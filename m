Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1542E7F5F
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 03:07:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 093D3304032
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 01:07:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iX58vDHOEBFDTIvk for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 01:07:00 -0700 (PDT)
Date: Mon, 31 Aug 2015 18:06:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/22] xfs: %pF is only for function pointers
Message-ID: <20150831080657.GF26895@dastard>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
	<1426130037-17956-21-git-send-email-scottwood@freescale.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426130037-17956-21-git-send-email-scottwood@freescale.com>
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
To: Scott Wood <scottwood@freescale.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 11, 2015 at 10:13:56PM -0500, Scott Wood wrote:
> Use %pS for actual addresses, otherwise you'll get bad output
> on arches like ppc64 where %pF expects a function descriptor.
> 
> Signed-off-by: Scott Wood <scottwood@freescale.com>
> Cc: xfs@oss.sgi.com

Scott, I've just found that this change (commit 65dd297 "xfs: %pF is
only for function pointers") breaks the symbolic printing in XFS
trace events on x86_64. eg.

> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 51372e3..b5ac81e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -115,7 +115,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
>  		__entry->refcount = refcount;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d agno %u refcount %d caller %pf",
> +	TP_printk("dev %d:%d agno %u refcount %d caller %ps",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->refcount,

This results in output like this:

760.828474: xfs_perag_get:  dev 253:32 agno 13 refcount 10 caller 0xffffffff814eef02s
760.828476: xfs_perag_put:  dev 253:32 agno 13 refcount 9 caller 0xffffffff814eefe8s

When I revert this commit, I get:

71.911265: xfs_perag_get:   dev 253:32 agno 0 refcount 11 caller xfs_extent_busy_insert
71.911266: xfs_perag_put:   dev 253:32 agno 0 refcount 10 caller xfs_extent_busy_insert

Which is exactly what we should be getting from the tracing. I'm
using trace-cmd to gather and print the events, and it breaks
both old and current versions of trace-cmd.

Can you please look into why this change broke the tracing output
on x86-64 - if there is no obvious/easy fix for it, then I'm simply
going to revert it because having the tracing work correctly on
x86-64 is far more important to us than ppc64 or ia64....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
