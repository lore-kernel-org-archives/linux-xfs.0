Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05DD37F5E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 22:45:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06BC330404E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 20:45:06 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id vn1HzHku19AcGkWu for
	<xfs@oss.sgi.com>; Wed, 28 May 2014 20:45:05 -0700 (PDT)
Message-ID: <5386AABD.5070708@cn.fujitsu.com>
Date: Thu, 29 May 2014 11:34:21 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: xfs: possible deadlock warning
References: <538571D4.70904@cn.fujitsu.com> <20140528060050.GK8554@dastard>
In-Reply-To: <20140528060050.GK8554@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave,

On 05/28/2014 02:00 PM, Dave Chinner wrote:

> On Wed, May 28, 2014 at 01:19:16PM +0800, Gu Zheng wrote:
>> Hi all,
>> When running the latest Linus' tree, the following possible deadlock warning occurs.
> 
> false positive. There isn't a deadlock between inode locks on
> different filesystems. i.e. there is no dependency between shmem
> inodes and xfs inodes, nor on their security contexts.  Nor can you
> take a page fault on a directory inode, which is the XFS inode lock
> class it's complaining about.

If it's really a noisy, can we avoid this?
 
Thanks,
Gu

> 
> Fundamentally, the problem here is shmem instantiating a new inode
> with the mmap_sem held. That's just plain wrong...

Agree, it's better to prepare the file before going into the protection region. 

> 
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
