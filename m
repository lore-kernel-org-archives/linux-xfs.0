Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A68C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4459E22464
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s0pDFslj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgIQQDU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbgIQQCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:02:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4623EC0612F2;
        Thu, 17 Sep 2020 09:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ERIQwtkPVGiQ163kFxwIpbYx/7lumvK0N4TJxlxzWBY=; b=s0pDFsljDMLOzJxcResh1Q3Ywc
        mb08dCv0cvLlBlU90+l+Can7xBVrrDxzd1yMjO7W4LdirB1UQOZyTGTneyH6f3TvKRpSVwdGh7HX9
        jyEpc1WKCkyvQOTlT3yv+I4h2FCqzxAELh0xD2IvlEXKmlSSiOfGc8NAJkRnb4JcQ/4368GlGsTBd
        dEvrjuplQ6O+O78XRpH2Y+JMfElMEUrD3hwJA+roKTrtSB/4dVN+kXTbpVkoIXKpNhFGPedi4fLUz
        /imywwl0+oqFOpQmfysSl8d6rSVaOs0MDFa+m77vLQmZMrJfLX5zy6mfQb+AOCXLKDZsy1SxPjbPp
        3dV/e3BQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIwMI-0004gZ-U9; Thu, 17 Sep 2020 16:02:06 +0000
Date:   Thu, 17 Sep 2020 17:02:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
Message-ID: <20200917160206.GB17092@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013419510.2923511.4577521065964693699.stgit@magnolia>
 <5F62BEAD.3090602@cn.fujitsu.com>
 <20200917032730.GQ7955@magnolia>
 <5F62DB4E.9040506@cn.fujitsu.com>
 <20200917035620.GR7955@magnolia>
 <20200917075245.GC26262@infradead.org>
 <20200917155439.GY7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917155439.GY7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 08:54:39AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 17, 2020 at 08:52:45AM +0100, Christoph Hellwig wrote:
> > On Wed, Sep 16, 2020 at 08:56:20PM -0700, Darrick J. Wong wrote:
> > > Oops, sorry, I was reading the wrong VM report.  It's overlayfs (atop
> > > xfs though I don't think that matters) that doesn't support FSGETXATTR
> > > on directories.
> > 
> > I think we should overlayfs to support FSGETXATTR on all files that
> > can be opened instead.
> 
> Heh, yes, that would be a better option. :)
> 
> Even if they do add it, though, I still think we need to be able to
> _notrun this test to avoid failures on unpatched kernels?

I think supporting FSGETXATTR only on regular files is a bug and should
fail.

> This also makes me wonder, we lose all the FSGETXATTR state on copy-up,
> don't we?  Since the VFS doesn't have a primitive for cloning all the
> metadata?

Good question.
