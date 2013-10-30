Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE1057F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 17:00:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBC0B304032
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 14:59:59 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UxGr7SbmeALm5xp2 for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 14:59:58 -0700 (PDT)
Date: Thu, 31 Oct 2013 08:59:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/30] libxfs: fix root inode handling inconsistencies
Message-ID: <20131030215940.GH6188@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
	<20131030102318.GA31519@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131030102318.GA31519@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 03:23:18AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 30, 2013 at 03:31:16PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When "mounting" a filesystem via libxfs_mount(), callers can tell
> > libxfs to read the root and realtime inodes into cache. However,
> > when unmounting the filesystem, libxfs_unmount() used to
> > unconditionally free root inodes if they were present.
> > 
> > This leads to interesting issues like in mkfs, when it handles
> > creation, reading and freeing of the root and rt inodes itself.
> > It, however, passes in the flag to tell libxfs_mount() to read the
> > root inode, and so when unmounting throws an error like:
> > 
> > cache_node_put: node put on refcount 0 (node=0x684610)
> > 
> > When a second libxfs_iput() call is made on the root inode.
> > 
> > Clean this up and fix up all the callers that use magic numbers
> > rather than symbolic values to tell libxfs tomount the root inodes.
> 
> I think the right fix is to kill LIBXFS_MOUNT_ROOTINOS as nothing
> ever uses mp->m_rootip.

Good point - I never looked at the users of mp->m_rootip, so didn't
notice this. I'll redo this patch to kill LIBXFS_MOUNT_ROOTINOS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
