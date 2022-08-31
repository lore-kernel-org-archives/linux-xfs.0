Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4D0ECAAD4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 09:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiHaJwG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 05:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiHaJwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Aug 2022 05:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA0F9FA93
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 02:52:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D7B6B81FAC
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 09:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FD5C433D6;
        Wed, 31 Aug 2022 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661939520;
        bh=AIepTHbPN5FUnPpJGGn3FVQwF902BINLW+SWEAESu1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hLZnlRcRozM2avzQIohpxY9mMydB3lVKwwi/aQ9dl6ep4a1Tnjvy29PUUKSTq2K4V
         sZeuCFIjdTVJAfu48L7TkLInuw9rBtYHa5K5nHCyMTWWBP+amb6sCIqIZfUOH7u2/p
         zxJkEUGrPYQFI+dvj55YpoghhdqtY7ENl4oYwSKhyrdltCYt6qvZOiLdZMZkXApHKo
         hHfFG1uJkfDwWpasU1ykoFinOz64jEGyfUJ+igLTHUJwaF8pPR4ByETR87ibwXm/VZ
         jcSN9uC9UL96r2uMZSp70ZNkmV1hcIgLAKKFTSVDIBcrMejYG/qYnSPrWNBoAhbAZl
         lDsAkOJiGf32A==
Date:   Wed, 31 Aug 2022 11:51:56 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Jakub Bogusz <qboosh@pld-linux.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Polish translation update for xfsprogs 5.19.0
Message-ID: <20220831095156.nvwk4ypkoimqgwrv@andromeda>
References: <V-1rFt33HfX-PEKxCk2p6in23I_qJ6ELj6MmYMtgqjl6jHFh1hNVR4i5E1SF-RCY63GvFrKJzzv3leO8g-mpRA==@protonmail.internalid>
 <20220822160022.GA10067@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822160022.GA10067@stranger.qboosh.pl>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 22, 2022 at 06:00:22PM +0200, Jakub Bogusz wrote:
> Hello,
> 
> I prepared an update of Polish translation of xfsprogs 5.19.0.
> As previously, because of size (whole file is ~574kB, diff is ~750kB),
> I'm sending just diff header to the list and whole file is available
> to download at:
> http://qboosh.pl/pl.po/xfsprogs-5.19.0.pl.po
> (sha256: e5f73247e6c029902ef7c341170e5855599c364c50e3f98cc525a54ab17686e0)
> 
> Whole diff is available at:
> http://qboosh.pl/pl.po/xfsprogs-5.19.0-pl.po-update.patch
> (sha256: b9aa4a60c7c0984880ffbac82e836c5a202b01d481cb9a0f0398eeee6ffac637)
> 
> Please update.
> 
> 
> Diff header is:
> 
> Polish translation update for xfsprogs 5.19.0.
> 
> Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

Just for completion...

The patch looks fine to be applied (although I don't understand polish).

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos Maiolino
