Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 985457F37
	for <linux-xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:35:38 -0500 (CDT)
Message-ID: <523A0086.1080000@sgi.com>
Date: Wed, 18 Sep 2013 14:35:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_check: fix test for too-high level in v2 dir node
References: <52322B67.80305@redhat.com>
In-Reply-To: <52322B67.80305@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 09/12/13 16:00, Eric Sandeen wrote:
> The test as it stands allows level == XFS_DA_NODE_MAXDEPTH (5),
> but a max depth of 5 equates to level values of 0 through 4.
>
> Level 5 would be a depth of 6.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>

> diff --git a/db/check.c b/db/check.c
> index cbe55ba..d9e3e3f 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3138,7 +3138,7 @@ process_leaf_node_dir_v2_int(
>   	case XFS_DA_NODE_MAGIC:
>   		node = iocur_top->data;
>   		xfs_da3_node_hdr_from_disk(&nodehdr, node);
> -		if (nodehdr.level<  1 || nodehdr.level>  XFS_DA_NODE_MAXDEPTH) {
> +		if (nodehdr.level<  1 || nodehdr.level>= XFS_DA_NODE_MAXDEPTH) {
>   			if (!sflag || v)
>   				dbprintf(_("bad node block level %d for dir ino "
>   					 "%lld block %d\n"),


I think the current code is correct.

0 is a leaf. levels 1-XFS_DA_NODE_MAXDEPTH are nodes.
Subtract 1 when used as an index.

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
