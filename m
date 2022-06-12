Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62CCC43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 18:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiFLSor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 14:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiFLSo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 14:44:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F36C5C84D
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:44:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15B8EB80CFF
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB87CC341D0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655059465;
        bh=kq+ZTyr/+EZan0OI+B+Gn9OC8Gt6qgB27u/iPvHpj0s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mCXkkt9LcVdRIqRex5AMm1eDLkSCUAZHsvvcT49g0xaHUNc/wOVcdK49keWpanGXj
         Pr4PaJ6AYw8lEqvVPq8e7ZnQ8y9hcBdJ7lNRuc3ADW/NyIJZ+WonTHrYgNRgMKP81W
         fKwtV1JemCqIiK7l5w2hZqInAVyFZgy0kaxVb4sgWrX+vmzeAKPeiCMokINmtYuwzU
         zpRGn1J4mKtGoQxXL/ZpgzLqhwDyGn2jjKe7F+WDqKlA8Tl976MZskwKtBcbhOU9V4
         iSG+I2EorIua9roJa/Ux7f6PxSIiWD3/7GocBCzCEIgxPCRyuOOy0MAolgtl87YbQQ
         fPxhOilxxr8Lw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ACA02CC13B6; Sun, 12 Jun 2022 18:44:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 18:44:25 +0000
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
Message-ID: <bug-216073-201763-mUXS1oEcIm@https.bugzilla.kernel.org/>
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

--- Comment #16 from yuzhao@google.com ---
On Sun, Jun 12, 2022 at 12:05 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> > Please let me know if there is something we want to test -- I can
> > reproduce the problem reliably:
> >
> > ------------[ cut here ]------------
> > kernel BUG at mm/usercopy.c:101!
>
> The line right before cut here would have been nice ;-)

Right.

$ grep usercopy:
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
2882303761517129920, size 11)!
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
8574853690513436864, size 11)!
usercopy: Kernel memory exposure attempt detected from vmalloc (offset
7998392938210013376, size 11)!
...

> https://lore.kernel.org/linux-mm/YqXU+oU7wayOcmCe@casper.infradead.org/
>
> might fix your problem, but I can't be sure without that line.

Thanks, it worked!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
