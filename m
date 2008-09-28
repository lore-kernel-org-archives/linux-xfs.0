Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 12:25:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8SJPemr016663
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 12:25:40 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C223448F8F3
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 12:27:15 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153]) by cuda.sgi.com with ESMTP id 2fMyhfBe3nezVwWb for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 12:27:15 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so2288941fgb.8
        for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 12:27:14 -0700 (PDT)
Message-ID: <48DFDA8B.6070006@gmail.com>
Date: Sun, 28 Sep 2008 22:27:07 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Speed of rm compared to reiserfs (slow) - and switching logdevices
References: <48D9FDA1.8050701@gmail.com> <20080925002724.GA27997@disturbed> <48DB48E3.3020104@gmail.com> <20080925235453.GF27997@disturbed> <48DC9227.6060908@gmail.com> <48DFB20D.2020609@gmail.com> <48DFCC1F.9000506@sandeen.net>
In-Reply-To: <48DFCC1F.9000506@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 2008-09-28 21:25, Eric Sandeen wrote:
> Török Edwin wrote:
>   
>> On 2008-09-26 10:41, Török Edwin wrote:
>>     
>>> On 2008-09-26 02:54, Dave Chinner wrote:
>>>   
>>>       
>>>> On Thu, Sep 25, 2008 at 11:16:35AM +0300, Török Edwin wrote:
>>>>   
>>>>     
>>>>         
>>>>> On 2008-09-25 03:27, Dave Chinner wrote:
>>>>>     
>>>>>       
>>>>>           
>>>>>> On Wed, Sep 24, 2008 at 11:43:13AM +0300, Török Edwin wrote:
>>>>>>       
>>>>>>         
>>>>>>             
>>>>> Thanks for the suggestions, the time for rm has improved a bit, but is
>>>>> still slower than reiserfs:
>>>>>
>>>>> time rm -rf gcc
>>>>>
>>>>> real    1m18.818s
>>>>> user    0m0.156s
>>>>> sys     0m11.777s
>>>>>
>>>>> Is there anything else I can try to make it faster?
>>>>>     
>>>>>       
>>>>>           
>>>> Buy more disks. ;)
>>>>
>>>> XFS is not really optimised for single disk, metadata intensive,
>>>> small file workloads.
>>>>     
>>>>         
>>> I have 6 disks, in raid10 :)
>>>   
>>>       
>> I moved the logdevice to another disk (not part of RAID array), and now
>> the speed of rm is down to 30 seconds!
>>
>> I didn't find any documentation on how to convert an XFS fs with
>> internal log device to use external, so I did the following:
>> # xfs_db -x /dev/mapper/vg--all-lv--opt
>> xfs_db>sb
>> xfs_db> write logstart 0
>> xfs_db> quit
>>
>> The zero the logdevice, and mount using logdev=. This worked.
>>
>> However if I now use xfs_repair on this filesystem it restores the
>> internal log. Is there a way to make this change permanent? (i.e. switch
>> permanently to using external log?)
>>     
>
> Odds are you need to also set the logstart in the other superblocks:
>
> xfs_db> sb 0
> xfs_db> write logstart 0
> xfs_db> sb 1
> xfs_db> write logstart 0
>
> ...
>
> you could script this with xfs_db -c
>   

Thank you, xfs_repair now no longer changes the logdevice.

Best regards,
--Edwin
