Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD15C00528
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 08:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjHBIw2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHBIw1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 04:52:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78E2D9
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 01:52:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82CBA61882
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 08:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2E1C433C8;
        Wed,  2 Aug 2023 08:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690966345;
        bh=eyQeIQit9GmWN+rJm7+vx3EwPDbE6X4PvZbNSJKjyYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hPSdM4Z/j8RA0zl5c3kTr09WJqvRZbapqDtwDmn4sIZWZPHqtWyOf96dWVJ2xuFTC
         TbVLdcDDvCPoWntdX87B1y7H3UZp13DU7pXafgbj84OtG3fMh73qpPpPVGt5kVrIo3
         6siD1zsdyuzgy6lqDfxFXG2H9Vnxlr5G1l2Di1x30p4vP7A+cCqfEnLIL2tof9UK+v
         CISDERjlDQhUY6plplOeTokqLN3YIJrCH9VkRfr2iXXMFNk3BgFcu2mbHM0XglWGmy
         82xpX0/htjEyccsPMLAWz25IuXDy8W1DqQ3jglbiveQO0MTQXyX/H2DQOeJs1ABGKB
         bUmIVdZzqtaZg==
Date:   Wed, 2 Aug 2023 10:52:22 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Bill O'Donnell <bodonnel@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs.8: correction on mkfs.xfs manpage since reflink
 and dax are compatible
Message-ID: <20230802085222.53cul5vymxyxjznz@andromeda>
References: <66z3bx95e2xL_ZIVsmJU4cLb5z2V8aW7EpQ6kArDfJ2ej7brNwRcbuXvcbLP2pFWdXyFSPBFTRWG-U62SMRU7A==@protonmail.internalid>
 <20230728222017.178599-1-bodonnel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728222017.178599-1-bodonnel@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 28, 2023 at 05:20:17PM -0500, Bill O'Donnell wrote:
> Merged early in 2023: Commit 480017957d638 xfs: remove restrictions for fsdax
> and reflink. There needs to be a corresponding change to the mkfs.xfs manpage
> to remove the incompatiblity statement.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  man/man8/mkfs.xfs.8.in | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index ce6f1e2d..08bb92f6 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -323,13 +323,6 @@ option set. When the option
>  .B \-m crc=0
>  is used, the reference count btree feature is not supported and reflink is
>  disabled.
> -.IP
> -Note: the filesystem DAX mount option (
> -.B \-o dax
> -) is incompatible with
> -reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
> -.B \-m reflink=0
> -option to mkfs.xfs to disable the reflink feature.
>  .RE
>  .PP
>  .PD 0
> --
> 2.41.0
> 
