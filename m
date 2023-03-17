Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB34C6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 20:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCQUo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 16:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjCQUo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 16:44:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7EF42BC9
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 13:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56127B825BE
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 20:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB046C433D2;
        Fri, 17 Mar 2023 20:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679085858;
        bh=lK06MHJDzAou/zelt1xtTmnD9AcGjWWDeYLgfVmPp6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kOd268QpVDUPLGFkSnVcMNofn5DpICQYC7ay4/rufk2iIaLuoBEg+Co2FBMunUMK8
         NGZJeykcQL7Ip7WwsEomjTOAvxWvEYaBGs+eTjvNZBTFqU6R81TvnzWQF7snHR6MET
         /GDMT4U/Swdc8rrMrCY+7Y1CeoB1fPf3k9ts+Cv95+s0xdWKICt+ztTfiVyVXG1FFT
         K0ZZXBVJvjQOYe3nZFAYN7zb1YCJfmo8Ac4O7Ey6CySJ1TB2yzh0mMsgegsmywbcVf
         AGEeXydK1+iUtd1sI4r389eKwxVvQl3CYL7SUd5XkTYqJY4xoXjBvffoxibiaDq+IP
         LIDT59ks03TCw==
Date:   Fri, 17 Mar 2023 13:44:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Message-ID: <20230317204418.GQ11376@frogsfrogsfrogs>
References: <20230309172733.GD1637786@frogsfrogsfrogs>
 <871qlp8fsl.fsf@doe.com>
 <20230316052037.GJ11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fk0/ih0b2o7NZ+F/"
Content-Disposition: inline
In-Reply-To: <20230316052037.GJ11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--fk0/ih0b2o7NZ+F/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 15, 2023 at 10:20:37PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 16, 2023 at 10:16:02AM +0530, Ritesh Harjani wrote:
> > "Darrick J. Wong" <djwong@kernel.org> writes:
> > 
> > Hi Darrick,
> > 
> > Thanks for your analysis and quick help on this.
> > 
> > >>
> > >> Hi Darrick,
> > >>
> > >> Please find the information collected from the system. We added some
> > >> debug logs and looks like it is exactly what is happening which you
> > >> pointed out.
> > >>
> > >> We added a debug kernel patch to get more info from the system which
> > >> you had requested [1]
> > >>
> > >> 1. We first breaked into emergency shell where root fs is first getting
> > >> mounted on /sysroot as "ro" filesystem. Here are the logs.
> > >>
> > >> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
> > >>          Mounting /sysroot...
> > >> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
> > >> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
> > >> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
> > >> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
> > >> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
> > >> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
> > >> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
> > >> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
> > >> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
> > >> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
> > >> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
> > >> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
> > >> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
> > >> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
> > >> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
> > >> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
> > >> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
> > >> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
> > >>
> > >> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
> > >> the huge value.
> > >
> > > Ok, so log recovery finds 3064909 and clears it...
> > >
> > >> [   17.801281] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:13
> > >> [   17.801287] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:14
> > >
> > > <snip the rest of these...>
> > >
> > >> [   17.844910] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:62
> > >> [   17.844916] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:63
> > >> [   17.886079] XFS (dm-0): Ending recovery (logdev: internal)
> > >> [  OK  ] Mounted /sysroot.
> > >> [  OK  ] Reached target Initrd Root File System.
> > >>
> > >>
> > >> 2. Then these are the logs from xfs_repair -n /dev/dm-0
> > >> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
> > >> printed in above xlog_recover_iunlink_ag() function.
> > >>
> > >> switch_root:/# xfs_repair -n /dev/dm-0
> > >> Phase 1 - find and verify superblock...
> > >> Phase 2 - using internal log
> > >>         - zero log...
> > >>         - scan filesystem freespace and inode maps...
> > >> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
> > >
> > > ...yet here we find that 3064909 is still on the unlinked list?
> > >
> > > Just to confirm -- you ran xfs_repair -n after the successful recovery
> > > above, right?
> > >
> > Yes, that's right.
> > 
> > >>         - found root inode chunk
> > >> Phase 3 - for each AG...
> > >>         - scan (but don't clear) agi unlinked lists...
> > >>         - process known inodes and perform inode discovery...
> > >>         - agno = 0
> > >>         - agno = 1
> > >>         - agno = 2
> > >>         - agno = 3
> > >>         - process newly discovered inodes...
> > >> Phase 4 - check for duplicate blocks...
> > >>         - setting up duplicate extent list...
> > >>         - check for inodes claiming duplicate blocks...
> > >>         - agno = 0
> > >>         - agno = 2
> > >>         - agno = 1
> > >>         - agno = 3
> > >> No modify flag set, skipping phase 5
> > >> Phase 6 - check inode connectivity...
> > >>         - traversing filesystem ...
> > >>         - traversal finished ...
> > >>         - moving disconnected inodes to lost+found ...
> > >> Phase 7 - verify link counts...
> > >> would have reset inode 3064909 nlinks from 4294967291 to 2
> > >
> > > Oh now that's interesting.  Inode on unlinked list with grossly nonzero
> > > (but probably underflowed) link count.  That might explain why iunlink
> > > recovery ignores the inode.  Is inode 3064909 reachable via the
> > > directory tree?
> > >
> > > Would you mind sending me a metadump to play with?  metadump -ago would
> > > be best, if filenames/xattrnames aren't sensitive customer data.
> > 
> > Sorry about the delay.
> > I am checking for any permissions part internally.
> > Meanwhile - I can help out if you would like me to try anything.
> 
> Ok.  I'll try creating a filesystem with a weirdly high refcount
> unlinked inode and I guess you can try it to see if you get the same
> symptoms.  I've finished with my parent pointers work for the time
> being, so I might have some time tomorrow (after I kick the tires on
> SETFSUUID) to simulate this and see if I can adapt the AGI repair code
> to deal with this.

If you uncompress and mdrestore the attached file to a blockdev, mount
it, and run some creat() exerciser, do you get the same symptoms?  I've
figured out how to make online fsck deal with it. :)

