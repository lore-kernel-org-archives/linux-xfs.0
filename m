Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jan 2008 18:01:14 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0720lTW006272
	for <xfs@oss.sgi.com>; Sun, 6 Jan 2008 18:00:48 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFA76C07706
	for <xfs@oss.sgi.com>; Sun,  6 Jan 2008 18:01:01 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.170]) by cuda.sgi.com with ESMTP id oMqXXgfVoTXTNVCD for <xfs@oss.sgi.com>; Sun, 06 Jan 2008 18:01:01 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so3456208ugd.20
        for <xfs@oss.sgi.com>; Sun, 06 Jan 2008 18:01:00 -0800 (PST)
Message-ID: <96c268400801061801i62853e5xdda1b93cc864dda5@mail.gmail.com>
Date: Mon, 7 Jan 2008 05:01:00 +0300
From: "Maxim Gordienko" <mgordienko@gmail.com>
Subject: xfs_repair core dump
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello!

I'm trying to repair damaged xfs partition, but xfs_repair crashes
with core dump
distribution is fully updated ubuntu 7.10, xfsprogs are 2.9.0.
Have tried xfs_repair from other dists like knoppix or gparted livecd,
compiled from source last stable (2.9.4-1)
same result. Could you please help? Thank you.

Phase 5 - rebuild AG headers and trees...
*** glibc detected *** xfs_repair: munmap_chunk(): invalid pointer:
0xb514d008 ***
======= Backtrace: =========
/lib/tls/i686/cmov/libc.so.6(cfree+0x1bb)[0xb7ead92b]
xfs_repair[0x8062d9a]
xfs_repair[0x806c896]
xfs_repair[0x8080515]
/lib/tls/i686/cmov/libpthread.so.0[0xb7f9846b]
/lib/tls/i686/cmov/libc.so.6(clone+0x5e)[0xb7f136de]
