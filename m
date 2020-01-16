Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988B1C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62CAE2075B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pv0jJnWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgAPJZg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 04:25:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAPJZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UqOcPUSXJ7lwNXiesuUVJjA2O+I6z8lyJiCSpRxSNFw=; b=pv0jJnWMeLYDJWYCJ/Pq9yeaT
        P+Wj0aqJl3kA1ZgepXdKQXAx6zLSTFh9+y6y4EViWmPyINhX96veaq0D5pZOtzwPhdqPA3xVgRmlJ
        bTU0zI6tvXwCMGU1b4RuX4RGGY49OpFIVozExp65wVsaO8+FxAHQA9kYy7BAtQOSdLQ2YKRZNvvI7
        aL/+vr9BNm0csTq5/7sFFLgAag/pYT9iYcQ5a80oNK6DYe7pSFl8tui4R9O/ppi0RKMzvcQPTcg3v
        MtnOsFST2wnIWbIXnP0V7gpyyJyM9plL1d7ie2qMCNOX+0gYfOk7WM+JZRyvaKqakoO6WLMTYEoAn
        VplFmxDCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1PD-0007R5-Vp; Thu, 16 Jan 2020 09:25:35 +0000
Date:   Thu, 16 Jan 2020 01:25:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 6/7] generic/108: skip test if we can't initialize
 scsi_debug
Message-ID: <20200116092535.GF21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915147326.2374854.964133120890777930.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915147326.2374854.964133120890777930.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Correct the logic in this test that detects failed scsi_debug
> initializations.  Downgrade the reaction to _notrun since the filesystem
> under test did not fail, just our mockup disk.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
