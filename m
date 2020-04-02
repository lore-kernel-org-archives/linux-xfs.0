Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DE3C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 14:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 256702074D
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 14:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4XkNfji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388750AbgDBO4s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 10:56:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388239AbgDBO4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 10:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d1irmk9/oUpVLIFVXh+K262CLxFTDXqQuS3uixURb1w=; b=b4XkNfjiURhEqWZK3GELqIah54
        XhtObyhSPCKuV4jrBO1lKRNY6OzRsC7KUc0i8Q4U10gU/vrxj4Gmfm4TqIP41/iD1kADqIQdcvcyo
        VODhdJCTKLnXZ/J/f7aALbUwd7UFPtbx9bUpk6eXfI/4pBvHFtwq1HlQdSqzDVBNq3AXAHSKyVJbn
        PTOYpLXRTH0pBMMOiZi3yJuM83T536w412UX2wl/GLKzOvqLEmFzRpWRwOKatd8GaKtEeTrTVVrK5
        ZY4R9iQdzAIwp3pyr4Z03F0cIkpqc/f94mZkUxyynti0qQ4UtExzVVket12e/obDRnDby8Ot5QRDd
        UGSGjZZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jK1Gy-0000Hd-7r; Thu, 02 Apr 2020 14:56:48 +0000
Date:   Thu, 2 Apr 2020 07:56:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402145648.GA23488@infradead.org>
References: <20200402041705.GD80283@magnolia>
 <20200402075108.GB17191@infradead.org>
 <20200402084930.GA26523@infradead.org>
 <20200402145344.GE80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402145344.GE80283@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 07:53:44AM -0700, Darrick J. Wong wrote:
> > > Looks reasonable.  That being said I really hate the way we handle
> > > this - I've been wanting to rework the wsync/dirsync code to just mark
> > > as transaction as dirsync or wsync and then let xfs_trans_commit handle
> > > checking if the file system is mounted with the option to clean this
> > > mess up.  Let me see if I could resurrect that quickly.
> > 
> > Resurrected and under testing now.  While forward porting your patch
> > I noticed it could be much simpler even without the refactor by just
> > using xfs_trans_set_sync.  The downside of that is that the log force
> > is under the inode locks, but so are the log forces for all other wysnc
> > induced log forces.  So I think you should just submit this in the
> > simplified version matching the rest of the wsync users as a fix. If
> > we want to optimize it later on that should be done as a separate patch
> > and for all wsync/dirsync users.
> 
> Can you please send in a Reviewed-by so I can get this moving? :)

In case the above wasn't clear: I don't think this is the right way
to go.  Just to fix the reflink vs wsync bug I think we want a
one-liner like this:

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b0ce04ffd3cd..e2cc7b84ca6c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -948,6 +948,7 @@ xfs_reflink_update_dest(
 
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 
+	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_error;
