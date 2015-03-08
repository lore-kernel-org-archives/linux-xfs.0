Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AEF637F5D
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 05:02:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 805EE8F8037
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 03:02:32 -0700 (PDT)
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id HojKqSC5Aalmf3wj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Mar 2015 03:02:30 -0700 (PDT)
Received: by wggy19 with SMTP id y19so4906682wgg.9
	for <xfs@oss.sgi.com>; Sun, 08 Mar 2015 03:02:29 -0700 (PDT)
Date: Sun, 8 Mar 2015 11:02:23 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150308100223.GC15487@gmail.com>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
	<20150307163657.GA9702@gmail.com>
	<CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Mar 7, 2015 at 8:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > And the patch Dave bisected to is a relatively simple patch. Why 
> > not simply revert it to see whether that cures much of the 
> > problem?
> 
> So the problem with that is that "pmd_set_numa()" and friends simply 
> no longer exist. So we can't just revert that one patch, it's the 
> whole series, and the whole point of the series.

Yeah.

> What confuses me is that the only real change that I can see in that 
> patch is the change to "change_huge_pmd()". Everything else is 
> pretty much a 100% equivalent transformation, afaik. Of course, I 
> may be wrong about that, and missing something silly.

Well, there's a difference in what we write to the pte:

 #define _PAGE_BIT_NUMA          (_PAGE_BIT_GLOBAL+1)
 #define _PAGE_BIT_PROTNONE      _PAGE_BIT_GLOBAL

and our expectation was that the two should be equivalent methods from 
the POV of the NUMA balancing code, right?

> And the changes to "change_huge_pmd()" were basically re-done
> differently by subsequent patches anyway.
> 
> The *only* change I see remaining is that change_huge_pmd() now does
> 
>    entry = pmdp_get_and_clear_notify(mm, addr, pmd);
>    entry = pmd_modify(entry, newprot);
>    set_pmd_at(mm, addr, pmd, entry);
> 
> for all changes. It used to do that "pmdp_set_numa()" for the
> prot_numa case, which did just
> 
>    pmd_t pmd = *pmdp;
>    pmd = pmd_mknuma(pmd);
>    set_pmd_at(mm, addr, pmdp, pmd);
> 
> instead.
> 
> I don't like the old pmdp_set_numa() because it can drop dirty bits,
> so I think the old code was actively buggy.

Could we, as a silly testing hack not to be applied, write a 
hack-patch that re-introduces the racy way of setting the NUMA bit, to 
confirm that it is indeed this difference that changes pte visibility 
across CPUs enough to create so many more faults?

Because if the answer is 'yes', then we can safely say: 'we regressed 
performance because correctness [not dropping dirty bits] comes before 
performance'.

If the answer is 'no', then we still have a mystery (and a regression) 
to track down.

As a second hack (not to be applied), could we change:

 #define _PAGE_BIT_PROTNONE      _PAGE_BIT_GLOBAL

to:

 #define _PAGE_BIT_PROTNONE      (_PAGE_BIT_GLOBAL+1)

to double check that the position of the bit does not matter?

I don't think we've exhaused all avenues of analysis here.

Thanks,

	Ingo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
