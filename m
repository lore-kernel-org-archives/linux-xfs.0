Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 00:40:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q7e008018206
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:40:00 -0700
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30C7C4869D1
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:41:34 -0700 (PDT)
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.190]) by cuda.sgi.com with ESMTP id DEEAOKU0vUlNVLLj for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:41:34 -0700 (PDT)
Received: by fk-out-0910.google.com with SMTP id 26so924972fkx.4
        for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 00:41:33 -0700 (PDT)
Message-ID: <48DC9227.6060908@gmail.com>
Date: Fri, 26 Sep 2008 10:41:27 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Speed of rm compared to reiserfs (slow)
References: <48D9FDA1.8050701@gmail.com> <20080925002724.GA27997@disturbed> <48DB48E3.3020104@gmail.com> <20080925235453.GF27997@disturbed>
In-Reply-To: <20080925235453.GF27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>, xfs@oss.sgi.com

On 2008-09-26 02:54, Dave Chinner wrote:
> On Thu, Sep 25, 2008 at 11:16:35AM +0300, Török Edwin wrote:
>   
>> On 2008-09-25 03:27, Dave Chinner wrote:
>>     
>>> On Wed, Sep 24, 2008 at 11:43:13AM +0300, Török Edwin wrote:
>>>       
>> Thanks for the suggestions, the time for rm has improved a bit, but is
>> still slower than reiserfs:
>>
>> time rm -rf gcc
>>
>> real    1m18.818s
>> user    0m0.156s
>> sys     0m11.777s
>>
>> Is there anything else I can try to make it faster?
>>     
>
> Buy more disks. ;)
>
> XFS is not really optimised for single disk, metadata intensive,
> small file workloads.

I have 6 disks, in raid10 :)

md4 : active raid10 sda3[0] sdf3[5] sdc3[4] sde3[3] sdd3[2] sdb3[1]
      2159617728 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]

--- Logical volume ---
  LV Name                /dev/vg-all/lv-var
  VG Name                vg-all
  LV UUID                CQHPts-K3OE-9kWV-hg7q-328i-RP0i-Dew94c
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.27 TB
  Current LE             332800
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

  --- Segments ---
  Logical extent 0 to 332799:
    Type                linear
    Physical volume     /dev/md4
    Physical extents    25600 to 358399

>  It scales by being able to keep lots of disks
> busy at the same time. Those algorithms don't map to single disk
> configs as efficiently as a filesystem that was specifically
> designed for optimal performance for these workloads (like
> reiserfs). We're working on making it better, but that takes time....

I see.
Well the read performance is very good as I said in my initial email ;)

Thanks,
--Edwin
