Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E2FC00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 08:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiHRIXP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 04:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240585AbiHRIXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 04:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9221FB20
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 01:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B2C8B8212C
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 08:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD186C43140
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 08:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660810987;
        bh=gJA5/6Q/cqoXoYfIElw6vU0sK7x9jq9F3sbqkwK30Is=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Idub/OgsItDjlNT6pKIujVJ8OpOL5As7V1+0yvS2DrnFuhijRpwimuRp874GcSwi2
         avojE5BUuQ5E4YcpZuFVwdarynsIRp3j5QKNSS8RU6jy2hfOOXRSBKJ6MeaK2PXy6V
         MA8Ve6jolYr3fTIgWz0ZblGemhBGdxM1VqmFmzVEvN0mtgjnPlpR3duWAURMDY0AVh
         lVnID+9QJjdVS9eOqCg9owiBMdpblFtFHYHTU1obWCpIRvt605C7i9BUMhmAfwGf37
         8H93anOdZfotVcZxfwg2lp3BwRUVIoqexjH+soVqS0AKflsyg3URrwedQDT+Bv/gy4
         BpmnnD/5KSQkw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CA567C433E6; Thu, 18 Aug 2022 08:23:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Thu, 18 Aug 2022 08:23:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-zGmyXERW6w@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

--- Comment #7 from zhoukete@126.com ---
(In reply to Amir Goldstein from comment #6)
> On Wed, Aug 17, 2022 at 1:19 PM <bugzilla-daemon@kernel.org> wrote:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
> >
> > --- Comment #5 from zhoukete@126.com ---
> > (In reply to Amir Goldstein from comment #4)
> >
> > >
> > > According to xfs_trans_dirty_buf() I think it could mean uptodate and
> > > dirty buffer.
> > >
> >
> > when I review the xfs_trans_dirty_buf code, I found that xfs inode item
> > b_log_item is null,
> >
> > crash> xfs_log_item.li_buf,li_ops 0xffff0340999a0a80 -x
> >   li_buf =3D 0xffff0200125b7180
> >   li_ops =3D 0xffff800008faec60 <xfs_inode_item_ops>
> > crash> xfs_buf.b_log_item 0xffff0200125b7180
> >   b_log_item =3D 0x0
> >
> > and only xfs buf log item b_log_item has value
> >
> > crash> xfs_log_item.li_buf,li_ops ffff033f8d7c9de8 -x
> >   li_buf =3D 0x0
> >   li_ops =3D 0xffff800008fae8d8 <xfs_buf_item_ops>
> > crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
> >   bli_buf =3D 0xffff0200125b4a80
> > crash> xfs_buf.b_log_item 0xffff0200125b4a80
> >   b_log_item =3D 0xffff033f8d7c9de8
> > crash> xfs_buf_log_item.bli_flags 0xffff033f8d7c9de8
> >   bli_flags =3D 2     (XFS_BLI_DIRTY)
> > crash> xfs_buf_log_item.bli_item.li_flags  ffff033f8d7c9de8
> >   bli_item.li_flags =3D 1,  (XFS_LI_IN_AIL)
> >
> > So xfs buf log item XFS_DONE is set because of xfs_trans_dirty_buf(),buf
> xfs
> > inode log item never call xfs_trans_dirty_buf() because of b_log_item =
=3D=3D
> 0x0.
> >
> > Do  you know the reason why xfs inode log item XFS_DONE is set=EF=BC=9F
> >
>=20
> #define XBF_DONE        (1u << 5) /* all pages in the buffer uptodate */
>=20
> Buffer uptodate does not mean that it is not dirty.
> I am not sure about the rest of your analysis.
>=20
> > >
> > > Maybe the hardware never returned with a response?
> > > Hard to say. Maybe someone else has ideas.
> > >
> >
> > If we can prove that XFS_DONE isn't stand for iodone, I think this issue
> may
> > cause by the hardware error.
> >
> > I find the err msg in dmesg:
> > [ 9824.111366] mpt3sas_cm0: issue target reset: handle =3D (0x0034)
> >
> > Maybe it tell us mpt3sas lost the io requests before.
> >
>=20
> Yes, maybe it does.
>=20
> Anyway, if your hardware had errors, could it be that your
> filesystem is shutting down?
>=20
> If it does, you may be hit by the bug fixed by
> 84d8949e7707 ("xfs: hold buffer across unpin and potential shutdown
> processing")
> but I am not sure if all the conditions in this bug match your case.
>=20
> If you did get hit by this bug, you may consider upgrade to v5.10.135
> which has the bug fix.
>=20
> Thanks,
> Amir.

I think xfs isn't in shutdown stat,
crash> xfs_mount.m_flags 0xffff00ff85169000 -x
  m_flags =3D 0x100  (XFS_MOUNT_ATTR2)

About the 84d8949e7707 ,I would try to back port to 5.10.38.
Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
