Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 742F97F50
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 18:28:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F4778F8089
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 16:28:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WQW9OgNEXKcqcamt for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2015 16:28:42 -0800 (PST)
Date: Wed, 11 Feb 2015 11:28:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] xfs: xfs_spaceman utility rework
Message-ID: <20150211002840.GR4251@dastard>
References: <54ca326a.a1c4440a.6b39.422e@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ca326a.a1c4440a.6b39.422e@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 06:45:17PM +0530, Dhruvesh Rathore wrote:
> 
> The original kernel patch that Dave wrote for xfs_spaceman implemented
> FS_IOC_FIEMAPFS ioctl, here is the original fiemap extension patch:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00363.html
> 
> These patches were not posted and were just forward ported to a current 
> 3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in Dave's
> kernel tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> 
> The original xfs_spaceman tool that Dave wrote to call the fiemap
> interface and make use of it is here:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00366.html
> 
> Dave just updated it to the 3.2.2 code base and pushed it to the
> spaceman branch in this tree:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

These tree branches have just been updated (via rebase) with all the
changes in these patches integrated. Please update your trees and
review and test the updated patches. The patches have been
reshuffled and reworked, so please make sure you are happy with the
attributions in the commit messages for the new patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
