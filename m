Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 05:13:53 -0800 (PST)
Received: from r2d2.neofacto.lu (mail.neofacto.lu [158.64.60.195])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA8DDlAj009037
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 05:13:50 -0800
Message-ID: <47330B8E.5010008@jamendo.com>
Date: Thu, 08 Nov 2007 14:13:50 +0100
From: Amandine AUPETIT <amandine@jamendo.com>
MIME-Version: 1.0
Subject: Re: 7Tb XFS partition lost on reboot
References: <473072FD.4070104@jamendo.com> <alpine.LRH.0.9999.0711061144540.17301@hogwarts.egr.duke.edu> <4730B98C.5090008@sandeen.net>
In-Reply-To: <4730B98C.5090008@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, xfs@oss.sgi.com

Hi,
Thanks for the advice !
I checked the label with xfs_admin -l :
# xfs_admin -l /dev/cciss/c1d0p1
label = ""

I tried to blank it in case there is something invisible :
# xfs_admin -L -- /dev/cciss/c1d0p1
writing all SBs
new label = ""

But it seems to be the same. :(

Amandine


Eric Sandeen a écrit :
> Joshua Baker-LePain wrote:
>   
>> On Tue, 6 Nov 2007 at 2:58pm, Amandine AUPETIT wrote
>>
>>     
>>> So I created the partition with parted, because fdisk can't do more that 2tb 
>>> partitions.
>>> It's ok, I can do what I want but...
>>>
>>> on reboot, there is a Superblock problem, something like that. When I check 
>>> with xfs_check :
>>>       
>> First guess -- did you use a gpt disklabel on that device?  Standard 
>> (msdos) disklabels don't work on devices >2TB.  The usual symptom of a big 
>> device with an msdos disklabel is that the partition table goes away on 
>> reboot.
>>     
>
> I second that hunch.  :)
>
> -Eric
>   
