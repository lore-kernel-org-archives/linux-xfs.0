Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ0ophp022766
	for <linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 18:50:51 -0600
Message-ID: <492C9D65.2080302@sgi.com>
Date: Wed, 26 Nov 2008 11:50:45 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Badness in key lookup (length)
References: <200811252302.55944.Martin@Lichtvoll.de>
In-Reply-To: <200811252302.55944.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@Lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Hi!
> 
> I also checked my / XFS filesystem after that failed attempt to hibernate 
> via TuxOnIce (see my mail "truncated files"). Well BTW this happened on a 
> ThinkPad T42.
> 
> While /home was fine, / had some rather minor - it seems - issues. Whether 
> they have been from today or from whenever - I do not know.
> 
> xfs_check had stuff like
> 
> agi unlinked bucket 0 is 8620800 in ag 0 (inode=8620800)
> agi unlinked bucket 1 is 1181377 in ag 0 (inode=1181377)
> agi unlinked bucket 2 is 8628866 in ag 0 (inode=8628866)
> agi unlinked bucket 3 is 8620611 in ag 0 (inode=8620611)
> agi unlinked bucket 4 is 1181380 in ag 0 (inode=1181380)
> agi unlinked bucket 5 is 7711173 in ag 0 (inode=7711173)
> agi unlinked bucket 6 is 7711174 in ag 0 (inode=7711174)
> [...]
> allocated inode 207025 has 0 link count
> allocated inode 207029 has 0 link count
> allocated inode 207118 has 0 link count
> allocated inode 7711173 has 0 link count
> allocated inode 7711174 has 0 link count
> allocated inode 7711197 has 0 link count
> 
> Which are due to references to deleted files AFAIK.
> 
Yep, inodes which were unlinked but still had references to them
when the filesystem was taken down without cleanly unmounting.
There is a hash table of buckets which point to linked lists of unlinked inodes.
These are then supposed to be cleaned up during the log-replay stage
on mount.
I presume (sorry for asking but just checking :-) that you mounted the filesystem
first - you would have gotten an error message if there was a dirty log anyway.
And if you didn't mount first, did you get the error message? Just curious.

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
