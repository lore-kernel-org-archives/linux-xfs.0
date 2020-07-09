Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9FFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324AC20772
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uEWsYZRC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgGINk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 09:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgGINk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 09:40:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F09FC08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 06:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bN5Il5Id3XTdQrCF/P9brtYqf08kVL0me90qyH/YUw0=; b=uEWsYZRCchTJ8UEphTZb703mpj
        6nJtnUWeQJmsm0L2hRmoagvaMT4j0dDdQ7mSti7YdqHGRnABGEq3Ppe/LKUvmDC686n12yc/cv+uJ
        38yCHSBzOBz4GHYOs/exBwfYEC07SmbfCdl6hwQCnmzHiiYD6Jg7RfQKtOZkt7YFtd7jl+816YyR3
        UgWDIqMbD8huOzttAB/mSPeW/ldBPzbwH4HJw6jQzQ453ziVKgl0fQA4uNaggW5eYzf4HhmLMcJA2
        TyNeN37eFHfvwu8f8GM+OzfpczHqVtyUOZL3qgOHcmsYEGovcKAVyo/bt3aNhgzNKg/E72+jNS9e4
        UV6pvaPw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWmp-0001BH-41; Thu, 09 Jul 2020 13:40:27 +0000
Date:   Thu, 9 Jul 2020 14:40:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/22] xfs: validate ondisk/incore dquot flags
Message-ID: <20200709134027.GC3860@infradead.org>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
 <159398717379.425236.1842038690682253468.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159398717379.425236.1842038690682253468.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 05, 2020 at 03:12:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While loading dquot records off disk, make sure that the quota type
> flags are the same between the incore dquot and the ondisk dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
