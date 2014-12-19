Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7371A7F3F
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 02:57:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 613A030407B
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 00:57:44 -0800 (PST)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
	[209.85.215.44]) by cuda.sgi.com with ESMTP id 9xmi2xVZY5PSbJpl
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Dec 2014 00:57:43 -0800 (PST)
Received: by mail-la0-f44.google.com with SMTP id gd6so466821lab.3
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 00:57:42 -0800 (PST)
Received: from localhost ([80.203.33.141])
	by mx.google.com with ESMTPSA id fb6sm2525177lbc.46.2014.12.19.00.57.40
	for <xfs@oss.sgi.com> (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
	Fri, 19 Dec 2014 00:57:41 -0800 (PST)
Date: Fri, 19 Dec 2014 09:57:38 +0100
From: Stevie Trujillo <stevie.trujillo@gmail.com>
Subject: xfsdump questions
Message-ID: <20141219095738.6b6e6c88@localhost>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello!

Is xfsdump an ancient relic or something recommended to new users (I
have never seen anyone recommending it)? I gave it a try and found the
incremental backups to be really fast!

How are incremental backups implemented? I saw that my inventory file
is really small. Does it use some internal xfs metadata to detect
changes? Is it resilient against all kinda renames and changing
timestamps etc that a user might do? (I've previously used a backup
system that broke when doing stuff like that)

Is it possible to backup (and restore) ctimes?

I read that the incremental backups are limited to a depth of 10. Are
they intended to be used in a binary tree like fashion?

--
Stevie Trujillo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
