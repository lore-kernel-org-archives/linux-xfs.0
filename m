Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8770xTN228479 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 02:01:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BFB217B5F40
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 00:01:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	GwuQAp2agav59HMD for <xfs@oss.sgi.com>;
	Tue, 07 Sep 2010 00:01:42 -0700 (PDT)
Date: Tue, 7 Sep 2010 17:01:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100907070139.GL705@dastard>
References: <201008191312.49346@zmi.at> <201009070058.40849@zmi.at>
	<20100907033134.GF7362@dastard> <201009070820.08354@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009070820.08354@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Sep 07, 2010 at 08:20:07AM +0200, Michael Monnerie wrote:
> On Dienstag, 7. September 2010 Dave Chinner wrote:
> > # mkfs.xfs -n size=64k
> > (-n = naming = directories. -d = data != directories)
> 
> Thank you, Dave. Do I interpret that parameter right:
> 
> When a new directory is created, per default it would occupy only 4KB, 
> with -n size=64k would be reserved.

No, it allocates 64k blocks for the directory instead of 4k blocks.

> As the directory fills, space within 
> that block will be used, so in the default case after 4KB (how many 
> inodes would that be roughly? 256 Bytes/Inode, so 16 entries?) XFS would 
> reserve the next block, but in your case 256 entries would fit.

Inodes are not stored in the dirctory structure, only the directory
entry name and the inode number. Hence the amount of space used by a
directory entry is determined by the length of the name.

> That would keep dir fragmentation lower, and with todays disks, take a 
> minimal more space, so it sounds very good to use that option. 
> Especially with RAIDs, where stripes usually are 64KB or bigger. Or 
> would the waste of space be so big that it could hurt?

Well, there is extra overhead to allocate large directory blocks (16
pages instead of one, to begin with, then there's the vmap overhead,
etc), so for small directories smaller block sizes are faster for
create and unlink operations.

For empty directorys, operations on 4k block sized directories
consume roughly 50% less CPU that 64k block size directories. The
4k block size directoeies consume less CPU out to roughly 1.5
million entries where the two are roughly equal. At directory sizes
of 10 million entries, 64k directory block operations are consuming
about 15% of the CPU that 4k directory block operations consume.

In terms of lookups, the 64k block directory will take less IO but
consume more CPU for a given lookup. Hence it depends on your IO
latency and whether directory readahead can hide that latency as to
which will be faster. e.g. For SSDs, CPU usage might be the limiting
factor, not the IO. Right now I don't have any numbers on what
the difference might be - I'm getting 1B inode population issues worked
out first before I start on measuring cold cache lookup times on 1B
files....

> Last question: Is there a way to set that option on a given XFS?

No, it is a mkfs time parameter, though we have been discussing the
possibility of being able to set it per-directory (at mkdir time
when no blocks have been allocated).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
