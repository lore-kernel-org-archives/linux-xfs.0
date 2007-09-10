Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 09:29:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AGSv4p019333
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 09:28:59 -0700
Message-ID: <46E570C4.6080303@sandeen.net>
Date: Mon, 10 Sep 2007 11:28:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Attempt to Access Beyond End of Device
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>	 <46E5670E.9000703@sandeen.net> <1189439689.18040.17.camel@auctoritas.fs3.ph>
In-Reply-To: <1189439689.18040.17.camel@auctoritas.fs3.ph>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>
Cc: linux-xfs@oss.sgi.com, Alec Joseph Rivera <agi@fs3.ph>

Federico Sevilla III wrote:
> On Mon, 2007-09-10 at 10:47 -0500, Eric Sandeen wrote:
>> can you send along the results of:
>>
>> 	# xfs_db -r -c "sb 0" -c "print" /dev/sda8?
> 
> Will do first thing tomorrow when I get back access to the machine, and
> will revert to the list.
> 
>> and
>> 	# cat /proc/partitions
>>
>> ... and does the hardware raid have a funky sector size?
> 
> Please advise as to how best to usually find this out. 

Dunno :)

FWIW, the size check that is failing is simply looking at the fs
geometry and trying to go out and read the last sector.

-Eric
