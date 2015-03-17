Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10F597F47
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 11:54:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F3BD28F8066
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 09:53:58 -0700 (PDT)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	Nx9DrxqmIwsEL9Gw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 09:53:58 -0700 (PDT)
Received: by iecsl2 with SMTP id sl2so15548722iec.1
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 09:53:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150317070655.GB10105@dastard>
References: <CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com>
	<CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
	<20150309112936.GD26657@destitution>
	<CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
	<20150309191943.GF26657@destitution>
	<CA+55aFzFt-vX5Jerci0Ty4Uf7K4_nQ7wyCp8hhU_dB0X4cBpVQ@mail.gmail.com>
	<20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
Date: Tue, 17 Mar 2015 09:53:57 -0700
Message-ID: <CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
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

On Tue, Mar 17, 2015 at 12:06 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> TO close the loop here, now I'm back home and can run tests:
>
> config                            3.19      4.0-rc1     4.0-rc4
> defaults                         8m08s        9m34s       9m14s
> -o ag_stride=-1                  4m04s        4m38s       4m11s
> -o bhash=101073                  6m04s       17m43s       7m35s
> -o ag_stride=-1,bhash=101073     4m54s        9m58s       7m50s
>
> It's better but there are still significant regressions, especially
> for the large memory footprint cases. I haven't had a chance to look
> at any stats or profiles yet, so I don't know yet whether this is
> still page fault related or some other problem....

Ok. I'd love to see some data on what changed between 3.19 and rc4 in
the profiles, just to see whether it's "more page faults due to extra
COW", or whether it's due to "more TLB flushes because of the
pte_write() vs pte_dirty()" differences. I'm *guessing*  lot of the
remaining issues are due to extra page fault overhead because I'd
expect write/dirty to be fairly 1:1, but there could be differences
due to shared memory use and/or just writebacks of dirty pages that
become clean.

I guess you can also see in vmstat.mm_migrate_pages whether it's
because of excessive migration (because of bad grouping) or not. So
not just profiles data.

At the same time, I feel fairly happy about the situation - we at
least understand what is going on, and the "3x worse performance" case
is at least gone.  Even if that last case still looks horrible.

So it's still a bad performance regression, but at the same time I
think your test setup (big 500 TB filesystem, but then a fake-numa
thing with just 4GB per node) is specialized and unrealistic enough
that I don't feel it's all that relevant from a *real-world*
standpoint, and so I wouldn't be uncomfortable saying "ok, the page
table handling cleanup caused some issues, but we know about them and
how to fix them longer-term".  So I don't consider this a 4.0
showstopper or a "we need to revert for now" issue.

If it's a case of "we take a lot more page faults because we handle
the NUMA fault and then have a COW fault almost immediately", then the
fix is likely to do the same early-cow that the normal non-numa-fault
case does. In fact, my gut feel is that we should try to unify that
numa/regula fault handling path a bit more, but that would be a pretty
invasive patch.

                     Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
