Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 595C17F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 05:12:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF93EAC003
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 03:12:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id NqLJjTBwOI1w1pNk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 03:12:54 -0700 (PDT)
Date: Fri, 20 Mar 2015 10:12:46 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150320101246.GF3087@suse.de>
References: <20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
	<CA+55aFyxA9u2cVzV+S7TSY9ZvRXCX=z22YAbi9mdPVBKmqgR5g@mail.gmail.com>
	<20150319224143.GI10105@dastard>
	<CA+55aFy5UeNnFUTi619cs3b9Up2NQ1wbuyvcCS614+o3=z=wBQ@mail.gmail.com>
	<20150320002311.GG28621@dastard>
	<CA+55aFyqXDVv9JkkhvM26x6PC5V82corR7HQNxmkeGZjOCxD=A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyqXDVv9JkkhvM26x6PC5V82corR7HQNxmkeGZjOCxD=A@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 06:29:47PM -0700, Linus Torvalds wrote:
> And the VM_WRITE test should be stable and not have any subtle
> interaction with the other changes that the numa pte things
> introduced. It would be good to see if the profiles then pop something
> *else* up as the performance difference (which I'm sure will remain,
> since the 7m50s was so far off).
> 

As a side-note, I did test a patch that checked pte_write and preserved
it across both faults and setting the protections. It did not alter
migration activity much but there was a  drop in minor faults - 20% drop in
autonumabench, 58% drop in xfsrepair workload. I'm assuming this is due to
refaults to mark pages writable.  The patch looks and is hacky so I won't
post it to save people bleaching their eyes. I'll spend some time soon
(hopefully today) at a smooth way of falling through to WP checks after
trapping a NUMA fault.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
