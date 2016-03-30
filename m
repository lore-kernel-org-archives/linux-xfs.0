Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C730F7CA3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:41:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BAF48F8037
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 13:41:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id InXAh52DzG6Vu2Mb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 13:41:27 -0700 (PDT)
Date: Wed, 30 Mar 2016 22:41:20 +0200
From: Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCH] xfs: fix a memory leak in xfs_get_acl on error
Message-ID: <20160330204119.GA8032@mguzik>
References: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
	<20160330202655.GH30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160330202655.GH30721@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Thu, Mar 31, 2016 at 07:26:55AM +1100, Dave Chinner wrote:
> On Wed, Mar 30, 2016 at 04:35:07PM +0200, Mateusz Guzik wrote:
> > Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> > ---
> >  fs/xfs/xfs_acl.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index 2dad2b5..ce10c4c 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> > @@ -162,10 +162,11 @@ xfs_get_acl(struct inode *inode, int type)
> >  		 */
> >  		if (error != -ENOATTR)
> >  			acl = ERR_PTR(error);
> > -		return acl;
> > +		goto out;
> >  	}
> >  
> >  	acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
> > +out:
> >  	kmem_free(xfs_acl);
> >  	return acl;
> >  }
> 
> Hi Mateusz,
> 
> It looks like we've already fixed this problem - can you check
> 4.6-rc1 and if the leak is still there post an updated patch?
> 

The patch which introuced the bug is not present in 4.6-rc1.

The patch is against next-20160330, the bug was introduced in:

commit ae4e84be32ef6fdf97f10852778597b1a2be3cba
Author: Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu Mar 24 14:38:37 2016 +0100

    posix_acl: Inode acl caching fixes

Apologies if this should have been handled differently (by replying to the
original patch?)

-- 
Mateusz Guzik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
