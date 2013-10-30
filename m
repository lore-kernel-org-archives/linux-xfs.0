Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B5367F3F
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 05:23:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33543AC00A
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 03:23:19 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 5CzqQk1MySBaRv9e (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 03:23:18 -0700 (PDT)
Date: Wed, 30 Oct 2013 03:23:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/30] libxfs: fix root inode handling inconsistencies
Message-ID: <20131030102318.GA31519@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-26-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 03:31:16PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When "mounting" a filesystem via libxfs_mount(), callers can tell
> libxfs to read the root and realtime inodes into cache. However,
> when unmounting the filesystem, libxfs_unmount() used to
> unconditionally free root inodes if they were present.
> 
> This leads to interesting issues like in mkfs, when it handles
> creation, reading and freeing of the root and rt inodes itself.
> It, however, passes in the flag to tell libxfs_mount() to read the
> root inode, and so when unmounting throws an error like:
> 
> cache_node_put: node put on refcount 0 (node=0x684610)
> 
> When a second libxfs_iput() call is made on the root inode.
> 
> Clean this up and fix up all the callers that use magic numbers
> rather than symbolic values to tell libxfs tomount the root inodes.

I think the right fix is to kill LIBXFS_MOUNT_ROOTINOS as nothing
ever uses mp->m_rootip.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
