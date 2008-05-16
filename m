Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 04:35:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GBYiMW021967
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 04:34:48 -0700
Received: from smtp-out03.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5ECA17C7B0
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 04:35:32 -0700 (PDT)
Received: from smtp-out03.alice-dsl.net (smtp-out03.alice-dsl.net [88.44.63.5]) by cuda.sgi.com with ESMTP id KAKNnSI6KCMaM6BG for <xfs@oss.sgi.com>; Fri, 16 May 2008 04:35:32 -0700 (PDT)
Subject: Re: [PATCH] XFS tuning on software RAID5 partitionable array; error in xfsprogs 2.9.8
From: Andi Kleen <andi@firstfloor.org>
References: <47D90614.9040206@free.fr>
	<18408.36753.223347.129420@notabene.brown> <47E92EE2.1080108@free.fr>
	<20080326065232.GA21970@percy.comedia.it> <47EA71BF.8050800@tmr.com>
	<47EA8CF4.7080201@free.fr> <47EA99AD.9060400@free.fr>
	<482D6388.7040602@free.fr>
Date: Fri, 16 May 2008 13:30:15 +0200
In-Reply-To: <482D6388.7040602@free.fr> (Hubert Verstraete's message of "Fri, 16 May 2008 12:35:52 +0200")
Message-ID: <87fxsi32rc.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hubert Verstraete <hubskml@free.fr>
Cc: xfs@oss.sgi.com

Hubert Verstraete <hubskml@free.fr> writes:
>
> The line 89 in libdisk/md.c is: "free(dfile2);" but it should have
> remained "if (dfile2) free(dfile2);" because dfile2 is null in case
> mkfs.xfs is run on an MD device.

ISO-C free() is defined to do nothing on a NULL input.

-Andi
