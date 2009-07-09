Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69MFOfx056124 for <xfs@oss.sgi.com>; Thu, 9 Jul 2009 17:15:25 -0500
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A403354743
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 15:16:00 -0700 (PDT)
Received: from slurp.thebarn.com (mail.thebarn.com [208.42.117.202]) by
	cuda.sgi.com with ESMTP id Wz00Gv1eh5UEWX47 for
	<xfs@oss.sgi.com>; Thu, 09 Jul 2009 15:16:00 -0700 (PDT)
Received: from funky.x.thebarn.com (slurp.x.thebarn.com [10.0.0.11])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.3/8.14.0) with ESMTP id n69MFa85099917;
	Thu, 9 Jul 2009 17:15:52 -0500 (CDT) (envelope-from cattelan@xfs.org)
Message-ID: <4A566C08.6070302@xfs.org>
Date: Thu, 09 Jul 2009 17:15:36 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: Growfs 10Tb extension corrupted FS
References: <17646_1247153558_4A560D96_17646_249626_1_OFD6EDBDC1.E3DD344B-ONC12575EE.0054FDE0-C12575EE.00556215@exane.com>
In-Reply-To: <17646_1247153558_4A560D96_17646_249626_1_OFD6EDBDC1.E3DD344B-ONC12575EE.0054FDE0-C12575EE.00556215@exane.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Frederic Patrault <Frederic.Patrault@exane.com>
Cc: xfs@oss.sgi.com

Frederic Patrault wrote:
> Hello,
>
>
>
> i ran into the bug http://oss.sgi.com/archives/xfs/2007-01/msg00053.html on
> Centos 5.2 x64
> TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
>
>   
Heh ya our old friend.

I do have experience with trying to back out from this issue, but the
amount of data
depends on how much the fs was mucked with.

Basically what you will need to do is with xfs_db reset the the FS size
and ag count back
to what is was before the grow cmd messed it up.

The last ag will still potentially be wrong since the grow cmd try to
convert it from a
partial ag a full ag and those numbers are probably wrong as well.

If repair was run that is a different story and may or may not have
made  big mess of things.


