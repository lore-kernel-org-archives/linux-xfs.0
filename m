Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B90AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 20:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbiFLUx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 16:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiFLUx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 16:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACF742A3B
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 13:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F230B80D07
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 20:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1356C341CF
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655067233;
        bh=Zuuyj3PDsjmuYTcUYW/EUQVFP7yRvaFe8KgDoOx85DM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KWvm9VRmLHom8KTwMmxwUDK84N6eSJIu79abbE578kweCgP/t3EduunraNQN0T37V
         FCTqcNm7yq6l2/Sf/tPg4STstPb2VgV7j1yvvthPeT1TeIlGFeT21MA+G9SRnhbIb1
         Kdwk0KBFYoXSZtdcOf2O2VGtRnqhbLMJWPzR8QAI4lT4gdl9DveavPp/guay5TRW1o
         +jxZlFn+yYw5nRE6KoywFOUClrUXbD4lMVngEKBif9+5+I8Jbm/lkVPYaDaq3NM6yI
         xyny4xI+FcPoskXieAG1lxl3SPBmvxLIP/b7rV5NJWgVsObnHaZ4HOwE3L7MIAiwgf
         nvFqAzBqKYrhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A06AECC13B1; Sun, 12 Jun 2022 20:53:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 20:53:52 +0000
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
Message-ID: <bug-216073-201763-opH3QiEYvc@https.bugzilla.kernel.org/>
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

--- Comment #19 from yuzhao@google.com ---
On Sun, Jun 12, 2022 at 1:52 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 12, 2022 at 12:43:45PM -0600, Yu Zhao wrote:
> > On Sun, Jun 12, 2022 at 12:05 PM Matthew Wilcox <willy@infradead.org>
> wrote:
> > >
> > > On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> > > > Please let me know if there is something we want to test -- I can
> > > > reproduce the problem reliably:
> > > >
> > > > ------------[ cut here ]------------
> > > > kernel BUG at mm/usercopy.c:101!
> > >
> > > The line right before cut here would have been nice ;-)
> >
> > Right.
> >
> > $ grep usercopy:
> > usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> > 2882303761517129920, size 11)!
> > usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> > 8574853690513436864, size 11)!
> > usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> > 7998392938210013376, size 11)!
>
> That's a different problem.  And, er, what?  How on earth do we have
> an offset that big?!
>
>                 struct vm_struct *area =3D find_vm_area(ptr);
>                 offset =3D ptr - area->addr;
>                 if (offset + n > get_vm_area_size(area))
>                         usercopy_abort("vmalloc", NULL, to_user, offset, =
n);
>
> That first offset is 0x2800'0000'0000'30C0
>
> You said it was easy to replicate; can you add:
>
>                         printk("addr:%px ptr:%px\n", area->addr, ptr);
>
> so that we can start to understand how we end up with such a bogus
> offset?

Here you go:

addr:96ffffdfebcd4000 ptr:ffffffdfebcd70c0
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
7566047373982445760, size 11)!

And, not sure if it'd be helpful, with the vmap:

va_start:ffffffd83db0d000 va_end:ffffffd83db13000
addr:44ffffd83db0d000 ptr:ffffffd83db100c0
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
13474770085092536512, size 11)!

which seems to explain why the fix worked.

+               if (offset + n > get_vm_area_size(area)) {
+                       struct vmap_area *vmap =3D
find_vmap_area((unsigned long)ptr);
+
+                       if (vmap)
+                               printk("va_start:%px va_end:%px\n",
vmap->va_start, vmap->va_end);
+                       printk("addr:%px ptr:%px\n", area->addr, ptr);
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);
+               }

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
