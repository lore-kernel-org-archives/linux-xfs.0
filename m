Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCACC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB45E613CE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhEUIHj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 04:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhEUIHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 04:07:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAB1C061574;
        Fri, 21 May 2021 01:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gk/Bs1z2pdszkkVDZePpa9pa7MM+7lGGz3dJCL0qtXs=; b=M6ridaPathCkZKWdFCdJaoavV1
        pL/EErgn2M5SPD2XKgIxgJHY+b4O6AqFLeVaK6Ws+au8Lii0lK7q2aBljFfhgYuIhTCl6AvV/xVK7
        8LyPPBrBR5G2/Wsp7PJ52HL6Hxtgz4CnDztxIw0IpH3Hai4Y0DyM0rbYJc3RVBN2oY5qegEhLRwpt
        ro2XHP2k3ZsGAS3HkYqPUhE+JXtG3h82xzUUMaJ/ezbRNP/GebnU9BQyxpa7MkIh/YNo+AyFtfB/U
        pQjxNcsSYJ7cQqTlICHCcOV7Ta2Yrf9rmIypjspWMbz1L3vvhh2euzgAqAlUR7U25KSzZiG5jmT9g
        xQ4mTVVA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lk08v-00Gli5-Hv; Fri, 21 May 2021 08:04:56 +0000
Date:   Fri, 21 May 2021 09:04:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/6] xfs/178: fix mkfs success test
Message-ID: <YKdpieAgYrUspm+X@infradead.org>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
 <162146863062.2500122.10306270841818355198.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162146863062.2500122.10306270841818355198.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 04:57:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the obviously incorrect code here that wants to fail the test if
> mkfs doesn't succeed.  The return value ("$?") is always the status of
> the /last/ command in the pipe.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
