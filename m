Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9031BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 13:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F21D64F47
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 13:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhCDNxz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241658AbhCDNxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 08:53:34 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F18C061574
        for <linux-xfs@vger.kernel.org>; Thu,  4 Mar 2021 05:52:54 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id u4so43329330lfs.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 05:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y+UlYRs2dmPEC9Oz+YSPtL0zhFKJLByiSkSdB8oDPYw=;
        b=bEStU4LjQ5W9BvaHTbZA420udCPivpRH6bXrbPnUEfHArXY27o6KxGL8xO9LBgwK2N
         JnnrqwXF4sojEdCqGcBr/WcQiy0IPRFA6Xya23jkkfbVrEF5QRzmtAB80UwevzFGS9d1
         gTEPMlk2L6UkeVOYIYocud9efiNDlHye61eqjYKkCWP+V9fClLkgum5sGYTNxT3rurNN
         Pgk/VPGB+yIQvke+C2wzWPLhJdIYwgwDRUOGw2LFAvDc0PsdkiJhvnWkMnOtP7kTrGmj
         CtoCuLytiUX47j6o1O2LJiinRW2qbCSwBig8bZQfOs0Jfh3rVq2qp+GYdokRpeoiFuwH
         1Tag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+UlYRs2dmPEC9Oz+YSPtL0zhFKJLByiSkSdB8oDPYw=;
        b=OycUFjzPsc83idy8HaxUfBQvPgY7GCIN2JOpvSd6PHi+ZR7LAy9rk5ZCZS05+dVgUG
         lc7SdCCsuyAh3KE3ZyforBXvKF0/TWSDAQSVv5BwFjP/2LJs3DnOzF7xsYY3VvfW+EoE
         PlxfmIMZ+ZV5rtHPA/dQ+fdaZNfX8irWK2bNxXggPSkEJw0WgnLOyCTqa0Mi8uNWXceP
         XzzsDIUdb831j51l/LJNNbuX0pXGN0H+F4MepTNby7Tb3wZsHG1vOfGQmfKHGSvGrQVe
         Sn0/X7gaEi4/Z84OCb5vhFW6toccgbnREF43nNRxqPK4MUSkeSG7JuB0J8d2QgFj+siK
         y43g==
X-Gm-Message-State: AOAM530eZpvr/plvPGnFYhb7OawgAW/mMzojtvS/6lyETWpbW1jP44CH
        aqibiqBqWWptEXyyOnb6OxJx9GOSA8A=
X-Google-Smtp-Source: ABdhPJzJxwPu7RQWLAVaTVqaPz8D+X5QUtADihBV17iAC5FI4n6RThNnbXFvzb2NbmBUjCaNmQnLRw==
X-Received: by 2002:a05:6512:39c5:: with SMTP id k5mr2314884lfu.478.1614865972588;
        Thu, 04 Mar 2021 05:52:52 -0800 (PST)
Received: from amb.lan (user-5-173-161-108.play-internet.pl. [5.173.161.108])
        by smtp.gmail.com with ESMTPSA id v9sm863070lfd.195.2021.03.04.05.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 05:52:51 -0800 (PST)
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Guy Lowe <gl@mega.co.nz>
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
 <20191108065627.GA6260@infradead.org>
 <c52e2515-272f-476e-7cfa-a2ef23c66b56@gmail.com>
 <20191127154353.GA9847@infradead.org>
 <7b5db9fd-7f40-bf43-e494-d6d95839c0f1@gmail.com>
 <20191127162646.GA12929@infradead.org>
 <1e301f27-f4d1-3005-c53c-5999dfd13658@gmail.com> <YEDVIxkxObgBA4YC@bfoster>
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Message-ID: <a743a294-236f-051b-8282-3386f1433111@gmail.com>
Date:   Thu, 4 Mar 2021 14:52:50 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEDVIxkxObgBA4YC@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: pl
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

W dniu 04.03.2021 o 13:40, Brian Foster pisze:
> On Wed, Mar 03, 2021 at 04:47:44PM +0100, Arkadiusz Miśkiewicz wrote:
>> W dniu 27.11.2019 o 17:26, Christoph Hellwig pisze:
>>> On Wed, Nov 27, 2019 at 05:25:20PM +0100, Arkadiusz Miśkiewicz wrote:
>>>> Hm, 5.3 but I saw this on 5.1.15, too. See below. (or did you mean 5.1
>>>> was with big changes?)
>>>
>>> I meant 5.1, sorry.
>>>
>>>> Probably it will be easier to just bisect and I plan to do that after
>>>> backup catches up with missing data (and it takes days).
>>>
>>> Thanks a lot!
>>>
>>
> 
> What kernel does the warning in the subject refer to? If v5.3, that
> looks like a delalloc physical allocation failure.

