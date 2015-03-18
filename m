Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 679347F47
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 11:08:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37DAF304053
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 09:08:50 -0700 (PDT)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) by cuda.sgi.com with ESMTP id
	ynZBkPfTtF6G5JSV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 09:08:45 -0700 (PDT)
Received: by igcau2 with SMTP id au2so67043089igc.0
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 09:08:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150317220840.GC28621@dastard>
References: <CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
	<20150309191943.GF26657@destitution>
	<CA+55aFzFt-vX5Jerci0Ty4Uf7K4_nQ7wyCp8hhU_dB0X4cBpVQ@mail.gmail.com>
	<20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
Date: Wed, 18 Mar 2015 09:08:44 -0700
Message-ID: <CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>

On Tue, Mar 17, 2015 at 3:08 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> Damn. From a performance number standpoint, it looked like we zoomed
>> in on the right thing. But now it's migrating even more pages than
>> before. Odd.
>
> Throttling problem, like Mel originally suspected?

That doesn't much make sense for the original bisect you did, though.

Although if there are two different issues, maybe that bisect was
wrong. Or rather, incomplete.

>> Can you do a simple stupid test? Apply that commit 53da3bc2ba9e ("mm:
>> fix up numa read-only thread grouping logic") to 3.19, so that it uses
>> the same "pte_dirty()" logic as 4.0-rc4. That *should* make the 3.19
>> and 4.0-rc4 numbers comparable.
>
> patched 3.19 numbers on this test are slightly worse than stock
> 3.19, but nowhere near as bad as 4.0-rc4:
>
>         241,718      migrate:mm_migrate_pages           ( +-  5.17% )

Ok, that's still much worse than plain 3.19, which was ~55,000.
Assuming your memory/measurements were the same.

So apparently the pte_write() -> pte_dirty() check isn't equivalent at
all. My thinking that for the common case (ie private mappings) it
would be *exactly* the same, because all normal COW pages turn dirty
at the same time they turn writable (and, in page_mkclean_one(), turn
clean and read-only again at the same time). But if the numbers change
that much, then clearly my simplistic "they are the same in practice"
is just complete BS.

So why am I wrong? Why is testing for dirty not the same as testing
for writable?

I can see a few cases:

 - your load has lots of writable (but not written-to) shared memory,
and maybe the test should be something like

      pte_dirty(pte) || (vma->vm_flags & (VM_WRITE|VM_SHARED) ==
(VM_WRITE|VM_SHARED))

   and we really should have some helper function for this logic.

 - something completely different that I am entirely missing

What am I missing?

                          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
