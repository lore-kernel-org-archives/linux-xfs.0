Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Dec 2006 17:52:42 -0800 (PST)
Received: from taiwan.yingternet.net (taiwan.yingternet.net [59.124.122.220])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBT1qYqw004672
	for <linux-xfs@oss.sgi.com>; Thu, 28 Dec 2006 17:52:35 -0800
Message-ID: <459474A7.2090902@yingternet.com>
Date: Fri, 29 Dec 2006 09:51:35 +0800
From: Ying-Hung Chen <ying@yingternet.com>
MIME-Version: 1.0
Subject: Re: xfs_repair xfsprogs version > 2.8.11
References: <458E643D.3090008@yingternet.com> <458FA0F8.1020107@yingternet.com> <45939ABD.6010600@melbourne.sgi.com>
In-Reply-To: <45939ABD.6010600@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: linux-xfs@oss.sgi.com

Hi David,

on 2.4 side, I am running the kernel based on 2.4.33, using gcc 3.4.4,
glibc-2.3.5, ulimit yields

core file size        (blocks, -c) 0
data seg size         (kbytes, -d) 60144
file size             (blocks, -f) unlimited
max locked memory     (kbytes, -l) unlimited
max memory size       (kbytes, -m) unlimited
open files                    (-n) 256
pipe size          (512 bytes, -p) 8
stack size            (kbytes, -s) 8192
cpu time             (seconds, -t) unlimited
max user processes            (-u) 100
virtual memory        (kbytes, -v) unlimited

on 2.6 side, I have kernel based on 2.6.16.32, using gcc 4.1.1 and
glibc-2.3.6, ulimit yields

core file size          (blocks, -c) 0
data seg size           (kbytes, -d) 12288
file size               (blocks, -f) unlimited
pending signals                 (-i) 1535
max locked memory       (kbytes, -l) 32
max memory size         (kbytes, -m) unlimited
open files                      (-n) 256
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 100
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

anything that you need for better pin point the problem?

also, is the stacksize resizing really necessary as showed in

...
stacksize *= 4;
...

Thanks

-Ying

David Chatterton wrote:
> Ying-Hung,
> 
> Can you please provide some info on your configuration? Obviously we are
> not seeing this problem in our own tests and reproducing this will help
> to resolve it.
> 
> Thanks,
> 
> David
> 
> 
> Ying-Hung Chen wrote:
>> Hi there,
>>
>> actually, i have trace the code in to xfs_repair/threads.c (taken from
>> 2.8.18)
>>
>> void
>> thread_init(void)
>> {
>>     ....
>>     if ((status = pthread_attr_getstacksize(&attr, &stacksize)) != 0)
>>         do_error(_("status from pthread_attr_getstacksize: %d"),
>>         status);
>>
>>     stacksize *= 4;
>>
>>     if ((status = pthread_attr_setstacksize(&attr, stacksize)) != 0)
>>         do_error(_("status from pthread_attr_setstacksize: %d"),
>>         status);
>>  ....
>>  }
>>
>> the repair program dies in pthread_attr_setstacksize(&attr, stacksize)).
>> is there any reason why the program is trying to set the stacksize into
>> 4 times the current size?
>>
>> just for testing purposes, I remove the stacksize *= 4; the xfs_repair
>> seems to 'work', at least from user's point of view.
>>
>> I have tested with x86 32bits machines with 2.4 and 2.6 kernels, they
>> both yield with the same results,
>>
>> Thanks,
>>
>> -Ying
>>
>> Ying-Hung Chen wrote:
>>> Hi there,
>>>
>>> I found that xfs_repair always returns the following message with the
>>> xfsprogs version > 2.8.11
>>>
>>> [root@yroro i586]# xfs_repair /dev/hdb1
>>>
>>> fatal error -- status from pthread_attr_setstacksize: 22
>>>
>>> from the ChangeLog, seems like there is some internal changes with
>>> threads starting 2.8.11 .. the xfs_repair works for me up to 2.8.11, it
>>> fails to work on 2.8.16 and 2.8.18,
>>>
>>> how do I work around this problem?
>>>
>>> Thanks,
>>>
>>> -Ying
>>>
> 
