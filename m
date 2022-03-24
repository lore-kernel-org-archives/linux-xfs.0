Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FC0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 12:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiCXMC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 08:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbiCXMC0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 08:02:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494A7986D1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 05:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C47B82377
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 12:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26DFAC340F5
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 12:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648123251;
        bh=myZ/r6Wyoon5VYEy5z0Ybuv6r7Dn2onfxllTzQSX4yA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dERtyWavnRskVz5h0vrhKiX+ohqR5HEMGSSW8dvHiW/Hs4KfuRhnNSE8uluS2kiyt
         RDJlu3bIU7T+69AAGrLExi4UcxvSquinHSn/xaCjBl8IkJvzK99HuUV0+ieK9cr9I8
         4SDYdi3gD7B0lS1xF8dz6dE0zkW2u5uy8PJZi8Dx7zUGWdvjUBKq/f3ZudYaZQK3c1
         7sCIJiSkk2qwQSsSezWndow8CzSsdH2aoBu88twinzRsWo5kVbJaikWt6iLEU6Tzxz
         e7TLpJPKk1ll5X+q0aMWt+4PBm6nakwro40MYaEjiAj4qkyjLwKRMa9O45+tyyu4OM
         co8UzxCat05ow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 126A3C05FD6; Thu, 24 Mar 2022 12:00:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215687] chown behavior on XFS is changed
Date:   Thu, 24 Mar 2022 12:00:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215687-201763-b62TiQqzZi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215687-201763@https.bugzilla.kernel.org/>
References: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215687

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
(In reply to The Linux kernel's regression tracker (Thorsten Leemhuis) from
comment #3)
> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> to make this easily accessible to everyone.
>=20
> On 15.03.22 09:12, bugzilla-daemon@kernel.org wrote:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215687
> >=20
> >            Summary: chown behavior on XFS is changed
>=20
> Darrick, what's up with this bug reported more than ten days ago? It's a
> a regression reported the reporter even bisected to a change of yours
> (e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") --
> see the ticket for details) =E2=80=93 but nothing happened afaics. Did the
> discussion about this continue somewhere else or did it fall through the
> cracks?
>=20
> Anyway: I'm adding it to regzbot, my Linux kernel regression tracking bot:
>=20
> #regzbot ^introduced e014f37db1a2d109afa750042ac4d69cf3e3d88e
> #regzbot title xfs: chown behavior changed
> #regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215687
> #regzbot ignore-activity
>=20
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>=20
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.

Darrick has talked about it with us in IRC (as below, hope that helps):

2022-03-16 00:02 < djwong> all that setgid dropping came out of complaints =
that
xfs didn't handle that the same way as all the other linux filesystems
2022-03-16 00:03 < djwong> zlang: ^^^
2022-03-16 00:04 < djwong> originally the xfs setattr more or less did what=
 the
vfs setattr did
2022-03-16 00:04 < djwong> but now people update the vfs setattr and they d=
on't
update the xfs version
2022-03-16 00:05 < djwong> so is this a "unique feature of xfs"?
2022-03-16 00:06 < djwong> inconsistent behavior from xfs?
2022-03-16 00:06 < djwong> or just bitrotting crap in the kernel?
2022-03-16 01:46 < zlang> djwong, sandeen: Thanks! I don't know if there's a
standard describe that, just thought about how should we backport it, hope =
no
customer depend on the old behavior :)
2022-03-16 01:55 < zlang> That would be great if no customer depend on that=
, or
they might complain, if their script expect a program lose S_ISUID and S_IS=
GID
after chown, but not, then cause permission/security problem
2022-03-16 02:00 < zlang> So if we backport that, we might be better to warn
that in doc. To remind them if they hope to "lose" S_ISUID and S_ISGID bits,
better to do that clearly and definitely
2022-03-16 02:01 < djwong> <nod> all that setgid handling is ... very murky
2022-03-16 02:01 < djwong> it at least matches ext4 and btrfs now :P


And another bug report (which can be closed DUP on this one):
https://bugzilla.kernel.org/show_bug.cgi?id=3D215693

Darrick has reviewed and replied in IRC (update as below):

2022-03-16 17:10 < zlang> djwong: Did you notice that generic/673 fails on
xfs-5.18-merge-1, looks similar with that chown problem
2022-03-16 17:30 < zlang> https://bugzilla.kernel.org/show_bug.cgi?id=3D215=
693
2022-03-16 17:32 < zlang> But this's about reflink (not chown), and sometim=
es
it lose sgid bit after reflink, sometimes not ...
2022-03-16 17:39 < zlang> So I report a seperate bug to track this question,
please help to review and make sure the new expected behaviors. Sorry to br=
ing
this trouble to you
2022-03-17 00:36 < djwong> zlang: both setgid changes that you filed bugs
against stem from the same setattr_copy issue
2022-03-17 00:37 < djwong> also generic/673 is wrong, see
https://lore.kernel.org/fstests/164740142591.3371628.12793589713189041823.s=
tgit@magnolia/T/#u

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
