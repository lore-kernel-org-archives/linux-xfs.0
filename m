Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF01B7FA9
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:40:33 -0500 (CDT)
Date: Thu, 14 Mar 2013 16:40:33 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Remove obsoleted m_inode_shrink from xfs_mount
	structure
Message-ID: <20130314214033.GY22182@sgi.com>
References: <513D7A26.3030401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513D7A26.3030401@oracle.com>
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
Cc: dchinner@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Mar 11, 2013 at 02:31:02PM +0800, Jeff Liu wrote:
> Looks the old m_inode_shrink is obsoleted as we perform inodes reclaim per AG via
> m_reclaim_workqueue, this patch remove it from the xfs_mount structure if so.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
