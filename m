Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p683gNd4209693 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 22:42:23 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C628552D9
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 20:42:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wMnW7lyATfipFoNX for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 20:42:21 -0700 (PDT)
Date: Fri, 8 Jul 2011 13:42:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Number of ACLs
Message-ID: <20110708034218.GG1026@dastard>
References: <4E15AA1A.3090802@lncsa.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E15AA1A.3090802@lncsa.com>
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
To: Laurent CARON <lcaron@lncsa.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2011 at 02:44:10PM +0200, Laurent CARON wrote:
> Hi,
> 
> I'd like to know if it is possible in a simple & safe way to
> increase the number of supported ACLs on an already existing FS.
> 
> xfs_acl.h:
> #define XFS_ACL_MAX_ENTRIES 25
> 
> Changing XFS_ACL_MAX_ENTRIES to something higher should do the
> trick, but will it be safe: ie: will I risk corrupting the FS this
> way ?

It's effectively an on-disk format change. If you add more than 25
ACLs and then downgrade kernel, you won't be able to access those
ACLs.

Hmmm, even worse, looking at the code it would probably cause a
buffer overrun (memory corupting crash) as the old kernels only
allocate an array large enough to hold 25 ACLs and the
xfs_acl_from_disk() function implicitly trusts the number of ACLs in
the xattr fits into the array....

So, that definitely means larger number of ACLs requires a feature
bit in the superblock so that once you go over 25 ACLs you can't use
that filesystem on a kernel that does not support >25 ACLs.  i.e.
it's a typical on-disk versioning change that requires a bunch of
work in both kernel and userspace to support a new feature
superblock feature bit. In this case, the feature bit would
only need to be set by the kernel on existing filesystems when you
first go over 25 ACLs on an inode, so most people wouldn't even care
about the change....

An example for this dynamic setting of a feature bit is the code to
dynamically indicate the filesystem has version 2 inodes in it. See
xfs_bump_ino_vers2() and what it does to add a feature bit when that
transition occurs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
