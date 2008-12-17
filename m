Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHL6HcG013745 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 15:06:18 -0600
Message-ID: <494969C6.4090500@sandeen.net>
Date: Wed, 17 Dec 2008 15:06:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH][RFC] fs: Add new pre-allocation ioctls
	to vfs for compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
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
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
>> This patch adds ioctls to vfs for compatibility with legacy XFS
>> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
>> effectively invokes sys_fallocate for the new ioctls.
>> Note: These legacy ioctls are also implemented by OCFS2.
>>
>> There are some things that I'm not sure about:
>> 1. Should the struct space_resv be exposed to user-space? If not,
>> then what would be the right place to put it? And the ioctl
>> definitions?
> 
> Yes. As far as where to put it, I'm not sure. Maybe falloc.h?

I'd sort of rather not; why should that legacy struct space_resv be
available in a header... I thought this was for people already using the
xfs ioctl, in which case they are already using the xfs header... and if
they want preallocation in any new work, they should use fallocate()
instead, yes?

I mean it wouldn't hurt anything but it sort of confuses the interface
story IMHO.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
