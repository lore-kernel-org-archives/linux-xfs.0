Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA6C47F5D
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 14:13:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AF59AC003
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 12:13:28 -0800 (PST)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	IGHpMc3h6I1DPNSQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 12:13:27 -0800 (PST)
Received: by iery20 with SMTP id y20so678651ier.0
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 12:13:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425741651-29152-2-git-send-email-mgorman@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-2-git-send-email-mgorman@suse.de>
Date: Sat, 7 Mar 2015 12:13:27 -0800
Message-ID: <CA+55aFwGLOfmBMHsFzuqKbJqR43+SVydv5zxh-KWMPD=fQG1UQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: thp: Return the correct value for change_huge_pmd
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

Looks obviously correct. The old code was just very wrong.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

                     Linus


On Sat, Mar 7, 2015 at 7:20 AM, Mel Gorman <mgorman@suse.de> wrote:
> The wrong value is being returned by change_huge_pmd since commit
> 10c1045f28e8 ("mm: numa: avoid unnecessary TLB flushes when setting
> NUMA hinting entries") which allows a fallthrough that tries to adjust
> non-existent PTEs. This patch corrects it.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/huge_memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fc00c8cb5a82..194c0f019774 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1482,6 +1482,7 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>
>         if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
>                 pmd_t entry;
> +               ret = 1;
>
>                 /*
>                  * Avoid trapping faults against the zero page. The read-only
> @@ -1490,11 +1491,10 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>                  */
>                 if (prot_numa && is_huge_zero_pmd(*pmd)) {
>                         spin_unlock(ptl);
> -                       return 0;
> +                       return ret;
>                 }
>
>                 if (!prot_numa || !pmd_protnone(*pmd)) {
> -                       ret = 1;
>                         entry = pmdp_get_and_clear_notify(mm, addr, pmd);
>                         entry = pmd_modify(entry, newprot);
>                         ret = HPAGE_PMD_NR;
> --
> 2.1.2
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
