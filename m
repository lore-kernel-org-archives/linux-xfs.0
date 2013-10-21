Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CFB07F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 14:59:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9EFF1AC002
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 12:59:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WzeiCVvEoUEntbyV for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 12:59:35 -0700 (PDT)
Message-ID: <526587A5.4000602@sandeen.net>
Date: Mon, 21 Oct 2013 14:59:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: use -F for mkfs.ext4 in btrfs/012
References: <1382371516-13720-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382371516-13720-1-git-send-email-jbacik@fusionio.com>
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

On 10/21/13 11:05 AM, Josef Bacik wrote:
> I noticed this test was hanging because mkfs.ext4 wanted to make sure it was ok
> to mkfs an entire device.  We need -F so it doesn't ask this question.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/btrfs/012 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/btrfs/012 b/tests/btrfs/012
> index de90149..f7e5da5 100755
> --- a/tests/btrfs/012
> +++ b/tests/btrfs/012
> @@ -65,7 +65,7 @@ _require_command $E2FSCK_PROG e2fsck
>  rm -f $seqres.full
>  
>  # Create & populate an ext4 filesystem
> -$MKFS_EXT4_PROG -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
> +$MKFS_EXT4_PROG -F -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
>  	_notrun "Could not create ext4 filesystem"
>  # Manual mount so we don't use -t btrfs or selinux context
>  mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
