Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C64C00140
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 16:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiHOQM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Aug 2022 12:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiHOQM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Aug 2022 12:12:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CDDDEE7
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 09:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 999D7CE113E
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 16:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7954C43143
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660579940;
        bh=/iPBCzOTRkXPoGredWii4VDDQRymC81oy0JRx1djvyY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Lh90AAvrT9qMAgPvNpE38/4vOsyiFkBG9+Fu721a2OBL3nemoxB//16XkDFqKo0nJ
         2vAE1lpJSyZ16lnsfMhIN5qQ8XFqCXrCFNZ6LmpS6UheERbnKL+cATPLjsOKzM0pPT
         ymPSIOmGxDK3pZmNFMPil+SbdWMoUxzr2V8fqf53Juc5xCKYRcJJSBEWXE3ZboXBeE
         vNj3/pyYkLPqbdEzlQ4HS4CS360KUUu/VM1RQosCQPnoCK7aC1RZivp/bez5XECoCj
         KHPbec4L79D3vW3GQPvVdorU2kbhtjUUgXe9FJpcJLX3a/ItoSsCptrM1PoTCnmBqK
         Hqk0i7kqxUdTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C5B1DC433E4; Mon, 15 Aug 2022 16:12:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Mon, 15 Aug 2022 16:12:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: amir73il@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216343-201763-NC5Ss92xjn@https.bugzilla.kernel.org/>
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

--- Comment #2 from Amir Goldstein (amir73il@gmail.com) ---
On Mon, Aug 15, 2022 at 2:54 AM Dave Chinner <david@fromorbit.com> wrote:
>
> [cc Amir, the 5.10 stable XFS maintainer]
>
> On Tue, Aug 09, 2022 at 11:46:23AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
> >
> >             Bug ID: 216343
> >            Summary: XFS: no space left in xlog cause system hang
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: 5.10.38
> >           Hardware: ARM
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: zhoukete@126.com
> >         Regression: No
> >
> > Created attachment 301539
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=3D301539&action=3De=
dit
> > stack
> >
> > 1. cannot login with ssh, system hanged and cannot do anything
> > 2. dmesg report 'audit: audit_backlog=3D41349 > audit_backlog_limit=3D8=
192'
> > 3. I send sysrq-crash and get vmcore file , I dont know how to reproduce
> it.
> >
> > Follwing is my analysis from vmcore:
> >
> > The reason why tty cannot login is pid 2021571 hold the acct_process mu=
tex,
> and
> > 2021571 cannot release mutex because it is wait for xlog release space.=
 See
> the
> > stac info in the attachment of stack.txt
> >
> > So I try to figure out what happened to xlog
> >
> > crash> struct xfs_ail.ail_target_prev,ail_targe,ail_head 0xffff00ff884f=
1000
> >   ail_target_prev =3D 0xe9200058600
> >   ail_target =3D 0xe9200058600
> >   ail_head =3D {
> >     next =3D 0xffff0340999a0a80,
> >     prev =3D 0xffff020013c66b40
> >   }
> >
> > there are 112 log item in ail list
> > crash> list 0xffff0340999a0a80 | wc -l
> > 112
> >
> > 79 item of them are xlog_inode_item
> > 30 item of them are xlog_buf_item
> >
> > crash> xfs_log_item.li_flags,li_lsn 0xffff0340999a0a80 -x
> >   li_flags =3D 0x1
> >   li_lsn =3D 0xe910005cc00 =3D=3D=3D> first item lsn
> >
> > crash> xfs_log_item.li_flags,li_lsn ffff020013c66b40 -x
> >   li_flags =3D 0x1
> >   li_lsn =3D 0xe9200058600 =3D=3D=3D> last item lsn
> >
> > crash>xfs_log_item.li_buf 0xffff0340999a0a80
> >  li_buf =3D 0xffff0200125b7180
> >
> > crash> xfs_buf.b_flags 0xffff0200125b7180 -x
> >  b_flags =3D 0x110032  (XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_INODES|_XBF_P=
AGES)
> >
> > crash> xfs_buf.b_state 0xffff0200125b7180 -x
> >   b_state =3D 0x2 (XFS_BSTATE_IN_FLIGHT)
> >
> > crash> xfs_buf.b_last_error,b_retries,b_first_retry_time 0xffff0200125b=
7180
> -x
> >   b_last_error =3D 0x0
> >   b_retries =3D 0x0
> >   b_first_retry_time =3D 0x0
> >
> > The buf flags show the io had been done(XBF_DONE is set).
> > When I review the code xfs_buf_ioend, if XBF_DONE is set,
> xfs_buf_inode_iodone
> > will be called and it will remove the log item from ail list, then rele=
ase
> the
> > xlog space by moving the tail_lsn.
> >
> > But now this item is still in the ail list, and the b_last_error =3D 0,
> XBF_WRITE
> > is set.
> >
> > xfs buf log item is the same as the inode log item.
> >
> > crash> list -s xfs_log_item.li_buf 0xffff0340999a0a80
> > ffff033f8d7c9de8
> >   li_buf =3D 0x0
> > crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
> >   bli_buf =3D 0xffff0200125b4a80
> > crash> xfs_buf.b_flags 0xffff0200125b4a80 -x
> >   b_flags =3D 0x100032 (XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_PAGES)
> >
> > I think it is impossible that (XBF_DONE is set & b_last_error =3D 0) an=
d the
> item
> > still in the ail.
> >
> > Is my analysis correct?

I don't think so.
I think this buffer write is in-flight.

> > Why xlog space cannot release space?

Not sure if space cannot be released or just takes a lot of time.
There are several AIL/CIL improvements in upstream kernel and
none of them are going to land in 5.10.y.

The reported kernel version 5.10.38 has almost no upstream fixes
at all, but I don't think that any of the fixes in 5.10.y are relevant for
this case anyway.

If this hang happens often with your workload, I suggest using
a newer kernel and/or formatting xfs with a larger log to meet
the demands of your workload.

Thanks,
Amir.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
