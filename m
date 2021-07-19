Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC82AC12002
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 09:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39D1611EF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 09:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhGSI1m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:27:42 -0400
Received: from casper.infradead.org ([90.155.50.34]:45340 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbhGSI1l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 04:27:41 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 04:26:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QYefk0EIRtQClCJohzzeU0cyNgdqIPkL2m9McJxKjdk=; b=DIgP8EBegSX1CZlm4ESRHIoEm9
        G1B1SaRCc7EtudC1Ogn69nVqqv9i1UtHr/PpD0EjqviFKkATTMgn1hBwHavVli99d2PzzN9bZEbxz
        WRlriu17UJXIvRe3vruoTVPUmdB8L8jaO4U+aTJprSnnNx9gsI6XqTNz30ui7GT/vHulCQNZSgHqn
        4p0oOOt58LE+hAS4h1dhk/T0Je69OndCX5i6gjB30TBWtznBSILSws38s/EAly8S/Q1CKI1HFrAXn
        tZy6+C+NwYhNYSMcp+UVYEBFG68fHbbLU/oBCZaLRC5ka8up50RqtVztBKdG6ihcgxFOMOl4YTh5l
        z5oAebGA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5Opr-006fB4-7B; Mon, 19 Jul 2021 08:41:23 +0000
Date:   Mon, 19 Jul 2021 09:41:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        Changheun Lee <nanich.lee@samsung.com>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>
Subject: Re: [PATCH 2/9] f2fs: remove allow_outplace_dio()
Message-ID: <YPU6pz2WoYAW3iDJ@infradead.org>
References: <20210716143919.44373-1-ebiggers@kernel.org>
 <20210716143919.44373-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716143919.44373-3-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 16, 2021 at 09:39:12AM -0500, Eric Biggers wrote:
> +	do_opu = (rw == WRITE && f2fs_lfs_mode(sbi));

Nit: no need for the braces.
