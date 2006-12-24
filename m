Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Dec 2006 04:01:21 -0800 (PST)
Received: from taiwan.yingternet.net (taiwan.yingternet.net [59.124.122.220])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBOC1Dqw020404
	for <linux-xfs@oss.sgi.com>; Sun, 24 Dec 2006 04:01:14 -0800
Message-ID: <458E643D.3090008@yingternet.com>
Date: Sun, 24 Dec 2006 19:27:57 +0800
From: Ying-Hung Chen <ying@yingternet.com>
MIME-Version: 1.0
Subject: xfs_repair xfsprogs version > 2.8.11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi there,

I found that xfs_repair always returns the following message with the
xfsprogs version > 2.8.11

[root@yroro i586]# xfs_repair /dev/hdb1

fatal error -- status from pthread_attr_setstacksize: 22

from the ChangeLog, seems like there is some internal changes with
threads starting 2.8.11 .. the xfs_repair works for me up to 2.8.11, it
fails to work on 2.8.16 and 2.8.18,

how do I work around this problem?

Thanks,

-Ying
