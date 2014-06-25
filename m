Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29BDA7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 17:00:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0DDD304048
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 15:00:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WzwgZKe19Mi9zmMK for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 15:00:07 -0700 (PDT)
Date: Thu, 26 Jun 2014 07:59:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS CRC errors after a crash
Message-ID: <20140625215952.GM9508@dastard>
References: <20140625164939.GA27620@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140625164939.GA27620@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Jun 25, 2014 at 06:49:39PM +0200, Jan Kara wrote:
>   Hello,
> 
>   so I've been crash-testing XFS (just killing KVM with XFS filesystem
> mounted) a bit with V5 superblock enabled in 3.16-rc1 and I can pretty
> easily hit CRC mismatches after that. Kernel complains like:

Yes, we had that reported yesterday by another person, using virtual
box. I've been unable to reproduce it on my local KVM VMs, so I'm
wondering what your configuration KVM configuration is?

> [518184.794175] XFS (sdb3): Mounting V5 Filesystem
> [518184.902898] XFS (sdb3): Starting recovery (logdev: internal)
> [518187.118860] XFS (sdb3): Metadata CRC error detected at xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1
> [518187.118870] XFS (sdb3): Unmount and run xfs_repair
> [518187.118875] XFS (sdb3): First 64 bytes of corrupted metadata buffer:
> [518187.118882] ffff880136ffd600: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f aa 40  XAGF...........@
> [518187.118887] ffff880136ffd610: 00 02 6d 53 00 02 77 f8 00 00 00 00 00 00 00 01  ..mS..w.........
> [518187.118891] ffff880136ffd620: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 03  ................
> [518187.118895] ffff880136ffd630: 00 00 00 04 00 08 81 d0 00 08 81 a7 00 00 00 00  ................
> [518187.118923] XFS (sdb3): metadata I/O error: block 0x1 ("xfs_trans_read_buf_map") error 74 numblks 1
> 
> So it seem like the checksum doesn't get updated properly in all the cases.
> Looking into the logdump, there doesn't seem to be any modifications for
> this AGF block in unrelayed part of the log but there are some modifications
> in the older parts of the log - the latest LSN where block 1 was updated is
> 1,4639 (and the buffer contents in the log corresponds to the data I see in
> block 1). However the lsn field in AGF structure in that block shows 1,3616
> so that really seems stale (and I've checked and in that transaction the
> block has been modified as well).

That tallies with what has been reported -it was the AGI block,
however. What I know so far is that the CRC matches for the version
of the structure logged at the apparent LSN, but the data is more
recent.

Now the only way I can see the data getting updated without the LSN
being updates is through log recovery, the analysis is here:

http://oss.sgi.com/pipermail/xfs/2014-June/036938.html

At the bottom of the email is a request for a information resulting
from a reproduction cycle. Can you run that cycle and provide the
metadumps and dmesg when a problem is first found?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
