Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F02A07F60
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 12:25:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C184D304032
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 10:24:58 -0700 (PDT)
Received: from mail1.bemta7.messagelabs.com (mail1.bemta7.messagelabs.com
	[216.82.254.108]) by cuda.sgi.com with ESMTP id
	zExr92e3S242SFJi (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jul 2015 10:24:55 -0700 (PDT)
From: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>
Subject: RE: XFS File system in trouble
Date: Sat, 18 Jul 2015 17:23:27 +0000
Message-ID: <03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
In-Reply-To: <55AA5FCE.4080702@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>, "'lrhorer@mygrande.net'" <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: Saturday, July 18, 2015 9:17 AM
To: Rhorer, Leslie; 'lrhorer@mygrande.net'; xfs@oss.sgi.com
Subject: Re: XFS File system in trouble

On 7/17/15 9:46 PM, Rhorer, Leslie wrote:
>> I have a 24T XFS file system that is very sick, and seemingly getting 
>> sicker. I believe it to be the file system itself. I have replaced the 
>> RAID chassis, the OS, the cables, the drive controller, and most of 
>> the drives. Re-syncing the RAID array complete in a reasonable time, 
>> given the size of the array, and reports no mismatches.
>> Xfs_repair completes, usually with no errors found, or sometimes one 
>> or two errors. Some commands, like a df, are now hanging. Writes are 
>> often failing with I/O errors. I haven't found any amount of obvious 
>> file corruption, but performing a CRC check using md5sum, md6sum, 
>> sha256sum, etc., come up with different values every time they are run 
>> on many large files. What can I do to try to rectify this?

>If writes fail with I/O errors, that should show up in dmesg, but I don't see any such messages.

	I had rebooted.  Here is an example:

RAID-Server:/RAID/Server-Main/Equipment/Drive Controllers/HighPoint Adapters/Rocket 2722/Driver# tar -xzvf RR_27xx.tar.gz 

It works for a while, because some of the directories already exist, but when it started to try to create directories, it started getting FS errors and I had to wind up rebooting.  After reboot, I get the following when I try to run the command from the directory again:

[  380.556635] XFS (md0): xfs_iread: validation failed for inode 124656869424 failed
[  380.556644] ffff8800b514c000: 49 4e 00 00 03 02 00 00 00 30 00 70 00 00 03 e8  IN.......0.p....
[  380.556648] ffff8800b514c010: 00 00 00 00 06 20 b0 6f 01 2e 00 00 00 00 00 16  ..... .o........
[  380.556652] ffff8800b514c020: 01 57 37 fd 2b 5d 22 9e 1e 0a 61 8c 00 00 00 20  .W7.+]"...a.... 
[  380.556655] ffff8800b514c030: ff ff 00 d2 1b f6 27 90 00 00 00 00 00 00 00 00  ......'.........
[  380.556684] XFS (md0): Internal error xfs_iread at line 392 of file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_inode_buf.c.  Caller xfs_iget+0x24b/0x690 [xfs]
[  380.556690] CPU: 5 PID: 4981 Comm: tar Not tainted 3.16.0-4-amd64 #1 Debian 3.16.7-ckt11-1
[  380.556694] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 1503 01/11/2013
[  380.556697]  0000000000000001 ffffffff8150b405 ffff8802333a6000 ffffffffa066e5cb
[  380.556703]  0000018800000010 ffffffffa0673f6b ffff8800a8464400 ffff8802333a6000
[  380.556708]  0000000000000075 ffff8800b58accc8 ffffffffa06b9b3a ffffffffa0673f6b
[  380.556714] Call Trace:
[  380.556732]  [<ffffffff8150b405>] ? dump_stack+0x41/0x51
[  380.556738]  [<ffffffffa066e5cb>] ? xfs_corruption_error+0x5b/0x80 [xfs]
[  380.556744]  [<ffffffffa0673f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[  380.556752]  [<ffffffffa06b9b3a>] ? xfs_iread+0xea/0x400 [xfs]
[  380.556757]  [<ffffffffa0673f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[  380.556762]  [<ffffffffa0673f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[  380.556770]  [<ffffffffa06b3de6>] ? xfs_ialloc+0xa6/0x500 [xfs]
[  380.556776]  [<ffffffffa068358e>] ? kmem_zone_alloc+0x6e/0xe0 [xfs]
[  380.556783]  [<ffffffffa06b42a2>] ? xfs_dir_ialloc+0x62/0x2a0 [xfs]
[  380.556789]  [<ffffffffa06821e5>] ? xfs_trans_reserve+0x1f5/0x200 [xfs]
[  380.556796]  [<ffffffffa06b49a9>] ? xfs_create+0x489/0x700 [xfs]
[  380.556799]  [<ffffffff811b40ea>] ? kern_path_create+0xaa/0x190
[  380.556805]  [<ffffffffa06795ea>] ? xfs_generic_create+0xca/0x250 [xfs]
[  380.556807]  [<ffffffff811b7ad0>] ? vfs_mkdir+0xb0/0x160
[  380.556808]  [<ffffffff811b868b>] ? SyS_mkdirat+0xab/0xe0
[  380.556811]  [<ffffffff815115cd>] ? system_call_fast_compare_end+0x10/0x15
[  380.556812] XFS (md0): Corruption detected. Unmount and run xfs_repair
[  380.556822] XFS (md0): Internal error xfs_trans_cancel at line 959 of file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_trans.c.  Caller xfs_create+0x2b2/0x700 [xfs]
[  380.556823] CPU: 5 PID: 4981 Comm: tar Not tainted 3.16.0-4-amd64 #1 Debian 3.16.7-ckt11-1
[  380.556824] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 1503 01/11/2013
[  380.556825]  000000000000000c ffffffff8150b405 ffff8800b58accc8 ffffffffa0682e07
[  380.556827]  ffff8800a8464800 ffff8800b665fec8 ffff8802333a6000 ffffffffa06b47d2
[  380.556828]  0000000000000001 ffff8800b665fe20 ffff8800b665fe1c ffff8800b665feb0
[  380.556830] Call Trace:
[  380.556832]  [<ffffffff8150b405>] ? dump_stack+0x41/0x51
[  380.556838]  [<ffffffffa0682e07>] ? xfs_trans_cancel+0xc7/0xf0 [xfs]
[  380.556845]  [<ffffffffa06b47d2>] ? xfs_create+0x2b2/0x700 [xfs]
[  380.556847]  [<ffffffff811b40ea>] ? kern_path_create+0xaa/0x190
[  380.556853]  [<ffffffffa06795ea>] ? xfs_generic_create+0xca/0x250 [xfs]
[  380.556854]  [<ffffffff811b7ad0>] ? vfs_mkdir+0xb0/0x160
[  380.556856]  [<ffffffff811b868b>] ? SyS_mkdirat+0xab/0xe0
[  380.556858]  [<ffffffff815115cd>] ? system_call_fast_compare_end+0x10/0x15
[  380.556860] XFS (md0): xfs_do_force_shutdown(0x8) called from line 960 of file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_trans.c.  Return address = 0xffffffffa0682e20
[  380.735013] XFS (md0): Corruption of in-memory data detected.  Shutting down filesystem
[  380.735017] XFS (md0): Please umount the filesystem and rectify the problem(s)
[  382.465430] XFS (md0): xfs_log_force: error 5 returned.
[  412.529071] XFS (md0): xfs_log_force: error 5 returned.
[  425.657948] ata2.00: exception Emask 0x10 SAct 0x4000000 SErr 0x280100 action 0x6 frozen
[  425.657956] ata2.00: irq_stat 0x08000000, interface fatal error
[  425.657962] ata2: SError: { UnrecovData 10B8B BadCRC }
[  425.657968] ata2.00: failed command: READ FPDMA QUEUED
[  425.657977] ata2.00: cmd 60/08:d0:b8:02:45/00:00:0c:00:00/40 tag 26 ncq 4096 in
         res 50/00:d0:b8:02:45/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
[  425.657982] ata2.00: status: { DRDY }
[  425.657988] ata2: hard resetting link
[  426.149601] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  426.150666] ata2.00: configured for UDMA/100
[  426.150675] ata2: EH complete
[  426.157721] ata2.00: exception Emask 0x10 SAct 0x10000000 SErr 0x280100 action 0x6 frozen
[  426.157724] ata2.00: irq_stat 0x08000000, interface fatal error
[  426.157726] ata2: SError: { UnrecovData 10B8B BadCRC }
[  426.157728] ata2.00: failed command: READ FPDMA QUEUED
[  426.157732] ata2.00: cmd 60/40:e0:c0:02:45/00:00:0c:00:00/40 tag 28 ncq 32768 in
         res 50/00:e0:c0:02:45/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
[  426.157733] ata2.00: status: { DRDY }
[  426.157736] ata2: hard resetting link
[  426.649390] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  426.650661] ata2.00: configured for UDMA/100
[  426.650670] ata2: EH complete
[  426.657444] ata2: limiting SATA link speed to 3.0 Gbps
[  426.657453] ata2.00: exception Emask 0x10 SAct 0x20000000 SErr 0x280100 action 0x6 frozen
[  426.657458] ata2.00: irq_stat 0x08000000, interface fatal error
[  426.657463] ata2: SError: { UnrecovData 10B8B BadCRC }
[  426.657468] ata2.00: failed command: READ FPDMA QUEUED
[  426.657477] ata2.00: cmd 60/40:e8:c0:02:45/00:00:0c:00:00/40 tag 29 ncq 32768 in
         res 50/00:e8:c0:02:45/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
[  426.657482] ata2.00: status: { DRDY }
[  426.657488] ata2: hard resetting link
[  427.149119] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  427.150269] ata2.00: configured for UDMA/100
[  427.150278] ata2: EH complete
[  437.456774] systemd-logind[4495]: Failed to start user service: Unknown unit: user@65534.service
[  437.459623] systemd-logind[4495]: New session c1 of user nobody.
[  442.592642] XFS (md0): xfs_log_force: error 5 returned.
[  461.447454] systemd-logind[4495]: Removed session c1.
[  472.656343] XFS (md0): xfs_log_force: error 5 returned.
[  502.719909] XFS (md0): xfs_log_force: error 5 returned.
[  517.754984] systemd-logind[4495]: New session 2 of user root.
[  532.783626] XFS (md0): xfs_log_force: error 5 returned.
[  562.847248] XFS (md0): xfs_log_force: error 5 returned.
[  592.910892] XFS (md0): xfs_log_force: error 5 returned.
[  622.974525] XFS (md0): xfs_log_force: error 5 returned.
[  653.038159] XFS (md0): xfs_log_force: error 5 returned.
[  683.101796] XFS (md0): xfs_log_force: error 5 returned.
[  713.165433] XFS (md0): xfs_log_force: error 5 returned.
[  743.229069] XFS (md0): xfs_log_force: error 5 returned.
[  773.292709] XFS (md0): xfs_log_force: error 5 returned.
[  803.356344] XFS (md0): xfs_log_force: error 5 returned.
[  833.419991] XFS (md0): xfs_log_force: error 5 returned.
[  863.483617] XFS (md0): xfs_log_force: error 5 returned.
[  893.547256] XFS (md0): xfs_log_force: error 5 returned.
[  923.610889] XFS (md0): xfs_log_force: error 5 returned.

