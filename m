Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D59E7F75
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 09:10:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86370AC005
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 07:10:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6rwgS8DebTZ5db3c for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 07:10:43 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 15F9263C3BC5
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 09:10:43 -0600 (CST)
Subject: Re: [PATCH 00/11] xfsprogs misc fixes
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565F09F2.9090709@sandeen.net>
Date: Wed, 2 Dec 2015 09:10:42 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
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
To: xfs@oss.sgi.com

Thanks, I'll help look over these.

Could you please map the coverity CIDs to these fixes?

We like to include that in the commit metadata.

Thanks,
-Eric

On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> minor fixes in xfsprogs, mostly coverity reported fixes.
> 
> Vivek Trivedi (11):
>   xfsprogs: xfs_io: fix a memory leak in imap_f
>   xfsprogs: fix integer overflow in xlog_find_verify_cycle
>   xfsprogs: mkfs: fix unintentional integer overflow
>   xfsprogs: xfsdb: remove unnessary checks in
>     process_leaf_node_dir_v2_free
>   xfsprogs: xfs_mdrestore: check bad read count in perform_restore
>   xfsprogs: xfs_db: check null derefernce after block_to_bt
>   xfsprogs: xfs_fsr: replace sprintf with snprintf to avoid buffer
>     overflow
>   xfsprogs: xfs_repair: fix possible null dereference in build_ino_tree
>   xfsprogs: xfs_repair: fix possible null dereference in
>     traverse_int_dir2block
>   xfsprogs: fix possible null pointer dereference in
>     xfs_iformat_extents
>   xfsprogs: xfs_repair: fix possible null pointer dereference in
>     mark_standalone_inodes
> 
>  db/btblock.c              |    3 +++
>  db/check.c                |    2 --
>  fsr/xfs_fsr.c             |    4 ++--
>  io/imap.c                 |    7 ++++++-
>  libxfs/xfs_inode_fork.c   |    4 ++++
>  libxlog/xfs_log_recover.c |    2 +-
>  mdrestore/xfs_mdrestore.c |    4 ++++
>  mkfs/xfs_mkfs.c           |    2 +-
>  repair/dir2.c             |    2 +-
>  repair/phase5.c           |    2 +-
>  repair/phase6.c           |    7 +++++--
>  11 files changed, 28 insertions(+), 11 deletions(-)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
