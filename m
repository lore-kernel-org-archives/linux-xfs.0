Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4712EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175712075D
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sUs/s7zq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAXXYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:24:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgAXXYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:24:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8RYa4tWJ0hmXteJiscjflORIgOigPAMHYNYzxKBJudM=; b=sUs/s7zqf/pwAeL14SBrl3Fte
        /baexIql0musXn6xY/Rd/TlIuz98mm8fyujDcW1xwYG67PzvQvoUH6kTbutHFkeRISzh2do/qWZOm
        5xV5hXX+PgclY+zk1Vl9gHKHcjsVoGoxQ18CFv70LitzjS7iZHdu4nzzUjchW4aIMOmI4HbUAwQzr
        s2oEqJO3YYd2yV1+T3rNW7IU6qs7VyQYyL+NI94WXojZQTfOMtKOp46pQ9mUSOg1WjcowA4isvmIZ
        mhlaH2DYUcozRs4yf+zzszn2uS6MMVsABdKNUIpWy39yr7jD8/v3xBzBLSg8SotpYflJx4n9fcnBM
        Ny7vW7Qtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv8JB-00042P-Iy; Fri, 24 Jan 2020 23:24:13 +0000
Date:   Fri, 24 Jan 2020 15:24:13 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 27/29] xfs: clean up the attr flag confusion
Message-ID: <20200124232413.GB22102@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-28-hch@lst.de>
 <20200121194440.GC8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121194440.GC8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 11:44:40AM -0800, Darrick J. Wong wrote:
> Clean up?  This whole XATTR_/ATTR_/XFS_ATTR_/XFS_IOC_ATTR_ quadrality is
> /still/ confusing to me.

> >  	struct xfs_mount	*mp = dp->i_mount;
> >  	struct xfs_trans_res	tres;
> > -	int			rsvd = (args->flags & ATTR_ROOT) != 0;
> > +	int			rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
> 
> bool?

Ok.

> > @@ -87,7 +67,7 @@ struct xfs_attr_list_context {
> >  	int			dupcnt;		/* count dup hashvals seen */
> >  	int			bufsize;	/* total buffer size */
> >  	int			firstu;		/* first used byte in buffer */
> > -	int			flags;		/* from VOP call */
> > +	unsigned int		attr_namespace;
> 
> What flags go with this attr_namespace field?  XFS_ATTR_{ROOT,SECURE}?

Yes.. I'll add a comment.

> > +/*
> > + * Flags for the attr ioctl interface.
> > + * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
> > + */
> > +#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> > +#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> > +#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
> > +#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> 
> I think it's worth nothing that these flags are supposed to be passed in
> via am_flags in the attrmulti structure.

Done.

> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -194,7 +194,8 @@ typedef struct xfs_da_args {
> >  	uint8_t		filetype;	/* filetype of inode for directories */
> >  	void		*value;		/* set of bytes (maybe contain NULLs) */
> >  	int		valuelen;	/* length of value */
> > -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> > +	unsigned int	attr_namespace;
> > +	unsigned int	attr_flags;
> 
> Please add comments to both of these fields explaining which flags go
> with which field.

Ok.

> AFAICT, xfs_da_args.attr_namespace holds the two ondisk namespace flags?

Yes.

> Which are XFS_ATTR_{ROOT,SECURE}?

Yes.

> And ... I think the next patch makes
> it so that people can pass XFS_ATTR_INCOMPLETE for lookups, too?

Yes.  Internal lookups at least.

> 
> vs. xfs_da_args.attr_flags, which contains the XATTR_{CREATE,REPLACE}
> flags, which are the attr operation flags that we got from userspace?

Yes.

> And what goes in xfs_attr_list_context.attr_namespace?  Same values as
> xfs_da_args.attr_namespace?

Yes.

> > +static unsigned int
> > +xfs_attr_namespace(
> > +	u32			ioc_flags)
> > +{
> > +	unsigned int		namespace = 0;
> > +
> > +	if (ioc_flags & XFS_IOC_ATTR_ROOT)
> > +		namespace |= XFS_ATTR_ROOT;
> > +	if (ioc_flags & XFS_IOC_ATTR_SECURE)
> > +		namespace |= XFS_ATTR_SECURE;
> 
> Seeing as these are mutually exclusive options, I'm a little surprised
> there isn't more checking that both of these flags aren't set at the
> same time.
> 
> (Or I've been reading this series too long and missed that it does...)

XFS never rejected the combination.  It just won't find anything in that
case.  Let me see if I could throw in another patch to add more checks
there.
