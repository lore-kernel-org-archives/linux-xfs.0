Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D314829DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:50:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D006AC001
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:50:53 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tWD2EhWGEu2mz4vY for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:50:51 -0800 (PST)
Date: Tue, 3 Dec 2013 09:50:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/15] mkfs: Sanitise the superblock feature macros
Message-ID: <20131202225047.GZ10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-4-git-send-email-david@fromorbit.com>
	<20131202104302.GC21394@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202104302.GC21394@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 02, 2013 at 02:43:02AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 12:43:38PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > They are horrible macros that simply obfuscate the code, so
> > let's factor the code and make them nice functions.
> > 
> > To do this, add a sb_feat_args structure that carries around the
> > variables rather than a strange assortment of variables. This means
> > all the default can be clearly defined in a structure
> > initialisation, and dependent feature bits are easy to check.
> 
> Nice clean,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But one minor nitpick:
> 
> > +	bool	projid16bit;
> 
> Given that 32-bit projids are the newer feature I'd make them the
> flag instead of inverting it, which is how all the other flags work.

Fair enough - I just converted the existing variables to a
structure. I'll fix that up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
