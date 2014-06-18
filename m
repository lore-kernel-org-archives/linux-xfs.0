Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA7557F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 07:01:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A79BC8F8059
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 05:01:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IhTm6bA5HjjV8fVS for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 05:01:26 -0700 (PDT)
Date: Wed, 18 Jun 2014 22:01:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f
Message-ID: <20140618120124.GR9508@dastard>
References: <alpine.DEB.2.19.4.1406180224150.4757@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1406180224150.4757@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 18, 2014 at 02:44:27AM -0700, Christian Kujau wrote:
> Hi,
> 
> this PowerBook G4 crashed (power supply failed) and now I have to wait a 
> few days until the new PSU arrives. In the meantime I attached its 
> external disks to an Intel Atom machine (i686) and wanted to mount the 
> disks:

The XFS transactions in the log are not endian neutral - they are
written in the endian format of the current CPU. PowerBook G4 is a
ppc chip which is big endian, intel atom is little endian.

The log headers are always big endian, and they have a field in
the header to determine the endianness of the contents of the log
records...

> # mount -t xfs /dev/mapper/wdc1 /mnt/media
> mount: /dev/mapper/wdc1: can't read superblock
> 
> In dmesg:
> 
> XFS (dm-3): Mounting Filesystem
> XFS (dm-3): Starting recovery (logdev: internal)
> XFS (dm-3): log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f.
> f8808000: 00 00 00 01 00 00 00 00 69 01 00 00 76 63 5a 10  ........i...vcZ.
> f8808010: 00 00 00 10 69 00 00 00 54 52 41 4e 00 00 00 2a  ....i...TRAN...*
> XFS (dm-3): dirty log written in incompatible format - can't recover
> XFS (dm-3): log mount/recovery failed: error 5
> XFS (dm-3): log mount failed

	if (unlikely(head->h_fmt != cpu_to_be32(XLOG_FMT))) {
                xfs_warn(mp,
        "dirty log written in incompatible format - can't recover");

#ifdef XFS_NATIVE_HOST
#define XLOG_FMT XLOG_FMT_LINUX_BE
#else
#define XLOG_FMT XLOG_FMT_LINUX_LE
#endif

So that's exactly what I'd expect to see from filesystem with the
wrong endianness in the log.

> Note: /dev/mapper/wdc1 is a dm-crypt device, not sure if this matters 
> though.
> 
> Running "xfs_repair -n /dev/mapper/wdc1" came back with an exit code of 
> "0" and did not report anything unusual (attached below).
> 
> Running xfs_repair (v3.2.0 from Fedora 20) *without* "-n" warns that the 
> filesystem has valuable metadata changes and advises to mount it first. Or 
> use "xfs_repair -L" to clear the log, but I have not done this just yet.

"-n" simply ignores what is in the log.

> I *think* I have mounted the same filesystem before on this i686 system 
> (some weeks ago) but then the filesystem got umounted cleanly from the 
> PowerPC system, where this disk is attached to usually.

Yes, that's the only way to safely move a filesystem between
machines of different endianness - a clean log has nothing to
replay, so no endian problems and all new records will be written
according to the endianness of the host the filesystem is currently
mounted on.

> Could it be that endianess has something to do with it? The PowerPC is 
> big-endian I think, and the i686 Laptop is little-endian. Even though I'm 
> almost certain that I've mounted the disk before, now that the filesystem 
> needs to be recovered first, maybe endianess matters now?

Always has mattered for the log. We're slowly moving the structure
of the internal code to be able to fix the endianess of the
transaction contents, but we're not really in any hurry given most
archs are moving to be little endian anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
