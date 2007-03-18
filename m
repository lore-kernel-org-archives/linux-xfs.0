Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Mar 2007 14:23:05 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2ILMx6p003167
	for <xfs@oss.sgi.com>; Sun, 18 Mar 2007 14:23:01 -0700
Subject: But wait, theres more... [Fwd: Bug#415123: -R option can't append
	to a plain file]
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: text/plain
Date: Mon, 19 Mar 2007 08:23:13 +1100
Message-Id: <1174252993.5051.233.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

And a free set of steak knives if you fix this bug...  ;-)

-------- Forwarded Message --------
From: Peter Chubb <peterc@gelato.unsw.edu.au>
Reply-To: Peter Chubb <peterc@gelato.unsw.edu.au>,
415123@bugs.debian.org
To: submit@bugs.debian.org
Subject: Bug#415123: -R option can't append to a plain file
Date: Fri, 16 Mar 2007 19:54:37 +1100

Package: xfsdump
Version: 2.2.38-1

If I use xfsdump to dump to a plain file, interrupt it, then restart
with the -R option, xfsdump complains:

xfsdump: ERROR: media contains valid xfsdump but does not support append

which is misleading: of *course* you can append to a regular file if
there's space on the filesystem.

--
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia

-- 
Nathan
