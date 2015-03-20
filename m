Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4346A7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 12:02:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE1E1AC009
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 10:02:24 -0700 (PDT)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
	[209.85.213.173]) by cuda.sgi.com with ESMTP id
	I9menCEFobh7bf3j (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 10:02:23 -0700 (PDT)
Received: by ignm3 with SMTP id m3so33342138ign.0
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 10:02:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150320041357.GO10105@dastard>
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
	<20150320041357.GO10105@dastard>
Date: Fri, 20 Mar 2015 10:02:23 -0700
Message-ID: <CA+55aFx1pywykWa0ThcHgE7wzdVuyOBSx27iyx_FtZpYSJbKGQ@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Testing now. It's a bit faster - three runs gave 7m35s, 7m20s and
> 7m36s. IOWs's a bit better, but not significantly. page migrations
> are pretty much unchanged, too:
>
>            558,632      migrate:mm_migrate_pages ( +-  6.38% )

Ok. That was kind of the expected thing.

I don't really know the NUMA fault rate limiting code, but one thing
that strikes me is that if it tries to balance the NUMA faults against
the *regular* faults, then maybe just the fact that we end up taking
more COW faults after a NUMA fault then means that the NUMA rate
limiting code now gets over-eager (because it sees all those extra
non-numa faults).

Mel, does that sound at all possible? I really have never looked at
the magic automatic rate handling..

                         Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
