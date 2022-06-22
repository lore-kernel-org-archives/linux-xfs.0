Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAE3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 23:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377475AbiFVX2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377329AbiFVX2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:28:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0763EAAB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23C57B8204E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0322C34114;
        Wed, 22 Jun 2022 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655940512;
        bh=du4VLU6GTI3drOWM6tG1zO2GATvPU8WtIDyh01sjN7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8bQOCTiSvbGCG+xNP8cDmkPBPcR22y+xYe2d038LtRODbkxww9K55gHxbLCHhYOq
         RXtmrapjSV5wnI025valX16ZtWnH91Y0W3l/RBI5TBL6lEWAwaFvdjPcSwrLFR/KcV
         MPnXZ2r8CKtXmkpZ18JXf0X9xMchRJhNrpZJnWluDsR+R2dZPbdwihB2lzcNlwcoSY
         UAlXvwFYRPkOGc6Y0qG8dRbkEX+ZGq/4mJNZN9WIFEqOy7yEHOek7640FNd15zBjC2
         LGUC5ltqhaHpgh/xOBBEcezfhJeV7ESnazchsksATStx2B/m84ezhVqLylytdBnDaH
         YnBc8xNLkcgKQ==
Date:   Wed, 22 Jun 2022 16:28:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RESEND PATCH 0/2] xfs: random fixes for lock flags
Message-ID: <YrOloCS1nZAPGq/E@magnolia>
References: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 10:30:32AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Hi,
> 
> This patchset include some patches to factor out lock flags
> and fix the mmap_lock state check.

Funny that I didn't notice during review and nobody ever tripped
debugging assertions.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Kaixu Xia (2):
>   xfs: factor out the common lock flags assert
>   xfs: use invalidate_lock to check the state of mmap_lock
> 
>  fs/xfs/xfs_inode.c | 64 ++++++++++++++++++----------------------------
>  1 file changed, 25 insertions(+), 39 deletions(-)
> 
> -- 
> 2.27.0
> 
