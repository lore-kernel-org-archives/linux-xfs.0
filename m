Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45846 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbeI3G6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 02:58:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CD637294D3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Sep 2018 00:28:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201287] xfsprogs 4.17 and later can't be built as static
 binaries anymore
Date: Sun, 30 Sep 2018 00:28:15 +0000
Message-ID: <bug-201287-201763-Obv8PT9Df5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201287-201763@https.bugzilla.kernel.org/>
References: <bug-201287-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201287

--- Comment #4 from Andreas K. Hüttel (dilfridge@gentoo.org) ---
(In reply to Andreas K. Hüttel from comment #3)
> Ugh. I can't reproduce the final link failure with the unmodified release
> tarball. So that part is likely our problem, sorry for the noise.
> 
> [We sed LLDFLAGS += -all-static into the Makefiles.]

(More precisely, simplified from the "ebuild":

sed -i -e "1iLLDFLAGS += -all-static" include/builddefs.in
find -name Makefile -exec sed -i -r -e '/^LLDFLAGS [+]?=
-static(-libtool-libs)?$/d' {} +

)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
