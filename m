Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01HHEWX007587 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 11:17:15 -0600
Date: Thu, 1 Jan 2009 12:17:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Feature requests, was Re: XFS internal error when NFS client
	accesses nonexistent inode
Message-ID: <20090101171713.GB18020@infradead.org>
References: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
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
To: Mario Becroft <mb@gem.win.co.nz>
Cc: xfs@oss.sgi.com

On Thu, Jan 01, 2009 at 03:09:08AM +1300, Mario Becroft wrote:
> While I am writing, two things I wish XFS could do, and two more that
> would be jolly nice to have:
> 
> 1. shrink filesystems

http://xfs.org/index.php/Shrinking_Support

> 2. dump/restore preserving inode numbers

That's very hard to do, given that inode numbers encode the location
on disk.  To support your NFS exporting scenario you would also have
to preserve the generation number, which also forms part of the nfs file
handle.

> 3. high-performance dump with multi-threaded reading to fully utilise
> disk throughput

Didn't xfsdump in IRIX have some sort of multi-stream support.  Bill, do
you remember anything like that?

> 4. on-line xfs_check/repair

Well, you can check online, it's just not going to give good results.
Using snaphots you can easily check online, and with a little hack
even repair, but you'd still have to reboot to then use the repaired
filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
