Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E357A7F6F
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 03:48:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD8738F804B
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 01:48:59 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id iTbesMP9fxZZiOwZ for
	<xfs@oss.sgi.com>; Wed, 22 May 2013 01:48:58 -0700 (PDT)
Date: Wed, 22 May 2013 04:48:56 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <2013798179.4502334.1369212536770.JavaMail.root@redhat.com>
In-Reply-To: <2132292786.4417784.1369195807747.JavaMail.root@redhat.com>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<2132292786.4417784.1369195807747.JavaMail.root@redhat.com>
Subject: Re: 3.9.0: XFS rootfs corruption
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "Eric Sandeen" <sandeen@sandeen.net>
> Cc: xfs@oss.sgi.com
> Sent: Wednesday, May 22, 2013 12:10:07 PM
> Subject: Re: 3.9.0: XFS rootfs corruption
> 
> OK, this has never been reproduced in 3.9-rc1 so far. It may because the
> rootfs became full after crash dump testing though.
> CAI Qian
Oops, it is still there,
[    1.872402] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled 
[    1.882003] XFS (dm-1): Mounting Filesystem 
[    5.036445] XFS (dm-1): Starting recovery (logdev: internal) 
[    5.337985] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd00000000245778c 
[    5.337985]  
[    5.338002] CPU: 15 PID: 425 Comm: mount Not tainted 3.10.0-rc2+ #1 
[    5.338007] Call Trace: 
[    5.338014] [c0000002e3782b90] [c000000000014e1c] .show_stack+0x7c/0x1f0 (unreliable) 
[    5.338024] [c0000002e3782c60] [c0000000007439dc] .dump_stack+0x28/0x3c 
[    5.338056] [c0000002e3782cd0] [d000000002410634] .xfs_error_report+0x54/0x70 [xfs] 
[    5.338088] [c0000002e3782d40] [d000000002457634] .__xfs_dir3_data_check+0x784/0x820 [xfs] 
[    5.338120] [c0000002e3782e40] [d00000000245778c] .xfs_dir3_data_verify+0xbc/0xe0 [xfs] 
[    5.338151] [c0000002e3782ec0] [d0000000024577ec] .xfs_dir3_data_write_verify+0x3c/0x1c0 [xfs] 
[    5.338181] [c0000002e3782f70] [d00000000240db44] ._xfs_buf_ioapply+0xd4/0x410 [xfs] 
[    5.338210] [c0000002e37830b0] [d00000000240df8c] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    5.338241] [c0000002e3783140] [d00000000240e084] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    5.338271] [c0000002e37831d0] [d00000000240e294] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs] 
[    5.338300] [c0000002e37832b0] [d00000000240f2d8] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    5.338334] [c0000002e3783350] [d000000002471fc4] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs] 
[    5.338366] [c0000002e3783410] [d0000000024722cc] .xlog_recover_process_data+0x25c/0x370 [xfs] 
[    5.338399] [c0000002e37834e0] [d000000002472528] .xlog_do_recovery_pass+0x148/0x590 [xfs] 
[    5.338431] [c0000002e3783650] [d000000002472a08] .xlog_do_log_recovery+0x98/0x110 [xfs] 
[    5.338463] [c0000002e37836e0] [d000000002472aa0] .xlog_do_recover+0x20/0x160 [xfs] 
[    5.338495] [c0000002e3783770] [d000000002472c78] .xlog_recover+0x98/0x110 [xfs] 
[    5.338527] [c0000002e3783800] [d00000000247d504] .xfs_log_mount+0x134/0x1d0 [xfs] 
[    5.338559] [c0000002e3783890] [d0000000024768e8] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    5.338589] [c0000002e3783940] [d000000002424bbc] .xfs_fs_fill_super+0x30c/0x3a0 [xfs] 
[    5.338598] [c0000002e37839e0] [c000000000214a78] .mount_bdev+0x258/0x2a0 
[    5.338627] [c0000002e3783ab0] [d000000002422678] .xfs_fs_mount+0x18/0x30 [xfs] 
[    5.338635] [c0000002e3783b20] [c000000000215900] .mount_fs+0x70/0x230 
[    5.338643] [c0000002e3783be0] [c000000000237ee8] .vfs_kern_mount+0x58/0x130 
[    5.338650] [c0000002e3783c90] [c00000000023b0b0] .do_mount+0x2d0/0xb30 
[    5.338657] [c0000002e3783d70] [c00000000023b9c0] .SyS_mount+0xb0/0x110 
[    5.338664] [c0000002e3783e30] [c000000000009e54] syscall_exit+0x0/0x98 
[    5.338672] c0000002d5220000: 58 44 32 44 09 50 00 40 0a 50 00 40 0b 50 00 40  XD2D.P.@.P.@.P.@ 
[    5.338679] c0000002d5220010: 00 00 00 00 08 23 e6 2d 32 62 65 61 68 5f 74 61  .....#.-2beah_ta 
[    5.338686] c0000002d5220020: 73 6b 5f 33 64 36 62 37 64 62 32 2d 61 35 35 37  sk_3d6b7db2-a557 
[    5.338693] c0000002d5220030: 2d 34 34 63 31 2d 38 65 64 36 2d 62 63 32 62 37  -44c1-8ed6-bc2b7 
[    5.338700] XFS (dm-1): Internal error xfs_dir3_data_write_verify at line 271 of file fs/xfs/xfs_dir2_data.c.  Caller 0xd00000000240db44 
[    5.338700]  
[    5.338710] CPU: 15 PID: 425 Comm: mount Not tainted 3.10.0-rc2+ #1 
[    5.338715] Call Trace: 
[    5.338718] [c0000002e3782c60] [c000000000014e1c] .show_stack+0x7c/0x1f0 (unreliable) 
[    5.338726] [c0000002e3782d30] [c0000000007439dc] .dump_stack+0x28/0x3c 
[    5.338755] [c0000002e3782da0] [d000000002410634] .xfs_error_report+0x54/0x70 [xfs] 
[    5.338785] [c0000002e3782e10] [d0000000024106cc] .xfs_corruption_error+0x7c/0xb0 [xfs] 
[    5.338816] [c0000002e3782ec0] [d0000000024578f8] .xfs_dir3_data_write_verify+0x148/0x1c0 [xfs] 
[    5.338846] [c0000002e3782f70] [d00000000240db44] ._xfs_buf_ioapply+0xd4/0x410 [xfs] 
[    5.338875] [c0000002e37830b0] [d00000000240df8c] .xfs_buf_iorequest+0x4c/0xe0 [xfs] 
[    5.338906] [c0000002e3783140] [d00000000240e084] .xfs_bdstrat_cb+0x64/0x120 [xfs] 
[    5.338936] [c0000002e37831d0] [d00000000240e294] .__xfs_buf_delwri_submit+0x154/0x2b0 [xfs] 
[    5.338965] [c0000002e37832b0] [d00000000240f2d8] .xfs_buf_delwri_submit+0x38/0xd0 [xfs] 
[    5.338998] [c0000002e3783350] [d000000002471fc4] .xlog_recover_commit_trans+0xf4/0x1a0 [xfs] 
[    5.339030] [c0000002e3783410] [d0000000024722cc] .xlog_recover_process_data+0x25c/0x370 [xfs] 
[    5.339063] [c0000002e37834e0] [d000000002472528] .xlog_do_recovery_pass+0x148/0x590 [xfs] 
[    5.339095] [c0000002e3783650] [d000000002472a08] .xlog_do_log_recovery+0x98/0x110 [xfs] 
[    5.339128] [c0000002e37836e0] [d000000002472aa0] .xlog_do_recover+0x20/0x160 [xfs] 
[    5.339160] [c0000002e3783770] [d000000002472c78] .xlog_recover+0x98/0x110 [xfs] 
[    5.339192] [c0000002e3783800] [d00000000247d504] .xfs_log_mount+0x134/0x1d0 [xfs] 
[    5.339226] [c0000002e3783890] [d0000000024768e8] .xfs_mountfs+0x3c8/0x780 [xfs] 
[    5.339256] [c0000002e3783940] [d000000002424bbc] .xfs_fs_fill_super+0x30c/0x3a0 [xfs] 
[    5.339264] [c0000002e37839e0] [c000000000214a78] .mount_bdev+0x258/0x2a0 
[    5.339293] [c0000002e3783ab0] [d000000002422678] .xfs_fs_mount+0x18/0x30 [xfs] 
[    5.339301] [c0000002e3783b20] [c000000000215900] .mount_fs+0x70/0x230 
[    5.339308] [c0000002e3783be0] [c000000000237ee8] .vfs_kern_mount+0x58/0x130 
[    5.339315] [c0000002e3783c90] [c00000000023b0b0] .do_mount+0x2d0/0xb30 
[    5.339322] [c0000002e3783d70] [c00000000023b9c0] .SyS_mount+0xb0/0x110 
[    5.339329] [c0000002e3783e30] [c000000000009e54] syscall_exit+0x0/0x98 
[    5.339335] XFS (dm-1): Corruption detected. Unmount and run xfs_repair 
[    5.339341] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 1364 of file fs/xfs/xfs_buf.c.  Return address = 0xd00000000240db70 
[    5.339350] XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem 
[    5.339356] XFS (dm-1): Please umount the filesystem and rectify the problem(s) 
[    5.339365] XFS (dm-1): metadata I/O error: block 0x2cb35d0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.339372] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339382] XFS (dm-1): metadata I/O error: block 0x2cb71d8 ("xlog_recover_iodone") error 5 numblks 8 
[    5.339389] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339398] XFS (dm-1): metadata I/O error: block 0x2fada78 ("xlog_recover_iodone") error 5 numblks 8 
[    5.339405] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339415] XFS (dm-1): metadata I/O error: block 0x3243eb0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.339422] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339431] XFS (dm-1): metadata I/O error: block 0x324ee10 ("xlog_recover_iodone") error 5 numblks 16 
[    5.339438] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339447] XFS (dm-1): metadata I/O error: block 0x324ee20 ("xlog_recover_iodone") error 5 numblks 16 
[    5.339454] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339463] XFS (dm-1): metadata I/O error: block 0x4150802 ("xlog_recover_iodone") error 5 numblks 1 
[    5.339471] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339480] XFS (dm-1): metadata I/O error: block 0x4323540 ("xlog_recover_iodone") error 5 numblks 8 
[    5.339487] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339496] XFS (dm-1): metadata I/O error: block 0x457c9b0 ("xlog_recover_iodone") error 5 numblks 16 
[    5.339503] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.339519] XFS (dm-1): metadata I/O error: block 0x2cb2158 ("xlog_recover_iodone") error 117 numblks 8 
[    5.339526] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 386 of file fs/xfs/xfs_log_recover.c.  Return address = 0xd00000000246d140 
[    5.412895] XFS (dm-1): log mount/recovery failed: error 117 
[    5.412943] XFS (dm-1): log mount failed 
[      
FAILED   
] Failed to mount /sysroot.  
See 'systemctl status sysroot.mount' for details.  
[      
DEPEND   
] Dependency failed for Initrd Root File System.  
[      
DEPEND   
] Dependency failed for Reload Configuration from the Real Root.  
[    5.423354] systemd[1]: Starting Emergency Shell... 
[    5.428268] systemd[1]: Starting Journal Service... 
[    5.431426] systemd-journald[201]: Received SIGTERM 
[    5.432383] systemd[1]: Starting Journal Service... 
[    5.432961] systemd[1]: Started Journal Service. 
[    5.433743] systemd[1]: Stopped udev Kernel Device Manager. 
[    5.433777] systemd[1]: Stopping dracut pre-udev hook... 
[    5.433789] systemd[1]: Stopped dracut pre-udev hook. 
[    5.433829] systemd[1]: Stopping dracut cmdline hook... 
[    5.433840] systemd[1]: Stopped dracut cmdline hook. 
[    5.433875] systemd[1]: Stopping udev Kernel Socket. 
[    5.433911] systemd[1]: Closed udev Kernel Socket. 
[    5.433922] systemd[1]: Stopping udev Control Socket. 
[    5.433955] systemd[1]: Closed udev Control Socket. 
 
