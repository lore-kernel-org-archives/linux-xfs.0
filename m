Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 09:34:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8SGWsJa002412
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 09:32:55 -0700
Received: from mu-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B720F1B01B13
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 09:34:28 -0700 (PDT)
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.184]) by cuda.sgi.com with ESMTP id e33K7H7GAqYg74Vk for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 09:34:28 -0700 (PDT)
Received: by mu-out-0910.google.com with SMTP id w1so2857320mue.2
        for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 09:34:28 -0700 (PDT)
Message-ID: <48DFB20D.2020609@gmail.com>
Date: Sun, 28 Sep 2008 19:34:21 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Speed of rm compared to reiserfs (slow) - and switching logdevices
References: <48D9FDA1.8050701@gmail.com> <20080925002724.GA27997@disturbed> <48DB48E3.3020104@gmail.com> <20080925235453.GF27997@disturbed> <48DC9227.6060908@gmail.com>
In-Reply-To: <48DC9227.6060908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>, xfs@oss.sgi.com

On 2008-09-26 10:41, Török Edwin wrote:
> On 2008-09-26 02:54, Dave Chinner wrote:
>   
>> On Thu, Sep 25, 2008 at 11:16:35AM +0300, Török Edwin wrote:
>>   
>>     
>>> On 2008-09-25 03:27, Dave Chinner wrote:
>>>     
>>>       
>>>> On Wed, Sep 24, 2008 at 11:43:13AM +0300, Török Edwin wrote:
>>>>       
>>>>         
>>> Thanks for the suggestions, the time for rm has improved a bit, but is
>>> still slower than reiserfs:
>>>
>>> time rm -rf gcc
>>>
>>> real    1m18.818s
>>> user    0m0.156s
>>> sys     0m11.777s
>>>
>>> Is there anything else I can try to make it faster?
>>>     
>>>       
>> Buy more disks. ;)
>>
>> XFS is not really optimised for single disk, metadata intensive,
>> small file workloads.
>>     
>
> I have 6 disks, in raid10 :)
>   


I moved the logdevice to another disk (not part of RAID array), and now
the speed of rm is down to 30 seconds!

I didn't find any documentation on how to convert an XFS fs with
internal log device to use external, so I did the following:
# xfs_db -x /dev/mapper/vg--all-lv--opt
xfs_db>sb
xfs_db> write logstart 0
xfs_db> quit

The zero the logdevice, and mount using logdev=. This worked.

However if I now use xfs_repair on this filesystem it restores the
internal log. Is there a way to make this change permanent? (i.e. switch
permanently to using external log?)

Best regards,
--Edwin
