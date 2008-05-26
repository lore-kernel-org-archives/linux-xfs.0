Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 May 2008 03:34:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4QAYBQ3007229
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 03:34:12 -0700
Received: from dqmail.dynamicquest.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8F3CBDB063
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 03:35:02 -0700 (PDT)
Received: from dqmail.dynamicquest.com (dqmail.dynamicquest.com [74.202.150.200]) by cuda.sgi.com with ESMTP id i83vp5dcNIXnUuKL for <xfs@oss.sgi.com>; Mon, 26 May 2008 03:35:02 -0700 (PDT)
Message-ID: <483A9254.8010509@dynamicquest.com>
Date: Mon, 26 May 2008 06:35:00 -0400
From: Javier Gomez <gomez@dynamicquest.com>
MIME-Version: 1.0
Subject: Re: Lost Superblock and need help recovering
References: <483A231F.2030207@dynamicquest.com> <483A3112.4090502@sandeen.net>
In-Reply-To: <483A3112.4090502@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


    The two devices having issues are /dev/etherd/e5.1p1    and    
/dev/etherd/e4.1p1

    You make a very valid point.  Notice the main device shows the full 
size (one has 12.6 TB and the other is 9.5 TB).  Each of these two 
devices contain a single complete partition on it taking up the full 
size of the device.  It looks like both of these are short on the size 
for the actual partition "1p1".  Note that for device /dev/etherd/e3.1 
and /dev/etherd/e7.1  and /dev/etherd/e7.2 we formated the xfs 
filesystem directly on the device.  The groups on the net had noted that 
it could be done either way, but it might be a little safer to do it 
with the xfs formated directly on the device (not sure if this is 
valid).  In this case /dev/etherd/e3 and /dev/etherd/e7 both came up 
just fine after the hard shutdown while the /dev/etherd/e4 and 
/dev/etherd/e5 both have this superblock issue.  Each of these devices 
are running the same stuff except that /dev/etherd/e5 is slightly 
smaller then the other ones in disk space.  See this information below, 
do you have any suggestions to recover from it?  Is there anyway to 
remap the partition description to fill the entire size correctly so 
that the xfs_repair can complete its job?
   
    Thanks again for any help...
                      Javier

[root@seer proc]# cat partitions
major minor  #blocks  name

   8     0  243163136 sda
   8     1     104391 sda1
   8     2  243055417 sda2
 253     0  241008640 dm-0
 253     1    2031616 dm-1
 152     0 12697913278 etherd/e4.1
 152     1 1960494281 etherd/e4.1p1
 152    16 12697913278 etherd/e3.1
 152    32 12697913278 etherd/e7.1
 152    48 9523468862 etherd/e5.1
 152    49  933533929 etherd/e5.1p1
 152    64  976762558 etherd/e7.2



Eric Sandeen wrote:
> Javier Gomez wrote:
>
>   
>>  > xfs_repair -nv /dev/etherd/e4.1p1
>> ---------------------------------------------------------------
>> Phase 1 - find and verify superblock...
>> error reading superblock 4 -- seek to offset 1219003957248 failed
>> couldn't verify primary superblock - bad magic number !!!
>>     
>
> Looks to me like you still have storage problems.
>
> 1219003957248 is just over 1 terabyte... why can't repair seek to that
> location if it's a 13T device?
>
> What does /proc/partitions say about this block device (or do AoE
> devices go there?)
>
> -Eric
>
>   
>> attempting to find secondary superblock...
>> ................................................................................................
>> ......................................................
>> ..................
>> ..................
>> ............Sorry, could not find valid secondary superblock
>> Exiting now.
>> ---------------------------------------------------------------
>>
>>
>>     
>
>   


[[HTML alternate version deleted]]
