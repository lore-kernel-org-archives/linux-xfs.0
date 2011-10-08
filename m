Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p98MYElF071040 for <xfs@oss.sgi.com>; Sat, 8 Oct 2011 17:34:14 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F7E814594D2
	for <xfs@oss.sgi.com>; Sat,  8 Oct 2011 15:41:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4wcvw7TvxVWQgQfR for <xfs@oss.sgi.com>;
	Sat, 08 Oct 2011 15:41:12 -0700 (PDT)
Date: Sun, 9 Oct 2011 09:34:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111008223404.GM3159@dastard>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<4E8F0385.7060906@birkenwald.de> <20111007231410.GG3159@dastard>
	<4E90422E.3060805@birkenwald.de>
	<20111008131809.GB25855@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111008131809.GB25855@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Bernhard Schmidt <berni@birkenwald.de>, xfs@oss.sgi.com

On Sat, Oct 08, 2011 at 09:18:09AM -0400, Christoph Hellwig wrote:
> On Sat, Oct 08, 2011 at 02:29:34PM +0200, Bernhard Schmidt wrote:
> > Can I avoid XFS giving ENOSPC due to inode shortage even in worst
> > case situations? I would be fine preallocating 1 GB for inode
> > storage if that would fix the problem. ext4 with bytes-per-inode =
> > blocksize does this fine.
> 
> It's a bit of a hack, but you can do that fairly easily by:
> 
>  - mounting the filesystem with the ikeep option
>  - creating the numbers of inodes you need (use a worst case allocation)
>    before starting the workload

Just bear in mind that this can result in all inodes being allocated
in the same AG, thereby serialising all future file creation and
deletion in the filesystem. If you take this route, using a directory
hashing scheme is, IMO, absolutely necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
