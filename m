Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Nov 2006 01:35:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAF9ZLaG008733
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 01:35:22 -0800
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56ADAD1D295C
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 01:07:56 -0800 (PST)
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id E298F8C01
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 10:07:53 +0100 (CET)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 14329-04 for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 10:07:50 +0100 (CET)
Received: from groupware.pawisda.de (groupware.intra.frontsite.de [192.168.200.14])
	by mail.pawisda.de (Postfix) with ESMTP id F26DB5882
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 10:07:49 +0100 (CET)
Message-ID: <18773.62.159.242.114.1163581669.squirrel@groupware.pawisda.de>
Date: Wed, 15 Nov 2006 10:07:49 +0100 (CET)
Subject: SLES 9 x86: xfs_force_shutdown
From: "Dan Am" <xfs@lonx.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello ,
this has come up before, I have read up on some threads, esp from Feb this
year and it is probably handled by now. (Is it ?)

Heres the log:
Nov 14 15:31:05 l08arnfs01 kernel: xfs_force_shutdown(dm-0,0x8) called
from line 1091 of file fs/xfs/xfs_trans.c.  Return address =
0xffffffffa01035e8
Nov 14 15:42:55 l08arnfs01 kernel: xfs_force_shutdown(dm-0,0x1) called
from line 353 of file fs/xfs/xfs_rw.c.  Return address =
0xffffffffa01035e8

Novell has not yet patched up from our Kernel Version "2.6.5.7-244", and
in our env., I cannot switch to Vanilla.

Size of device : 1T.  My current mount options are:

/dev/mapper/vg-l0 on /data type xfs (rw,logbufs=8,logbsize=32768,biosize=16)

Can I tweak something here, or elsewhere, so the effects of the bug are
lessened until Novell patches ?

TIA
Best Dan
