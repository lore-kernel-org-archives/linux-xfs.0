Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274glA5016904 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:42:48 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cd539zpEoeHPzWFe for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:42:45 -0800 (PST)
Date: Wed, 7 Mar 2012 15:42:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem setfacl has limitation?
Message-ID: <20120307044242.GJ3592@dastard>
References: <4F56C4D5.1070206@eisoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F56C4D5.1070206@eisoo.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "yyq@eisoo.com" <yyq@eisoo.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 07, 2012 at 10:15:49AM +0800, yyq@eisoo.com wrote:
> Hi,all,
>     When set files/directories attributes with setfacl on XFS file
> system, we has encountered that ACL items is under the limitation of
> 23. I wonder that if XFS file system has this limitation and if can
> we exceed it?

>From fs/xfs/xfs_acl.h:

#define XFS_ACL_MAX_ENTRIES 25
....
/* On-disk XFS access control list structure */
struct xfs_acl {
	__be32	  acl_cnt;
	struct xfs_acl_entry {
		__be32  ae_tag;
		__be32  ae_id;
		__be16  ae_perm;
	} acl_entry[XFS_ACL_MAX_ENTRIES];
};

It's basically a limitation of the on-disk format definition that
has been carried over from Irix. It is an arbitrary limit - the real
limit is the maximum size of an attribute (64KB) and we plan to
raise it to that limit as part of the upcoming on-disk format
changes for metadata checksums...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
