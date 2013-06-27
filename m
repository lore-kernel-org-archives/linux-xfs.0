Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5992D7F7D
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 02:26:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 216FD8F8037
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 00:26:41 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zlKllQmccOI9I3fd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 00:26:39 -0700 (PDT)
Message-ID: <51CBEA31.1020302@oracle.com>
Date: Thu, 27 Jun 2013 15:30:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix SCRATCH_DEV_POOL mount/umount issues
References: <1372298261-16801-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372298261-16801-1-git-send-email-jbacik@fusionio.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: sandeen@redhat.com, zab@redhat.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com



On 06/27/2013 09:57 AM, Josef Bacik wrote:
> If you use the SCRATCH_DEV_POOL for btrfs you will end up with the command line
> like this
>
> mkfs.btrfs $SCRATCH_DEV_POOL $SCRATCH_DEV

> and btrfs does this thing where it makes the lowest valued device id show up in
> /proc/mounts no matter which device you specify at the mount command.  So in
> this case mount will show the first device in $SCRATCH_DEV_POOL instead of
> $SCRATCH_DEV,

  The first item in the SCRATCH_DEV_POOL is assigned to SCRATCH_DEV.
  The remaining will be used where more than one disk is needed.

> so anybody who wants to just use the scratch mnt with the scratch
> dev will fail to work because we never unmount the scratch mount.


>  Fix this by
> checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
> so we can run our test.  Also fix scratch_unmount to call umount $SCRATCH_MNT
> instead of unmount $SCRATCH_DEV so it doesn't screw up with tests that use
> $SCRATCH_DEV_POOL.  This fixes the issue I was seeing by running
>
> ./check btrfs/307 generic/015
>
> Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   common/rc |   19 ++++++++++++++++++-
>   1 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index ad7cbc9..6e3ad65 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -280,7 +280,7 @@ _scratch_mount()
>
>   _scratch_unmount()
>   {
> -    $UMOUNT_PROG $SCRATCH_DEV
> +    $UMOUNT_PROG $SCRATCH_MNT
>   }

  This will fix the above problem for the reason mentioned.

>   _scratch_remount()
> @@ -938,6 +938,8 @@ _supported_os()
>   #
>   _require_scratch()
>   {
> +    local i
> +
>       case "$FSTYP" in
>   	nfs*)
>   		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> @@ -978,6 +980,21 @@ _require_scratch()
>               exit 1
>           fi
>       fi
> +
> +    # we may have a scratch dev pool specified, so make sure it's been unmounted
> +    # from the scratch mount
> +    for i in $SCRATCH_DEV_POOL; do
> +        if _mount | grep -q $i; then
> +            if ! _mount | grep $i | grep -q $SCRATCH_MNT; then
> +                echo "\$SCRATCH_DEV_POOL is mounted but not on \$SCRATCH_MNT - aborting"
> +                exit 1
> +            fi
> +            if ! $UMOUNT_PROG $i; then
> +                echo "failed to umount $i - aborting"
> +                exit 1
> +            fi
> +        fi
> +    done
>   }

   This looks some additional checks beyond the fix for above problem.
   Or did I miss something ? Further _is_mounted() can be used here.



Thanks
Anand

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