A possible solution for runtime would be to make it so that
xfs_iunlink_lookup could iget the inode if it's not in cache at all.

--D

> --D
> 
> > >> No modify flag set, skipping filesystem flush and exiting.
> > >>
> > >>
> > >> 3. Then we exit from the shell for the system to continue booting.
> > >> Here it will continue.. Just pasting the logs where the warning gets
> > >> generated and some extra logs are getting printed for the same inode
> > >> with our patch.
> > >>
> > >>
> > >> it continues
> > >> ================
> > >> [  587.999113] ------------[ cut here ]------------
> > >> [  587.999121] WARNING: CPU: 48 PID: 2026 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> > >> [  587.999185] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rfkill sunrpc xts pseries_rng vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi ibmveth scsi_transport_srp nvme nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
> > >> [  587.999215] CPU: 48 PID: 2026 Comm: in:imjournal Not tainted 6.2.0-rc8ssh+ #38
> > >> [  587.999219] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
> > >> [  587.999222] NIP:  c00800000065fa80 LR: c00800000065fa4c CTR: c000000000ea4d40
> > >> [  587.999226] REGS: c00000001aa83650 TRAP: 0700   Not tainted  (6.2.0-rc8ssh+)
> > >> [  587.999228] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24224842  XER: 00000000
> > >> [  587.999236] CFAR: c00800000065fa54 IRQMASK: 0
> > >> [  587.999236] GPR00: c00000004570b2c8 c00000001aa838f0 c008000000708300 0000000000000000
> > >> [  587.999236] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c00000000413faf0
> > >> [  587.999236] GPR08: 0000000000000000 c00000000413fba0 0000000000000000 fffffffffffffffd
> > >> [  587.999236] GPR12: 0000000000000040 c000004afeccd880 0000000000000000 0000000004000000
> > >> [  587.999236] GPR16: c00000001aa83b38 c00000001aa83a38 c00000001aa83a68 c000000035264c00
> > >> [  587.999236] GPR20: c00000004570b200 0000000000008000 c00000000886c400 00000000002ec44d
> > >> [  587.999236] GPR24: 000000000014040d 000000000000000d c000000051875400 00000000002ec44d
> > >> [  587.999236] GPR28: c000000035262c00 c00000004570b200 c00000008f2d8b90 000000000014040d
> > >> [  587.999272] NIP [c00800000065fa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
> > >> [  587.999327] LR [c00800000065fa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
> > >> [  587.999379] Call Trace:
> > >> [  587.999381] [c00000001aa838f0] [c00000008f2d8b90] 0xc00000008f2d8b90 (unreliable)
> > >> [  587.999385] [c00000001aa83910] [c008000000660094] xfs_iunlink+0x1bc/0x2c0 [xfs]
> > >> [  587.999438] [c00000001aa839d0] [c008000000664804] xfs_rename+0x69c/0xd10 [xfs]
> > >> [  587.999491] [c00000001aa83b10] [c00800000065e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
> > >> [  587.999544] [c00000001aa83ba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
> > >> [  587.999549] [c00000001aa83c90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
> > >> [  587.999553] [c00000001aa83de0] [c000000000580520] sys_rename+0x60/0x80
> > >> [  587.999557] [c00000001aa83e10] [c000000000033630] system_call_exception+0x150/0x3b0
> > >> [  587.999562] [c00000001aa83e50] [c00000000000c554] system_call_common+0xf4/0x258
> > >> [  587.999567] --- interrupt: c00 at 0x7fff96082e20
> > >> [  587.999569] NIP:  00007fff96082e20 LR: 00007fff95c45e24 CTR: 0000000000000000
> > >> [  587.999572] REGS: c00000001aa83e80 TRAP: 0c00   Not tainted  (6.2.0-rc8ssh+)
> > >> [  587.999575] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
> > >> [  587.999584] IRQMASK: 0
> > >> [  587.999584] GPR00: 0000000000000026 00007fff94f5d220 00007fff96207300 00007fff94f5d288
> > >> [  587.999584] GPR04: 0000000172b76b70 0000000000000000 0600000000000000 0000000000000002
> > >> [  587.999584] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> > >> [  587.999584] GPR12: 0000000000000000 00007fff94f666e0 0000000172b65930 0000000000000000
> > >> [  587.999584] GPR16: 0000000132fe7648 00007fff95c47ce0 0000000000000000 000000000000004c
> > >> [  587.999584] GPR20: 0000000000000082 00007fff94f5e3a0 00007fff94f5e398 00007fff880029b0
> > >> [  587.999584] GPR24: 0000000000000000 00007fff94f5e388 00007fff94f5e378 00007fff94f5e3b0
> > >> [  587.999584] GPR28: 00007fff95c60000 00007fff95c605e0 00007fff88000c10 00007fff94f5d288
> > >> [  587.999618] NIP [00007fff96082e20] 0x7fff96082e20
> > >> [  587.999620] LR [00007fff95c45e24] 0x7fff95c45e24
> > >> [  587.999622] --- interrupt: c00
> > >> [  587.999624] Code: 2c230000 4182002c e9230020 2fa90000 419e0020 38210020 e8010010 7c0803a6 4e800020 60000000 60000000 60000000 <0fe00000> 60000000 60000000 60000000
> > >> [  587.999637] ---[ end trace 0000000000000000 ]---
> > >> [  587.999640] xfs_iunlink_update_backref: next_agino: 3064909 cannot be found
> > >> [  587.999643] xfs_iunlink_insert_inode: Cannot find backref for agino:1311757, ip->i_ino:1311757, next_agino: 3064909 agno:0
> > >> [  587.999646] XFS (dm-0): Internal error xfs_trans_cancel at line 1097 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x9cc/0xd10 [xfs]
> > >>
> > >> ^^^ There are the extra info printing the next_agino to be the same
> > >> agino 3064909 for xfs_iunlink_lookup has failed.
> > >
> > > Yep, then runtime code encounters agi[0].unlinked[13] == 3064909, but
> > > doesn't find an xfs_inode in the cache for it, and shuts down the
> > > filesystem.
> > >
> > 
> > Sure, thanks for the info.
> > 
> > > --D
> > >
> > >>
> > >> [  587.999701] CPU: 48 PID: 2026 Comm: in:imjournal Tainted: G        W          6.2.0-rc8ssh+ #38
> > >> [  587.999705] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
> > >> [  587.999708] Call Trace:
> > >> [  587.999709] [c00000001aa838f0] [c000000000e87328] dump_stack_lvl+0x6c/0x9c (unreliable)
> > >> [  587.999715] [c00000001aa83920] [c008000000646a84] xfs_error_report+0x5c/0x80 [xfs]
> > >> [  587.999767] [c00000001aa83980] [c008000000676860] xfs_trans_cancel+0x178/0x1b0 [xfs]
> > >> [  587.999823] [c00000001aa839d0] [c008000000664b34] xfs_rename+0x9cc/0xd10 [xfs]
> > >> [  587.999876] [c00000001aa83b10] [c00800000065e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
> > >> [  587.999929] [c00000001aa83ba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
> > >> [  587.999933] [c00000001aa83c90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
> > >> [  587.999937] [c00000001aa83de0] [c000000000580520] sys_rename+0x60/0x80
> > >> [  587.999941] [c00000001aa83e10] [c000000000033630] system_call_exception+0x150/0x3b0
> > >> [  587.999945] [c00000001aa83e50] [c00000000000c554] system_call_common+0xf4/0x258
> > >> [  587.999950] --- interrupt: c00 at 0x7fff96082e20
> > >> [  587.999952] NIP:  00007fff96082e20 LR: 00007fff95c45e24 CTR: 0000000000000000
> > >> [  587.999955] REGS: c00000001aa83e80 TRAP: 0c00   Tainted: G        W           (6.2.0-rc8ssh+)
> > >> [  587.999958] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
> > >> [  587.999967] IRQMASK: 0
> > >> [  587.999967] GPR00: 0000000000000026 00007fff94f5d220 00007fff96207300 00007fff94f5d288
> > >> [  587.999967] GPR04: 0000000172b76b70 0000000000000000 0600000000000000 0000000000000002
> > >> [  587.999967] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> > >> [  587.999967] GPR12: 0000000000000000 00007fff94f666e0 0000000172b65930 0000000000000000
> > >> [  587.999967] GPR16: 0000000132fe7648 00007fff95c47ce0 0000000000000000 000000000000004c
> > >> [  587.999967] GPR20: 0000000000000082 00007fff94f5e3a0 00007fff94f5e398 00007fff880029b0
> > >> [  587.999967] GPR24: 0000000000000000 00007fff94f5e388 00007fff94f5e378 00007fff94f5e3b0
> > >> [  587.999967] GPR28: 00007fff95c60000 00007fff95c605e0 00007fff88000c10 00007fff94f5d288
> > >> [  588.000000] NIP [00007fff96082e20] 0x7fff96082e20
> > >> [  588.000002] LR [00007fff95c45e24] 0x7fff95c45e24
> > >> [  588.000004] --- interrupt: c00
> > >> [  588.012398] Core dump to |/usr/lib/systemd/systemd-coredump pipe failed
> > >> [  588.020328] XFS (dm-0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x190/0x1b0 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down filesystem.
> > >> [  588.020388] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
> > >>
> > >>
> > >> 4. Here is the patch diff which we used to collect the info.
> > >>
> > >> <patch>
> > >> =============
> > >>
> > >> root-> git diff
> > >> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > >> index 5808abab786c..86b8cab7f759 100644
> > >> --- a/fs/xfs/xfs_inode.c
> > >> +++ b/fs/xfs/xfs_inode.c
> > >> @@ -1859,8 +1859,10 @@ xfs_iunlink_update_backref(
> > >>                 return 0;
> > >>
> > >>         ip = xfs_iunlink_lookup(pag, next_agino);
> > >> -       if (!ip)
> > >> +       if (!ip) {
> > >> +               pr_err("%s: next_agino: %u cannot be found\n", __func__, next_agino);
> > >>                 return -EFSCORRUPTED;
> > >> +       }
> > >>         ip->i_prev_unlinked = prev_agino;
> > >>         return 0;
> > >>  }
> > >> @@ -1935,8 +1937,11 @@ xfs_iunlink_insert_inode(
> > >>          * inode.
> > >>          */
> > >>         error = xfs_iunlink_update_backref(pag, agino, next_agino);
> > >> -       if (error)
> > >> +       if (error) {
> > >> +               pr_crit("%s: Cannot find backref for agino:%u, ip->i_ino:%llu, next_agino: %u agno:%u\n",
> > >> +                       __func__, agino, ip->i_ino, next_agino, pag->pag_agno);
> > >>                 return error;
> > >> +       }
> > >>
> > >>         if (next_agino != NULLAGINO) {
> > >>                 /*
> > >> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > >> index fc61cc024023..035fc1eba871 100644
> > >> --- a/fs/xfs/xfs_log.c
> > >> +++ b/fs/xfs/xfs_log.c
> > >> @@ -825,6 +825,10 @@ xfs_log_mount_finish(
> > >>          */
> > >>         mp->m_super->s_flags |= SB_ACTIVE;
> > >>         xfs_log_work_queue(mp);
> > >> +       if (xlog_recovery_needed(log))
> > >> +               pr_crit("%s: Recovery needed is set\n", __func__);
> > >> +       else
> > >> +               pr_crit("%s: Recovery needed not set\n", __func__);
> > >>         if (xlog_recovery_needed(log))
> > >>                 error = xlog_recover_finish(log);
> > >>         mp->m_super->s_flags &= ~SB_ACTIVE;
> > >> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > >> index 322eb2ee6c55..6caa8147b443 100644
> > >> --- a/fs/xfs/xfs_log_recover.c
> > >> +++ b/fs/xfs/xfs_log_recover.c
> > >> @@ -2696,8 +2696,13 @@ xlog_recover_iunlink_bucket(
> > >>                 ASSERT(VFS_I(ip)->i_nlink == 0);
> > >>                 ASSERT(VFS_I(ip)->i_mode != 0);
> > >>                 xfs_iflags_clear(ip, XFS_IRECOVERY);
> > >> -               agino = ip->i_next_unlinked;
> > >>
> > >> +               if (bucket == 13) {
> > >> +                       pr_crit("%s: bucket: %d, agino: %u, ino: %llu, iget ret: %d, previno:%llu, prev_agino:%u\n",
> > >> +                               __func__, bucket, agino, ip->i_ino, error, prev_ip ? prev_ip->i_ino : -1, prev_ip ? XFS_INO_TO_AGINO(mp, prev_ip->i_ino) : -1);
> > >> +               }
> > >> +
> > >> +               agino = ip->i_next_unlinked;
> > >>                 if (prev_ip) {
> > >>                         ip->i_prev_unlinked = prev_agino;
> > >>                         xfs_irele(prev_ip);
> > >> @@ -2789,8 +2794,11 @@ xlog_recover_iunlink_ag(
> > >>                          * bucket and remaining inodes on it unreferenced and
> > >>                          * unfreeable.
> > >>                          */
> > >> +                       pr_crit("%s: Failed in xlog_recover_iunlink_bucket %d\n", __func__, error);
> > >>                         xfs_inodegc_flush(pag->pag_mount);
> > >>                         xlog_recover_clear_agi_bucket(pag, bucket);
> > >> +               } else {
> > >> +                       pr_crit("%s: ran xlog_recover_iunlink_bucket for agi:%u, bucket:%d\n", __func__, pag->pag_agno, bucket);
> > >>                 }
> > >>         }
> > >>
> > >>
> > >> > That evidence will guide us towards a kernel patch.
> > >>
> > >> I can spend some more time to debug and understand on how to fix this.
> > >> But thought of sharing this info meanwhile and see if there are any
> > >> pointers on how to fix this in kernel.
> > >>
> > >> Let me know if any other info is needed. We haven't yet run xfs_repair
> > >> on the device w/o -n option.
> > >>
> > >> -ritesh

--fk0/ih0b2o7NZ+F/
Content-Type: application/x-xz
Content-Disposition: attachment; filename="ritesh.md.xz"
Content-Transfer-Encoding: base64

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
3AET3BxKscRn+wIAAAAABFla

--fk0/ih0b2o7NZ+F/--
