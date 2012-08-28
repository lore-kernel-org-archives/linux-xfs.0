Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SE0hwl103859 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 09:00:43 -0500
Message-ID: <503CCF3F.5050608@sgi.com>
Date: Tue, 28 Aug 2012 09:01:35 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/10] xfstests: rename USE_BIG_LOOPFS to be more generic
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/26/2012 03:39 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> USE_BIG_LOOPFS is really misnamed - it can be used on real devices just as
> easily as loop devices. It really means we are testing a large scratch device
> and that we should enable the special filesystem filling and checking options
> that enable xfstests to be run sanely on large XFS filesystems.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   004       |    2 +-
>   015       |    2 +-
>   030       |    2 +-
>   031       |    2 +-
>   032       |    2 +-
>   033       |    4 ++--
>   041       |    2 +-
>   049       |    2 +-
>   083       |    2 +-
>   092       |    2 +-
>   148       |    2 +-
>   149       |    2 +-
>   common    |    2 +-
>   common.rc |   12 ++++++------
>   setup     |    5 +++--
>   15 files changed, 23 insertions(+), 22 deletions(-)
>

>   MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode64"
>   _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
> diff --git a/148 b/148
> index 76cbf37..7bb1722 100755
> --- a/148
> +++ b/148
> @@ -66,8 +66,8 @@ _check_ag()
>   _supported_fs xfs
>   _supported_os IRIX Linux

#RCJ As long as you are making changes to this file, please remove Linux 
from the _supported_os as xfs_prepair64 is an IRIX specific binary.

>
> -_require_nobigloopfs
>   _require_scratch
> +_require_no_large_scratch_dev
>
>   DSIZE="-dsize=100m"
>
> diff --git a/149 b/149
> index 5131a45..193e6d7 100755
> --- a/149
> +++ b/149
> @@ -100,8 +100,8 @@ EOF
>   _supported_fs xfs
>   _supported_os IRIX Linux

#RCJ As long as you are making changes to this file, please remove Linux 
from the _supported_os as xfs_prepair is an IRIX specific binary.

>
> -_require_nobigloopfs
>   _require_scratch
> +_require_no_large_scratch_dev
>
>   # sanity test - default + one root directory entry
>   # Note: must do this proto/mkfs now for later inode size calcs

Otherwise it looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
