Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UHNucW091551 for <xfs@OSS.SGI.com>; Mon, 30 Jan 2012 11:23:56 -0600
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	AjvbSLyaqBB6jDl9 for <xfs@OSS.SGI.com>;
	Mon, 30 Jan 2012 09:23:54 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB647400C5C402 for xfs@OSS.SGI.com; Mon, 30 Jan 2012 17:23:52 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RruxI-0003Mh-4k
	for <xfs@OSS.SGI.com>; Mon, 30 Jan 2012 17:23:48 +0000
MIME-Version: 1.0
Message-ID: <20262.53793.852781.185079@tree.ty.sabi.co.UK>
Date: Mon, 30 Jan 2012 17:23:45 +0000
Subject: Re: File system remain unresponsive until the system is rebooted.
In-Reply-To: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> We are using RAID-0 volumes as PV's in our LVM stack and XFS
> as the filesystem.

LVM is in general a bad idea, and I have found that it
occasionally interacts not so well with XFS and other
filesystems under resource pressure.

It also seems from one of the backtraces that you are
complicating all this further by running under Xen,
perhaps on sparsely allocated virtual disks.

> [ ... ] The files system remained unresponsive until we
> rebooted the system and again increased the size of the
> filesystem. [ ... ]

Good luck. I know some people who also went the whole VM/LVM/XFS
stack way and had lots of problems. It is what I call the
"syntactic" approach: expecting that every syntactically valid
combination of features is going to work, and work well. Sure it
should :-).

Most of the hangs seem to happen during resource allocation,
and at least one is triggered by the flusher:

> Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550853] [<ffffffff8111241b>] bdi_writeback_task+0x4b/0xe0
> Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550858] [<ffffffff810c72f0>] ? bdi_start_fn+0x0/0x110
> Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550861] [<ffffffff810c7371>] bdi_start_fn+0x81/0x110
> Jan 26 03:05:47 ip-10-0-1-153 kernel: [241565.550863] [<ffffffff810c72f0>] ? bdi_start_fn+0x0/0x110

It could be that there is intense pressure on kernel memory,
often due to excessively loose flusher parameters.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
