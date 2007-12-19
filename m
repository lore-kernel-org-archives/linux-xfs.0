Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 16:38:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ0c9Rd005507
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 16:38:14 -0800
Date: Wed, 19 Dec 2007 11:38:52 +1100
Subject: Re: kernel oops on debian , 2.6.18-5
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <476790D5.6040205@univ-nantes.fr> <20071218123259.GL4396912@sgi.com> <4767DC20.1080406@univ-nantes.fr>
Message-ID: <op.t3j3221z3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <4767DC20.1080406@univ-nantes.fr>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>, David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Jacky Carimalo <jacky.carimalo@univ-nantes.fr>

On Wed, 19 Dec 2007 01:41:36 +1100, Yann Dupont  
<Yann.Dupont@univ-nantes.fr> wrote:

> David Chinner wrote:
>> On Tue, Dec 18, 2007 at 10:20:21AM +0100, Yann Dupont wrote:
>>
>>> Hello, we got a kernel oops, probably in xfs on a debian kernel.
>>>
>>> This volume is on SAN + device mapper.
>>> this is a 1 TB  volume. It was in service for more than 2 ou 3 years.
>>> There is a high humber of files on it, as this volume serves for a
>>> rsyncd, where 200+ servers sync their root filesystem on it every day.
>>>
>>> here is the oops :
>>>
>>> Dec 16 23:27:32 inchgower kernel: XFS internal error
>>> XFS_WANT_CORRUPTED_GOTO at line 1561 of file fs/xfs/xfs_alloc.c.   
>>> Caller
>>> 0xffffffff881857b7
>>> Dec 16 23:27:32 inchgower kernel:
>>> Dec 16 23:27:32 inchgower kernel: Call Trace:
>>> Dec 16 23:27:32 inchgower kernel:  [<ffffffff88183ec0>]
>>> :xfs:xfs_free_ag_extent+0x19f/0x67f
>>>
>>
>> corrupted freespace btree. what does xfs_check tell you about the
>> filesystem on dm-3?
>>
>>
> xfs_check tells me to run xfs_repair -L, the attempts to mount the FS
> to clear the logs ending in kernel oops.

[snip]

> Phase 4 - check for duplicate blocks...
>          - setting up duplicate extent list...
>          - check for inodes claiming duplicate blocks...
>          - agno = 0
>
> )
>
> And now the process seems stuck.
> There is no activity on the san disk ;
>
> a ps show this :
>
> root      7885  6466  7885  0    6 1447133 5660020 6 09:55 pts/0   
> 00:00:19 xfs_repair -L /dev/evms/DATAXFS2
> root      7885  6466 17190  0    6 1447133 5660020 6 10:16 pts/0   
> 00:00:00 xfs_repair -L /dev/evms/DATAXFS2
> root      7885  6466 17191  0    6 1447133 5660020 6 10:16 pts/0   
> 00:00:00 xfs_repair -L /dev/evms/DATAXFS2
> root      7885  6466 17192  0    6 1447133 5660020 6 10:16 pts/0   
> 00:00:00 xfs_repair -L /dev/evms/DATAXFS2
> root      7885  6466 17193  0    6 1447133 5660020 6 10:16 pts/0   
> 00:00:00 xfs_repair -L /dev/evms/DATAXFS2
> root      7885  6466 17194  0    6 1447133 5660020 6 10:16 pts/0   
> 00:00:00 xfs_repair -L /dev/evms/DATAXFS2
>
>
> and a strace this :
> inchgower:~# strace -fp 7885
> Process 17194 attached with 6 threads - interrupt to quit
> [pid 17191] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
> [pid 17192] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
> [pid 17193] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
> [pid 17194] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
> [pid 17190] futex(0x67e4f8, FUTEX_WAIT, 2, NULL
>
> Can I stop the process and start another version without risking  
> problems ?

Yes, you can stop and restart. In your scenario, run xfs_repair -P to
disable prefetch which is getting stuck.

Barry.
