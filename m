Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RKgrf6249323 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 14:42:53 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id IazW9526j1OzgBqd for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 12:42:52 -0800 (PST)
Message-ID: <4F230C4B.2010200@sandeen.net>
Date: Fri, 27 Jan 2012 14:42:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 273 274 275: do test in dedicated dir and leave
	test files in it
References: <1326388815-21181-1-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1326388815-21181-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs@oss.sgi.com

On 1/12/12 11:20 AM, Eryu Guan wrote:
> Do all testings in dedicated dir($SCRATCH_MNT/$seq) instead of
> $SCRATCH_MNT and don't remove test files in _cleanup() for debug
> purpose.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
...

> diff --git a/274 b/274
> index b658004..c351c40 100755
> --- a/274
> +++ b/274
> @@ -35,13 +35,15 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>  	cd /
> -	rm -f $SCRATCH_MNT/* $tmp.*
> +	rm -f $tmp.*
>  	_scratch_unmount
>  }
>  
>  . ./common.rc
>  . ./common.filter
>  
> +WORK_DIR="$SCRATCH_MNT/$seq"
> +
>  # real QA test starts here
>  _supported_fs generic
>  _supported_os IRIX Linux
> @@ -57,8 +59,9 @@ umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
> -rm -rf $SCRATCH_MNT/*
> -cd $SCRATCH_MNT
> +rm -rf $WORK_DIR
> +mkdir -p $WORK_DIR
> +cd $WORK_DIR

I think this test could use more work; for one, I don't like cd-ing into
the dir, because then if you send output to $seq.full it doesn't go
where you expect it.  I'd rather not cd, and:

>  dd if=/dev/zero of=test bs=4K count=1 >/dev/null 2>&1

dd if=/dev/zero of=$WORK_DIR/test bs=4K count=1 >/dev/null 2>&1

then specify the full path to the files instead.

TBH I'm still trying to work out what exactly 274 is supposed to test;
there are no comments about the behavior other than:

# preallocation test

As a general plea to those writing tests, _please_ include a concise
but descriptive comment at the top so that the user knows just what
the test tests, and how it tests it.  Inline comments help too;
bash isn't always so easy to read.

I'm thinking that an overhaul for 273 and 274 like I did for
275 might be in order...

-Eric

>  if [ $? -ne 0 ]
>  then
> diff --git a/275 b/275
> index 214262e..7a4d414 100755
> --- a/275
> +++ b/275
> @@ -36,13 +36,15 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>  	cd /
> -	rm -f $SCRATCH_MNT/* $tmp.*
> +	rm -f $tmp.*
>  	_scratch_unmount
>  }
>  
>  . ./common.rc
>  . ./common.filter
>  
> +WORK_DIR="$SCRATCH_MNT/$seq"
> +
>  # real QA test starts here
>  _supported_fs generic
>  _supported_os IRIX Linux
> @@ -58,8 +60,9 @@ umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
> -rm -rf $SCRATCH_MNT/*
> -cd $SCRATCH_MNT
> +rm -rf $WORK_DIR
> +mkdir -p $WORK_DIR
> +cd $WORK_DIR
>  
>  dd if=/dev/zero of=tmp1 bs=4K count=1 >/dev/null 2>&1
>  if [ $? -ne 0 ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
