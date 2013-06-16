Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C8BF7F37
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 18:31:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F8A88F8033
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 16:31:30 -0700 (PDT)
Received: from mail-qe0-f46.google.com (mail-qe0-f46.google.com
	[209.85.128.46]) by cuda.sgi.com with ESMTP id aXV0WZhCcTJySHAK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Jun 2013 16:31:25 -0700 (PDT)
Received: by mail-qe0-f46.google.com with SMTP id nd7so1327622qeb.19
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 16:31:25 -0700 (PDT)
References: <CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<20130616220648.GG29338@dastard>
	<CAC2B=ZHBxCcvg4DMDdcRBXGrRJ2KVAibW1ToQ3yU5T5bQuHJtA@mail.gmail.com>
	<20130616231429.GH29338@dastard>
In-Reply-To: <20130616231429.GH29338@dastard>
Mime-Version: 1.0 (1.0)
Message-Id: <DF6F4914-1C0C-4E96-A5BA-307E0B663FC5@gmail.com>
From: Mark Seger <mjseger@gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Date: Sun, 16 Jun 2013 19:31:21 -0400
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nathan Scott <nathans@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks for your feedback, I really do appreciate it.  Tell you what, I'll try to get a newer distro installed and see if I can reproduce.  Either way ill let you know what I find
-mark

Sent from my iPhone

On Jun 16, 2013, at 7:14 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Jun 16, 2013 at 06:31:13PM -0400, Mark Seger wrote:
>>> 
>>> There is no way that fallocate() of 1000x1k files should be causing
>>> 450MB/s of IO for 5 seconds.
>> 
>> I agree and that's what has me puzzled as well.
>> 
>>> However, I still have no idea what you are running this test on - as
>>> I asked in another email, can you provide some information about
>>> the system your are seeing this problem on so we can try to work out
>>> what might be causing this?
>> 
>> sorry about that.  This is an HP box with 192GB RAM and 6 2-core
>> hyperthreaded CPUs, running ubuntu/precise
>> 
>> segerm@az1-sw-object-0006:~$ uname -a
>> Linux az1-sw-object-0006 2.6.38-16-server #68hf1026116v20120926-Ubuntu SMP
>> Wed Sep 26 14:34:13 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> 
> So it running a pretty old Ubuntu something-or-other kernel. There's
> only limited help I can give you for this kernel as I've got no idea
> what Ubuntu have put in it...
> 
>> segerm@az1-sw-object-0006:~$ python --version
>> Python 2.7.1+
>> 
>> segerm@az1-sw-object-0006:~$ xfs_repair -V
>> xfs_repair version 3.1.4
>> 
>> segerm@az1-sw-object-0006:~$ cat /proc/meminfo
>> MemTotal:       198191696 kB
>> MemFree:        166202324 kB
>> Buffers:          193268 kB
>> Cached:         21595332 kB
> ....
>> over 60 mounts, but here's the one I'm writing to:
>> 
>> segerm@az1-sw-object-0006:~$ mount | grep disk0
>> /dev/sdc1 on /srv/node/disk0 type xfs (rw,nobarrier)
>> 
>> not sure what you're looking for here so here's it all
>> 
>> segerm@az1-sw-object-0006:~$ cat /proc/partitions
>> major minor  #blocks  name
>> 
>>   8        0  976762584 sda
>>   8        1     248976 sda1
>>   8        2          1 sda2
>>   8        5  976510993 sda5
>> 251        0   41943040 dm-0
>> 251        1    8785920 dm-1
>> 251        2    2928640 dm-2
>>   8       16  976762584 sdb
>>   8       17  976760832 sdb1
>> 251        3  126889984 dm-3
>> 251        4     389120 dm-4
>> 251        5   41943040 dm-5
>>   8       32 2930233816 sdc
>>   8       33 2930233344 sdc1
> ....
> 
>> segerm@az1-sw-object-0006:~$ xfs_info /srv/node/disk0
>> meta-data=/dev/sdc1              isize=1024   agcount=32, agsize=22892416
>> blks
>>         =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=732557312, imaxpct=5
>>         =                       sunit=64     swidth=64 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=357696, version=2
>>         =                       sectsz=512   sunit=64 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Ok, that's interesting - a 1k inode size, and sunit=swidth=256k. But
> it doesn't cause a current kernel to reproduce the behaviour you are
> seeing....
> 
> sunit=256k is interesting, because:
> 
>>    0.067874 cpu=0 pid=41977 fallocate [285] entry fd=15 mode=0x1
>> offset=0x0 len=10240
>>    0.067980 cpu=0 pid=41977 block_rq_insert dev_t=0x04100030 wr=write
>> flags=SYNC sector=0xaec11a00 len=262144
> 
> That's a write which is rounded up to 256k.
> 
> BTW, that's a trace for a also a 10k fallocate, not 1k, but
> regardless it doesn't change behaviour on my TOT test kernel.
> 
>> I hope this helps but if there's any more I can provide I'll be
>> happy to do so.
> 
> It doesn't tell me what XFS is doing with the fallocate call.
> Providing the trace-cmd trace output from the FAQ might shed some
> light on it...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
