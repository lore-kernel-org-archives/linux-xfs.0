Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DFQ9I5067609 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 10:26:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 054651ED996D
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:26:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	khrqzjA3wiaoOIXm for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 08:26:08 -0700 (PDT)
Date: Tue, 13 Sep 2011 11:26:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: Observed Crash followed by deadlock of khubd/sync/XFS
Message-ID: <20110913152607.GA21460@infradead.org>
References: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
	<CADDb1s2S9R5RoaJ2NGSbCXORngx8PQVB6r3-QVJbjCUYh+B63Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s2S9R5RoaJ2NGSbCXORngx8PQVB6r3-QVJbjCUYh+B63Q@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 08, 2011 at 10:58:35PM +0530, Amit Sahrawat wrote:
> Since this is very hard to reproduce, to make it easy to debug. This
> can be reproduce by introducing msleep in the kernel xfs_umountfs()
> before xfs_log_sbcount(), just add a print before this function and
> sleep and the moment the print appear unplug the USB device, same
> scenario will be reproduced.
> CRASH will show the backtrace and return to normal shell, but when
> process state is checked, khubd will be shown in TASK-UNINTERRUPTIBLE
> state 'D'.
> Further if sync is issued that will also get converted to 'D' state,
> the back-trace for each of the task is same as mentioned in the
> previous mail.

I've not been able to reproduce this using that method so far.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
