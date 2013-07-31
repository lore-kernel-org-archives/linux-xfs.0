Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 709347CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 12:09:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5709AC001
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 10:09:20 -0700 (PDT)
Date: Wed, 31 Jul 2013 13:09:04 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130731130904.1a96246a@oracle.com>
In-Reply-To: <20130731132523.GS3111@sgi.com>
References: <20130729230709.11033b2d@oracle.com>
	<20130730234021.GR3111@sgi.com> <20130731002119.GR13468@dastard>
	<20130731132523.GS3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 31 Jul 2013 08:25:23 -0500
Ben Myers <bpm@sgi.com> wrote:

> Hey,
> 
> On Wed, Jul 31, 2013 at 10:21:19AM +1000, Dave Chinner wrote:
> > On Tue, Jul 30, 2013 at 06:40:21PM -0500, Ben Myers wrote:
> > > On Mon, Jul 29, 2013 at 11:07:09PM -0400, Dwight Engen wrote:
> > > > >From e6a9ee0cfa0ed40484f66bc1726dc19de36038b8 Mon Sep 17
> > > > >00:00:00 2001
> > > > From: Dwight Engen <dwight.engen@oracle.com>
> > > > Date: Tue, 2 Jul 2013 09:52:54 -0400
> > > > Subject: [PATCH 7/7] enable building user namespace with xfs
> > > > 
> > > > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > > 
> > > Was there a patch running around to limit bulkstat to
> > > init_user_ns?  Any other items that needed to be addressed before
> > > applying this patch?
> > 
> > Bulkstat has a capable(CAP_SYS_ADMIN) check and therefore can only
> > be executed in the init name space. Similarly, all the
> > open-by-handle interfaces have the same capable() checks so they
> > can only be executed int he init name space, too.
> 
> Gah.  I was under the impression that you could have a process with
> CAP_SYS_ADMIN in a namespace other than init_user_ns.

Hi Ben, a process can be CAP_SYS_ADMIN in its own userns, but the
check for that would be ns_capable(CAP_SYS_ADMIN) not
capable(CAP_SYS_ADMIN) which checks against init_user_ns. The checks
Dave was mentioning are all against init_user_ns so bulkstat
and open-by-handle effectively cannot be used from inside a
non-init_user_ns.

> > The only thing I think we still need to address is whether
> > xfs_ioc_setattr() should allow users within a namespace to change
> > the project ID of a file they otherwise own. That function is
> > currently changed to use a inode_owner_or_capable() check and so if
> > the uids match inside the namespace the modification is allowed.
> > 
> > However, right now for project IDs I think we have decided to limit
> > manipulations to the init user namespace and not expose project IDs
> > inside user namespaces at all. Hence I think that xfs_ioc_setattr()
> > needs a further check for this...
>
> Looks like that should be added to patch 3.  Dwight, if you prefer to
> repost only patch 3 that's fine.

I'll add this into patch 3 once we get it sorted out and then repost
with Gao's reviewed-by tags. Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
