Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6N4ArDr028716 for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 23:10:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78248AC8DD1
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 21:19:51 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Je7Klt5sJ7OFLr7w for
	<xfs@oss.sgi.com>; Wed, 22 Jul 2009 21:19:51 -0700 (PDT)
Message-ID: <4A67E2F5.2030400@sandeen.net>
Date: Wed, 22 Jul 2009 23:11:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem shutting down on linux 2.6.28.9 (xfs_rename)
References: <000c01ca0ae0$e85420a0$b8fc61e0$@fr>
In-Reply-To: <000c01ca0ae0$e85420a0$b8fc61e0$@fr>
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
To: Gabriel Barazer <gabriel@oxeva.fr>
Cc: xfs@oss.sgi.com

Gabriel Barazer wrote:
> Hi,
> 
> I recently put a NFS file server into production, with mostly XFS volumes on LVM. The server was quite low on traffic until this morning and one of the filesystems crashed twice since this morning with the following backtrace:
> 
> Filesystem "dm-24": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811b09a7
> Pid: 2053, comm: nfsd Not tainted 2.6.28.9-filer #1
> Call Trace:
>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>  [<ffffffff811b1806>] xfs_trans_cancel+0x56/0xed
>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
...

> xfs_force_shutdown(dm-24,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811b181f
> Filesystem "dm-24": Corruption of in-memory data detected.  Shutting down filesystem: dm-24
> 
> The two crashed are related to the same function: xfs_rename.

Can you do objdump -d xfs.ko | grep "xfs_rename\|xfs_trans_cancel" and
maybe we can see which call to xfs_trans_cancel in xfs_rename this was.

The problem relates to canceling a dirty transaction on an error path.

-Eric

> I _really_ cannot upgrade to 2.6.29 or later because of the "reconnect_path: npd != pd" bug and the maybe related radix-tree bug ( http://bugzilla.kernel.org/show_bug.cgi?id=13375 ) affecting all kernel version afeter 2.6.28.
> 
> Unmounting then remounting the filesystem allow to access the mountpoint again without any error message or apparent file corruption.
> This filesystem is used by ~30 NFS clients and contains about 5M files (100GB).
> 
> Before using the volume over NFS, there was only local activity (rsync syncing) and we didn't get any error.
> 
> I expect to see this crash again in a few hours except if the volume is really corrupted. Does a full filesystem copy to a newly created volume would have a chance to solve the problem?
> 
> Thanks,
> 
> Gabriel
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
