Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0949C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 08:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4072208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 08:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rCvhqBDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbgDBItb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 04:49:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgDBItb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 04:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VuGoSIc2KI8ow1jp9y215K8Eg8NTKqBkJHMVONR52iA=; b=rCvhqBDmhoDe528jgTYUROmKf5
        Nab2ylSZr54n0yUy+QMFZuT+Po7HxSJX1H1vrb9wvCHXX2Ar/bjTkjkWkV6sbGSL4cIlCbvZPSAOv
        zukBg03N1ooeJxwse8zEv68HsXhLoB+8W6d02TpNj2G9BgH1i0LBeF4+D/j8EeDF29ymgMPausG/O
        kTjcg1IRTpxuA6JBRH+Ge9Wg6+TpCX4TL896rI79LcOgRy3vkIPVi0sMQgCoej8SDZF87kiLIYq2S
        292c08T32FhJgvtoKgAsI4sYw1kPlwBRP3dv5IdiJdOsUEhyImYzpJyKGvvpkpzbVUp0rEG5NDUqq
        kQ6t9fgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJvXW-00078K-R1; Thu, 02 Apr 2020 08:49:30 +0000
Date:   Thu, 2 Apr 2020 01:49:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402084930.GA26523@infradead.org>
References: <20200402041705.GD80283@magnolia>
 <20200402075108.GB17191@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402075108.GB17191@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 12:51:08AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 01, 2020 at 09:17:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Reflink should force the log out to disk if the filesystem was mounted
> > with wsync, the same as most other operations in xfs.
> 
> Looks reasonable.  That being said I really hate the way we handle
> this - I've been wanting to rework the wsync/dirsync code to just mark
> as transaction as dirsync or wsync and then let xfs_trans_commit handle
> checking if the file system is mounted with the option to clean this
> mess up.  Let me see if I could resurrect that quickly.

Resurrected and under testing now.  While forward porting your patch
I noticed it could be much simpler even without the refactor by just
using xfs_trans_set_sync.  The downside of that is that the log force
is under the inode locks, but so are the log forces for all other wysnc
induced log forces.  So I think you should just submit this in the
simplified version matching the rest of the wsync users as a fix. If
we want to optimize it later on that should be done as a separate patch
and for all wsync/dirsync users.
