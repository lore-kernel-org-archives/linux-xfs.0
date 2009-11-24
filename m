Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOGJc1a148424 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 10:19:38 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6F9B4C5E06
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 08:20:00 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id UZM4ss8lMRSQX4r3 for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 08:20:00 -0800 (PST)
Date: Tue, 24 Nov 2009 11:20:00 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Which kernel options should be enabled to find the root cause
	of this bug?
In-Reply-To: <4B0BF866.7040004@sandeen.net>
Message-ID: <alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0911240805490.25676@p34.internal.lan>
	<4B0BF866.7040004@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Tue, 24 Nov 2009, Eric Sandeen wrote:

> Justin Piszcz wrote:
>>
>>
>> On Sat, 17 Oct 2009, Justin Piszcz wrote:
>>
>>> Hello,
>>>
>>> I have a system I recently upgraded from 2.6.30.x and after
>>> approximately 24-48 hours--sometimes longer, the system cannot write
>>> any more files to disk (luckily though I can still write to /dev/shm)
>>> -- to which I have
>>> saved the sysrq-t and sysrq-w output:
>>>
>>> http://home.comcast.net/~jpiszcz/20091017/sysrq-w.txt
>>> http://home.comcast.net/~jpiszcz/20091017/sysrq-t.txt
>
> Unfortunately it looks like a lot of the sysrq-t, at least, was lost.
Yes, when this occurred the first few times, I can only grab whats in dmesg
to the ramdisk, trying to access any file system other than the ramdisk
(tmpfs) /dev/shm, will cause the process to be locked.

>
> The sysrq-w trace has the "show blocked state" start a ways down the file,
> for anyone playing along at home ;)
>
> Other things you might try are a sysrq-m to get memory state...
I actually performed most of the useful sysrq-commands, please see
the following:

wget http://home.comcast.net/~jpiszcz/20091018/dmesg.txt
wget http://home.comcast.net/~jpiszcz/20091018/interrupts.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-l.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-m.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-p.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-q.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-t.txt
wget http://home.comcast.net/~jpiszcz/20091018/sysrq-w.txt

>
>>> Configuration:
>>>
>>> $ cat /proc/mdstat Personalities : [raid1] [raid6] [raid5] [raid4] md1
>>> : active raid1 sdb2[1] sda2[0]
>>>      136448 blocks [2/2] [UU]
>>>
>>> md2 : active raid1 sdb3[1] sda3[0]
>>>      129596288 blocks [2/2] [UU]
>>>
>>> md3 : active raid5 sdj1[7] sdi1[6] sdh1[5] sdf1[3] sdg1[4] sde1[2]
>>> sdd1[1] sdc1[0]
>>>      5128001536 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]
>>>
>>> md0 : active raid1 sdb1[1] sda1[0]
>>>      16787776 blocks [2/2] [UU]
>>>
>>> $ mount
>>> /dev/md2 on / type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144)
>>> tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
>>> proc on /proc type proc (rw,noexec,nosuid,nodev)
>>> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
>>> udev on /dev type tmpfs (rw,mode=0755)
>>> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
>>> devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
>>> /dev/md1 on /boot type ext3 (rw,noatime)
>>> /dev/md3 on /r/1 type xfs
>>> (rw,noatime,nobarrier,logbufs=8,logbsize=262144)
>>> rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
>>> nfsd on /proc/fs/nfsd type nfsd (rw)
>
> Do you get the same behavior if you don't add the log options at mount time?
I have not tried disabling the log options, although they have been in effect
for a long time, (the logsbufs and bufsize and recently) the nobarrier
support.  Could there be an issue using -o nobarrier on a raid1+xfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
