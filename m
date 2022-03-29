Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EEEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiC2KDH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiC2KDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 06:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A44C7BE
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 03:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 841BE61180
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 10:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9003C34111
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 10:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648548074;
        bh=ooJnT9JsJzAq1LTVCoNJAEU0UzJFvd4UpftWlR3r/bk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oe4ZnAcsz1AozEYyjZiM4o3BKwh63CJp4gbjOeu21wWsk7ggIkIqwB5I4zq6PQOqE
         k3ScC2yGgl2YBDY7DHwyzzu2RvZBIqmfW/krElllPum97Ww28t0sSI87k9M9j2I9yS
         G+Y3oL+rCR+OgTN3Zng9FKEPmVWGpEc2D76GXsSqSWSW2i+gs7QM3JxeHKKcfDptv4
         zq7ZZM5cmY/XVyTDJv8siZggr9omLKYWOqjWBhRH2a2wzSvoechxy+XdiC4YfO+KX3
         6N1yX0axwDBpLXKJW6fd0ZiBP0PrLV0TKHSY7HVhdF8EqoWuxNb9ad4kBHWmJf9UaY
         GHvmZpzBCazWw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D5950C05F98; Tue, 29 Mar 2022 10:01:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215693] [xfstests generic/673] file on XFS lose its sgid bit
 after reflink, if there's only sgid bit
Date:   Tue, 29 Mar 2022 10:01:14 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215693-201763-ODkyHNZs99@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215693-201763@https.bugzilla.kernel.org/>
References: <bug-215693-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215693

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to The Linux kernel's regression tracker (Thorsten Leemhuis) from
comment #1)
> Is this issue still happening? was it also discussed any maybe solved
> already, like the other bug you mentioned? or should I poke the developers
> to get things moving?

Please refer to:
https://bugzilla.kernel.org/show_bug.cgi?id=3D215687#c4

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
