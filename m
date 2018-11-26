Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45228 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbeK0He0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 02:34:26 -0500
Date: Mon, 26 Nov 2018 12:38:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/6] xfstests: add copy/dedupe/clone to fsx/fsstress
Message-ID: <20181126203855.GF6783@magnolia>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
 <20181119052251.GQ2279@dhcp-12-117.nay.redhat.com>
 <20181119104547.GR2279@dhcp-12-117.nay.redhat.com>
 <20181119163809.GX4235@magnolia>
 <20181123073301.GA2299@dhcp-12-149.nay.redhat.com>
 <20181124165921.GE6783@magnolia>
 <20181125161928.GM3889@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181125161928.GM3889@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 26, 2018 at 12:19:28AM +0800, Eryu Guan wrote:
> On Sat, Nov 24, 2018 at 08:59:21AM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 23, 2018 at 03:33:01PM +0800, Zorro Lang wrote:
> > > On Mon, Nov 19, 2018 at 08:38:09AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Nov 19, 2018 at 06:45:47PM +0800, Zorro Lang wrote:
> > > > > On Mon, Nov 19, 2018 at 01:22:52PM +0800, Zorro Lang wrote:
> > > > > > On Tue, Nov 13, 2018 at 03:39:37PM -0800, Darrick J. Wong wrote:
> > > > > > > Hi all,
> > > > > > > 
> > > > > > > This series adds to fsx support for FICLONERANGE, FIDEDUPERANGE, and
> > > > > > > copy_file_range.  It adds to fsstress support for copy_file_range.
> > > > > > > There are known failures in 4.20-rc2, particularly with copy_file_range,
> > > > > > > so these patches provide a fstests base for everyone to start/continue
> > > > > > > looking for bugs.
> > > > > > 
> > > > > > Hi Darrick,
> > > > > > 
> > > > > > Your patches triggered 2 new failures on g/091 and g/263, refer to [1]. I can't
> > > > > > reproduce these failures on original xfstests [2]. I saw you were talking about g/091
> > > > > > in #xfs. Are these two failures same issue?
> > > > 
> > > > Most probably.  Dave and I are still digging through all the new
> > > > failures that show up in g/091, g/263, and g/127 once clonerange starts
> > > > happening.
> > > 
> > > Hi Darrick,
> > > 
> > > I just tried NFS, [1] tested with original xfstests, [2] tested with your
> > > patches. Looks like your patches bring in new failures to NFS test:
> > > g/075, g/112 and g/127.
> > 
> > Uh... it would be much more helpful to send along the golden output
> > diffs that show where fsx went bad (as well as the nfs configuration),
> 
> I was testing against a loop-mount nfsv4.2 server. The diff is like
> 
> @@ -1,3 +1,46 @@
>  QA output created by 263
>  fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
>  fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> +Seed set to 1
> +skipping zero size read
> +truncating to largest ever: 0xe400
> +copying to largest ever: 0x1f400
> +cloning to largest ever: 0x70000
> +copy range: 0x4b000 to 0x64000 at 0x2800
> +do_copy_range:: Resource temporarily unavailable

Hmm, well, -EAGAIN isn't documented as a valid return code in the
manpage, but I guess it wouldn't hurt to retry.  For that matter, I
should probably amend do_copy_file_range to use syscall() so that we
don't pick up the glibc wrapper by the same name.

> +LOG DUMP (32 total operations):
> +1(  1 mod 256): SKIPPED (no operation)
> +2(  2 mod 256): SKIPPED (no operation)
> +3(  3 mod 256): SKIPPED (no operation)
> +4(  4 mod 256): TRUNCATE UP    from 0x0 to 0xe400
> +5(  5 mod 256): INSERT 0x6000 thru 0x17fff     (0x12000 bytes)
> +6(  6 mod 256): ZERO     0x91be thru 0x1edf5   (0x15c38 bytes)
> +7(  7 mod 256): WRITE    0x3ac00 thru 0x3cdff  (0x2200 bytes) HOLE
> +8(  8 mod 256): MAPREAD  0x36000 thru 0x3be19  (0x5e1a bytes)
> +9(  9 mod 256): MAPWRITE 0x73200 thru 0x7928c  (0x608d bytes)
> +10( 10 mod 256): MAPREAD  0x3d000 thru 0x3f9c2 (0x29c3 bytes)
> +11( 11 mod 256): COLLAPSE 0x2b000 thru 0x44fff (0x1a000 bytes)
> +12( 12 mod 256): PUNCH    0x495fa thru 0x5f28c (0x15c93 bytes)
> +13( 13 mod 256): FALLOC   0x2f42a thru 0x4a8f4 (0x1b4ca bytes) INTERIOR
> +14( 14 mod 256): ZERO     0x530b7 thru 0x5f28c (0xc1d6 bytes)
> +15( 15 mod 256): MAPWRITE 0x55e00 thru 0x70d6e (0x1af6f bytes)
> +16( 16 mod 256): READ     0x2e000 thru 0x38fff (0xb000 bytes)
> +17( 17 mod 256): COLLAPSE 0x3f000 thru 0x4efff (0x10000 bytes)
> +18( 18 mod 256): COPY 0x28000 thru 0x42fff     (0x1b000 bytes) to 0x4400 thru 0x1f3ff
> +19( 19 mod 256): COLLAPSE 0x2c000 thru 0x44fff (0x19000 bytes)
> +20( 20 mod 256): WRITE    0x54a00 thru 0x709ff (0x1c000 bytes) HOLE
> +21( 21 mod 256): READ     0x53000 thru 0x69fff (0x17000 bytes)
> +22( 22 mod 256): MAPWRITE 0x1f200 thru 0x394bb (0x1a2bc bytes)
> +23( 23 mod 256): MAPREAD  0x43000 thru 0x5a2d8 (0x172d9 bytes)
> +24( 24 mod 256): MAPWRITE 0x23000 thru 0x38812 (0x15813 bytes)
> +25( 25 mod 256): WRITE    0x47800 thru 0x587ff (0x11000 bytes)
> +26( 26 mod 256): CLONE 0x3000 thru 0x11fff     (0xf000 bytes) to 0x61000 thru 0x6ffff
> +27( 27 mod 256): READ     0x6c000 thru 0x6efff (0x3000 bytes)
> +28( 28 mod 256): DEDUPE 0x12000 thru 0x1dfff   (0xc000 bytes) to 0x4000 thru 0xffff
> +29( 29 mod 256): INSERT 0x31000 thru 0x32fff   (0x2000 bytes)
> +30( 30 mod 256): FALLOC   0x2deac thru 0x49915 (0x1ba69 bytes) INTERIOR
> +31( 31 mod 256): DEDUPE 0x6f000 thru 0x71fff   (0x3000 bytes) to 0x25000 thru 0x27fff
> +32( 32 mod 256): COPY 0x4b000 thru 0x63fff     (0x19000 bytes) to 0x2800 thru 0x1b7ff
> +Log of operations saved to "/mnt/test/junk.fsxops"; replay with --replay-ops
> +Correct content saved for comparison
> +(maybe hexdump "/mnt/test/junk" vs "/mnt/test/junk.fsxgood")
> 
> And it seems like that NFSv4 doesn't like clone_file_range if src and
> dst point to the same file.

