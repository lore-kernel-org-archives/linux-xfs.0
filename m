Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B54D17F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:52:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 760608F8070
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 09:52:20 -0700 (PDT)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com
	[209.85.213.172]) by cuda.sgi.com with ESMTP id
	D42CycZgyNH7hjKW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 09:52:19 -0700 (PDT)
Received: by igdh15 with SMTP id h15so22651544igd.4
	for <xfs@oss.sgi.com>; Mon, 09 Mar 2015 09:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150309112936.GD26657@destitution>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
	<20150307163657.GA9702@gmail.com>
	<CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com>
	<CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
	<20150309112936.GD26657@destitution>
Date: Mon, 9 Mar 2015 09:52:18 -0700
Message-ID: <CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
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

On Mon, Mar 9, 2015 at 4:29 AM, Dave Chinner <david@fromorbit.com> wrote:
>
>> Also, is there some sane way for me to actually see this behavior on a
>> regular machine with just a single socket? Dave is apparently running
>> in some fake-numa setup, I'm wondering if this is easy enough to
>> reproduce that I could see it myself.
>
> Should be - I don't actually use 500TB of storage to generate this -
> 50GB on an SSD is all you need from the storage side. I just use a
> sparse backing file to make it look like a 500TB device. :P

What's your virtual environment setup? Kernel config, and
virtualization environment to actually get that odd fake NUMA thing
happening?

                          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
