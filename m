Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 14:39:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1BMcn1j017719
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 14:38:54 -0800
Received: from out4.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC338D60E3B
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 14:39:12 -0800 (PST)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com [66.111.4.28]) by cuda.sgi.com with ESMTP id DjU8Vkwbwieo5hLE for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 14:39:12 -0800 (PST)
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id CF8D390A7A
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 17:39:11 -0500 (EST)
Message-Id: <1202769551.16458.1236311973@webmail.messagingengine.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Subject: Restoring damaged incremental XFS dump?
Date: Mon, 11 Feb 2008 23:39:11 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I wonder whether I should use xfsdump as a replacement for a more
traditional incremental backup solution centered around the TAR archiver
STAR.  The advantage of STAR seems to be that files can also be
recovered even if, for example, the level 0 dump is damaged.  After all,
one is dealing with TAR, a pretty transparent archive format. The
advantage of xfsdump is that it creates true snapshots.

So, what happens when the level 0 dump created with xfsdump becomes
damaged.  Will I still be able to recover some files?  What about files
from >0 dumps?

-- 
Dipl.-Phys. Felix E. Klee
Naunynstr. 2, 76530 Baden-Baden, Germany
Tel.: +49 7221 396961, Fax: +49 7221 396960, Mobile: +49 174 1386060
http://www.linkedin.com/in/feklee
