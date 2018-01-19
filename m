Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46410 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbeASEjI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 23:39:08 -0500
Date: Fri, 19 Jan 2018 12:39:06 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 2/3] xfs/realtime: Default rtinherit=1, add
 _require_no_rtinherit function
Message-ID: <20180119043906.GW3102@eguan.usersys.redhat.com>
References: <20180112041619.540900-1-rwareing@fb.com>
 <20180112041619.540900-3-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180112041619.540900-3-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 08:16:18PM -0800, Richard Wareing wrote:
> To better exercise the data path code of realtime subvolumes, we will
> set rtinherit=1 during mkfs calls.  For tests which this is not desired
> we introduce a _require_no_rtinherit function to opt out of this
> behavior.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> ---
> Changes since v3:
> * XFS FS check in _require_no_rtinherit
> * Fixed comment for _require_no_rtinherit to reflect (reworked) function
> 
> Changes since v2:
> * Removed use of RT_INHERT, instead we now simply bail from the test.  Users
>   will have to create two separate configs for realtime one with rtinherit=1
>   in the mkfs options, one without and do separate runs to get full test
>   coverage.
> * Added comments explaining reasons for _require_no_rtinherit declarations
> 
> Changes since v1:
> * None
> 
>  common/rc         | 10 ++++++++++
>  tests/generic/250 |  3 +++
>  tests/generic/252 |  3 +++
>  tests/generic/441 |  3 +++
>  tests/xfs/170     |  1 +
>  5 files changed, 20 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 76f9d69..cceabce 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -33,6 +33,16 @@ BC=$(which bc 2> /dev/null) || BC=
>  VALID_TEST_ID="[0-9]\{3\}"
>  VALID_TEST_NAME="$VALID_TEST_ID-\?[[:alnum:]-]*"
>  
> +# Some tests are not relevant or functional when testing XFS realtime
> +# subvolumes along with the rtinherit=1 mkfs option.  In these cases,
> +# this test will opt-out of the test.
> +_require_no_rtinherit()
> +{
> +  [ "$FSTYP" = "xfs" ] && echo "$MKFS_OPTIONS" | 

Trailing whitespace in above line :)

> +    egrep -q "rtinherit([^=]|=1)" && \

Hmm, this works with "-drtinherit=1" and "-drtinherit,<other opts>" but
fails to detect the "-d rtinherit" case, because the regexp expects some
character after "rtinherit". I think this change could fix it:

-   egrep -q "rtinherit([^=]|=1)" && \
+   egrep -q "rtinherit([^=]|=1|$)" && \

If this looks ok to you, I can fix it on commit (along with the
whitespace issue).

Thanks,
Eryu

> +    _notrun "rtinherit mkfs option is not supported by this test."
> +}
> +
>  _require_math()
>  {
>  	if [ -z "$BC" ]; then
> diff --git a/tests/generic/250 b/tests/generic/250
> index 3c4fe6d..a8fd97e 100755
> --- a/tests/generic/250
> +++ b/tests/generic/250
> @@ -48,6 +48,9 @@ _require_scratch
>  _require_dm_target error
>  _require_xfs_io_command "falloc"
>  _require_odirect
> +# This test uses "dm" without taking into account the data could be on
> +# realtime subvolume, thus the test will fail with rtinherit=1
> +_require_no_rtinherit
>  
>  rm -f $seqres.full
>  
> diff --git a/tests/generic/252 b/tests/generic/252
> index ffedd56..b506d59 100755
> --- a/tests/generic/252
> +++ b/tests/generic/252
> @@ -47,6 +47,9 @@ _supported_os Linux
>  _require_scratch
>  _require_dm_target error
>  _require_xfs_io_command "falloc"
> +# This test uses "dm" without taking into account the data could be on
> +# realtime subvolume, thus the test will fail with rtinherit=1
> +_require_no_rtinherit
>  _require_aiodio "aiocp"
>  AIO_TEST="src/aio-dio-regress/aiocp"
>  
> diff --git a/tests/generic/441 b/tests/generic/441
> index 075d877..5fbfece 100755
> --- a/tests/generic/441
> +++ b/tests/generic/441
> @@ -47,6 +47,9 @@ _cleanup()
>  # real QA test starts here
>  _supported_os Linux
>  _require_scratch
> +# This test uses "dm" without taking into account the data could be on
> +# realtime subvolume, thus the test will fail with rtinherit=1
> +_require_no_rtinherit
>  
>  # Generally, we want to avoid journal errors on the extended testcase. Only
>  # unset the -s flag if we have a logdev
> diff --git a/tests/xfs/170 b/tests/xfs/170
> index c5ae8e4..6deef1b 100755
> --- a/tests/xfs/170
> +++ b/tests/xfs/170
> @@ -50,6 +50,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
> +_require_no_rtinherit
>  
>  _check_filestreams_support || _notrun "filestreams not available"
>  
> -- 
> 2.9.5
> 
