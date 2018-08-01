Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40020 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389370AbeHAQBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 12:01:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w71EE9LP142826
        for <linux-xfs@vger.kernel.org>; Wed, 1 Aug 2018 14:15:26 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2kge0d61as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Aug 2018 14:15:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w71EFOr2011115
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 1 Aug 2018 14:15:25 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w71EFOhB027910
        for <linux-xfs@vger.kernel.org>; Wed, 1 Aug 2018 14:15:24 GMT
Date: Wed, 1 Aug 2018 07:15:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: check da node magic in _node_lookup_int
Message-ID: <20180801141524.GB30972@magnolia>
References: <153307925470.7924.18204385078598751297.stgit@magnolia>
 <153307926059.7924.13909891112765252120.stgit@magnolia>
 <20180801121202.2nk4qwwizmvhla57@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801121202.2nk4qwwizmvhla57@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Aug 01, 2018 at 02:12:02PM +0200, Carlos Maiolino wrote:
> On Tue, Jul 31, 2018 at 04:21:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Before we start processing what we /think/ is a da3 node block, actually
> > check the magic to make sure that we're looking at a node block.  This
> > way we won't blow the asserts in _node_hdr_from_disk on corrupted
> > metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The patch looks good, but why wouldn't merge it into the previous one?
> 
> Both patches look reasonable to fit into a single one.
> 
> But, merging both or not.

They're different logical changes to the source code -- one refactors to
use a local variable, the other adds extra checks.

--D

> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 8ffe17b223da..376bee94b5dd 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -1523,8 +1523,10 @@ xfs_da3_node_lookup_int(
> >  			break;
> >  		}
> >  
> > -		blk->magic = XFS_DA_NODE_MAGIC;
> > +		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC)
> > +			return -EFSCORRUPTED;
> >  
> > +		blk->magic = XFS_DA_NODE_MAGIC;
> >  
> >  		/*
> >  		 * Search an intermediate node for a match.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
