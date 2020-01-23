Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FE7C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F094321835
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="adNswL9C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWWe5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:34:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWWe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:34:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JYuhWZ8vlgZ5QvDa3e3oQ9gphZ5lsEiqMWVQ44QmhTo=; b=adNswL9CL2fkc6pqlO4d6//ZF
        sWtYaDmmZKq+fvEkpVG9ioRro//ONbNbfBH88YoFlSj+yGHIrvOe2LVxu8Es2JFnlRlRrovduCdUd
        Wa8hhfQ/gaua9xZ25LixkrKFCoYhUi3fzlpv1ULIpCZUh1oXSw6ZES/NQxkcV31WS13dFgh9LAV1h
        0/md6IeeeZPWcyEOlEg1xoYu/C7idyHcodeYEfK+mtMVwdi1DLFz/aB2xI6i8bxzyr6j9ucP3c8Ys
        Wp+aWC2LoRBQb1btq9WOsIwshdRJcnJ6jyPgv954yxPZZ+bS/5ROIk9PFstRRqI+1Hxcr6ajWZ1pZ
        5c52sXQEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iul3v-000287-1b; Thu, 23 Jan 2020 22:34:55 +0000
Date:   Thu, 23 Jan 2020 14:34:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/29] xfs: factor out a helper for a single
 XFS_IOC_ATTRMULTI_BY_HANDLE op
Message-ID: <20200123223455.GB2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-6-hch@lst.de>
 <20200121175453.GF8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121175453.GF8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 09:54:53AM -0800, Darrick J. Wong wrote:
> >  
> > +int
> > +xfs_ioc_attrmulti_one(
> > +	struct file		*parfilp,
> > +	struct inode		*inode,
> > +	uint32_t		opcode,
> > +	void __user		*uname,
> > +	void __user		*value,
> > +	uint32_t		*len,
> > +	uint32_t		flags)
> 
> That's a lot of arguments.  Any chance you could change the ioctl32
> handler to convert the compat_xfs_attr_multiop to a xfs_attr_multiop and
> pass that into this function?

We could, but it would be painful.  The interface also isn't really
that different from the normal xattr one, so I don't find it too bad.