>What did repair find?

This time it says:
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 11:01:53: scanning filesystem freespace - 32 of 32 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 11:01:53: scanning agi unlinked lists - 32 of 32 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 15
        - agno = 30
        - agno = 0
        - agno = 1
        - agno = 16
        - agno = 17
        - agno = 2
        - agno = 3
        - agno = 18
        - agno = 4
        - agno = 5
        - agno = 19
        - agno = 6
        - agno = 20
        - agno = 21
        - agno = 7
        - agno = 8
        - agno = 31
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 9
        - agno = 10
        - agno = 25
        - agno = 11
        - agno = 26
        - agno = 12
        - agno = 27
        - agno = 13
        - agno = 28
        - agno = 14
        - agno = 29
        - 11:01:56: process known inodes and inode discovery - 42624 of 42624 inodes done
        - process newly discovered inodes...
        - 11:01:56: process newly discovered inodes - 32 of 32 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 11:01:56: setting up duplicate extent list - 32 of 32 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 7
        - agno = 6
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - 11:01:56: check for inodes claiming duplicate blocks - 42624 of 42624 inodes done
Phase 5 - rebuild AG headers and trees...
        - 11:01:57: rebuild AG headers and trees - 32 of 32 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
Done

I go into a directory on the array and run ` tar -xzvf RR_27xx.tar.gz`

