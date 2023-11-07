Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A7EC4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 10:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjKGK0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 05:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjKGK0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 05:26:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485D5F7
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 02:26:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6A30C4339A
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 10:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699352759;
        bh=vcBcWTiNY/SXCwOx25LrBpJl+XUpjw2QJBE+HEH3wWk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=k3wyDDA8qK8D7OTz6UBYSfc/h+k21nwIHdgMZpaOvRv8o2ASfZthnWxKRNAPnvH5k
         2F0uuZM7Pqf5uA8d/JVGTtlbCwFR9SuZYX/WfT7tDuy/SazKQvDedJLC0HLKa5QTWm
         xXNKAwjos9ulZFuibq0IlN4YYfvBKrmhpikZFQ3ab3P6pyx9kIVeIL8ZTU+gGAVTdJ
         ao9YHoK+6Nmcx2KAaxjKtb41GP2BfN93nH07bItkI62QnLM7ec/B+1rsMzVn2Tmeyt
         h9I30HVfWt3e0R5sbUckWOIJGIAxZbeYRLvZuM5l/gwcQPs3v2RBzEbGAxuT+mb3q6
         LwKQcCh2x6WDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D6E4BC53BD0; Tue,  7 Nov 2023 10:25:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 07 Nov 2023 10:25:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@nmitconsulting.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-H5AeazZTqF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #24 from KN (kernel@nmitconsulting.co.uk) ---
Long time lurker here offering a potential workaround.


We experienced near identical kernel issues as mentioned here with a comple=
tely
different setup. We saw the issue on our OKD cluster (4.12 and 4.13) runnin=
g on
Fedora CoreOS (37 and 38). We had ~70 nodes with a specific workload profil=
e,
and of these, anywhere between 1 and 5 would run into this issue each night=
 on
our production cluster. These nodes were very IO intensive (druid
middlemanager/ingest nodes) but not database related. The persistent volumes
that were contributing the majority of the disk IO were configured as xfs. =
We
tried for weeks to reproduce this error but could not.

Whilst we have to accept this is a kernel bug and not an xfs bug, we *resol=
ved*
our issues by switching from xfs to ext4. Haven't had a single instance of =
this
error since we migrated our persistent volumes away from xfs.=20

3 weeks and counting and not a single failure.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
