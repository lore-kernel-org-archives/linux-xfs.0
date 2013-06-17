Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B771129DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 16:58:06 -0500 (CDT)
Date: Mon, 17 Jun 2013 16:58:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Remove redundant error variable from
	xfs_growfs_data_private()
Message-ID: <20130617215805.GH20932@sgi.com>
References: <51924F2D.8030706@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51924F2D.8030706@oracle.com>
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

On Tue, May 14, 2013 at 10:50:21PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Commit eab4e633 "xfs: uncached buffer reads need to return an error".
> 
> Remove redundant error variable, using the function level error variable
> to store bp->b_error instead.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
