Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 330877F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 06:54:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5A45AC01C
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 04:54:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	27tymbjqSxoZ307p for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 04:54:06 -0800 (PST)
Date: Mon, 16 Dec 2013 23:54:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_REPAIR on LVM partition
Message-ID: <20131216125402.GB10988@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
	<20131216000141.GU31386@dastard>
	<CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
	<20131216030537.GX31386@dastard>
	<CAG97racd-UhUqhVLcsbjqZt51iTEaHKaQNMkvQFnznH8X8wOUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG97racd-UhUqhVLcsbjqZt51iTEaHKaQNMkvQFnznH8X8wOUQ@mail.gmail.com>
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
To: Rafael Weingartner <rafaelweingartner@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 16, 2013 at 06:52:23AM -0200, Rafael Weingartner wrote:
> What's a "RAID NAS controller"? Details, please, or we can't help
> > you.
> 
> 
> Maybe I am not expressing my self clearly. That is what I meant:
> http://www.starline.de/produkte/raid-systeme/infortrend-raid-systeme/eonstor/es-a08u-g2421/
> 
> It is a piece of hardware that we use to apply RAIDx (normally 1 or 5) over
> physical disks instead of plugging them on the storage server and applying
> RAID via software or something else. It exports the volumes using an SCSI
> channel.  The devices are seen on the server as normal sd*, as if they were
> normal physical devices.
> 
> So, hardware RAID5, lost a drive, rebuild on replace, filesystem in
> > a bad way after rebuild?
> 
> 
> That is exactly what happened, the RAID5 array lost a drive, and after we
> replaced and rebuild it, the filesystem was not mounting anymore.
> Teorically, this should not affect the filesystem since the RAID5 would
> have recovered any lost information.

In theory, yes. But we hear about "successful" hardware raid
rebuilds ifrom situations like yours that result in corrupt
filesystems. i.e. the hardware RAID rebuild didn't actually recover
properly...

So, what's the contents of the primary XFS superblock on that
device? What does this give:

# dd if=<dev> bs=512 count=1 | hexdump -C

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
