Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3466CC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 15:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbiE3Pwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 11:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242046AbiE3PvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 11:51:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399FC67D12
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 08:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6D1B80DC0
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 15:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C1D4C341C4
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653923919;
        bh=+GPbZ6P0p6r1mpFOViN6031mGGAuYx1SLfAR5qV6HMg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gj+eACdi0hP4IAboN8a27EAgcNlY1uggVQT3REG7Y5M1WspzZK+mwDFjmCSml3kBZ
         QBBWMC1PzhUCZVZLiEnlirDhVvVveyc6+hM5j1xdDlnZRmzciUxhIQ6TIxFGd0hhJ7
         fXyud1T4f3UHazg49rr51p+eylMyndIm2N2lnpFSg3NwhAu/oGPmm2DurkTE1eVnex
         llXR/mcZ+TFJcmqdVlkaO2WMQXAWOyqlgMqN++NQei11Fb5KJEVlf1RZtex8yQeXMC
         CcK6s5ZBISGNdFhjM14sJa4nZi1HfKrHjofARKznnCzw7Rqu9vklHEPIsizgBvzlZM
         kQ8J+Py9Gm24g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02C1ACC13B6; Mon, 30 May 2022 15:18:39 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216047] [generic/623 DAX] kernel BUG at
 mm/page_table_check.c:51!
Date:   Mon, 30 May 2022 15:18:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
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
Message-ID: <bug-216047-201763-EEAO3NN6cW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216047-201763@https.bugzilla.kernel.org/>
References: <bug-216047-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216047

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
Created attachment 301076
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301076&action=3Dedit
kernel config file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
