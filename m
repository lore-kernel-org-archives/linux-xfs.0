Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1BFC7F37
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 17:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9028B304039
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 15:24:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GdmbuEVKwQtFSOVc for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 15:24:03 -0700 (PDT)
Date: Thu, 19 Mar 2015 09:23:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150318222314.GD28621@dastard>
References: <20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>

On Wed, Mar 18, 2015 at 10:31:28AM -0700, Linus Torvalds wrote:
> On Wed, Mar 18, 2015 at 9:08 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So why am I wrong? Why is testing for dirty not the same as testing
> > for writable?
> >
> > I can see a few cases:
> >
> >  - your load has lots of writable (but not written-to) shared memory
> 
> Hmm. I tried to look at the xfsprog sources, and I don't see any
> MAP_SHARED activity.  It looks like it's just using pread64/pwrite64,
> and the only MAP_SHARED is for the xfsio mmap test thing, not for
> xfsrepair.
> 
> So I don't see any shared mappings, but I don't know the code-base.

Right - all the mmap activity in the xfs_repair test is coming from
memory allocation through glibc - we don't use mmap() directly
anywhere in xfs_repair. FWIW, all the IO into these pages that are
allocated is being done via direct IO, if that makes any
difference...

> >  - something completely different that I am entirely missing
> 
> So I think there's something I'm missing. For non-shared mappings, I
> still have the idea that pte_dirty should be the same as pte_write.
> And yet, your testing of 3.19 shows that it's a big difference.
> There's clearly something I'm completely missing.

This level of pte interactions is beyond my level of knowledge, so
I'm afraid at this point I'm not going to be much help other than to
test patches and report the result.

FWIW, here's the distribution of the hash table we are iterating
over. There are a lot of search misses, which means we are doing a
lot of pointer chasing, but the distribution is centred directly
around the goal of 8 entries per chain and there is no long tail:

libxfs_bcache: 0x67e110
Max supported entries = 808584
Max utilized entries = 808584
Active entries = 808583
Hash table size = 101073
Hits = 9789987
Misses = 8224234
Hit ratio = 54.35
MRU 0 entries =   4667 (  0%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      4 (  0%)
MRU 3 entries = 797447 ( 98%)
MRU 4 entries =    653 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =   2755 (  0%)
MRU 7 entries =   1518 (  0%)
MRU 8 entries =   1518 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =     21 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries     30 (  0%)
Hash buckets with   1 entries    241 (  0%)
Hash buckets with   2 entries   1019 (  0%)
Hash buckets with   3 entries   2787 (  1%)
Hash buckets with   4 entries   5838 (  2%)
Hash buckets with   5 entries   9144 (  5%)
Hash buckets with   6 entries  12165 (  9%)
Hash buckets with   7 entries  14194 ( 12%)
Hash buckets with   8 entries  14387 ( 14%)
Hash buckets with   9 entries  12742 ( 14%)
Hash buckets with  10 entries  10253 ( 12%)
Hash buckets with  11 entries   7308 (  9%)
Hash buckets with  12 entries   4872 (  7%)
Hash buckets with  13 entries   2869 (  4%)
Hash buckets with  14 entries   1578 (  2%)
Hash buckets with  15 entries    894 (  1%)
Hash buckets with  16 entries    430 (  0%)
Hash buckets with  17 entries    188 (  0%)
Hash buckets with  18 entries     88 (  0%)
Hash buckets with  19 entries     24 (  0%)
Hash buckets with  20 entries     11 (  0%)
Hash buckets with  21 entries     10 (  0%)
Hash buckets with  22 entries      1 (  0%)


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
