Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0V5qIDN073649 for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 23:52:19 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1730129D70C
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 21:54:44 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9A1aA96YtFpusl2X for <xfs@oss.sgi.com>;
	Sun, 30 Jan 2011 21:54:44 -0800 (PST)
Date: Mon, 31 Jan 2011 16:54:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: reordering file operations for performance
Message-ID: <20110131055429.GK21311@dastard>
References: <AANLkTim0h1Ez8f8YprUqUv=4OvAfDPStS8yM8Kdq5bCc@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTim0h1Ez8f8YprUqUv=4OvAfDPStS8yM8Kdq5bCc@mail.gmail.com>
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
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

On Sun, Jan 30, 2011 at 08:47:03PM -0800, Phil Karn wrote:
> I have written a file deduplicator, dupmerge, that walks through a file
> system (or reads a list of files from stdin), sorts them by size, and
> compares each pair of the same size looking for duplicates. When it finds
> two distinct files with identical contents on the same file system, it
> deletes the newer copy and recreates its path name as a hard link to the
> older version.
> 
> For performance it actually compares SHA1 hashes, not the actual file
> contents. To avoid unnecessary full-file reads, it first compares the hashes
> of the first pages (4kiB) of each file. Only if they match will I compute
> and compare the full file hashes. Each file is fully read at most once and
> sequentially, so if the file occupies a single extent it can be read in a
> single large contiguous transfer. This is noticeably faster than doing a
> direct compare, seeking between two files at opposite ends of the disk.
> 
> I am looking for additional performance enhancements, and I don't mind using
> fs-specific features. E.g., I am now stashing the file hashes into xfs
> extended file attributes.
> 
> I regularly run xfs_fsr and have added fallocate() calls to the major file
> copy utilities, so all of my files are in single extents. Is there an easy
> way to ask xfs where those extents are located so that I could sort a set of
> files by location and then access them in a more efficient order?

ioctl(FS_IOC_FIEMAP) is what you want.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
