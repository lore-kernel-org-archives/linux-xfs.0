Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41236 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbeLRRaS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:30:18 -0500
Subject: Re: [PATCH 6/6] xfs: stringify scrub types in ftrace output
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344776951.4341.14323367177195315854.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <32a11dec-500d-1b18-49fa-86aa8c45f0f7@sandeen.net>
Date: Tue, 18 Dec 2018 11:30:16 -0600
MIME-Version: 1.0
In-Reply-To: <154344776951.4341.14323367177195315854.stgit@magnolia>
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
> Use __print_symbolic to print the scrub type in ftrace output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/trace.h |  103 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 77 insertions(+), 26 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 0141eb1ac091..3c83e8b3b39c 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -26,6 +26,57 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
>  TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
>  TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
>  
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PROBE);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SB);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGF);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGFL);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGI);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BNOBT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_CNTBT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_INOBT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FINOBT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RMAPBT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_REFCNTBT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_INODE);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTD);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTA);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTC);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIR);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_XATTR);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SYMLINK);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PARENT);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTBITMAP);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTSUM);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
> +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
> +
> +#define XFS_SCRUB_TYPE_STRINGS \

Hm I thought you just moved these sorts of #defines /out/ of the trace files
and adjacent to their type definitions in core header files; why not this one?

> +	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
> +	{ XFS_SCRUB_TYPE_SB,		"sb" }, \
> +	{ XFS_SCRUB_TYPE_AGF,		"agf" }, \
> +	{ XFS_SCRUB_TYPE_AGFL,		"agfl" }, \
> +	{ XFS_SCRUB_TYPE_AGI,		"agi" }, \
> +	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \

-Eric