It works for a bit, but then it tries to create some directories:

RR274x/Driver/Linux/SLES/rr274x_3x-sles-9sp3-x86_64-v1.0.10.0708.tgz
RR274x/Driver/Linux/Ubuntu/
RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386/
RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386/boot/
tar: RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386/boot: Cannot mkdir: Structure needs cleaning
RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386/boot/rr274x_3x2.6.32-21-generic-paei386.ko.gz
tar: RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386/boot: Cannot mkdir: Input/output error

gzip: stdin: Input/output error
tar: Unexpected EOF in archive
tar: RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386: Cannot utime: Input/output error
tar: RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386: Cannot change ownership to uid 0, gid 1000: Input/output error
tar: RR274x/Driver/Linux/Ubuntu/rr274x_3x-ubuntu-10.04-i386: Cannot change mode to rwxr-xr-x: Input/output error
tar: RR274x/Driver/Linux/Ubuntu: Cannot utime: Input/output error
tar: RR274x/Driver/Linux/Ubuntu: Cannot change ownership to uid 0, gid 1000: Input/output error
tar: RR274x/Driver/Linux/Ubuntu: Cannot change mode to rwxr-xr-x: Input/output error
tar: RR274x/Driver/Linux: Cannot utime: Input/output error
tar: RR274x/Driver/Linux: Cannot change ownership to uid 0, gid 1000: Input/output error
tar: RR274x/Driver/Linux: Cannot change mode to rwxr-xr-x: Input/output error
tar: RR274x/Driver: Cannot utime: Input/output error
tar: RR274x/Driver: Cannot change ownership to uid 0, gid 1000: Input/output error
tar: RR274x/Driver: Cannot change mode to rwxr-xr-x: Input/output error
tar: RR274x: Cannot utime: Input/output error
tar: RR274x: Cannot change ownership to uid 0, gid 1000: Input/output error
tar: RR274x: Cannot change mode to rwxr-xr-x: Input/output error
tar: Error is not recoverable: exiting now

