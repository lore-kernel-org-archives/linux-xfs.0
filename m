Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80AC07F56
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 02:07:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F32CCAC002
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 00:07:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0rCyzoioqPwt3rld for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 00:07:34 -0700 (PDT)
Date: Tue, 17 Mar 2015 18:06:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150317070655.GB10105@dastard>
References: <CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com>
	<CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
	<20150309112936.GD26657@destitution>
	<CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
	<20150309191943.GF26657@destitution>
	<CA+55aFzFt-vX5Jerci0Ty4Uf7K4_nQ7wyCp8hhU_dB0X4cBpVQ@mail.gmail.com>
	<20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150312184925.GH3406@suse.de>
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
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Thu, Mar 12, 2015 at 06:49:26PM +0000, Mel Gorman wrote:
> On Thu, Mar 12, 2015 at 09:20:36AM -0700, Linus Torvalds wrote:
> > On Thu, Mar 12, 2015 at 6:10 AM, Mel Gorman <mgorman@suse.de> wrote:
> > >
> > > I believe you're correct and it matches what was observed. I'm still
> > > travelling and wireless is dirt but managed to queue a test using pmd_dirty
> > 
> > Ok, thanks.
> > 
> > I'm not entirely happy with that change, and I suspect the whole
> > heuristic should be looked at much more (maybe it should also look at
> > whether it's executable, for example), but it's a step in the right
> > direction.
> > 
> 
> I can follow up when I'm back in work properly. As you have already pulled
> this in directly, can you also consider pulling in "mm: thp: return the
> correct value for change_huge_pmd" please? The other two patches were very
> minor can be resent through the normal paths later.

TO close the loop here, now I'm back home and can run tests:

config                            3.19      4.0-rc1     4.0-rc4
defaults                         8m08s        9m34s       9m14s
-o ag_stride=-1                  4m04s        4m38s       4m11s
-o bhash=101073                  6m04s       17m43s       7m35s
-o ag_stride=-1,bhash=101073     4m54s        9m58s       7m50s

It's better but there are still significant regressions, especially
for the large memory footprint cases. I haven't had a chance to look
at any stats or profiles yet, so I don't know yet whether this is
still page fault related or some other problem....

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
