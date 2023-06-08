Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29ECC7EE25
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 14:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbjFHOrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 10:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjFHOrP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 10:47:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF482D4A
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 07:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64B8E60AFF
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 14:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3CC433D2;
        Thu,  8 Jun 2023 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686235633;
        bh=JnnLSzIAFhwxUVyt+/hEC0txc6HHwswv8plBCzMIdIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bp4qoGwmOOdOLi/JnPwQ82LgK1LPMcHz8c/ZIp/s04c1FuhduucE0U8Oc4L5WcojI
         aaVoUCBByF49dZ1UbgPfqVRg2O+qrTodRwRT+ov9XRsc3m9xJudJntVGGaMqmo1z4H
         6UGBz8uq5cnI0zCjpOb5yPQpvdYtwQ+y8S8B1OoohBytV4u2Hx7fE6x6CwwubaAdBV
         3e7Vk7YNEsHexnay9mrCnqwHjKl7ND21YvR8N+gwnY9UuP34L217efQlmd+AwwrXIF
         xysgFpTvMHqPU4JHL4SzrZj5qrdMqaL78+SuocEaciU/DunJh2TJKIhev4NkaEJOCO
         Q+vqcK71URmiQ==
Date:   Thu, 8 Jun 2023 07:47:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: fix man's default value for sparse option
Message-ID: <20230608144713.GV1325469@frogsfrogsfrogs>
References: <20230608091320.113513-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608091320.113513-1-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2023 at 11:13:20AM +0200, Pavel Reichl wrote:
> Fixes: 9cf846b51 ("mkfs: enable sparse inodes by default")
> Suggested-by: Lukas Herbolt <lukas@herbolt.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Heh, whoops.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  man/man8/mkfs.xfs.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index 49e64d47a..48e26ece7 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -631,7 +631,7 @@ Enable sparse inode chunk allocation. The
>  .I value
>  is either 0 or 1, with 1 signifying that sparse allocation is enabled.
>  If the value is omitted, 1 is assumed. Sparse inode allocation is
> -disabled by default. This feature is only available for filesystems
> +enabled by default. This feature is only available for filesystems
>  formatted with
>  .B \-m crc=1.
>  .IP
> -- 
> 2.40.1
> 
