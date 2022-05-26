Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2729BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 10:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiEZKhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiEZKhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 06:37:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C3130A
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 03:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16F9CB81F14
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6C0FC3411E
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653561451;
        bh=DaG2BLvSGkWvpqRtClBbXXwGl+LdVOCF2OFzyh6/zBE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Psx6GTw6fvnGxhy8ai6deWa4Eh3OXWVhK59SNaa0ppJtKFKywukN7QElyyndnrM0l
         TUfHr+RwGjXxPfdT2aTiZvUMKHs/F+7jjkO0FjOxPA7xQ2TolmIXBZkucxpxfhUQUt
         wycu9zUQCsPRx5RrwldJWWMtr9i0DvzK90TqV9X3cXofJtvbbwjJfP3u+ZSPCsa3d7
         AhXAhlucmnOpdOYxKHl5NK4yXLbmPOy3UPa935cZWtTGg95XZt3e1aUc/uyrnEdBLS
         IjHpWVPW2C1jL2lCXIUMVVe3u/q+wES/O8uLXLokD0KgyLD+U9t4Rel0WfReWuaJdo
         jZ4FQ87uZX4yw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C71F7C05FD4; Thu, 26 May 2022 10:37:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Thu, 26 May 2022 10:37:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgorman@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-LVgZDLbN9c@https.bugzilla.kernel.org/>
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

--- Comment #23 from Mel Gorman (mgorman@suse.de) ---
(In reply to Peter Pavlisko from comment #21)
> (In reply to Mel Gorman from comment #20)
> > (In reply to Peter Pavlisko from comment #19)
> > > (In reply to Mel Gorman from comment #18)
> > > > Created attachment 301044 [details]
> > > > Patch to always allocate at least one page
> > > >=20
> > > > Hi Peter,
> > > >=20
> > > > Could you try the attached patch against 5.18 please? I was unable =
to
> > > > reproduce the problem but I think what's happening is that an array=
 for
> > > > receiving a bulk allocation is partially populated and the bulk
> allocator
> > > is
> > > > returning without allocating at least one page. Allocating even one
> page
> > > > should hit the path where kswapd is woken.
> > >=20
> > > Hi Mel,
> > >=20
> > > I tried this patch and it does indeed work with 5.18.0-rc7. Without t=
he
> > > patch it freezes, after I apply the patch the archive extracts
> flawlessly.
> >=20
> > Thanks Peter, I'll prepare a proper patch and post it today. You won't =
be
> > cc'd as I only have the bugzilla email alias for you but I'll post a
> > lore.kernel.org link here.
>=20
> Thank you very much.
>=20
> I don't know if this is the proper place to discuss this, but I am curious
> about the cause. Was it an issue with the way XFS is calling the allocator
> in a for(;;) loop when it does not get the expected result? Or was it an
> issue with the allocator itself not working in some obscure edge case? Or
> was it my .config, stretching the kernel ability to function in a bad way?

I think blaming XFS would be excessive even though the API says it only
attempts to allocate the requested number of pages with no guarantee the ex=
act
number will be returned. A glance at the implementation would show it was
trying to return at least one page and the code flow of XFS hints that the =
XFS
developers expected that some progress would generally be made or kswapd wo=
uld
be woken as appropriate. The original intention was that the caller did not
necessarily need all the pages but that's not true for XFS or NFS. While I
could have altered XFS, it would have encouraged boiler-plate code to be
created for NFS or any other user of the API that requires the exact number=
 of
pages to be returned.

The allocator was working as intended but not necessarily working as desired
for callers.

I don't think your .config is at fault. While I could not reproduce the
problem, I could force the problem to occur by injecting failures. It's
possible that the problem is easier to trigger on your particular machine b=
ut
the corner case existed since 5.13. It's an interesting coincidence that a
similar problem was found on NFS at roughly the same time which might indic=
ate
that something else changed to make this corner case easier to trigger but =
the
corner case was always there.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
