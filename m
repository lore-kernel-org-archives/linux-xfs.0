Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 764637F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 17:42:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09DCAAC002
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 15:42:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IHIRQOgu2R9GFSmJ for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 15:41:58 -0700 (PDT)
Date: Fri, 20 Mar 2015 09:41:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150319224143.GI10105@dastard>
References: <CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
	<CA+55aFyxA9u2cVzV+S7TSY9ZvRXCX=z22YAbi9mdPVBKmqgR5g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyxA9u2cVzV+S7TSY9ZvRXCX=z22YAbi9mdPVBKmqgR5g@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 02:41:48PM -0700, Linus Torvalds wrote:
> On Wed, Mar 18, 2015 at 10:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So I think there's something I'm missing. For non-shared mappings, I
> > still have the idea that pte_dirty should be the same as pte_write.
> > And yet, your testing of 3.19 shows that it's a big difference.
> > There's clearly something I'm completely missing.
> 
> Ahh. The normal page table scanning and page fault handling both clear
> and set the dirty bit together with the writable one. But "fork()"
> will clear the writable bit without clearing dirty. For some reason I
> thought it moved the dirty bit into the struct page like the VM
> scanning does, but that was just me having a brainfart. So yeah,
> pte_dirty doesn't have to match pte_write even under perfectly normal
> circumstances. Maybe there are other cases.
> 
> Not that I see a lot of forking in the xfs repair case either, so..
> 
> Dave, mind re-running the plain 3.19 numbers to really verify that the
> pte_dirty/pte_write change really made that big of a difference. Maybe
> your recollection of ~55,000 migrate_pages events was faulty. If the
> pte_write ->pte_dirty change is the *only* difference, it's still very
> odd how that one difference would make migrate_rate go from ~55k to
> 471k. That's an order of magnitude difference, for what really
> shouldn't be a big change.

My recollection wasn't faulty - I pulled it from an earlier email.
That said, the original measurement might have been faulty. I ran
the numbers again on the 3.19 kernel I saved away from the original
testing. That came up at 235k, which is pretty much the same as
yesterday's test. The runtime,however, is unchanged from my original
measurements of 4m54s (pte_hack came in at 5m20s).

Wondering where the 55k number came from, I played around with when
I started the measurement - all the numbers since I did the bisect
have come from starting it at roughly 130AGs into phase 3 where the
memory footprint stabilises and the tlb flush overhead kicks in.

However, if I start the measurement at the same time as the repair
test, I get something much closer to the 55k number. I also note
that my original 4.0-rc1 numbers were much lower than the more
recent steady state measurements (360k vs 470k), so I'd say the
original numbers weren't representative of the steady state
behaviour and so can be ignored...

> Maybe a system update has changed libraries and memory allocation
> patterns, and there is something bigger than that one-liner
> pte_dirty/write change going on?

Possibly. The xfs_repair binary has definitely been rebuilt (testing
unrelated bug fixes that only affect phase 6/7 behaviour), but
otherwise the system libraries are unchanged.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
