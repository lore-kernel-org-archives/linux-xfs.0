Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AF8C43219
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiDFCzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377072AbiDEV1p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 17:27:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCE152B11
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 13:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FD22B81FE1
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 20:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35B9EC385A9
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 20:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649191716;
        bh=Cc/ANYn9lORDUVoCuGoQA8LzvFOKFmEb3woct9/TsKU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fNjgfsRpZLhF/Y6jvxuRj4T3Ny53VrAwrN4So1Dn8ebrpqcFoI3PVEgtpu5teAq82
         xZ6QL6nyJHSCHRCf3CbeRLmW4d1EFn9Ksat1AhbMEitNOtJf7SV1Ze98c65h7iarz8
         io3wkPNh1njliuJQTsUEHmks3IKBlq6+ei8R3jIZCQMh35RjS/tHua6sAD5FoNgY1T
         k52ZbiOsMqm4ICMXmuJnIb8pdFWgD+UCLxhS0PwmYN3u1rmDhye/F8A/rzsZcjL23Z
         5OLKoO4PRrNk9koWM5U4Ep6tEcuL7YfqAFUJEeKWmgTt8BVKEp3IaqqmX2PyUKdGGw
         f+If3pXi601dQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1FDC9CC13AD; Tue,  5 Apr 2022 20:48:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 20:48:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: shy828301@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215804-201763-kkPW7Pcs6S@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

--- Comment #6 from Yang Shi (shy828301@gmail.com) ---
On Tue, Apr 5, 2022 at 12:25 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Apr 05, 2022 at 04:44:35AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215804
> [...]
> > [37285.232165] Unable to handle kernel paging request at virtual address
> > fffffbffff000008
> > [37285.232776] KASAN: maybe wild-memory-access in range
> > [0x0003dffff8000040-0x0003dffff8000047]
> > [37285.233332] Mem abort info:
> > [37285.233520]   ESR =3D 0x96000006
> > [37285.233725]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > [37285.234077]   SET =3D 0, FnV =3D 0
> > [37285.234281]   EA =3D 0, S1PTW =3D 0
> > [37285.234544]   FSC =3D 0x06: level 2 translation fault
> > [37285.234871] Data abort info:
> > [37285.235065]   ISV =3D 0, ISS =3D 0x00000006
> > [37285.235319]   CM =3D 0, WnR =3D 0
> > [37285.235517] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000457=
4eb000
> > [37285.235953] [fffffbffff000008] pgd=3D0000000458c71003,
> p4d=3D0000000458c71003,
> > pud=3D0000000458c72003, pmd=3D0000000000000000
> > [37285.236651] Internal error: Oops: 96000006 [#1] SMP
> > [37285.239187] CPU: 3 PID: 3302514 Comm: xfs_io Kdump: loaded Tainted: =
G=20=20=20
>    W         5.17.0+ #1
> > [37285.239810] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0
> 02/06/2015
> > [37285.240292] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS
> BTYPE=3D--)
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
>       ttu_flags =3D ... TTU_SPLIT_HUGE_PMD ...
>       try_to_unmap()
>         try_to_unmap_one()
>           split_huge_pmd_address()
>             pmd =3D pmd_offset(pud, address);
>             __split_huge_pmd(vma, pmd, address, freeze, folio);
>               if (folio) {
>                 if (folio !=3D page_folio(pmd_page(*pmd)))
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
> @@ -2145,15 +2145,14 @@ void __split_huge_pmd(struct vm_area_struct *vma,
> pmd_t *pmd,
>          * pmd against. Otherwise we can end up replacing wrong folio.
>          */
>         VM_BUG_ON(freeze && !folio);
> -       if (folio) {
> -               VM_WARN_ON_ONCE(!folio_test_locked(folio));
> -               if (folio !=3D page_folio(pmd_page(*pmd)))
> -                       goto out;
> -       }
> +       VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
>
>         if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
> -           is_pmd_migration_entry(*pmd))
> +           is_pmd_migration_entry(*pmd)) {
> +               if (folio && folio !=3D page_folio(pmd_page(*pmd)))
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

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
