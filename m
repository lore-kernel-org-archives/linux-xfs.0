Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A90717F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 16:33:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CDD8AC003
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 14:33:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8lnPjgSXKBeLDJy8 for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 14:33:15 -0800 (PST)
Date: Thu, 19 Dec 2013 09:33:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS BUG] xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
	Structure needs cleaning
Message-ID: <20131218223312.GP31386@dastard>
References: <52B1B89A.8030401@disconnect.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B1B89A.8030401@disconnect.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: arno <arno@disconnect.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Dec 18, 2013 at 04:00:42PM +0100, arno wrote:
> Hello,
> 
> (Please keep me in CC, I'm not subscribed)
> 
> Just got "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure
> needs cleaning" when trying to grow a logical Volume. Sorry, I lost the
> xfs_growfs output.
> 
> After collecting some info, I ran xfs_repair, and that seemed to fix it,
> so no harm done. After fixing, the FS had the new, increased size, if
> that matters.

This isn't the first time you've grown the filesystem, is it?

On older kernels, growfs could leave trailing garbage in the new
secondary superblocks it created. This was fixed in kernel v3.8 by
commit:

1375cb6 xfs: growfs: don't read garbage for new secondary superblocks

This garbage is detected by other changes made in v3.8 that verify
the secondary superblocks as they are read.

9802182 xfs: verify superblocks as they are read from disk

So if you grew the filesystem on a kernel older than v3.8, growing
it again on a v3.8+ kernel will detect the superblock corruption and
throw this error.

xfs_repair was recently fixed to detect the garbage in secondary
superblocks and zero it:

cbd7508 xfs_repair: zero out unused parts of superblocks

So what you need to do is run xfs_repair built from the development
git tree and run it on your filesystem. That will remove the garbage
from the superblocks and make this problem go away forever.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
