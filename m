Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C8737F58
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 00:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 287D8AC010
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 22:20:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GxkI4m3YC2nXRRmA for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 22:20:48 -0700 (PDT)
Date: Fri, 19 Jul 2013 15:20:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 2/7] xfs: convert kuid_t to/from uid_t in ACLs
Message-ID: <20130719052046.GT11674@dastard>
References: <20130717114720.1004da49@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130717114720.1004da49@oracle.com>
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
Cc: xfs@oss.sgi.com

On Wed, Jul 17, 2013 at 11:47:20AM -0400, Dwight Engen wrote:
> Change permission check for setting ACL to use inode_owner_or_capable()
> which will additionally allow a CAP_FOWNER user in a user namespace to
> be able to set an ACL on an inode covered by the user namespace mapping.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Looks good. I can tell the conversions are correct just at a glance
now :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
