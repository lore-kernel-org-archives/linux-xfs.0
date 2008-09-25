Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 01:15:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P8FABC010455
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 01:15:10 -0700
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B37B21079064
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 01:16:44 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188]) by cuda.sgi.com with ESMTP id 1kamaAF0xqViTjxB for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 01:16:44 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id h3so313537nfh.42
        for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 01:16:43 -0700 (PDT)
Message-ID: <48DB48E3.3020104@gmail.com>
Date: Thu, 25 Sep 2008 11:16:35 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: Speed of rm compared to reiserfs (slow)
References: <48D9FDA1.8050701@gmail.com> <20080925002724.GA27997@disturbed>
In-Reply-To: <20080925002724.GA27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, david@fromorbit.com

On 2008-09-25 03:27, Dave Chinner wrote:
> On Wed, Sep 24, 2008 at 11:43:13AM +0300, Török Edwin wrote:
>   
>> Hi,
>>
>> I am happily using xfs for /var, /usr and /, and I am very pleased with
>> the read speed.
>> I've just recommended xfs to a friend, and he complained about the speed
>> of rm.
>>
>> I did a test on my box, and indeed the speed of rm is order of magnitude
>> slower compared to reiserfs.
>> I already use lazy-count, and noatime/nodiratime. Write barriers are off
>> because I run on raid10.
>>
>> Is there anything else I can tune to get faster rm speed?
>>     
>
> mount -o logbsize=262144 <dev> <mtpt>
>   

I've added it to my mount options, also tried logbufs=8 (but that didn't
make much difference).

>   
>> # mount | grep var
>> /dev/mapper/vg--all-lv--var on /var type xfs (rw,noatime,nodiratime)
>>     
>
> BTW, noatime implies nodiratime - you don't ned to specify both.
>
>   
>> tmpfs                 2.0G   12K  2.0G   1% /lib/init/rw
>> udev                   10M  188K  9.9M   2% /dev
>> tmpfs                 2.0G     0  2.0G   0% /dev/shm
>> /dev/mapper/vg--all-lv--usr
>>                       100G  5.3G   95G   6% /usr
>> /dev/mapper/vg--all-lv--var
>>                       1.3T  230G  1.1T  18% /var
>>     
>
> At 1.1T, you probably want to use inode64 for /var. The different
> allocation strategy of inode32 can be substantially slower than
> inode64.
>
>   

Thanks for the suggestions, the time for rm has improved a bit, but is
still slower than reiserfs:

time rm -rf gcc

real    1m18.818s
user    0m0.156s
sys     0m11.777s

Is there anything else I can try to make it faster?

Best regards,
--Edwin
