Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CEFC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2814921D90
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o8zZikyH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgIQHyz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgIQHyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:54:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FACEC061756;
        Thu, 17 Sep 2020 00:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tj3hNMWxUwsfwSKhw7FrgT0GcQho8NzJXZIVD/ak+vc=; b=o8zZikyHEwOL1mvypjR07+W+mo
        bsbU+QRT5CxY0uqlXul6Yg5Vm7MFxUKJmexkkn9FAcxAM1wsbg5SQ4CKoUEXiTKBf6Wuv1xRtDF41
        9y+3hl3bZp9+CdusV+lbfqpfBWeuf4NV0/PUv5d0rYqFRWAKRbpq1MFTX+1/kwXwfLX3LBscntwo2
        QZpSHmtCuDQ5H15sKPdFTWGm8mWXsIIZYrI/BBZcbo2jBC5QHdmQ+24A54w209oz9CLWX+QWrfGNk
        26O/ms2xW5cgkwcSDDX/mIdNlfOYi4Q4RmUF0Wt2tPaghG7avvXwDZGbSZgrdTST4FWxMcAxIoP2h
        wGtBBBlQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIojn-00079P-9F; Thu, 17 Sep 2020 07:53:51 +0000
Date:   Thu, 17 Sep 2020 08:53:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 05/24] xfs/031: make sure we don't set rtinherit=1 on mkfs
Message-ID: <20200917075351.GE26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013420779.2923511.9462939883966946313.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013420779.2923511.9462939883966946313.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs.xfs does not support setting rtinherit on the root directory /and/
> pre-populating the filesystem with protofiles, so don't run this test if
> rtinherit is in the mkfs options.

That is a bit of a weird limitation.  Any reason we can't fix this in
mkfs instead?
