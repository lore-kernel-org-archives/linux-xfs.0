Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Nov 2008 21:54:00 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA65rjxs012583
	for <xfs@oss.sgi.com>; Wed, 5 Nov 2008 21:53:47 -0800
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 80F2E9088A
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2008 21:53:45 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA03020 for <xfs@oss.sgi.com>; Thu, 6 Nov 2008 16:53:42 +1100
Subject: TAKE 052 - keep Eric happy :-)
Message-Id: <20081106055342.4C19958AE1F3@chook.melbourne.sgi.com>
Date: Thu,  6 Nov 2008 16:53:42 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Long devicenames cause this quota output to split onto 2 lines:

# xfs_quota -c "quota -gpu -birnN 99" /mnt/scratch
/dev/mapper/testvol-test2
                           880       1004       1004   00 [--------]           1         10         10   00 [--------]           0          0          0   00 [--------] /mnt/scratch

but if we make that "\n" go away, the test still passes.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Nov  6 16:52:39 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32444a
xfstests/052 - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/052.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Long devicenames cause this quota output to split onto 2 lines:
	  # xfs_quota -c "quota -gpu -birnN 99" /mnt/scratch
	  /dev/mapper/testvol-test2
	  880       1004       1004   00 [--------]           1         10         10   00 [--------]           0          0          0   00 [--------] /mnt/scratch
	  but if we make that "\n" go away, the test still passes.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
