Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 746877F62
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 20:54:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52FB1304053
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 18:54:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Bt675rBTHykwyiw7 for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 18:54:19 -0800 (PST)
Date: Mon, 2 Nov 2015 13:53:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/5] xfs: SGI ACL Fixes
Message-ID: <20151102025352.GY19199@dastard>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Oct 30, 2015 at 04:05:03PM +0100, Andreas Gruenbacher wrote:
> Here is a reworked patch queue that also handles setting SGI_ACL_{FILE,DEFAULT}
> via XFS_IOC_ATTRMULTI_BY_HANDLE.  Please review.
> 
> Thanks,
> Andreas
> 
> Andreas Gruenbacher (5):
>   xfs: Validate the length of on-disk ACLs
>   xfs: Plug memory leak in xfs_attrmulti_attr_set

Ok, I've taken these two patches for the upcoming merge window as
they fix bugs, but I've taken Brian's cached ACL invalidation patch
instead of these:

>   xfs: SGI ACLs: Fix caching and mode setting
>   xfs: Add namespace parameter to the xfs kuid/kgid <=> uid/gid wrappers
>   xfs: SGI ACLs: Map uid/gid namespaces

I'm not yet convinced that these patches are the right way to solve
the given issue as they may interact badly with xfsdump/restore.
However, I do want the kernel code to behave correctly after
xfs_restore runs and Brian's change is enough to do this. If
we do decide that we need to make the above changes to the posix
acl code, it's easy enough to replace this invalidation code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
