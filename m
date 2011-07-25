Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PEqoxC006601 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 09:52:50 -0500
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Mon, 25 Jul 2011 09:51:40 -0500
Message-ID: <1311605500.2914.12.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-07-22 at 16:39 -0700, Chandra Seetharaman wrote:
> Remove the definition and usage of the macro XFS_BUF_ZEROFLAGS.
> 
> In the specific contexts, not all flags need to be cleared. Hence the
> simplification.
> 
> Rationale for xfs_log.c:
> from hch: XBF_READ and XBF_DELWRI will never be set here, XBF_WRITE
> XBF_ASYNC, and XBF_SYNCIO are set just below.
> Hence clearing only XBF_FUA and XBF_FLUSH would suffice.
> 
> Rationale for xfs_log_recover.c
> from hch: XBF_READ, XBF_WRITE, XBF_ASYNC and XBF_DELWRI already get dealt with
> in xfs_bwrite a few lines down.
> from hch: XBF_SYNCIO, XBF_FUA and XBF_FLUSH are used only in log buffers. No
> need to clear them here.

Sorry, I reviewed this last week and signed off on it
but I see it's stuck in my mail outbox for some reason.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