>
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1588 of
> file /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_alloc.c.
> Caller 0xffffffff8859056b
>
> Call Trace:
>  [<ffffffff8858ec7e>] :xfs:xfs_free_ag_extent+0x19f/0x67f
>  [<ffffffff8859056b>] :xfs:xfs_free_extent+0xa9/0xc9
>  [<ffffffff885b2f0e>] :xfs:xfs_growfs_data+0x7b3/0x999
>  [<ffffffff885dab90>] :xfs:xfs_ioctl+0x11ec/0x137c
>  [<ffffffff80014864>] n_tty_receive_buf+0xd45/0xdc5
>  [<ffffffff80014864>] n_tty_receive_buf+0xd45/0xdc5
>  [<ffffffff80055c55>] pty_write+0x32/0x3a
>  [<ffffffff8002e254>] __wake_up+0x38/0x4f
>  [<ffffffff8008ac03>] default_wake_function+0x0/0xe
>  [<ffffffff885d9408>] :xfs:xfs_file_ioctl+0x2f/0x57
>  [<ffffffff80041a45>] do_ioctl+0x21/0x6b
>  [<ffffffff8002ff32>] vfs_ioctl+0x248/0x261
>  [<ffffffff8004be14>] sys_ioctl+0x59/0x78
>  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
>
> Filesystem "dm-10": XFS internal error xfs_trans_cancel at line 1138 of
> file /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_trans.c.
> Caller 0xffffffff885b30a4
>
> Call Trace:
>  [<ffffffff885ca923>] :xfs:xfs_trans_cancel+0x5b/0xfe
>  [<ffffffff885b30a4>] :xfs:xfs_growfs_data+0x949/0x999
>  [<ffffffff885dab90>] :xfs:xfs_ioctl+0x11ec/0x137c
>  [<ffffffff80014864>] n_tty_receive_buf+0xd45/0xdc5
>  [<ffffffff80014864>] n_tty_receive_buf+0xd45/0xdc5
>  [<ffffffff80055c55>] pty_write+0x32/0x3a
>  [<ffffffff8002e254>] __wake_up+0x38/0x4f
>  [<ffffffff8008ac03>] default_wake_function+0x0/0xe
>  [<ffffffff885d9408>] :xfs:xfs_file_ioctl+0x2f/0x57
>  [<ffffffff80041a45>] do_ioctl+0x21/0x6b
>  [<ffffffff8002ff32>] vfs_ioctl+0x248/0x261
>  [<ffffffff8004be14>] sys_ioctl+0x59/0x78
>  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
>
> xfs_force_shutdown(dm-10,0x8) called from line 1139 of
> file /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_trans.c.
> Return address = 0xffffffff885ca941
> Filesystem "dm-10": Corruption of in-memory data detected.  Shutting down
> filesystem: dm-10
> Please umount the filesystem, and rectify the problem(s)
> xfs_force_shutdown(dm-10,0x1) called from line 424 of
> file /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_rw.c.
> Return address = 0xffffffff885d47f1
> xfs_force_shutdown(dm-10,0x1) called from line 424 of
> file /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_rw.c.
> Return address = 0xffffffff885d47f1
> Filesystem "dm-10": Disabling barriers, not supported by the underlying
> device
> attempt to access beyond end of device
> dm-10: rw=0, want=71676493824, limit=49392123904
> I/O error in filesystem ("dm-10") meta-data dev dm-10 block 0x10b0407fff
> ("xfs_read_buf") error 5 buf count 512
> XFS: size check 2 failed
> Filesystem "dm-10": Disabling barriers, not supported by the underlying
> device
> attempt to access beyond end of device
> dm-10: rw=0, want=71676493824, limit=49392123904
> I/O error in filesystem ("dm-10") meta-data dev dm-10 block 0x10b0407fff
> ("xfs_read_buf") error 5 buf count 512
> XFS: size check 2 failed
> Filesystem "dm-10": Disabling barriers, not supported by the underlying
> device
> attempt to access beyond end of device
> dm-10: rw=0, want=71676493824, limit=49392123904
> I/O error in filesystem ("dm-10") meta-data dev dm-10 block 0x10b0407fff
> ("xfs_read_buf") error 5 buf count 512
> XFS: size check 2 failed
>
>
>
>
> i'm trying to sort out to get the situation back before the extension but i
> did not manage
> please advise on how i could :
>
> Original FS was ~13Tb i added ~10Tb then XFS failed to growfs because of
> the bug
> Now i xfs_repair it is a success but when i mount the FS i have a ~35Tb FS
>
> umount the trying to mount it give an error same problem, 1st magic number
> can't be found
>
>
> i don't know how to fix it ;-(
>
> xfs_db -r /dev/VG_SAN_DATA01/VDL_DATA01
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 8959561728
> rblocks = 0
> rextents = 0
> uuid = cc4a679f-5153-4b6b-8620-8a12546845ef
> logstart = 2147483652
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 1
> agblocks = 75112352
> agcount = 120
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3084
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 27
> rextslog = 0
> inprogress = 0
> imax_pct = 25
> icount = 768
> ifree = 49
> fdblocks = 5599584628
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
> #cat /proc/partitions
> 253    10 24696061952 dm-10
>
> kind regards
> Frederic Patrault
>
>
>
>         ___________________________________
>
> The integrity of this message cannot be guaranteed on the internet .Therefore EXANE cannot be considered responsible for the contents.
> If you are not the intended recipient of this  message ,please delete it and notify the sender.
>
> This message is provided for information purposes only and should not be construed as a solicitation or offer to buy or sell any securities or related financial instruments
> Although it may contain some elements from publications produced by Exane's research department ,this message is not research.
> Please consult our web site for important disclaimers and disclosures concerning Exane's research  (http://www.exane.com)
>         ___________________________________
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
