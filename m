Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA919C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74719204EC
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fyvJK/p8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbgIAQL4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731444AbgIAQLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 12:11:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F1C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 09:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zl4sknKKZt3wwGHqV5Lma3jSTlem7NsxX0WGBcF/vag=; b=fyvJK/p87dnNP/yvK1qcdQsmhq
        eB1fsMCw8W/dUhcwRig1cqu1disOmD2u2PKCZPKGtuTcCzSxdIT+uvv2Um8UI1IkbNeMCuuTCF0qU
        PcFuPJy6Xw5pLp3OWo7bVX7CPZxfAtwfz1J9OyYcq/SFg0ic9lFXJWM42jJZJzlU8a8UfqObgMbBL
        rGNn0jjCDOtEkzH98RHHrmsP/OyWsOVioR8+F6lqBi3kfSufbleS1ujMZQzMZxmfAcAQaB1OCcV6c
        U9t8BoU4ArNiDNSdBb2sINtMAX55MDe/T/iNDl3mdT8YF5TVsTVBgz+L/wrweK4WpYfuk9JrZ5QKi
        6+qmBvLw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8su-0005y0-Dv; Tue, 01 Sep 2020 16:11:48 +0000
Date:   Tue, 1 Sep 2020 17:11:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add inline helper to convert from data fork to
 xfs_attr_shortform
Message-ID: <20200901161148.GA22553@infradead.org>
References: <20200901095919.238598-1-cmaiolino@redhat.com>
 <20200901141341.GB174813@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901141341.GB174813@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 10:13:41AM -0400, Brian Foster wrote:
> FWIW, I thought we tried to avoid including headers from other headers
> like this. I'm also wondering if it's an issue that we'd be including a
> a header that is external to libxfs from a libxfs header. Perhaps this
> could be simplified by passing the xfs_ifork pointer to the new helper
> rather than the xfs_inode and/or moving the helper to
> libxfs/xfs_inode_fork.h and putting a forward declaration of
> xfs_attr_shortform in there..?

Or just turn it into a macro, which might be easiet?

> > +static inline struct xfs_attr_shortform *
> > +xfs_attr_ifork_to_sf(struct xfs_inode *ino) {
> > +	return (struct xfs_attr_shortform *)ino->i_afp->if_u1.if_data;
> > +}

I also find the name a little strange as it takes the inode

maybe xfs_inode_to_attr_sf ?
