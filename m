Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NMMif0112789 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 16:22:45 -0600
Received: from smtp2.es.uci.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1035F19907A9
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 14:22:13 -0800 (PST)
Received: from smtp2.es.uci.edu (smtp2.es.uci.edu [128.200.80.28]) by
	cuda.sgi.com with ESMTP id OAZJcGgRJKuP0hs8 for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 14:22:13 -0800 (PST)
From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
Date: Mon, 23 Feb 2009 14:24:24 -0800
References: <200902231243.33897.harry.mangalam@uci.edu>
	<200902231345.25062.harry.mangalam@uci.edu>
	<49A31AFD.8070804@sandeen.net>
In-Reply-To: <49A31AFD.8070804@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902231424.25130.harry.mangalam@uci.edu>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

mount -t xfs -o loop,offset=11403264,ro,norecovery /dev/md0 /lost

gives me a mount(!!):

df -> /lost/public, but it's not a standard entry:
?--------- ? ?    ?    ?    ? /lost/public

and dmesg coughs up many lines of XFS errors:

loop: AES key scrubbing enabled
loop: loaded (max 8 devices)
Filesystem "loop0": Disabling barriers, not supported by the 
underlying device
Mounting filesystem "loop0" in no-recovery mode.  Filesystem will be 
inconsistent.
XFS resetting qflags for filesystem loop0
xfs_force_shutdown(loop0,0x1) called from line 424 of file 
fs/xfs/xfs_rw.c.  Return address = 0xfb2fc728
Filesystem "loop0": I/O Error Detected.  Shutting down filesystem: 
loop0
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(loop0,0x1) called from line 424 of file 
fs/xfs/xfs_rw.c.  Return address = 0xfb2fc728
Filesystem "loop0": Disabling barriers, not supported by the 
underlying device
Mounting filesystem "loop0" in no-recovery mode.  Filesystem will be 
inconsistent.
XFS resetting qflags for filesystem loop0




On Monday 23 February 2009, Eric Sandeen wrote:
> try mount -o loop,offset=11403264 /dev/whatever /mnt/whatever
>
> I'd probably also add ro,norecovery to the options as well so you
> don't actually write anything to it at this point.
>
> -Eric



-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
