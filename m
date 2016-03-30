Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C7317CAE
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 17:06:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E300CAC004
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:06:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pDdh2BWgq7zstdkK for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 15:06:35 -0700 (PDT)
Date: Thu, 31 Mar 2016 09:05:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix a memory leak in xfs_get_acl on error
Message-ID: <20160330220515.GI30721@dastard>
References: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
	<20160330202655.GH30721@dastard> <20160330204119.GA8032@mguzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160330204119.GA8032@mguzik>
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
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Wed, Mar 30, 2016 at 10:41:20PM +0200, Mateusz Guzik wrote:
> On Thu, Mar 31, 2016 at 07:26:55AM +1100, Dave Chinner wrote:
> > On Wed, Mar 30, 2016 at 04:35:07PM +0200, Mateusz Guzik wrote:
> > > Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> > > ---
> > >  fs/xfs/xfs_acl.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > > index 2dad2b5..ce10c4c 100644
> > > --- a/fs/xfs/xfs_acl.c
> > > +++ b/fs/xfs/xfs_acl.c
> > > @@ -162,10 +162,11 @@ xfs_get_acl(struct inode *inode, int type)
> > >  		 */
> > >  		if (error != -ENOATTR)
> > >  			acl = ERR_PTR(error);
> > > -		return acl;
> > > +		goto out;
> > >  	}
> > >  
> > >  	acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
> > > +out:
> > >  	kmem_free(xfs_acl);
> > >  	return acl;
> > >  }
> > 
> > Hi Mateusz,
> > 
> > It looks like we've already fixed this problem - can you check
> > 4.6-rc1 and if the leak is still there post an updated patch?
> > 
> 
> The patch which introuced the bug is not present in 4.6-rc1.
> 
> The patch is against next-20160330, the bug was introduced in:
> 
> commit ae4e84be32ef6fdf97f10852778597b1a2be3cba
> Author: Andreas Gruenbacher <agruenba@redhat.com>
> Date:   Thu Mar 24 14:38:37 2016 +0100
> 
>     posix_acl: Inode acl caching fixes
> 
> Apologies if this should have been handled differently (by replying to the
> original patch?)

You need to put this information in the patch description so we
don't have to guess at what it applies to. Most maintainers assume
that if it is not mentioned, the patch should apply to their current
top of tree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
