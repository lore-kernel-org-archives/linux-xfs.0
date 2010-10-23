Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9NLRfRq066064 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 16:27:41 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DB0EE364AD
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 14:44:15 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7KGcjGJJDbp7BmBt
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 14:44:15 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DD3D26C102
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 16:28:55 -0500 (CDT)
Message-ID: <4CC35398.6000308@hardwarefreak.com>
Date: Sat, 23 Oct 2010 16:28:56 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Best filesystems ?
References: <4CBE2403.8070108@hardwarefreak.com>	<20101019234217.GD12506@dastard>	<19646.55189.843933.481529@tree.ty.sabi.co.uk>	<20101021020009.GG12506@dastard>	<19648.27859.799400.168394@tree.ty.sabi.co.uk>	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
	<19651.9652.631329.903552@tree.ty.sabi.co.uk>
In-Reply-To: <19651.9652.631329.903552@tree.ty.sabi.co.uk>
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
To: xfs@oss.sgi.com

Peter Grandi put forth on 10/23/2010 1:13 PM:

> * XFS is like JFS, and with somewhat higher scalability both as to
>   sizes and as to higher internal parallelism in the of multiple
>   processes accessing the same file, and has a couple of nice
>   features (mostly barrier support, but also small blocks and large
>   inodes). Its major limitation are internal complexity and should
>   only be used on 64b systems. It can support single filesystems
>   larger than 10-15TB, but that's stretching things.

I'm surprised you mentioned Lustre and not CXFS, especially given the
mailing list you posted this diatribe to.  Beasts of a different breed,
but both cluster oriented.  And, apparently you're not familiar with
NASA Advanced Supercomputing (NAS) Division at Ames Research Center.
They've got some multi hundred terabyte filesystems to show you:

http://www.nas.nasa.gov/Resources/Systems/archive_storage.html

> * Lustre works well as a network parallel large file streaming
>   filesystem. It is however somewhat unstable and great care has to
>   be taken in integration testing because of that.

Integration testing?  I guess you mean the linkers and compilers on the
build machines?  The Lustre client library gets linked directly into
every application that runs on the compute nodes--it's entirely user
space code.  Or at least this is the way it used to be IIRC.  To do any
general work with the files (move/copy/etc) you had to log onto an
object storage server node.  Maybe this has changed with newer revs.

> I currently think that JFS, XFS and Lustre cover more or less all
> common workloads. 

I'll agree with the first two, but Lustre isn't used for "common"
workloads.  See above.

> I occasionally use 'ext2' or NTFS for data
> exchange between Linux and MS-Windows.

Most people use Samba, C/DVD-Rs, or thumb drives for this purpose.  If
you have _that_ much data to move between systems, Samba over GigE
yields similar throughput to mounting a USB or eSATA disk, without the
hassle.  If Samba throws up a wall and you can't tune settings around
it, use rsync or something similar.  Dragging HDs between systems is
so... 80s. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
