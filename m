Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 10:59:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6IxPYn028921
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 10:59:29 -0800
Message-ID: <4730B98C.5090008@sandeen.net>
Date: Tue, 06 Nov 2007 12:59:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 7Tb XFS partition lost on reboot
References: <473072FD.4070104@jamendo.com> <alpine.LRH.0.9999.0711061144540.17301@hogwarts.egr.duke.edu>
In-Reply-To: <alpine.LRH.0.9999.0711061144540.17301@hogwarts.egr.duke.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: Amandine AUPETIT <amandine@jamendo.com>, xfs@oss.sgi.com

Joshua Baker-LePain wrote:
> On Tue, 6 Nov 2007 at 2:58pm, Amandine AUPETIT wrote
> 
>> So I created the partition with parted, because fdisk can't do more that 2tb 
>> partitions.
>> It's ok, I can do what I want but...
>>
>> on reboot, there is a Superblock problem, something like that. When I check 
>> with xfs_check :
> 
> First guess -- did you use a gpt disklabel on that device?  Standard 
> (msdos) disklabels don't work on devices >2TB.  The usual symptom of a big 
> device with an msdos disklabel is that the partition table goes away on 
> reboot.

I second that hunch.  :)

-Eric
