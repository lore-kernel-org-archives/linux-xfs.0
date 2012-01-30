Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UMZiFw140060 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 16:35:44 -0600
Received: from smtp-2.hut.fi (smtp-2.hut.fi [130.233.228.92]) by cuda.sgi.com
	with ESMTP id CLbhv7WhXID97ehs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Jan 2012 14:35:42 -0800 (PST)
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q0UMZe7j019017
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 00:35:40 +0200
Received: from smtp-2.hut.fi ([130.233.228.92])
	by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new,
	port 10024) with LMTP id 12706-697 for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 00:35:39 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q0UMZTqf019010
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 00:35:29 +0200
Date: Tue, 31 Jan 2012 00:35:28 +0200
From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: xfs task blocked for more than 120 seconds
Message-ID: <20120130223527.GH10174@sli.dy.fi>
References: <20120130002026.GG10174@sli.dy.fi> <20120130010530.GI15102@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120130010530.GI15102@dastard>
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

On Mon, Jan 30, 2012 at 12:05:30PM +1100, Dave Chinner wrote:
> > * The computer is a Core i7 2600 3.4 GHz with 4 cores and HT
> >   (therefore shows as 8 cores) with 8 GiB main memory. AES-NI
> >   instructions are supported and disk crypto generally (with ext4)
> >   works at transparent speeds.
> 
> That's not to say that ext4 doesn't have long IO hold-offs - it just
> doesn't trigger the hang-check code.

Hmm, maybe. Yet 120 seconds of a blocking syscall somehow sounds quite
long to me. With ext3 I remember seeing those every now and then with
dm-crypt.

> It is definitely a possibility that dm-crypt is not keeping up with
> the IO that XFS is sending it and the way XFS blocks waiting for it
> to complete triggers the hang-check code. However, it is possible
> that XFS is stalling due to long IO completion latencies. Do the
> workloads actually complete, or does the system hang? Also, does the
> IO to the disk appear to stop for long periods, or is the disk 100%
> busy the whole time? If the disk goes idle, can you get a dump of
> the stalled processes via "echo w > /proc/sysrq-trigger" and post
> that?

The workloads do eventually complete. I tried the tar extraction again
but this time extracting the tar from a different disk and saw no such
warnings (and the time taken seems reasonable at 96 minutes).

The blocked syscalls during BackupPC backupping seems weirder to me. I
don't think the ext4 partition was even mounted at that point, and if
it was, there certainly was no activity, i.e. the XFS partition was
the only partition on that disk that saw any I/O. I'll see if I can
figure out some way to repeat that and to figure out if the disk goes
idle.

	Sami

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
