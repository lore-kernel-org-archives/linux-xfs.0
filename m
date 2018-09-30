Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45958 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbeI3HDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 03:03:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2FC3329BAB
        for <linux-xfs@vger.kernel.org>; Sun, 30 Sep 2018 00:32:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201287] xfsprogs 4.17 and later can't be built as static
 binaries anymore
Date: Sun, 30 Sep 2018 00:32:59 +0000
Message-ID: <bug-201287-201763-50z0RFMyQI@https.bugzilla.kernel.org/>
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

--- Comment #5 from Andreas K. Hüttel (dilfridge@gentoo.org) ---
With above two commands and the configure call below I can reproduce the
problem with the otherwise unmodified 4.18 tarball.

(Feel free to close anyway if you see fit.)

./configure --prefix=/usr --build=x86_64-pc-linux-gnu
--host=x86_64-pc-linux-gnu --mandir=/usr/share/man --infodir=/usr/share/info
--datadir=/usr/share --sysconfdir=/etc --localstatedir=/var/lib
--docdir=/usr/share/doc/xfsprogs-4.18.0
--htmldir=/usr/share/doc/xfsprogs-4.18.0/html --libdir=/usr/lib64 --disable-lto
--enable-blkid --with-crond-dir=/etc/cron.d
--with-systemd-unit-dir=/lib/systemd/system --disable-libicu --enable-gettext
--disable-readline --disable-editline --enable-static

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
