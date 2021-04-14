Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B20C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BA961139
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349194AbhDNGUf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbhDNGUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:20:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE859C061574;
        Tue, 13 Apr 2021 23:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f+fAbCZ4rDvX+NbTHtYJx7n0QM8e83b45pYQ1m7apMA=; b=P/c+dbCTBmRmPmr7c+03E/vxGb
        U9f68N/JYDKQHrwMmlqtOeFWmcfOTPzN4dUfILWFGjFvwruCtkzeRlIorN2DbOUgOqbuQ5Izwx+dk
        Gt1Y6iaNNNggDHtEYOmiAy8hyfk9njsEcapmL5zplwoSMs4Eiacs3UXGri0q4ic9PKUrwczMvBicd
        1wL99IuhB9jYM8ivm1RlIGWM7HeMzW/kGTVsuQzp6aJfVHc1NW6uE00Spypw0e0N0Wlvj3iD9wAmM
        18iTe6+wOshOpQjs0vBGaMN2MXCWKTWyvlbEMZ8TJKL9UBomZbvqCPqnyWt2pEI3PmPGfF0lbHM9t
        a8iW5gag==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYsg-006jh8-HO; Wed, 14 Apr 2021 06:20:07 +0000
Date:   Wed, 14 Apr 2021 07:20:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 7/9] generic/620: fix order of require_scratch calls
Message-ID: <20210414062006.GI1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836231396.2754991.1877515727730919792.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836231396.2754991.1877515727730919792.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:05:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> _require_scratch_16T_support does not itself check that the scratch
> device exists, which means that it depends on someone else to call
> _require_scratch.  Document this dependency and fix this test so that we
> can run:
> 
> ./check --exact-order generic/374 generic/620
> 
> on an ext4 filesystem without g/620 tripping over the mess left by g/374
> when it calls _notrun.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
