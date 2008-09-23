Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 01:03:25 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N83Lli030967
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:03:21 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id E41FC90893
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:04:51 -0700 (PDT)
Message-ID: <48D89FC6.7010205@sgi.com>
Date: Tue, 23 Sep 2008 17:50:30 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c
References: <48D6A0AD.3040307@kevinjamieson.com>
In-Reply-To: <48D6A0AD.3040307@kevinjamieson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: kevin@kevinjamieson.com
Cc: xfs@oss.sgi.com


Hi Kevin, sorry for the delay - yes AFAICT we have seen this before,
see the discussion and patches in the xfs@oss archives at
http://oss.sgi.com/archives/xfs/2008-03/msg00144.html

I think several patches have been committed to recent mainline kernels,
but it looks like your testing on 2.6.26 indicates either it still isn't
fixed, or you've hit a different problem, despite the similar stack
traces. Tim might have additional info to add here ...

In any case, this has also been been reported in Novell bugzilla #243029
against SLES10sp1. Since you're running sles10sp1, perhaps you could get
in touch with Novell for support?

Thanks
-- Mark


Kevin Jamieson wrote:
> Hello,
>
> We have encountered the following error several times on some of our
> customer systems running SLES 10 SP1 (kernel version 2.6.16.46-0.12):
>
> Sep 12 01:24:41 gn1 kernel: Filesystem "dm-0": XFS internal error
> xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller
> 0xf9429f23
> Sep 12 01:24:41 gn1 kernel:  [<f942277d>] xfs_trans_cancel+0x4d/0xd6 [xfs]
> Sep 12 01:24:41 gn1 kernel:  [<f9429f23>] xfs_create+0x4f1/0x52a [xfs]
> Sep 12 01:24:41 gn1 kernel:  [<f9429f23>] xfs_create+0x4f1/0x52a [xfs]
> Sep 12 01:24:41 gn1 kernel:  [<f9433657>] xfs_vn_mknod+0x172/0x276 [xfs]
> Sep 12 01:24:41 gn1 kernel:  [<c016c45b>] vfs_create+0xd1/0x138
> Sep 12 01:24:41 gn1 kernel:  [<c016e862>] sys_mknodat+0xfa/0x164
> Sep 12 01:24:41 gn1 kernel:  [<c016fc47>] do_ioctl+0x4f/0x5e
> Sep 12 01:24:41 gn1 kernel:  [<c016fea2>] vfs_ioctl+0x24c/0x25e
> Sep 12 01:24:41 gn1 kernel:  [<c016e8df>] sys_mknod+0x13/0x17
> Sep 12 01:24:41 gn1 kernel:  [<c0103bdb>] sysenter_past_esp+0x54/0x79
> Sep 12 01:24:41 gn1 kernel: xfs_force_shutdown(dm-0,0x8) called from
> line 1139 of file fs/xfs/xfs_trans.c.  Return address = 0xf94359db
> Sep 12 01:24:41 gn1 kernel: Filesystem "dm-0": Corruption of in-memory
> data detected.  Shutting down filesystem: dm-0
>
>
>  From a recent occurrence of this, I was able to obtain a copy of the
> file system prior to it being restored from backup.
>
> The file system in question is relatively full -- 800GB with 25GB free
> and 70M inodes used (the file system is used with a proprietary
> DMAPI-based HSM application, so most of the file data is punched out).
>
> With the file system in this state, the forced shutdown error is
> reproducible when attempting to create a file in a particular directory
> -- an ENOSPC error is returned to userspace, and the file system shuts
> down.
>
> The forced shutdown is also reproducible with this file system mounted
> on a more recent kernel version -- here is a stack trace from the same
> file system mounted on a 2.6.26 kernel built from oss.sgi.com cvs on Sep
> 19 2008:
>
> Sep 21 06:35:41 gn1 kernel: Filesystem "loop0": XFS internal error
> xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller
> 0xf93c8195
> Sep 21 06:35:41 gn1 kernel:  [<f93c2fc0>] xfs_trans_cancel+0x4d/0xd3 [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<f93c8195>] xfs_create+0x49b/0x4db [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<f93c8195>] xfs_create+0x49b/0x4db [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<f93d166b>] xfs_vn_mknod+0x128/0x1e3 [xfs]
> Sep 21 06:35:41 gn1 kernel:  [<c0170e9d>] vfs_create+0xb4/0x117
> Sep 21 06:35:41 gn1 kernel:  [<c0172c46>] do_filp_open+0x1a0/0x671
> Sep 21 06:35:41 gn1 kernel:  [<c01681da>] do_sys_open+0x40/0xb6
> Sep 21 06:35:41 gn1 kernel:  [<c0168294>] sys_open+0x1e/0x23
> Sep 21 06:35:41 gn1 kernel:  [<c0104791>] sysenter_past_esp+0x6a/0x99
> Sep 21 06:35:41 gn1 kernel:  [<c02b0000>] unix_listen+0x8/0xc9
> Sep 21 06:35:41 gn1 kernel:  =======================
> Sep 21 06:35:41 gn1 kernel: xfs_force_shutdown(loop0,0x8) called from
> line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xf93c2fd6
> Sep 21 06:35:41 gn1 kernel: Filesystem "loop0": Corruption of in-memory
> data detected.  Shutting down filesystem: loop0
>
>
> Tracing through the XFS code, the ENOSPC error is returned here from
> fs/xfs/xfs_da_btree.c:
>
> xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
> {
> ...
>     if (got != count || mapp[0].br_startoff != bno ||
>         ...
>         return XFS_ERROR(ENOSPC);
>     }
> ...
> }
>
> where got = 0 and count = 1 and xfs_da_grow_inode() is called from
> xfs_create() -> xfs_dir_createname() -> xfs_dir2_node_addname() ->
> xfs_da_split() -> xfs_da_root_split()
>
>
> xfs_repair -n (the latest version of xfs_repair from cvs, as the SLES 10
> SP1 version just runs out of memory) does not report any problems with
> the file system, but after running xfs_repair (without -n) on the file
> system, the error can no longer be triggered. Based on this, I suspect a
> problem with the free space btrees, as I understand that xfs_repair
> rebuilds them. I tried running xfs_check (latest cvs version also) as
> well but it runs out of memory and dies.
>
> Are there any known issues in 2.6.16 that could lead to this sort of
> problem? If there is any additional information that would be helpful in
> tracking this down, please let me know. If needed, I can probably make a
> xfs_metadump of the file system available to someone from SGI later this
> week.
>
>
> Some additional information that may be useful:
>
>
> # xfs_info /fs
> meta-data=/dev/loop0             isize=1024   agcount=32, agsize=6179712
> blks
>          =                       sectsz=512   attr=1
> data     =                       bsize=4096   blocks=197750784, imaxpct=0
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
>
> # xfs_db -f -r -c 'sb 0' -c p /mnt/scratch3/xfs.fs
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 197750784
> rblocks = 0
> rextents = 0
> uuid = 18602b1d-e419-4f97-9bd7-37c4b64b884a
> logstart = 134217732
> rootino = 32
> rbmino = 33
> rsumino = 34
> rextsize = 1
> agblocks = 6179712
> agcount = 32
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3094
> sectsize = 512
> inodesize = 1024
> inopblock = 4
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 10
> inopblog = 2
> agblklog = 23
> rextslog = 0
> inprogress = 0
> imax_pct = 0
> icount = 72288384
> ifree = 1131
> fdblocks = 6101857
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
>
>
> This is for the directory that triggers the problem:
>
> # xfs_db -f -r -c 'inode 304409506' -c p /mnt/scratch3/xfs.fs
> core.magic = 0x494e
> core.mode = 040700
> core.version = 1
> core.format = 2 (extents)
> core.nlinkv1 = 2
> core.uid = 60000
> core.gid = 65534
> core.flushiter = 0
> core.atime.sec = Fri Sep 12 01:15:17 2008
> core.atime.nsec = 169962854
> core.mtime.sec = Fri Sep 12 01:24:41 2008
> core.mtime.nsec = 058880718
> core.ctime.sec = Fri Sep 12 01:24:41 2008
> core.ctime.nsec = 058880718
> core.size = 40960
> core.nblocks = 12
> core.extsize = 0
> core.nextents = 12
> core.naextents = 0
> core.forkoff = 24
> core.aformat = 1 (local)
> core.dmevmask = 0
> core.dmstate = 0
> core.newrtbm = 0
> core.prealloc = 0
> core.realtime = 0
> core.immutable = 0
> core.append = 0
> core.sync = 0
> core.noatime = 0
> core.nodump = 0
> core.rtinherit = 0
> core.projinherit = 0
> core.nosymlinks = 0
> core.extsz = 0
> core.extszinherit = 0
> core.nodefrag = 0
> core.gen = 0
> next_unlinked = null
> u.bmx[0-11] = [startoff,startblock,blockcount,extentflag]
> 0:[0,76102390,1,0] 1:[1,76102361,1,0] 2:[2,76102054,1,0]
> 3:[3,76102053,1,0] 4:[4,76101744,1,0] 5:[5,76101743,1,0]
> 6:[6,76101742,1,0] 7:[7,76101741,1,0] 8:[8,76101740,1,0]
> 9:[9,76101707,1,0] 10:[8388608,76102391,1,0] 11:[16777216,76102719,1,0]
> a.sfattr.hdr.totsize = 74
> a.sfattr.hdr.count = 2
> a.sfattr.list[0].namelen = 16
> a.sfattr.list[0].valuelen = 8
> a.sfattr.list[0].root = 1
> a.sfattr.list[0].secure = 0
> a.sfattr.list[0].name = "\004,\005XfY\016oapoBO\bR)"
> a.sfattr.list[0].value = "\000\000\000\000\000\000\000\000"
> a.sfattr.list[1].namelen = 16
> a.sfattr.list[1].valuelen = 24
> a.sfattr.list[1].root = 1
> a.sfattr.list[1].secure = 0
> a.sfattr.list[1].name = "\003>\016oMa7\034@#I8\004X\027G"
> a.sfattr.list[1].value =
> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
>
>
>
> # xfs_repair -f /mnt/scratch4/xfs.fs
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
>
>
>
> Thanks,
> Kevin Jamieson
>
>

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
