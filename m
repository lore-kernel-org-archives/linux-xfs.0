Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfDDQdS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:33:18 -0400
Subject: Re: [PATCH 49/36] xfs_scrub: remove redundant function declarations
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190401164317.GA5147@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1711899c-e4d4-03a2-f109-94d57ecd4097@sandeen.net>
Date: Thu, 4 Apr 2019 11:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <20190401164317.GA5147@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 4/1/19 11:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove a redundant function declaration.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/scrub.h |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/scrub/scrub.h b/scrub/scrub.h
> index 34c3dd30..e6e3f16f 100644
> --- a/scrub/scrub.h
> +++ b/scrub/scrub.h
> @@ -25,8 +25,6 @@ bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
>  		struct xfs_action_list *alist);
>  bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
>  		struct xfs_action_list *alist);
> -enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
> -		struct action_item *aitem, unsigned int flags);
>  
>  bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
>  bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
> 
