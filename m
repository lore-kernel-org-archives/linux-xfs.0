Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E5FECAAD4
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 13:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiH3NCT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiH3NCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 09:02:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069687B292
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 06:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A32B81AAC
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 13:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE168C433D6;
        Tue, 30 Aug 2022 13:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661864531;
        bh=/BCJnxIIFgcczpS+u7aEmZ+69niPbdWPiCtaDP9YY2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V3pdFCdlkM67iyy0T1msR/L7+/LlHYoNZ/T8CregIfR6QMqArPBVwksQMlShE3ycU
         bTTV1BxauB+XgkyG+LRem0lcvrQxGJbSICs9w0xU6H64qKdgH+uVKImRnAOk6Jx+wN
         5LwloPXcYgtaNEeX2go3XcVqTMwGVHBcDlCha5ad0Dn7bP3BHw8a85Uk0ihl37njit
         27rYvSHoqkNTXZa7CynmidJ74Ktl0P7ZZKRpVnfijcmhdCbDZFBlMrlz93wdQgEwYK
         OjRJACnkngE6mEaEUmX5ChpAbj1olzIm0DuHg8+f//KcVRN+WleLi8C1u88aBgBEVq
         qKv0KrBJyOOjA==
Date:   Tue, 30 Aug 2022 15:02:07 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Jakub Bogusz <qboosh@pld-linux.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Polish translation update for xfsprogs 5.19.0
Message-ID: <20220830130207.dhia5gbof7wzo7br@andromeda>
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

Thanks Jakub, I'm gonna queue this update for 6.0

> 
> ---
>  pl.po |17011 ++++++++++++++++++++++++++++++++++--------------------------------
>  1 file changed, 8894 insertions(+), 8117 deletions(-)
> 
> --- xfsprogs-5.19.0/po/pl.po.orig       2022-06-01 20:30:20.000000000 +0200
> +++ xfsprogs-5.19.0/po/pl.po    2022-08-21 21:30:05.004759894 +0200
> [...]
> 
> 
> Regards,
> 
> --
> Jakub Bogusz    http://qboosh.pl/

-- 
Carlos Maiolino
