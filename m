Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE1FC43219
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451888AbiDFCy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349831AbiDEVad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 17:30:33 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5218D267D
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 13:48:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bx5so612469pjb.3
        for <linux-xfs@vger.kernel.org>; Tue, 05 Apr 2022 13:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQJXQ0o4/xZn83G9V0zs1zmNIfX3wUZZ2U7kK8rPsT8=;
        b=dqZAVPoJmEVZRkK4fDdyarkdxCjyaLibCaemYMbu2ALQFNFVNsR01bQisMSFPUJig2
         z9clku74QrgA8hZ48ZC2BxYWSpSp7iMBzUqDX1w1xgC90j9PA743LNIcAcHZSYvGEP/Y
         DqyhIBwncn8ZK1MfzOWoXw32w1qT2EQwzjgPId+pk8WVWf/C6w8y0iDXZSyUyo3SQmD9
         OnVTX9CPhHxMV75rn2OpT49euYse8RyIvGJmHUQCss5WRabuzTZZ0OuUWGx8HimUKJf7
         ba+xogmszDY37tfobgluSoZHRD6Fpmr9evryc7vTgFFfRuF9G4VgKrYBZnoBH0mS3zqM
         aDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQJXQ0o4/xZn83G9V0zs1zmNIfX3wUZZ2U7kK8rPsT8=;
        b=WBI1zKmQD8RjHrCRQ9h2sRmRHhYT094lX9hQyGynKK5PYA+reIm32GtbT1C0FQn+yZ
         CrqcYI5YjA6cJcBQbBuU+kFgM9/FNGuA+XNPl9ED0X4Ijnelhlqf/GUu+AA26BfI2ad5
         ozPmTD7T+nrjPe+PXwQjcCenr/76aEPg9UQppYvMrYsuG32L867zWDyEtAMbGcb70sKr
         nJpIW67h8B0X6SJCX10w7soO26BfvV+q2fPVx7KRy7pVENN0Z2UTPVN+QYbo7hO3vq9+
         3K6WZ2GB6htiHqyyXpvWCYy4W8697v2kXK+KExerA0P4h1WAbYDMojh9FODJcCrFEQMi
         izmw==
X-Gm-Message-State: AOAM532puro7N2j61kSVA18S423uncJuzXjOmn6DWm0/6Icca/wXqpS5
        8cMshDRHomeln3WDOIZxAU0XXJmbISHS2YJen+U=
X-Google-Smtp-Source: ABdhPJwNwBsNPifmbbwbkO5MnAKc7ceCoJwOotXzWhk0urCtLqOMcRUvQm/YZBXhUnj4IYsbiw8eVB9f2NKD5ae7qJo=
X-Received: by 2002:a17:903:1cb:b0:156:c35f:7f14 with SMTP id
 e11-20020a17090301cb00b00156c35f7f14mr5235856plh.26.1649191712485; Tue, 05
 Apr 2022 13:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <bug-215804-201763@https.bugzilla.kernel.org/> <YkyXRsMubP8uNOF8@casper.infradead.org>
In-Reply-To: <YkyXRsMubP8uNOF8@casper.infradead.org>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 5 Apr 2022 13:48:21 -0700
Message-ID: <CAHbLzkqm4WVGpEp+YOxkNd+VeOvnO+314kbzDhgKaJ-oeyNt9g@mail.gmail.com>
Subject: Re: [Bug 215804] New: [xfstests generic/670] Unable to handle kernel
 paging request at virtual address fffffbffff000008
