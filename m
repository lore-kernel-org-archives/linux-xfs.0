Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 251DE7F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:06:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E685B8F8033
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:06:54 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Giob32WOnpf41Rpc for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:06:53 -0800 (PST)
Date: Fri, 13 Dec 2013 09:06:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/8] xfs: get rid of XFS_INODE_CLUSTER_SIZE macros
Message-ID: <20131212220651.GE10988@dastard>
References: <52A967DD.3040909@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A967DD.3040909@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Dec 12, 2013 at 03:38:05PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Get rid of XFS_INODE_CLUSTER_SIZE() macros, use mp->m_inode_cluster_size
> directly.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
