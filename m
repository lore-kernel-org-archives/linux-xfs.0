Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED2A029DF8
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 00:24:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5FEE8F8070
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 22:24:37 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id HnVoSffQQwlQzpZ9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 22:24:32 -0700 (PDT)
Date: Tue, 7 May 2013 07:24:30 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Mount probing not silent. Internal error xfs_sb_read_verify at
	line 726
Message-ID: <20130507052430.GA508@x4>
References: <20130506112717.GA502@x4> <5187E290.8090109@sandeen.net>
	<20130506183020.GA513@x4> <51880121.8000001@sandeen.net>
	<20130506192629.GA503@x4> <5188074F.2090500@sandeen.net>
	<20130506195521.GB503@x4> <51881750.3090309@sandeen.net>
	<51882537.6070904@sandeen.net> <20130507002314.GM19978@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130507002314.GM19978@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: util-linux@vger.kernel.org, Karel Zak <kzak@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 2013.05.07 at 10:23 +1000, Dave Chinner wrote:
> On Mon, May 06, 2013 at 04:48:39PM -0500, Eric Sandeen wrote:
> > On 5/6/13 3:49 PM, Eric Sandeen wrote:
> > ...
> > 
> > > Interesting, so [mount] really does try to mount by successive fs types.
> > > 
> > > I wonder when that behavior changed (my util-linux-ng 2.17 on RHEL6 doesn't do this)
> > > 
> > > I'll take a look.
> > 
> > Just to satisfy my curiosity:
> > 
> > commit c6c98f93f5e4b3fb9a8b51ed2ef9967793df7b1c
> > Author: Karel Zak <kzak@redhat.com>
> > Date:   Mon Mar 15 13:46:43 2010 +0100
> > 
> >     mount: report ambivalent FS detection, improve brute force detection
> > 
> > So we're getting into xfs mount with an actual "-t xfs" equivalent,
> > and not going down the "silent" paths.
> 
> That's just completely broken mount behaviour. Probing is supposed
> to be *silent*, and this is just downright obnxious. Here's what I
> get in my log after doing this:
> 
> # dd if=/dev/zero of=/dev/vdb bs=512 count=1
> # blkid -g
> # mount  /dev/vdb /mnt/scratch/
> mount: you must specify the filesystem type
> $ dmesg
> ......
> [83182.775467] REISERFS warning (device vdb): sh-2021 reiserfs_fill_super: can not find reiserfs on vdb
> [83182.778473] EXT3-fs (vdb): error: can't find ext3 filesystem on dev vdb.
> [83182.781135] EXT2-fs (vdb): error: can't find an ext2 filesystem on dev vdb.
> [83182.783524] EXT4-fs (vdb): VFS: Can't find ext4 filesystem
> [83182.787392] cramfs: wrong magic
> [83182.788926] SQUASHFS error: Can't find a SQUASHFS superblock on vdb
> [83182.791150] VFS: Can't find a Minix filesystem V1 | V2 | V3 on device vdb.
> [83182.793737] FAT-fs (vdb): bogus number of reserved sectors
> [83182.795202] FAT-fs (vdb): Can't find a valid FAT filesystem
> [83182.797268] FAT-fs (vdb): bogus number of reserved sectors
> [83182.798984] FAT-fs (vdb): Can't find a valid FAT filesystem
> [83182.801236] BFS-fs: bfs_fill_super(): No BFS filesystem on vdb (magic=00000000)
> [83182.846555] ISOFS: Unable to identify CD-ROM format.
> [83182.849136] hfs: unable to find HFS+ superblock
> [83182.851164] hfs: can't find a HFS filesystem on dev vdb.
> [83182.853204] vxfs: WRONG superblock magic
> [83182.856855] VFS: unable to find oldfs superblock on device vdb
> [83182.858930] VFS: could not find a valid V7 on vdb.
> [83182.860938] NTFS-fs error (device vdb): read_ntfs_boot_sector(): Primary boot sector is invalid.
> [83182.863247] NTFS-fs error (device vdb): read_ntfs_boot_sector(): Mount option errors=recover not used. Aborting without trying to recover.
> [83182.866563] NTFS-fs error (device vdb): ntfs_fill_super(): Not an NTFS volume.
> [83182.873922] AFFS: No valid root block on device vdb
> [83182.875697] VFS: Can't find a romfs filesystem on dev vdb.
> [83182.877823] qnx4: wrong fsid in superblock.
> [83182.884286] UDF-fs: warning (device vdb): udf_load_vrs: No VRS found
> [83182.886217] UDF-fs: Rescanning with blocksize 2048
> [83182.891965] UDF-fs: warning (device vdb): udf_load_vrs: No VRS found
> [83182.893730] UDF-fs: warning (device vdb): udf_fill_super: No partition found (1)
> [83182.896216] omfs: Invalid superblock (0)
> [83182.898937] XFS (vdb): bad magic number
> [83182.900150] ffff88007bbce000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [83182.902676] ffff88007bbce010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [83182.905281] ffff88007bbce020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [83182.907845] ffff88007bbce030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [83182.910559] XFS (vdb): Internal error xfs_sb_read_verify at line 726 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff814645e5
> [83182.910559]
> [83182.914377] Pid: 1064, comm: kworker/0:1H Not tainted 3.9.0-rc8-dgc+ #575
> [83182.916499] Call Trace:
> [83182.917245]  [<ffffffff8146761f>] xfs_error_report+0x3f/0x50
> [83182.918762]  [<ffffffff814645e5>] ? xfs_buf_iodone_work+0xc5/0xf0
> [83182.920113]  [<ffffffff8146768e>] xfs_corruption_error+0x5e/0x90
> [83182.921351]  [<ffffffff814cf50a>] xfs_sb_read_verify+0x11a/0x130
> [83182.922692]  [<ffffffff814645e5>] ? xfs_buf_iodone_work+0xc5/0xf0
> [83182.923972]  [<ffffffff810b6555>] ? finish_task_switch+0x65/0x100
> [83182.925343]  [<ffffffff814645e5>] xfs_buf_iodone_work+0xc5/0xf0
> [83182.926634]  [<ffffffff810a35d0>] process_one_work+0x170/0x400
> [83182.927832]  [<ffffffff810a4f26>] worker_thread+0x116/0x390
> [83182.929116]  [<ffffffff810a4e10>] ? busy_worker_rebind_fn+0xb0/0xb0
> [83182.930460]  [<ffffffff810aadd8>] kthread+0xd8/0xe0
> [83182.931469]  [<ffffffff810aad00>] ? kthread_create_on_node+0x140/0x140
> [83182.932921]  [<ffffffff81c23dec>] ret_from_fork+0x7c/0xb0
> [83182.934047]  [<ffffffff810aad00>] ? kthread_create_on_node+0x140/0x140
> [83182.935489] XFS (vdb): Corruption detected. Unmount and run xfs_repair
> [83182.937045] XFS (vdb): SB validate failed with error 22.
> [83182.940181] NILFS: Can't find nilfs on dev vdb.
> [83182.941321] BeFS(vdb): No write support. Marking filesystem read-only
> [83182.943036] BeFS(vdb): invalid magic header
> [83182.946526] (mount,23815,1):ocfs2_fill_super:1039 ERROR: superblock probe failed!
> [83182.948515] (mount,23815,1):ocfs2_fill_super:1230 ERROR: status = -22
> [83182.951606] GFS2: not a GFS2 filesystem
> [83182.952898] GFS2: gfs2 mount does not exist
> [83182.954425] F2FS-fs (vdb): Magic Mismatch, valid(0xf2f52010) - read(0x49474158)
> [83182.956540] F2FS-fs (vdb): Can't find a valid F2FS filesystem in first superblock
> [83182.959044] F2FS-fs (vdb): Magic Mismatch, valid(0xf2f52010) - read(0x0)
> [83182.960894] F2FS-fs (vdb): Can't find a valid F2FS filesystem in second superblock
> 
> I've removed logfs from my kernels because this probing causes
> logfs to oops the kernel...
> 
> I think that mount needs fixing, not XFS. mount needs to be doing
> silent mounts when doing this brute forcing, not noisy, explicit
> mounts that we expect to throw errors if there is a problem.

> BTW, strace indicates that MS_SILENT is not being used during brute
> force mounts:
> 
> # strace -vx mount /dev/vdb /mnt/scratch/ 2>&1 |grep ^mount
> mount("/dev/vdb", "/mnt/scratch/", "reiserfs", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> mount("/dev/vdb", "/mnt/scratch/", "ext3", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> mount("/dev/vdb", "/mnt/scratch/", "ext2", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> mount("/dev/vdb", "/mnt/scratch/", "ext4", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> ....
> 
> So this really looks like a bug in mount, not the filesystem handling
> of slient mounts...

So, lets CC util-linux...

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
