Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 21:43:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3N4h0RD020431
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 21:43:02 -0700
Subject: Re: [PATCH, XFSQA] Use XFS_IO_PROG in 164 and 165
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080423015713.GL103491721@sgi.com>
Date: Wed, 23 Apr 2008 14:44:29 +1000
Message-ID: <op.t91rgfck3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080423015713.GL103491721@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, 23 Apr 2008 11:57:13 +1000, David Chinner <dgc@sgi.com> wrote:

> We should be using $XFS_IO_PROG rather than calling the binary
> directly and assuming that the path is picking up the right test binary.

Yep, OK. I'm sure there's plenty of other ones with other xfsprogs too.

> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/164 |   24 ++++++++++++------------
>  xfstests/165 |   16 ++++++++--------
>  2 files changed, 20 insertions(+), 20 deletions(-)
>
> Index: xfs-cmds/xfstests/164
> ===================================================================
> --- xfs-cmds.orig/xfstests/164	2007-08-24 14:19:48.000000000 +1000
> +++ xfs-cmds/xfstests/164	2008-04-23 11:53:31.821494444 +1000
> @@ -64,36 +64,36 @@ _test_eof_hole()
>  {
>  	# on a BB boundary
>  	rm -f $testfile
> -	xfs_io -f -d \
> +	$XFS_IO_PROG -f -d \
>  		  -c 'pwrite -b 50k 0 50k' \
>  		  -c 'truncate 100k' \
>                    -c 'pread -b 200k 0 200k' \
>  		  $testfile | _filter_io
> -	xfs_io -c 'bmap -vp' $testfile | _filter_bmap
> +	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
>  	echo ""
> 	# on an odd byte boundary => 1 short of boundary
>  	rm -f $testfile
>  	boundary_minus1=`expr 100 \* 1024 - 1`
>  	echo "boundary_minus1 = $boundary_minus1"
> -	xfs_io -f -d \
> +	$XFS_IO_PROG -f -d \
>  		  -c 'pwrite -b 50k 0 50k' \
>  		  -c "truncate $boundary_minus1" \
>                    -c 'pread -b 200k 0 200k' \
>  		  $testfile | _filter_io
> -	xfs_io -c 'bmap -vp' $testfile | _filter_bmap
> +	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
>  	echo ""
> 	# on an odd byte boundary => 1 over boundary
>  	rm -f $testfile
>  	boundary_plus1=`expr 100 \* 1024 + 1`
>  	echo "boundary_plus1 = $boundary_plus1"
> -	xfs_io -f -d \
> +	$XFS_IO_PROG -f -d \
>  		  -c 'pwrite -b 50k 0 50k' \
>  		  -c "truncate $boundary_plus1" \
>                    -c 'pread -b 200k 0 200k' \
>  		  $testfile | _filter_io
> -	xfs_io -c 'bmap -vp' $testfile | _filter_bmap
> +	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
>  	echo ""
>  }
> @@ -101,39 +101,39 @@ _test_eof_unwritten_extent()
>  {
>  	# on a BB boundary
>  	rm -f $testfile
> -	xfs_io -f -d \
> +	$XFS_IO_PROG -f -d \
>  		  -c 'resvsp 0 100k' \
>  		  -c 'truncate 100k' \
>  		  -c 'pwrite -b 50k 0 50k' \
>                    -c 'pread -b 200k 0 200k' \
>  		  $testfile | _filter_io
> -	xfs_io -c 'bmap -vp' $testfile | _filter_bmap
> +	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
>  	echo ""
> 	# on an odd byte boundary => 1 short of boundary
>  	rm -f $testfile
>  	boundary_minus1=`expr 100 \* 1024 - 1`
>  	echo "boundary_minus1 = $boundary_minus1"
> -	xfs_io -f -d \
> +	$XFS_IO_PROG -f -d \
>  		  -c "resvsp 0 $boundary_minus1" \
>  		  -c "truncate $boundary_minus1" \
>  		  -c 'pwrite -b 50k 0 50k' \
>                    -c 'pread -b 200k 0 200k' \
>  		$testfile | _filter_io
> -	xfs_io -c 'bmap -vp' $testfile | _filter_bmap
> +	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
>  	echo ""
> 	# on an odd byte boundary => 1 over boundary
>  	rm -f $testfile
>  	boundary_plus1=`expr 100 \* 1024 + 1`
>  	echo "boundary_plus1 = $boundary_plus1"
> -	xfs_io -f -d \
> +	$XFS_IO_PROG -f -d \
>  		  -c "resvsp 0 $boundary_plus1" \
>  		  -c "truncate $boundary_plus1" \
>  		  -c 'pwrite -b 50k 0 50k' \
>                    -c 'pread -b 200k 0 200k' \
>  		  $testfile | _filter_io
> -	xfs_io -c 'bmap -vp' $testfile | _filter_bmap
> +	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
>  	echo ""
>  }
> Index: xfs-cmds/xfstests/165
> ===================================================================
> --- xfs-cmds.orig/xfstests/165	2007-04-20 20:28:54.000000000 +1000
> +++ xfs-cmds/xfstests/165	2008-04-23 11:53:56.350340350 +1000
> @@ -68,10 +68,10 @@ len=4
>  end=`expr 10 \* $len`
> # Other test...
> -#xfs_io -f -c "resvsp ${off}k ${end}k" $testfile
> +#$XFS_IO_PROG -f -c "resvsp ${off}k ${end}k" $testfile
> # write the initial file
> -xfs_io -f -c "pwrite 0  ${end}k" $testfile | _filter_io
> +$XFS_IO_PROG -f -c "pwrite 0  ${end}k" $testfile | _filter_io
> off=0
> @@ -80,7 +80,7 @@ do
>  	offset=${off}k
>  	length=${len}k
> -	xfs_io -c "unresvsp $offset $length" -c "bmap -vp" $testfile |  
> _filter_bmap
> +	$XFS_IO_PROG -c "unresvsp $offset $length" -c "bmap -vp" $testfile |  
> _filter_bmap
> 	off=`expr $off + $len` # skip over 1
>  	off=`expr $off + $len`
> @@ -97,18 +97,18 @@ do
>  	echo ""
> 	# prealloc and write
> -	xfs_io -d -c "resvsp $offset $length" -c "pwrite -b $bufsize $offset  
> $length" $testfile | _filter_io
> +	$XFS_IO_PROG -d -c "resvsp $offset $length" -c "pwrite -b $bufsize  
> $offset $length" $testfile | _filter_io
> 	# Other tests...
> -	#xfs_io -c "resvsp $offset $length" $testfile
> +	#$XFS_IO_PROG -c "resvsp $offset $length" $testfile
>  	#xfs_bmap -v -p $testfile
> -	#xfs_io -d -c "pwrite -b $bufsize $offset $length" $testfile
> +	#$XFS_IO_PROG -d -c "pwrite -b $bufsize $offset $length" $testfile
>  	#xfs_bmap -v -p $testfile
> -	xfs_io -r -c "pread -v -b $bufsize $offset $length" $testfile  
> >$tmp.$off &
> +	$XFS_IO_PROG -r -c "pread -v -b $bufsize $offset $length" $testfile  
> >$tmp.$off &
> 	# Other tests...
> -	#xfs_io -r -c "pread -v -b $bufsize $offset $length" $testfile
> +	#$XFS_IO_PROG -r -c "pread -v -b $bufsize $offset $length" $testfile
>          #sleep 5
> 	off=`expr $off + $len` # skip over 1
