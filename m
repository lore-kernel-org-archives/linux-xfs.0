Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC00B7F5A
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 02:12:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46456AC008
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 00:12:53 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 2oTJrYFrcOgtNpZM for
	<xfs@oss.sgi.com>; Wed, 31 Jul 2013 00:12:51 -0700 (PDT)
Message-ID: <51F8B944.1060807@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 15:14:12 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 6/7] xfs: add capable check to free eofblocks ioctl
References: <20130729230705.128e4509@oracle.com>
In-Reply-To: <20130729230705.128e4509@oracle.com>
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

On 07/30/2013 11:07 AM, Dwight Engen wrote:
> Check for CAP_SYS_ADMIN since the caller can truncate preallocated
> blocks from files they do not own nor have write access to. A more
> fine grained access check was considered: require the caller to
> specify their own uid/gid and to use inode_permission to check for
> write, but this would not catch the case of an inode not reachable
> via path traversal from the callers mount namespace.
> 
> Add check for read-only filesystem to free eofblocks ioctl.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
