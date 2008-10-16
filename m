Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 23:38:14 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G6c9Uk029441
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 23:38:11 -0700
Message-ID: <48F6EF7F.4070008@sgi.com>
Date: Thu, 16 Oct 2008 17:38:39 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: another problem with latest code drops
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed>
In-Reply-To: <20081016060247.GF25906@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Oct 16, 2008 at 12:06:21PM +1000, Lachlan McIlroy wrote:
>> fsstress started reporting these errors
>>
>> fsstress: check_cwd failure
>> fsstress: check_cwd failure
>> fsstress: check_cwd failure
>> fsstress: check_cwd failure
>> fsstress: check_cwd failure
>> ...
>>
>> The filesystem is mounted on /mnt/data but the mount point is now toast.
>>
>> wipeout:/mnt # mount
>> ...
>> /dev/mapper/dm0 on /mnt/data type xfs (rw,logdev=/dev/ram0,nobarrier)
>>
>>
>> wipeout:/mnt # ls -alF
>> /bin/ls: data: Input/output error
>> total 4
>> drwxr-xr-x  6 root root   57 Aug  8 03:09 ./
>> drwxr-xr-x 21 root root 4096 Oct 15 11:56 ../
>> ?---------  0 root root    0 Dec 31  1969 data
>> drwxr-xr-x  2 root root    6 Jul 16 08:21 home/
> 
> I bet the filesystem has been shut down....
> 
> [snip]
> 
>> Oct 16 09:54:54 wipeout kernel: [79179.449760] Filesystem "dm-0": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff8118
>> d422
>> Oct 16 09:54:54 wipeout kernel: [79179.449773] Pid: 6679, comm: fsstress Not tainted 2.6.27-rc8 #192
>> Oct 16 09:54:54 wipeout kernel: [79179.449775] Oct 16 09:54:54 wipeout 
>> kernel: [79179.449775] Call Trace:
>> Oct 16 09:54:54 wipeout kernel: [79179.449784]  [<ffffffff81176d54>] xfs_error_report+0x3c/0x3e
>> Oct 16 09:54:54 wipeout kernel: [79179.449789]  [<ffffffff8118d422>] ? xfs_rename+0x703/0x745
>> Oct 16 09:54:54 wipeout kernel: [79179.449795]  [<ffffffff8118e9cb>] xfs_trans_cancel+0x5f/0xfc
>> Oct 16 09:54:54 wipeout kernel: [79179.449799]  [<ffffffff8118d422>] xfs_rename+0x703/0x745
>> Oct 16 09:54:54 wipeout kernel: [79179.449805]  [<ffffffff8119d4b2>] xfs_vn_rename+0x5d/0x61
>> Oct 16 09:54:54 wipeout kernel: [79179.449810]  [<ffffffff810ab449>] vfs_rename+0x2b2/0x42e
>> Oct 16 09:54:54 wipeout kernel: [79179.449815]  [<ffffffff810ad0f2>] sys_renameat+0x16d/0x1e3
>> Oct 16 09:54:54 wipeout kernel: [79179.449821]  [<ffffffff810a66d2>] ? sys_newstat+0x31/0x3c
>> Oct 16 09:54:54 wipeout kernel: [79179.449826]  [<ffffffff810ad17e>] sys_rename+0x16/0x18
>> Oct 16 09:54:54 wipeout kernel: [79179.449831]  [<ffffffff8100bf3b>] system_call_fastpath+0x16/0x1b
>> Oct 16 09:54:54 wipeout kernel: [79179.449835] Oct 16 09:54:54 wipeout 
> 
> Ah, yes. A shutdown in a directory transaction. Have you applied the
> fix to the directory block allocation transaction accounting that was one
> of the last patches I posted?
Yes, I checked that in yesterday and ran with it overnight.

> 
> If so, then there's some other problem in that code that we'll
> need a reproducable test case to be able to find....

I was running 8 copies of this command:
fsstress -p 64 -n 10000000 -d /mnt/data/fsstress.$i

I tried it again but this time the system ran out of memory
and locked up hard.  I couldn't see why though - maybe a memory
leak.
