Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7ELZeGZ010613 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 16:35:40 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	exoEeL15MevfFtPo for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 14:35:39 -0700 (PDT)
Date: Wed, 15 Aug 2012 07:35:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: aborted SCSI commands while discarding/unmapping via mkfs.xfs
Message-ID: <20120814213535.GK2877@dastard>
References: <502AB82D.9090408@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <502AB82D.9090408@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: dchinner@redhat.com, Christoph Hellwig <hch@lst.de>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Aug 14, 2012 at 10:42:21PM +0200, Stefan Priebe wrote:
> Hello list,
> 
> i'm testing KVM with qemu, libiscsi, virtio-scsi-pci and
> scsi-general on top of a nexenta storage solution. While doing
> mkfs.xfs on an already used LUN / block device i discovered that the
> unmapping / discard commands mkfs.xfs sends take a long time which
> results in a lot of aborted scsi commands.

Sounds like a problem with your storage being really slow at
discards.

> Would it make sense to let mkfs.xfs send these unmapping commands in
> small portations (f.e. 100MB)

No, because the underlying implementation (blkdev_issue_discard())
already breaks the discard request up into the granularity that is
supported by the underlying storage.....

> or is there another problem in the
> patch to the block device? Any suggestions or ideas?

.... which, of course, had bugs in it so is a muchmore likely cause
of your problems.

That said,the discard granularity is derived from information the
storage supplies the kernel in it's SCSI mode page, so if the
discard granularity is too large, that's a storage problem, not a
linux problem at all, let alone a mkfs.xfs problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
