Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4B7B7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:43:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91A64304039
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:43:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bWtN4uiDW9tHEm6G for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:43:15 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BA01263C5A9F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:43:14 -0600 (CST)
Subject: Re: [PATCH 06/11] xfsprogs: xfs_db: check null derefernce after
	block_to_bt
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-7-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565FD671.1070600@sandeen.net>
Date: Wed, 2 Dec 2015 23:43:13 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-7-git-send-email-t.vivek@samsung.com>
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

I think this is ok; another "should never happen" scenario,
so the ASSERT seems fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> add assert if block_to_bt returns NULL to avoid null pointer
> dereference and get backtrace.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  db/btblock.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/db/btblock.c b/db/btblock.c
> index 46140fc..91593f8 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -180,6 +180,7 @@ btblock_key_offset(
>  	struct xfs_db_btree	*bt = block_to_bt(block);
>  	int			offset;
>  
> +	ASSERT(bt != NULL);
>  	ASSERT(startoff == 0);
>  	ASSERT(block->bb_level != 0);
>  
> @@ -201,6 +202,7 @@ btblock_ptr_offset(
>  	int			offset;
>  	int			maxrecs;
>  
> +	ASSERT(bt != NULL);
>  	ASSERT(startoff == 0);
>  	ASSERT(block->bb_level != 0);
>  
> @@ -225,6 +227,7 @@ btblock_rec_offset(
>  	struct xfs_db_btree	*bt = block_to_bt(block);
>  	int			offset;
>  
> +	ASSERT(bt != NULL);
>  	ASSERT(startoff == 0);
>  	ASSERT(block->bb_level == 0);
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
