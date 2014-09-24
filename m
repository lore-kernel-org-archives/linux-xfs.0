Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 664587F63
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 14:15:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3757F304062
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 12:15:09 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id cw4hpCsEBB1KMHdq (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 12:15:04 -0700 (PDT)
Date: Wed, 24 Sep 2014 12:14:59 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f
In-Reply-To: <alpine.DEB.2.19.4.1406181719040.4757@trent.utfs.org>
Message-ID: <alpine.DEB.2.19.4.1409241201470.9897@trent.utfs.org>
References: <alpine.DEB.2.19.4.1406180224150.4757@trent.utfs.org>
	<20140618120124.GR9508@dastard>
	<e2537966-9b06-45eb-b2c7-dd5cffa968dd@email.android.com>
	<20140618230721.GD4453@dastard>
	<alpine.DEB.2.19.4.1406181719040.4757@trent.utfs.org>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 18 Jun 2014 at 17:22, Christian Kujau wrote:
> On Thu, 19 Jun 2014 at 09:07, Dave Chinner wrote:
> > > When the PowerPC box crashed there should not have been any i/o on
> > > the file system - so, if there was nothing to commit, clearing the
> > > log with "xfs_repair -L" should not lose any data, right?
> > 
> > In theory. use xfs_logprint to check the log is empty...
> 
> Ah - next time I'll use that. I was too impatient and went with 
> "-L" and now the filesystem could be mounted. All is good.

My PowerBook G4 is offline again (rats!) and again I connected this disk 
to an i686 laptop. Trying to mount fails again, because the XFS file system 
was not unmounted properly and the i686 laptop cannot read the big-endian 
XFS log. OK, no biggie, this had been explained earlier. I just wanted to 
share the xfs_logprint(8) output of this filesystem and I haven't cleared 
the log yet - just in case anyone wants to play around with that some 
more:

# xfs_logprint /dev/mapper/wdc1 
xfs_logprint:
    data device: 0xfd03
    log device: 0xfd03 daddr: 976762064 length: 262144

cycle: 1        version: 2              lsn: 1,0        tail_lsn: 1,0
length of Log Record: 20        prev offset: -1         num ops: 1
uuid: 3f121b9a-19e9-4cc8-97ba-86ec62240026   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: b0c0d0d0  len: 8  clientid: LOG  flags: UNMOUNT 
Unmount filesystem

============================================================================
cycle: 1        version: 2              lsn: 1,2        tail_lsn: 1,2
length of Log Record: 512       prev offset: 0          num ops: 5
uuid: 3f121b9a-19e9-4cc8-97ba-86ec62240026   format: big endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 4029c0bb  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: 4029c0bb  len: 16  clientid: TRANS  flags: none
xfs_logprint: unknown log operation type (5254)
**********************************************************************
* ERROR: data block=2                                                 *
**********************************************************************
Bad data in log



When the PowerPC crashed, the XFS file system was mounte read-write but 
no writes should have been active, only read operations at best.

I'll probably clear the log tomorrow. And yes, this might be a more exotic
scenario so don't bother with code fixes, I just wanted this to be 
somewhat documented in the archives.

Cheers,
Christian.

# mount -t xfs -o ro /dev/mapper/wdc1 /mnt
# dmesg
[...]
 XFS (dm-3): Mounting V4 Filesystem
 XFS (dm-3): Starting recovery (logdev: internal)
 XFS (dm-3): log record CRC mismatch: found 0xbb3995f5, expected 0x6e17c591.
 fa400000: 00 00 00 01 00 00 00 00 69 01 00 00 8e 6c 64 e0  ........i....ld.
 fa400010: 00 00 00 10 69 00 00 00 54 52 41 4e 00 00 00 2a  ....i...TRAN...*
 XFS (dm-3): dirty log written in incompatible format - can't recover
 XFS (dm-3): log mount/recovery failed: error 5
 XFS (dm-3): log mount failed

> Now I only have to make sure to cleanly unmount from the i686 box 
> once my PowerPC system is back online :-)
> 
> Thanks you!
> Christian.
> -- 
> BOFH excuse #25:
> 
> Decreasing electron flux
-- 
BOFH excuse #334:

50% of the manual is in .pdf readme files

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
