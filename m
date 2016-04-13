Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C9157CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 23:51:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 211258F8037
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:51:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jave1Q0dEiGiWl4i for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 21:51:33 -0700 (PDT)
Date: Wed, 13 Apr 2016 14:51:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair fails after trying to format log cycle?
Message-ID: <20160413045129.GO567@dastard>
References: <56F6DE67.60403@shaw.ca> <20160328085541.GA27040@bfoster.bfoster>
	<570C8D4D.3060304@shaw.ca> <20160412140512.GA59690@bfoster.bfoster>
	<570D578D.5010706@shaw.ca> <570DB6CD.1000007@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <570DB6CD.1000007@shaw.ca>
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
To: Andrew Ryder <tireman@shaw.ca>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 11:02:37PM -0400, Andrew Ryder wrote:
> Is it possible the location its searching for at block
> 
> 02:34:43.887528 pread64(4, 0x7fb8f53e0200, 2097152, 3001552175104) =
> -1 EIO (Input/output error)

so offset is 3001552175104, or roughly around the 3TB mark. Given
the log i always placed int eh middle of the filesystem and you have
a 6TB device, then the above definitely looks like a valid place to
be reading from the log.

> xfs_logprint:
>     data device: 0x902
>     log device: 0x902 daddr: 5860130880 length: 4173824

daddr converted to offset is 5860130880 * 512 = 3001552175104, which
tells us that the above pread64 failure was definitely coming from
an attempt to read the log.

That this is coming from the block device from userspace indicates a
problem below XFS. There is something going wrong with your
underlying block device and/or hardware here; AFAICT it's not
related to XFS at all.

> >GNU Parted 3.2
> >Using /dev/sdk
> >Welcome to GNU Parted! Type 'help' to view a list of commands.
> >(parted) p
> >Model: ATA ST2000DL001-9VT1 (scsi)
> >Disk /dev/sdk: 2000GB
> >Sector size (logical/physical): 512B/512B
> >Partition Table: msdos
> >Disk Flags:
> >
> >Number  Start  End     Size    Type     File system  Flags
> >  1      512B   2000GB  2000GB  primary               raid
> >Number  Start  End          Size         Type     File system  Flags
> >  1      1s     3907029167s  3907029167s  primary               raid

Compared to the other devices, it has a different start sector, a
different size, and an msdos partition table rather than gpt.
Definitely a red flag...

> >>>This all began when the RR2722 driver running under 3.18.15
> >>>complained and

Reported physical IO errors to a write command. Really, this looks
like a hardware issue, not something that can be fixed by running
xfs_repair...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
