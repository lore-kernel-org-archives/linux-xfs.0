Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA508C25B06
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Aug 2022 23:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiHNXyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Aug 2022 19:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHNXyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Aug 2022 19:54:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16074E0D9
        for <linux-xfs@vger.kernel.org>; Sun, 14 Aug 2022 16:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D50A60F3D
        for <linux-xfs@vger.kernel.org>; Sun, 14 Aug 2022 23:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE5C8C43140
        for <linux-xfs@vger.kernel.org>; Sun, 14 Aug 2022 23:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660521292;
        bh=GIBN95mvXQpXpHUDgwS0bz90MJgoF0cqqlcSbzSgb8Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NFeML4cyvXlTZY9+msgG/7xkfoUBvfHtzHGc+F7nj8DZFcEfP5fTl7qLu/YhL3NKM
         kFSQRMpGq4bCHDHrOSGgOneePM6DcqqvBTfhlP2SQrEjBaxLVj48wM8mtGViNDXw2W
         qfvOar/+WoXPQGmug50P5YOdQE3xB08yNyVwoe/aFZotn3cGzjnH5XTDBKeLVhUDxV
         8iw3DswtMnZfZ4I3RECk1N+sKAOLBpVlIbpJf+kgumljOoZc/2+wK5Ot8x8pf+P2ZX
         N2uEOieqCyCxEMrd1/LNkmQMbnPX5LCMQ/kTt5U9cD+/QmtHnXuL9Dcm0RQoc3aTin
         kS1+2l8nyjiOQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DBB22C0422F; Sun, 14 Aug 2022 23:54:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Sun, 14 Aug 2022 23:54:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-jdxdDvUKTL@https.bugzilla.kernel.org/>
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

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
[cc Amir, the 5.10 stable XFS maintainer]

On Tue, Aug 09, 2022 at 11:46:23AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
>=20
>             Bug ID: 216343
>            Summary: XFS: no space left in xlog cause system hang
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.10.38
>           Hardware: ARM
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zhoukete@126.com
>         Regression: No
>=20
> Created attachment 301539
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D301539&action=3Dedit
> stack
>=20
> 1. cannot login with ssh, system hanged and cannot do anything
> 2. dmesg report 'audit: audit_backlog=3D41349 > audit_backlog_limit=3D819=
2'
> 3. I send sysrq-crash and get vmcore file , I dont know how to reproduce =
it.
>=20
> Follwing is my analysis from vmcore:
>=20
> The reason why tty cannot login is pid 2021571 hold the acct_process mute=
x,
> and
> 2021571 cannot release mutex because it is wait for xlog release space. S=
ee
> the
> stac info in the attachment of stack.txt
>=20
> So I try to figure out what happened to xlog
>=20
> crash> struct xfs_ail.ail_target_prev,ail_targe,ail_head=C2=A00xffff00ff8=
84f1000=20
> =C2=A0=C2=A0ail_target_prev =3D 0xe9200058600
> =C2=A0=C2=A0ail_target =3D 0xe9200058600
> =C2=A0=C2=A0ail_head =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0next =3D 0xffff0340999a0a80,=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0prev =3D 0xffff020013c66b40
> =C2=A0=C2=A0}
>=20
> there are 112 log item in ail list
> crash> list 0xffff0340999a0a80 | wc -l
> 112=20
>=20
> 79 item of them are xlog_inode_item
> 30 item of them are xlog_buf_item
>=20
> crash> xfs_log_item.li_flags,li_lsn 0xffff0340999a0a80 -x=20
>   li_flags =3D 0x1
>   li_lsn =3D 0xe910005cc00 =3D=3D=3D> first item lsn
>=20
> crash> xfs_log_item.li_flags,li_lsn ffff020013c66b40 -x
>   li_flags =3D 0x1
>   li_lsn =3D 0xe9200058600 =3D=3D=3D> last item lsn
>=20
> crash>xfs_log_item.li_buf=C2=A00xffff0340999a0a80=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
> =C2=A0li_buf =3D 0xffff0200125b7180
>=20
> crash> xfs_buf.b_flags 0xffff0200125b7180 -x
> =C2=A0b_flags =3D 0x110032=C2=A0=C2=A0(XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_=
INODES|_XBF_PAGES)=20
>=20
> crash> xfs_buf.b_state 0xffff0200125b7180 -x
>   b_state =3D 0x2 (XFS_BSTATE_IN_FLIGHT)
>=20
> crash> xfs_buf.b_last_error,b_retries,b_first_retry_time 0xffff0200125b71=
80
> -x
>   b_last_error =3D 0x0
>   b_retries =3D 0x0
>   b_first_retry_time =3D 0x0=20
>=20
> The buf flags show the io had been done(XBF_DONE is set).
> When I review the code xfs_buf_ioend, if XBF_DONE is set,
> xfs_buf_inode_iodone
> will be called and it will remove the log item from ail list, then release
> the
> xlog space by moving the tail_lsn.
>=20
> But now this item is still in the ail list, and the b_last_error =3D 0,
> XBF_WRITE
> is set.
>=20
> xfs buf log item is the same as the inode log item.
>=20
> crash> list -s xfs_log_item.li_buf 0xffff0340999a0a80
> ffff033f8d7c9de8
> =C2=A0=C2=A0li_buf =3D 0x0
> crash> xfs_buf_log_item.bli_buf=C2=A0=C2=A0ffff033f8d7c9de8
> =C2=A0=C2=A0bli_buf =3D 0xffff0200125b4a80
> crash> xfs_buf.b_flags 0xffff0200125b4a80 -x
> =C2=A0=C2=A0b_flags =3D 0x100032=C2=A0(XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_=
PAGES)=20
>=20
> I think it is impossible that (XBF_DONE is set & b_last_error =3D 0) and =
the
> item
> still in the ail.
>=20
> Is my analysis correct?=20
> Why xlog space cannot release space?
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
