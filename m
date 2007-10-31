Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 21:08:03 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V47pPY014657
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 21:07:54 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1In4rz-0000WK-HW
	for xfs@oss.sgi.com; Tue, 30 Oct 2007 21:07:55 -0700
Message-ID: <13502504.post@talk.nabble.com>
Date: Tue, 30 Oct 2007 21:07:55 -0700 (PDT)
From: "paul.lkw" <paul.lkw@mfun.org>
Subject: Re: 2.6TB Storage Size Problem
In-Reply-To: <alpine.LRH.0.9999.0710302328250.29151@hogwarts.egr.duke.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <13501909.post@talk.nabble.com> <alpine.LRH.0.9999.0710302328250.29151@hogwarts.egr.duke.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Does it means I have to use one harddisk for just boot process ?


Joshua Baker-LePain wrote:
> 
> On Tue, 30 Oct 2007 at 7:35pm, paul.lkw wrote
> 
>> I have a DELL server with a hardware raid controller card and 6 x 750GB
>> Harddisk, and I configured it as a Raid-5 (5 x 750GB) and 1 of HotSpare.
>> I
>> partitioned 50GB of the main base CentOS system and the remain
>> unpartitioned
>> size should be 2.5xxxTB, but however I just have 2.0T as EXT-3 limitation
>> (I
>> think), How can I use the full size of this with LVM?
> 
> This has been answered many times on the CentOS list:
> 
> 1) On a device larger than 2.0TB, you must use a gpt disklabel rather than
>     the default msdos.
> 
> 2) You must use parted when partitioning such a device.
> 
> 3) You can't boot from such a device (as neither grub nor lilo support gpt
>     disklabels).
> 
> -- 
> Joshua Baker-LePain
> QB3 Shared Cluster Sysadmin
> UCSF
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/2.6TB-Storage-Size-Problem-tf4722532.html#a13502504
Sent from the Xfs - General mailing list archive at Nabble.com.
