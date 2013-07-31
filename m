Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 271237CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 19:21:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 080668F8035
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 17:21:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gU3mFgXCHjUlSQhK for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 17:21:39 -0700 (PDT)
Date: Wed, 31 Jul 2013 10:21:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130731002119.GR13468@dastard>
References: <20130729230709.11033b2d@oracle.com>
	<20130730234021.GR3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130730234021.GR3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Tue, Jul 30, 2013 at 06:40:21PM -0500, Ben Myers wrote:
> Hey Dwight,
> 
> On Mon, Jul 29, 2013 at 11:07:09PM -0400, Dwight Engen wrote:
> > >From e6a9ee0cfa0ed40484f66bc1726dc19de36038b8 Mon Sep 17 00:00:00 2001
> > From: Dwight Engen <dwight.engen@oracle.com>
> > Date: Tue, 2 Jul 2013 09:52:54 -0400
> > Subject: [PATCH 7/7] enable building user namespace with xfs
> > 
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> 
> Was there a patch running around to limit bulkstat to init_user_ns?  Any other
> items that needed to be addressed before applying this patch?

Bulkstat has a capable(CAP_SYS_ADMIN) check and therefore can only be
executed in the init name space. Similarly, all the open-by-handle
interfaces have the same capable() checks so they can only be
executed int he init name space, too.

The only thing I think we still need to address is whether
xfs_ioc_setattr() should allow users within a namespace to change
the project ID of a file they otherwise own. That function is
currently changed to use a inode_owner_or_capable() check and so if
the uids match inside the namespace the modification is allowed.

However, right now for project IDs I think we have decided to limit
manipulations to the init user namespace and not expose project IDs
inside user namespaces at all. Hence I think that xfs_ioc_setattr()
needs a further check for this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
