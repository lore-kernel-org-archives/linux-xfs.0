Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 15:49:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OMn24H032697
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 15:49:04 -0700
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B320E84B6
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 15:49:42 -0700 (PDT)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by cuda.sgi.com with ESMTP id BZ3oH6VuHWGH8lcR for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 15:49:42 -0700 (PDT)
Received: from chello089076023161.chello.pl ([89.76.23.161]:1545 helo=[192.168.0.124])
	by main.carme.maven.pl with esmtpa (Exim 4.69)
	(envelope-from <arekm@maven.pl>)
	id 1JpAAj-0006zo-Dc
	for xfs@oss.sgi.com; Fri, 25 Apr 2008 00:44:09 +0200
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: xfs_quota report
Date: Fri, 25 Apr 2008 00:49:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Disposition: inline
Message-Id: <200804250049.34740.arekm@maven.pl>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

xfs_quota -x -c "report" by default walks passwd and displays quota only for 
users found there.

I wonder if there is a better way to get information about uid/gids that have 
any files on xfs filesystem? So report command could be enhanced to display 
such "users", too. 

Right now the only option is to use report -L0 -Usome_very_high_number with a 
hope that the number will always be high enough.
-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
