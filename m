Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p03AtUSF075916 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 04:55:30 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 507E71617918
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 02:57:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A56S5kCoD62VtEfA for
	<xfs@oss.sgi.com>; Mon, 03 Jan 2011 02:57:36 -0800 (PST)
Date: Mon, 3 Jan 2011 11:57:23 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: xfs: add FITRIM support
In-Reply-To: <20101230114129.GA4321@infradead.org>
Message-ID: <alpine.LFD.2.00.1101031152101.2815@dhcp-lab-213.englab.brq.redhat.com>
References: <20101125112304.GA4195@infradead.org>
	<20101223014409.GL4907@dastard>
	<20101230114129.GA4321@infradead.org>
MIME-Version: 1.0
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
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Thu, 30 Dec 2010, Christoph Hellwig wrote:

> On Thu, Dec 23, 2010 at 12:44:09PM +1100, Dave Chinner wrote:
> > Hmmmm - if we are given a range to trim, wouldn't we do better to
> > walk the by-bno btree instead?  i.e, we have two different cases
> > here - trim an entire AG, and trim part of an AG given by {start, end}. 
> > 
> > We only need these range checks on the AGs that are only partially
> > trimmed, and it would seem more efficient to me to walk the by-bno
> > tree for those rather than walk the by-size tree trying to find
> > range matches.
> 
> It might be, but I'm not sure it's really worth the complexity.  I can't
> really find any good use case for a partially trim anyway.
> 
> Ccing Lukas to figure out what his intent with this was.

Hi, I assume that you're talking about situation, when you call FITRIM
with start and len not covering the whole filesystem possibly resulting
in trimming just a part of the AG ? In this case I just copy my answer
from previous mail...

I had two reasons to do this as it is, but only one is really worth it.
Since we want to run FITRIM from the userspace on the background, we want
to disturb other IO as little as possible and whole filesystem trim can
take minutes on some devices (not talking about LUNs which is even more
painful). So you'll probably agree that we do not want to have possibly
minute long stalls when doing FITRIM. And presumably we do not want the
users to care about the size of AG, nor the blocksize (preferably).

But it is optional, so if you have fast device with small, not very
fragmented filesystem you can end up doing FITRIM on the whole filesystem
at once and it will be the right thing to do. Also, some might want to
have nice-n-shiny progress bars:).

Thanks!
-Lukas

> 
> > Hmmm - so we hold the agf locked for the entire trim? That's a bit
> > ugly. Given this is best effort, we could avoid this by changing it
> > to something like:
> > 
> > 	longest = 0;
> > 	do {
> > 		lock agf
> > 		force log
> > 		if (!longest)
> > 			longest = agf->longest
> > 		init cursor
> > 		do {
> > 			xfs_alloc_lookup_le(longest)
> > 			alloc_get_rec(&fbno, &flen)
> > 			check flen
> > 			busy search
> > 			discard
> > 			decrement cursor
> > 		} while (flen == longest)
> > 		destroy cursor
> > 		unlock agf
> > 		longest = flen;
> > 	} while(1)
> 
> This doesn't seem overly efficient.  Unless we have lots of extents
> with same size we keep having to allocate new cursors all the time.
> 
> I'm not too worried about busy systems - FITRIM is explicitly called and
> we should expect admins not to call it during the most busy time of the
> day.  And even in it's current form it's already much better than
> wiper.sh in that respect.
> 
> I think adding a periodical break using a modified scheme is fine, but
> I'd really like to get the code out into some more testers hands for
> now.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
