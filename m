Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FFk98L195678 for <xfs@oss.sgi.com>; Tue, 15 May 2012 10:46:10 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Vu2MDNHUMPA4c1OS for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 08:46:08 -0700 (PDT)
Message-ID: <4FB27A3F.9060902@sandeen.net>
Date: Tue, 15 May 2012 10:46:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 V2] xfstests 273: fix of reading scratch size and
	removing lost+found
References: <1335521240-24098-1-git-send-email-tmarek@redhat.com>
	<1335521240-24098-2-git-send-email-tmarek@redhat.com>
In-Reply-To: <1335521240-24098-2-git-send-email-tmarek@redhat.com>
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
To: Tom Marek <tmarek@redhat.com>
Cc: lczerner@redhat.com, dchinner@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On 4/27/12 5:07 AM, Tom Marek wrote:
> There were two reasons why test 273 was failing. Firstrly, when running on
> ext4 fs it was removing everything from SCRATCH_MNT directory at the beginning
> of tests including the lost+found directory. This caused error while checking
> scratch fs after finishing test. Secondly, obtaining of the partition size was
> not counting with with behaviour of df utility which may split the line containg
> informations about one partition when it is too long thus it may have returned
> nothing.
> 
> First problem was solved with removing all unnecessary rm -rf commands and the
> second one was fixed with alternative awk script which is able to deal with
> any line splitting possible. Also 'umount $SCRATCH_DEV' was substituted for
> '_scratch_unmount'.
> 
> Cc: sandeen@sandeen.net
> Signed-off-by: Tom Marek <tmarek@redhat.com>

Looks fine, I'll merge this today, sorry for the delay.

(I'm curious though, why was the df line so long?  And is this the only test
which has that problem?  Maybe all that awk should go to a helper if any
other test needs it)

-Eric

> ---
> V2: cleaning of $SCRATCH_MNT removed from cleanup()
> 
>  273 |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/273 b/273
> index 2965132..da9172d 100755
> --- a/273
> +++ b/273
> @@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>  	cd /
> -	rm -rf $SCRATCH_MNT/* $tmp.*
> +	rm -rf $tmp.*
>  	_scratch_unmount
>  }
>  
> @@ -68,7 +68,7 @@ _file_create()
>  
>  	cd $SCRATCH_MNT/origin
>  
> -	_disksize=`df --block-size=1 | grep $SCRATCH_DEV | awk '{print $2}'`
> +	_disksize=`df --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
>  	_disksize=$(($_disksize / 3))
>  	_num=$(($_disksize / $count / $threads / 4096))
>  	_count=$count
> @@ -106,8 +106,6 @@ _do_workload()
>  	_pids=""
>  	_pid=1
>  	
> -	rm -rf $SCRATCH_MNT/*
> -
>  	_threads_set
>  	_file_create
>  
> @@ -134,7 +132,7 @@ echo "------------------------------"
>  
>  rm -f $seq.full
>  
> -umount $SCRATCH_DEV 2>/dev/null
> +_scratch_unmount 2>/dev/null
>  _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
