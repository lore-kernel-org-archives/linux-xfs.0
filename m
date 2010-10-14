Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EIkfOk062552 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 13:46:41 -0500
Subject: Re: [PATCH 1/2] xfsrestore: turn off NODECHK
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101012215400.430780299@sgi.com>
References: <20101012215322.749700656@sgi.com>
	<20101012215400.430780299@sgi.com>
Date: Thu, 14 Oct 2010 13:45:11 -0500
Message-ID: <1287081911.2362.574.camel@doink>
Mime-Version: 1.0
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, 2010-10-12 at 16:53 -0500, wkendall@sgi.com wrote:
> plain text document attachment (no_node_check)
> The NODECHK macro should only be enabled as needed for
> development/debugging.  Having it on limits xfsrestore to
> 268 million directory entries instead of 4 billion. 

I was going to suggest you leave it in the Makefile in
commented-out form, perhaps with an explanation that
it's available for development.  But since NODECHK is
only ever referenced inside "restore/node.c", maybe
such a thing could be done inside that file instead.

I.e., something like:

/*
 * NODECHK can be enabled for development and debugging
 * in order to enforce additional checks on handles
 * when nodes are mapped, unmapped, and freed.  It should
 * not be used for production code, it cuts into the number
 * of directory entries xfsrestore can handle.
 */
/* #define NODECHK */

I'll leave it up to you whether you think that's worth
doing (and if so, let me know).  Either way:

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Index: xfsdump-kernel.org/restore/Makefile
> ===================================================================
> --- xfsdump-kernel.org.orig/restore/Makefile
> +++ xfsdump-kernel.org/restore/Makefile
> @@ -103,7 +103,7 @@ LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBA
>  LTDEPENDENCIES = $(LIBRMT)
>  
>  LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
> -	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DNODECHK -DDIRENTHDR_CHECKSUM \
> +	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DDIRENTHDR_CHECKSUM \
>  	-DF_FSSETDM
>  
>  default: depend $(LTCOMMAND)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
