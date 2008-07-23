Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:49:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N7nNn0012591
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:49:26 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA07929 for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 17:50:33 +1000
Date: Wed, 23 Jul 2008 17:52:24 +1000
Subject: Syncing up libxfs to kernel source
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ueqitmgv3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This one is mainly for Dave...

In xfs_alloc_read_agf() in xfs_alloc.c, the current user-space version
checks:

agf_ok = ...
	be32_to_cpu(agf->agf_btreeblks) <= be32_to_cpu(agf->agf_length) &&
	...

but the kernel version doesn't.

Is this an oversight with the lazy-counter code in the kernel, remove from
user-space or leave them different?
