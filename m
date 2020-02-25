Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEB0C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 20:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A461320675
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 20:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C27S/EX7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgBYUqg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:46:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgBYUqg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 15:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o/1QFZxzNT826m7JFIAME3+yVzvEsCUL19H0/+ZaGD0=; b=C27S/EX74cPZD/Vexlr8p3tKtQ
        728obkNdVPjtjHZvyhB6xDUhJvo4kt/VU30ZNqgzPAqX5gF7l5kxxnqDLlGY+NKKC05zby3lHtz/b
        YH5brjngTWrhNfaC1aD0vv3E6EeO8OSHzNvkWhfGo+WiKgkEg/wm778jgIjOd8clQ1y1eEFZY3gzJ
        /AkM/+qjw29NQew9qQ0gELKGnqD2c78UNKJ5/SA5EapGxrdXG0eVurrZNnJdnIdcT3npCToYqVKNp
        OKqDar1kDgw95WD1AJBYj+ALBetyYNEmKK4gkVmd4y9v2yJiXHdV/XfvU2jwKotN1MUqM/3HWFkQT
        4uf8RPaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6h68-00036M-Ke; Tue, 25 Feb 2020 20:46:32 +0000
Date:   Tue, 25 Feb 2020 12:46:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Qian Cai <cai@lca.pw>, elver@google.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix data races in inode->i_*time
Message-ID: <20200225204632.GA6191@infradead.org>
References: <1582661385-30210-1-git-send-email-cai@lca.pw>
 <20200225202829.GV6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225202829.GV6740@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 12:28:29PM -0800, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 81f2f93caec0..2d5ca13ee9da 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -547,9 +547,9 @@
> >  	stat->uid = inode->i_uid;
> >  	stat->gid = inode->i_gid;
> >  	stat->ino = ip->i_ino;
> > -	stat->atime = inode->i_atime;
> > -	stat->mtime = inode->i_mtime;
> > -	stat->ctime = inode->i_ctime;
> > +	stat->atime = READ_ONCE(inode->i_atime);
> > +	stat->mtime = READ_ONCE(inode->i_mtime);
> > +	stat->ctime = READ_ONCE(inode->i_ctime);
> 
> Seeing as one is supposed to take ILOCK_SHARED before reading inode core
> information, why don't we do that here?  Is there some huge performance
> benefit to be realized from READ_ONCE vs. waiting for the lock that
> protects all the writes from each other?

Yes, I don't see how READ_ONCE works on a structure.

I think you should look into fixing this race in generic_fillattr
first, and we then piggy back on that fix in XFS once it has all been
sorted out.
