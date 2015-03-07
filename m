Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CCFB7F5F
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 14:31:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8E8FAC001
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 12:31:05 -0800 (PST)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	lfZwyhoo0nVIjQx2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 12:31:04 -0800 (PST)
Received: by iecvy18 with SMTP id vy18so29860101iec.9
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 12:31:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425741651-29152-2-git-send-email-mgorman@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-2-git-send-email-mgorman@suse.de>
Date: Sat, 7 Mar 2015 12:31:03 -0800
Message-ID: <CA+55aFyCgzNGU-VAaKvwTYFhtJc_ugLK6hRzZBCxMYdAt5TVuA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: thp: Return the correct value for change_huge_pmd
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
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>

On Sat, Mar 7, 2015 at 7:20 AM, Mel Gorman <mgorman@suse.de> wrote:
>
>                 if (!prot_numa || !pmd_protnone(*pmd)) {
> -                       ret = 1;
>                         entry = pmdp_get_and_clear_notify(mm, addr, pmd);
>                         entry = pmd_modify(entry, newprot);
>                         ret = HPAGE_PMD_NR;

Hmm. I know I acked this already, but the return value - which correct
- is still potentially something we could improve upon.

In particular, we don't need to flush the TLB's if the old entry was
not present. Sadly, we don't have a helper function for that.

But the code *could* do something like

    entry = pmdp_get_and_clear_notify(mm, addr, pmd);
    ret = pmd_tlb_cacheable(entry) ? HPAGE_PMD_NR : 1;
    entry = pmd_modify(entry, newprot);

where pmd_tlb_cacheable() on x86 would test if _PAGE_PRESENT (bit #0) is set.

In particular, that would mean that as we change *from* a protnone
(whether NUMA or really protnone) we wouldn't need to flush the TLB.

In fact, we could make it even more aggressive: it's not just an old
non-present TLB entry that doesn't need flushing - we can avoid the
flushing whenever we strictly increase the access rigths. So we could
have something that takes the old entry _and_ the new protections into
account, and avoids the TLB flush if the new entry is strictly more
permissive.

This doesn't explain the extra TLB flushes Dave sees, though, because
the old code didn't make those kinds of optimizations either. But
maybe something like this is worth doing.

                            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
