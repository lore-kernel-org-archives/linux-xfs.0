Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4F1DfV7055540 for <xfs@oss.sgi.com>; Fri, 14 May 2010 20:13:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95B093443F0
	for <xfs@oss.sgi.com>; Fri, 14 May 2010 18:15:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	FKowVC1Bm0tTDdRu for <xfs@oss.sgi.com>;
	Fri, 14 May 2010 18:15:56 -0700 (PDT)
Date: Sat, 15 May 2010 11:15:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Defrag in shrinkers (was Re: [PATCH 0/5] Per-superblock shrinkers)
Message-ID: <20100515011523.GG8120@dastard>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
	<alpine.DEB.2.00.1005141244380.9466@router.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005141244380.9466@router.home>
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
To: Christoph Lameter <cl@linux.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>, linux-fsdevel@vger.kernel.org

On Fri, May 14, 2010 at 12:46:52PM -0500, Christoph Lameter wrote:
> Would it also be possible to add some defragmentation logic when you
> revise the shrinkers? Here is a prototype patch that would allow you to
> determine the other objects sitting in the same page as a given object.
> 
> With that I hope that you have enough information to determine if its
> worth to evict the other objects as well to reclaim the slab page.

I'll have a think about how this might fit in - the real problem is
when the list returns objects that belong to a different superblock.
We can only safely check whether the object belongs to the current
superblock - to check if it belongs to a different sb we a lot of
locks and reference counting to juggle. That would require
re-introducing all the muck (and then some) that this patchset
removes from the shrinkers.

Perhaps just freeing the objects that belong to the current sb would
be sufficient to realise significant improvements (will be fine for
systems that only have one active or dominant filesystem), but i
think some experimentation would be needed.

The that brings us to test cases - we need a good one. I think we
need to re-evaluate where we stand with regard to slab fragmentation
(which probably hasn't changed much), and we need to be able to
quantify the amount of improvement the increase in complexity will
provide.  I don't have anything close to hand to generate such
fragmentation, so it might take a little time to write a test that
does the IO patterns I know will generate problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
