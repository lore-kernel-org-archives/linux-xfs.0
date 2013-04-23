Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D2E17F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 07:51:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5BDEAC006
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 05:51:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QRZCaEfb8BaPopAh for
	<xfs@oss.sgi.com>; Tue, 23 Apr 2013 05:51:41 -0700 (PDT)
Message-ID: <5176833C.8070305@redhat.com>
Date: Tue, 23 Apr 2013 08:49:00 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: introduce CONFIG_XFS_WARN
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1366699138-24055-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/23/2013 02:38 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
...
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index cd29f61..d3e0679 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -405,7 +405,7 @@ typedef struct xfs_trans {
>  	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
>  	int64_t			t_frextents_delta;/* superblock freextents chg*/
>  	int64_t			t_res_frextents_delta; /* on-disk only chg */
> -#ifdef DEBUG
> +#if defined(DEBUG) || defined(XFS_WARN)
>  	int64_t			t_ag_freeblks_delta; /* debugging counter */
>  	int64_t			t_ag_flist_delta; /* debugging counter */
>  	int64_t			t_ag_btree_delta; /* debugging counter */
> 

I see some ASSERT() calls using these counters but the macros that
manage them appear to be defined against DEBUG only (further down in
xfs_trans.h). This looks like it would lead to spurious warnings..?

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
