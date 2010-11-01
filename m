Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1MK7Gm246855 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 17:20:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C53994EE486
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 15:21:29 -0700 (PDT)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id 1TIoirrBV5YKFbi7 for
	<xfs@oss.sgi.com>; Mon, 01 Nov 2010 15:21:29 -0700 (PDT)
Message-ID: <4CCF3D68.6060201@sandeen.net>
Date: Mon, 01 Nov 2010 17:21:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair of critical volume
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
In-Reply-To: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On 10/31/10 2:54 AM, Eli Morris wrote:
> I have a large XFS filesystem (60 TB) that is composed of 5 hardware
> RAID 6 volumes. One of those volumes had several drives fail in a
> very short time and we lost that volume. However, four of the volumes
> seem OK. We are in a worse state because our backup unit failed a
> week later when four drives simultaneously went offline. So we are in
> a bad very state. I am able to mount the filesystem that consists of
> the four remaining volumes. I was thinking about running xfs_repair
> on the filesystem in hopes it would recover all the files that were
> not on the bad volume, which are obviously gone. Since our backup is
> gone, I'm very concerned about doing anything to lose the data that
> will still have. I ran xfs_repair with the -n flag and I have a
> lengthly file of things that program would do to our filesystem. I
> don't have the expertise to decipher the output and figure out if
> xfs_repair would fix the filesystem in a way that would retain our
> remaining data or if it would, let's say t!


One thing you could do is make an xfs_metadump image, xfs_mdrestore
it to a sparse file, and then do a real xfs_repair run on that.
You can then mount the repaired image and see what's there.
So from a metadata perspective, you can do a real-live repair
run on an image, and see what happens.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
