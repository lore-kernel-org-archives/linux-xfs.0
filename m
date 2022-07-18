Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD15C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 17:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiGRRR2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 13:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGRRR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 13:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5ED2C13F
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 10:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201286156E
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 17:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4F7C341C0;
        Mon, 18 Jul 2022 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658164646;
        bh=dsHwu9ZkYMgoGuN+wwtSLnUOAR1HB0fW6bVqf5M7T/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y2cu1MY3LNHmasCHBYy4kduFvFHOUuB3cJEaZ2cpcVku7yH/1QoaCFyt7ZeGzpmHS
         GKeP9yj41fKRmqP4c5rWAS27JxUkK2IH5MADdknuMGdT2O71bCrFVNA7IQcuFzd7YH
         0tdndnJUUiABtD43L1M7gEfT4U70pJZsi41rL0uPk2WoUy1euEkG8QjlSnKtcy1rwu
         zcUpkPVZri2xcYBf6d6jwQVA4HDjGQkhUUFSaLLaClaM49uh9ry+drwqgCNyu11r1h
         u7mfAHJDUKI0WlLqi4GO1isdeJhgUWB9dmabnswwBy5SijDMkW0eB3w+M4ra+y1Ov9
         aqvZlOb6WUBDQ==
Date:   Mon, 18 Jul 2022 10:17:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com,
        Xiaole He <hexiaole@kylinos.cn>
Subject: Re: [PATCH v2 1/2] xfsdocs: fix inode timestamps lower limit value
Message-ID: <YtWVpW2EQAMIWnBd@magnolia>
References: <1658052449-567-1-git-send-email-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658052449-567-1-git-send-email-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 17, 2022 at 06:07:28PM +0800, Xiaole He wrote:
> In kernel source tree 'fs/xfs/libxfs/xfs_format.h', there defined inode
> timestamps as 'xfs_legacy_timestamp' if the 'bigtime' feature disabled,
> and also defined the min and max time constants 'XFS_LEGACY_TIME_MIN'
> and 'XFS_LEGACY_TIME_MAX' as below:
> 
> /* fs/xfs/libxfs/xfs_format.h begin */
> struct xfs_legacy_timestamp {
>         __be32          t_sec;          /* timestamp seconds */
>         __be32          t_nsec;         /* timestamp nanoseconds */
> };
>  #define XFS_LEGACY_TIME_MIN     ((int64_t)S32_MIN)
>  #define XFS_LEGACY_TIME_MAX     ((int64_t)S32_MAX)
> /* fs/xfs/libxfs/xfs_format.h end */
> /* include/linux/limits.h begin */
>  #define U32_MAX         ((u32)~0U)
>  #define S32_MAX         ((s32)(U32_MAX >> 1))
>  #define S32_MIN         ((s32)(-S32_MAX - 1))
> /* include/linux/limits.h end */
> 
> When the 't_sec' and 't_nsec' are 0, the time value it represents is
> 1970-01-01 00:00:00 UTC, the 'XFS_LEGACY_TIME_MIN', that is -(2^31),
> represents the min second offset relative to the
> 1970-01-01 00:00:00 UTC, it can be converted to human-friendly time
> value by 'date' command:
> 
> /* command begin */
> [root@~]# date --utc -d '@0' +'%Y-%m-%d %H:%M:%S'
> 1970-01-01 00:00:00
> [root@~]# date --utc -d "@`echo '-(2^31)'|bc`" +'%Y-%m-%d %H:%M:%S'
> 1901-12-13 20:45:52
> [root@~]#
> /* command end */
> 
> That is, the min time value is 1901-12-13 20:45:52 UTC, but the
> 'design/XFS_Filesystem_Structure/timestamps.asciidoc' write the min
> time value as 'The smalle st date this format can represent is
> 20:45:52 UTC on December 31st', there should be a typo, and this patch
> correct 2 places of wrong min time value, from '31st' to '13st'.
> 
> Signed-off-by: Xiaole He <hexiaole@kylinos.cn>

Looks correct, will commit...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> V1 -> V2: Wrap line at 72 column, add Signed-off-by, add one more 
> 'date' command for explanation, remove the question section.
> 
>  design/XFS_Filesystem_Structure/timestamps.asciidoc | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/timestamps.asciidoc b/design/XFS_Filesystem_Structure/timestamps.asciidoc
> index 08baa1e..56d4dc9 100644
> --- a/design/XFS_Filesystem_Structure/timestamps.asciidoc
> +++ b/design/XFS_Filesystem_Structure/timestamps.asciidoc
> @@ -26,13 +26,13 @@ struct xfs_legacy_timestamp {
>  };
>  ----
>  
> -The smallest date this format can represent is 20:45:52 UTC on December 31st,
> +The smallest date this format can represent is 20:45:52 UTC on December 13st,
>  1901, and the largest date supported is 03:14:07 UTC on January 19, 2038.
>  
>  With the introduction of the bigtime feature, the format is changed to
>  interpret the timestamp as a 64-bit count of nanoseconds since the smallest
>  date supported by the old encoding.  This means that the smallest date
> -supported is still 20:45:52 UTC on December 31st, 1901; but now the largest
> +supported is still 20:45:52 UTC on December 13st, 1901; but now the largest
>  date supported is 20:20:24 UTC on July 2nd, 2486.
>  
>  [[Quota_Timers]]
> -- 
> 1.8.3.1
> 
