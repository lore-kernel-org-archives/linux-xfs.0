Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3M4B2jA194236 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 23:11:02 -0500
Date: Fri, 22 Apr 2011 00:14:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs build warning
Message-ID: <20110422041430.GA28590@infradead.org>
References: <4DA876C2.8050606@oracle.com>
	<20110415173902.GA27378@infradead.org>
	<1303416490.2581.518.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303416490.2581.518.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <randy.dunlap@oracle.com>, xfs@oss.sgi.com

On Thu, Apr 21, 2011 at 03:08:10PM -0500, Alex Elder wrote:
> On Fri, 2011-04-15 at 13:39 -0400, Christoph Hellwig wrote:
> > On Fri, Apr 15, 2011 at 09:48:02AM -0700, Randy Dunlap wrote:
> > > on i386, when CONFIG_LBDAF is not enabled:
> > > 
> > > fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
> > 
> > This should fix it:
> 
> Looks good.  Christoph, can I assume your signoff?
> 
> I wonder whether we'll ever need to cast the other
> fields that are based on abstractions from __uint32_t
> (like xfs_agblock_t, xfs_extlen_t, ...).

I'll resend it with a proper changelog and signoff.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
