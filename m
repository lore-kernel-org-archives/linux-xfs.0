Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 12:04:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8EJ41TM024204
	for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 12:04:03 -0700
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4258E126F1FC
	for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 12:05:09 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com with ESMTP id 041rITAALUqTtTbo for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 12:05:09 -0700 (PDT)
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kewu6-0003Lf-QD
	for linux-xfs@oss.sgi.com; Sun, 14 Sep 2008 19:05:02 +0000
Received: from 78-21-61-244.access.telenet.be ([78.21.61.244])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:05:02 +0000
Received: from fhimpe by 78-21-61-244.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 19:05:02 +0000
From: Frederik Himpe <fhimpe@telenet.be>
Subject: XFS does not recognise mount options in 2.6.27-rc6
Date: Sun, 14 Sep 2008 18:53:21 +0000 (UTC)
Message-ID: <pan.2008.09.14.18.53.20@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
others. Because of this, at boot time it fails to mount the partitions rw, 
making the system unusable.

Some time ago, it seems a patch was about to be committed, but apparently 
this has not been done yet:
http://lkml.org/lkml/2008/8/14/340

What's the status of this now?

-- 
Frederik Himpe
