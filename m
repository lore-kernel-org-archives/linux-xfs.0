Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 08:23:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QFN3ql002006
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 08:23:10 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47805F4E94
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 08:23:45 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id 1Ruhq44OhPRA6W60 for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 08:23:45 -0700 (PDT)
Date: Sat, 26 Apr 2008 17:23:21 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid)
 and to 0.6% of EXT3 (3ware hardware raid)
Message-ID: <20080426172321.1096faf5@galadriel.home>
In-Reply-To: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Darling <darlingm@gmail.com>
Cc: xfs@oss.sgi.com

Le Wed, 23 Apr 2008 21:48:53 -0400 vous écriviez:

> If anyone could give me some pointers, I would much appreciate it!

You may greatly enhance performance on hardware RAID by using the
"nobarrier" mount option. However in this case you must have proper
power and/or optional 3Ware BBU (Battery backup unit). The BBU costs
around 60 euros so I'd take it anyway ;)
XFS is very (and sanely) touchy about the atomicity of logging
operations. Each delete action implies several small seeks and writes
( at the very least one to the data volume and one to the log) and that
hinders performance. "nobarrier" removes the enforcement to sync'ed
disk writes to the log, however this is dangerous if you're having
power supply problems.
Another option wich gave very satisfactory results to me is to use an
ultra-fast small SSD drive to store the filesystem log. However a single
professional SSD is as expensive as a 3Ware 9650 + several high
capacity SATA drives, but the combination is mostly comparable in
performance to a SAS array of lesser capacity and much higher power
consumption.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
