Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4AA977CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:44:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DADCAC003
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 16:44:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lh1jP9DDSH7n7AH8 for <xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 16:44:00 -0700 (PDT)
Date: Thu, 1 Aug 2013 09:43:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130731234357.GF7118@dastard>
References: <20130729230709.11033b2d@oracle.com>
	<20130730234021.GR3111@sgi.com> <20130731002119.GR13468@dastard>
	<20130731141931.2e1c77d4@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130731141931.2e1c77d4@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, xfs@oss.sgi.com

On Wed, Jul 31, 2013 at 02:19:31PM -0400, Dwight Engen wrote:
> On Wed, 31 Jul 2013 10:21:19 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> [...]
> > The only thing I think we still need to address is whether
> > xfs_ioc_setattr() should allow users within a namespace to change
> > the project ID of a file they otherwise own. That function is
> > currently changed to use a inode_owner_or_capable() check and so if
> > the uids match inside the namespace the modification is allowed.
> 
> Right, so before this change the caller has to own the file or be
> CAP_FOWNER in init_user_ns. Changing to using inode_owner_or_capable()
> means the caller has to own the file (and the inode's uid must be valid
> in current_user_ns) or be CAP_FOWNER in current_user_ns. I don't
> see how this lets the user the user do something inside the userns that
> they can't do outside.

Right.

> Basically I think we want to treat projids as a non namespace aware
> identifier, but it sounds like maybe we don't want them manipulated
> from userns context at all.

Exactly.

> > However, right now for project IDs I think we have decided to limit
> > manipulations to the init user namespace and not expose project IDs
> > inside user namespaces at all. Hence I think that xfs_ioc_setattr()
> > needs a further check for this...
> 
> If we don't want to allow setting the projid from a userns, the check
> I would propose inside the if (mask & FSX_EXTSIZE) block is:
>   if (current_user_ns() != &init_user_ns)
> Is the appropriate error return for this EINVAL? (thats what a similar
> check in kernel/taskstats.c returns)

Yeah, it looks like the very few cases where an error is returned
for such a check it is an EINVAL case. Don't forget a comment
explaining this.

We probably also fix getxstate/getxquota implementations to reject
project quota requests as well. It might be best to do this with an
additional patch.

As it is, we're going to need to revisit the project quota support
in fs/quota/quota.c because that maps project IDs to/from user
namespaces. This was done based on the overriding assertion of the
userns implementor that project quota IDs must be mapped via
namespaces, but as we are getting down to it the details (i.e.
project IDs only visible in the init user ns) we can see
that this is incorrect and we're going to need to do quite a bit of
surgery there to fix this up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
