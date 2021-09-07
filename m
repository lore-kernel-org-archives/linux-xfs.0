Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFB0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Sep 2021 07:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB07E60EB7
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Sep 2021 07:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhIGHZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231324AbhIGHZE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Sep 2021 03:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA4F6109D;
        Tue,  7 Sep 2021 07:23:56 +0000 (UTC)
Date:   Tue, 7 Sep 2021 08:23:54 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mm/kmemleak: allow __GFP_NOLOCKDEP passed to kmemleak's
 gfp
Message-ID: <YTcTinqat08VK+xP@arm.com>
References: <20210907055659.3182992-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907055659.3182992-1-naohiro.aota@wdc.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 07, 2021 at 02:56:59PM +0900, Naohiro Aota wrote:
> In a memory pressure situation, I'm seeing the lockdep WARNING below.
> Actually, this is similar to a known false positive which is already
> addressed by commit 6dcde60efd94 ("xfs: more lockdep whackamole with
> kmem_alloc*").
> 
> This warning still persists because it's not from kmalloc() itself but
> from an allocation for kmemleak object. While kmalloc() itself suppress
> the warning with __GFP_NOLOCKDEP, gfp_kmemleak_mask() is dropping the
> flag for the kmemleak's allocation.
> 
> Allow __GFP_NOLOCKDEP to be passed to kmemleak's allocation, so that the
> warning for it is also suppressed.
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   5.14.0-rc7-BTRFS-ZNS+ #37 Not tainted

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
