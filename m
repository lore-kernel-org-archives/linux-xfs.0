Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34112 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeFAIGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jun 2018 04:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <20180601075702.12467-1-yosun@suse.com>
References: <20180601075702.12467-1-yosun@suse.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Jun 2018 11:06:04 +0300
Message-ID: <CAOQ4uxhA31ZMvvUZetyV-EegaWs4w5-ibhen7fNrNFHa8=SW4Q@mail.gmail.com>
Subject: Re: [PATCH] xfstests/btrfs: adapt ppc64le node size at least 65536
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yong Sun <yosun@suse.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

Wrong list. You were looking for <fstests@vger.kernel.org>

Thanks,
Amir.

On Fri, Jun 1, 2018 at 10:57 AM, Yong Sun <yosun@suse.com> wrote:
> From: yosun <yosun@suse.com>
>
> node size(leaf size) in ppc64le at least 65536, so mkfs with --nodesize smaller than that number will cause a fail on 057 and 122.
>
> Signed-off-by: Yong Sun <yosun@suse.com>
> ---
>  tests/btrfs/057 | 6 ++++++
>  tests/btrfs/122 | 8 +++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/tests/btrfs/057 b/tests/btrfs/057
> index a834b763..69d096fb 100755
> --- a/tests/btrfs/057
> +++ b/tests/btrfs/057
> @@ -48,6 +48,12 @@ _require_scratch
>
>  rm -f $seqres.full
>
> +# the nodesize in ppc64le is at least 65536, it will mismatch output
> +HARDWARE_PLATFORM=`uname -i`
> +if [ "$HARDWARE_PLATFORM" = "ppc64le" ]; then
> +        _notrun "Not supported on ppc64le with nodesize > 4096"
> +fi
> +
>  # use small leaf size to get higher btree height.
>  run_check _scratch_mkfs "-b 1g --nodesize 4096"
>
> diff --git a/tests/btrfs/122 b/tests/btrfs/122
> index 213a27f8..50003ad0 100755
> --- a/tests/btrfs/122
> +++ b/tests/btrfs/122
> @@ -55,7 +55,13 @@ rm -f $seqres.full
>
>  # Force a small leaf size to make it easier to blow out our root
>  # subvolume tree
> -_scratch_mkfs "--nodesize 16384" >/dev/null
> +# Exception: leaf size at least 65536 in ppc64le
> +HARDWARE_PLATFORM=`uname -i`
> +if [ "$HARDWARE_PLATFORM" = "ppc64le" ]; then
> +        _scratch_mkfs "--nodesize 65536" >/dev/null
> +else
> +        _scratch_mkfs "--nodesize 16384" >/dev/null
> +fi
>  _scratch_mount
>  _run_btrfs_util_prog quota enable $SCRATCH_MNT
>
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
