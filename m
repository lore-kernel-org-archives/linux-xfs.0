Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4H0Mwqb212228 for <xfs@oss.sgi.com>; Sun, 16 May 2010 19:22:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82A43348598
	for <xfs@oss.sgi.com>; Sun, 16 May 2010 17:25:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	O4fWUJX4Gyqh1IWC for <xfs@oss.sgi.com>;
	Sun, 16 May 2010 17:25:14 -0700 (PDT)
Date: Mon, 17 May 2010 10:24:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Defrag in shrinkers
Message-ID: <20100517002444.GJ8120@dastard>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
	<alpine.DEB.2.00.1005141244380.9466@router.home>
	<87y6fmmdak.fsf@basil.nowhere.org> <201005151308.18090.edt@aei.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005151308.18090.edt@aei.ca>
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
To: Ed Tomlinson <edt@aei.ca>
Cc: npiggin@suse.de, Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org, Christoph Lameter <cl@linux.com>

On Sat, May 15, 2010 at 01:08:17PM -0400, Ed Tomlinson wrote:
> On Friday 14 May 2010 16:36:03 Andi Kleen wrote:
> > Christoph Lameter <cl@linux.com> writes:
> > 
> > > Would it also be possible to add some defragmentation logic when you
> > > revise the shrinkers? Here is a prototype patch that would allow you to
> > > determine the other objects sitting in the same page as a given object.
> > >
> > > With that I hope that you have enough information to determine if its
> > > worth to evict the other objects as well to reclaim the slab page.
> > 
> > I like the idea, it would be useful for the hwpoison code too,
> > when it tries to clean a page.
> 
> If this is done generally we probably want to retune the 'pressure' put on the slab.  The
> whole reason for the callbacks was to keep the 'pressure on the slab proportional to the
> memory pressure (scan rate).  

I don't see that defrag based reclaim changes the concept of
pressure at all. As long as reclaim follows the nr_to_scan
guideline, then it doesn't matter if we do reclaim from the LRU or
reclaim from a list provided by the slab cache....

FWIW, one thing that would be necessary, I think, is to avoid defrag
until a certain level of fragmentation has occurred - we should do
LRU-based reclaim as much as possible, and only trigger defrag-style
reclaim once we hit a trigger (e.g. once the slab is 25% partial
pages).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
