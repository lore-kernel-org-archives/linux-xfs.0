Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81092C7618A
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Mar 2023 08:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCTIc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 04:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjCTIc4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2023 04:32:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4766413DD1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 01:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB116B80CAA
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 08:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FD31C433A1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 08:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679301172;
        bh=iVIK7z1hl9ukQ6P6YtzD73QgR9R6HP7VfUIZSyBD+y0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lYUR2wo+siN02vud3CF2PXsub9XORbuwvuhBooQUsKLYitYTCahSb4UNPq7yUfFX1
         7Fh0wMknIt6Odi9LbywqiKtRX4GNWZ/+Yr4UjAJxTLd9pQJBBjP2r2QJnmJV7rjLpW
         6Gn/CF5+5OBlkQggtba0jNFjW2BCxNTGZIzBkKfvNeoMEOQ0jdiPnw8IUbb6+drqQK
         9osf2z222X3+oD1N1c84bxvhotfm9BbjA6QWuttu+iDCqWEg8sIjKmXc6IW816IUIc
         bb8ZFngYyEuaQl2ojaV24plUhkEL5NzRN13WkIUz+uZGa25ugmMFd39TMSThhb8XMI
         vS7YgoevPjcxw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5C7B8C43142; Mon, 20 Mar 2023 08:32:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217216] [Syzkaller & bisect] There is BUG: unable to handle
 kernel NULL pointer dereference in xfs_filestream_select_ag in v6.3-rc3
Date:   Mon, 20 Mar 2023 08:32:52 +0000
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
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217216-201763-MCb6h1JmVn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217216-201763@https.bugzilla.kernel.org/>
References: <bug-217216-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217216

--- Comment #1 from xupengfe (pengfei.xu@intel.com) ---
Related community link:
https://lore.kernel.org/linux-xfs/ZBgCH%2F8EguhJkwPI@xpf.sh.intel.com/T/#u

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