To:     Matthew Wilcox <willy@infradead.org>
Cc:     bugzilla-daemon@kernel.org, linux-xfs@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 5, 2022 at 12:25 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Apr 05, 2022 at 04:44:35AM +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=215804
> [...]
> > [37285.232165] Unable to handle kernel paging request at virtual address
> > fffffbffff000008
> > [37285.232776] KASAN: maybe wild-memory-access in range
> > [0x0003dffff8000040-0x0003dffff8000047]
> > [37285.233332] Mem abort info:
> > [37285.233520]   ESR = 0x96000006
> > [37285.233725]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [37285.234077]   SET = 0, FnV = 0
> > [37285.234281]   EA = 0, S1PTW = 0
> > [37285.234544]   FSC = 0x06: level 2 translation fault
> > [37285.234871] Data abort info:
> > [37285.235065]   ISV = 0, ISS = 0x00000006
> > [37285.235319]   CM = 0, WnR = 0
> > [37285.235517] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000004574eb000
> > [37285.235953] [fffffbffff000008] pgd=0000000458c71003, p4d=0000000458c71003,
> > pud=0000000458c72003, pmd=0000000000000000
> > [37285.236651] Internal error: Oops: 96000006 [#1] SMP
> > [37285.239187] CPU: 3 PID: 3302514 Comm: xfs_io Kdump: loaded Tainted: G       W         5.17.0+ #1
> > [37285.239810] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> > [37285.240292] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [37285.240783] pc : __split_huge_pmd+0x1d8/0x34c
> > [37285.241097] lr : __split_huge_pmd+0x174/0x34c
> > [37285.241407] sp : ffff800023a56fe0
> > [37285.241642] x29: ffff800023a56fe0 x28: 0000000000000000 x27:
> > ffff0001c54d4060
> > [37285.242145] x26: 0000000000000000 x25: 0000000000000000 x24:
> > fffffc00056cf000
> > [37285.242661] x23: 1ffff0000474ae0a x22: ffff0007104fe630 x21:
> > ffff00014fab66b0
> > [37285.243175] x20: ffff800023a57080 x19: fffffbffff000000 x18:
> > 0000000000000000
> > [37285.243689] x17: 0000000000000000 x16: ffffb109a2ec7e30 x15:
> > 0000ffffd9035c10
> > [37285.244202] x14: 00000000f2040000 x13: 0000000000000000 x12:
> > ffff70000474aded
> > [37285.244715] x11: 1ffff0000474adec x10: ffff70000474adec x9 :
> > dfff800000000000
> > [37285.245230] x8 : ffff800023a56f63 x7 : 0000000000000001 x6 :
> > 0000000000000003
> > [37285.245745] x5 : ffff800023a56f60 x4 : ffff70000474adec x3 :
> > 1fffe000cd086e01
> > [37285.246257] x2 : 1fffff7fffe00001 x1 : 0000000000000000 x0 :
> > fffffbffff000008
> > [37285.246770] Call trace:
> > [37285.246952]  __split_huge_pmd+0x1d8/0x34c
> > [37285.247246]  split_huge_pmd_address+0x10c/0x1a0
> > [37285.247577]  try_to_unmap_one+0xb64/0x125c
> > [37285.247878]  rmap_walk_file+0x1dc/0x4b0
> > [37285.248159]  try_to_unmap+0x134/0x16c
> > [37285.248427]  split_huge_page_to_list+0x5ec/0xcbc
> > [37285.248763]  truncate_inode_partial_folio+0x194/0x2ec
>
> Clearly this is due to my changes, but I'm wondering why it doesn't
> happen with misaligned mappings and shmem today.  Here's the path I
> see as being problematic:
>
> split_huge_page()
>   split_huge_page_to_list()
>     unmap_page()
>       ttu_flags = ... TTU_SPLIT_HUGE_PMD ...
>       try_to_unmap()
>         try_to_unmap_one()
>           split_huge_pmd_address()
>             pmd = pmd_offset(pud, address);
>             __split_huge_pmd(vma, pmd, address, freeze, folio);
>               if (folio) {
>                 if (folio != page_folio(pmd_page(*pmd)))
>
> I'm assuming it's crashing at that line.  Calling pmd_page() on a
> pmd that we haven't checked is pmd_trans_huge() seems like a really
> bad idea.  I probably compounded that problem by calling page_folio()
> on something that's not necessarily a PMD that points to a page, but
> I think the real sin here is that nobody checks before this that it's
> trans_huge.
>
> Here's Option A for fixing it: Only check pmd_page() after checking
> pmd_trans_huge():
>
> +++ b/mm/huge_memory.c
> @@ -2145,15 +2145,14 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>          * pmd against. Otherwise we can end up replacing wrong folio.
>          */
>         VM_BUG_ON(freeze && !folio);
> -       if (folio) {
> -               VM_WARN_ON_ONCE(!folio_test_locked(folio));
> -               if (folio != page_folio(pmd_page(*pmd)))
> -                       goto out;
> -       }
> +       VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
>
>         if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
> -           is_pmd_migration_entry(*pmd))
> +           is_pmd_migration_entry(*pmd)) {
> +               if (folio && folio != page_folio(pmd_page(*pmd)))
> +                       goto out;
>                 __split_huge_pmd_locked(vma, pmd, range.start, freeze);
> +       }
>
>  out:
>         spin_unlock(ptl);
>
> I can think of a few more ways of fixing it, but that one seems best.
> Not tested in any meaningful way, more looking for feedback.

I agree with your analysis. That pmd may be a normal PMD so its
so-called pfn is invalid in fact. The fix looks fine to me.

>
