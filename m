Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 944147F4E
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 15:15:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 819108F806F
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 13:15:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5YPwbFM2OgGRhqes for
	<xfs@oss.sgi.com>; Fri, 03 May 2013 13:15:07 -0700 (PDT)
Message-ID: <51841AC5.3090309@redhat.com>
Date: Fri, 03 May 2013 15:15:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: unmount scratch mnt in test 307
References: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 5/3/13 3:11 PM, Josef Bacik wrote:
> So if you have a mount command that doesn't use /etc/mtab then it will spit out
> a different device for the mounted device.  So say we have
> 
> SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc"
> 
> we will turn this into
> 
> SCRATCH_DEV="/dev/sda"
> SCRATCH_DEV_POOL="/dev/sdb /dev/sdc"
> 
> and then when you mkfs this you do _scratch_mkfs $SCRATCH_DEV_POOL which turns
> into this
> 
> mkfs.btrfs /dev/sdb /dev/sdc /dev/sda
> 
> becuase we do
> 
> mkfs $* $SCRATCH_DEV
> 
> Then btrfs will always show the lowest devid in /proc/mounts to maintain
> consistency, so even though we do mount /dev/sda $SCRATCH_MNT, you will see
> /dev/sdb as the mounted device in /proc/mounts.  So then say the next test wants
> to just use $SCRATCH_DEV, it will do _require_scratchdev which will check to see
> if $SCRATCH_DEV is mounted, which it will look like it is not because
> /proc/mounts shows /dev/sdb instead of /dev/sda, and so it won't umount
> $SCRATCH_MNT, and then that test will fail because we can't mkfs the device
> because it is busy.  I reproduced this on a box that doesn't use /etc/mtab by
> doing
> 
> ./check btrfs/307 generic/015
> 
> and 015 would fail.  With this patch it passes now.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/btrfs/307 |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/btrfs/307 b/tests/btrfs/307
> index 87314c6..15157b3 100644
> --- a/tests/btrfs/307
> +++ b/tests/btrfs/307
> @@ -35,6 +35,7 @@ _cleanup()
>  {
>      cd /
>      rm -f $tmp.*
> +    umount $SCRATCH_MNT
>  }
>  
>  # get standard environment, filters and checks
> 

This seems fine for this particular test.

Is it really a hard requirement that each test unmount SCRATCH_[DEV|MNT] if it used it?
If so, fine... the README does indicate this.

But I wonder if we can make it a little more foolproof by updating _require_scratch
to handle this situation more gracefully?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
