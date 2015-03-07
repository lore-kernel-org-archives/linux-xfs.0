Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A1057F5A
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 14:56:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D94FBAC001
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 12:56:24 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id HiKuBQ4SvYsZt9w1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 12:56:22 -0800 (PST)
Date: Sat, 7 Mar 2015 20:56:16 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/4] mm: thp: Return the correct value for change_huge_pmd
Message-ID: <20150307205616.GZ3087@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-2-git-send-email-mgorman@suse.de>
	<CA+55aFyCgzNGU-VAaKvwTYFhtJc_ugLK6hRzZBCxMYdAt5TVuA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyCgzNGU-VAaKvwTYFhtJc_ugLK6hRzZBCxMYdAt5TVuA@mail.gmail.com>
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>

On Sat, Mar 07, 2015 at 12:31:03PM -0800, Linus Torvalds wrote:
> On Sat, Mar 7, 2015 at 7:20 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> >                 if (!prot_numa || !pmd_protnone(*pmd)) {
> > -                       ret = 1;
> >                         entry = pmdp_get_and_clear_notify(mm, addr, pmd);
> >                         entry = pmd_modify(entry, newprot);
> >                         ret = HPAGE_PMD_NR;
> 
> Hmm. I know I acked this already, but the return value - which correct
> - is still potentially something we could improve upon.
> 
> In particular, we don't need to flush the TLB's if the old entry was
> not present. Sadly, we don't have a helper function for that.
> 
> But the code *could* do something like
> 
>     entry = pmdp_get_and_clear_notify(mm, addr, pmd);
>     ret = pmd_tlb_cacheable(entry) ? HPAGE_PMD_NR : 1;
>     entry = pmd_modify(entry, newprot);
> 
> where pmd_tlb_cacheable() on x86 would test if _PAGE_PRESENT (bit #0) is set.
> 

I agree with you in principle. pmd_tlb_cacheable looks and sounds very
similar to pte_accessible().

> In particular, that would mean that as we change *from* a protnone
> (whether NUMA or really protnone) we wouldn't need to flush the TLB.
> 
> In fact, we could make it even more aggressive: it's not just an old
> non-present TLB entry that doesn't need flushing - we can avoid the
> flushing whenever we strictly increase the access rigths. So we could
> have something that takes the old entry _and_ the new protections into
> account, and avoids the TLB flush if the new entry is strictly more
> permissive.
> 
> This doesn't explain the extra TLB flushes Dave sees, though, because
> the old code didn't make those kinds of optimizations either. But
> maybe something like this is worth doing.
> 

I think it is worth doing although it'll be after LSF/MM before I do it. I
severely doubt this is what Dave is seeing because the vmstats indicated
there was no THP activity but it's still a good idea.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
