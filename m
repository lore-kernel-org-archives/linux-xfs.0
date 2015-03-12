Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB4E07F47
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 13:49:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A66B8F8035
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 11:49:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id mWhonFzGAp6t44wP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2015 11:49:34 -0700 (PDT)
Date: Thu, 12 Mar 2015 18:49:26 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150312184925.GH3406@suse.de>
References: <20150307163657.GA9702@gmail.com>
	<CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com>
	<CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
	<20150309112936.GD26657@destitution>
	<CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
	<20150309191943.GF26657@destitution>
	<CA+55aFzFt-vX5Jerci0Ty4Uf7K4_nQ7wyCp8hhU_dB0X4cBpVQ@mail.gmail.com>
	<20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
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

On Thu, Mar 12, 2015 at 09:20:36AM -0700, Linus Torvalds wrote:
> On Thu, Mar 12, 2015 at 6:10 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> > I believe you're correct and it matches what was observed. I'm still
> > travelling and wireless is dirt but managed to queue a test using pmd_dirty
> 
> Ok, thanks.
> 
> I'm not entirely happy with that change, and I suspect the whole
> heuristic should be looked at much more (maybe it should also look at
> whether it's executable, for example), but it's a step in the right
> direction.
> 

I can follow up when I'm back in work properly. As you have already pulled
this in directly, can you also consider pulling in "mm: thp: return the
correct value for change_huge_pmd" please? The other two patches were very
minor can be resent through the normal paths later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
