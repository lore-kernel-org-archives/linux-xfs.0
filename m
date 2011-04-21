Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LK6Bjf172875 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 15:06:11 -0500
Subject: Re: xfs build warning
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110415173902.GA27378@infradead.org>
References: <4DA876C2.8050606@oracle.com>
	<20110415173902.GA27378@infradead.org>
Date: Thu, 21 Apr 2011 15:08:10 -0500
Message-ID: <1303416490.2581.518.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, xfs@oss.sgi.com

On Fri, 2011-04-15 at 13:39 -0400, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 09:48:02AM -0700, Randy Dunlap wrote:
> > on i386, when CONFIG_LBDAF is not enabled:
> > 
> > fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
> 
> This should fix it:

Looks good.  Christoph, can I assume your signoff?

I wonder whether we'll ever need to cast the other
fields that are based on abstractions from __uint32_t
(like xfs_agblock_t, xfs_extlen_t, ...).

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
