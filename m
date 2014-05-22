Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3B7F7F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 12:06:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A386A30407B
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 10:06:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7nNTNREUogEgjZND for
	<xfs@oss.sgi.com>; Thu, 22 May 2014 10:06:50 -0700 (PDT)
Date: Thu, 22 May 2014 13:06:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs/005: filter _scratch_mount output and fix golden
	output to match it
Message-ID: <20140522170647.GA25877@bfoster.bfoster>
References: <1400775429-30015-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400775429-30015-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 23, 2014 at 12:17:09AM +0800, Eryu Guan wrote:
> Failure message of _scratch_mount is something like:
> 
> mount: mount /dev/sda5 on /mnt/scratch failed: Structure needs cleaning
> 
> not
> 
> mount: Structure needs cleaning
> 
> Filter the output and fix the golden image to match the new output.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/005     | 2 +-
>  tests/xfs/005.out | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/005 b/tests/xfs/005
> index 94157c4..534f910 100755
> --- a/tests/xfs/005
> +++ b/tests/xfs/005
> @@ -59,7 +59,7 @@ _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
>  $XFS_IO_PROG -c "pwrite 224 4" $SCRATCH_DEV | _filter_xfs_io
>  
>  # should FAIL, the crc is bad; golden output contains mount failure
> -_scratch_mount
> +_scratch_mount 2>&1 | _filter_scratch
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/005.out b/tests/xfs/005.out
> index 13d0125..853e446 100644
> --- a/tests/xfs/005.out
> +++ b/tests/xfs/005.out
> @@ -1,4 +1,4 @@
>  QA output created by 005
>  wrote 4/4 bytes at offset 224
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -mount: Structure needs cleaning
> +mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Structure needs cleaning
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
