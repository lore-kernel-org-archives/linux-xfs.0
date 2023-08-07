Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE95DC001DB
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 22:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjHGWeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 18:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjHGWeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 18:34:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F36EC
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 15:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9E6622D5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 22:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E294C433D9
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691447661;
        bh=XvtAamAZTv2IQSP/Z4dDQKkjxNM9lFxYMEVwQxMCSak=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=szm6M8Dd6sbjA3Ozwi5d3i45wu6B4zEtoED2XB+vg9HYyu+bclKuvd9BmLxwCzAWt
         ulAMG6NUFfgao8l3bSKsVEN4X0lO5Mudn9K1JAKOvEj8ZFbUoGKOreeSqi1nISiLhb
         GBi8YUC3Ep6GqOA0oHMqGPjt9c2CtyMKEE5dZsEt0nAYMGPmFOCyc/FiFZhBFPnHkk
         6bzLLR6CX0i9TDDuGUDJGvEYFNvd+e4EGHeyE/ycSzcCjAxbi8837gNgee5nbfkb11
         hB4hXlPxBYokULjjwefx0RtWeda+6xQazukcgpKvU5uDIRr+i7GXfacaQ7gq7S6Gjm
         InOX7YH28/H/g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4D237C53BD0; Mon,  7 Aug 2023 22:34:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 22:34:20 +0000
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
Message-ID: <bug-217769-201763-HMT9396NVV@https.bugzilla.kernel.org/>
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

--- Comment #6 from Mariusz Gronczewski (xani666@gmail.com) ---
I still have image of that VM with the problem if you want me to check
something on it

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
