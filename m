Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B69C25B08
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 13:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiHQNQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Aug 2022 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiHQNP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 09:15:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FAC50713
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 06:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C9636133D
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 13:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A011C43140
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660742129;
        bh=yJfMtHa2u+rnhuEKsfL/u3OpXL1585daly5/OcqlAyE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=odkvZNBk3vMsesqztRf7Wca+hSp7PO4VZwDJ33N0zttCYv5c6phT4M4vPsd32fscF
         eck/8EI6m3kIUxqbU4GDGIGb3EQck2YWvWKMZ1GEHXJAwPUk74SRW3xgVM+9RcQ0s5
         gOnbNJ6PnhBCiD7RkfZKfP17dMLSFZ7w8rvonrcOANRZwYP0rJirn9fUxKmSjVuDZZ
         OCaQxVDnmntFEptZIixK9r4PgXtqPlGWpw+VUiLor6ahpJoY8ukI8zg6eqcCxihY8G
         g+fywRHwRnos7wdUAWIOeF2U3aB2xsB5UF9OhopMpODG/iJ2IuP07dQIV1STEgN10K
         SDaewcpecGpjw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 59851C433EA; Wed, 17 Aug 2022 13:15:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] XFS: no space left in xlog cause system hang
Date:   Wed, 17 Aug 2022 13:15:28 +0000
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
Message-ID: <bug-216343-201763-9Tsrp1ERyw@https.bugzilla.kernel.org/>
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

--- Comment #6 from Amir Goldstein (amir73il@gmail.com) ---
On Wed, Aug 17, 2022 at 1:19 PM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
>
> --- Comment #5 from zhoukete@126.com ---
> (In reply to Amir Goldstein from comment #4)
>
> >
> > According to xfs_trans_dirty_buf() I think it could mean uptodate and
> > dirty buffer.
> >
>
> when I review the xfs_trans_dirty_buf code, I found that xfs inode item
> b_log_item is null,
>
> crash> xfs_log_item.li_buf,li_ops 0xffff0340999a0a80 -x
>   li_buf =3D 0xffff0200125b7180
>   li_ops =3D 0xffff800008faec60 <xfs_inode_item_ops>
> crash> xfs_buf.b_log_item 0xffff0200125b7180
>   b_log_item =3D 0x0
>
> and only xfs buf log item b_log_item has value
>
> crash> xfs_log_item.li_buf,li_ops ffff033f8d7c9de8 -x
>   li_buf =3D 0x0
>   li_ops =3D 0xffff800008fae8d8 <xfs_buf_item_ops>
> crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
>   bli_buf =3D 0xffff0200125b4a80
> crash> xfs_buf.b_log_item 0xffff0200125b4a80
>   b_log_item =3D 0xffff033f8d7c9de8
> crash> xfs_buf_log_item.bli_flags 0xffff033f8d7c9de8
>   bli_flags =3D 2     (XFS_BLI_DIRTY)
> crash> xfs_buf_log_item.bli_item.li_flags  ffff033f8d7c9de8
>   bli_item.li_flags =3D 1,  (XFS_LI_IN_AIL)
>
> So xfs buf log item XFS_DONE is set because of xfs_trans_dirty_buf(),buf =
xfs
> inode log item never call xfs_trans_dirty_buf() because of b_log_item =3D=
=3D 0x0.
>
> Do  you know the reason why xfs inode log item XFS_DONE is set=EF=BC=9F
>

#define XBF_DONE        (1u << 5) /* all pages in the buffer uptodate */

Buffer uptodate does not mean that it is not dirty.
I am not sure about the rest of your analysis.

> >
> > Maybe the hardware never returned with a response?
> > Hard to say. Maybe someone else has ideas.
> >
>
> If we can prove that XFS_DONE isn't stand for iodone, I think this issue =
may
> cause by the hardware error.
>
> I find the err msg in dmesg:
> [ 9824.111366] mpt3sas_cm0: issue target reset: handle =3D (0x0034)
>
> Maybe it tell us mpt3sas lost the io requests before.
>

Yes, maybe it does.

Anyway, if your hardware had errors, could it be that your
filesystem is shutting down?

If it does, you may be hit by the bug fixed by
84d8949e7707 ("xfs: hold buffer across unpin and potential shutdown
processing")
but I am not sure if all the conditions in this bug match your case.

If you did get hit by this bug, you may consider upgrade to v5.10.135
which has the bug fix.

Thanks,
Amir.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
