Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from st42p63im-zteg05201801.me.com ([17.36.66.145]:53767 "EHLO
        st42p63im-zteg05201801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751230AbdFEDOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2017 23:14:18 -0400
Received: from process-dkim-sign-daemon.st42p63im-zteg05201801.me.com by
 st42p63im-zteg05201801.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OR100400X6OTR00@st42p63im-zteg05201801.me.com> for
 linux-xfs@vger.kernel.org; Mon, 05 Jun 2017 02:14:16 +0000 (GMT)
Received: from icloud.com ([127.0.0.1]) by st42p63im-zteg05201801.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 with ESMTPSA id <0OR1005WKY760W00@st42p63im-zteg05201801.me.com> for
 linux-xfs@vger.kernel.org; Mon, 05 Jun 2017 02:14:16 +0000 (GMT)
Subject: bug report: Unexpected file modify
From: Hong Jehn <hongjehn@icloud.com>
Content-type: text/plain; charset=us-ascii
Message-id: <0F7B512B-973A-4651-8DBC-5E39FBF871C2@icloud.com>
Date: Mon, 05 Jun 2017 10:13:52 +0800
Content-transfer-encoding: quoted-printable
MIME-version: 1.0 (1.0)
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I thought it was the diffutils problem, but I sent the below mail to them. T=
hey said that this problem is almost certainly not diffutils fault. So I gue=
ss it leaves to XFS or glibc.
My os is centos 7, the latest update from repository.
------------------------------------
When I use command "diff -qr abc/ usb/abc/" to compare 2 directory,  it chan=
ges the "centos_7_x86_64_Minimal.iso" sometime but the file size didn't chan=
ge even when I just ran the same command and it says they are the same. Othe=
r file are fine, it changes only this iso file.

Also, I wrote a similler program like diff before it came out the same probl=
em. I guess it's a glibc bug? I kept the broken file in case you need it.

This problem comes out like once a week, I kept the sha256-code but this pro=
blem seems serious.
