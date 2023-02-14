Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C4DC636CC
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 01:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjBNBXF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Feb 2023 20:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjBNBXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2023 20:23:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3C413D5B
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 17:23:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAB75B81A31
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 01:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 960E5C4339E
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676337781;
        bh=6b54oIQx1fhP1kJo4Lub75QKiXBbITUKdah/mAHecnQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OYCth53oYBBJdEfBT6znPf2JrgeTdPbvdfQyEKm/0rtkImvSKuNCMTMRUI1dhfx2T
         2rJmmRJHM3+OwHRaawhf7bIRtEYCy/fL5Hp0kKb6RVSge8Z2lHx0GswAanRWmUi3sJ
         rchrrIIZBtT6IFA6kgxW3kOrkm1Xy8VrEz/NojAxJBliLcviSmMsbjc9wxRn7ecklh
         gjB4hXyPPgi/tI2YpOkH5QsNe585oorxgVrIfA3bfUBmaCI7S1R1ypKdZCewN4Ra7K
         1Hv8KiWb++tdHHPf09DvgT2NfEWkXD/ljykydW3VofnISkG0WCAya5wFOL893vCNIM
         sj5PgYlZOypQw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 81B94C2BCF6; Tue, 14 Feb 2023 01:23:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217030] [Syzkaller & bisect] There is
 "xfs_bmapi_convert_delalloc" WARNING in v6.2-rc7 kernel
Date:   Tue, 14 Feb 2023 01:23:01 +0000
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
Message-ID: <bug-217030-201763-emRBCzMAW1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217030-201763@https.bugzilla.kernel.org/>
References: <bug-217030-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217030

--- Comment #2 from xupengfe (pengfei.xu@intel.com) ---
Hi Dave,

Thanks a lot for your comments!
I just used bisect scripts to find the above commit. And I reverted the com=
mit
and the issue was gone.

Maybe it's not accurate for the root cause.

Your comments could give more clue for the problem solving.

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
