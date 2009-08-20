Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7K1bijv241908 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 20:37:55 -0500
Received: from elrond.infotech.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 819293E3731
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:38:26 -0700 (PDT)
Received: from elrond.infotech.no (smtp.infotech.no [82.134.31.41]) by
	cuda.sgi.com with ESMTP id IfrzbeMjRHB20D4x for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:38:26 -0700 (PDT)
Message-ID: <4A8CA90D.6040001@interlog.com>
Date: Wed, 19 Aug 2009 21:38:21 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu>
	<20090820010552.GA22107@infradead.org>
	<20090820011004.GC14005@shareable.org>
In-Reply-To: <20090820011004.GC14005@shareable.org>
Reply-To: dgilbert@interlog.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jamie Lokier <jamie@shareable.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>, liml@rtr.ca, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>

Jamie Lokier wrote:
> Christoph Hellwig wrote:
>>> So i'm torn about the 'syscall versus ioctl' issue, i'd 
>>> like to avoid making interface design mistakes and i'd 
>>> like to solicit some opinions about this. I've attached 
>>> the perfcounters ioctl patch below.
>> Only add a syscall if it has _one_ clear defined purpose,
>> which has kernel-wide meaning.
> 
> One clear defined purpose which comes to mind is a "trim" or "punch"
> system call, for making holes in files as well as trimming block
> devices.  Several other OSes have that capability on files.
> 
> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
> 
> It would be tidy if it does, as it could have the same meaning with files.

Both ATA and SCSI leave it up to the device to decide
whether reads after a trim on a logical block are
determinate (i.e. zeroes are returned) or indeterminate.

In the case of ATA the IDENTIFY DEVICE data word 69 bit
14 gives the indication. In the case of SCSI the
READ CAPACITY(16) command response TPRZ bit gives the
indication. In both case a value of one indicates
determinate.

Doug Gilbert


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
