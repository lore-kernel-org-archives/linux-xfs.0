Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1564C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 04:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCPEq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 00:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPEqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 00:46:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298D826C0E
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 21:46:22 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u5so490346plq.7
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 21:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678941981;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T5OXx/p+Nj3tJ7Fdewstm7hPu+m5R92pwiqA2/9znmQ=;
        b=Ecud0c8Jr5OYvaOwJo0isswUMYSMBQkPAlUlsjFf+o3Djgine6pVLVRcs7frf6ItHB
         M+kv5cHeokckGIRnGjq0fuaFt6fKzpxE2ONxn8xaMzJBukRQR/CJbxAsGi/RNZih+7FQ
         PwZBZBdvNKSTP32vH6puueIXGzzgTVjqa4mCTNscYkB+kQlnb9rsUGdZDjtef+iEcduo
         ryF98Z9TxqcT9HFdvCUi50H2coTj7AT4YvUaYs8x5Iu3RQBkPNy1lgxXX8HpJEGX9mgL
         CIAHNuTLfufXNvZ5lbKILkdaY+lf5aYT9dffU7XZlPl12KPWVSlJEvZOqhy59ulMG304
         Jhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678941981;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T5OXx/p+Nj3tJ7Fdewstm7hPu+m5R92pwiqA2/9znmQ=;
        b=ZI81lWEfIu7mBzpLuCG44Pp5kPaNc/7H/m0Q9owzIJamzrBw41a4gkPlrR5t+21LGZ
         VWfQ6v3BwIQWpKLtAd8c7h5zO96Svvn0yK+C/43ksf17Cj79Zr8d1qF7tF7PBO/tgaOb
         EaxJC5vK1bmXa/KhSQxuyXZWN4Mx706MBF3krnuIddGlyGu8SpnBZ9pK0QI4lfjrVoAI
         U0G76O3d5sPTDfUZXRJIbLgjgDZLsmJNPS2bYR/ZRy10R6VUjc69AfUEIugxIGQ/AIIn
         FPYJvb/a6WjtAPiiuaRrove59E+0BK8cjW1uq2YMMCv2B4VVBjcqbvFs3tnJBV9i79Wq
         DKaw==
X-Gm-Message-State: AO0yUKXYVmKrUoo6vZXyNPR5iislE1ktfgC99wsP7SJDD7iS1fsHebE5
        +tvtMmwx/DNCJYS46cwcK7U=
X-Google-Smtp-Source: AK7set8slYrg1Ev9qjtPG+PIyMgOAw15kUI9Se3gVSH/DCI/6xI9Pt1RzgHZOzZ1WjDE+Ddk8kgugg==
X-Received: by 2002:a17:90a:51c5:b0:23d:4a9e:868b with SMTP id u63-20020a17090a51c500b0023d4a9e868bmr2383614pjh.31.1678941981460;
        Wed, 15 Mar 2023 21:46:21 -0700 (PDT)
Received: from rh-tp ([2406:7400:63:469f:1474:7c59:3a57:aab6])
        by smtp.gmail.com with ESMTPSA id s1-20020a17090b070100b00234afca2498sm2164391pjz.28.2023.03.15.21.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 21:46:20 -0700 (PDT)
Date:   Thu, 16 Mar 2023 10:16:02 +0530
Message-Id: <871qlp8fsl.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error xfs_trans_cancel
In-Reply-To: <20230309172733.GD1637786@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:

Hi Darrick,

Thanks for your analysis and quick help on this.

>>
>> Hi Darrick,
>>
>> Please find the information collected from the system. We added some
>> debug logs and looks like it is exactly what is happening which you
>> pointed out.
>>
>> We added a debug kernel patch to get more info from the system which
>> you had requested [1]
>>
>> 1. We first breaked into emergency shell where root fs is first getting
>> mounted on /sysroot as "ro" filesystem. Here are the logs.
>>
>> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
>>          Mounting /sysroot...
>> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
>> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
>> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
>> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
>> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
>> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
>> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
>> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
>> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
>> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
>> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
>> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
>> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
>> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
>> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
>> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
>> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
>> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
>>
>> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
>> the huge value.
>
> Ok, so log recovery finds 3064909 and clears it...
>
>> [   17.801281] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:13
>> [   17.801287] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:14
>
> <snip the rest of these...>
>
>> [   17.844910] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:62
>> [   17.844916] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:63
>> [   17.886079] XFS (dm-0): Ending recovery (logdev: internal)
>> [  OK  ] Mounted /sysroot.
>> [  OK  ] Reached target Initrd Root File System.
>>
>>
>> 2. Then these are the logs from xfs_repair -n /dev/dm-0
>> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
>> printed in above xlog_recover_iunlink_ag() function.
>>
>> switch_root:/# xfs_repair -n /dev/dm-0
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
>
> ...yet here we find that 3064909 is still on the unlinked list?
>
> Just to confirm -- you ran xfs_repair -n after the successful recovery
> above, right?
>
Yes, that's right.

