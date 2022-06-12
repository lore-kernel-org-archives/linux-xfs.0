Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17D0C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 19:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiFLTwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 15:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiFLTwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 15:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EAB57137
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 12:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B11FDB80D1C
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 19:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72D65C341CD
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 19:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655063562;
        bh=dRR+eYIy1Y5LeUSpyfPws7nTexOuVzdcCUTg3xU8PIU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tYeHbroAKQBxA/VcFLSqSmEF/hz1VUxoAs5FrPWvrh0lGiRjx07UvC+cgfTShxAhH
         cyRuiKoNuSxR+kOzKYhiIQ2zZ+C1nipscv0CCeOknrUsSlrNHUYHOeFIyTk2TDHdkZ
         M9FlEIFJeHUgPTB7gkRmFE2C/Hd4SAyCGGqaTBUwO+IX8nIxgOpwieuhfjstXOOEfv
         cwWPHzbNaEwKLz9L2WnFOcwJSOlX4HVS3XbGIPWEe59pWCdDqPJ7/Smwl5YR2iXXBE
         OFWzHabTTpYVE8znT4VvXjthoc0Gzrm9aDccSmd55k8Xfowi+79A6f00A6RKoscIoR
         aZN5piCREFQHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 62646C05FD6; Sun, 12 Jun 2022 19:52:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 19:52:41 +0000
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
Message-ID: <bug-216073-201763-Km5N4jjmqf@https.bugzilla.kernel.org/>
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

--- Comment #18 from willy@infradead.org ---
On Sun, Jun 12, 2022 at 12:43:45PM -0600, Yu Zhao wrote:
> On Sun, Jun 12, 2022 at 12:05 PM Matthew Wilcox <willy@infradead.org> wro=
te:
> >
> > On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> > > Please let me know if there is something we want to test -- I can
> > > reproduce the problem reliably:
> > >
> > > ------------[ cut here ]------------
> > > kernel BUG at mm/usercopy.c:101!
> >
> > The line right before cut here would have been nice ;-)
>=20
> Right.
>=20
> $ grep usercopy:
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> 2882303761517129920, size 11)!
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> 8574853690513436864, size 11)!
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset
> 7998392938210013376, size 11)!

That's a different problem.  And, er, what?  How on earth do we have
an offset that big?!

                struct vm_struct *area =3D find_vm_area(ptr);
                offset =3D ptr - area->addr;
                if (offset + n > get_vm_area_size(area))
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);

That first offset is 0x2800'0000'0000'30C0

You said it was easy to replicate; can you add:

                        printk("addr:%px ptr:%px\n", area->addr, ptr);

so that we can start to understand how we end up with such a bogus
offset?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
