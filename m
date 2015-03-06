Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2225D7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 18:53:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2C6AAC006
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 16:53:11 -0800 (PST)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	4qv0hDI35QgERcPM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 16:53:10 -0800 (PST)
Received: by iecrp18 with SMTP id rp18so13802222iec.7
	for <xfs@oss.sgi.com>; Thu, 05 Mar 2015 16:53:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425599692-32445-3-git-send-email-mgorman@suse.de>
References: <1425599692-32445-1-git-send-email-mgorman@suse.de>
	<1425599692-32445-3-git-send-email-mgorman@suse.de>
Date: Thu, 5 Mar 2015 16:53:09 -0800
Message-ID: <CA+55aFzdWE3dO8z6jUScft7=cLmE3x7G8Ak5dizfL=_z7puzaA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: numa: Do not clear PTEs or PMDs for NUMA hinting
	faults
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

On Thu, Mar 5, 2015 at 3:54 PM, Mel Gorman <mgorman@suse.de> wrote:
>                 if (!prot_numa || !pmd_protnone(*pmd)) {
> -                       entry = pmdp_get_and_clear_notify(mm, addr, pmd);
> -                       entry = pmd_modify(entry, newprot);
> +                       /*
> +                        * NUMA hinting update can avoid a clear and defer the
> +                        * flush as it is not a functional correctness issue if
> +                        * access occurs after the update and this avoids
> +                        * spurious faults.
> +                        */
> +                       if (prot_numa) {
> +                               entry = *pmd;
> +                               entry = pmd_mkprotnone(entry);
> +                       } else {
> +                               entry = pmdp_get_and_clear_notify(mm, addr,
> +                                                                 pmd);
> +                               entry = pmd_modify(entry, newprot);
> +                               BUG_ON(pmd_write(entry));
> +                       }
> +
>                         ret = HPAGE_PMD_NR;
>                         set_pmd_at(mm, addr, pmd, entry);
> -                       BUG_ON(pmd_write(entry));

So I don't think this is right, nor is the new pte code.

You cannot just read the old pte entry, change it, and write it back.
That's fundamentally racy, and can drop any concurrent dirty or
accessed bit setting. And there are no locks you can use to protect
against that, since the accessed and dirty bit are set by hardware.

Now, losing the accessed bit doesn't matter - it's a small race, and
not a correctness issue. But potentially losing dirty bits is a data
loss problem.

Did the old prot_numa code do this too? Because if it did, it sounds
like it was just buggy.

                                            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
