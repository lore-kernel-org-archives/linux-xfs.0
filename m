Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92552C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jul 2022 15:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiGOPju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 11:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiGOPjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jul 2022 11:39:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB22E9EB
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 08:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A7DCB82D12
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 15:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322BEC34115;
        Fri, 15 Jul 2022 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657899586;
        bh=Llg9wnF4r7cUG5PLv33LrDVTdnBw2tLO8fGQf4g7KtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VhaKV8P2WBEXWimFabXvUSBbVrC3XOm8cP3O0Imh5FpNmExX+xZ/ki5wdZZswKyUi
         96aTU+nnbNyrAGMxYz63tGzUdevEWAMcOy3D7Iz7lDjvIG16hb2KLvGZEjTAx1C/vB
         LTBlOGRkoY1FJzHDKFj28272YlkyRot2yjpqEOMwI6Kz0K2xqItHVrdB/LhGrlWcIT
         sOVFu659dAp6eDABSgdi1JPbaWA42BDFhq9E6geKtGqdLP/vgWyDNLPkXN3aXUF8+4
         3CYk8zasviddSaSLJr8FQ/dj6kFLlGgYs/+3vsiZ62z+Ld/EDUiz9H859Y40RI3NC3
         HVe8GZmQ2oxmA==
Date:   Fri, 15 Jul 2022 08:39:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     hexiaole <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole@kylinos.cn
Subject: Re: [PATCH v1 1/2] xfsdocs: fix inode timestamps lower limit value
Message-ID: <YtGKQaqJ8fnQzIYf@magnolia>
References: <1657882427-96-1-git-send-email-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1657882427-96-1-git-send-email-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[Ugh, reflowed this to 72 columns]

On Fri, Jul 15, 2022 at 06:53:46PM +0800, hexiaole wrote:
> From: hexiaole <hexiaole@kylinos.cn>
> 
> 1. Fix description
> In kernel source tree 'fs/xfs/libxfs/xfs_format.h', there defined
> inode timestamps as 'xfs_legacy_timestamp' if the 'bigtime' feature
> disabled, and also defined the min and max time constants
> 'XFS_LEGACY_TIME_MIN' and 'XFS_LEGACY_TIME_MAX':
> 
> /* fs/xfs/libxfs/xfs_format.h begin */
> struct xfs_legacy_timestamp {
>         __be32          t_sec;          /* timestamp seconds */
>         __be32          t_nsec;         /* timestamp nanoseconds */
> };
> /* fs/xfs/libxfs/xfs_format.h end */
> /* include/linux/limits.h begin */
> /* include/linux/limits.h end */
> 
> When the 't_sec' and 't_nsec' are 0, the time value it represents is
> 1970-01-01 00:00:00 UTC, the 'XFS_LEGACY_TIME_MIN', that is -(2^31),
> represents the min second offset relative to the 1970-01-01 00:00:00
> UTC, it can be converted to human-friendly time value by 'date'
> command:
> 
> /* command begin */
> [root@DESKTOP-G0RBR07 sources]# date --utc -d "@`echo '-(2^31)'|bc`" +'%Y-%m-%d %H:%M:%S'
> 1901-12-13 20:45:52
> [root@DESKTOP-G0RBR07 sources]#
> /* command end */
> 
> That is, the min time value is 1901-12-13 20:45:52 UTC, but the
> 'design/XFS_Filesystem_Structure/timestamps.asciidoc' write the min
> time value as 'The smalle st date this format can represent is
> 20:45:52 UTC on December 31st', there should be a typo, and this patch
> correct 2 places of wrong min time value, from '3 1st' to '13st'.

Yep, that's a typo, can you send a patch to fix the xfs_format.h
comments, please?

> 2. Question
> In the section 'Quota Timers' of
> 'design/XFS_Filesystem_Structure/timestamps.asciidoc':
> 
> /* timestamps.asciidoc begin */
> With the introduction of the bigtime feature, the ondisk field now
> encodes the upper 32 bits of an unsigned 34-bit seconds counter.  ...
>
> The smallest quota expiration date is now 00:00:04 UTC on January 1st, 1970;
> and the largest is 20:20:24 UTC on July 2nd, 2486.
> /* timestamps.asciidoc end */
> 
> It seems hard to understand the the relationship among the '32 bits of
> an unsigned 34-bit seconds counter', '00:00:04 UTC on January 1st,
> 1970', and 00:00:04 UTC on January 1st, 1970', is it there a typo for
> '34-bit' and the expected one is '64-bit'?

The incore timer field is the usual 64-bit time_t, like you'd expect.
However, its usage is clamped such that we only use the lower 34 bits of
the field, because the ondisk timer field is still 32 bits wide.  At the
time of review for bigtime, we decided that losing the lower 2 bits of
precision was a better sacrifice than redesigning the ondisk dquot
format.  This results in a resolution of 4 seconds (instead of 1)
because the conversion is:

ondisk_timer = incore_timer >> 2;

Hence the ondisk field encodes the upper 32 bits of a (logically) 34-bit
counter.

--D

> ---
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
> 2.27.0
> 
