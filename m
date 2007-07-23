Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 15:26:12 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6NMQ8bm014648
	for <linux-xfs@oss.sgi.com>; Mon, 23 Jul 2007 15:26:10 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1ID6Lz-0003YJ-B7
	for linux-xfs@oss.sgi.com; Mon, 23 Jul 2007 15:26:11 -0700
Message-ID: <11753958.post@talk.nabble.com>
Date: Mon, 23 Jul 2007 15:26:11 -0700 (PDT)
From: amilrego <victor.amil@gmail.com>
Subject: Re: XFS log warning "Writing back config space on device"
In-Reply-To: <469E31C5.6010606@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <11667329.post@talk.nabble.com> <469E31C5.6010606@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com




Eric Sandeen-3 wrote:
> 
> amilrego wrote:
>> Hello.
>> I have formated one 300 GB partition in Linux OS, and then i worked
>> whitout
>> problems.
>> But, If I do a "dmesg" there is a warning error (i don´t know if is
>> really a
>> problem or maybe could cause problems in future):
>> 
>> SCSI device sdb: drive cache: write back
>>  sdb: sdb1
>>  ---
>> 
>> XFS mounting filesystem sdb1
>> Ending clean XFS mount for filesystem: sdb1
>> PM: Writing back config space on device 0000:05:02.0 at offset b (was
>> 165314e4, writing 12bc103c)
> 
> That's not an xfs message; it's from the PCI subsystem.  It shouldn't be
> related to anything xfs is doing...  It's also only a debug-level
> message (at least in 2.6.18).
> 
> -eric
> 
> 
> 
> 

Thanks Eric. Really, I am running 2.6.18 then it is only a debug message :)

-- 
View this message in context: http://www.nabble.com/XFS-log-warning-%22Writing-back-config-space-on-device%22-tf4102828.html#a11753958
Sent from the linux-xfs mailing list archive at Nabble.com.
