Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740A1C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 17:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiFLR1C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 13:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiFLR1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 13:27:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145255A083
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 10:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64ACACE0E04
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 17:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CF4DC341CC
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655054816;
        bh=zFXw52z845UG55y8ifh4SvT8wfKFOc8a4O0kSQUi6Cs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IgtJItW/5osxjE1kCBrRufqL4Fs9rvZehEKpoOl4VQXre/TilEGw4UMNSvrQvtHIi
         gaGecvcOZqC3O/K1Xq173o2Ge4Wjpsc3AszAKMIksRTyaO0VCEwbc4IP9NDCRFDzeC
         sL22YbyZfkOzAJROW1RgyrC9q/iV69tnhXAUcYbNSibfYYkblh74UGct8sKnfoWrOO
         +hG3qTGkY3CjzMjpo63IEC//kW8VcAPrKqZDtc2iV8G61C+nkKSJ/jb6Ydv+2sGgvI
         6tbaeN+JK/d303qwlGOCcddjowGG3DzuiK81Bz6rYHwshT34YFvl9xpVgqzcfLFMPn
         ZpGPx5EyTQfuA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5CD74CC13B5; Sun, 12 Jun 2022 17:26:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 17:26:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: willy@infradead.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-ipmB9K3UcC@https.bugzilla.kernel.org/>
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

--- Comment #13 from willy@infradead.org ---
On Sun, Jun 12, 2022 at 03:03:20PM +0200, Uladzislau Rezki wrote:
> > @@ -181,8 +181,9 @@ static inline void check_heap_object(const void *pt=
r,
> unsigned long n,
> >                     return;
> >             }
> >=20=20
> > -           offset =3D ptr - area->addr;
> > -           if (offset + n > get_vm_area_size(area))
> > +           /* XXX: We should also abort for free vmap_areas */
> > +           offset =3D (unsigned long)ptr - area->va_start;
> >
> I was a bit confused about "offset" and why it is needed here. It is alwa=
ys
> zero.=20
> So we can get rid of it to make it less confused. From the other hand a z=
ero
> offset
> contributes to nothing.

I don't think offset is necessarily zero.  'ptr' is a pointer somewhere
in the object, not necessarily the start of the object.

> >
> > +           if (offset + n >=3D area->va_end)
> >
> I think it is a bit wrong. As i see it, "n" is a size and what we would l=
ike
> to do
> here is boundary check:
>=20
> <snip>
> if (n > va_size(area))
>     usercopy_abort("vmalloc", NULL, to_user, 0, n);
> <snip>

Hmm ... we should probably be more careful about wrapping.

                if (n > area->va_end - addr)
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);

... and that goes for the whole function actually.  I'll split that into
a separate change.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
