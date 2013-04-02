Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9AFB87F72
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 04:31:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B6A930406A
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 02:31:09 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id Or4BlyxSZk1YIl9b for
	<xfs@oss.sgi.com>; Tue, 02 Apr 2013 02:31:08 -0700 (PDT)
Date: Tue, 2 Apr 2013 05:31:06 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <985125161.581860.1364895066584.JavaMail.root@redhat.com>
In-Reply-To: <20130402090047.GF3670@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
	<247719576.438259.1364882929749.JavaMail.root@redhat.com>
	<20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk>
	<20130402073035.GD3670@kernel.dk>
	<14055702.547701.1364891947331.JavaMail.root@redhat.com>
	<20130402090047.GF3670@kernel.dk>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com



----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Dave Chinner" <david@fromorbit.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> Sent: Tuesday, April 2, 2013 5:00:47 PM
> Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> 
> On Tue, Apr 02 2013, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Jens Axboe" <axboe@kernel.dk>
> > > To: "Dave Chinner" <david@fromorbit.com>
> > > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML"
> > > <linux-kernel@vger.kernel.org>
> > > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5
> > > running xfstests case #78]
> > > 
> > > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > > [Added jens Axboe to CC]
> > > > > 
> > > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > > kernel
> > > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > > like
> > > > > > something new broke this. Log is here with sysrq debug info.
> > > > > > http://people.redhat.com/qcai/stable/log
> > > > 
> > > > CAI Qian, can you try and back the below out and test again?
> > > 
> > > Nevermind, it's clearly that one. The below should improve the
> > > situation, but it's not pretty. A better fix would be to allow
> > > auto-deletion even if PART_NO_SCAN is set.
> > Jens, when compiled the mainline (up to fefcdbe) with this patch,
> > it error-ed out,
> 
> Looks like I sent the wrong one, updated below.
The patch works well. Thanks!
CAI Qian
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index fe5f640..faa3afa 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1057,14 +1057,15 @@ static int loop_clr_fd(struct loop_device *lo)
>  		struct disk_part_iter piter;
>  		struct hd_struct *part;
>  
> -		mutex_lock_nested(&bdev->bd_mutex, 1);
> -		invalidate_partition(bdev->bd_disk, 0);
> -		disk_part_iter_init(&piter, bdev->bd_disk,
> -					DISK_PITER_INCL_EMPTY);
> -		while ((part = disk_part_iter_next(&piter)))
> -			delete_partition(bdev->bd_disk, part->partno);
> -		disk_part_iter_exit(&piter);
> -		mutex_unlock(&bdev->bd_mutex);
> +		if (mutex_trylock(&bdev->bd_mutex)) {
> +			invalidate_partition(bdev->bd_disk, 0);
> +			disk_part_iter_init(&piter, bdev->bd_disk,
> +						DISK_PITER_INCL_EMPTY);
> +			while ((part = disk_part_iter_next(&piter)))
> +				delete_partition(bdev->bd_disk, part->partno);
> +			disk_part_iter_exit(&piter);
> +			mutex_unlock(&bdev->bd_mutex);
> +		}
>  	}
>  
>  	/*
> 
> --
> Jens Axboe
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
