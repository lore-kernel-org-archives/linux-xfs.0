Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7ECE57F57
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:13:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69BA9304087
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:13:00 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RDbcyPkJCf2OoTNg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:12:59 -0800 (PST)
Message-ID: <529D05AB.7080306@oracle.com>
Date: Mon, 02 Dec 2013 16:11:55 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] [PATCH 15/18] jfs: use generic posix ACL
	infrastructure
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.391407780@bombadil.infradead.org>
In-Reply-To: <20131201120656.391407780@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

On 12/01/2013 05:59 AM, Christoph Hellwig wrote:
> Copy the scheme I introduced to btrfs many years ago to only use the
> xattr handler for ACLs, but pass plain attrs straight through.

Looks good.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>  fs/jfs/acl.c       |  105 ++++++++++++++++++++------------------------------
>  fs/jfs/file.c      |    4 +-
>  fs/jfs/jfs_acl.h   |    7 +---
>  fs/jfs/jfs_xattr.h |    2 +
>  fs/jfs/namei.c     |    1 +
>  fs/jfs/super.c     |    2 +
>  fs/jfs/xattr.c     |  108 ++++++++++++++++++----------------------------------
>  7 files changed, 89 insertions(+), 140 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