>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 2
>>         - agno = 1
>>         - agno = 3
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> Phase 7 - verify link counts...
>> would have reset inode 3064909 nlinks from 4294967291 to 2
>
> Oh now that's interesting.  Inode on unlinked list with grossly nonzero
> (but probably underflowed) link count.  That might explain why iunlink
> recovery ignores the inode.  Is inode 3064909 reachable via the
> directory tree?
>
> Would you mind sending me a metadump to play with?  metadump -ago would
> be best, if filenames/xattrnames aren't sensitive customer data.

Sorry about the delay.
I am checking for any permissions part internally.
Meanwhile - I can help out if you would like me to try anything.

>> No modify flag set, skipping filesystem flush and exiting.
>>
>>
>> 3. Then we exit from the shell for the system to continue booting.
>> Here it will continue.. Just pasting the logs where the warning gets
>> generated and some extra logs are getting printed for the same inode
>> with our patch.
>>
>>
>> it continues
>> ================
>> [  587.999113] ------------[ cut here ]------------
>> [  587.999121] WARNING: CPU: 48 PID: 2026 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
>> [  587.999185] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rfkill sunrpc xts pseries_rng vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi ibmveth scsi_transport_srp nvme nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
>> [  587.999215] CPU: 48 PID: 2026 Comm: in:imjournal Not tainted 6.2.0-rc8ssh+ #38
>> [  587.999219] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
>> [  587.999222] NIP:  c00800000065fa80 LR: c00800000065fa4c CTR: c000000000ea4d40
>> [  587.999226] REGS: c00000001aa83650 TRAP: 0700   Not tainted  (6.2.0-rc8ssh+)
>> [  587.999228] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24224842  XER: 00000000
>> [  587.999236] CFAR: c00800000065fa54 IRQMASK: 0
>> [  587.999236] GPR00: c00000004570b2c8 c00000001aa838f0 c008000000708300 0000000000000000
>> [  587.999236] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c00000000413faf0
>> [  587.999236] GPR08: 0000000000000000 c00000000413fba0 0000000000000000 fffffffffffffffd
>> [  587.999236] GPR12: 0000000000000040 c000004afeccd880 0000000000000000 0000000004000000
>> [  587.999236] GPR16: c00000001aa83b38 c00000001aa83a38 c00000001aa83a68 c000000035264c00
>> [  587.999236] GPR20: c00000004570b200 0000000000008000 c00000000886c400 00000000002ec44d
>> [  587.999236] GPR24: 000000000014040d 000000000000000d c000000051875400 00000000002ec44d
>> [  587.999236] GPR28: c000000035262c00 c00000004570b200 c00000008f2d8b90 000000000014040d
>> [  587.999272] NIP [c00800000065fa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
>> [  587.999327] LR [c00800000065fa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
>> [  587.999379] Call Trace:
>> [  587.999381] [c00000001aa838f0] [c00000008f2d8b90] 0xc00000008f2d8b90 (unreliable)
>> [  587.999385] [c00000001aa83910] [c008000000660094] xfs_iunlink+0x1bc/0x2c0 [xfs]
>> [  587.999438] [c00000001aa839d0] [c008000000664804] xfs_rename+0x69c/0xd10 [xfs]
>> [  587.999491] [c00000001aa83b10] [c00800000065e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
>> [  587.999544] [c00000001aa83ba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
>> [  587.999549] [c00000001aa83c90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
>> [  587.999553] [c00000001aa83de0] [c000000000580520] sys_rename+0x60/0x80
>> [  587.999557] [c00000001aa83e10] [c000000000033630] system_call_exception+0x150/0x3b0
>> [  587.999562] [c00000001aa83e50] [c00000000000c554] system_call_common+0xf4/0x258
>> [  587.999567] --- interrupt: c00 at 0x7fff96082e20
>> [  587.999569] NIP:  00007fff96082e20 LR: 00007fff95c45e24 CTR: 0000000000000000
>> [  587.999572] REGS: c00000001aa83e80 TRAP: 0c00   Not tainted  (6.2.0-rc8ssh+)
>> [  587.999575] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
>> [  587.999584] IRQMASK: 0
>> [  587.999584] GPR00: 0000000000000026 00007fff94f5d220 00007fff96207300 00007fff94f5d288
>> [  587.999584] GPR04: 0000000172b76b70 0000000000000000 0600000000000000 0000000000000002
>> [  587.999584] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [  587.999584] GPR12: 0000000000000000 00007fff94f666e0 0000000172b65930 0000000000000000
>> [  587.999584] GPR16: 0000000132fe7648 00007fff95c47ce0 0000000000000000 000000000000004c
>> [  587.999584] GPR20: 0000000000000082 00007fff94f5e3a0 00007fff94f5e398 00007fff880029b0
>> [  587.999584] GPR24: 0000000000000000 00007fff94f5e388 00007fff94f5e378 00007fff94f5e3b0
>> [  587.999584] GPR28: 00007fff95c60000 00007fff95c605e0 00007fff88000c10 00007fff94f5d288
>> [  587.999618] NIP [00007fff96082e20] 0x7fff96082e20
>> [  587.999620] LR [00007fff95c45e24] 0x7fff95c45e24
>> [  587.999622] --- interrupt: c00
>> [  587.999624] Code: 2c230000 4182002c e9230020 2fa90000 419e0020 38210020 e8010010 7c0803a6 4e800020 60000000 60000000 60000000 <0fe00000> 60000000 60000000 60000000
>> [  587.999637] ---[ end trace 0000000000000000 ]---
>> [  587.999640] xfs_iunlink_update_backref: next_agino: 3064909 cannot be found
>> [  587.999643] xfs_iunlink_insert_inode: Cannot find backref for agino:1311757, ip->i_ino:1311757, next_agino: 3064909 agno:0
>> [  587.999646] XFS (dm-0): Internal error xfs_trans_cancel at line 1097 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x9cc/0xd10 [xfs]
>>
>> ^^^ There are the extra info printing the next_agino to be the same
>> agino 3064909 for xfs_iunlink_lookup has failed.
>
> Yep, then runtime code encounters agi[0].unlinked[13] == 3064909, but
> doesn't find an xfs_inode in the cache for it, and shuts down the
> filesystem.
>

Sure, thanks for the info.

> --D
>
>>
>> [  587.999701] CPU: 48 PID: 2026 Comm: in:imjournal Tainted: G        W          6.2.0-rc8ssh+ #38
>> [  587.999705] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
>> [  587.999708] Call Trace:
>> [  587.999709] [c00000001aa838f0] [c000000000e87328] dump_stack_lvl+0x6c/0x9c (unreliable)
>> [  587.999715] [c00000001aa83920] [c008000000646a84] xfs_error_report+0x5c/0x80 [xfs]
>> [  587.999767] [c00000001aa83980] [c008000000676860] xfs_trans_cancel+0x178/0x1b0 [xfs]
>> [  587.999823] [c00000001aa839d0] [c008000000664b34] xfs_rename+0x9cc/0xd10 [xfs]
>> [  587.999876] [c00000001aa83b10] [c00800000065e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
>> [  587.999929] [c00000001aa83ba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
>> [  587.999933] [c00000001aa83c90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
>> [  587.999937] [c00000001aa83de0] [c000000000580520] sys_rename+0x60/0x80
>> [  587.999941] [c00000001aa83e10] [c000000000033630] system_call_exception+0x150/0x3b0
>> [  587.999945] [c00000001aa83e50] [c00000000000c554] system_call_common+0xf4/0x258
>> [  587.999950] --- interrupt: c00 at 0x7fff96082e20
>> [  587.999952] NIP:  00007fff96082e20 LR: 00007fff95c45e24 CTR: 0000000000000000
>> [  587.999955] REGS: c00000001aa83e80 TRAP: 0c00   Tainted: G        W           (6.2.0-rc8ssh+)
>> [  587.999958] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
>> [  587.999967] IRQMASK: 0
>> [  587.999967] GPR00: 0000000000000026 00007fff94f5d220 00007fff96207300 00007fff94f5d288
>> [  587.999967] GPR04: 0000000172b76b70 0000000000000000 0600000000000000 0000000000000002
>> [  587.999967] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [  587.999967] GPR12: 0000000000000000 00007fff94f666e0 0000000172b65930 0000000000000000
>> [  587.999967] GPR16: 0000000132fe7648 00007fff95c47ce0 0000000000000000 000000000000004c
>> [  587.999967] GPR20: 0000000000000082 00007fff94f5e3a0 00007fff94f5e398 00007fff880029b0
>> [  587.999967] GPR24: 0000000000000000 00007fff94f5e388 00007fff94f5e378 00007fff94f5e3b0
>> [  587.999967] GPR28: 00007fff95c60000 00007fff95c605e0 00007fff88000c10 00007fff94f5d288
>> [  588.000000] NIP [00007fff96082e20] 0x7fff96082e20
>> [  588.000002] LR [00007fff95c45e24] 0x7fff95c45e24
>> [  588.000004] --- interrupt: c00
>> [  588.012398] Core dump to |/usr/lib/systemd/systemd-coredump pipe failed
>> [  588.020328] XFS (dm-0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x190/0x1b0 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down filesystem.
>> [  588.020388] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
>>
>>
>> 4. Here is the patch diff which we used to collect the info.
>>
>> <patch>
>> =============
>>
>> root-> git diff
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 5808abab786c..86b8cab7f759 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1859,8 +1859,10 @@ xfs_iunlink_update_backref(
>>                 return 0;
>>
>>         ip = xfs_iunlink_lookup(pag, next_agino);
>> -       if (!ip)
>> +       if (!ip) {
>> +               pr_err("%s: next_agino: %u cannot be found\n", __func__, next_agino);
>>                 return -EFSCORRUPTED;
>> +       }
>>         ip->i_prev_unlinked = prev_agino;
>>         return 0;
>>  }
>> @@ -1935,8 +1937,11 @@ xfs_iunlink_insert_inode(
>>          * inode.
>>          */
>>         error = xfs_iunlink_update_backref(pag, agino, next_agino);
>> -       if (error)
>> +       if (error) {
>> +               pr_crit("%s: Cannot find backref for agino:%u, ip->i_ino:%llu, next_agino: %u agno:%u\n",
>> +                       __func__, agino, ip->i_ino, next_agino, pag->pag_agno);
>>                 return error;
>> +       }
>>
>>         if (next_agino != NULLAGINO) {
>>                 /*
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index fc61cc024023..035fc1eba871 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -825,6 +825,10 @@ xfs_log_mount_finish(
>>          */
>>         mp->m_super->s_flags |= SB_ACTIVE;
>>         xfs_log_work_queue(mp);
>> +       if (xlog_recovery_needed(log))
>> +               pr_crit("%s: Recovery needed is set\n", __func__);
>> +       else
>> +               pr_crit("%s: Recovery needed not set\n", __func__);
>>         if (xlog_recovery_needed(log))
>>                 error = xlog_recover_finish(log);
>>         mp->m_super->s_flags &= ~SB_ACTIVE;
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 322eb2ee6c55..6caa8147b443 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2696,8 +2696,13 @@ xlog_recover_iunlink_bucket(
>>                 ASSERT(VFS_I(ip)->i_nlink == 0);
>>                 ASSERT(VFS_I(ip)->i_mode != 0);
>>                 xfs_iflags_clear(ip, XFS_IRECOVERY);
>> -               agino = ip->i_next_unlinked;
>>
>> +               if (bucket == 13) {
>> +                       pr_crit("%s: bucket: %d, agino: %u, ino: %llu, iget ret: %d, previno:%llu, prev_agino:%u\n",
>> +                               __func__, bucket, agino, ip->i_ino, error, prev_ip ? prev_ip->i_ino : -1, prev_ip ? XFS_INO_TO_AGINO(mp, prev_ip->i_ino) : -1);
>> +               }
>> +
>> +               agino = ip->i_next_unlinked;
>>                 if (prev_ip) {
>>                         ip->i_prev_unlinked = prev_agino;
>>                         xfs_irele(prev_ip);
>> @@ -2789,8 +2794,11 @@ xlog_recover_iunlink_ag(
>>                          * bucket and remaining inodes on it unreferenced and
>>                          * unfreeable.
>>                          */
>> +                       pr_crit("%s: Failed in xlog_recover_iunlink_bucket %d\n", __func__, error);
>>                         xfs_inodegc_flush(pag->pag_mount);
>>                         xlog_recover_clear_agi_bucket(pag, bucket);
>> +               } else {
>> +                       pr_crit("%s: ran xlog_recover_iunlink_bucket for agi:%u, bucket:%d\n", __func__, pag->pag_agno, bucket);
>>                 }
>>         }
>>
>>
>> > That evidence will guide us towards a kernel patch.
>>
>> I can spend some more time to debug and understand on how to fix this.
>> But thought of sharing this info meanwhile and see if there are any
>> pointers on how to fix this in kernel.
>>
>> Let me know if any other info is needed. We haven't yet run xfs_repair
>> on the device w/o -n option.
>>
>> -ritesh
