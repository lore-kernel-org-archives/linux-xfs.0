Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBBBjqmQ181772 for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 05:45:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7270614F515F
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 03:46:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kB160Z3xiCMENcku for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2009 03:46:29 -0800 (PST)
Date: Fri, 11 Dec 2009 06:46:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] [XFS] Replace per-ag array with a radix tree
Message-ID: <20091211114627.GB5436@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-6-git-send-email-david@fromorbit.com>
	<20091210234547.GA28289@infradead.org>
	<20091211004353.GF30608@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091211004353.GF30608@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>
Cc: xfs@oss.sgi.com

On Fri, Dec 11, 2009 at 11:43:53AM +1100, Dave Chinner wrote:
> > > +	spin_lock(&mp->m_perag_lock);
> > > +	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> > > +	spin_unlock(&mp->m_perag_lock);
> > > +	return pag;
> > 
> > Can't we do this as a lock-less (at least for lookups) radix tree?
> 
> I think it can be (RCU-based?) , but I think that makes sense as a
> followup optimisation once we have confidence the code is working
> as it should.

Nick, what are the rules for the lock-less radix tree reader side?

Dave is introducing a radix tree in XFS which has the following access
pattern:

 - lots of read side access during normal fs operations
 - insertations currently only happen during mount before the fs is life
   and during a very rare operation (filesystem resize)
 - currently items are never deleted, but we might need that in the
   future (for filesystem shrink support)
 - the objects pointed to are kmalloced and refcounted structures,
   but we don't even strictly need the refcounting until the filesystem
   shrink support is implemented

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
