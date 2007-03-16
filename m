Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 20:25:48 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2G3Pg6p005632
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 20:25:43 -0700
Subject: xfsdump buglets
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: text/plain
Date: Fri, 16 Mar 2007 14:25:36 +1100
Message-Id: <1174015536.5051.193.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

Hey Bill,

Got a couple of minor xfsdump problems reported to me, they're probably
straightforward for someone who knows xfsdump well - here ya go...

cheers.

-------- Forwarded Message --------
From: Peter Chubb <peterc@gelato.unsw.edu.au>
Reply-To: Peter Chubb <peterc@gelato.unsw.edu.au>,
415080@bugs.debian.org
To: submit@bugs.debian.org
Subject: Bug#415080: Poor error message from xfsdump for incorrect args
Date: Fri, 16 Mar 2007 09:47:50 +1100

Package: xfsdump
Version: 2.2.38-1 

I do:
	xfsdump -l 0 -p -f afile filesystem
and get
	xfsdump: ERROR: -^@ argument missing
because -p needs a numeric argument.

The message should say -p argument missing.
--
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia


------- Forwarded Message --------
From: Peter Chubb <peterc@gelato.unsw.edu.au>
Reply-To: Peter Chubb <peterc@gelato.unsw.edu.au>,
415081@bugs.debian.org
To: submit@bugs.debian.org
Subject: Bug#415081: xfsdump doesn't accept relative pathnames to
mountpoints
Date: Fri, 16 Mar 2007 09:54:52 +1100

Package: xfsdump
Version: 2.2.38-1

I have a filesystem mounted at /export.

I do:
	cd /
	xfsdump -l 0 -f /path/to/file export
and see
xfsdump: ERROR: export does not identify a file system

	xfsdump -l 0 -f /path/to/file /export 

works.
--
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia


-- 
Nathan
