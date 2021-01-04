Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D3DC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D719C21919
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADTes convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADTes (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jan 2021 14:34:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B479022209
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 19:34:07 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210723] [Bug report] overlayfs over xfs whiteout operation may
 cause deadlock
Date:   Mon, 04 Jan 2021 19:34:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bfoster@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210723-201763-4hRnQHA4VI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210723-201763@https.bugzilla.kernel.org/>
References: <bug-210723-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210723

--- Comment #2 from bfoster@redhat.com ---
On Mon, Jan 04, 2021 at 03:09:23PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210723
> 
> --- Comment #1 from Dave (chiluk@ubuntu.com) ---
> Has there been any progress on this?  We've been regularly hitting what
> appears
> to be an xfs deadlock on 5.8, 5.9, and now 5.10 on our kubernetes nodes that
> also employ containers and overlayfs.  I haven't been able to do as much
> digging as wenli yet so I don't have any more detailed information.
> 

For whatever reason this bug report has not been synced between bugzilla
and the mailing list. I don't see the initial report on the list at all
and the subsequent replies to the initial thread appear on the list and
not in the bz.

In any event, I believe Darrick root caused and Wenli confirmed a fix
here:

https://lore.kernel.org/linux-xfs/20201217211117.GF38809@magnolia/

... which presumably just needs to be posted/reviewed as a proper patch.

Brian

> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
