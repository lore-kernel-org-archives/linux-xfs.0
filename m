Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Oct 2006 16:58:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA10wJaG014068
	for <linux-xfs@oss.sgi.com>; Tue, 31 Oct 2006 16:58:21 -0800
Message-ID: <4547F0FC.5060502@sgi.com>
Date: Wed, 01 Nov 2006 11:57:32 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com>
In-Reply-To: <4547EDFD.8020407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: John Groves <John@Groves.net>
Cc: Vlad Apostolov <vapo@sgi.com>, linux-xfs@oss.sgi.com

Vlad Apostolov wrote:
> John Groves wrote:
>> I'm running up against a difficult situation because 
>> dm_path_to_handle does not return a handle, if the path is to a 
>> directory.  Is this a known issue, or perhaps fixed in a recent 
>> version?  Or is there another way get the handle of a directory by 
>> path?  When any file type is renamed, I (for various reasons) *must* 
>> know not just the old & new parent handles, but also the handle of 
>> the renamed thingy.  If the thingy is a directory, I'm stuck at the 
>> moment.
>>
>> My test system has dmapi 2.2.1-5, which I don't think is current, but 
>> I can't seem to get access to the oss.sgi.com server to check.
>>
>> Any advice or info appreciated.  I'm willing to try and submit a 
>> patch, but I'd appreciate first knowing whether there was a specific 
>> reason or problem that led to the current behavior.
>>
>> Thanks,
>> John Groves
>>
> Hi John,
>
> If your path is longer than 2000 characters dm_path_to_handle used to 
> fail.
> This bug was fixed in August 2006. Please update your tree from here:
>
> http://oss.sgi.com/projects/xfs/download.html
>
> Regards,
> Vlad
>
You could also see an example of how to use dm_path_to_handle() in

xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle.c

Here is the output for a regular file and a directory:

vapo@emu ~/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd> ls -al /mnt/scratch1
total 8
drwxrwxrwx 4 root root    46 2006-11-01 12:04 .
drwxr-xr-x 8 root root    89 2006-10-30 14:23 ..
drwxr-xr-x 7 root root  4096 2006-10-26 10:56 dmapi
drwxr-xr-x 8 root root  4096 2006-10-26 10:56 dmapi_test
-rw-r--r-- 1 vapo cdrom    0 2006-11-01 12:04 file
vapo@emu ~/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd> sudo  
./path_to_handle /mnt/scratch1/file
5d1111a90e4800000e000000710100009600000000000000
vapo@emu ~/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd> sudo  
./path_to_handle /mnt/scratch1/dmapi
5d1111a90e4800000e0000006e0000008300000000000000
vapo@emu ~/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd>

Regards,
Vlad
