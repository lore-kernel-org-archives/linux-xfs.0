Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4AD37F8E
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 18:53:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60BCBAC002
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 16:53:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wtbs5avIIBj4ds8v for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 16:53:27 -0700 (PDT)
Date: Fri, 11 Apr 2014 09:53:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/204: correct log size for XFS
Message-ID: <20140410235322.GA15995@dastard>
References: <53467259.1080604@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53467259.1080604@oracle.com>
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
To: alexander.tsvetkov@oracle.com
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 02:28:41PM +0400, alexander.tsvetkov@oracle.com wrote:
> generic/204 fails on device with Advanced Format of 4096 bytes per
> physical sector and when partition starts at the 4K boundary/./In this case
> filesystem sector/block size will be of 4096 bytes size and
> _scratch_mkfs_sized
> fails because mkfs reports that 5Mb log size is not enough to create
> a filesystem,
> for example attempt to make filesystem on such partition:
> 
> mkfs.xfs -f -bsize=4096 -l size=5m -d size=109051904 /dev/sdb2"
> 
> results to:
> 
> "log size 1280 blocks too small, minimum size is 1605 blocks"
> 
> and generic/204fails with ENOSPC before it has finished creating the
> necessary files:
> 
> "QA output created by 204
> ./tests/generic/204: line 86: echo: write error: No space left on device
> ..."
> 
> Log size of 7Mbis enough to make filesytem and pass this test.

This is missing a s-o-b line. Can you add one?

> 
> diff --git a/tests/generic/204 b/tests/generic/204
> index 13a762a..4ebab26 100755
> --- a/tests/generic/204
> +++ b/tests/generic/204
> @@ -53,9 +53,9 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2>
> $tmp.mkfs > /dev/null
> 
>  # For xfs, we need to handle the different default log sizes that
> different
>  # versions of mkfs create. All should be valid with a 5MB log, so
> use that.
> -[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=5m"
> +[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m"
> 
> -SIZE=`expr 104 \* 1024 \* 1024`
> +SIZE=`expr 106 \* 1024 \* 1024`
>  _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
>                 | _filter_mkfs 2> $tmp.mkfs > /dev/null
>  _scratch_mount

The change looks fine, but your mailer is line wrapping and
whitespace mangling the patches.  Please read
Documentation/SubmittingPatches in the kernel tree for how to do
this correctly.  Also, please don't send patches in multipart emails
- turn off html sending so that git am doesn't throw a wobbly over
it...

I've fixed it up this time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
