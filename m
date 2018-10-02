Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53258 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbeJBXV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 19:21:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6638E284C0
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 16:37:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Tue, 02 Oct 2018 16:37:14 +0000
Message-ID: <bug-201259-201763-SMSx0idCb1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201259-201763@https.bugzilla.kernel.org/>
References: <bug-201259-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201259

--- Comment #5 from Eric Sandeen (sandeen@sandeen.net) ---
Even simpler, 

xfs_io -f -c "pwrite -S 0x72 0 4096" $DONOR1

xfs_io -f \
        -c "falloc -k 8192 4096"        \
        -c "pwrite -S 0x57 65536 8192" \
        -c "fdatasync" \
        -c "reflink $DONOR1 0 131072 4096" \
                $TARGET

so this seems to be an extending reflink extending past/into speculative
preallocation which exposes the stale blocks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
