Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C51C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA4661139
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349209AbhDNGWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbhDNGWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:22:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24970C061574;
        Tue, 13 Apr 2021 23:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eL1Y1CbwdYoXBkb/aMl89KmkTWLhCRb/Xknf9aiZhBU=; b=j6DQKWa0xPEDp08vYJWrabMqmo
        24lhVbKRQUwAmt6vXftFjz83LQxrLNwi7Qps2mAW6Dt4bFfM9N7oJEc0syJtMjICXI/GqtDMPEE4I
        kjXIoAWArWavIM95tVc+ge0hX77TWITjUzlpEghMB89v4F6WwKLL+psnSyPjrSbU4sMHj6qyfLzGV
        29krIQI32+TKP49bvy11dLNLZSMkdd2NRYNg0BTsvdi5EpbxviIG+HXR7eK+VU7QgZQB3PLmtczKS
        IQn994Wtm7H1hK6CBMdo32B7jXURX+dIuA3JkqDT0Dfyiyk/nI3JmUDUO/LjGihXQT7YSscCNBzl+
        ti+K4IEw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYu7-006jlz-ID; Wed, 14 Apr 2021 06:21:38 +0000
Date:   Wed, 14 Apr 2021 07:21:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 9/9] xfs/305: make sure that fsstress is still running
 when we quotaoff
Message-ID: <20210414062135.GK1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836232608.2754991.16417283237743979525.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836232608.2754991.16417283237743979525.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:05:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Greatly increase the number of fs ops that fsstress is supposed to run
> in in this test so that we can ensure that it's still running when the
> quotaoff gets run.  1000 might have been sufficient in 2013, but it
> isn't now.

How long does this now run?
