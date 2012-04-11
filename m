Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3B7P55Z034457 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 02:25:06 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UTD75GgLSTn7KEL7 for
	<xfs@oss.sgi.com>; Wed, 11 Apr 2012 00:25:04 -0700 (PDT)
Date: Wed, 11 Apr 2012 09:24:50 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] 273: don't delete everything if $SCRATCH_MNT isn't set
In-Reply-To: <4F8430FF.2090706@netapp.com>
Message-ID: <alpine.LFD.2.00.1204110917300.3798@dhcp-27-109.brq.redhat.com>
References: <4F832C25.3080408@netapp.com> <20120409214445.GJ18323@dastard>
	<4F8430FF.2090706@netapp.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, 10 Apr 2012, Bryan Schumaker wrote:

> On 04/09/12 17:44, Dave Chinner wrote:
> 
> > On Mon, Apr 09, 2012 at 02:36:21PM -0400, Bryan Schumaker wrote:
> >> The cleanup function is trapped before _require_scratch() is called, and
> >> then expands "rm -rf $SCRATCH_MNT/*" to "rm -rf /*"
> > 
> > It doesn't need to clean up the scratch device - tests need to mkfs
> > it first before using it, so just remove the $tmp* files. The sae
> > fix is needed for tests 274 and 275.
> > 
> > Also, it shouldn't be using "-rf" to do cleanup - "rm -f $tmp.*" is
> > sufficient to remove all the tmp files...
> 
> 
> Thanks for looking!  Maybe something like this?  (copying what 272 does):

This is actually not needed at all. Simply removing the 'rm -rf
$SCRATCH_MNT/*' line should be good enough :).

There is no need to remove anything from SCRATCH_DEV on cleanup, as
well as prior to actual testing.

And Dave is right, there are more tests like this which has to be fixed.

> 
> diff --git a/273 b/273
> index 2965132..4641e9d 100755
> --- a/273
> +++ b/273
> @@ -30,14 +30,7 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=0	# success is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> -
> -_cleanup()
> -{
> -	cd /
> -	rm -rf $SCRATCH_MNT/* $tmp.*
> -	_scratch_unmount
> -}
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  . ./common.rc
>  . ./common.filter
> @@ -138,7 +131,18 @@ umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
> -_do_workload
> +if ! _do_workload; then
> +	echo "workout failed"
> +	_scratch_unmount
> +	status=1
> +	exit
> +fi
> +
> +if ! _scratch_unmount; then
> +	echo "failed to umount"
> +	status=1
> +	exit
> +fi
>  
>  _check_scratch_fs
>  status=$?
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
