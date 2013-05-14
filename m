Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4AE7C7F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 16:49:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9550AC009
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 14:49:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2vLYNzhcivW9CKDE for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 14:49:10 -0700 (PDT)
Date: Wed, 15 May 2013 07:49:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 311: fsck the dmflakey device instead of the
	real device
Message-ID: <20130514214908.GL29466@dastard>
References: <1368563722-23452-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368563722-23452-1-git-send-email-jbacik@fusionio.com>
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
Cc: xfs@oss.sgi.com

On Tue, May 14, 2013 at 04:35:22PM -0400, Josef Bacik wrote:
> Dave pointed out that xfs was having issues with 311 because of caching issues.
> He suggested that I fsck the dm-flakey device to make sure we don't have this
> problem.  This is the easiest way I could think to accomplish this, please let
> me know if this is a bad idea.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/generic/311 |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/generic/311 b/tests/generic/311
> index 2b3b569..f11119b 100644
> --- a/tests/generic/311
> +++ b/tests/generic/311
> @@ -125,7 +125,10 @@ _run_test()
>  
>  	#Unmount and fsck to make sure we got a valid fs after replay
>  	_unmount_flakey
> +	tmp=$SCRATCH_DEV
> +	SCRATCH_DEV=$FLAKEY_DEV
>  	_check_scratch_fs
> +	SCRATCH_DEV=$tmp
>  	[ $? -ne 0 ] && _fatal "fsck failed"

I think this can be done with a pretty simple change to
_check_scratch_fs. i.e. pass the device to be checked in as a
parameter, and if the parameter is not set, have _check_scratch_fs
default to using $SCRATCH_DEV. It's a one-line change to 311, and
about 10 lines of (simple) change to _check_scratch_fs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
