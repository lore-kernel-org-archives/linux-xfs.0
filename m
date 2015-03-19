Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0184B7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:05:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC2A330408D
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:05:51 -0700 (PDT)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
	[209.85.213.173]) by cuda.sgi.com with ESMTP id
	qFDF5cj7RJ687qFh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 16:05:47 -0700 (PDT)
Received: by igcqo1 with SMTP id qo1so3781991igc.0
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150319224143.GI10105@dastard>
References: <CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
	<CA+55aFyxA9u2cVzV+S7TSY9ZvRXCX=z22YAbi9mdPVBKmqgR5g@mail.gmail.com>
	<20150319224143.GI10105@dastard>
Date: Thu, 19 Mar 2015 16:05:46 -0700
Message-ID: <CA+55aFy5UeNnFUTi619cs3b9Up2NQ1wbuyvcCS614+o3=z=wBQ@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 3:41 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> My recollection wasn't faulty - I pulled it from an earlier email.
> That said, the original measurement might have been faulty. I ran
> the numbers again on the 3.19 kernel I saved away from the original
> testing. That came up at 235k, which is pretty much the same as
> yesterday's test. The runtime,however, is unchanged from my original
> measurements of 4m54s (pte_hack came in at 5m20s).

Ok. Good. So the "more than an order of magnitude difference" was
really about measurement differences, not quite as real. Looks like
more a "factor of two" than a factor of 20.

Did you do the profiles the same way? Because that would explain the
differences in the TLB flush percentages too (the "1.4% from
tlb_invalidate_range()" vs "pretty much everything from migration").

The runtime variation does show that there's some *big* subtle
difference for the numa balancing in the exact TNF_NO_GROUP details.
It must be *very* unstable for it to make that big of a difference.
But I feel at least a *bit* better about "unstable algorithm changes a
small varioation into a factor-of-two" vs that crazy factor-of-20.

Can you try Mel's change to make it use

        if (!(vma->vm_flags & VM_WRITE))

instead of the pte details? Again, on otherwise plain 3.19, just so
that we have a baseline. I'd be *so* much happer with checking the vma
details over per-pte details, especially ones that change over the
lifetime of the pte entry, and the NUMA code explicitly mucks with.

                           Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
