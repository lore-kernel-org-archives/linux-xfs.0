Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 13:04:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3LK3w7t021711
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 13:04:00 -0700
Received: from gv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F0C8A83466
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 13:04:39 -0700 (PDT)
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.191]) by cuda.sgi.com with ESMTP id rWTU5HmFC9tMkDal for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 13:04:39 -0700 (PDT)
Received: by gv-out-0910.google.com with SMTP id s4so175518gve.9
        for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 13:04:37 -0700 (PDT)
Message-ID: <4f52331f0804211257n47c1d21fiffb6d07235c5b302@mail.gmail.com>
Date: Mon, 21 Apr 2008 12:57:22 -0700
From: "Fong Vang" <sudoyang@gmail.com>
Subject: xfs_check and xfs_repair internal working details
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I would like to find how how xfs_check and xfs_repair do their work
internally.  I need to find answers to the following questions:

a) assuming the amount of data is the same for file systems, does it take
longer for xfs_check and xfs_repair to check/repair a file system with a lot
more files than one that has fewer?  Assuming two file systems are 1TB each
completely filled.  One of the file systems is filled with very large files
while the other one is filled with very small files, does it take longer to
check and repair the latter?

b) does xfs_check and repair check only the used blocks or does it check
everything?  I think there's a free list as well so I'm assuming it checks
that list as well.

If anyone can provide more insight into xfs_check and repair, it would be
greatly appreciated.

Thank you.


[[HTML alternate version deleted]]
