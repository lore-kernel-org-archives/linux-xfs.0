Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D383ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Sep 2022 14:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiIEO3b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 10:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbiIEO30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Sep 2022 10:29:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670975A880
        for <linux-xfs@vger.kernel.org>; Mon,  5 Sep 2022 07:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09AF2612AB
        for <linux-xfs@vger.kernel.org>; Mon,  5 Sep 2022 14:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C65AC4347C
        for <linux-xfs@vger.kernel.org>; Mon,  5 Sep 2022 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662388158;
        bh=REehZA7jESZG5hYkE0bHtxT+v68vEkxIkr7jpdbEFKk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AjULW/QRT/k6Cw4T3U6Gy054h6Z60WPBjki6F2uzY3+o1W+T056GVoOuRNPHL0qNu
         Sv81pRxSFwo6DD1MEjjNTx/N/MEhujSOgBZeWcAv3Dd4NsoeCSyzWWPsPlyfrdWOky
         uQU1rZjX9fQCkVdlAg3aDS4YaV2vCETCEoHJWwaJd9g3AO8LhqZ3UkwMc0yPXHeKI0
         oTMDgTXoCDl/u0HISeaYHA8ndfrNLWn9poyYCytdRCehCKKqE0xWnHfXpQviUkZScf
         UEsGgEF/YOF/qilZ+WP6UGLMeyXm0KIp+ELovKZN8WqI7NJ9wefubmbKfQ2StocxCu
         W6WbFyflmNvNA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4B1DCC433E4; Mon,  5 Sep 2022 14:29:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205833] fsfreeze blocks close(fd) on xfs sometimes
Date:   Mon, 05 Sep 2022 14:29:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel.org@estada.ch
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205833-201763-YqF3KnFU5o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205833-201763@https.bugzilla.kernel.org/>
References: <bug-205833-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D205833

--- Comment #4 from Stefan @dns2utf8 Schindler (kernel.org@estada.ch) ---
Has the fix been merged?

On the latest Arch Linux I am no longer able to reproduce the error where t=
he
second process hangs.

My test files & programs are here:

* Quick test: https://gitlab.com/dns2utf8/xfs_fsfreeze_test/
* Heavy load: https://gitlab.com/dns2utf8/multi_file_writer/

Best,
Stefan

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
