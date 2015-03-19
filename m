Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABA997F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 13:09:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6CD008F8073
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:09:17 -0700 (PDT)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	Af0qDkgXdLjp8EQ7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 11:09:16 -0700 (PDT)
Received: by iedm5 with SMTP id m5so9367119ied.3
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:09:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150319141022.GD3087@suse.de>
References: <20150312131045.GE3406@suse.de>
	<CA+55aFx=81BGnQFNhnAGu6CetL7yifPsnD-+v7Y6QRqwgH47gQ@mail.gmail.com>
	<20150312184925.GH3406@suse.de> <20150317070655.GB10105@dastard>
	<CA+55aFzdLnFdku-gnm3mGbeS=QauYBNkFQKYXJAGkrMd2jKXhw@mail.gmail.com>
	<20150317205104.GA28621@dastard>
	<CA+55aFzSPcNgxw4GC7aAV1r0P5LniyVVC66COz=3cgMcx73Nag@mail.gmail.com>
	<20150317220840.GC28621@dastard>
	<CA+55aFwne-fe_Gg-_GTUo+iOAbbNpLBa264JqSFkH79EULyAqw@mail.gmail.com>
	<CA+55aFy-Mw74rAdLMMMUgnsG3ZttMWVNGz7CXZJY7q9fqyRYfg@mail.gmail.com>
	<20150319141022.GD3087@suse.de>
Date: Thu, 19 Mar 2015 11:09:15 -0700
Message-ID: <CA+55aFwTcw2rTjPM_EOjPeKNWwdfNVazx+O=YAFXPWw1h==Tgw@mail.gmail.com>
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

On Thu, Mar 19, 2015 at 7:10 AM, Mel Gorman <mgorman@suse.de> wrote:
> -       if (!pmd_dirty(pmd))
> +       /* See similar comment in do_numa_page for explanation */
> +       if (!(vma->vm_flags & VM_WRITE))

Yeah, that would certainly be a whole lot more obvious than all the
"if this particular pte/pmd looks like X" tests.

So that, together with scanning rate improvements (this *does* seem to
be somewhat chaotic, so it's quite possible that the current scanning
rate thing is just fairly unstable) is likely the right thing. I'd
just like to _understand_ why that write/dirty bit makes such a
difference. I thought I understood what was going on, and was happy,
and then Dave come with his crazy numbers.

Damn you Dave, and damn your numbers and "facts" and stuff. Sometimes
I much prefer ignorant bliss.

                           Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
