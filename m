Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 17:26:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBB1QrD9005610
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 17:26:55 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AB45468342
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 17:27:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BRg3RdE14tDwlKJT for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 17:27:03 -0800 (PST)
Message-ID: <475DE745.9040907@sandeen.net>
Date: Mon, 10 Dec 2007 19:26:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: AW: Unexpected XFS SB number 0x00000000
References: <002a01c83b74$52060330$f6120990$@de> <475DC056.3000502@sandeen.net> <003401c83b8e$84c1d730$8e458590$@de>
In-Reply-To: <003401c83b8e$84c1d730$8e458590$@de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris <hsvchris@gmx.de>
Cc: linux-xfs@oss.sgi.com

Chris wrote:
>> Did your new partition table start in exactly the same place?
>>
> 
> I assumed it would be in the same place...
> I guess there is no way to find out what the old one looked like?
> 
>> Can you find the string "XFSB" anywhere near where your old partition
>> started?
>>
> 
> I can try to do so...how? :)
> When I look into the partition with cfdisk, I can see what
> cylinders/heads/sectors it uses. But I'm sure there are other tools?
> 
> Interestingly, after a reboot cfdisk shows me a 801575.31 MB partition and
> 2199023.26 MB free space, although I wrote a single partition of 3000598.57
> MB into the table before rebooting.

fat partitions can't be > 2T

-Eric