How did you conclude that nfs4 doesn't it like clone_file_range if src
== dest?  Operation 26 in the fsxlog shows that it did such a clone and
succeeded.

--D

> Thanks,
> Eryu
> 
> > but yes, in general we found a lot of corruption problems and I only
> > sent off a pull request w/ the fixes just now.
> > 
> > (I've also been trying to reproduce the EFSCORRUPTED failure in
> > generic/127, but haven't been able to hit that yet...)
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > 
> > > [1]
> > > # ./check -nfs generic/075 generic/127 generic/112 generic/263 generic/091 generic/231 generic/499 generic/511 generic/469 generic/455 generic/456 generic/457  
> > > FSTYP         -- nfs
> > > PLATFORM      -- Linux/x86_64 xxxxx 4.18.0-xxxx
> > > MKFS_OPTIONS  -- xx.xxx.xxx.xx:/mnt/nfscratch
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 xx.xxx.xxx.xx:/mnt/nfscratch /mnt/scratch                                                                   
> > > 
> > > generic/075      7s
> > > generic/091      25s
> > > generic/112      7s
> > > generic/127      231s
> > > generic/231     [not run] disk quotas not supported by this filesystem type: nfs
> > > generic/263      11s
> > > generic/455     [not run] This test requires a valid $LOGWRITES_DEV
> > > generic/456     [not run] require xx.xxx.xxx.xx:/mnt/nfscratch to be valid block disk                                                                               
> > > generic/457     [not run] This test requires a valid $LOGWRITES_DEV
> > > generic/469     [failed, exit status 1]- output mismatch (see /home/xfstests/results//generic/469.out.bad)                                                                                    
> > >     --- tests/generic/469.out   2018-11-23 01:57:26.983507354 -0500
> > >     +++ /home/xfstests/results//generic/469.out.bad     2018-11-23 02:08:50.846429431 -0500
> > >     @@ -1,9 +1,14 @@
> > >      QA output created by 469
> > >      fsx --replay-ops fsxops.0
> > >     -fsx -y --replay-ops fsxops.0
> > >     -fsx --replay-ops fsxops.1
> > >     -fsx -y --replay-ops fsxops.1
> > >     -fsx --replay-ops fsxops.2
> > >     -fsx -y --replay-ops fsxops.2
> > >     ...
> > >     (Run 'diff -u tests/generic/469.out /home/xfstests/results//generic/469.out.bad'  to see the entire diff)                                                                                 
> > > generic/499     [not run] xfs_io fcollapse failed (old kernel/wrong fs?)
> > > generic/511     [not run] xfs_io fzero failed (old kernel/wrong fs?)
> > > Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/455 generic/456 generic/457 generic/469 generic/499 generic/511                                          
> > > Not run: generic/231 generic/455 generic/456 generic/457 generic/499 generic/511
> > > Failures: generic/469
> > > Failed 1 of 12 tests
> > > 
> > > [2]
> > > # ./check -nfs generic/075 generic/127 generic/112 generic/263 generic/091 generic/231 generic/499 generic/511 generic/469 generic/455 generic/456 generic/457  
> > > FSTYP         -- nfs
> > > PLATFORM      -- Linux/x86_64 xx.xxx.xxx.xx 4.18.0-xxx
> > > MKFS_OPTIONS  -- xx.xxx.xxx.xx:/mnt/nfscratch
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 xx.xxx.xxx.xx:/mnt/nfscratch /mnt/scratch                                                                   
> > > 
> > > generic/075 7s ... [failed, exit status 1]- output mismatch (see /home/xfstests/results//generic/075.out.bad)                                                                                 
> > >     --- tests/generic/075.out   2018-11-23 01:57:26.842506110 -0500
> > >     +++ /home/xfstests/results//generic/075.out.bad     2018-11-23 02:14:59.151610903 -0500
> > >     @@ -4,15 +4,4 @@
> > >      -----------------------------------------------
> > >      fsx.0 : -d -N numops -S 0
> > >      -----------------------------------------------
> > >     -
> > >     ------------------------------------------------
> > >     -fsx.1 : -d -N numops -S 0 -x
> > >     ------------------------------------------------
> > >     ...
> > >     (Run 'diff -u tests/generic/075.out /home/xfstests/results//generic/075.out.bad'  to see the entire diff)                                                                                 
> > > generic/091 25s ...  22s
> > > generic/112 7s ... [failed, exit status 1]- output mismatch (see /home/xfstests/results//generic/112.out.bad)                                                                                 
> > >     --- tests/generic/112.out   2018-11-23 01:57:26.857506242 -0500
> > >     +++ /home/xfstests/results//generic/112.out.bad     2018-11-23 02:15:21.703805589 -0500
> > >     @@ -4,15 +4,4 @@
> > >      -----------------------------------------------
> > >      fsx.0 : -A -d -N numops -S 0
> > >      -----------------------------------------------
> > >     -
> > >     ------------------------------------------------
> > >     -fsx.1 : -A -d -N numops -S 0 -x
> > >     ------------------------------------------------
> > >     ...
> > >     (Run 'diff -u tests/generic/112.out /home/xfstests/results//generic/112.out.bad'  to see the entire diff)
> > > generic/127 231s ... - output mismatch (see /home/xfstests/results//generic/127.out.bad)
> > >     --- tests/generic/127.out   2018-11-23 01:57:26.863506295 -0500
> > >     +++ /home/xfstests/results//generic/127.out.bad     2018-11-23 02:16:41.049490964 -0500
> > >     @@ -4,10 +4,50 @@
> > >      === FSX Light Mode, Memory Mapping ===
> > >      All 100000 operations completed A-OK!
> > >      === FSX Standard Mode, No Memory Mapping ===
> > >     -All 100000 operations completed A-OK!
> > >     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
> > >     +copy range: 0x17cf1 to 0x203e3 at 0x8c59
> > >     +do_copy_range:: Invalid argument
> > >     ...
> > >     (Run 'diff -u tests/generic/127.out /home/xfstests/results//generic/127.out.bad'  to see the entire diff)
> > > generic/231     [not run] disk quotas not supported by this filesystem type: nfs
> > > generic/263 11s ...  10s
> > > generic/455     [not run] This test requires a valid $LOGWRITES_DEV
> > > generic/456     [not run] require xx.xxx.xxx.xx:/mnt/nfscratch to be valid block disk
> > > generic/457     [not run] This test requires a valid $LOGWRITES_DEV
> > > generic/469     [failed, exit status 1]- output mismatch (see /home/xfstests/results//generic/469.out.bad)
> > >     --- tests/generic/469.out   2018-11-23 01:57:26.983507354 -0500
> > >     +++ /home/xfstests/results//generic/469.out.bad     2018-11-23 02:16:53.208596019 -0500
> > >     @@ -1,9 +1,14 @@
> > >      QA output created by 469   
> > >      fsx --replay-ops fsxops.0  
> > >     -fsx -y --replay-ops fsxops.0
> > >     -fsx --replay-ops fsxops.1  
> > >     -fsx -y --replay-ops fsxops.1
> > >     -fsx --replay-ops fsxops.2  
> > >     -fsx -y --replay-ops fsxops.2
> > >     ...
> > >     (Run 'diff -u tests/generic/469.out /home/xfstests/results//generic/469.out.bad'  to see the entire diff)
> > > generic/499     [not run] xfs_io fcollapse failed (old kernel/wrong fs?)
> > > generic/511     [not run] xfs_io fzero failed (old kernel/wrong fs?)
> > > Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/455 generic/456 generic/457 generic/469 generic/499 generic/511
> > > Not run: generic/231 generic/455 generic/456 generic/457 generic/499 generic/511
> > > Failures: generic/075 generic/112 generic/127 generic/469
> > > Failed 4 of 12 tests
> > > 
> > > > 
> > > > --D
> > > > 
> > > > > 
> > > > > And a g/127 failure can be reproduced sometimes, on XFS with "-m reflink=1,rmapbt=1 -b size=2048":
> > > > > # for ((i=0; i<10; i++));do echo "The ${i}th time"; ./check generic/127 || break;done
> > > > > ...
> > > > > ...
> > > > > The 2th time
> > > > > FSTYP         -- xfs (non-debug)
> > > > > PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc2
> > > > > MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 -b size=2048 /dev/mapper/fedora_ibm--x3650m4--10-xfscratch
> > > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/fedora_ibm--x3650m4--10-xfscratch /mnt/scratch
> > > > > 
> > > > > generic/127 1996s ... _check_xfs_filesystem: filesystem on /dev/mapper/fedora_ibm--x3650m4--10-xfstest is inconsistent (r)
> > > > > (see /home/git/xfstests/results//generic/127.full for details)
> > > > > _check_dmesg: something found in dmesg (see /home/git/xfstests/results//generic/127.dmesg)
> > > > > - output mismatch (see /home/git/xfstests/results//generic/127.out.bad)
> > > > >     --- tests/generic/127.out   2018-11-18 22:18:45.030651588 -0500
> > > > >     +++ /home/git/xfstests/results//generic/127.out.bad 2018-11-19 01:11:27.267582320 -0500
> > > > >     @@ -4,10 +4,20022 @@
> > > > >      === FSX Light Mode, Memory Mapping ===
> > > > >      All 100000 operations completed A-OK!
> > > > >      === FSX Standard Mode, No Memory Mapping ===
> > > > >     -All 100000 operations completed A-OK!
> > > > >     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
> > > > >     +insert range: 0x1000 to 0x3000
> > > > >     +do_insert_range: fallocate: Structure needs cleaning
> > > > >     ...
> > > > >     (Run 'diff -u tests/generic/127.out /home/git/xfstests/results//generic/127.out.bad'  to see the entire diff)
> > > > > Ran: generic/127
> > > > > Failures: generic/127
> > > > > Failed 1 of 1 tests
> > > > > 
> > > > > # cat results/generic/127.full
> > > > > _check_xfs_filesystem: filesystem on /dev/mapper/fedora_ibm--x3650m4--10-xfstest is inconsistent (r)                                                                                          
> > > > > *** xfs_repair -n output ***
> > > > > Phase 1 - find and verify superblock...
> > > > > Phase 2 - using internal log
> > > > >         - zero log...
> > > > >         - scan filesystem freespace and inode maps...
> > > > > sb_fdblocks 10479543, counted 10479553
> > > > >         - found root inode chunk
> > > > > Phase 3 - for each AG...
> > > > >         - scan (but don't clear) agi unlinked lists...
> > > > >         - process known inodes and perform inode discovery...
> > > > >         - agno = 0
> > > > >         - agno = 1
> > > > >         - agno = 2
> > > > >         - agno = 3
> > > > >         - process newly discovered inodes...
> > > > > Phase 4 - check for duplicate blocks...
> > > > >         - setting up duplicate extent list...
> > > > >         - check for inodes claiming duplicate blocks...
> > > > >         - agno = 0
> > > > >         - agno = 2
> > > > >         - agno = 3
> > > > >         - agno = 1
> > > > > No modify flag set, skipping phase 5
> > > > > Phase 6 - check inode connectivity...
> > > > >         - traversing filesystem ...
> > > > >         - traversal finished ...
> > > > >         - moving disconnected inodes to lost+found ...
> > > > > Phase 7 - verify link counts...
> > > > > No modify flag set, skipping filesystem flush and exiting.
> > > > > *** end xfs_repair output
> > > > > ...
> > > > > ...
> > > > > 
> > > > > # cat results/generic/127.dmesg
> > > > > [ 7251.338263] run fstests generic/127 at 2018-11-19 00:38:16
> > > > > [ 7820.117091] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_bmap.c, line: 5793
> > > > > [ 7820.126420] WARNING: CPU: 6 PID: 14304 at fs/xfs/xfs_message.c:93 asswarn+0x1c/0x1f [xfs]
> > > > > [ 7820.135552] Modules linked in: dm_flakey sunrpc intel_rapl xfs sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel libcrc32c kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_
> > > > > clmulni_intel iTCO_wdt iTCO_vendor_support intel_cstate igb ipmi_ssif intel_uncore ioatdma intel_rapl_perf rndis_host ipmi_si cdc_ether usbnet mii pcspkr i2c_i801 ipmi_devintf dca ipmi_msghan
> > > > > dler lpc_ich ext4 mbcache jbd2 sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel megaraid_sas wmi dm_mod                          
> > > > > [ 7820.188746] CPU: 6 PID: 14304 Comm: fsx Not tainted 4.20.0-rc2 #8
> > > > > [ 7820.195549] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012                                                                                     
> > > > > [ 7820.205988] RIP: 0010:asswarn+0x1c/0x1f [xfs]
> > > > > [ 7820.210857] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 c0 23 8f c1 48 89 fa 31 ff e8 06 fa ff ff <0f> 0b c3 66 66 66 66 90 48 89 f1 41 89 d0
> > > > > 48 c7 c6 c0 23 8f c1 48
> > > > > [ 7820.231815] RSP: 0018:ffff8881d0b07a18 EFLAGS: 00010282
> > > > > [ 7820.237649] RAX: 0000000000000000 RBX: 1ffff1103a160f4b RCX: 0000000000000000
> > > > > [ 7820.245605] RDX: dffffc0000000000 RSI: 000000000000000a RDI: ffffed103a160f35
> > > > > [ 7820.253571] RBP: ffff8881dc659100 R08: ffffed108ecbcf91 R09: ffffed108ecbcf90
> > > > > [ 7820.261537] R10: ffffed108ecbcf90 R11: ffff8884765e7c87 R12: ffff8881d0b07cc8
> > > > > [ 7820.269503] R13: ffff8881b7745700 R14: ffff8884631baea0 R15: 00000000ffffff8b
> > > > > [ 7820.277470] FS:  00007f1511511b80(0000) GS:ffff888476400000(0000) knlGS:0000000000000000
> > > > > [ 7820.286503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [ 7820.292918] CR2: 0000000000621000 CR3: 00000001df136001 CR4: 00000000000606e0
> > > > > [ 7820.300892] Call Trace:
> > > > > [ 7820.303672]  xfs_bmap_insert_extents+0x537/0x640 [xfs]
> > > > > [ 7820.309463]  ? xfs_bmap_collapse_extents+0x600/0x600 [xfs]
> > > > > [ 7820.315600]  ? find_held_lock+0x3a/0x1c0
> > > > > [ 7820.320034]  ? xfs_ilock+0x130/0x480 [xfs]
> > > > > [ 7820.324675]  ? xfs_insert_file_space+0x239/0x5a0 [xfs]
> > > > > [ 7820.330419]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 7820.335922]  xfs_insert_file_space+0x254/0x5a0 [xfs]
> > > > > [ 7820.341519]  ? xfs_collapse_file_space+0x680/0x680 [xfs]
> > > > > [ 7820.347507]  ? xfs_setattr_nonsize+0xf50/0xf50 [xfs]
> > > > > [ 7820.353051]  ? __lock_is_held+0xb4/0x140
> > > > > [ 7820.357439]  ? setattr_prepare+0xd6/0x620
> > > > > [ 7820.361969]  xfs_file_fallocate+0x304/0x6c0 [xfs]
> > > > > [ 7820.367277]  ? xfs_break_layouts+0x2f0/0x2f0 [xfs]
> > > > > [ 7820.372632]  ? __lock_is_held+0xb4/0x140
> > > > > [ 7820.377012]  ? lock_acquire+0x142/0x380
> > > > > [ 7820.381303]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 7820.386742]  ? rcu_sync_lockdep_assert+0x74/0xb0
> > > > > [ 7820.391898]  ? __sb_start_write+0x1b2/0x260
> > > > > [ 7820.396576]  vfs_fallocate+0x2b8/0x750
> > > > > [ 7820.400769]  ksys_fallocate+0x3c/0x80
> > > > > [ 7820.404863]  __x64_sys_fallocate+0x93/0xf0
> > > > > [ 7820.409438]  ? lockdep_hardirqs_on+0x37c/0x560
> > > > > [ 7820.414404]  do_syscall_64+0x9f/0x460
> > > > > [ 7820.418498]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > [ 7820.424139] RIP: 0033:0x7f1510a05027
> > > > > [ 7820.428131] Code: 7f 8e 2c 00 f7 d8 64 89 02 b8 ff ff ff ff eb ba 0f 1f 00 48 8d 05 c1 e9 2c 00 49 89 ca 8b 00 85 c0 75 10 b8 1d 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 41 55 49 89 cd 41 54 49 89 d4 55 89 f5
> > > > > [ 7820.449089] RSP: 002b:00007ffe87f51fb8 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> > > > > [ 7820.457541] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f1510a05027
> > > > > [ 7820.465505] RDX: 0000000000001000 RSI: 0000000000000020 RDI: 0000000000000003
> > > > > [ 7820.473472] RBP: 0000000000001000 R08: 0000000000000009 R09: 0000000000000001
> > > > > [ 7820.481439] R10: 0000000000002000 R11: 0000000000000246 R12: 0000000000001000
> > > > > [ 7820.489406] R13: 0000000000003000 R14: 0000000000002710 R15: 0000000000000000
> > > > > [ 7820.497387] irq event stamp: 32247142
> > > > > [ 7820.501479] hardirqs last  enabled at (32247141): [<ffffffffb77029d2>] console_unlock+0x672/0xc50
> > > > > [ 7820.511387] hardirqs last disabled at (32247142): [<ffffffffb74054d1>] trace_hardirqs_off_thunk+0x1a/0x1c
> > > > > [ 7820.522069] softirqs last  enabled at (32247138): [<ffffffffb92006a8>] __do_softirq+0x6a8/0xa1c
> > > > > [ 7820.531789] softirqs last disabled at (32247131): [<ffffffffb75b5431>] irq_exit+0x281/0x2d0
> > > > > [ 7820.541111] ---[ end trace e663047569bb2026 ]---
> > > > > [ 7820.546378] XFS (dm-2): Internal error XFS_WANT_CORRUPTED_GOTO at line 5793 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_insert_file_space+0x254/0x5a0 [xfs]
> > > > > [ 7820.562125] CPU: 6 PID: 14304 Comm: fsx Tainted: G        W         4.20.0-rc2 #8
> > > > > [ 7820.570479] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012
> > > > > [ 7820.580869] Call Trace:
> > > > > [ 7820.583605]  dump_stack+0x7c/0xc0
> > > > > [ 7820.587355]  xfs_bmap_insert_extents+0x560/0x640 [xfs]
> > > > > [ 7820.593145]  ? xfs_bmap_collapse_extents+0x600/0x600 [xfs]
> > > > > [ 7820.599275]  ? find_held_lock+0x3a/0x1c0
> > > > > [ 7820.603710]  ? xfs_ilock+0x130/0x480 [xfs]
> > > > > [ 7820.608351]  ? xfs_insert_file_space+0x239/0x5a0 [xfs]
> > > > > [ 7820.614091]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 7820.619593]  xfs_insert_file_space+0x254/0x5a0 [xfs]
> > > > > [ 7820.625191]  ? xfs_collapse_file_space+0x680/0x680 [xfs]
> > > > > [ 7820.631179]  ? xfs_setattr_nonsize+0xf50/0xf50 [xfs]
> > > > > [ 7820.636724]  ? __lock_is_held+0xb4/0x140
> > > > > [ 7820.641117]  ? setattr_prepare+0xd6/0x620
> > > > > [ 7820.645654]  xfs_file_fallocate+0x304/0x6c0 [xfs]
> > > > > [ 7820.650961]  ? xfs_break_layouts+0x2f0/0x2f0 [xfs]
> > > > > [ 7820.656316]  ? __lock_is_held+0xb4/0x140
> > > > > [ 7820.660697]  ? lock_acquire+0x142/0x380
> > > > > [ 7820.664987]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 7820.670434]  ? rcu_sync_lockdep_assert+0x74/0xb0
> > > > > [ 7820.675590]  ? __sb_start_write+0x1b2/0x260
> > > > > [ 7820.680266]  vfs_fallocate+0x2b8/0x750
> > > > > [ 7820.684459]  ksys_fallocate+0x3c/0x80
> > > > > [ 7820.688551]  __x64_sys_fallocate+0x93/0xf0
> > > > > [ 7820.693125]  ? lockdep_hardirqs_on+0x37c/0x560
> > > > > [ 7820.698088]  do_syscall_64+0x9f/0x460
> > > > > [ 7820.702180]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > [ 7820.707828] RIP: 0033:0x7f1510a05027
> > > > > [ 7820.711811] Code: 7f 8e 2c 00 f7 d8 64 89 02 b8 ff ff ff ff eb ba 0f 1f 00 48 8d 05 c1 e9 2c 00 49 89 ca 8b 00 85 c0 75 10 b8 1d 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 41 55 49 89 cd 41 54 49 89 d4 55 89 f5
> > > > > [ 7820.732770] RSP: 002b:00007ffe87f51fb8 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> > > > > [ 7820.741223] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f1510a05027
> > > > > [ 7820.749188] RDX: 0000000000001000 RSI: 0000000000000020 RDI: 0000000000000003
> > > > > [ 7820.757153] RBP: 0000000000001000 R08: 0000000000000009 R09: 0000000000000001
> > > > > [ 7820.765118] R10: 0000000000002000 R11: 0000000000000246 R12: 0000000000001000
> > > > > [ 7820.773084] R13: 0000000000003000 R14: 0000000000002710 R15: 0000000000000000
> > > > > [ 8205.957877] perf: interrupt took too long (4024 > 3995), lowering kernel.perf_event_max_sample_rate to 49000
> > > > > [ 8740.028504] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_bmap.c, line: 5793
> > > > > [ 8740.037622] WARNING: CPU: 1 PID: 14567 at fs/xfs/xfs_message.c:93 asswarn+0x1c/0x1f [xfs]
> > > > > [ 8740.046754] Modules linked in: dm_flakey sunrpc intel_rapl xfs sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel libcrc32c kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iTCO_wdt iTCO_vendor_support intel_cstate igb ipmi_ssif intel_uncore ioatdma intel_rapl_perf rndis_host ipmi_si cdc_ether usbnet mii pcspkr i2c_i801 ipmi_devintf dca ipmi_msghandler lpc_ich ext4 mbcache jbd2 sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel megaraid_sas wmi dm_mod
> > > > > [ 8740.099955] CPU: 1 PID: 14567 Comm: fsx Tainted: G        W         4.20.0-rc2 #8
> > > > > [ 8740.108309] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012
> > > > > [ 8740.118749] RIP: 0010:asswarn+0x1c/0x1f [xfs]
> > > > > [ 8740.123616] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 c0 23 8f c1 48 89 fa 31 ff e8 06 fa ff ff <0f> 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 c0 23 8f c1 48
> > > > > [ 8740.144576] RSP: 0018:ffff8881d0b07a18 EFLAGS: 00010282
> > > > > [ 8740.150410] RAX: 0000000000000000 RBX: 1ffff1103a160f4b RCX: 0000000000000000
> > > > > [ 8740.158375] RDX: dffffc0000000000 RSI: 000000000000000a RDI: ffffed103a160f35
> > > > > [ 8740.166340] RBP: ffff8881dc659100 R08: ffffed103cafcf91 R09: ffffed103cafcf90
> > > > > [ 8740.174306] R10: ffffed103cafcf90 R11: ffff8881e57e7c87 R12: ffff8881d0b07cc8
> > > > > [ 8740.182272] R13: ffff8881b7745700 R14: ffff8881dc24b560 R15: 00000000ffffff8b
> > > > > [ 8740.190239] FS:  00007f2f73e0bb80(0000) GS:ffff8881e5600000(0000) knlGS:0000000000000000
> > > > > [ 8740.199273] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [ 8740.205687] CR2: 00007f0fac93fb10 CR3: 00000001d8e92006 CR4: 00000000000606e0
> > > > > [ 8740.213653] Call Trace:
> > > > > [ 8740.216424]  xfs_bmap_insert_extents+0x537/0x640 [xfs]
> > > > > [ 8740.222214]  ? xfs_bmap_collapse_extents+0x600/0x600 [xfs]
> > > > > [ 8740.228348]  ? find_held_lock+0x3a/0x1c0
> > > > > [ 8740.232783]  ? xfs_ilock+0x130/0x480 [xfs]
> > > > > [ 8740.237423]  ? xfs_insert_file_space+0x239/0x5a0 [xfs]
> > > > > [ 8740.243166]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 8740.248668]  xfs_insert_file_space+0x254/0x5a0 [xfs]
> > > > > [ 8740.254265]  ? xfs_collapse_file_space+0x680/0x680 [xfs]
> > > > > [ 8740.260253]  ? xfs_setattr_nonsize+0xf50/0xf50 [xfs]
> > > > > [ 8740.265797]  ? __lock_is_held+0xb4/0x140
> > > > > [ 8740.270184]  ? setattr_prepare+0xd6/0x620
> > > > > [ 8740.274720]  xfs_file_fallocate+0x304/0x6c0 [xfs]
> > > > > [ 8740.280030]  ? xfs_break_layouts+0x2f0/0x2f0 [xfs]
> > > > > [ 8740.285383]  ? __lock_is_held+0xb4/0x140
> > > > > [ 8740.289764]  ? lock_acquire+0x142/0x380
> > > > > [ 8740.294054]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 8740.299492]  ? rcu_sync_lockdep_assert+0x74/0xb0
> > > > > [ 8740.304647]  ? __sb_start_write+0x1b2/0x260
> > > > > [ 8740.309323]  vfs_fallocate+0x2b8/0x750
> > > > > [ 8740.313527]  ksys_fallocate+0x3c/0x80
> > > > > [ 8740.317621]  __x64_sys_fallocate+0x93/0xf0
> > > > > [ 8740.322194]  ? lockdep_hardirqs_on+0x37c/0x560
> > > > > [ 8740.327150]  do_syscall_64+0x9f/0x460
> > > > > [ 8740.331243]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > [ 8740.336883] RIP: 0033:0x7f2f732ff027
> > > > > [ 8740.340876] Code: 7f 8e 2c 00 f7 d8 64 89 02 b8 ff ff ff ff eb ba 0f 1f 00 48 8d 05 c1 e9 2c 00 49 89 ca 8b 00 85 c0 75 10 b8 1d 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 41 55 49 89 cd 41 54 49 89 d4 55 89 f5
> > > > > [ 8740.361833] RSP: 002b:00007ffed5d41578 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> > > > > [ 8740.370276] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f2f732ff027
> > > > > [ 8740.378241] RDX: 0000000000001000 RSI: 0000000000000020 RDI: 0000000000000003
> > > > > [ 8740.386206] RBP: 0000000000001000 R08: 0000000000000009 R09: 0000000000000001
> > > > > [ 8740.394171] R10: 0000000000002000 R11: 0000000000000246 R12: 0000000000001000
> > > > > [ 8740.402135] R13: 0000000000003000 R14: 0000000000002710 R15: 0000000000000000
> > > > > [ 8740.410116] irq event stamp: 32889272
> > > > > [ 8740.414207] hardirqs last  enabled at (32889271): [<ffffffffb77029d2>] console_unlock+0x672/0xc50
> > > > > [ 8740.424113] hardirqs last disabled at (32889272): [<ffffffffb74054d1>] trace_hardirqs_off_thunk+0x1a/0x1c
> > > > > [ 8740.434795] softirqs last  enabled at (32889268): [<ffffffffb92006a8>] __do_softirq+0x6a8/0xa1c
> > > > > [ 8740.444506] softirqs last disabled at (32889261): [<ffffffffb75b5431>] irq_exit+0x281/0x2d0
> > > > > [ 8740.453820] ---[ end trace e663047569bb2027 ]---
> > > > > [ 8740.459097] XFS (dm-2): Internal error XFS_WANT_CORRUPTED_GOTO at line 5793 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_insert_file_space+0x254/0x5a0 [xfs]                              
> > > > > [ 8740.474842] CPU: 1 PID: 14567 Comm: fsx Tainted: G        W         4.20.0-rc2 #8
> > > > > [ 8740.483195] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012                                                                                     
> > > > > [ 8740.493594] Call Trace:
> > > > > [ 8740.496329]  dump_stack+0x7c/0xc0
> > > > > [ 8740.500079]  xfs_bmap_insert_extents+0x560/0x640 [xfs]
> > > > > [ 8740.505871]  ? xfs_bmap_collapse_extents+0x600/0x600 [xfs]
> > > > > [ 8740.512000]  ? find_held_lock+0x3a/0x1c0
> > > > > [ 8740.516437]  ? xfs_ilock+0x130/0x480 [xfs]
> > > > > [ 8740.521082]  ? xfs_insert_file_space+0x239/0x5a0 [xfs]
> > > > > [ 8740.526825]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 8740.532329]  xfs_insert_file_space+0x254/0x5a0 [xfs]
> > > > > [ 8740.537928]  ? xfs_collapse_file_space+0x680/0x680 [xfs]
> > > > > [ 8740.543918]  ? xfs_setattr_nonsize+0xf50/0xf50 [xfs]
> > > > > [ 8740.549462]  ? __lock_is_held+0xb4/0x140
> > > > > [ 8740.553846]  ? setattr_prepare+0xd6/0x620
> > > > > [ 8740.558385]  xfs_file_fallocate+0x304/0x6c0 [xfs]
> > > > > [ 8740.563698]  ? xfs_break_layouts+0x2f0/0x2f0 [xfs]
> > > > > [ 8740.569053]  ? __lock_is_held+0xb4/0x140
> > > > > [ 8740.573432]  ? lock_acquire+0x142/0x380
> > > > > [ 8740.577713]  ? rcu_read_lock_sched_held+0x114/0x130
> > > > > [ 8740.583160]  ? rcu_sync_lockdep_assert+0x74/0xb0
> > > > > [ 8740.588316]  ? __sb_start_write+0x1b2/0x260
> > > > > [ 8740.592992]  vfs_fallocate+0x2b8/0x750
> > > > > [ 8740.597184]  ksys_fallocate+0x3c/0x80
> > > > > [ 8740.601277]  __x64_sys_fallocate+0x93/0xf0
> > > > > [ 8740.605851]  ? lockdep_hardirqs_on+0x37c/0x560
> > > > > [ 8740.610813]  do_syscall_64+0x9f/0x460
> > > > > [ 8740.614906]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > [ 8740.620547] RIP: 0033:0x7f2f732ff027
> > > > > [ 8740.624540] Code: 7f 8e 2c 00 f7 d8 64 89 02 b8 ff ff ff ff eb ba 0f 1f 00 48 8d 05 c1 e9 2c 00 49 89 ca 8b 00 85 c0 75 10 b8 1d 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 41 55 49 89 cd
> > > > > 41 54 49 89 d4 55 89 f5
> > > > > [ 8740.645498] RSP: 002b:00007ffed5d41578 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> > > > > [ 8740.653941] RAX: ffffffffffffffda RBX: 0000000000002000 RCX: 00007f2f732ff027
> > > > > [ 8740.661906] RDX: 0000000000001000 RSI: 0000000000000020 RDI: 0000000000000003
> > > > > [ 8740.669870] RBP: 0000000000001000 R08: 0000000000000009 R09: 0000000000000001
> > > > > [ 8740.677837] R10: 0000000000002000 R11: 0000000000000246 R12: 0000000000001000
> > > > > [ 8740.685804] R13: 0000000000003000 R14: 0000000000002710 R15: 0000000000000000
> > > > > [ 9240.766303] XFS: Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 984
> > > > > [ 9240.774045] WARNING: CPU: 2 PID: 14814 at fs/xfs/xfs_message.c:93 asswarn+0x1c/0x1f [xfs]
> > > > > [ 9240.783176] Modules linked in: dm_flakey sunrpc intel_rapl xfs sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel libcrc32c kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iTCO_wdt iTCO_vendor_support intel_cstate igb ipmi_ssif intel_uncore ioatdma intel_rapl_perf rndis_host ipmi_si cdc_ether usbnet mii pcspkr i2c_i801 ipmi_devintf dca ipmi_msghandler lpc_ich ext4 mbcache jbd2 sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel megaraid_sas wmi dm_mod
> > > > > [ 9240.836381] CPU: 2 PID: 14814 Comm: umount Tainted: G        W         4.20.0-rc2 #8
> > > > > [ 9240.845027] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012
> > > > > [ 9240.855465] RIP: 0010:asswarn+0x1c/0x1f [xfs]
> > > > > [ 9240.860330] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 c0 23 8f c1 48 89 fa 31 ff e8 06 fa ff ff <0f> 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 c0 23 8f c1 48
> > > > > [ 9240.881289] RSP: 0018:ffff8881d0f37c70 EFLAGS: 00010286
> > > > > [ 9240.887123] RAX: 0000000000000000 RBX: ffff8881b7745980 RCX: 0000000000000000
> > > > > [ 9240.895089] RDX: dffffc0000000000 RSI: 000000000000000a RDI: ffffed103a1e6f80
> > > > > [ 9240.903046] RBP: ffff8881dc659100 R08: ffffed103cb3cf91 R09: ffffed103cb3cf90
> > > > > [ 9240.911002] R10: ffffed103cb3cf90 R11: ffff8881e59e7c87 R12: ffff8881b7745700
> > > > > [ 9240.918967] R13: 0000000000000002 R14: ffffffffc19e52e0 R15: 0000000000000002
> > > > > [ 9240.926933] FS:  00007f222baf4fc0(0000) GS:ffff8881e5800000(0000) knlGS:0000000000000000
> > > > > [ 9240.935964] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [ 9240.942379] CR2: 00007f222b6d0d50 CR3: 00000001c3f72003 CR4: 00000000000606e0
> > > > > [ 9240.950344] Call Trace:
> > > > > [ 9240.953130]  xfs_fs_destroy_inode+0x584/0x8e0 [xfs]
> > > > > [ 9240.958587]  dispose_list+0xfa/0x1d0
> > > > > [ 9240.962585]  evict_inodes+0x29e/0x390
> > > > > [ 9240.966679]  ? dispose_list+0x1d0/0x1d0
> > > > > [ 9240.970973]  generic_shutdown_super+0xac/0x330
> > > > > [ 9240.975937]  kill_block_super+0x94/0xe0
> > > > > [ 9240.980222]  deactivate_locked_super+0x82/0xd0
> > > > > [ 9240.985184]  deactivate_super+0x123/0x140
> > > > > [ 9240.989662]  ? get_super_exclusive_thawed+0x10/0x10
> > > > > [ 9240.995112]  ? rcu_is_watching+0x2c/0x80
> > > > > [ 9240.999499]  cleanup_mnt+0x9f/0x130
> > > > > [ 9241.003397]  task_work_run+0x10e/0x190
> > > > > [ 9241.007591]  exit_to_usermode_loop+0x136/0x160
> > > > > [ 9241.012555]  do_syscall_64+0x39d/0x460
> > > > > [ 9241.016745]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > [ 9241.022384] RIP: 0033:0x7f222ab37ea7
> > > > > [ 9241.026366] Code: f0 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ef 2b 00 f7 d8 64 89 01 48
> > > > > [ 9241.047324] RSP: 002b:00007ffd4fe12588 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> > > > > [ 9241.055777] RAX: 0000000000000000 RBX: 0000556846b3b2d0 RCX: 00007f222ab37ea7
> > > > > [ 9241.063733] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556846b44210
> > > > > [ 9241.071698] RBP: 0000000000000000 R08: 0000556846b43a70 R09: 00007ffd4fe10df0
> > > > > [ 9241.079663] R10: 0000000000000000 R11: 0000000000000246 R12: 0000556846b44210
> > > > > [ 9241.087629] R13: 00007f222b8de1a4 R14: 0000556846b3b4b0 R15: 00007ffd4fe127f8
> > > > > [ 9241.095609] irq event stamp: 7674
> > > > > [ 9241.099312] hardirqs last  enabled at (7673): [<ffffffffb77029d2>] console_unlock+0x672/0xc50
> > > > > [ 9241.108830] hardirqs last disabled at (7674): [<ffffffffb74054d1>] trace_hardirqs_off_thunk+0x1a/0x1c
> > > > > [ 9241.119128] softirqs last  enabled at (7670): [<ffffffffb92006a8>] __do_softirq+0x6a8/0xa1c
> > > > > [ 9241.128452] softirqs last disabled at (7663): [<ffffffffb75b5431>] irq_exit+0x281/0x2d0
> > > > > [ 9241.137379] ---[ end trace e663047569bb2028 ]---
> > > > > [ 9241.147301] XFS (dm-2): Unmounting Filesystem
> > > > > [ 9242.193993] XFS (dm-3): Unmounting Filesystem
> > > > > 
> > > > > # cat results/generic/127.out.bad
> > > > > QA output created by 127
> > > > > === FSX Light Mode, No Memory Mapping ===
> > > > > All 100000 operations completed A-OK!
> > > > > === FSX Light Mode, Memory Mapping ===
> > > > > All 100000 operations completed A-OK!
> > > > > === FSX Standard Mode, No Memory Mapping ===
> > > > > ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
> > > > > insert range: 0x1000 to 0x3000
> > > > > do_insert_range: fallocate: Structure needs cleaning
> > > > > LOG DUMP (96808 total operations):
> > > > > 96809( 41 mod 256): CLONE 0x23000 thru 0x24fff  (0x2000 bytes) to 0x2e000
> > > > > 96810( 42 mod 256): ZERO     0x1715e thru 0x2055b       (0x93fe bytes)
> > > > > 96811( 43 mod 256): TRUNCATE UP from 0x38000 to 0x3ff65
> > > > > 96812( 44 mod 256): READ     0xe132 thru 0x1a9a4        (0xc873 bytes)
> > > > > 96813( 45 mod 256): COPY 0x1349b thru 0x20acd   (0xd633 bytes) to 0x31aaa
> > > > > 96814( 46 mod 256): WRITE    0x2b405 thru 0x375ab       (0xc1a7 bytes)
> > > > > 96815( 47 mod 256): CLONE 0x18000 thru 0x1cfff  (0x5000 bytes) to 0x2a000
> > > > > 96816( 48 mod 256): CLONE 0x20000 thru 0x2cfff  (0xd000 bytes) to 0x2d000
> > > > > 96817( 49 mod 256): PUNCH    0x289e8 thru 0x367ed       (0xde06 bytes)
> > > > > 96818( 50 mod 256): COLLAPSE 0x7000 thru 0x9fff (0x3000 bytes)
> > > > > 96819( 51 mod 256): READ     0x18b36 thru 0x1b469       (0x2934 bytes)
> > > > > 96820( 52 mod 256): PUNCH    0x10b33 thru 0x1f25b       (0xe729 bytes)
> > > > > 96821( 53 mod 256): ZERO     0x352bc thru 0x3a2d7       (0x501c bytes)
> > > > > 96822( 54 mod 256): CLONE 0xa000 thru 0xdfff    (0x4000 bytes) to 0x19000
> > > > > 96823( 55 mod 256): FALLOC   0x2c454 thru 0x313f7       (0x4fa3 bytes) INTERIOR
> > > > > ....
> > > > > ....
> > > > > (too many lines)
> > > > > ....
> > > > > ....
> > > > > 96801( 33 mod 256): FALLOC   0x22d99 thru 0x2e95b       (0xbbc2 bytes) INTERIOR
> > > > > 96802( 34 mod 256): READ     0x3a8d6 thru 0x3d68a       (0x2db5 bytes)
> > > > > 96803( 35 mod 256): WRITE    0x29e18 thru 0x36a02       (0xcbeb bytes)
> > > > > 96804( 36 mod 256): COPY 0x22a95 thru 0x2f8fb   (0xce67 bytes) to 0x12f33
> > > > > 96805( 37 mod 256): PUNCH    0x752b thru 0x129a3        (0xb479 bytes)
> > > > > 96806( 38 mod 256): WRITE    0x1251c thru 0x15fd4       (0x3ab9 bytes)
> > > > > 96807( 39 mod 256): FALLOC   0x7882 thru 0x153d0        (0xdb4e bytes) INTERIOR
> > > > > 96808( 40 mod 256): INSERT 0x1000 thru 0x2fff   (0x2000 bytes)
> > > > > Log of operations saved to "/mnt/test/fsx_std_nommap.fsxops"; replay with --replay-ops
> > > > > Correct content saved for comparison
> > > > > (maybe hexdump "/mnt/test/fsx_std_nommap" vs "/mnt/test/fsx_std_nommap.fsxgood")
> > > > > === FSX Standard Mode, Memory Mapping ===
> > > > > All 100000 operations completed A-OK!
> > > > > 
> > > > > Thanks,
> > > > > Zorro
> > > > > 
> > > > > 
> > > > > > 
> > > > > > Thanks,
> > > > > > Zorro
> > > > > > 
> > > > > > [1]
> > > > > > # ./check --large-fs generic/075 generic/127 generic/112 generic/263 generic/091 generic/231 generic/499 generic/511 generic/469 generic/455 generic/456 generic/4
> > > > > > 57 xfs/207
> > > > > > FSTYP         -- xfs (non-debug)
> > > > > > PLATFORM      -- Linux/x86_64 hp-dl580g7-04 4.18.0-39.el8.x86_64
> > > > > > MKFS_OPTIONS  -- -f -b size=2048 /dev/mapper/VG500T-LV500T
> > > > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/VG500T-LV500T /mnt/scratch
> > > > > > 
> > > > > > generic/075      15s
> > > > > > generic/091     [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/091.out.bad)                                                                                
> > > > > >     --- tests/generic/091.out   2018-11-16 22:51:29.117927437 +0800
> > > > > >     +++ /root/git/xfstests/results//generic/091.out.bad 2018-11-19 11:18:21.618028378 +0800
> > > > > >     @@ -5,3 +5,31 @@
> > > > > >      fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
> > > > > >      fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
> > > > > >      fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
> > > > > >     +mapped writes DISABLED
> > > > > >     +Seed set to 1
> > > > > >     +skipping zero size read
> > > > > >     +truncating to largest ever: 0xe400
> > > > > >     ...
> > > > > >     (Run 'diff -u tests/generic/091.out /root/git/xfstests/results//generic/091.out.bad'  to see the entire diff)                                                                             
> > > > > > generic/112      16s
> > > > > > generic/127      225s
> > > > > > generic/231      179s
> > > > > > generic/263     [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/263.out.bad)                                                                                
> > > > > >     --- tests/generic/263.out   2018-11-16 22:51:29.172929902 +0800
> > > > > >     +++ /root/git/xfstests/results//generic/263.out.bad 2018-11-19 11:25:24.841385577 +0800
> > > > > >     @@ -1,3 +1,52 @@
> > > > > >      QA output created by 263
> > > > > >      fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> > > > > >      fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> > > > > >     +Seed set to 1
> > > > > >     +skipping zero size read
> > > > > >     +truncating to largest ever: 0xe400
> > > > > >     +fallocating to largest ever: 0x49915
> > > > > >     ...
> > > > > >     (Run 'diff -u tests/generic/263.out /root/git/xfstests/results//generic/263.out.bad'  to see the entire diff)                                                                             
> > > > > > generic/455      2024s
> > > > > > generic/456      27s
> > > > > > generic/457      350s
> > > > > > generic/469      1s
> > > > > > generic/499      26s
> > > > > > generic/511      2s
> > > > > > xfs/207  47s
> > > > > > Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/455 generic/456 generic/457 generic/469 generic/499 generic/511 xfs/207
> > > > > > Failures: generic/091 generic/263
> > > > > > Failed 2 of 13 tests
> > > > > > 
> > > > > > [2]
> > > > > > # ./check --large-fs generic/075 generic/127 generic/112 generic/263 generic/091 generic/231 generic/499 generic/511 generic/469 generic/455 generic/456 generic/457 xfs/207
> > > > > > FSTYP         -- xfs (non-debug)
> > > > > > PLATFORM      -- Linux/x86_64 hp-dl580g7-04 4.18.0-39.el8.x86_64
> > > > > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/VG500T-LV500T
> > > > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/VG500T-LV500T /mnt/scratch
> > > > > > 
> > > > > > generic/075 18s ...  17s
> > > > > > generic/091 24s ...  16s
> > > > > > generic/112 18s ...  18s
> > > > > > generic/127 267s ...  214s
> > > > > > generic/231 199s ...  198s
> > > > > > generic/263 10s ...  9s
> > > > > > generic/455      2728s
> > > > > > generic/456 27s ...  26s
> > > > > > generic/457      367s
> > > > > > generic/469 1s ...  2s
> > > > > > generic/499 27s ...  24s
> > > > > > generic/511      3s
> > > > > > xfs/207  47s
> > > > > > Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/455 generic/456 generic/457 generic/469 generic/499 generic/511 xfs/207
> > > > > > Passed all 13 tests
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > --D
