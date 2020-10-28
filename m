Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5233EC55179
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F304B24724
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VozUVnB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgJ1VwD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:52:03 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbgJ1VwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6BRl/yiz4IDbFiZyHrMawAP/X7UidoypffzQVa4xOX0=; b=VozUVnB30MVi/lKCELAeAiPvND
        HdXDGvNRCdb4KL0AI2+FvYGVj3Qe3xis4sGoyo1K30SSTk+pAgI8BorZO6VmJIrPNxsjhGi1ZNZ0F
        yv/Q4ZTt+CrD9P9raAAN+giCfKPorFtuEVdt4UDldyoRqNsimoCDGK+Cutc9YqkkZ8p8LCo16+f+F
        uhUch9f+OydU91iW7M0UIVhusQboq1RobIyXOsS8ZgV4DFvMNbHcUnwW1S6NeJLE+TW4sGXQwoMHb
        f5ieEB+ppxOak9PsSbij/h1UakTMyDUsdBSM5144aQD+dQVlO8TKTUnrojreBNs5lH82qA23WtrN+
        0puJ8Bew==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg5N-0000mw-Sl; Wed, 28 Oct 2020 07:41:33 +0000
Date:   Wed, 28 Oct 2020 07:41:33 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs/520: disable external devices
Message-ID: <20201028074133.GB2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382530205.1202316.9303713563959751852.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382530205.1202316.9303713563959751852.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:01:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a regression test for a specific bug that requires a specific
> configuration of the data device.  Realtime volumes and external logs
> don't affect the efficacy of the test, but the test can fail mkfs if the
> realtime device is very large.
> 
> Therefore, unset USE_EXTERNAL so that we always run this regression
> test, even if the tester enabled realtime.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
