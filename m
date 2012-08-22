Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7MKwQI2051228 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 15:58:26 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	jET0oR1TRrzjll9p (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 13:59:12 -0700 (PDT)
Received: by ghz3 with SMTP id 3so41828ghz.26
	for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 13:59:11 -0700 (PDT)
Message-ID: <5035481C.5050503@inktank.com>
Date: Wed, 22 Aug 2012 15:59:08 -0500
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: Re: xfstests: Replace lstat64 with cat in test 120
References: <20120822185456.4F189B010E6D@gulag1.americas.sgi.com>
In-Reply-To: <20120822185456.4F189B010E6D@gulag1.americas.sgi.com>
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
To: xfs@oss.sgi.com

On 08/22/2012 01:54 PM, Rich Johnston wrote:
> The later versions of libtool (i.e.2.4+) create a wrapper (bash script) for
> lstat64 in the src directory.  The wrapper calls the real binary created by
> libtool (.libs/lstat64)
> 
> Test 120 only copies src/lstat64 to $SCRATCH_MNT.  If a later version of
> libtool is used then only the wrapper is copied to $SCRATCH_MNT and the wrapper
> will fail to find .libs/lstat64.
> 
>    ~/xfstests # diff 120.out 120.out.bad
>    /mnt/scratch/lstat64: error: `/mnt/scratch/.libs/lstat64' does not exist
>    This script is just a wrapper for lstat64.
>    See the libtool documentation for more information.
> 
> This patch copies /usr/bin/cat (which is readily availible on unix systems) to
> $SCRATCH_MNT instead of src/lstat64.

I was going to suggest you use /bin/cat instead, but it appears
the actual patch does.

Please update your description.  Otherwise, looks good to me.

Reviewed-by: Alex Elder <elder@inktank.com>

> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  120 |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: b/120
> ===================================================================
> --- a/120
> +++ b/120
> @@ -68,12 +68,12 @@ fi
>  
>  #executable file
>  echo "*** copying file ***"
> -cp src/lstat64 $SCRATCH_MNT
> -src/lstat64 $SCRATCH_MNT/lstat64 >$tmp.out
> +cp /bin/cat $SCRATCH_MNT
> +src/lstat64 $SCRATCH_MNT/cat >$tmp.out
>  sleep 5
>  echo "*** executing file ***"
> -$SCRATCH_MNT/lstat64 $SCRATCH_MNT/lstat64 >/dev/null
> -_compare_access_times $SCRATCH_MNT/lstat64 "executing file"
> +$SCRATCH_MNT/cat $SCRATCH_MNT/cat >/dev/null
> +_compare_access_times $SCRATCH_MNT/cat "executing file"
>  
>  #reading file
>  echo "*** creating file ***"
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
