Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813FFC34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5012070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I8YuGW9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgBQNsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:48:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57314 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBQNsR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:48:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Cm8CZPGLIyYjkmalmUeHdX0solgEiC0PWW94wpRcus=; b=I8YuGW9XkCJGXz4IgqAJnNJWoj
        bOgMRqZd8uR2lAb8Ay8OnyFaVTegyZMt7CCla/6NnTi7U+Qrbv95nuQ797Ce/bX13NYdOUMjWpVVv
        efKeGK6wwE9YDYEq5JyuU713F8WoeHymm1lOyR6Yb7MSwME37XcUeSJAiw9TBNs5oLD7hFONd2AF+
        j3B3f6R/zInKSc+2Sfpxz84U64BZw6EqigBckUDGCJ7IK1635dUswsqmyagkSBV+x/7JEwfuUqwHj
        4N5Henyov9oPFzaCbT75Am5bJe9klj4JH8OtDW88gUujk3FQ7V7kpiFSY86JBHZSCVCwwEou1S7Li
        lk7dZ3Ew==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gky-00086n-Ew; Mon, 17 Feb 2020 13:48:16 +0000
Date:   Mon, 17 Feb 2020 14:48:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/30] xfs: pass an initialized xfs_da_args structure to
 xfs_attr_set
Message-ID: <20200217134814.GA336731@infradead.org>
References: <20200129170310.51370-1-hch@lst.de>
 <20200129170310.51370-12-hch@lst.de>
 <3555829.Ga2YY0DfQR@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3555829.Ga2YY0DfQR@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 07, 2020 at 03:12:06PM +0530, Chandan Rajendra wrote:
> >  		struct inode *inode, const char *name, const void *value,
> >  		size_t size, int flags)
> >  {
> > -	int			xflags = handler->flags;
> > -	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_da_args	args = {
> > +		.dp		= XFS_I(inode),
> > +		.flags		= handler->flags,
> > +		.name		= name,
> > +		.namelen	= strlen(name),
> > +		.value		= (unsigned char *)value,
> 
> Since xfs_da_args.value is of type "void *', Wouldn't it be more uniform if
> 'value' is typecasted with (void *)? 

Yes, fixed.
