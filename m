Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D3DC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 19:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D97B23D9A
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 19:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393353AbgLJTSf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 14:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393341AbgLJTSc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Dec 2020 14:18:32 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210577] [xfstests generic/616] kernel BUG at
 lib/list_debug.c:28!
Date:   Thu, 10 Dec 2020 19:17:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: axboe@kernel.dk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210577-201763-2gmW64bVOR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210577-201763@https.bugzilla.kernel.org/>
References: <bug-210577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210577

--- Comment #5 from Jens Axboe (axboe@kernel.dk) ---
On 12/10/20 12:06 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210577
> 
> --- Comment #4 from Zorro Lang (zlang@redhat.com) ---
> (In reply to Jens Axboe from comment #3)
>> What underlying device is being used?
> 
> The underlying device is general disk partition. But they're virtual
> machine(by
> qemu-kvm), I only have VM ppc64le/aarch64.

I mean the actual disk - is it virtioblk? dm over virtioblk? That kind of
thing.

> The kernel is:
> # git clone https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> # git checkout -b for-next origin/for-next

Got it, thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
