Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93DF88045
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:27:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EFDF8F804C
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:27:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0T5RsQSB6vp2r5k1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:27:33 -0800 (PST)
Date: Thu, 5 Feb 2015 09:27:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: replace xfs_mod_incore_sb_batched
Message-ID: <20150205142707.GK31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-7-git-send-email-david@fromorbit.com>
	<20150205141044.GH31625@laptop.bfoster>
	<20150205141954.GA18047@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150205141954.GA18047@infradead.org>
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

On Thu, Feb 05, 2015 at 06:19:54AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 05, 2015 at 09:10:44AM -0500, Brian Foster wrote:
> > >  	/* apply remaining deltas */
> > > +	spin_lock(&mp->m_sb_lock);
> > >  	if (rtxdelta) {
> > > -		error = xfs_mod_frextents(mp, rtxdelta);
> > > +		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
> > 
> > Any reason why we don't continue to use the xfs_mod_frextents() function
> > introduced in the previous patch? Seems like we should be consistent one
> > way or the other.
> 
> We're already under the sb_lock and would need another lock roundtrip to
> avoid a deadlock in that case.  But mit might be worth to simply make
> the real time extent counter a percpu one to behave similar to the other
> counters that can be manipulated outside of the transaction commit code.
> 

Ah, thanks... missed that the lock was taken there. This one looks fine
to me as well:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
