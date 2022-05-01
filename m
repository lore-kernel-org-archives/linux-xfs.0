Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7A1C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  1 May 2022 07:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240273AbiEAHNK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 May 2022 03:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiEAHNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 May 2022 03:13:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EED186C4
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 00:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05796611CD
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 07:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61736C385B4
        for <linux-xfs@vger.kernel.org>; Sun,  1 May 2022 07:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651388984;
        bh=Ff6scVMJz33htB6btC5FkBHcfc7aO6Wkz61mvR1Q1ZI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ktZzX9csBvfB8KZoP3H3R+wCds2UL4eAlewAGp0TUE2SHDcH27o3vltQehVda+1J5
         PMJfKbaa0TfrizQh2X8T0MZ9uu2gUEDZAAXbEwPxYHb+iJGH1zuwIoLlM5XHz3qqUD
         DFUl2FHpVpEUULVEueOiC8AGgbT1hekkEDagn0XQAXN1TbC29U2uZ11iU9K74ApqIh
         YS/Juh4rzvMVxj4mcAxDOBmkipLzXrc4isl67uq90k5Do+VMu7TRfA6lzITC7ARC/6
         VDHKpRU8XWwM5ivGPXvHcj42DQWPsxG3GcjxbWHZ1ZYRtUbh9CIjcSX9Dk7cMgiXiE
         tYvPiID3FN0NQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 41A4ACC13B2; Sun,  1 May 2022 07:09:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215927] kernel deadlock when mounting the image
Date:   Sun, 01 May 2022 07:09:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215927-201763-AGpJPXDFVY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215927-201763@https.bugzilla.kernel.org/>
References: <bug-215927-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215927

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
Created attachment 300862
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300862&action=3Dedit
Filesystem image

Confirming.

[   74.606226] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [mount:677]
[  101.997591] watchdog: BUG: soft lockup - CPU#1 stuck for 51s! [mount:677]
[  129.388962] watchdog: BUG: soft lockup - CPU#1 stuck for 77s! [mount:677]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
