Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C9C001B0
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 20:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjHGUPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 16:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjHGUPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 16:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B41C10CF
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 13:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4176621F2
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 20:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E8F1C43391
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 20:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691439312;
        bh=CB3FEO25ybrvVLmvF4/2SNeJJBl/rqwTCQi5VvHP4V0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dP9iFWLi7JZuKJc5E9qliKiYRb3xr+cemJicbEVSEyG/MUWUEVB21+VyK0Uk60QJ4
         Qx+jRrBQ+dVuPuvJDmlFzEoK8gOTplB5GMTG9sPBUMdpfRir37J6XYFy8mrt8dE+3k
         HWo7uRbNK1r2G71TQ96SWP79PFQo9cVlQSaSYnTfodBl0Hd3sO7r+smU1He3+K++hD
         bFx6gsG0OyyATezo4Cd6IQnV4SRWaXwthP0EB/Zl68biXoWiLBP2D6t7+79EGHG5JT
         vVxJUhkQv3t91/oeq9vWhHn7luPyObDkDtSVgSS1GcnUacQXDBJC1UsyfIN1CWMSD4
         e9cI/6SvfRXJw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2F350C53BD0; Mon,  7 Aug 2023 20:15:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 20:15:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217769-201763-cJBSFqacBX@https.bugzilla.kernel.org/>
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

--- Comment #5 from Eric Sandeen (sandeen@sandeen.net) ---
Ok thanks, the other instance I recently saw of this problem likely also
started on a rather old kernel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
