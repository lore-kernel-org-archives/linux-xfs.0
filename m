Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B635C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E681E2223E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vKruFlYS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIWHBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgIWHBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:01:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6CCC061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1N9jhgIIlm8K6Fenjm6SJfA/Y81oDJykxGzq9e6zkMw=; b=vKruFlYSxtsKh0RuE9OHCFqmcH
        FpXvd1WGvXdz/rKs1V4VzaEMXDesWMPQUqMo95DAk7YQ64KMCmTp5nhDRHSbRbKdrM2ahNzX0viSi
        uN7TyteikclU2hbUwNPdaFgPS33+kWKP9FwMXUl5mML1djZ28EQfTeCVugH94f1Ro6Mm1UQTJGCUs
        W4wYlS2+1XGdKq7xPu4Vvz7zSguOIRwobv7YMDp57TNUXgZkebmcsxiIH4t8SqzF7GPThP8sWVVCY
        Azp5YcI5grMPmeQWEEoDJB6lXm2SsmIGPEv8IGilMpY0xNvaumLtZCdsZW7obmKq2xLz5njWbnx3s
        TSFUb2Yg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKymX-0007Ct-Jy; Wed, 23 Sep 2020 07:01:37 +0000
Date:   Wed, 23 Sep 2020 08:01:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 1/3] xfs: directly return if the delta equal to zero
Message-ID: <20200923070137.GA25798@infradead.org>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
 <20200922174347.GG2175303@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922174347.GG2175303@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 01:43:47PM -0400, Brian Foster wrote:
> This does slightly change behavior in that this function currently
> unconditionally results in logging the associated dquot in the
> transaction. I'm not sure anything really depends on that with a delta
> == 0, but it might be worth documenting in the commit log.
> 
> Also, it does seem a little odd to bail out after we've potentially
> allocated ->t_dqinfo as well as assigned the current dquot a slot in the
> transaction. I think that means the effect of this change is lost if
> another dquot happens to be modified (with delta != 0) in the same
> transaction (which might also be an odd thing to do).

Yes, it seems like we should probably bail out at the very beginning for
delta == 0, and document what kind of changes this theoretically causes,
and why they don't matter.

Btw, the function could really use a reindent, the formatting is very
strange.
