Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1736CC2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0093361C74
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhF1NI7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233114AbhF1NI6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jun 2021 09:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 05181619AB
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jun 2021 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624885593;
        bh=6CqK1pOlYbf/YzCmyq/XF29JHNh5dHUMSYD72+cLRJA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dRnehBvFhCXHZu8EL6V7Bk9cnJVflLaYdBBm1Y42NS9P6EbI5Tua+xdT/KvOuPI/A
         KFxfmi9j47Y2WIJaz07gsmrzzX2WJBXx1aqphxToF3qRYgFGFwOfUROJ4rN7jkDkXx
         /RoeNNCG02GPUO3HohsJD9EyLQ/DcI8H4rlhX3bXi7MYuLw3fuoznoQIlJIDsXzHbk
         zfFY20HTQcsyAKzvmV5e4lVU9quVjXoWGY4pSbso3q+LXmyWM+FWGbSKK7vLUMSbjX
         SRp539oda8KMVO4USZJlXwlaH6tf3qcet2Tm6kgQMAfJB3f9GqkWhZwXqxhYAHspaa
         s+6bF4zmBCyug==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213609] [xfstests xfs/503] testing always hang on 64k directory
 size xfs
Date:   Mon, 28 Jun 2021 13:06:32 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-213609-201763-eofscAQvTX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213609-201763@https.bugzilla.kernel.org/>
References: <bug-213609-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213609

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Created attachment 297643
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D297643&action=3Dedit
console log of xfs/503

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
