Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40504 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbeLRRVq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:21:46 -0500
Subject: Re: [PATCH 5/6] xfs: stringify btree cursor types in ftrace output
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344776323.4341.3184468728000538253.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <64a9bdda-e5b9-bed8-5800-c5872ea5c8ce@sandeen.net>
Date: Tue, 18 Dec 2018 11:21:44 -0600
MIME-Version: 1.0
In-Reply-To: <154344776323.4341.3184468728000538253.stgit@magnolia>
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
> Use __print_symbolic to print the btree type in ftrace output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, and because XFS_BTNUM_BNOi *shudder* et al are enums, you also
need the fancy wrappers.

> ---
>  fs/xfs/libxfs/xfs_types.h |    9 +++++++++
>  fs/xfs/scrub/trace.h      |   38 ++++++++++++++++++++++++++------------
>  fs/xfs/xfs_trace.h        |   12 ++++++++++--
>  3 files changed, 45 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 297cf2318f83..eb04afe9cce0 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -114,6 +114,15 @@ typedef enum {
>  	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
>  } xfs_btnum_t;
>  
> +#define XFS_BTNUM_STRINGS \
> +	{ XFS_BTNUM_BNOi,	"bnobt" }, \
> +	{ XFS_BTNUM_CNTi,	"cntbt" }, \
> +	{ XFS_BTNUM_RMAPi,	"rmapbt" }, \
> +	{ XFS_BTNUM_BMAPi,	"bmbt" }, \
> +	{ XFS_BTNUM_INOi,	"inobt" }, \
> +	{ XFS_BTNUM_FINOi,	"finobt" }, \
> +	{ XFS_BTNUM_REFCi,	"refcbt" }
> +

how do we decide whether to put these string translations for trace in common
headers (as here) vs. in the the trace file itself (as with, say,
XFS_AG_BTREE_CMP_FORMAT_STR) ?

-Eric
