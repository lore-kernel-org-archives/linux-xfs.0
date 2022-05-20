Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65E1C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 20:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbiETUrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 16:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbiETUrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 16:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D41197F4A
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 13:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17B4761D15
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 20:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EB9FC34116
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653079619;
        bh=LdOBlWQA/M1yE1m3egIlMIRlRjgaVDjayNNfOqdERcE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lrc+cMy1iprfyu7xI5ugetqGDtDExWhhxdv3Y/pvVnD7eJ8iEmzt9pM4qTiPBJEYs
         SY8paBgdRGoW4w+LE4D3NPKK9EBfpOwhZUNV2xuOrR4ZOS2oAIisGf1T/5+qjsiQVf
         VAfgpBwG4N6EgpGc0z030kM0ZAnk/sfGdVWHVockP+cIaaOFRKwymT8vTYRkaNax5f
         fpqQkV4QuyUAlk1tSt00WguZJU2pse0EIyhJjv55JwMJnGGC7cgGvDcGncvNdB9NJr
         gAkYmiC2yGs/PVe7jPz+IclUJp+8jCG+I7PZEy7dmYlQtI1HEA5DjUkmLmr8Im6Dl8
         7tdMOzEQzx0Kw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5E3FFC05FD4; Fri, 20 May 2022 20:46:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Fri, 20 May 2022 20:46:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzilla@colorremedies.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216007-201763-MIBIEBSBT6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

Chris Murphy (bugzilla@colorremedies.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla@colorremedies.com

--- Comment #2 from Chris Murphy (bugzilla@colorremedies.com) ---
Please see
https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
and supplement the bug report with the missing information. Thanks.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
