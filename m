Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23BBC7F4E
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 12:33:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 121C6304043
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 10:33:46 -0800 (PST)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	FBVuvroHbYVgPgep (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 10:33:44 -0800 (PST)
Received: by ierx19 with SMTP id x19so93666511ier.3
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 10:33:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425741651-29152-4-git-send-email-mgorman@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-4-git-send-email-mgorman@suse.de>
Date: Sat, 7 Mar 2015 10:33:43 -0800
Message-ID: <CA+55aFwSQgrYqfXPr6RPvQ+8OJfexXJRY_GVEKg5QtB2t38cWA@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: numa: Mark huge PTEs young when clearing NUMA
	hinting faults
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

On Sat, Mar 7, 2015 at 7:20 AM, Mel Gorman <mgorman@suse.de> wrote:
>         pmd = pmd_modify(pmd, vma->vm_page_prot);
> +       pmd = pmd_mkyoung(pmd);

Hmm. I *thought* this should be unnecessary. vm_page_prot alreadty has
the accessed bit set, and we kind of depend on the initial page table
setup and mk_pte() and friends (ie all new pages are installed
"young").

But it looks like I am wrong - the way we use _[H]PAGE_CHG_MASK means
that we always take the accessed and dirty bits from the old entry,
ignoring the bit in vm_page_prot.

I wonder if we should just make pte/pmd_modify() work the way I
*thought* they worked (remove the masking of vm_page_prot bits).

So the patch isn't wrong. It's just that we *migth* instead just do
something like this:

    arch/x86/include/asm/pgtable.h | 4 ++--
    1 file changed, 2 insertions(+), 2 deletions(-)

   diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
   index a0c35bf6cb92..79b898bb9e18 100644
   --- a/arch/x86/include/asm/pgtable.h
   +++ b/arch/x86/include/asm/pgtable.h
   @@ -355,7 +355,7 @@ static inline pte_t pte_modify(pte_t pte,
pgprot_t newprot)
            * the newprot (if present):
            */
           val &= _PAGE_CHG_MASK;
   -       val |= massage_pgprot(newprot) & ~_PAGE_CHG_MASK;
   +       val |= massage_pgprot(newprot);

           return __pte(val);
    }
   @@ -365,7 +365,7 @@ static inline pmd_t pmd_modify(pmd_t pmd,
pgprot_t newprot)
           pmdval_t val = pmd_val(pmd);

           val &= _HPAGE_CHG_MASK;
   -       val |= massage_pgprot(newprot) & ~_HPAGE_CHG_MASK;
   +       val |= massage_pgprot(newprot);

           return __pmd(val);
    }

instead, and remove the mkyoung. Completely untested, but that "just
or in the new protection bits" is what pnf_pte() does just a few lines
above this.

                        Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
