Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f42.google.com ([209.85.208.42]:33608 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbeJLPXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 11:23:22 -0400
Received: by mail-ed1-f42.google.com with SMTP id l14-v6so1661845edq.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Oct 2018 00:52:09 -0700 (PDT)
Received: from amb.local ([185.244.214.245])
        by smtp.gmail.com with ESMTPSA id j22-v6sm305650edr.96.2018.10.12.00.52.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 00:52:07 -0700 (PDT)
Subject: Re: repair: realloc(): invalid next size
References: <214be03d-9cc7-378b-3635-6fca3cdcb1dd@gmail.com>
 <81713fcb-915b-d408-83a6-0d98eb6de4b6@gmail.com>
From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Message-ID: <a5cd76a2-ef4c-300f-3764-b9b490ee73ea@gmail.com>
Date: Fri, 12 Oct 2018 09:52:06 +0200
MIME-Version: 1.0
In-Reply-To: <81713fcb-915b-d408-83a6-0d98eb6de4b6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: pl
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 09/10/2018 15:49, Arkadiusz Miśkiewicz wrote:
> On 08/10/2018 16:03, Arkadiusz Miśkiewicz wrote:
>>
>> Big fs, ton of small files, repair takes 36h until this happens:
>>
>> rebuilding directory inode 30363993060
>> rebuilding directory inode 30398868604
>> rebuilding directory inode 30414474627
>> rebuilding directory inode 30425006954
>> rebuilding directory inode 30447937553
>> rebuilding directory inode 30529556616
>> rebuilding directory inode 30537494728
>> rebuilding directory inode 30569826838
>> rebuilding directory inode 31060721895
>> Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>> Warning: recursive buffer locking at block 31060721776 detected
>> Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>> Warning: recursive buffer locking at block 31060721776 detected
>> Metadata corruption detected at 0x41f980, inode 0x73b5d00e7 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>> realloc(): invalid next size
>> Aborted
>>
>>
>> Fails somewhere in 0x41f9db <xfs_dir2_sf_verify+603>
[...]

> 
> gdb doesn't like my binary, not sure why yet

LTO patch that was merged into xfsprogs makes binary undebuggable with 
gdb (if it gets enabled and it is automatically in my setup).

Now back to main problem:

#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007ffff7ba7541 in __GI_abort () at abort.c:79
#2  0x00007ffff7c00458 in __libc_message (action=action@entry=do_abort, 
fmt=fmt@entry=0x7ffff7d0f400 "%s\n") at ../sysdeps/posix/libc_fatal.c:181
#3  0x00007ffff7c06dea in malloc_printerr (str=str@entry=0x7ffff7d0d6ce 
"realloc(): invalid next size") at malloc.c:5336
#4  0x00007ffff7c0b00c in _int_realloc (av=av@entry=0x7ffff7d46c40 
<main_arena>, oldp=oldp@entry=0x61930520, oldsize=oldsize@entry=96, 
nb=nb@entry=160) at malloc.c:4520
#5  0x00007ffff7c0c28b in __GI___libc_realloc (oldmem=0x61930530, 
bytes=140) at malloc.c:3214
#6  0x000000000044343a in kmem_realloc (ptr=0x61930530, new_size=140, 
flags=5) at kmem.c:90
#7  0x0000000000491dd7 in libxfs_idata_realloc (ip=0x50a95cd0, 
byte_diff=63, whichfork=0) at xfs_inode_fork.c:511
#8  0x0000000000485dc3 in xfs_dir2_sf_addname_easy (args=0x69ac0100, 
sfep=0x61930546, offset=44, new_isize=137) at xfs_dir2_sf.c:379
#9  0x0000000000485cff in xfs_dir2_sf_addname (args=0x69ac0100) at 
xfs_dir2_sf.c:339
#10 0x0000000000477705 in libxfs_dir_createname (tp=0x5b60a9d0, 
dp=0x50a95cd0, name=0x50ad5450, inum=31060721942, first=0x7fffffffdae8, 
dfops=0x7fffffffdaa0, total=45) at xfs_dir2.c:281
#11 0x0000000000427b1a in longform_dir2_rebuild (mp=0x7fffffffe180, 
ino=31060721895, ip=0x50a95cd0, irec=0x7fff2016f780, ino_offset=7, 
hashtab=0x8d9811e0) at phase6.c:1444
#12 0x000000000042a743 in longform_dir2_entry_check (mp=0x7fffffffe180, 
ino=31060721895, ip=0x50a95cd0, num_illegal=0x7fffffffdccc, 
need_dot=0x7fffffffdcd4, irec=0x7fff2016f780, ino_offset=7, 
hashtab=0x8d9811e0) at phase6.c:2481
#13 0x000000000042b7c7 in process_dir_inode (mp=0x7fffffffe180, agno=14, 
irec=0x7fff2016f780, ino_offset=7) at phase6.c:2983
#14 0x000000000042c4ff in traverse_function (wq=0x7fffffffde50, agno=14, 
arg=0x62c5ec20) at phase6.c:3254
#15 0x00000000004305fe in prefetch_ag_range (work=0x7fffffffde50, 
start_ag=0, end_ag=39, dirs_only=true, func=0x42c442 
<traverse_function>) at prefetch.c:964
#16 0x000000000043077e in do_inode_prefetch (mp=0x7fffffffe180, 
stride=0, func=0x42c442 <traverse_function>, check_cache=false, 
dirs_only=true) at prefetch.c:1027
#17 0x000000000042c5d3 in traverse_ags (mp=0x7fffffffe180) at phase6.c:3284
#18 0x000000000042c88a in phase6 (mp=0x7fffffffe180) at phase6.c:3372
#19 0x000000000043ebd8 in main (argc=3, argv=0x7fffffffe688) at 
xfs_repair.c:949


more at

https://ixion.pld-linux.org/~arekm/xfs-1/gdb1.txt

Have coredump, so can look for more details.
