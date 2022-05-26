Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B38C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 09:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbiEZJRF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 05:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiEZJRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 05:17:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C86C6E4F
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 02:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14B4661B9F
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 09:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D0C5C3411E
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 09:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653556621;
        bh=QQv5NBt5gcJ9kWBY23d4w+wZH3D9HvF+LkYq0G9ji1Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kpS4CC1QyJXTZYhaf9hr0ceydS9xTrErGWOBBao4tHKUWVqKcNdjHmgLwOL99jXhw
         yPG8/ZBh1Zz8r1Vqy0/quEsZk0xxVZp1BfVh3jortFAtNCUkiJl25SI5IoceIUuy4P
         2EJorkUcCUUoncwXct73UZSrNuoPMRQOVdjHAtWb770mAFhTp51wgslfH3n0pGLpY2
         7Vw7m9OLcol1VMiZT1npPVsO1fBS8PJSc4OZ1J0GNWDf9zOO41BMc8GKUsmRGiKOLP
         Xn4f5NTX3jTd/5wBNBvQ7xHAmUIVwcHztKneyFnq/Rfmt3BYvMA6J0/HPH0dVui4y3
         WPrb4h/qFgSXA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3220BC05FD2; Thu, 26 May 2022 09:17:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Thu, 26 May 2022 09:16:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-GwNuopMzC0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #21 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
(In reply to Mel Gorman from comment #20)
> (In reply to Peter Pavlisko from comment #19)
> > (In reply to Mel Gorman from comment #18)
> > > Created attachment 301044 [details]
> > > Patch to always allocate at least one page
> > >=20
> > > Hi Peter,
> > >=20
> > > Could you try the attached patch against 5.18 please? I was unable to
> > > reproduce the problem but I think what's happening is that an array f=
or
> > > receiving a bulk allocation is partially populated and the bulk alloc=
ator
> > is
> > > returning without allocating at least one page. Allocating even one p=
age
> > > should hit the path where kswapd is woken.
> >=20
> > Hi Mel,
> >=20
> > I tried this patch and it does indeed work with 5.18.0-rc7. Without the
> > patch it freezes, after I apply the patch the archive extracts flawless=
ly.
>=20
> Thanks Peter, I'll prepare a proper patch and post it today. You won't be
> cc'd as I only have the bugzilla email alias for you but I'll post a
> lore.kernel.org link here.

Thank you very much.

I don't know if this is the proper place to discuss this, but I am curious
about the cause. Was it an issue with the way XFS is calling the allocator =
in a
for(;;) loop when it does not get the expected result? Or was it an issue w=
ith
the allocator itself not working in some obscure edge case? Or was it my
.config, stretching the kernel ability to function in a bad way?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
