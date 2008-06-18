Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 00:20:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5I7K3TX020806
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:20:04 -0700
Received: from web34506.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 4F86ECE50DB
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:21:01 -0700 (PDT)
Received: from web34506.mail.mud.yahoo.com (web34506.mail.mud.yahoo.com [66.163.178.172]) by cuda.sgi.com with SMTP id H5hhsmkFzYmkbDHx for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:21:01 -0700 (PDT)
Date: Wed, 18 Jun 2008 00:21:01 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Fw: Re: XFS mkfs/mount options
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <521591.99815.qm@web34506.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

To all,

It appears I have found a defect in my testing. Generally, the procedure has been something like:

create filesystem
mount filesystem and set owner/group
run benchmark
alter some condition (CPU speed or IRQ routing)
re-run benchmark
compare results

The second run is contaminated by caching effects from the first run. This accounts for the roughly 5% speedup I saw after enabling explicit IRQ routing. Once I corrected this oversight, the difference became statistical noise.

My apologies to all for this red herring.

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
