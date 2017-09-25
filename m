Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44295 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934892AbdIYVit (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 17:38:49 -0400
Date: Mon, 25 Sep 2017 14:38:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/3] xfs/realtime: Add require_no_realtime function
Message-ID: <20170925213845.GC5020@magnolia>
References: <20170925195625.756877-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925195625.756877-1-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 25, 2017 at 12:56:23PM -0700, Richard Wareing wrote:
> Some tests do not play well with realtime devices, in an effort to
> produce a stable set of test which exercise the realtime code paths
> we introduce a _require_no_realtime function to allow tests to opt
> out of realtime subvolume test runs.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> ---
> Changes since v1:
> * None
> 
>  common/rc                      | 8 ++++++++
>  tests/generic/409              | 1 +
>  tests/generic/410              | 1 +

Why don't shared subtree tests work w/ rt?

>  tests/generic/411              | 1 +

Some sort of mount regression?

>  tests/xfs/077                  | 1 +
>  tests/xfs/189                  | 1 +
>  tests/xfs/191-input-validation | 1 +
>  tests/xfs/202                  | 1 +
>  tests/xfs/284                  | 1 +

This test checks that xfsprogs don't run on a mounted fs.  Why would
that be excluded from rt testing?

Since there's only 8 tests on your list, I'm curious why each of them
gets disabled for rt filesystems?

--D

>  9 files changed, 16 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 53bbb11..a0081f1 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1835,6 +1835,14 @@ _require_realtime()
>  	_notrun "Realtime device required, skipped this test"
>  }
>  
> +# This test requires that a realtime subvolume is not in use
> +#
> +_require_no_realtime()
> +{
> +    [ -n "$SCRATCH_RTDEV" ] && \
> +	_notrun "Test not compatible with realtime subvolumes, skipped this test"
> +}
> +
>  # this test requires that a specified command (executable) exists
>  # $1 - command, $2 - name for error message
>  #
> diff --git a/tests/generic/409 b/tests/generic/409
> index 3ad65c9..8ed3e4e 100755
> --- a/tests/generic/409
> +++ b/tests/generic/409
> @@ -65,6 +65,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>  _require_local_device $SCRATCH_DEV
> +_require_no_realtime
>  
>  fs_stress()
>  {
> diff --git a/tests/generic/410 b/tests/generic/410
> index 63ab716..1bbaff8 100755
> --- a/tests/generic/410
> +++ b/tests/generic/410
> @@ -73,6 +73,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>  _require_local_device $SCRATCH_DEV
> +_require_no_realtime
>  
>  fs_stress()
>  {
> diff --git a/tests/generic/411 b/tests/generic/411
> index 83f6d26..ea718fc 100755
> --- a/tests/generic/411
> +++ b/tests/generic/411
> @@ -54,6 +54,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>  _require_local_device $SCRATCH_DEV
> +_require_no_realtime
>  
>  fs_stress()
>  {
> diff --git a/tests/xfs/077 b/tests/xfs/077
> index eba4f08..d202fa4 100755
> --- a/tests/xfs/077
> +++ b/tests/xfs/077
> @@ -50,6 +50,7 @@ _cleanup()
>  
>  _supported_fs xfs
>  _supported_os Linux
> +_require_no_realtime
>  _require_scratch
>  _require_xfs_crc
>  _require_meta_uuid
> diff --git a/tests/xfs/189 b/tests/xfs/189
> index 636f6f0..699eb3c 100755
> --- a/tests/xfs/189
> +++ b/tests/xfs/189
> @@ -236,6 +236,7 @@ _putback_scratch_fstab()
>  _supported_fs xfs
>  _supported_os Linux
>  
> +_require_no_realtime
>  _require_scratch
>  _require_noattr2
>  
> diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
> index cff3efa..764ac9b 100755
> --- a/tests/xfs/191-input-validation
> +++ b/tests/xfs/191-input-validation
> @@ -47,6 +47,7 @@ _cleanup()
>  # Modify as appropriate.
>  _supported_fs xfs
>  _supported_os Linux
> +_require_no_realtime
>  _require_scratch
>  _require_xfs_mkfs_validation
>  
> diff --git a/tests/xfs/202 b/tests/xfs/202
> index b9827a7..f887873 100755
> --- a/tests/xfs/202
> +++ b/tests/xfs/202
> @@ -38,6 +38,7 @@ status=1	# failure is the default!
>  _supported_fs xfs
>  _supported_os Linux
>  
> +_require_no_realtime
>  # single AG will cause default xfs_repair to fail. This test is actually
>  # testing the special corner case option needed to repair a single AG fs.
>  _require_scratch_nocheck
> diff --git a/tests/xfs/284 b/tests/xfs/284
> index e3625fe..fa5dac8 100755
> --- a/tests/xfs/284
> +++ b/tests/xfs/284
> @@ -49,6 +49,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs xfs
>  _supported_os Linux
> +_require_no_realtime
>  _require_test
>  _require_scratch
>  
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
