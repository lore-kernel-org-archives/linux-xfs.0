Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Apr 2008 13:11:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3IKBF45002159
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 13:11:18 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3256159372A
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 13:11:55 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id HjI7m42pAvAmXIi0 for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 13:11:55 -0700 (PDT)
Date: Fri, 18 Apr 2008 22:10:33 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS error cannot mount RAID
Message-ID: <20080418221033.66c1fb34@galadriel.home>
In-Reply-To: <200804161801.35174.support@geoglobal.com>
References: <200804161801.35174.support@geoglobal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amicus Services Inc." <support@geoglobal.com>
Cc: xfs@oss.sgi.com, vincent.roy@geoglobal.com

Le Wed, 16 Apr 2008 18:01:35 -0600 vous écriviez:

> I have a AMCC RAID 5 which has been verified without error but cannot
> mount on a SUSE 10.1 OS. Inconsistency on the volume may have
> occurred during an abrupt power shutdown. Not sure if it would be
> prudent to run XFS_Repair at this stage since XFS_check returned info
> indicating inconsistencies exist.

Well I know from experience that xfs_repair may bite, unfortunately,
and that 3Ware RAID-5 really is touchy about power... BBU really is a
must.
Anyway, here is what to do :
1) if possible, use xfs_dump to backup the whole filesystem as is on
some other device, tape, disk, whatever you have available.
2) run xfs_repair -n /dev/sdXX >> /tmp/testfile and send "testfile" to
the list.

good luck!
-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
