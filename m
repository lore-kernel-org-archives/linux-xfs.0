Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A954C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 13:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbiFLNDd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 09:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiFLNDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 09:03:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2CC2AEE
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 06:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0977260ED9
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 13:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6190DC341CD
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655039007;
        bh=y+aVLJ98U1qAcwb/+YAEbM6FaxYFnUh8ROE4cDMGZQM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XthpGk4uJHDBMR2W5GD56udfwS1yZ44yuK5L6XBAe5Te6PQOqv3EfXoCj6EcSiKGD
         v0dlzEkEaDaYz9G8t+yGslqC2ioaUwcfp5uDNc6wV+T8pjgDOW56j8KaJzOBjU5Ksg
         qOviuPkpnVT5ajNV3eHWHh72cp68GIWXKPTvTDZK0qFOGgMuRJHWwpLafUBS1v/uVG
         gLfxHSoJHkAlLrZkv8rXpy9XxgP/nDy6XaTU7j+YH16GmtIUuyv4QsIYuVAQzjqFn4
         BjMQv0fptXM/Y9ETlokAPeZltjF9MVMO6KDS5OCImsxq9oj8bEViIGvC4VV3uZSVkk
         j1qKVTnarxkjQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 51033CC13B4; Sun, 12 Jun 2022 13:03:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 13:03:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: urezki@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-VwAnjfQ9ww@https.bugzilla.kernel.org/>
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

--- Comment #12 from urezki@gmail.com ---
> On Sun, Jun 12, 2022 at 12:42:30PM +0800, Zorro Lang wrote:
> > Looks likt it's not a s390x specific bug, I just hit this issue once (n=
ot
> 100%
> > reproducible) on aarch64 with linux v5.19.0-rc1+ [1]. So back to cc
> linux-mm
> > to get more review.
> >=20
> > [1]
> > [  980.200947] usercopy: Kernel memory exposure attempt detected from
> vmalloc 'no area' (offset 0, size 1)!=20
>=20
>        if (is_vmalloc_addr(ptr)) {
>                struct vm_struct *area =3D find_vm_area(ptr);
>                if (!area) {
>                        usercopy_abort("vmalloc", "no area", to_user, 0, n=
);
>=20
> Oh.  Looks like XFS uses vm_map_ram() and vm_map_ram() doesn't allocate
> a vm_struct.
>=20
> Ulad, how does this look to you?
>
It looks like a correct way to me :) XFS uses
per-cpu-vm_map_ram()-vm_unmap_ram()
API which do not allocate "vm_struct" because it is not needed.

>
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index baeacc735b83..6bc2a1407c59 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -173,7 +173,7 @@ static inline void check_heap_object(const void *ptr,
> unsigned long n,
>       }
>=20=20
>       if (is_vmalloc_addr(ptr)) {
> -             struct vm_struct *area =3D find_vm_area(ptr);
> +             struct vmap_area *area =3D find_vmap_area((unsigned long)pt=
r);
>               unsigned long offset;
>=20=20
>               if (!area) {
> @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr,
> unsigned long n,
>                       return;
>               }
>=20=20
> -             offset =3D ptr - area->addr;
> -             if (offset + n > get_vm_area_size(area))
> +             /* XXX: We should also abort for free vmap_areas */
> +             offset =3D (unsigned long)ptr - area->va_start;
>
I was a bit confused about "offset" and why it is needed here. It is always
zero.=20
So we can get rid of it to make it less confused. From the other hand a zero
offset
contributes to nothing.

>
> +             if (offset + n >=3D area->va_end)
>
I think it is a bit wrong. As i see it, "n" is a size and what we would lik=
e to
do
here is boundary check:

<snip>
if (n > va_size(area))
    usercopy_abort("vmalloc", NULL, to_user, 0, n);
<snip>

--
Uladzislau Rezki

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
