Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 May 2008 08:12:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4QFChUF029015
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 08:12:48 -0700
Received: from dqmail.dynamicquest.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08C7C1B3135
	for <xfs@oss.sgi.com>; Mon, 26 May 2008 08:13:34 -0700 (PDT)
Received: from dqmail.dynamicquest.com (dqmail.dynamicquest.com [74.202.150.200]) by cuda.sgi.com with ESMTP id BDTQhSGQWMGk4fGq for <xfs@oss.sgi.com>; Mon, 26 May 2008 08:13:34 -0700 (PDT)
Message-ID: <483AD39C.8040201@dynamicquest.com>
Date: Mon, 26 May 2008 11:13:32 -0400
From: Javier Gomez <gomez@dynamicquest.com>
MIME-Version: 1.0
Subject: Re: Lost Superblock and need help recovering
References: <483A231F.2030207@dynamicquest.com> <483A3112.4090502@sandeen.net> <483A9254.8010509@dynamicquest.com> <483ACE00.4050701@sandeen.net>
In-Reply-To: <483ACE00.4050701@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


    Thanks for the feedback.  Your right on the mark.  We did use 
"parted" to create the partitions on this device.  That would explain 
the issue we are having right now.  Do you have any suggestions on what 
to do next to correct this issue.  I have not seen any clear information 
on the net about this issue.  The information on these devices is very 
important to us and very critical we get it up again prior to tomorrow 
(or reasonably soon after).

    How would you suggest we try to repair the partition table.  Also 
given that its 13 TB a "dd" to backup the device will take a long time 
and I am also not sure what dd command to run that will grab the data 
correctly given the bad partition information currently in place.
                Javier




Eric Sandeen wrote:
> Javier Gomez wrote:
>   
>>     The two devices having issues are /dev/etherd/e5.1p1    and   
>> /dev/etherd/e4.1p1
>>
>>     You make a very valid point.  Notice the main device shows the full
>> size (one has 12.6 TB and the other is 9.5 TB).  Each of these two
>> devices contain a single complete partition on it taking up the full
>> size of the device.  It looks like both of these are short on the size
>> for the actual partition "1p1".  
>>     
>
> Yep....
>
>   
>> Note that for device /dev/etherd/e3.1
>> and /dev/etherd/e7.1  and /dev/etherd/e7.2 we formated the xfs
>> filesystem directly on the device.  The groups on the net had noted that
>> it could be done either way, but it might be a little safer to do it
>> with the xfs formated directly on the device (not sure if this is
>> valid).  
>>     
>
> >From the xfs perspective, it does not really matter.
>
>   
>> In this case /dev/etherd/e3 and /dev/etherd/e7 both came up
>> just fine after the hard shutdown while the /dev/etherd/e4 and
>> /dev/etherd/e5 both have this superblock issue.  
>>     
>
> If we look at those devices in /proc/partitions:
>
>   
>>  152     0 12697913278 etherd/e4.1	<-- 11.8GiB
>>  152     1 1960494281 etherd/e4.1p1	<--  1.8GiB
>>  152    48 9523468862 etherd/e5.1	<--  8.8GiB
>>  152    49  933533929 etherd/e5.1p1	<--  0.9GiB
>>     
>
> you can see that the partitions don't actually seeem to span much of the
> device.  I don't know how that happened, but it's unlikely to be an xfs
> problem.... perhaps if you can figure out what went wrong there, and get
> your partitions back to the right(?) size xfs will see a consistent
> filesystem.
>
>   
>> Each of these devices
>> are running the same stuff except that /dev/etherd/e5 is slightly
>> smaller then the other ones in disk space.  See this information below,
>> do you have any suggestions to recover from it?  Is there anyway to
>> remap the partition description to fill the entire size correctly so
>> that the xfs_repair can complete its job?
>>     
>
> What sort of partition tables are on the devices?  I'll hazard a guess
> that they're dos partition tables made with parted?  Hmm yep from
> looking at the sizes of your devices and partitions, it does appear that
> the high bits of the size have been lost.
>
> If so then you've been bitten by a parted bug that lets you "create" dos
> partition tables larger than can actually be stored on-disk (2T IIRC),
> so that when you reboot, it appears to be truncated.  However, the xfs
> data is still there, if so.
>
> Depending on how big the dos partition table is I think some people have
> successfully replaced it with a GPT table, which can handle these larger
> sizes.  Doing that is a little tricky, and backing up the old table with
> dd is well-advised.
>
> -Eric
>   


[[HTML alternate version deleted]]
