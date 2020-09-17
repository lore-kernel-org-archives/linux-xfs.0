Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D816AC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D03021D43
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:53:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EZudd8iI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgIQHxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIQHw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:52:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7530DC061756;
        Thu, 17 Sep 2020 00:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=el6jY8jpJi53h31dvW+aJk6Wq2UoObpRndf4PWw6yz4=; b=EZudd8iIkr2JLclhl8ifq+cSsT
        zL+dGQ7XSPMPXw6RgYC6CsXKt0SdLR7u/B9IF6rlgPSCorv34qpBWPdIkIhO8wPzJN6xgxeh/iB2s
        zQrup/4FYowlQvSXlX61Fve3Bdwd1uCbXzdRNy0kHuZEEjx4BYuLUSjg8APZ1pSlfAmkFSJA3hv4a
        Zmpi14YMKAJ+4xMlKOXr0EcIDTb3Vo1idJAQ7S3AkRNhKt5b9D8stAXGAIPeoVAFEAinzHZGzLl5Q
        fbxQkH9bY7G3ICM7C+hKrQ8FEMXGyVtipqvsMFSAcB3r7Yuw9TZN3d4Cy2uW7yr7zpOcRu6N+vU+J
        sgRUMwEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoij-00075Q-Mj; Thu, 17 Sep 2020 07:52:45 +0000
Date:   Thu, 17 Sep 2020 08:52:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Xiao Yang <yangx.jy@cn.fujitsu.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
Message-ID: <20200917075245.GC26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013419510.2923511.4577521065964693699.stgit@magnolia>
 <5F62BEAD.3090602@cn.fujitsu.com>
 <20200917032730.GQ7955@magnolia>
 <5F62DB4E.9040506@cn.fujitsu.com>
 <20200917035620.GR7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917035620.GR7955@magnolia>
L:      linux-unionfs@vger.kernel.org
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:56:20PM -0700, Darrick J. Wong wrote:
> Oops, sorry, I was reading the wrong VM report.  It's overlayfs (atop
> xfs though I don't think that matters) that doesn't support FSGETXATTR
> on directories.

I think we should overlayfs to support FSGETXATTR on all files that
can be opened instead.
