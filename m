Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28EAC7F37
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 12:31:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 074BF8F8049
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 10:31:30 -0700 (PDT)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	9wO9353dVGAZyx7G (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 10:31:29 -0700 (PDT)
Received: by iegc3 with SMTP id c3so45001074ieg.3
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 10:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
References: <CA+55aFywW5JLq=BU_qb2OG5+pJ-b1v9tiS5Ygi-vtEKbEZ_T5Q@mail.gmail.com>
	<20150309191943.GF26657@destitution>
	<CA+55aFzFt-vX5Jerci0Ty4Uf7K4_nQ7wyCp8hhU_dB0X4cBpVQ@mail.gmail.com>
	<20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
Date: Wed, 18 Mar 2015 10:31:28 -0700
Message-ID: <CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
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

On Wed, Mar 18, 2015 at 9:08 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So why am I wrong? Why is testing for dirty not the same as testing
> for writable?
>
> I can see a few cases:
>
>  - your load has lots of writable (but not written-to) shared memory

Hmm. I tried to look at the xfsprog sources, and I don't see any
MAP_SHARED activity.  It looks like it's just using pread64/pwrite64,
and the only MAP_SHARED is for the xfsio mmap test thing, not for
xfsrepair.

So I don't see any shared mappings, but I don't know the code-base.

>  - something completely different that I am entirely missing

So I think there's something I'm missing. For non-shared mappings, I
still have the idea that pte_dirty should be the same as pte_write.
And yet, your testing of 3.19 shows that it's a big difference.
There's clearly something I'm completely missing.

                          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
