Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 989CD7F3F
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 20:29:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83CBF304053
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:29:49 -0700 (PDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	zr560SKmwfR67KfH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 18:29:47 -0700 (PDT)
Received: by igcau2 with SMTP id au2so6029160igc.0
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:29:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150320002311.GG28621@dastard>
References: <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
	<CA+55aFyxA9u2cVzV+S7TSY9ZvRXCX=z22YAbi9mdPVBKmqgR5g@mail.gmail.com>
	<20150319224143.GI10105@dastard>
	<CA+55aFy5UeNnFUTi619cs3b9Up2NQ1wbuyvcCS614+o3=z=wBQ@mail.gmail.com>
	<20150320002311.GG28621@dastard>
Date: Thu, 19 Mar 2015 18:29:47 -0700
Message-ID: <CA+55aFyqXDVv9JkkhvM26x6PC5V82corR7HQNxmkeGZjOCxD=A@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 5:23 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Bit more variance there than the pte checking, but runtime
> difference is in the noise - 5m4s vs 4m54s - and profiles are
> identical to the pte checking version.

Ahh, so that "!(vma->vm_flags & VM_WRITE)" test works _almost_ as well
as the original !pte_write() test.

Now, can you check that on top of rc4? If I've gotten everything
right, we now have:

 - plain 3.19 (pte_write): 4m54s
 - 3.19 with vm_flags & VM_WRITE: 5m4s
 - 3.19 with pte_dirty: 5m20s

so the pte_dirty version seems to have been a bad choice indeed.

For 4.0-rc4, (which uses pte_dirty) you had 7m50s, so it's still
_much_ worse, but I'm wondering whether that VM_WRITE test will at
least shrink the difference like it does for 3.19.

And the VM_WRITE test should be stable and not have any subtle
interaction with the other changes that the numa pte things
introduced. It would be good to see if the profiles then pop something
*else* up as the performance difference (which I'm sure will remain,
since the 7m50s was so far off).

                        Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
