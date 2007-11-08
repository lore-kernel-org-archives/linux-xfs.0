Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 06:59:39 -0800 (PST)
Received: from r2d2.neofacto.lu (mail.neofacto.lu [158.64.60.195])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA8ExWfY024308
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 06:59:35 -0800
Message-ID: <47332456.9030805@jamendo.com>
Date: Thu, 08 Nov 2007 15:59:34 +0100
From: Amandine AUPETIT <amandine@jamendo.com>
MIME-Version: 1.0
Subject: Re: 7Tb XFS partition lost on reboot
References: <473072FD.4070104@jamendo.com> <alpine.LRH.0.9999.0711061144540.17301@hogwarts.egr.duke.edu> <4730B98C.5090008@sandeen.net> <47330B8E.5010008@jamendo.com> <4733201C.9060802@sandeen.net>
In-Reply-To: <4733201C.9060802@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, xfs@oss.sgi.com

Ok, sorry for the mix-up.
You were right, the problem was about the partition table.
Actually, even if it was a gpt partition table, it was corrupted. I 
seems to be a ubuntu parted problem. I had to rebuild pared from the 
sources and when I ran it, it said :

# ./parted
GNU Parted 1.8.8
Using /dev/cciss/c1d0
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print                                                           
print
Warning: /dev/cciss/c1d0 contains GPT signatures, indicating that it has 
a GPT
table.  However, it does not have a valid fake msdos partition table, as it
should.  Perhaps it was corrupted -- possibly by a program that doesn't
understand GPT partition tables.  Or perhaps you deleted the GPT table, 
and are
now using an msdos partition table.  Is this a GPT partition table?
Yes/No? yes                                                              
yes
Model: Compaq Smart Array (cpqarray)
Disk /dev/cciss/c1d0: 7501GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  7501GB  7501GB  xfs          primary      



So I deleted the existing partition and recreated a new one. I found 
back all my data on this new partition, and on reboot there is no 
problem anymore.

Thanks a lot for your help ! :)

Amandine


Eric Sandeen a écrit :
> Amandine AUPETIT wrote:
>   
>> Hi,
>> Thanks for the advice !
>> I checked the label with xfs_admin -l :
>> # xfs_admin -l /dev/cciss/c1d0p1
>> label = ""
>>
>> I tried to blank it in case there is something invisible :
>> # xfs_admin -L -- /dev/cciss/c1d0p1
>> writing all SBs
>> new label = ""
>>
>> But it seems to be the same. :(
>>     
>
> No, not the filesystem label, the disklabel, otherwise known as the
> partition table - dos vs. gpt.  This is something you set with parted or
> fdisk, not xfs_admin.
>
> -Eric
>   
