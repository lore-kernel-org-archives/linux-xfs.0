Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 13:28:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m96KSkKF020773
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 13:28:47 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 462A29F110B
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2008 13:30:23 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id GDcpjmMFs6CjAlFZ for <xfs@oss.sgi.com>; Mon, 06 Oct 2008 13:30:23 -0700 (PDT)
Date: Mon, 6 Oct 2008 16:30:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: XFS: "slow at directory traversal .. after 3 years of use"
In-Reply-To: <1c08324d0810061325kdd1453alb9eab9ceb769b1cf@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810061627260.15837@p34.internal.lan>
References: <1c08324d0810061325kdd1453alb9eab9ceb769b1cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Lennart Hansen <lahansen@gmail.com>

Someone pointed me to the following paper:

http://www.stdlib.net/~colmmacc/Apachecon-EU2005/scaling-apache-handout.pdf

Which states:

After nearly 3 years of use, some problems with XFS became noticeable. As the number of used inodes in the filesystem grows XFS becomes very slow at directory traversal. Although this did not impede web-serving it did have a heavy impact on how quickly we could synchronise content with the primary sources.

Dave / Eric, comments here?  Does ext3 suffer from the same problem?

Have these issues been fixed since 2005?  Would inode64 alleviate some of
these problems?

Justin.
