Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91CBE7FBD
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 09:43:26 -0600 (CST)
Message-ID: <5130CC9F.4090207@sgi.com>
Date: Fri, 1 Mar 2013 09:43:27 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/10] xfstests: hardcode fops for determinable fsstests
	runs
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-4-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-4-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> 106,107 and 117 are frozen tests which use known seed, it is
> reasonable to explicitly hardcode file operations in order to avoid
> implicit changes caused by future changes in fsstress.
>
> NOTE: options genereted like follows: fsstress -S c $ORIG_ARGS
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

106 and 107 are not valid for ext4. They failed the same before and 
after this patch with xfs. Because 106 and 107 are not in the auto group 
and 117 is in the auto group and passes for both xfs and ext4,
I will say this looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


> ---
>   106 |   33 +++++++++++++++++++++++++++++++--
>   107 |   32 +++++++++++++++++++++++++++++---
>   2 files changed, 60 insertions(+), 5 deletions(-)
>
> diff --git a/106 b/106
> index 8278691..b351fe5 100755
> --- a/106
> +++ b/106
> @@ -61,8 +61,37 @@ _require_prjquota $SCRATCH_DEV
>
>   # initial populate
>   target=$SCRATCH_MNT/target
> -$FSSTRESS_PROG -s 0xdeed -m8 -w -p4 -n1000 $FSSTRESS_AVOID -d $target
> -$FSSTRESS_PROG -s 0xdeed -m8 -z -p4 -n1000 -fsetxattr=500 -fchown=500 -d $target
> +$FSSTRESS_PROG -z -s 57069 -m 8 -n 1000 -p 4 \
> +-f allocsp=1 \
> +-f chown=3 \
> +-f creat=4 \
> +-f dwrite=4 \
> +-f fallocate=1 \
> +-f fdatasync=1 \
> +-f fiemap=1 \
> +-f freesp=1 \
> +-f fsync=1 \
> +-f link=1 \
> +-f mkdir=2 \
> +-f mknod=2 \
> +-f punch=1 \
> +-f rename=2 \
> +-f resvsp=1 \
> +-f rmdir=1 \
> +-f setxattr=1 \
> +-f symlink=2 \
> +-f sync=1 \
> +-f truncate=2 \
> +-f unlink=1 \
> +-f unresvsp=1 \
> +-f write=4 \
> +-d $target
> +
> +$FSSTRESS_PROG -z -s 57069 -m 8 -n 1000 -p 4 \
> +-f chown=500 \
> +-f setxattr=500 \
> +-d $target
> +
>
>   # also use space, to be able to go over/under limits easily
>   uid=255
> diff --git a/107 b/107
> index 74403e6..eaf7e6a 100755
> --- a/107
> +++ b/107
> @@ -78,9 +78,35 @@ echo "6:$target" | tee -a $seq.full > $tmp.projects
>
>   echo "### populate filesystem"
>   mkdir $target		|| exit
> -FSSTRESS_AVOID="$FSSTRESS_AVOID -fmknod=0 -fsymlink=0"
> -$FSSTRESS_PROG -s 0xfeed -m8 -w -p4 -n1000 $FSSTRESS_AVOID -d $target
> -$FSSTRESS_PROG -s 0xbabe -m8 -z -p4 -n500 -fsetxattr=250 -fchown=250 -d $target
> +$FSSTRESS_PROG -z -s 65261 -m 8 -n 1000 -p 4 \
> +-f allocsp=1 \
> +-f chown=3 \
> +-f creat=4 \
> +-f dwrite=4 \
> +-f fallocate=1 \
> +-f fdatasync=1 \
> +-f fiemap=1 \
> +-f freesp=1 \
> +-f fsync=1 \
> +-f link=1 \
> +-f mkdir=2 \
> +-f punch=1 \
> +-f rename=2 \
> +-f resvsp=1 \
> +-f rmdir=1 \
> +-f setxattr=1 \
> +-f sync=1 \
> +-f truncate=2 \
> +-f unlink=1 \
> +-f unresvsp=1 \
> +-f write=4 \
> +-d $target
> +
> +$FSSTRESS_PROG -z -s 47806 -m 8 -n 500 -p 4 \
> +-f chown=250 \
> +-f setxattr=250 \
> +-d $target
> +
>
>   QARGS="-x -D $tmp.projects -P /dev/null $SCRATCH_MNT"
>
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
