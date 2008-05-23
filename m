Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 17:43:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4N0hRN7015257
	for <linux-xfs@oss.sgi.com>; Thu, 22 May 2008 17:43:27 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6B491A65AC
	for <linux-xfs@oss.sgi.com>; Thu, 22 May 2008 17:44:17 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id IXOxEM2nilyDHjip for <linux-xfs@oss.sgi.com>; Thu, 22 May 2008 17:44:17 -0700 (PDT)
Message-ID: <4836135D.9050409@tlinx.org>
Date: Thu, 22 May 2008 17:44:13 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: XFS for lots of small files
References: <4820832B.3070903@dubielvitrum.pl> (sfid-20080506_185726_779300_46423265) <200805062055.36755.Martin@lichtvoll.de>
In-Reply-To: <200805062055.36755.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>, Linux-Xfs <linux-xfs@oss.sgi.com>

Martin Steigerwald wrote:
> And there is quite some fragmentation on it:
> 
> xfs_db> frag
> actual 653519, ideal 587066, fragmentation factor 10.17%
----
	Not to disturb you, but are  you running xfs_fsr on a
regular basis?

I have a shell script that runs in my 'cron.daily' that has two
lines:
----
#!/bin/bash
ionice -c 3 /usr/sbin/xfs_fsr &
-------

I've never noticed fragmentation above 1% on my disks...but your
mileage may vary ....
