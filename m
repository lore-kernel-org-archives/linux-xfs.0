Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F650C5DF9E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC9124786
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:54:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dlnbe8/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgJ1Vw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:52:27 -0400
Received: from casper.infradead.org ([90.155.50.34]:44310 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgJ1Vw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gEAH2ANjR36PbIT6F/Cjwp9vQMe7/HxDWM/iH0oiPNM=; b=Dlnbe8/csSGfRRPPsw0LbfU18R
        NUbIhr3rNtq0BYFnudkznZbqiU9HOFtk7BJ89hAjZdnlO8GLx3uTQFcN1iCKvEeHTA49TmBCwB6Sn
        p4rj9WDavchYccb0EbusKjvH9IF+0Fxvm9diub/v7kHlgDWWtzWbavtGbvNgqM2klYHCJOK6Nn2RJ
        O9XxAUUetxA5fRM2xrkQxm9LciiH53059McY/H9XWJDYdIhOaERw1jJilCetkzbk3ZHv6b3wo3W0h
        E14RaCUsnhuDkPxskY7Ix45JgRAFqghYO5/cPQ1fn/d66kycqKiwB9WdPnSzQF9+EKVZpfLq673WD
        5RQ75roQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg8U-0000ua-Ed; Wed, 28 Oct 2020 07:44:46 +0000
Date:   Wed, 28 Oct 2020 07:44:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 9/9] common/populate: make sure _scratch_xfs_populate
 puts its files on the data device
Message-ID: <20201028074446.GI2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382534741.1202316.10109027018039105023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382534741.1202316.10109027018039105023.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that _scratch_xfs_populate always installs its files on the
> data device even if the test config selects rt by default.

Can you explain why this is important (preferably also in a comment in
the source)?
