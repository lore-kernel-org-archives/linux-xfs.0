Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668CAC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448070AbiDFCy5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573625AbiDET0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 15:26:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92B427FC9
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 12:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DBD1618CD
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 19:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3BA8C385A9
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 19:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649186639;
        bh=4HuG22W9TjEDBv9kDR4Xz8Tu/Y3IHZLgan6EkBJkQUU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WBMa6iWZibFrBLWu83IWyiM2Kh6Eq7lq5VcB5Q6btwpBlib4RFGTWZx9dyvoSXXNX
         UOUEfGucEEuiCmtxhSmE0VKf37ysKGBO1TH7WDg/ODTvPzqMGmKI9OPHpibBS6duDQ
         UnuMs5rL/mMLxrZlY68qo85TT/zeNSOzWCPc+f6AQXY6QDecJrxNL8/8st7Ffm57RB
         5jUR9QESfuFTpAJbXOUXCv1kODhUHW8jkNuQI6FJzR1tBwGx3GZm/zylzY/f7nmjF9
         /UsHjkFKglGhJObZ7ZP0owzUI4tOcWO1dP1f5olmX9pgA2DZzOrlh36gDNnZEmZ4V7
         WmtEBOQ7pQVjQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D2BC3CC13AD; Tue,  5 Apr 2022 19:23:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 19:23:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: willy@infradead.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215804-201763-v6jMIEgnxq@https.bugzilla.kernel.org/>
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

--- Comment #5 from willy@infradead.org ---
On Tue, Apr 05, 2022 at 04:44:35AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215804
[...]
> [37285.232165] Unable to handle kernel paging request at virtual address
> fffffbffff000008=20
> [37285.232776] KASAN: maybe wild-memory-access in range
> [0x0003dffff8000040-0x0003dffff8000047]=20
> [37285.233332] Mem abort info:=20
> [37285.233520]   ESR =3D 0x96000006=20
> [37285.233725]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits=20
> [37285.234077]   SET =3D 0, FnV =3D 0=20
> [37285.234281]   EA =3D 0, S1PTW =3D 0=20
> [37285.234544]   FSC =3D 0x06: level 2 translation fault=20
> [37285.234871] Data abort info:=20
> [37285.235065]   ISV =3D 0, ISS =3D 0x00000006=20
> [37285.235319]   CM =3D 0, WnR =3D 0=20
> [37285.235517] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000004574e=
b000=20
> [37285.235953] [fffffbffff000008] pgd=3D0000000458c71003, p4d=3D000000045=
8c71003,
> pud=3D0000000458c72003, pmd=3D0000000000000000=20
> [37285.236651] Internal error: Oops: 96000006 [#1] SMP=20
> [37285.239187] CPU: 3 PID: 3302514 Comm: xfs_io Kdump: loaded Tainted: G=
=20=20=20=20=20
>  W         5.17.0+ #1=20
> [37285.239810] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/=
2015=20
> [37285.240292] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS
> BTYPE=3D--)=20
> [37285.240783] pc : __split_huge_pmd+0x1d8/0x34c=20
> [37285.241097] lr : __split_huge_pmd+0x174/0x34c=20
> [37285.241407] sp : ffff800023a56fe0=20
> [37285.241642] x29: ffff800023a56fe0 x28: 0000000000000000 x27:
> ffff0001c54d4060=20
> [37285.242145] x26: 0000000000000000 x25: 0000000000000000 x24:
> fffffc00056cf000=20
> [37285.242661] x23: 1ffff0000474ae0a x22: ffff0007104fe630 x21:
> ffff00014fab66b0=20
> [37285.243175] x20: ffff800023a57080 x19: fffffbffff000000 x18:
> 0000000000000000=20
> [37285.243689] x17: 0000000000000000 x16: ffffb109a2ec7e30 x15:
> 0000ffffd9035c10=20
> [37285.244202] x14: 00000000f2040000 x13: 0000000000000000 x12:
> ffff70000474aded=20
> [37285.244715] x11: 1ffff0000474adec x10: ffff70000474adec x9 :
> dfff800000000000=20
> [37285.245230] x8 : ffff800023a56f63 x7 : 0000000000000001 x6 :
> 0000000000000003=20
> [37285.245745] x5 : ffff800023a56f60 x4 : ffff70000474adec x3 :
> 1fffe000cd086e01=20
> [37285.246257] x2 : 1fffff7fffe00001 x1 : 0000000000000000 x0 :
> fffffbffff000008=20
> [37285.246770] Call trace:=20
> [37285.246952]  __split_huge_pmd+0x1d8/0x34c=20
> [37285.247246]  split_huge_pmd_address+0x10c/0x1a0=20
> [37285.247577]  try_to_unmap_one+0xb64/0x125c=20
> [37285.247878]  rmap_walk_file+0x1dc/0x4b0=20
> [37285.248159]  try_to_unmap+0x134/0x16c=20
> [37285.248427]  split_huge_page_to_list+0x5ec/0xcbc=20
> [37285.248763]  truncate_inode_partial_folio+0x194/0x2ec=20

Clearly this is due to my changes, but I'm wondering why it doesn't
happen with misaligned mappings and shmem today.  Here's the path I
see as being problematic:

split_huge_page()
  split_huge_page_to_list()
    unmap_page()
      ttu_flags =3D ... TTU_SPLIT_HUGE_PMD ...
      try_to_unmap()
        try_to_unmap_one()
          split_huge_pmd_address()
            pmd =3D pmd_offset(pud, address);
            __split_huge_pmd(vma, pmd, address, freeze, folio);
              if (folio) {
                if (folio !=3D page_folio(pmd_page(*pmd)))

I'm assuming it's crashing at that line.  Calling pmd_page() on a
pmd that we haven't checked is pmd_trans_huge() seems like a really
bad idea.  I probably compounded that problem by calling page_folio()
on something that's not necessarily a PMD that points to a page, but
I think the real sin here is that nobody checks before this that it's
trans_huge.

Here's Option A for fixing it: Only check pmd_page() after checking
pmd_trans_huge():

+++ b/mm/huge_memory.c
@@ -2145,15 +2145,14 @@ void __split_huge_pmd(struct vm_area_struct *vma, p=
md_t
*pmd,
         * pmd against. Otherwise we can end up replacing wrong folio.
         */
        VM_BUG_ON(freeze && !folio);
-       if (folio) {
-               VM_WARN_ON_ONCE(!folio_test_locked(folio));
-               if (folio !=3D page_folio(pmd_page(*pmd)))
-                       goto out;
-       }
+       VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));

        if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
-           is_pmd_migration_entry(*pmd))
+           is_pmd_migration_entry(*pmd)) {
+               if (folio && folio !=3D page_folio(pmd_page(*pmd)))
+                       goto out;
                __split_huge_pmd_locked(vma, pmd, range.start, freeze);
+       }

 out:
        spin_unlock(ptl);

I can think of a few more ways of fixing it, but that one seems best.
Not tested in any meaningful way, more looking for feedback.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
