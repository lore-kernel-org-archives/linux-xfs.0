Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADCD87CA1
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:32:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 836C88F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 14:32:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9sM7f7gKWKXdiZl1 for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 14:32:33 -0700 (PDT)
Date: Fri, 8 Apr 2016 07:32:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/259: handle minimum block size more precisely
Message-ID: <20160407213231.GD761@dastard>
References: <1460027155-4222-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460027155-4222-1-git-send-email-eguan@redhat.com>
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

On Thu, Apr 07, 2016 at 07:05:55PM +0800, Eryu Guan wrote:
> Currently xfs/259 checks $TEST_DIR for CRC support status to determine
> if 512 block size should be tested. But this doesn't always work. For
> example, when TEST_DEV is mkfs'ed with "-m crc=0" mkfs option, using
> mkfs.xfs binary with CRC being the default.
> 
> What should be really checked is whether mkfs.xfs creates CRC enabled
> XFS by default. So introduce a new flag XFS_MKFS_CRC_DEFAULT for this
> purpose, and do the check based on it in xfs/259.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> 
> This is actually the second attempt to fix this issue, because Christoph was
> not satisfied with the first attempt, and me either (after thinking about it
> more :-)). Hope it works this time.
> 
>  common/config | 8 ++++++++
>  tests/xfs/259 | 4 +---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/common/config b/common/config
> index cacd815..13bd307 100644
> --- a/common/config
> +++ b/common/config
> @@ -270,8 +270,16 @@ $MKFS_XFS_PROG -N -d file,name=/tmp/crc_check.img,size=32m -m crc=0 \
>  if [ $? -ne 0 ]; then
>  	XFS_MKFS_HAS_NO_META_SUPPORT=true
>  fi
> +# check if v5 xfs is default
> +XFS_MKFS_CRC_DEFAULT=0
> +$MKFS_XFS_PROG -N -d file,name=/tmp/crc_check.img,size=32m 2>&1 | grep -q crc=1
> +if [ $? -eq 0 ]; then
> +	XFS_MKFS_CRC_DEFAULT=1
> +fi
>  rm -f /tmp/crc_check.img

That tests the mkfs configuration that is applied to the scratch
device....

> diff --git a/tests/xfs/259 b/tests/xfs/259
> index 16c1935..3150ff3 100755
> --- a/tests/xfs/259
> +++ b/tests/xfs/259
> @@ -51,9 +51,7 @@ testfile=$TEST_DIR/259.image
>  # Test various sizes slightly less than 4 TB. Need to handle different
>  # minimum block sizes for CRC enabled filesystems, but use a small log so we
>  # don't write lots of zeros unnecessarily.
> -xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.mkfs > /dev/null
> -. $tmp.mkfs

This tests the configuration of the test device, which is not
controlled by the test harness, so can be different to the
configuration being used for the scratch device.

> -if [ $_fs_has_crcs -eq 1 ]; then
> +if [ $XFS_MKFS_CRC_DEFAULT -eq 1 ]; then

IOWs, this is not an not equivalent test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
