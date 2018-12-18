Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40716 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbeLRRYq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:24:46 -0500
Subject: Re: [PATCH 4/6] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344775711.4341.699323732443443292.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6bc5bc8d-e795-aaa0-2f00-f9878160333f@sandeen.net>
Date: Tue, 18 Dec 2018 11:24:45 -0600
MIME-Version: 1.0
In-Reply-To: <154344775711.4341.699323732443443292.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/18 5:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move XFS_INODE_FORMAT_STR to libxfs so that we don't forget to keep it
> updated, and add necessary TRACE_DEFINE_ENUM.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Now that I think of it, just adding a /* for ftrace */ above the #define
might be nice here and for the others, if you think it's appropriate, but:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_format.h |    7 +++++++
>  fs/xfs/xfs_trace.h         |   10 +++++-----
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b15412e4c535..d8902114786d 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -925,6 +925,13 @@ typedef enum xfs_dinode_fmt {
>  	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
>  } xfs_dinode_fmt_t;
>  
> +#define XFS_INODE_FORMAT_STR \
> +	{ XFS_DINODE_FMT_DEV,		"dev" }, \
> +	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
> +	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
> +	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
> +	{ XFS_DINODE_FMT_UUID,		"uuid" }
> +
>  /*
>   * Inode minimum and maximum sizes.
>   */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3f57002ca660..94e289aca220 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1901,11 +1901,11 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
>  	{ 0,	"target" }, \
>  	{ 1,	"temp" }
>  
> -#define XFS_INODE_FORMAT_STR \
> -	{ 0,	"invalid" }, \
> -	{ 1,	"local" }, \
> -	{ 2,	"extent" }, \
> -	{ 3,	"btree" }
> +TRACE_DEFINE_ENUM(XFS_DINODE_FMT_DEV);
> +TRACE_DEFINE_ENUM(XFS_DINODE_FMT_LOCAL);
> +TRACE_DEFINE_ENUM(XFS_DINODE_FMT_EXTENTS);
> +TRACE_DEFINE_ENUM(XFS_DINODE_FMT_BTREE);
> +TRACE_DEFINE_ENUM(XFS_DINODE_FMT_UUID);
>  
>  DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  	TP_PROTO(struct xfs_inode *ip, int which),
> 
