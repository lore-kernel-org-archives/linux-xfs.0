Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1A3RDW7216370 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 21:27:13 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id bdIcwKVtM8jo3KF7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 19:27:11 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1Rvh8h-0006sZ-0n
	for xfs@oss.sgi.com; Thu, 09 Feb 2012 19:27:11 -0800
Message-ID: <33297927.post@talk.nabble.com>
Date: Thu, 9 Feb 2012 19:27:11 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: Re: Inode lockdep problem observed on 2.6.37.6 xfs with RT subvolume
In-Reply-To: <20120202162823.GA3425@infradead.org>
MIME-Version: 1.0
References: <CAC=U0a1huHVULfMObyH_XNcQi5aTZtrbpcciNhw=92PE96f4cg@mail.gmail.com>
	<20120202091330.GA31203@infradead.org>
	<CAC=U0a11udmsGAKg5Sp+X2uxRTKS8gq37CK9OAZKhLOPKbWHKQ@mail.gmail.com>
	<20120202162823.GA3425@infradead.org>
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
To: xfs@oss.sgi.com


Christoph,

I would like to share some update on the issue I reported on the RT
subvolume with more 
data.

I have back ported the three patches to  2.6.37.  
> > ?xfs: only lock the rt bitmap inode once per allocation
> > ?xfs: fix xfs_get_extsz_hint for a zero extent size hint
> > ?xfs: add lockdep annotations for the rt inodes

With the patches the situation is slightly better however there seems to be
a 
recursive deadlock as part of xfs_fs_evict_inode, if there are multiple
extents
associated with the same inode. 

This is a stack trace during a mount after a reboot when the log is
replayed, however 
exactly the same path fails and deadlocks when the evict operation is 
attempted before a reboot. 

xfs_ilock(ip, XFS_ILOCK_EXCL) being acquired twice in a recursive loop
deadlock :

#0  xfs_ilock (ip=0xcf879980, lock_flags=33554436) at fs/xfs/xfs_iget.c:498
#1  0x801ee674 in xfs_iget_cache_hit (mp=0xcf640400, tp=0xcf0c0e58,
ino=<value
optimized out>, flags=0, lock_flags=33554436, 
    ipp=0xcf60f950) at fs/xfs/xfs_iget.c:238
#2  xfs_iget (mp=0xcf640400, tp=0xcf0c0e58, ino=<value optimized out>,
flags=0, lock_flags=33554436, ipp=0xcf60f950)
    at fs/xfs/xfs_iget.c:391
#3  0x80215b50 in xfs_trans_iget (mp=<value optimized out>, tp=0xcf0c0e58,
ino=<value optimized out>, flags=0, lock_flags=33554436, 
    ipp=0xcf60f950) at fs/xfs/xfs_trans_inode.c:60
#4  0x801a7044 in xfs_rtfree_extent (tp=0xcf0c0e58, bno=<value optimized
out>,
len=9) at fs/xfs/xfs_rtalloc.c:2166
#5  0x801c05d0 in xfs_bmap_del_extent (ip=0xcf879380, tp=<value optimized
out>, idx=0, flist=0xcf60fbb0, cur=0x0, del=0xcf60fad0, 
    logflagsp=0xcf60fac0, whichfork=0, rsvd=0) at fs/xfs/xfs_bmap.c:2892
#6  0x801c5460 in xfs_bunmapi (tp=0xcf0c0e58, ip=0xcf879380, bno=2303,
len=4294967297, flags=0, nexts=2, firstblock=0xcf60fba8, 
    flist=0xcf60fbb0, done=0xcf60fba0) at fs/xfs/xfs_bmap.c:5256
#7  0x801f0a88 in xfs_itruncate_finish (tp=0xcf60fc14, ip=0xcf879380,
new_size=<value optimized out>, fork=0, sync=1)
    at fs/xfs/xfs_inode.c:1585
#8  0x80218428 in xfs_inactive (ip=0xcf879380) at fs/xfs/xfs_vnodeops.c:1102
#9  0x800e2be4 in evict (inode=0xcf8794c0) at fs/inode.c:450
#10 0x800e3300 in iput_final (inode=0xcf8794c0) at fs/inode.c:1401
#11 iput (inode=0xcf8794c0) at fs/inode.c:1423
#12 0x80208740 in xlog_recover_process_one_iunlink (mp=0xcf640400,
agno=<value
optimized out>, agino=<value optimized out>, bucket=29)
    at fs/xfs/xfs_log_recover.c:3212
