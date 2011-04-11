Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BLBVTd112646 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:11:31 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D112B3C4BF0
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 14:14:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sarSdOdnPaumt0EA for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2011 14:14:49 -0700 (PDT)
Date: Tue, 12 Apr 2011 07:14:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: kick inode writeback when low on memory
Message-ID: <20110411211446.GD21395@dastard>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<1302157196-1988-3-git-send-email-david@fromorbit.com>
	<20110411183653.GD32346@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110411183653.GD32346@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 11, 2011 at 02:36:53PM -0400, Christoph Hellwig wrote:
> How do you produce so many atime-dirty inodes?  With relatime we
> should have cut down on the requirement for those a lot.

Copy a bunch of files, then md5sum them.

The copy modifies c/mtime, the md5sum modifies atime, sees mtime is
younger than atime, updates atime and dirties the inode. i.e.:

$ touch foo
$ stat foo
  File: `foo'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: fe02h/65026d    Inode: 150756489   Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/    dave)   Gid: ( 1000/    dave)
Access: 2011-04-12 07:08:24.668542636 +1000
Modify: 2011-04-12 07:08:24.668542636 +1000
Change: 2011-04-12 07:08:24.668542636 +1000
$ cp README foo
cp: overwrite `foo'? y
$ stat foo
  File: `foo'
  Size: 17525           Blocks: 40         IO Block: 4096   regular file
Device: fe02h/65026d    Inode: 150756489   Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/    dave)   Gid: ( 1000/    dave)
Access: 2011-04-12 07:08:24.668542636 +1000
Modify: 2011-04-12 07:08:44.676108103 +1000
Change: 2011-04-12 07:08:44.676108103 +1000
$ md5sum foo
9eb709847626f3663ea66121f10a27d7  foo
$ stat foo
  File: `foo'
  Size: 17525           Blocks: 40         IO Block: 4096   regular file
Device: fe02h/65026d    Inode: 150756489   Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/    dave)   Gid: ( 1000/    dave)
Access: 2011-04-12 07:09:00.223770431 +1000
Modify: 2011-04-12 07:08:44.676108103 +1000
Change: 2011-04-12 07:08:44.676108103 +1000
$

> Do you have traces that show if we're kicking off additional data
> writeback this way too, or just pushing timestamp updates into
> the AIL?

For the test workload, it just pushes timestamp updates into the AIL
as that is the only thing that is dirtying the inodes when the OOM
occurs. In other situations, I have no evidence either way, but
I have not noticed any performance changes from a high level.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
