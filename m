Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 10:00:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5PGxrtl024548
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 09:59:57 -0700
Received: from web34505.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 408F6D4D5B9
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 10:00:51 -0700 (PDT)
Received: from web34505.mail.mud.yahoo.com (web34505.mail.mud.yahoo.com [66.163.178.171]) by cuda.sgi.com with SMTP id BMtAGRk8vm6yuQkx for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 10:00:51 -0700 (PDT)
Date: Wed, 25 Jun 2008 10:00:50 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: Performance problems with millions of inodes
In-Reply-To: <20080625180222.12885793@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <889832.67139.qm@web34505.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Litauer <litauer@uni-koblenz.de>, Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

What type of RAID? If striping is involved, perhaps you should investigate the "su" and "sw" suboptions.

I also found some performance improvement with "-l lazy-count=1", although you may not wish to slow down repair times for a backup volume.
-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
