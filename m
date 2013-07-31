Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCD9A7CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 13:19:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 696A3AC003
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 11:19:53 -0700 (PDT)
Date: Wed, 31 Jul 2013 14:19:31 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130731141931.2e1c77d4@oracle.com>
In-Reply-To: <20130731002119.GR13468@dastard>
References: <20130729230709.11033b2d@oracle.com>
	<20130730234021.GR3111@sgi.com> <20130731002119.GR13468@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Gao feng <gaofeng@cn.fujitsu.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, 31 Jul 2013 10:21:19 +1000
Dave Chinner <david@fromorbit.com> wrote:

[...]
> The only thing I think we still need to address is whether
> xfs_ioc_setattr() should allow users within a namespace to change
> the project ID of a file they otherwise own. That function is
> currently changed to use a inode_owner_or_capable() check and so if
> the uids match inside the namespace the modification is allowed.

Right, so before this change the caller has to own the file or be
CAP_FOWNER in init_user_ns. Changing to using inode_owner_or_capable()
means the caller has to own the file (and the inode's uid must be valid
in current_user_ns) or be CAP_FOWNER in current_user_ns. I don't
see how this lets the user the user do something inside the userns that
they can't do outside.

Basically I think we want to treat projids as a non namespace aware
identifier, but it sounds like maybe we don't want them manipulated
from userns context at all.

> However, right now for project IDs I think we have decided to limit
> manipulations to the init user namespace and not expose project IDs
> inside user namespaces at all. Hence I think that xfs_ioc_setattr()
> needs a further check for this...

If we don't want to allow setting the projid from a userns, the check
I would propose inside the if (mask & FSX_EXTSIZE) block is:
  if (current_user_ns() != &init_user_ns)
Is the appropriate error return for this EINVAL? (thats what a similar
check in kernel/taskstats.c returns)

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
