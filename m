Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 732007F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 06:39:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46AA38F8039
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 04:39:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qz4ZSEzQ5YujoBwE for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 04:39:04 -0700 (PDT)
Date: Fri, 23 May 2014 07:39:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs/005: filter _scratch_mount output to match golden
	image
Message-ID: <20140523113902.GA38092@bfoster.bfoster>
References: <1400816603-2263-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400816603-2263-1-git-send-email-eguan@redhat.com>
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

On Fri, May 23, 2014 at 11:43:23AM +0800, Eryu Guan wrote:
> Failure message of mount has been changed since util-linux v2.21, to
> something like:
> 
> mount: mount /dev/sda5 on /mnt/scratch failed: Structure needs cleaning
> 
> Filter the output to match the golden image for newer mount binary so
> that both old and new version of mount work correctly.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v2: filter the mount error message instead of changing the golden image
> 

Works for me on 2.24.2.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/005 | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/005 b/tests/xfs/005
> index 94157c4..509ac61 100755
> --- a/tests/xfs/005
> +++ b/tests/xfs/005
> @@ -40,6 +40,11 @@ _cleanup()
>      rm -f $tmp.*
>  }
>  
> +filter_mount()
> +{
> +	sed -e "s/mount .* failed: //"
> +}
> +
>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> @@ -59,7 +64,7 @@ _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
>  $XFS_IO_PROG -c "pwrite 224 4" $SCRATCH_DEV | _filter_xfs_io
>  
>  # should FAIL, the crc is bad; golden output contains mount failure
> -_scratch_mount
> +_scratch_mount 2>&1 | filter_mount
>  
>  # success, all done
>  status=0
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