It was 5.3.8:
https://lore.kernel.org/linux-xfs/20191127154353.GA9847@infradead.org/T/

4.20.13 ok
5.1.15 bad
+ bisect results

> 
>> I didn't went far with this. It's not easy to reproduce and it seems
>> that 5 days of waiting for each git bisect step on 3 machines wasn't
>> enough to always catch bad state (or conditions that trigger the problem
>> didn't happen then). bisect log at the end of this mail.
>>
>>
>>
>> I also tested recent 5.11.0 to see if anything has changed but after few
>> days:
>>
>>> [773626.607012] ------------[ cut here ]------------
>>> [773626.607017] WARNING: CPU: 27 PID: 21938 at fs/xfs/libxfs/xfs_bmap.c:4586 xfs_bmapi_convert_delalloc+0x466/0x490 [xfs]
> 
> ... which looks the same as this one on v5.11.
> 
> The high level error scenario is that buffered writes have successfully
> performed delayed allocation, thus writes have succeeded ingesting data
> into the page cache. Some time later writeback occurs, attempts to
> convert delalloc blocks into physical extents and that real allocation
> fails. The fallout from this error is that we have to discard dirty
> pages (i.e. the page discard errors further down).
> 
> This generally should never occur. If it does, something could be
> inconsistent with regard to block reservation and physical free space
> accounting.
> 
> ...
>>> [773626.607304] Call Trace:
>>> [773626.607311]  xfs_map_blocks+0x1ed/0x440 [xfs]
>>> [773626.607378]  iomap_do_writepage+0x16d/0x7c0
>>> [773626.607382]  ? __mod_memcg_lruvec_state+0x21/0xe0
>>> [773626.607389]  write_cache_pages+0x195/0x3e0
>>> [773626.607396]  ? iomap_page_mkwrite_actor+0x70/0x70
>>> [773626.607403]  iomap_writepages+0x1c/0x40
>>> [773626.607406]  xfs_vm_writepages+0x61/0x80 [xfs]
>>> [773626.607472]  do_writepages+0x38/0x100
>>> [773626.607475]  ? __wb_calc_thresh+0x4b/0x130
>>> [773626.607478]  __writeback_single_inode+0x37/0x290
>>> [773626.607482]  writeback_sb_inodes+0x1fb/0x450
>>> [773626.607485]  wb_writeback+0xe8/0x2c0
>>> [773626.607488]  wb_workfn+0xe4/0x570
>>> [773626.607492]  process_one_work+0x218/0x3b0
>>> [773626.607496]  worker_thread+0x4d/0x3e0
>>> [773626.607498]  ? rescuer_thread+0x3c0/0x3c0
>>> [773626.607500]  kthread+0x11b/0x140
>>> [773626.607506]  ? __kthread_bind_mask+0x60/0x60
>>> [773626.607509]  ret_from_fork+0x22/0x30
>>> [773626.607517] ---[ end trace a8859bbc44aed5aa ]---
>>> [773626.607520] XFS (sdd1): page discard on page 000000003f3bd102, inode 0x34b0d7a87, offset 29847552.
>>> [773626.607545] XFS (sdd1): page discard on page 000000000b27cb4f, inode 0x34b0d7a87, offset 29851648.
>>> [773626.607564] XFS (sdd1): page discard on page 000000002b6c6656, inode 0x34b0d7a87, offset 29855744.
>>> [773626.607584] XFS (sdd1): page discard on page 0000000068fb9613, inode 0x34b0d7a87, offset 29859840.
>>> [773626.607603] XFS (sdd1): page discard on page 0000000087899aca, inode 0x34b0d7a87, offset 29863936.
>>> [773626.607621] XFS (sdd1): page discard on page 0000000064bfddfe, inode 0x34b0d7a87, offset 29868032.
>>> [773626.607640] XFS (sdd1): page discard on page 00000000e78d1795, inode 0x34b0d7a87, offset 29872128.
>>> [773626.607658] XFS (sdd1): page discard on page 000000005568f42b, inode 0x34b0d7a87, offset 29876224.
>>> [773626.607676] XFS (sdd1): page discard on page 00000000260f7761, inode 0x34b0d7a87, offset 29880320.
>>> [773626.607695] XFS (sdd1): page discard on page 00000000de9a8945, inode 0x34b0d7a87, offset 29884416.
>>> [773626.870475] sdd1: writeback error on inode 14144076423, offset 29843456, sector 6442630216
>>> [773629.283780] XFS (sdd1): Internal error xfs_trans_cancel at line 954 of file fs/xfs/xfs_trans.c.  Caller xfs_link+0x1bd/0x2b0 [xfs]
> 
> And then we end up with a dirty transaction cancel, which appears to be
> what actually shuts down the filesystem. It's not clear what exactly the
> cause of this is from the log output, but the above writeback errors
> suggest that perhaps it was a similar allocation failure associated with
> creating a directory entry after the transaction was already dirtied.

fs is out of free space indeed
/dev/sdd1        39T   39T   64M 100% /mnt/storage2

> 
> Can you report xfs_info, 'xfs_repair -n,' and 'xfs_db -c "freesp -s"
> ...' (or maybe even "freesp -s -d" depending on how much output it
> produces...) for this filesystem? 

