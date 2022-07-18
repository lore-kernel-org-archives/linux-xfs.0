Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEB0C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 17:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiGRROU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 13:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbiGRROO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 13:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1F528A
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 10:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A42BC6156E
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 17:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05E4C341C0;
        Mon, 18 Jul 2022 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658164451;
        bh=ddPtve5qoQnxDHI4NEQDWqjcufQV8MNuph8NCdHNNs8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvAA4bZUxlWdc6GWGDfHLCE6Op/cbaZpzhulllQ1CWe+20anPTL3qjl98HyHeORVd
         ojKtj8pWjGPQvhIZOmNJNDq4V/p6gnBMoJ/BxpSsKWaFeiIihBfKzf+7EhLqjcDERm
         RSBgF7tlLn7haULJBrXQxJu0HawjQJ2o68uRntyJReWsqX4htlfAx0z3z5yWcDot26
         mol3koc9z2aqbHFvqYpq3406TLFgbOE+YGBTx1uiF9M+9JA8G+0u0Rg6orUY2Beqx/
         a+ASIl7UzdM2OtceD+ney7bQtkrzwormdIpvkXCMt4Rl3iWAxEBskkk0DlDcJLtzOD
         3csoE0BXiJlNA==
Date:   Mon, 18 Jul 2022 10:14:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, allison.henderson@oracle.com,
        hexiaole@kylinos.cn
Subject: Re: [PATCH v1] xfs: fix comment for start time value of inode with
 bigtime enabled
Message-ID: <YtWU43q7hgGUOyUv@magnolia>
References: <1658052271-522-1-git-send-email-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658052271-522-1-git-send-email-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 17, 2022 at 06:04:31PM +0800, Xiaole He wrote:
> The 'ctime', 'mtime', and 'atime' for inode is the type of
> 'xfs_timestamp_t', which is a 64-bit type:
> 
> /* fs/xfs/libxfs/xfs_format.h begin */
> typedef __be64 xfs_timestamp_t;
> /* fs/xfs/libxfs/xfs_format.h end */
> 
> When the 'bigtime' feature is disabled, this 64-bit type is splitted
> into two parts of 32-bit, one part is encoded for seconds since
> 1970-01-01 00:00:00 UTC, the other part is encoded for nanoseconds
> above the seconds, this two parts are the type of
> 'xfs_legacy_timestamp' and the min and max time value of this type are
> defined as macros 'XFS_LEGACY_TIME_MIN' and 'XFS_LEGACY_TIME_MAX':
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
> 'XFS_LEGACY_TIME_MIN' is the min time value of the
> 'xfs_legacy_timestamp', that is -(2^31) seconds relative to the
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
> When 'bigtime' feature is enabled, this 64-bit type becomes a 64-bit
> nanoseconds counter, with the start time value is the min time value of
> 'xfs_legacy_timestamp'(start time means the value of 64-bit nanoseconds
> counter is 0). We have already caculated the min time value of
> 'xfs_legacy_timestamp', that is 1901-12-13 20:45:52 UTC, but the comment
> for the start time value of inode with 'bigtime' feature enabled writes
> the value is 1901-12-31 20:45:52 UTC:
> 
> /* fs/xfs/libxfs/xfs_format.h begin */
> /*
>  * XFS Timestamps
>  * ==============
>  * When the bigtime feature is enabled, ondisk inode timestamps become an
>  * unsigned 64-bit nanoseconds counter.  This means that the bigtime inode
>  * timestamp epoch is the start of the classic timestamp range, which is
>  * Dec 31 20:45:52 UTC 1901. ...
>  ...
>  */
> /* fs/xfs/libxfs/xfs_format.h end */
> 
> That is a typo, and this patch corrects the typo, from 'Dec 31' to
> 'Dec 13'.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Xiaole He <hexiaole@kylinos.cn>

Heh, thanks for fixing the typo.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index afdfc81..b55bdfa 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -704,7 +704,7 @@ struct xfs_agfl {
>   * When the bigtime feature is enabled, ondisk inode timestamps become an
>   * unsigned 64-bit nanoseconds counter.  This means that the bigtime inode
>   * timestamp epoch is the start of the classic timestamp range, which is
> - * Dec 31 20:45:52 UTC 1901.  Because the epochs are not the same, callers
> + * Dec 13 20:45:52 UTC 1901.  Because the epochs are not the same, callers
>   * /must/ use the bigtime conversion functions when encoding and decoding raw
>   * timestamps.
>   */
> -- 
> 1.8.3.1
> 
