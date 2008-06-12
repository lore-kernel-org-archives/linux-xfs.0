Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 10:08:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5CH8DU1006716
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 10:08:14 -0700
Received: from smtp3.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEF6421F065
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 10:09:06 -0700 (PDT)
Received: from smtp3.poczta.onet.pl (smtp3.poczta.onet.pl [213.180.130.29]) by cuda.sgi.com with ESMTP id 5cDj4ExCN99Yj3FA for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 10:09:06 -0700 (PDT)
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:34410 "EHLO
	orion.wszechswiat.org" rhost-flags-OK-OK-OK-FAIL) by ps3.test.onet.pl
	with ESMTPSA id S184555754AbYFLRJD4bzAh (ORCPT
	<rfc822;xfs@oss.sgi.com>); Thu, 12 Jun 2008 19:09:03 +0200
Message-ID: <485157D2.5050906@op.pl>
Date: Thu, 12 Jun 2008 19:07:30 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: Does XFS support sharing blocks?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

  Hello.

  I have a question: does the XFS filesystem support sharing blocks 
between objects (files, symlinks, fifos, ...). I mean, can 2 distinct 
objects have their data inside one physical block? If not, what is the 
"offset" field for in xfs_db output:

xfs_db> inode 19331
xfs_db> bmap -d
data offset 0 startblock 1212 (0/1212) count 1 flag 0

-- 
Pozdrawiam/Regards - Bogdan                     (GNU/Linux & FreeDOS)
Kurs asemblera x86 (DOS, GNU/Linux):http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
www.JabberPL.org www.TorProject.org Soft (EN): miniurl.pl/bogdro-soft
