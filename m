Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAA7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 23:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiCaXT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238040AbiCaXT0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 19:19:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817A224D994
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 16:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2281E61706
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 23:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78BF4C34113
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 23:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648768657;
        bh=b5A2ejO4adahjSE66Fbtnf7GLBlx7b5GMzGVSKAbqCA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Mij1THwwGPM6OvE2C9pbaZZ08Q5LizUJHqvNxo/RQJatIXo+8x4AmQiHkZuVFOCOK
         bGt+YizjI364i8iIrkkG+aF3/mnSsOTls8ZFceC67RyMTRb8uoxK+OJzh+KUaHCx6v
         IcaoKe22YAyl/3kZVmPFsIgpPt/UpkgUF41f9hKfIzVn+yyG4JmAdTQqRx52TIlcRu
         ugnDNiLwGaROYOjUZ7LuU/Opo66r1c7ygiCegZ7JYcGCR5WcDb+afk2snSzdHPv60m
         a7pkv2egqgnyGl0CsUxK6URQhhnQLM+UYxfk31XxI4ZmmHWMWls8PaYmgWOKYqoMqI
         PP95P7pHcsXaw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5F7ADC05FD6; Thu, 31 Mar 2022 23:17:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215783] kernel NULL pointer dereference and general protection
 fault in fs/xfs/xfs_buf_item_recover.c: xlog_recover_do_reg_buffer() when
 mount a corrupted image
Date:   Thu, 31 Mar 2022 23:17:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215783-201763-vUC9ERs95O@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215783-201763@https.bugzilla.kernel.org/>
References: <bug-215783-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215783

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Fri, Apr 01, 2022 at 08:35:39AM +1100, Dave Chinner wrote:
> On Thu, Mar 31, 2022 at 08:07:08PM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215783
> > - Overview=20
> > kernel NULL pointer dereference and general protection fault in
> > fs/xfs/xfs_buf_item_recover.c:xlog_recover_do_reg_buffer() when mount a
> > corrupted image, sometimes cause kernel hang
> >=20
> > - Reproduce=20
> > tested on kernel 5.17.1, 5.15.32
> >=20
> > $ mkdir mnt
> > $ unzip tmp7.zip
> > $ ./mount.sh xfs 7  ##NULL pointer derefence
> > or
> > $ sudo mount -t xfs tmp7.img mnt ##general protection fault
> >=20
> > - Kernel dump
>=20
> You've now raised 4 bugs that all look very similar and are quite
> possibly all caused by the same corruption vector.
> Please do some triage on the failure to identify the
> source of the corruption that trigger this failure.

Ok, the log has been intentionally corrupted in a way that does not
happen in the real world. i.e.  The iclog header at the tail of the
log has had the CRC zeroed, so CRC checking for media bit corruption
has been intentionally bypassed by the tool that corrupted the log.

The first item is a superblock buffer item, which contains 2
regions; a buf log item and a 384 byte long region containing the
logged superblock data.

However, the buf log item has been screwed with to say that it has 8
regions rather than 2, and so when recovery goes to recovery the
third region that doesn't exist, it falls off the end of the
allocated transaction buffer.

We only ever write iclogs with CRCs in them (except for mkfs when it
writes an unmount record to intialise the log), so bit corruptions
like this will get caught before we even started log recovery in
production systems.

We've got enough issues with actual log recovery bugs that we don't
need to be overloaded by being forced to play whack-a-mole with
malicious corruptions that *will not happen in the real world*
because "security!".

Looking at the crash locations for the other bugs, they are all
going to be the same thing - you've corrupted the vector index in
the log item and so they all fall off the end of the buffer because
the index no longer matches the actual contents of the log item.

vvvv THIS vvvv

> If you are going to run some scripted tool to randomly corrupt the
> filesystem to find failures, then you have an ethical and moral
> responsibility to do some of the work to narrow down and identify
> the cause of the failure, not just throw them at someone to do all
> the work.

^^^^ THIS ^^^^^

Please confirm your other reports have the same root cause and close
them if they are. If not, please point us to the unique corruption
in the log that causes the failure.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
