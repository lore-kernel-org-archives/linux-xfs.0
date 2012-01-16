Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GNBRXh118812 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 17:11:28 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	V0GAsbNStZTNM1HG for <xfs@oss.sgi.com>;
	Mon, 16 Jan 2012 15:11:25 -0800 (PST)
Date: Tue, 17 Jan 2012 10:11:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Optimal XFS formatting options?
Message-ID: <20120116231121.GB6922@dastard>
References: <33140169.post@talk.nabble.com>
	<4F12006F.8080805@hardwarefreak.com>
	<33145068.post@talk.nabble.com> <4F13ADF6.90903@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F13ADF6.90903@hardwarefreak.com>
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
Cc: xfs@oss.sgi.com

On Sun, Jan 15, 2012 at 10:56:22PM -0600, Stan Hoeppner wrote:
> On 1/15/2012 6:27 PM, MikeJeezy wrote:
> > I would like to align the partiton as well, but I am not sure how to acheive
> > this using parted.  This will be the only partition on the LUN, so not sure
> > if I even need to create one (although I do like to stay consistent with my
> > other volumes). 
> 
> If your drives have 512 byte physical sectors (not advanced format
> drives with 4096 byte sectors) then there is no need to worry about
> partition alignment.

That is incorrect. Partitions need to be aligned to the underlying
stripe configuration, regardless of the sector size of the drives
that make up the stripe. If you do not align the partition to the
stripe, then the filesystem will be unaligned no matter how you
configure it. Every layer of the storage stack under the filesystem
needs to be correctly aligned and sized for filesystem alignment to
make any difference to performance.

> > Any thoughts on partition alignment or
> > other thoughts in general?  Thank you.
> 
> Yes, don't use partitions if you don't need to divide your disk device
> (LUN/virtual disk) into multiple pieces.  Now, if you need to make use
> of snapshots or other volume management features, you may want to create
> an LVM device on top of the disk device (LUN) and then make your XFS on
> top of the LVM device.  If you have no need for LVM features, I'd say
> directly format the LUN with XFS, no partition table necessary.

If you use LVM, then you need to ensure that it is slicing up the
device in a manner that is aligned correctly to the underlying
stripe, just like if you are using partitions to provide the same
functionality. Different technologies, same problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
