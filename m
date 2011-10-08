Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p98MV8E8070946 for <xfs@oss.sgi.com>; Sat, 8 Oct 2011 17:31:08 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDFAA1B996F
	for <xfs@oss.sgi.com>; Sat,  8 Oct 2011 15:31:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KveHEdMpu4OnGMRd for <xfs@oss.sgi.com>;
	Sat, 08 Oct 2011 15:31:05 -0700 (PDT)
Date: Sun, 9 Oct 2011 09:30:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111008223059.GL3159@dastard>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<4E8F0385.7060906@birkenwald.de> <20111007231410.GG3159@dastard>
	<4E90422E.3060805@birkenwald.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E90422E.3060805@birkenwald.de>
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
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: xfs@oss.sgi.com

On Sat, Oct 08, 2011 at 02:29:34PM +0200, Bernhard Schmidt wrote:
> >I'd suggest that for your workload, you need to allow at least 10GB
> >of disk space per million inodes. Because of the number of small
> >files, XFS is going to need a much larger amount of free space
> >available to prevent aging related freespace fragmentation problems.
> >The above ratio results in a maximum space usage of about 50%, which
> >will avoid such issues. If you need to hold 2 million files, use a
> >20GB filesystem...
> 
> I don't need to hold 2 million files, 1 million might be enough, I
> have to make sure I cannot run out of inodes way before I run out of
> free space.
> 
> Generally speaking I have the following problem:
> 
> External nodes are submitting data (mails) to this system as fast as
> they can. The mails can be between 800 bytes and several megabytes.
> There are 50 receiver that write those mails as single files flat in
> a single directory.
> 
> There are 4 worker threads that process a _random_ file out of this
> directory. To process it they need to be able to create a temporary
> file on the same filesystem. Together they are slower than the 50
> receivers (they can process maybe 20% of the incoming rate), which
> means that this incoming directory is going to fill. For the sake of
> the argument lets assume that the amount of mails to be sent is
> unlimited.
> 
> The only knob the software knows to prevent this from going over is
> free disk space. When free disk space is lower than 2 Gigabyte, the
> acceptance of new mails is blocked gracefully until there is free
> space again.

You could increase this free space limit - that is likely to reduce
the incidence of too-early ENOSPC.

> It has, however, no way to deal with ENOSPC before that. When it
> cannot create new files due no free inodes (ext4 with default
> settings) or fragmentation in XFS, it breaks quite horribly and
> cannot recover by itself.
> 
> Can I avoid XFS giving ENOSPC due to inode shortage even in worst
> case situations? I would be fine preallocating 1 GB for inode
> storage if that would fix the problem. ext4 with bytes-per-inode =
> blocksize does this fine.
> 
> You mentioned an aging problem with XFS. I guess you mean that an
> XFS filesystem will get slower/more fragmented by time with abuse
> like this. These mail submission above will happen in bursts, during
> normal times it will go down to << 1000 files on the entire
> filesystem (empty incoming directory). Is this enough for XFS to
> "fix itself"?

In most cases, yes.

> BTW, the software can hash the incoming directory in 16 or 16x16
> subdirectories. Would that help XFS in any way with those filesizes?

Directory scalability is not affected by the size of the files
they index. OTOH, concurrency of operations would be improved.

That is, if you have all 2 million files in a single directory, only
one process (incoming or processing) can be modifying the directory
at a time. That will serialise a lot of the work that is being done.
If you have those 2M files hashed across 16 directories, then
modification/access collisions will be less likely hence operations
are more likely to be done in parallel (and therefore faster).

> At first glance I would have said yes, but due to the random access
> in those directories it would still have the entire spool as
> workload.

Random directory lookups on large directories are pretty efficient
on XFS due to the btree-based name hash indexing scheme they use.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
