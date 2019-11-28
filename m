Return-Path: <SRS0=tu3U=ZU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4691DC43215
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Nov 2019 11:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2365C20880
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Nov 2019 11:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfK1LBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:01:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:46898 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbfK1LBZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Nov 2019 06:01:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88C6CAC71;
        Thu, 28 Nov 2019 11:01:22 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E35B31E0B50; Thu, 28 Nov 2019 12:01:16 +0100 (CET)
Date:   Thu, 28 Nov 2019 12:01:16 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] generic/050: fix xfsquota configuration failures
Message-ID: <20191128110116.GA20395@quack2.suse.cz>
References: <20191127163457.GL6212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127163457.GL6212@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 27-11-19 08:34:57, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The new 'xfsquota' configuration for generic/050 doesn't filter out
> SCRATCH_MNT properly and seems to be missing an error message in the
> golden output.  Fix both of these problems.
> 
> Fixes: e088479871 ("generic/050: Handle xfs quota special case with different output")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks! The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v2: don't try the touch if the mount fails
> ---
>  tests/generic/050              |   12 +++++++-----
>  tests/generic/050.out.xfsquota |    5 ++---
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/generic/050 b/tests/generic/050
> index cf2b9381..7eabc7a7 100755
> --- a/tests/generic/050
> +++ b/tests/generic/050
> @@ -58,9 +58,11 @@ blockdev --setro $SCRATCH_DEV
>  # Mount it, and make sure we can't write to it, and we can unmount it again
>  #
>  echo "mounting read-only block device:"
> -_try_scratch_mount 2>&1 | _filter_ro_mount
> -echo "touching file on read-only filesystem (should fail)"
> -touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> +_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
> +if [ "${PIPESTATUS[0]}" -eq 0 ]; then
> +	echo "touching file on read-only filesystem (should fail)"
> +	touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> +fi
>  
>  #
>  # Apparently this used to be broken at some point:
> @@ -92,7 +94,7 @@ blockdev --setro $SCRATCH_DEV
>  # -o norecovery is used.
>  #
>  echo "mounting filesystem that needs recovery on a read-only device:"
> -_try_scratch_mount 2>&1 | _filter_ro_mount
> +_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
>  
>  echo "unmounting read-only filesystem"
>  _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
> @@ -103,7 +105,7 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
>  # data recovery hack.
>  #
>  echo "mounting filesystem with -o norecovery on a read-only device:"
> -_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
> +_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount | _filter_scratch
>  echo "unmounting read-only filesystem"
>  _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
>  
> diff --git a/tests/generic/050.out.xfsquota b/tests/generic/050.out.xfsquota
> index f204bd2f..35d7bd68 100644
> --- a/tests/generic/050.out.xfsquota
> +++ b/tests/generic/050.out.xfsquota
> @@ -1,8 +1,7 @@
>  QA output created by 050
>  setting device read-only
>  mounting read-only block device:
> -mount: /mnt-scratch: permission denied
> -touching file on read-only filesystem (should fail)
> +mount: SCRATCH_MNT: permission denied
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  setting device read-write
> @@ -17,7 +16,7 @@ mount: cannot mount device read-only
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  mounting filesystem with -o norecovery on a read-only device:
> -mount: /mnt-scratch: permission denied
> +mount: SCRATCH_MNT: permission denied
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  setting device read-write
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
