Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53GHfTw165289 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 11:17:42 -0500
Subject: Re: [PATCH] xfs: improve xfs_isilocked
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100529095019.GA18859@infradead.org>
References: <20100527190533.GB16102@infradead.org>
	<1275075653.2302.38.camel@doink> <20100529095019.GA18859@infradead.org>
Date: Thu, 03 Jun 2010 11:19:27 -0500
Message-ID: <1275581967.2468.9.camel@doink>
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
Cc: xfs@oss.sgi.com

On Sat, 2010-05-29 at 05:50 -0400, Christoph Hellwig wrote:
> On Fri, May 28, 2010 at 02:40:53PM -0500, Alex Elder wrote:
> > On Thu, 2010-05-27 at 15:05 -0400, Christoph Hellwig wrote:
> > > Use rwsem_is_locked to make the assertations for shared locks work.
> > 
> > So you're changing it so it answers "yes it's locked"
> > even it it's only a read lock now, right?
. . .

> > Now it's "If the exclusive flag is set, but no writer,
> > it's not locked.  Otherwise if the shared flag is
> > set it's locked if rwsem_is_locked() says we are.
> > Otherwise (ASSERT(0) and) it is not locked."
> 
> Not exactly.  Now it's:
> 
>  - if excl is set but shared isn't return true if mr_writer is
>    set, else false
>  - if shared is set either alone or together with excl return
>    if it is locked in any way (rwsem_is_locked).

OK, that makes sense, I get it now.

> Note that xfs_isilocked can be called like:
> 
> 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> 
> which means that either excl or shared is fine.
> 
>  - if either one or both of excl and shared are set and it's 
> 
> > That last part is wrong I think.  It should be OK to
> > call xfs_isilocked() with neither flag set, in which
> > case the result should be 0.
> 
> We can argue about removing the assert, but we currently don't
> and should't call xfs_isilocked wit ha 0 argument - it's rather
> pointless to do so.

Yes, you're right.  I'd still say the function should
return the right answer even if given an unreasonable
request.  But that's being pedantic.

> 
> > And if the exclusive
> > flag is set, and there *is* a writer, it *is* locked,
> > so it should return 1.
> 
> We do that right now.

Yup.  Thanks for setting me straight.

Reviewed-by: Alex Elder <aelder@sgi.com>




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
