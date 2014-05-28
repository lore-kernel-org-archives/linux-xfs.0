Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F55E29DF8
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:01:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68888304043
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:01:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RnoHezdIQX8ufCcs for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:01:15 -0700 (PDT)
Date: Wed, 28 May 2014 16:00:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: possible deadlock warning
Message-ID: <20140528060050.GK8554@dastard>
References: <538571D4.70904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538571D4.70904@cn.fujitsu.com>
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
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, May 28, 2014 at 01:19:16PM +0800, Gu Zheng wrote:
> Hi all,
> When running the latest Linus' tree, the following possible deadlock warning occurs.

false positive. There isn't a deadlock between inode locks on
different filesystems. i.e. there is no dependency between shmem
inodes and xfs inodes, nor on their security contexts.  Nor can you
take a page fault on a directory inode, which is the XFS inode lock
class it's complaining about.

Fundamentally, the problem here is shmem instantiating a new inode
with the mmap_sem held. That's just plain wrong...


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
