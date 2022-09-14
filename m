Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACA2ECAAD3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 17:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiINR7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Sep 2022 13:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiINR7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 13:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA44F832FD
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 10:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55318B81C4F
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 17:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18920C43142
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 17:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663178355;
        bh=zw3r9IkIvOW8H7WjcAXnHkAO0JrBxyu8D7gRiGJA2Kc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gjllMB3t//O3gcGexhHJ3W/Asc0eQb8P9LkWrui/9jg3xXp/h0AhoarVeWvXo2xDI
         oWbFOmSYRzfOKqy2+WHNImT4o8BHaNqc3Nz9EdjhZjkZCzPrEHTt6Xl1O9sjNJqZZ8
         Vi7vvQ4Ph3DjM0xElVQ6ije2mzk81zvpwzed+FFQsnwJx/ddsWR52F5DUj0r0Rv86L
         78nfDPA2sReg4y2MWwYMx6KVJD2uZUN/2w615jMGh41rut+7LbXjUjA3i++gu5zArK
         CJLAXE5jdcoYPfW9AtPELBlL9P6COmRQVxKaXGkY5E5p63qYPmY1lZD8zJ1dbhO9mt
         0WjG/805qAnxQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 09454C433E9; Wed, 14 Sep 2022 17:59:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216486] [xfstests generic/447] xfs_scrub always complains  fs
 corruption
Date:   Wed, 14 Sep 2022 17:59:14 +0000
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
Message-ID: <bug-216486-201763-qMo1UjG1zL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216486-201763@https.bugzilla.kernel.org/>
References: <bug-216486-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216486

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #1)
> On Wed, Sep 14, 2022 at 08:12:56AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216486
> >=20
> >             Bug ID: 216486
> >            Summary: [xfstests generic/447] xfs_scrub always complains  =
fs
> >                     corruption
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: 6.0.0-rc4+
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: zlang@redhat.com
> >         Regression: No
> >=20
> > Recently xfstests generic/447 always fails[1][2][3] on latest xfs kernel
> with
> > xfsprogs. It's reproducible on 1k blocksize and rmapbt enabled XFS (-b
> > size=3D1024 -m rmapbt=3D1). Not sure if it's a kernel bug or a xfsprogs=
 issue,
> or
> > an expected failure.
>=20
> It's an expected failure that is one of the many things fixed by the
> online fsck patchset.  The solution I came up with is described here:
> https://djwong.org/docs/xfs-online-fsck-design/#eventual-consistency-vs-
> online-fsck
>=20
> The TLDR is that scrub is probably racing with a thread that's in the
> middle of doing a file mapping change that involves both an rmap and a
> refcount update.  This is possible because we don't hold the AGF buffer
> between work items in a defer ops chain.

Thanks Darrick, for your reply and confirmation!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
