Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 19A907F51
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 13:12:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED6E78F804B
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 11:12:52 -0800 (PST)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
	[209.85.213.170]) by cuda.sgi.com with ESMTP id
	w9yVAclhtrtc2ffM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 11:12:51 -0800 (PST)
Received: by igjz20 with SMTP id z20so11832699igj.4
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 11:12:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150307163657.GA9702@gmail.com>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
	<20150307163657.GA9702@gmail.com>
Date: Sat, 7 Mar 2015 11:12:50 -0800
Message-ID: <CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
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

On Sat, Mar 7, 2015 at 8:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> And the patch Dave bisected to is a relatively simple patch.
> Why not simply revert it to see whether that cures much of the
> problem?

So the problem with that is that "pmd_set_numa()" and friends simply
no longer exist. So we can't just revert that one patch, it's the
whole series, and the whole point of the series.

What confuses me is that the only real change that I can see in that
patch is the change to "change_huge_pmd()". Everything else is pretty
much a 100% equivalent transformation, afaik. Of course, I may be
wrong about that, and missing something silly.

And the changes to "change_huge_pmd()" were basically re-done
differently by subsequent patches anyway.

The *only* change I see remaining is that change_huge_pmd() now does

   entry = pmdp_get_and_clear_notify(mm, addr, pmd);
   entry = pmd_modify(entry, newprot);
   set_pmd_at(mm, addr, pmd, entry);

for all changes. It used to do that "pmdp_set_numa()" for the
prot_numa case, which did just

   pmd_t pmd = *pmdp;
   pmd = pmd_mknuma(pmd);
   set_pmd_at(mm, addr, pmdp, pmd);

instead.

I don't like the old pmdp_set_numa() because it can drop dirty bits,
so I think the old code was actively buggy.

But I do *not* see why the new code would cause more migrations to happen.

There's probably something really stupid I'm missing.

                           Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
