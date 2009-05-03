Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n434wn10081749 for <xfs@oss.sgi.com>; Sat, 2 May 2009 23:58:49 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D32A25B417
	for <xfs@oss.sgi.com>; Sat,  2 May 2009 21:58:50 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id oCWwWhIY4nUkZ7K9 for
	<xfs@oss.sgi.com>; Sat, 02 May 2009 21:58:50 -0700 (PDT)
Message-ID: <49FD2488.70503@sandeen.net>
Date: Sat, 02 May 2009 23:58:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>	<20090502101405.GA6145@fancy-poultry.org>	<a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>	<49FC9762.6010109@sandeen.net>
	<a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
In-Reply-To: <a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs@oss.sgi.com

Alexander Beregalov wrote:
> 2009/5/2 Eric Sandeen <sandeen@sandeen.net>:
>> Alexander Beregalov wrote:
>>> 2009/5/2 Heinz Diehl <htd@fancy-poultry.org>:
>>>> On 01.05.2009, Alexander Beregalov wrote:
>>>>
>>>>> # xfs_db -r /dev/sdc1
>>>>> xfs_db> frag
>>>>> actual 23805, ideal 22890, fragmentation factor 3.84%
>>>>> # xfs_fsr -v /dev/sdc1
>>>>> /mnt/c start inode=0
>>>>> ino=158
>>>>> extents before:3 after:1 DONE ino=158
>>>>>
>>>>>  then it hangs
>>>> I can't confirm this here on my systems:
>>>>
>>>> liesel:~ # uname -a
>>>> Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
>>> I have this problem on two x86_32 hosts.
>>> It runs for about a minute and then hangs.
>> echo w > /proc/sysrq-trigger
>> dmesg
>>
>> would show all the sleeping processes...
> It is the same as I posted already:

(trimming cc's)

Does this happen if you try to defrag a single file?  i.e. something like:

# for I in `seq 10 -1 0`; do
 dd if=/dev/zero of=fragfile bs=4k count=1 seek=$I conv=notrunc oflag=sync
done

# xfs_fsr fragfile

I'm guessing it requires some activity on the files that are being
defragmented, but maybe worth a test (the test passes fine for me, though).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
