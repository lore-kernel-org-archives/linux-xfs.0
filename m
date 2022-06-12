Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A12C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 19:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiFLTIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 15:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiFLTIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 15:08:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5E8B8B
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 12:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0AE7B80D11
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 19:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AB8CC3411C
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655060878;
        bh=nLb+B2UVQitgVvAA6S4kLvpGfczg96ogrxfBYFiZpTQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rqMDWhrE1aqgx5QmUAmu8IoAkhMgG+Nh7F/CS1bmyfUrpKv7DBAw4ptSpoqkyHU8l
         miyDW2lZhW9jE+okjLTLceUBrng/ODbOfRE28U9P/AbKReBHvUa019Lgp/6xOnUUNO
         uP9vHOaiydSECaK7+CdH3oaKzMfmNLTt9SHKISGr8fQY8vQ6mEDXxGMfLchMznFr+/
         pvPjewSc/URUeYxC4nDXIkramk3Dl7RzIWGwwwW6XZVYrbwKb9JO1qs0wcSxpy6Pyi
         pGlhOn10jParxoOyEXUsh3HChMZLxbVlbZUcNhBwLK83aPMmSLc+WB7jDi0JDMVgXG
         44fRsCQx/zJlQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4A573C05FF5; Sun, 12 Jun 2022 19:07:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 19:07:57 +0000
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
Message-ID: <bug-216073-201763-gYCzZSJzSz@https.bugzilla.kernel.org/>
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

--- Comment #17 from urezki@gmail.com ---
> On Sun, Jun 12, 2022 at 03:03:20PM +0200, Uladzislau Rezki wrote:
> > > @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *=
ptr,
> unsigned long n,
> > >                   return;
> > >           }
> > >=20=20
> > > -         offset =3D ptr - area->addr;
> > > -         if (offset + n > get_vm_area_size(area))
> > > +         /* XXX: We should also abort for free vmap_areas */
> > > +         offset =3D (unsigned long)ptr - area->va_start;
> > >
> > I was a bit confused about "offset" and why it is needed here. It is al=
ways
> zero.=20
> > So we can get rid of it to make it less confused. From the other hand a
> zero offset
> > contributes to nothing.
>=20
> I don't think offset is necessarily zero.  'ptr' is a pointer somewhere
> in the object, not necessarily the start of the object.
>=20
Right you are. Just checked the __find_vmap_area() it returns VA of the add=
ress
it
belongs to. Initially i was thinking that addr have to be exactly as va->st=
art
only,
so i was wrong.

> > >
> > > +         if (offset + n >=3D area->va_end)
> > >
> > I think it is a bit wrong. As i see it, "n" is a size and what we would
> like to do
> > here is boundary check:
> >=20
> > <snip>
> > if (n > va_size(area))
> >     usercopy_abort("vmalloc", NULL, to_user, 0, n);
> > <snip>
>=20
> Hmm ... we should probably be more careful about wrapping.
>=20
>                 if (n > area->va_end - addr)
>                         usercopy_abort("vmalloc", NULL, to_user, offset, =
n);
>=20
> ... and that goes for the whole function actually.  I'll split that into
> a separate change.
>=20
Based on that offset can be > 0, checking "offset + n" with va->va_end is O=
K.

<snip>
if (offset + n > area->va_end)
    usercopy_abort("vmalloc", NULL, to_user, offset, n);
<snip>

--
Uladzislau Rezki

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
