Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA19CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 18:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiE3S3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 14:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiE3S3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 14:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946F860B89
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 11:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F129B80E9C
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 18:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15CABC341C0
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 18:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653935338;
        bh=NnAB556iHM6t9NtCeluagJAVYfcklym3kauV4fTg7N0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hF09389BfUTdavrHyLJQt3pljra3TtlWu3UgYTvxevXlLTHTNhpGx7qdW1OpCSqrF
         jCZXTyd66zl66MYJlGF5jm7rTplJ/72oul41xB6OtlqjcJK+/jduSHxdtc1/Er7sOj
         Nf+we+D8pzf6wMGhu3iwz2wlPyZVlP1AFPrriOkMv8pCFT7G0A86YeTI9MNhM7pIT3
         V6E99hDkzg1YGoA+Gii0pLF9GXQYlvdO0Oq3bSG4BvZs80Mf4qxoPNiiitWeJT1A67
         d8NXKb6K9FozLZeIY/8Rlf4uqO1/HXkW7jjFRQ6+zXLs1DUCrWp9Ii4oK3nSLC5xF4
         gUQt0qYQhY5qA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 05BB3C05FD4; Mon, 30 May 2022 18:28:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216047] [generic/623 DAX] kernel BUG at
 mm/page_table_check.c:51!
Date:   Mon, 30 May 2022 18:28:57 +0000
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
Message-ID: <bug-216047-201763-V0n1qRQCY1@https.bugzilla.kernel.org/>
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

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
Created attachment 301077
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301077&action=3Dedit
unreproducible kernel config file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
