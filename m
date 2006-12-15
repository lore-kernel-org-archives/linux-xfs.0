Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Dec 2006 06:32:40 -0800 (PST)
Received: from smtp2.belwue.de (smtp2.belwue.de [129.143.2.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBFEWRqw019608
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 06:32:28 -0800
Received: from scmail.science-computing.de (blackhole.science-computing.de [193.197.16.3])
	by smtp2.belwue.de with ESMTP id kBFEHU63028101
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 15:17:33 +0100 (MET)
	env-from (a.apprich@science-computing.de)
Received: from localhost (localhost [127.0.0.1])
	by scmail.science-computing.de (Postfix) with ESMTP id 509FC715E3F1
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 15:17:28 +0100 (CET)
Received: from scmail.science-computing.de ([127.0.0.1])
	by localhost (obitest [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25200-02 for <xfs@oss.sgi.com>;
	Fri, 15 Dec 2006 15:17:23 +0100 (CET)
Received: from [10.10.16.1] (elmstreet.science-computing.de [10.10.16.1])
	by scmail.science-computing.de (Postfix) with ESMTP id CCF7170F72B4
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 15:17:23 +0100 (CET)
Message-ID: <4582AE73.9080409@science-computing.de>
Date: Fri, 15 Dec 2006 15:17:23 +0100
From: Alexander Apprich <a.apprich@science-computing.de>
MIME-Version: 1.0
Subject: Re: not able to create XFS filesystem
References: <743683.94860.qm@web32704.mail.mud.yahoo.com>
In-Reply-To: <743683.94860.qm@web32704.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com

Hi,

chandrasekar mahalingam wrote:
> Hi
>    my RHEL 4 machine (Linux spea44 2.6.9-42.ELsmp #1
> SMP Wed Jul 12 23:32:02 EDT 2006 x86_64 x86_64 x86_64
> GNU/Linux) has the rpm installed for XFS . 
> 
> xorg-x11-xfs-6.8.2-1.EL.13.36 and
> xorg-x11-libs-6.8.2-1.EL.13.36
> 

those packages have nothing to do with the XFS filesystem :-)

> when i try to create a file system using
>  "mkfs -t xfs /dev/sekarvg/simple1" it says "mkfs.XFS:
> No such file or directory" . "lsmod|grep -i xfs " does
> not list xfs . 
> 

AFAIK the XFS filesystem isn't officially supported by
RedHat. You might get them from someplace else like

http://atrpms.net/dist/el4/

But the kernel also need to support xfs.


Hth

Alex