Generating "/run/initramfs/sosreport.txt" 
 
 
Entering emergency mode. Exit the shell to continue. 
Type "journalctl" to view system logs. 
You might want to save "/run/initramfs/sosreport.txt" to a USB stick or /boot 
after mounting them and attach it to a bug report. 
 
 
:/#
> 
> ----- Original Message -----
> > From: "Eric Sandeen" <sandeen@sandeen.net>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: xfs@oss.sgi.com
> > Sent: Wednesday, May 8, 2013 3:08:05 AM
> > Subject: Re: 3.9.0: XFS rootfs corruption
> > 
> > On 5/7/13 2:53 AM, CAI Qian wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > >> From: "Eric Sandeen" <sandeen@sandeen.net>
> > >> To: "CAI Qian" <caiqian@redhat.com>
> > >> Cc: xfs@oss.sgi.com
> > >> Sent: Monday, May 6, 2013 10:31:01 PM
> > >> Subject: Re: 3.9.0: XFS rootfs corruption
> > >>
> > >> On 5/6/13 2:50 AM, CAI Qian wrote:
> > >>> Saw this on several different Power7 systems after kdump reboot. It has
> > >>> xfsprogs-3.1.10
> > >>> and rootfs in on LVM. Never saw one of those in any of the RC releases.
> > >>>
> > >>> ] Reached target Basic System.
> > >>> [    4.919316] bio: create slab <bio-1> at 1
> > >>> [    5.078616] SGI XFS with ACLs, security attributes, large
> > >>> block/inode
> > >>> numbers, no debug enabled
> > >>> [    5.081925] XFS (dm-1): Mounting Filesystem
> > >>> [    5.168530] XFS (dm-1): Starting recovery (logdev: internal)
> > >>> [    5.333575] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line
> > >>> 176
> > >>> of
> > >>> file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000002396fdc
> > >>
> > >> here:
> > >>
> > >>         /*
> > >>          * Need to have seen all the entries and all the bestfree slots.
> > >>          */
> > >>         XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
> > >>
> > >> I hope Dave knows offhand what this might mean.  :)
> > >>
> > >> Could you get a metadump of the filesystem in question?
> > > Err, less familiar here. May I ask how can I do that?
> > 
> > since it's the root fs, you might need to do it from some sort of rescue
> > shell, then just do xfs_metadump /dev/<device> <metadump filename>
> > 
> > the resulting file should compress further with something like bzip2.
> > 
> > ...
> > 
> > >>> Also, never saw any of those in other architectures like x64, but
> > >>> started
> > >>> get those there in 3.9.0.
> > >>> Unsure if those are related.
> > >>>
> > >>> [ 3224.369782]
> > >>> =============================================================================
> > >>> [ 3224.370017] BUG xfs_efi_item (Tainted: GF   B       ): Poison
> > >>> overwritten
> > >>> [ 3224.370017]
> > >>> -----------------------------------------------------------------------------
> > >>
> > >>   2: 'F' if any module was force loaded by "insmod -f", ' ' if all
> > >>      modules were loaded normally.
> > >>
> > >> Force loaded modules, what's that from?
> > > This could be just happened after the booting done or we were running a
> > > stress test later
> > > that does load (modprobe *) and unload (modprobe -r *) every module.
> > > Again,
> > > those warnings
> > > could be totally unrelated to the above rootfs corruption.
> > > CAI Qian
> > 
> > hmmm :)  So any one of those modules could have caused memory corruption I
> > guess.
> > 
> > If you can hit it reliably you might try to narrow it down to whether it
> > is a particular module causing it.
> > 
> > -Eric
> > 
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
