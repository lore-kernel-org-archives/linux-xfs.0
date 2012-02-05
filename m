Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15957cs023636 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 03:05:08 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id MINZ7xBR8TTJIN49 for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 01:05:06 -0800 (PST)
Date: Sun, 5 Feb 2012 09:05:02 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120205090502.GA3961@nsrc.org>
References: <20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org> <20120203115434.GA649@nsrc.org>
	<4F2C38BE.2010002@hardwarefreak.com> <20120203221015.GA2675@nsrc.org>
	<4F2D016C.9020406@hardwarefreak.com> <20120204112436.GA3167@nsrc.org>
	<4F2D2953.2020906@hardwarefreak.com> <20120204200417.GA3362@nsrc.org>
	<4F2E10C1.3040200@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2E10C1.3040200@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Feb 04, 2012 at 11:16:49PM -0600, Stan Hoeppner wrote:
> When you lose a disk in this setup, how do you rebuild the replacement
> drive?  Do you simply format it and then move 3TB of data across GbE
> from other Gluster nodes?

Basically, yes. When you read a file, it causes the mirror to synchronise
that particular file. To force the whole brick to come back into sync you
run find+stat across the whole filesystem.
http://download.gluster.com/pub/gluster/glusterfs/3.2/Documentation/AG/html/sect-Administration_Guide-Managing_Volumes-Self_heal.html

> Even if the disk is only 1/3rd full, such a
> restore seems like an expensive and time consuming operation.  I'm
> thinking RAID has a significant advantage here.

Well, if you lose a 3TB disk in a RAID-1 type setup, then the whole disk has
to be copied block by block (whether it contains data or not). So the
consideration here is network bandwidth.

I am building with 10GE, but even 1G would be just about sufficient to carry
the peak bandwidth of a single one of these disks.  (dd on the raw disk
gives 120MB/s at the start and 60MB/s at the end)

The whole manageability aspect certainly needs to be considered very
seriously though.  With RAID1 or RAID10, dealing with a failed disk is
pretty much pull and plug; with Gluster we'd be looking at having to mkfs
the new filesystem, mount it at the right place, and then run the self-heal. 
This will have to be weighed against the availability advantages of being
able to take an entire storage node out of service.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
