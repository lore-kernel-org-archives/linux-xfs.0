Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A98A27F51
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:29:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8438D30406B
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:29:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lt03kiDcw4BYmH8H for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:29:43 -0700 (PDT)
Message-ID: <52654863.9050503@redhat.com>
Date: Mon, 21 Oct 2013 10:29:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfstests: generic/274 increase scratch fs size to 2g
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
	<1382120790-31060-5-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-5-git-send-email-jbacik@fusionio.com>
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

On 10/18/13 1:26 PM, Josef Bacik wrote:
> With 1 gig btrfs defaults to mixed block groups, so we ENOSPC in this test
> because we run out of metadata space, not data space.  Increasing to 2g allows
> us to use our normal setup and allows us to pass this test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Doubles the test time on xfs, but from 16s to 30s on a single spindle sata
disk; I think we can handle it.

ext4 fails w/ or w/o the patch, so *shrug*

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/274 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/274 b/tests/generic/274
> index da45fab..7c4887f 100755
> --- a/tests/generic/274
> +++ b/tests/generic/274
> @@ -57,7 +57,7 @@ echo "------------------------------"
>  rm -f $seqres.full
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
>  # Create a 4k file and Allocate 4M past EOF on that file
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
