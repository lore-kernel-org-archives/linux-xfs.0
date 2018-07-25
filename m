Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728694AbeGYRhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 13:37:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6PGO1Gx055865
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 16:25:10 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2kbvsnx7ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 16:25:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6PGP94A004881
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 16:25:09 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6PGP9Os032441
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 16:25:09 GMT
Date: Wed, 25 Jul 2018 09:25:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: clean up IRELE/iput callsites
Message-ID: <20180725162509.GQ4813@magnolia>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129832.28208.4218463670080722161.stgit@magnolia>
 <20180725040028.6tvtb3pfe4bbqf5i@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725040028.6tvtb3pfe4bbqf5i@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Jul 25, 2018 at 06:00:28AM +0200, Carlos Maiolino wrote:
> On Tue, Jul 24, 2018 at 06:14:58PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Replace the IRELE macro with a proper function so that we can do proper
> > typechecking and so that we can stop open-coding iput in scrub, which
> > means that we'll be able to ftrace inode lifetimes going through scrub
> > correctly.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >  }
> > +
> > +/* Release an inode. */
> > +void
> > +xfs_irele(
> > +	struct xfs_inode	*ip)
> > +{
> > +	trace_xfs_irele(ip, _RET_IP_);
> > +	iput(VFS_I(ip));
> > +}
> 
> I think this still shows the callers of xfs_irele() in the trace right? Assuming
> I'm right here:

Correct, this will point back to the return address of the call stack,
which should be the next line in the source code.

--D

> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 8e18bc0fedd0..fa05f8126b00 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -484,11 +484,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
> >  	xfs_finish_inode_setup(ip);
> >  }
> >  
> > -#define IRELE(ip) \
> > -do { \
> > -	trace_xfs_irele(ip, _THIS_IP_); \
> > -	iput(VFS_I(ip)); \
> > -} while (0)
> > +void xfs_irele(struct xfs_inode *ip);
> >  
> >  
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