$ xfs_info /mnt/storage2
meta-data=/dev/sdd1              isize=512    agcount=39,
agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0
         =                       reflink=0    bigtime=0
data     =                       bsize=4096   blocks=10248516859, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ xfs_db -c "freesp -s" /dev/sdd1
   from      to extents  blocks    pct
      1       1 1942417 1942417  19.12
      2       3 1371037 3258175  32.07
      4       7  805011 4014945  39.52
      8      15   72389  705619   6.94
     16      31    8063  158640   1.56
     32      63     976   36958   0.36
    128     255       4     753   0.01
    256     511      11    4115   0.04
    512    1023       7    4023   0.04
   1024    2047       7   11407   0.11
   2048    4095       2    6735   0.07
   4096    8191       1    4608   0.05
   8192   16383       1   11754   0.12
total free extents 4199926
total free blocks 10160149
average free extent size 2.41913

freesp -s -d:
http://ixion.pld-linux.org/~arekm/freesp.txt.gz

> Can you also describe the workload
> that eventually leads to this problem? 

This machine does only thing - rsnapshot (which is like 20 parallel
rsync + cp -al (hardlink) and rm -rf) on milions of small files (web
pages and maildir files).

I suspect the best next step to
> diagnose the problem is either to try and collect a tracepoint capture
> when the error occurs and/or if possible, produce a metadump of the fs
> for further investigation.

I'll do metadump (it will be ~50-60GB).

For now back to 4.19 on that machine.

I have two other machines doing similar job (parallel rsync only, no
hardlinking or rm -rf) which also tiggered this in the past but these
currently have free space and thus most likely that's why not hitting
this recently.

