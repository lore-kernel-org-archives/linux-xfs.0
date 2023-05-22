Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F425C77B73
	for <linux-xfs@archiver.kernel.org>; Mon, 22 May 2023 02:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjEVCLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 May 2023 22:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjEVCLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2023 22:11:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273BAB7
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2023 19:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F0E661946
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 02:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3892C433A4
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 02:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684721500;
        bh=kbaOx7e5aZz3g5PI3rBso2pF+Nb4cJzeMqA1V/GIlm8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lr3yX9GoOD7Wzfacttz2q5tg0xZEgJif5mMjYZnAVpsCuC/5o0SKg5/tEHmsk9Dh5
         lTUAyqO+nxno+h9yASQxma10yvMEyu0wgnfkeB7moWu+J8B4nzgVwtYKBV38E6g2EQ
         qQcWT/aRv5G9fU+ovNbdVMJ7FafrDOYkTcOjHJUS33tXEaEU/+IDr8eR0gBTYQjpzg
         vkFMpdVaKHUF1HtAzLkhro2uGfPYOzGW6hva6BY0kDsXLbsLgSHF1tkkmjPIdi2hrT
         dghVQhK8SQyO2ErhOtUIuhe/79eBpKxWK5OhhRgRJWjjgdc+N7FpCA8eEYWbxKa5Yk
         /nkMQXlCbUEyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D550BC43144; Mon, 22 May 2023 02:11:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217470] [Syzkaller & bisect] There is BUG: unable to handle
 kernel NULL pointer dereference in xfs_extent_free_diff_items in v6.4-rc3
Date:   Mon, 22 May 2023 02:11:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217470-201763-eXp6GwLlpr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217470-201763@https.bugzilla.kernel.org/>
References: <bug-217470-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217470

--- Comment #1 from xupengfe (pengfei.xu@intel.com) ---
Here is the xfs Linux kernel community link:
https://lore.kernel.org/linux-xfs/ZGrOYDZf+k0i4jyM@xpf.sh.intel.com/T/#u

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
