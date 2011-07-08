Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6881fwl225575 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 03:01:41 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 232D61E5D6A4
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2011 01:01:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IHdsaXjZXRVPnbKV for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2011 01:01:39 -0700 (PDT)
Date: Fri, 8 Jul 2011 18:01:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota: bug: traverses bind mountpoints
Message-ID: <20110708080135.GH1026@dastard>
References: <4E161B1D.90301@uvic.ca> <20110708032351.GF1026@dastard>
	<4E168C16.6000408@uvic.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E168C16.6000408@uvic.ca>
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
To: Paul Nienaber <phox@uvic.ca>
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2011 at 09:48:22PM -0700, Paul Nienaber wrote:
> I would definitely agree that this is perhaps perhaps quite
> nonsensical in the case of user/group quotas.  However, a project
> quota is conceptually a quota for "files in a directory and its
> subdirectories on a particular filesystem",

No, project quota works exactly like user and group quotas - every
file in a project group has the same project ID stored in the inode,
just like uid and gid are stored in the inode. They do not rely on
directory structure at all, and you can add any file to a project
anywhere in the filesystem simply by changing it's project ID.

Project quotas can be used to -implement- directory tree quotas
because there is another flag in the inode that tells directories
that children should inherit the projid of the parent directory at
creation time. That's the actual feature that allows project quotas
to be used for directory tree quotas - it's entirely independent of
the basic functionality of accounting and enforcing project quotas
based on the projid in each inode.

That's why it is not at all clear how bind mounts should be treated.
On one hand they should be treated identically to user and group
quotas, and on the other hand bind mounts can completely screw up
directory tree quotas.

> and I would argue that,
> regardless of bindmounts, / is never a subdirectory of /foo, and
> this is where I think the change in behaviour should be. 

You're attempting to cross recursive bind mounts with directory tree
quota and worse, pointing the bind mount inside the directory tree
to a parent directory outside the directory tree the quota applies
to.

IOWs, your directory structure disappears up it's own fundamental
orifice in a manner that is very difficult to detect (did Oroborus
know that it was eating it's own tail?). As such I don't think there
is a sane set of semantics that we can apply consistently in the XFS
code in both userspace and kernel code when it comes to directory
tree quotas and bind mounts.

The simple answer is: Just Don't Do It.

> There's
> also the somewhat-grey area of how 'project -C' should behave, and I
> suppose the simplest and most sensible answer there is "however
> 'project -s' and 'project -c' behave", as that's both at least
> somewhat sensible and the least likely to confuse people.  I'd be
> happy to go digging at find at some point soon.

Like I said above, there's also consistency with every other
application that does traversal for accounting purposes (e.g. du).
If you want to avoid traversals moving across bind mounts
(especially recursive bind mounts), I think we need a syscall flag
similar to AT_SYMLINK_NOFOLLOW for the kernel to detect and prevent
such traversal in a consistent manner.

As such, that's not a project quota problem - that's a generic, VFS
behaviour issue. That's where I'd recommend trying to solve the
bind mount traversal problem, not hack something into xfs_quota....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
