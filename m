Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D926E7F4E
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 11:20:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 569BFAC002
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 09:20:39 -0700 (PDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	6ZRIayV8qp2mowjO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2015 09:20:37 -0700 (PDT)
Received: by igal13 with SMTP id l13so1416315iga.1
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 09:20:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150312131045.GE3406@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
	<20150307163657.GA9702@gmail.com>
	<CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com>
	<CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
	<20150309112936.GD26657@destitution>
	<CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
	<20150309191943.GF26657@destitution>
	<CA+55aFzFt-vX5Jerci0Ty4Uf7K4_nQ7wyCp8hhU_dB0X4cBpVQ@mail.gmail.com>
	<20150312131045.GE3406@suse.de>
Date: Thu, 12 Mar 2015 09:20:36 -0700
Message-ID: <CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>

On Thu, Mar 12, 2015 at 6:10 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> I believe you're correct and it matches what was observed. I'm still
> travelling and wireless is dirt but managed to queue a test using pmd_dirty

Ok, thanks.

I'm not entirely happy with that change, and I suspect the whole
heuristic should be looked at much more (maybe it should also look at
whether it's executable, for example), but it's a step in the right
direction.

So I committed it and added a comment, and wrote a commit log about
it. I suspect any further work is post-4.0-release, unless somebody
comes up with something small and simple and obviously better.

                                 Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
