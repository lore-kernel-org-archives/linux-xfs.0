Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B0AA7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:41:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 389BC304090
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 14:41:51 -0700 (PDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	ECt9hd5WYczt03lE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 14:41:48 -0700 (PDT)
Received: by igcqo1 with SMTP id qo1so2427495igc.0
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 14:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
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
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
Date: Thu, 19 Mar 2015 14:41:48 -0700
Message-ID: <CA+55aFyxA9u2cVzV+S7TSY9ZvRXCX=z22YAbi9mdPVBKmqgR5g@mail.gmail.com>
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

On Wed, Mar 18, 2015 at 10:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I think there's something I'm missing. For non-shared mappings, I
> still have the idea that pte_dirty should be the same as pte_write.
> And yet, your testing of 3.19 shows that it's a big difference.
> There's clearly something I'm completely missing.

Ahh. The normal page table scanning and page fault handling both clear
and set the dirty bit together with the writable one. But "fork()"
will clear the writable bit without clearing dirty. For some reason I
thought it moved the dirty bit into the struct page like the VM
scanning does, but that was just me having a brainfart. So yeah,
pte_dirty doesn't have to match pte_write even under perfectly normal
circumstances. Maybe there are other cases.

Not that I see a lot of forking in the xfs repair case either, so..

Dave, mind re-running the plain 3.19 numbers to really verify that the
pte_dirty/pte_write change really made that big of a difference. Maybe
your recollection of ~55,000 migrate_pages events was faulty. If the
pte_write ->pte_dirty change is the *only* difference, it's still very
odd how that one difference would make migrate_rate go from ~55k to
471k. That's an order of magnitude difference, for what really
shouldn't be a big change.

I'm running a kernel right now with a hacky "update_mmu_cache()" that
warns if pte_dirty is ever different from pte_write().

+void update_mmu_cache(struct vm_area_struct *vma,
+               unsigned long addr, pte_t *ptep)
+{
+       if (!(vma->vm_flags & VM_SHARED)) {
+               pte_t now = READ_ONCE(*ptep);
+               if (!pte_write(now) != !pte_dirty(now)) {
+                       static int count = 20;
+                       static unsigned int prev = 0;
+                       unsigned int val = pte_val(now) & 0xfff;
+                       if (prev != val && count) {
+                               prev = val;
+                               count--;
+                               WARN(1, "pte value %x", val);
+                       }
+               }
+       }
+}

I haven't seen a single warning so far (and there I wrote all that
code to limit repeated warnings), although admittedly
update_mu_cache() isn't called for all cases where we change a pte
(not for the fork case, for example). But it *is* called for the page
faulting cases

Maybe a system update has changed libraries and memory allocation
patterns, and there is something bigger than that one-liner
pte_dirty/write change going on?

                             Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
