Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1038E7F55
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 01:50:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C0A0AC009
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:50:06 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id qD9DwjefpSw5SEwy for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:50:05 -0700 (PDT)
Message-ID: <51F8B3ED.7040808@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 14:51:25 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/7] xfs: convert kuid_t to/from uid_t in ACLs
References: <20130729230646.715303ed@oracle.com>
In-Reply-To: <20130729230646.715303ed@oracle.com>
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

On 07/30/2013 11:06 AM, Dwight Engen wrote:
> Change permission check for setting ACL to use inode_owner_or_capable()
> which will additionally allow a CAP_FOWNER user in a user namespace to
> be able to set an ACL on an inode covered by the user namespace mapping.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_acl.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