> 
> Brian
> 
>>> [773629.283920] CPU: 29 PID: 31348 Comm: cp Tainted: G        W   E   T 5.11.0-1 #1
>>> [773629.283923] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.0a 02/06/2018
>>> [773629.283924] Call Trace:
>>> [773629.283929]  dump_stack+0x6b/0x83
>>> [773629.283940]  xfs_trans_cancel+0x10d/0x130 [xfs]
>>> [773629.284015]  xfs_link+0x1bd/0x2b0 [xfs]
>>> [773629.284087]  xfs_vn_link+0x6e/0xc0 [xfs]
>>> [773629.284159]  vfs_link+0x28e/0x3c0
>>> [773629.284167]  do_linkat+0x24e/0x320
>>> [773629.284170]  __x64_sys_linkat+0x21/0x30
>>> [773629.284173]  do_syscall_64+0x33/0x80
>>> [773629.284179]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [773629.284187] RIP: 0033:0x7fcc5827a37e
>>> [773629.284190] Code: 48 8b 0d f5 0a 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 09 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c2 0a 0d 00 f7 d8 64 89 01 48
>>> [773629.284193] RSP: 002b:00007ffede14bac8 EFLAGS: 00000286 ORIG_RAX: 0000000000000109
>>> [773629.284196] RAX: ffffffffffffffda RBX: 0000000001d61dd0 RCX: 00007fcc5827a37e
>>> [773629.284198] RDX: 00000000ffffff9c RSI: 0000000001d61dd0 RDI: 00000000ffffff9c
>>> [773629.284200] RBP: 00000000ffffff9c R08: 0000000000000000 R09: 0000000000000000
>>> [773629.284202] R10: 0000000001d61930 R11: 0000000000000286 R12: 0000000001d61930
>>> [773629.284203] R13: 0000000001d61930 R14: 00000000ffffff9c R15: 0000000000000000
>>> [773629.284419] XFS (sdd1): xfs_do_force_shutdown(0x8) called from line 955 of file fs/xfs/xfs_trans.c. Return address = 00000000a8a1eaaa
>>> [773629.284425] XFS (sdd1): Corruption of in-memory data detected.  Shutting down filesystem
>>> [773629.284426] XFS (sdd1): Please unmount the filesystem and rectify the problem(s)
>>
>>
>>
>>
>>
>> Log from bisect:
>>
>>> 1fc1cd8399ab5541a488a7e47b2f21537dd76c2d is the first bad commit
>>> commit 1fc1cd8399ab5541a488a7e47b2f21537dd76c2d
>>> Merge: abf7c3d8ddea 6a613d24effc
>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date:   Thu Mar 7 10:11:41 2019 -0800
>>>
>>>     Merge branch 'for-5.1' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
>>>
>>>     Pull cgroup updates from Tejun Heo:
>>>
>>>      - Oleg's pids controller accounting update which gets rid of rcu delay
>>>        in pids accounting updates
>>>
>>>      - rstat (cgroup hierarchical stat collection mechanism) optimization
>>>
>>>      - Doc updates
>>>
>>>     * 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup:
>>>       cpuset: remove unused task_has_mempolicy()
>>>       cgroup, rstat: Don't flush subtree root unless necessary
>>>       cgroup: add documentation for pids.events file
>>>       Documentation: cgroup-v2: eliminate markup warnings
>>>       MAINTAINERS: Update cgroup entry
>>>       cgroup/pids: turn cgroup_subsys->free() into cgroup_subsys->release() to
>>> fix the accounting
>>>
>>>  Documentation/admin-guide/cgroup-v2.rst |  2 +-
>>>  Documentation/cgroup-v1/pids.txt        |  3 +++
>>>  MAINTAINERS                             |  5 +++--
>>>  include/linux/cgroup-defs.h             |  2 +-
>>>  include/linux/cgroup.h                  |  2 ++
>>>  kernel/cgroup/cgroup.c                  | 15 +++++++++------
>>>  kernel/cgroup/cpuset.c                  | 13 -------------
>>>  kernel/cgroup/pids.c                    |  4 ++--
>>>  kernel/cgroup/rstat.c                   | 10 ++++++----
>>>  kernel/exit.c                           |  1 +
>>>  10 files changed, 28 insertions(+), 29 deletions(-)
>>>
>>>
>>>
>>> git bisect start
>>> # good: [8fe28cb58bcb235034b64cbbb7550a8a43fd88be] Linux 4.20
>>> git bisect good 8fe28cb58bcb235034b64cbbb7550a8a43fd88be
>>> # bad: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
>>> git bisect bad e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd
>>> # good: [14dbfb417bd80c96ec700c7a8414bb6f5db7ecd2] Merge branch 'spi-5.1' into spi-next
>>> git bisect good 14dbfb417bd80c96ec700c7a8414bb6f5db7ecd2
>>> # bad: [b5dd0c658c31b469ccff1b637e5124851e7a4a1c] Merge branch 'akpm' (patches from Andrew)
>>> git bisect bad b5dd0c658c31b469ccff1b637e5124851e7a4a1c
>>> # good: [3478588b5136966c80c571cf0006f08e9e5b8f04] Merge branch 'locking-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>> git bisect good 3478588b5136966c80c571cf0006f08e9e5b8f04
>>> # skip: [da2577fe63f865cd9dc785a42c29c0071f567a35] Merge tag 'sound-5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
>>> git bisect skip da2577fe63f865cd9dc785a42c29c0071f567a35
>>> # skip: [593db80390cf40f1b9dcc790020d2edae87183fb] vmbus: Switch to use new generic UUID API
>>> git bisect skip 593db80390cf40f1b9dcc790020d2edae87183fb
>>> # good: [5a170e9e4c74bc7f9aa57861c90e5813d63bfdab] ALSA: i2c: Clean up with new procfs helpers
>>> git bisect good 5a170e9e4c74bc7f9aa57861c90e5813d63bfdab
>>> # good: [5a170e9e4c74bc7f9aa57861c90e5813d63bfdab] ALSA: i2c: Clean up with new procfs helpers
>>> git bisect good 5a170e9e4c74bc7f9aa57861c90e5813d63bfdab
>>> # good: [1c3816a194870e7a6622345dab7fb56c7d708613] ASoC: stm32: sai: add missing put_device()
>>> git bisect good 1c3816a194870e7a6622345dab7fb56c7d708613
>>> # good: [c5ba619247391527248c4a8fb27e68f7cece8d0d] ASoC: samsung: i2s: Change indentation in SAMSUNG_I2S_FMTS definition
>>> git bisect good c5ba619247391527248c4a8fb27e68f7cece8d0d
>>> # good: [c5ba619247391527248c4a8fb27e68f7cece8d0d] ASoC: samsung: i2s: Change indentation in SAMSUNG_I2S_FMTS definition
>>> git bisect good c5ba619247391527248c4a8fb27e68f7cece8d0d
>>> # good: [e402d24d884130ed308ff1d04fdababffcf0fa86] ARM: dts: meson8b: add the APB bus
>>> git bisect good e402d24d884130ed308ff1d04fdababffcf0fa86
>>> # good: [e402d24d884130ed308ff1d04fdababffcf0fa86] ARM: dts: meson8b: add the APB bus
>>> git bisect good e402d24d884130ed308ff1d04fdababffcf0fa86
>>> # good: [48a254d7ff729c71c06d73eb3c1929536283bb41] staging: rtl8188eu: cleanup comments in mlme_linux.c
>>> git bisect good 48a254d7ff729c71c06d73eb3c1929536283bb41
>>> # good: [542d0e583b7b366527175b2b5fc0aad262fa33b0] Merge tag 'devprop-5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
>>> git bisect good 542d0e583b7b366527175b2b5fc0aad262fa33b0
>>> # good: [67e79a6dc2664a3ef85113440e60f7aaca3c7815] Merge tag 'tty-5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
>>> git bisect good 67e79a6dc2664a3ef85113440e60f7aaca3c7815
>>> # bad: [1fc1cd8399ab5541a488a7e47b2f21537dd76c2d] Merge branch 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
>>> git bisect bad 1fc1cd8399ab5541a488a7e47b2f21537dd76c2d
>>
>> This last known "bad" is good starting point for bisecting again.
>>
>>> # good: [a9913f23f39f4aa74956587a03e78b758a10c314] Merge tag 'fs_for_v5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
>>> git bisect good a9913f23f39f4aa74956587a03e78b758a10c314
>>> # good: [f65e25e343cfc0e6f4db9a687c4085fad268325d] btrfs: Remove unnecessary casts in btrfs_read_root_item
>>> git bisect good f65e25e343cfc0e6f4db9a687c4085fad268325d
>>> # good: [16be1433737ee46f88da57d47f594c4fc1376538] xfs: make xfs_bmbt_to_iomap more useful
>>> git bisect good 16be1433737ee46f88da57d47f594c4fc1376538
>>> # good: [b1e243957e9b3ba8e820fb8583bdf18e7c737aa2] Merge tag 'for-5.1-part1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
>>> git bisect good b1e243957e9b3ba8e820fb8583bdf18e7c737aa2
>>> # good: [9e1fd794cb6bf813a40849a1fc236703bdcbc1a7] Merge tag 'xfs-5.1-merge-4' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
>>> git bisect good 9e1fd794cb6bf813a40849a1fc236703bdcbc1a7
>>> # good: [abf7c3d8ddea3b43fe758590791878e1fd88ac47] Merge branch 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
>>> git bisect good abf7c3d8ddea3b43fe758590791878e1fd88ac47
>>> # good: [05b71f6ffd182e3af3ac25ab811675d622d4ac2a] cgroup: add documentation for pids.events file
>>> git bisect good 05b71f6ffd182e3af3ac25ab811675d622d4ac2a
>>> # good: [6a613d24effcb875271b8a1c510172e2d6eaaee8] cpuset: remove unused task_has_mempolicy()
>>> git bisect good 6a613d24effcb875271b8a1c510172e2d6eaaee8
>>> # first bad commit: [1fc1cd8399ab5541a488a7e47b2f21537dd76c2d] Merge branch 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
>>
>>
>> If anyone else is bisecting then
>>
>> commit a9a3ed1eff3601b63aea4fb462d8b3b92c7c1e7e
>> Author: Borislav Petkov <bp@suse.de>
>> Date:   Wed Apr 22 18:11:30 2020 +0200
>>
>>     x86: Fix early boot crash on gcc-10, third try
>>
>>
>> and
>>
>> diff --git a/arch/x86/boot/compressed/kaslr_64.c
>> b/arch/x86/boot/compressed/kaslr_64.c
>> index 748456c365f4..90efa69132c4 100644
>> --- a/arch/x86/boot/compressed/kaslr_64.c
>> +++ b/arch/x86/boot/compressed/kaslr_64.c
>> @@ -30,7 +30,7 @@
>>  #include "../../mm/ident_map.c"
>>
>>  /* Used by pgtable.h asm code to force instruction serialization. */
>> -unsigned long __force_order;
>> +//unsigned long __force_order;
>>
>>  /* Used to track our page table allocation area. */
>>  struct alloc_pgt_data {
>>
>>
>> are needed to get kernel build and boot with modern toolchain.
>>
>> -- 
>> Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
>>
> 


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
