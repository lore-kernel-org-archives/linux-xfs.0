Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFB5C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 18:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiFLSBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 14:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbiFLSAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 14:00:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0667E2ED5F
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6B74B80CAB
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 18:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72D50C34115
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655056838;
        bh=Jwwnr3o0AEbbh5t6z0VMs4kfkQEdn2xaU2uTdirM+PQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LBqtFN8x5aVCJA4lUxmaW0sDOHKIf5GNZfq+KkEbvMamHxNV/I5eCrtUi/KyIjkFp
         PU09BuBeQJFVN88o9AUsQLL2STRemnfhJqwFBW3fXzcfXnFDq/4mRdGAyDjUuX7u6s
         0s7q3/fgcESev0dc4SCteY/B0daTmn3U3lwAidobcxheT/OY5zbQLs5EJBVbYmTvrl
         wjvuAJgyVSBLDcsd8WEs7IAoAgN7MtICsBgnH+E2qODYkp0So8J6URBxM4HOD+f7X5
         ZxbQf3P1REoa8gQ21BG2w6ldOwQkD11g69jVPF2n8MY+Quhi+yhFMQMInL7C4lVULU
         bMVnE605aJ72Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5E399CC13B3; Sun, 12 Jun 2022 18:00:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 18:00:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yuzhao@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-Ec451ykR8q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #14 from yuzhao@google.com ---
On Sun, Jun 12, 2022 at 11:27 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 12, 2022 at 03:03:20PM +0200, Uladzislau Rezki wrote:
> > > @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *=
ptr,
> unsigned long n,
> > >                     return;
> > >             }
> > >
> > > -           offset =3D ptr - area->addr;
> > > -           if (offset + n > get_vm_area_size(area))
> > > +           /* XXX: We should also abort for free vmap_areas */
> > > +           offset =3D (unsigned long)ptr - area->va_start;
> > >
> > I was a bit confused about "offset" and why it is needed here. It is al=
ways
> zero.
> > So we can get rid of it to make it less confused. From the other hand a
> zero offset
> > contributes to nothing.
>
> I don't think offset is necessarily zero.  'ptr' is a pointer somewhere
> in the object, not necessarily the start of the object.
>
> > >
> > > +           if (offset + n >=3D area->va_end)
> > >
> > I think it is a bit wrong. As i see it, "n" is a size and what we would
> like to do
> > here is boundary check:
> >
> > <snip>
> > if (n > va_size(area))
> >     usercopy_abort("vmalloc", NULL, to_user, 0, n);
> > <snip>
>
> Hmm ... we should probably be more careful about wrapping.
>
>                 if (n > area->va_end - addr)
>                         usercopy_abort("vmalloc", NULL, to_user, offset, =
n);
>
> ... and that goes for the whole function actually.  I'll split that into
> a separate change.

Please let me know if there is something we want to test -- I can
reproduce the problem reliably:

------------[ cut here ]------------
kernel BUG at mm/usercopy.c:101!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
CPU: 4 PID: 3259 Comm: iptables Not tainted 5.19.0-rc1-lockdep+ #1
pc : usercopy_abort+0x9c/0xa0
lr : usercopy_abort+0x9c/0xa0
sp : ffffffc010bd78d0
x29: ffffffc010bd78e0 x28: 42ffff80ac08d8ec x27: 42ffff80ac08d8ec
x26: 42ffff80ac08d8c0 x25: 000000000000000a x24: ffffffdf4c7e5120
x23: 000000000bec44c2 x22: efffffc000000000 x21: ffffffdf2896b0c0
x20: 0000000000000001 x19: 000000000000000b x18: 0000000000000000
x17: 2820636f6c6c616d x16: 0000000000000042 x15: 6574636574656420
x14: 74706d6574746120 x13: 0000000000000018 x12: 000000000000000d
x11: ff80007fffffffff x10: 0000000000000001 x9 : db174b7f89103400
x8 : db174b7f89103400 x7 : 0000000000000000 x6 : 79706f6372657375
x5 : ffffffdf4d9c617e x4 : 0000000000000000 x3 : ffffffdf4b7d017c
x2 : ffffff80eb188b18 x1 : 42ffff80ac08d8c8 x0 : 0000000000000066
Call trace:
 usercopy_abort+0x9c/0xa0
 __check_object_size+0x38c/0x400
 xt_obj_to_user+0xe4/0x200
 xt_compat_target_to_user+0xd8/0x18c
 compat_copy_entries_to_user+0x278/0x424
 do_ipt_get_ctl+0x7bc/0xb2c
 nf_getsockopt+0x7c/0xb4
 ip_getsockopt+0xee8/0xfa4
 raw_getsockopt+0xf4/0x23c
 sock_common_getsockopt+0x48/0x54
 __sys_getsockopt+0x11c/0x2f8
 __arm64_sys_getsockopt+0x60/0x70
 el0_svc_common+0xfc/0x1cc
 do_el0_svc_compat+0x38/0x5c
 el0_svc_compat+0x68/0xf4
 el0t_32_sync_handler+0xc0/0xf0
 el0t_32_sync+0x190/0x194
Code: aa0903e4 a9017bfd 910043fd 9438be18 (d4210000)
---[ end trace 0000000000000000 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
