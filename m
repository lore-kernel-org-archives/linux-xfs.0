Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EDEC001B0
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 18:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjHISbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 14:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjHISbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 14:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE04A3
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 11:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC8F643EA
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 18:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D538C433CD
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691605862;
        bh=bukJfTLpPUeLg6GmnCg/SuIpofbsj9YObhzAUuXefFY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CaG7LZAEebwbyektvyNquraw+cJLUPIPc08Ao5UAVM5Ke9I7n0Dn4zGb3CMPa4qrF
         v9f11GErtMl5FG1/le+RLg68Oa59hmYUDdtbEBUyFSYfEBfksOzNoqSr/gfSv3dgR1
         VowIJJXLltXtzKgJNrVuNz6bSMkejDWQ+MlppYy1Luo7Y0Qit7+J0X9guorwQn9ggU
         TVbq0ZNPVPme+YCNFiTEi8/by2CKO9VOalTLssdpA6mSlBZdzcPzWDrGQN48oGDbvq
         MsUlrbuFHmDUBQoiNmKS7gjt4HbwktaH8WCt4fLRvCIsOfPBK0twA4iGuedRSJtd5B
         UwfdESaA5HlIA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3ACE1C53BD0; Wed,  9 Aug 2023 18:31:02 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Wed, 09 Aug 2023 18:31:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xani666@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-WBZZJW01Qj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217769-201763@https.bugzilla.kernel.org/>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

--- Comment #14 from Mariusz Gronczewski (xani666@gmail.com) ---
Nope and I've seen same problem on bare metal

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
