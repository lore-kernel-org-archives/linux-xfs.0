Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B405229E09
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 18:27:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F5BEAC004
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 16:27:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HpGC862z82gMxK7F for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 16:27:48 -0700 (PDT)
Date: Sat, 27 Sep 2014 09:27:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
Message-ID: <20140926232745.GS4945@dastard>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
	<1411697952-24741-3-git-send-email-david@fromorbit.com>
	<20140926120104.GA10574@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926120104.GA10574@infradead.org>
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

On Fri, Sep 26, 2014 at 05:01:04AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 26, 2014 at 12:19:09PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The XLOG_UNMOUNT_TRANS case skips the transaction, despite the fact
> > an unmount record is always in a standalone transaction. Hence
> > whenever we come across one of these we need to free the transaction
> > structure associated with it as there is no commit record that
> > follows it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > @@ -3600,8 +3605,10 @@ xlog_recover_ophdr_to_trans(
> >  	 * on this opheader is allocate a new recovery container to hold
> >  	 * the recovery ops that will follow.
> >  	 */
> > -	if (ohead->oh_flags & XLOG_START_TRANS)
> > +	if (ohead->oh_flags & XLOG_START_TRANS) {
> > +		ASSERT(be32_to_cpu(ohead->oh_len) == 0);
> >  		xlog_recover_new_tid(rhp, tid, be64_to_cpu(rhead->h_lsn));
> > +	}
> >  	return NULL;
> 
> .. but I suspect this hunk fits better into the previous patch.

Folded it into the first patch.

> Also shouldn't we handle any sort of on disk corruption more gracefully?

Yes, we should. However, the recovery code is so full of this sort
of ASSERT() checking that graceful handling of errors is fairly
significant piece of work. It's already on my "cleanup work for a
rainy day" list. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
