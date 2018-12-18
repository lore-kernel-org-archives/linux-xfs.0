Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40614 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbeLRRXa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:23:30 -0500
Subject: Re: [PATCH 3/6] xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to
 libxfs
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344775094.4341.5105915870413863379.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c554b1d7-41ce-40e8-5fee-33990e361c87@sandeen.net>
Date: Tue, 18 Dec 2018 11:23:29 -0600
MIME-Version: 1.0
In-Reply-To: <154344775094.4341.5105915870413863379.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/18 5:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move XFS_AG_BTREE_CMP_FORMAT_STR to libxfs so that we don't forget to
> keep it updated, and TRACE_DEFINE_ENUM the values while we're at it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

whoops I skipped right over this when I asked the question this answers
in response to patch 5/6 sorry.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_types.h |    5 +++++
>  fs/xfs/xfs_trace.h        |    7 +++----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 05e8fa558f3e..297cf2318f83 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -104,6 +104,11 @@ typedef enum {
>  	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
>  } xfs_lookup_t;
>  
> +#define XFS_AG_BTREE_CMP_FORMAT_STR \
> +	{ XFS_LOOKUP_EQi,	"eq" }, \
> +	{ XFS_LOOKUP_LEi,	"le" }, \
> +	{ XFS_LOOKUP_GEi,	"ge" }
> +
>  typedef enum {
>  	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
>  	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index dcde4e9907f7..3f57002ca660 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2626,10 +2626,9 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
>  #define DEFINE_AG_EXTENT_EVENT(name) DEFINE_DISCARD_EVENT(name)
>  
>  /* ag btree lookup tracepoint class */
> -#define XFS_AG_BTREE_CMP_FORMAT_STR \
> -	{ XFS_LOOKUP_EQ,	"eq" }, \
> -	{ XFS_LOOKUP_LE,	"le" }, \
> -	{ XFS_LOOKUP_GE,	"ge" }
> +TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
> +TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
> +TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
>  DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agblock_t agbno, xfs_lookup_t dir),
> 