(Note if I copy the file to another filesystem and untar it, tar completes without errors.)

dmesg:
[1744.155054] XFS (md0): xfs_iread: validation failed for inode 124656869424 failed
[ 1744.155064] ffff8800af962000: 49 4e 00 00 03 02 00 00 00 30 00 70 00 00 03 e8  IN.......0.p....
[ 1744.155068] ffff8800af962010: 00 00 00 00 06 20 b0 6f 01 2e 00 00 00 00 00 16  ..... .o........
[ 1744.155071] ffff8800af962020: 01 57 37 fd 2b 5d 22 9e 1e 0a 61 8c 00 00 00 20  .W7.+]"...a.... 
[ 1744.155075] ffff8800af962030: ff ff 00 d2 1b f6 27 90 00 00 00 00 00 00 00 00  ......'.........
[ 1744.155103] XFS (md0): Internal error xfs_iread at line 392 of file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_inode_buf.c.  Caller xfs_iget+0x24b/0x690 [xfs]
[ 1744.155109] CPU: 4 PID: 6167 Comm: tar Not tainted 3.16.0-4-amd64 #1 Debian 3.16.7-ckt11-1
[ 1744.155113] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 1503 01/11/2013
[ 1744.155116]  0000000000000001 ffffffff8150b405 ffff8802333a6000 ffffffffa066e5cb
[ 1744.155123]  0000018800000010 ffffffffa0673f6b ffff8800ac8f1c00 ffff8802333a6000
[ 1744.155128]  0000000000000075 ffff880220abfdb0 ffffffffa06b9b3a ffffffffa0673f6b
[ 1744.155133] Call Trace:
[ 1744.155143]  [<ffffffff8150b405>] ? dump_stack+0x41/0x51
[ 1744.155160]  [<ffffffffa066e5cb>] ? xfs_corruption_error+0x5b/0x80 [xfs]
[ 1744.155177]  [<ffffffffa0673f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[ 1744.155199]  [<ffffffffa06b9b3a>] ? xfs_iread+0xea/0x400 [xfs]
[ 1744.155215]  [<ffffffffa0673f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[ 1744.155233]  [<ffffffffa0673f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[ 1744.155255]  [<ffffffffa06b3de6>] ? xfs_ialloc+0xa6/0x500 [xfs]
[ 1744.155261]  [<ffffffffa068358e>] ? kmem_zone_alloc+0x6e/0xe0 [xfs]
[ 1744.155268]  [<ffffffffa06b42a2>] ? xfs_dir_ialloc+0x62/0x2a0 [xfs]
[ 1744.155275]  [<ffffffffa06821e5>] ? xfs_trans_reserve+0x1f5/0x200 [xfs]
[ 1744.155281]  [<ffffffffa06b49a9>] ? xfs_create+0x489/0x700 [xfs]
[ 1744.155284]  [<ffffffff811b40ea>] ? kern_path_create+0xaa/0x190
[ 1744.155290]  [<ffffffffa06795ea>] ? xfs_generic_create+0xca/0x250 [xfs]
[ 1744.155292]  [<ffffffff811b7ad0>] ? vfs_mkdir+0xb0/0x160
[ 1744.155294]  [<ffffffff811b868b>] ? SyS_mkdirat+0xab/0xe0
[ 1744.155296]  [<ffffffff815115cd>] ? system_call_fast_compare_end+0x10/0x15
[ 1744.155297] XFS (md0): Corruption detected. Unmount and run xfs_repair
[ 1744.155307] XFS (md0): Internal error xfs_trans_cancel at line 959 of file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_trans.c.  Caller xfs_create+0x2b2/0x700 [xfs]
[ 1744.155309] CPU: 4 PID: 6167 Comm: tar Not tainted 3.16.0-4-amd64 #1 Debian 3.16.7-ckt11-1
[ 1744.155310] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 1503 01/11/2013
[ 1744.155310]  000000000000000c ffffffff8150b405 ffff880220abfdb0 ffffffffa0682e07
[ 1744.155312]  ffff88022b133000 ffff8800ad4bfec8 ffff8802333a6000 ffffffffa06b47d2
[ 1744.155314]  0000000000000001 ffff8800ad4bfe20 ffff8800ad4bfe1c ffff8800ad4bfeb0
[ 1744.155315] Call Trace:
[ 1744.155317]  [<ffffffff8150b405>] ? dump_stack+0x41/0x51
[ 1744.155324]  [<ffffffffa0682e07>] ? xfs_trans_cancel+0xc7/0xf0 [xfs]
[ 1744.155331]  [<ffffffffa06b47d2>] ? xfs_create+0x2b2/0x700 [xfs]
[ 1744.155332]  [<ffffffff811b40ea>] ? kern_path_create+0xaa/0x190
[ 1744.155339]  [<ffffffffa06795ea>] ? xfs_generic_create+0xca/0x250 [xfs]
[ 1744.155340]  [<ffffffff811b7ad0>] ? vfs_mkdir+0xb0/0x160
[ 1744.155342]  [<ffffffff811b868b>] ? SyS_mkdirat+0xab/0xe0
[ 1744.155344]  [<ffffffff815115cd>] ? system_call_fast_compare_end+0x10/0x15
[ 1744.155346] XFS (md0): xfs_do_force_shutdown(0x8) called from line 960 of file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_trans.c.  Return address = 0xffffffffa0682e20
[ 1744.358431] XFS (md0): Corruption of in-memory data detected.  Shutting down filesystem
[ 1744.358434] XFS (md0): Please umount the filesystem and rectify the problem(s)
[ 1768.335113] XFS (md0): xfs_log_force: error 5 returned.
[ 1798.398749] XFS (md0): xfs_log_force: error 5 returned.
[ 1828.462445] XFS (md0): xfs_log_force: error 5 returned.
[ 1858.526061] XFS (md0): xfs_log_force: error 5 returned.
[ 1888.589662] XFS (md0): xfs_log_force: error 5 returned.
[ 1918.653300] XFS (md0): xfs_log_force: error 5 returned.
[ 1948.716936] XFS (md0): xfs_log_force: error 5 returned.
[ 1978.780572] XFS (md0): xfs_log_force: error 5 returned.


>Not a lot to go on from the above narrative, I'm afraid.  What large files are those?  I presume that you are sure they should not be changing?

Hmm.  No, the files are not being changed by any process.  The ones for which I have observed the effect are large video files, although it is entirely possible it is happening with smaller files as well and I just haven't noticed it.  I just tried something, though.  I copied one of the files over to a different file system (Ext3), and the issue occurs there, as well.  This particular symptom may have nothing to do with XFS.  That would make sense if the issue with the file system is the structures, not the individual data files.  The jury is still out on this one.

>From the dmesg, every stuck process is stuck on nfs - doesn't look xfs related at all.

I shut down nfs and ran it again.  You can see the new file at the same link:

http://fletchergeek.com/images/dmesg.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
