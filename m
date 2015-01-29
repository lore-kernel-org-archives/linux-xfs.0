Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 472C47F9E
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:18:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27DC5304051
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 12:18:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 63lR3o9eKoSU4hsB for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 12:18:15 -0800 (PST)
Message-ID: <54CA9586.1010607@sandeen.net>
Date: Thu, 29 Jan 2015 14:18:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unable to mount and repair filesystems
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
In-Reply-To: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
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
To: Gerard Beekmans <GBeekmans@tsag.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/29/15 11:36 AM, Gerard Beekmans wrote:
> Hi,
>
> One of our VMware VMs crashed which has resulted in a few XFS filesystems unable to mount and be repaired.
>
> Some VM details:
> -          Distribution is CentOS 7
> -          Partitions reside inside LVM
> -          Tried CentOS provided xfsprogs-3.2.0-alpha2 as well as manually compiling 3.2.2
>
> When attempting to mount:
>
> [71895.922382] XFS (dm-9): Mounting Filesystem
> [71895.994614] XFS (dm-9): Starting recovery (logdev: internal)
> [71896.000910] XFS (dm-9): Metadata corruption detected at xfs_agf_read_verify+0x70/0x120 [xfs], block 0x753001
> [71896.002304] XFS (dm-9): Unmount and run xfs_repair
> [71896.003649] XFS (dm-9): First 64 bytes of corrupted metadata buffer:
> [71896.005049] ffff8800b1200c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [71896.006468] ffff8800b1200c10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [71896.007799] ffff8800b1200c20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [71896.009116] ffff8800b1200c30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

all zeros...

> [71896.010482] XFS (dm-9): metadata I/O error: block 0x753001 ("xfs_trans_read_buf_map") error 117 numblks 1
> mount: mount /dev/mapper/data-srv on /srv failed: Structure needs cleaning
>
>
> xfs_repair:
>
> xfs_repair /dev/mapper/data-srv
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - bad magic number !!!

bad first block, too.

Are you certain that the volume / storage behind dm-9 is in decent shape?  (i.e. is it really even an xfs filesystem?)

A VM crashing definitely should not result in a badly corrupt/unmountable filesystem.

Is there any other interesting part of the story? :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
