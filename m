Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Feb 2008 17:07:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1S17Xug011165
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 17:07:41 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA07020 for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 12:08:00 +1100
Date: Thu, 28 Feb 2008 12:09:00 +1100
Subject: [REVIEW] Don't make lazy counters default for mkfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------VG3IvjRXfoqXda1iqLF1my
MIME-Version: 1.0
Message-ID: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------VG3IvjRXfoqXda1iqLF1my
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

Lazy superblock counters was released into mainline in 2.6.23-rc1. Some  
distros are still running an older kernel (2.6.22 for example) and with  
the latest xfsprogs, cannot mount a freshly made filesystem with default  
options.

This patch make lazy counters default back to off now.

Users who have a more recent kernel can easily enable them with mkfs or  
xfs_admin -c1 (in a patch posted out a few days ago which will be in the  
same xfsprogs release as this patch).

Lazy counters will default to on again in xfsprogs 2.10.0 (when CI support  
is released). This should give enough time for distro kernels to catch up.

Barry.
------------VG3IvjRXfoqXda1iqLF1my
Content-Disposition: attachment; filename=default_lazycount_off.patch
Content-Type: text/x-patch; name=default_lazycount_off.patch
Content-Transfer-Encoding: Base64

SW5kZXg6IGNpL3hmc3Byb2dzL21rZnMveGZzX21rZnMuYwo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBjaS5vcmlnL3hmc3Byb2dzL21rZnMveGZzX21r
ZnMuYwkyMDA4LTAyLTI4IDEyOjAyOjU1LjAwMDAwMDAwMCArMTEwMAorKysg
Y2kveGZzcHJvZ3MvbWtmcy94ZnNfbWtmcy5jCTIwMDgtMDItMjggMTI6MDQ6
MTcuMjg4ODA5NzcwICsxMTAwCkBAIC03MzAsNyArNzMwLDcgQEAKIAlub2Rz
ZmxhZyA9IG5vcnNmbGFnID0gMDsKIAlmb3JjZV9vdmVyd3JpdGUgPSAwOwog
CXdvcnN0X2ZyZWVsaXN0ID0gMDsKLQlsYXp5X3NiX2NvdW50ZXJzID0gMTsK
KwlsYXp5X3NiX2NvdW50ZXJzID0gMDsKIAliemVybygmZnN4LCBzaXplb2Yo
ZnN4KSk7CiAKIAliemVybygmeGksIHNpemVvZih4aSkpOwo=

------------VG3IvjRXfoqXda1iqLF1my--
