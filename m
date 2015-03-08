Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE7D67F69
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 13:46:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E288AC002
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 11:46:17 -0700 (PDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	Xmca3i4SOos6Syys (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Mar 2015 11:46:11 -0700 (PDT)
Received: by iecrd18 with SMTP id rd18so6862766iec.13
	for <xfs@oss.sgi.com>; Sun, 08 Mar 2015 11:46:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
	<20150307163657.GA9702@gmail.com>
	<CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com>
	<CA+55aFyQyZXu2fi7X9bWdSX0utk8=sccfBwFaSoToROXoE_PLA@mail.gmail.com>
Date: Sun, 8 Mar 2015 11:46:10 -0700
Message-ID: <CA+55aFwE4K7wmPWKR2SMb9us0LQEoGeLeErrPdB--bSbwf7yzg@mail.gmail.com>
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
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

On Sun, Mar 8, 2015 at 11:35 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> As a second hack (not to be applied), could we change:
>>
>>  #define _PAGE_BIT_PROTNONE      _PAGE_BIT_GLOBAL
>>
>> to:
>>
>>  #define _PAGE_BIT_PROTNONE      (_PAGE_BIT_GLOBAL+1)
>>
>> to double check that the position of the bit does not matter?
>
> Agreed. We should definitely try that.

There's a second reason to do that, actually: the __supported_pte_mask
thing, _and_ the pageattr stuff in __split_large_page() etc play games
with _PAGE_GLOBAL. As does drivers/lguest for some reason.

So looking at this all, there's a lot of room for confusion with _PAGE_GLOBAL.

That kind of confusion would certainly explain the whole "the changes
_look_ like they do the same thing, but don't" - because of silly
semantic conflicts with PROTNONE vs GLOBAL.

                                Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