#13 0x8020884c in xlog_recover_process_iunlinks (log=<value optimized out>)
at
fs/xfs/xfs_log_recover.c:3289
#14 0x80209928 in xlog_recover_finish (log=0xcf638000) at
fs/xfs/xfs_log_recover.c:3926
#15 0x8020de74 in xfs_mountfs (mp=0xcf640400) at fs/xfs/xfs_mount.c:1386
#16 0x8022d228 in xfs_fs_fill_super (sb=0xcf5ff400, data=<value optimized
out>, silent=<value optimized out>)
    at fs/xfs/linux-2.6/xfs_super.c:1539
#17 0x800cbe68 in mount_bdev (fs_type=<value optimized out>, flags=32768,
dev_name=<value optimized out>, data=0xcfc52000, 
    fill_super=0x8022d04c <xfs_fs_fill_super>) at fs/super.c:820
#18 0x8022a6a4 in xfs_fs_mount (fs_type=<value optimized out>, flags=<value
optimized out>, dev_name=<value optimized out>, 
    data=<value optimized out>) at fs/xfs/linux-2.6/xfs_super.c:1616
#19 0x800ca6e0 in vfs_kern_mount (type=0x80597e10, flags=<value optimized
out>, name=<value optimized out>, data=<value optimized out>)
    at fs/super.c:986
#20 0x800ca888 in do_kern_mount (fstype=0xcff42580 "xfs", flags=<value
optimized out>, name=<value optimized out>, 
    data=<value optimized out>) at fs/super.c:1155
#21 0x800e9f08 in do_new_mount (dev_name=0xcf600100 "/dev/sda2",
dir_name=<value optimized out>, type_page=0xcff42580 "xfs", 
    flags=32768, data_page=0xcfc52000) at fs/namespace.c:1746
#22 do_mount (dev_name=0xcf600100 "/dev/sda2", dir_name=<value optimized
out>,
type_page=0xcff42580 "xfs", flags=32768, 
    data_page=0xcfc52000) at fs/namespace.c:2066
#23 0x800ea9d0 in sys_mount (dev_name=0x46e5d4 "/dev/sda2", dir_name=<value
optimized out>, type=<value optimized out>, flags=33792, 
    data=0x4700b0) at fs/namespace.c:2210
#24 0x800117bc in handle_sys () at arch/mips/kernel/scall32-o32.S:59
#25 0x0041ff1c in ?? ()
warning: GDB can't find the start of the function at 0x41ff1b.

The code deadlocks here :
xfs_iget.c
515             if (lock_flags & XFS_ILOCK_EXCL)
516                     mrupdate_nested(&ip->i_lock,

In case of 2.6.37 xfs_iget_cache_hit try's to lock repeatedly during the
evict.
I had to fix the locking by detecting if the inode is already locked and is
part of 
a transaction tp and also prevent from calleing xfs_trans_ijoin().
I can post the patch, however I would like to know if this deadlock makes
sense 
to you.

I suspect the same occurs with 2.6.39 as well. Although the xfs_trans_iget()
got replaced with the xfs_ilock() the deadlock can happen in
xfs_rtfree_extents().

Code on the 2.6.37 :

xfs_rt
int xfs_rtfree_extent() {
...
...

	/*
	 * Synchronize by locking the bitmap inode.
	 */
	error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
			       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);

...
...

}


Code on 2.6.39

int xfs_rtfree_extent() {
...
...
	/*
	 * Synchronize by locking the bitmap inode.
	 */
	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);  /*called from the upstream calling
function while loop*/
	xfs_trans_ijoin_ref(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
..
..
}

Kamal


Christoph Hellwig wrote:
> 
> On Thu, Feb 02, 2012 at 11:26:28AM -0500, Kamal Dasu wrote:
>> > ?xfs: only lock the rt bitmap inode once per allocation
>> > ?xfs: fix xfs_get_extsz_hint for a zero extent size hint
>> > ?xfs: add lockdep annotations for the rt inodes
>> >
>> > But in general the RT subvolume code is not regularly tested and only
>> > fixed when issues arise.
>> 
>> 
>> Thanks for quick reply and clarifying this, if upgrading the kernel is
>> not an option, should I be
>> considering backporting  changes to 2.6.37,  should I  use the entire
>> 2.6.39 or 3.0
>> xfs implementation as is of cherry pick the above three changes ?.
> 
> I don't remember if we have other changes in that area.  If backporting
> the changes is easy enough, go for it, if not stick to your original
> workaround.  Either way make sure you don't introduce other regressions
> by running xfstests.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

-- 
View this message in context: http://old.nabble.com/Inode-lockdep-problem-observed-on-2.6.37.6-xfs-with-RT-subvolume-tp33247492p33297927.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
