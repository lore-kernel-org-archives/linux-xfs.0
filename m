Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8EEE07CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 14:27:05 -0500 (CDT)
Date: Wed, 19 Jun 2013 14:27:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Remove two dead transaction log reservaion macros
Message-ID: <20130619192701.GQ20932@sgi.com>
References: <51836A1F.2020804@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51836A1F.2020804@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 03, 2013 at 03:41:19PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Upstream commit 5b292ae3a951a58e32119d73c7ac8f5bec7395a3
> 	xfs: make use of xfs_calc_buf_res() in xfs_trans.c
> 
> Beginning from above commit, neither XFS_ALLOCFREE_LOG_RES() nor
> XFS_DIROP_LOG_RES() is used by those routines for calculating
> transaction space reservations, so it's safe to remove them now.
> 
> Also, with a slightly update for the relevant comments to reflect
> the ideas of why those log count numbers should be.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good.  Applied.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
