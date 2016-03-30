Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 305247CA3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:27:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 947ABAC001
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 13:27:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KTsJd5cxlzPNAUsZ for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 13:26:58 -0700 (PDT)
Date: Thu, 31 Mar 2016 07:26:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix a memory leak in xfs_get_acl on error
Message-ID: <20160330202655.GH30721@dastard>
References: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
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

On Wed, Mar 30, 2016 at 04:35:07PM +0200, Mateusz Guzik wrote:
> Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> ---
>  fs/xfs/xfs_acl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 2dad2b5..ce10c4c 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -162,10 +162,11 @@ xfs_get_acl(struct inode *inode, int type)
>  		 */
>  		if (error != -ENOATTR)
>  			acl = ERR_PTR(error);
> -		return acl;
> +		goto out;
>  	}
>  
>  	acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
> +out:
>  	kmem_free(xfs_acl);
>  	return acl;
>  }

Hi Mateusz,

It looks like we've already fixed this problem - can you check
4.6-rc1 and if the leak is still there post an updated patch?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
