Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 May 2007 09:50:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l45GoDfB006809
	for <xfs@oss.sgi.com>; Sat, 5 May 2007 09:50:15 -0700
Message-ID: <463CB5C4.7040803@sandeen.net>
Date: Sat, 05 May 2007 11:50:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS crash on linux raid
References: <20070503164521.16efe075@harpe.intellique.com>	<20070504005922.GC32602149@melbourne.sgi.com>	<20070504090613.7c0f97d3@galadriel.home>	<20070504073344.GL32602149@melbourne.sgi.com>	<20070504152546.614374ac@harpe.intellique.com>	<463B4962.70904@sandeen.net>	<20070504173049.14606033@harpe.intellique.com>	<20070504232028.GA19744@tuatara.stupidest.org> <20070505171931.6fe9b6f5@galadriel.home>
In-Reply-To: <20070505171931.6fe9b6f5@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

Emmanuel Florac wrote:
> Le Fri, 4 May 2007 16:20:28 -0700 vous écriviez:
> 
>> You could if you have time try this and enable CONFIG_I386_IRQSTACKS
>> but don't enable CONFIG_I386_4KSTACKS and see if that helps...
> 
> That sounds very interesting, I'll give it a try monday.
> 

There are also stack debugging config options; one that will warn if you 
are about to overflow (CONFIG_DEBUG_STACKOVERFLOW) and one that will 
print max stack depth in sysrq-t output (CONFIG_DEBUG_STACK_USAGE).

-Eric
