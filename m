Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB7BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82FE72072C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XKcJFMlq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgAXXNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:13:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgAXXNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=leUclP0hPBqaJ07Jx66dVYFKjcGdNOwi3u+WznYU5fI=; b=XKcJFMlqgQID0km8OpP1CtOrD
        4xVMHMyT0T6hIvGcKgBj8vOoxTPTxBUWJn6Q2RqBvub08jipscFqqyJN14g76gxkPMacl+U5/Ivy+
        5fA5BdCv0HyPnmqyzgWKgCGT/5+XmAzR0V8hRwm9XLNP391S6ru8UZYJ16qGNbZVilwLQjYMcjoaq
        cFa7CX1Du+4jWwpWRtVr3mbjBc8JxGp5GqHT7P0j2Q95dUB89sh82zdth4WIsGJIa+QSRQzjOxvaw
        FP3T+6iGB3q77p2ibjmX3hN5E5Tzuncj/MKRq7nBS7VmQ2NBB2vsKpS2pzSeg4eaZM5GrMNli1GBz
        Vt4O6gGmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv891-0005nC-Fg; Fri, 24 Jan 2020 23:13:43 +0000
Date:   Fri, 24 Jan 2020 15:13:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 20/29] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Message-ID: <20200124231343.GA22102@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-21-hch@lst.de>
 <20200121184140.GT8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121184140.GT8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 10:41:40AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 14, 2020 at 09:10:42AM +0100, Christoph Hellwig wrote:
> > The old xfs_attr_list code is only used by the attrlist by handle
> > ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
> > attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
> > user ABIs.
> 
> They weren't there already? Gross....
> 
> > They are used through libattr headers with the same name
> > by at least xfsdump.  Also document this relation so that it doesn't
> > require a research project to figure out.
> 
> Shouldn't these two structures get a check in xfs_ondisk.h to make sure
> that we don't accidentally break the structure size?

These aren't on-disk but syscall ABI structures, and they actually
differ in size on different architectures..
