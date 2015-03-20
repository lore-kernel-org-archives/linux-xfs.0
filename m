Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BF617F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 04:56:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 378A98F8078
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 02:56:16 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id VdTH4g451mYqKOC6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 02:56:14 -0700 (PDT)
Date: Fri, 20 Mar 2015 09:56:06 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150320095606.GE3087@suse.de>
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFy5UeNnFUTi619cs3b9Up2NQ1wbuyvcCS614+o3=z=wBQ@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 04:05:46PM -0700, Linus Torvalds wrote:
> On Thu, Mar 19, 2015 at 3:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > My recollection wasn't faulty - I pulled it from an earlier email.
> > That said, the original measurement might have been faulty. I ran
> > the numbers again on the 3.19 kernel I saved away from the original
> > testing. That came up at 235k, which is pretty much the same as
> > yesterday's test. The runtime,however, is unchanged from my original
> > measurements of 4m54s (pte_hack came in at 5m20s).
> 
> Ok. Good. So the "more than an order of magnitude difference" was
> really about measurement differences, not quite as real. Looks like
> more a "factor of two" than a factor of 20.
> 
> Did you do the profiles the same way? Because that would explain the
> differences in the TLB flush percentages too (the "1.4% from
> tlb_invalidate_range()" vs "pretty much everything from migration").
> 
> The runtime variation does show that there's some *big* subtle
> difference for the numa balancing in the exact TNF_NO_GROUP details.

TNF_NO_GROUP affects whether the scheduler tries to group related processes
together. Whether migration occurs depends on what node a process is
scheduled on. If processes are aggressively grouped inappropriately then it
is possible there is a bug that causes the load balancer to move processes
off a node (possible migration) with NUMA balancing trying to pull it back
(another possible migration). Small bugs there can result in excessive
migration.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
