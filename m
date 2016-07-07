Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3719D7CFB
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 06:49:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBC758F80E5
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 04:49:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fN4GGJNmzMD8rtWp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 04:49:07 -0700 (PDT)
Date: Thu, 7 Jul 2016 07:49:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs mount hung on a corrupted filesystem
Message-ID: <20160707114905.GA3365@laptop.bfoster>
References: <d44e3415e126865eee4b216339cf9858@mail.gmail.com>
	<20160706113534.GA24552@bfoster.bfoster>
	<2f90f396734caeed89cc599acb0aa42d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2f90f396734caeed89cc599acb0aa42d@mail.gmail.com>
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
To: Kirubakaran Kaliannan <kirubak@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2016 at 10:27:11AM +0530, Kirubakaran Kaliannan wrote:
> Thanks Brain, I will check whether we can move up to v4.3.
> 
> In the mean time, I want to automate this situation. Run xfsrepair -L
> before trying to mount, By checking whether the file system is corrupted
> without mounting it. Not sure whether we can differentiate a mount which
> is going to hang and which is not. ?
> 

I don't think you'll easily be able to tell whether log recovery is
going to hang. The best you can probably do is to run 'xfs_repair -n'
and identify whether it flags any issues based on the return code.

Note that a filesystem that requires log recovery can appear
inconsistent to repair and xfs_repair doesn't replay the log. Therefore,
I would only suggest to use this to flag whether a mount has the
potential to hang. If you automatically run xfs_repair -L in such cases,
you destroy the log in most cases where log recovery is required (e.g.,
you basically just bypass the log). All in all, that's not something I
would recommend...

Brian

> Thanks,
> -kiru
> 
> 
> 
> -----Original Message-----
> From: Brian Foster [mailto:bfoster@redhat.com]
> Sent: Wednesday, July 06, 2016 5:06 PM
> To: Kirubakaran Kaliannan
> Cc: xfs@oss.sgi.com
> Subject: Re: xfs mount hung on a corrupted filesystem
> 
> On Wed, Jul 06, 2016 at 04:04:54PM +0530, Kirubakaran Kaliannan wrote:
> > Hi All,
> >
> >
> >
> > Sending it once again, in case we all missed this earlier mail,
> >
> >
> >
> > Any help is much appreciated.
> >
> > This bug hangs the mount with the following stack. Similar to (
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382801)
> >
> 
> It's hard to say for sure, but this could be due to historical EFI/EFD
> reference counting brokenness. This was known to lead to unmount hangs on
> mount failure, shutdown situations, etc. This code was totally reworked in
> v4.3.0 and I don't think includes any fixes that are easily backportable
> to such an old kernel. You should be able to avoid this by repairing the
> fs such that it mounts, fwiw.
> 
> Brian
> 
> >
> >
> > root@zios-vsa-00000253-vc-0:~# cat /proc/26511/task/26511/stack
> >
> > [<ffffffffc0776c69>] xfs_ail_push_all_sync+0xa9/0xe0 [xfs]
> >
> > [<ffffffffc076c2e7>] xfs_log_quiesce+0x37/0x70 [xfs]
> >
> > [<ffffffffc076c33a>] xfs_log_unmount+0x1a/0x70 [xfs]
> >
> > [<ffffffffc0760845>] xfs_mountfs+0x5e5/0x7b0 [xfs]
> >
> > [<ffffffffc0763fca>] xfs_fs_fill_super+0x2ca/0x360 [xfs]
> >
> > [<ffffffff811eb220>] mount_bdev+0x1b0/0x1f0
> >
> > [<ffffffffc0761c95>] xfs_fs_mount+0x15/0x20 [xfs]
> >
> > [<ffffffff811ebb79>] mount_fs+0x39/0x1b0
> >
> > [<ffffffff812070db>] vfs_kern_mount+0x6b/0x120
> >
> > [<ffffffff8120a032>] do_mount+0x222/0xca0
> >
> > [<ffffffff8120adab>] SyS_mount+0x8b/0xe0
> >
> > [<ffffffff817179cd>] system_call_fastpath+0x16/0x1b
> >
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >
> >
> >
> >
> >
> > Is this a known issue ? otherwise how to avoid the hang, a mount
> > failure will help to force-repair the filesystem and remount.
> >
> >
> >
> > Thanks
> >
> > -kiru
> >
> >
> >
> > *From:* Kirubakaran Kaliannan [mailto:kirubak@zadarastorage.com]
> > *Sent:* Wednesday, June 29, 2016 11:25 AM
> > *To:* 'xfs@oss.sgi.com'
> > *Subject:* xfs mount hung on a corrupted filesystem
> >
> >
> >
> >
> >
> > Hi XFS-developers,
> >
> >
> >
> > We are running XFS on ubuntu kernel-3.18.19
> >
> >
> >
> > On a drive failure connected to my server, the file-system experienced
> > the corruption. Attached the corruption.out file which contains the
> > information regarding the corruption.
> >
> >
> >
> > Later when the file-system is unmounted and mounted back, the mount
> > hung with the following stack (attached the dmesg when mount is run)
> >
> >
> >
> > ------------------
> >
> > [ 3611.093909]  [<ffffffff81710c85>] dump_stack+0x4e/0x71
> >
> > [ 3611.093943]  [<ffffffffc07ff68e>] xfs_error_report+0x3e/0x40 [xfs]
> >
> > [ 3611.093964]  [<ffffffffc07beccc>] ? xfs_free_extent+0x10c/0x170
> > [xfs]
> >
> > [ 3611.093984]  [<ffffffffc07bd45f>]
> > xfs_free_ag_extent.constprop.13+0x20f/0x980 [xfs]
> >
> > [ 3611.094012]  [<ffffffffc07be4cf>] ?
> > xfs_alloc_fix_freelist+0x4af/0x510
> > [xfs]
> >
> > [ 3611.094070]  [<ffffffffc07beccc>] xfs_free_extent+0x10c/0x170 [xfs]
> >
> > [ 3611.094120]  [<ffffffffc0827da5>]
> > xlog_recover_process_efi+0x175/0x1b0
> > [xfs]
> >
> > [ 3611.094180]  [<ffffffffc0829ed4>]
> > xlog_recover_process_efis.isra.27+0x64/0xb0 [xfs]
> >
> > [ 3611.094227]  [<ffffffffc082d181>] xlog_recover_finish+0x21/0xb0
> > [xfs]
> >
> > [ 3611.094271]  [<ffffffffc0821204>] xfs_log_mount_finish+0x34/0x50
> > [xfs]
> >
> > [ 3611.094317]  [<ffffffffc0817769>] xfs_mountfs+0x509/0x7b0 [xfs]
> >
> > [ 3611.094359]  [<ffffffffc081afca>] xfs_fs_fill_super+0x2ca/0x360
> > [xfs]
> >
> > [ 3611.094369]  [<ffffffff811eb220>] mount_bdev+0x1b0/0x1f0
> >
> > [ 3611.094406]  [<ffffffffc081ad00>] ? xfs_parseargs+0xbe0/0xbe0 [xfs]
> >
> > [ 3611.094443]  [<ffffffffc0818c95>] xfs_fs_mount+0x15/0x20 [xfs]
> >
> > [ 3611.094452]  [<ffffffff811ebb79>] mount_fs+0x39/0x1b0
> >
> > [ 3611.094460]  [<ffffffff81192fc5>] ? __alloc_percpu+0x15/0x20
> >
> > [ 3611.094472]  [<ffffffff812070db>] vfs_kern_mount+0x6b/0x120
> >
> > [ 3611.094479]  [<ffffffff8120a032>] do_mount+0x222/0xca0
> >
> > [ 3611.094486]  [<ffffffff8120adab>] SyS_mount+0x8b/0xe0
> >
> > [ 3611.094495]  [<ffffffff817179cd>] system_call_fastpath+0x16/0x1b
> >
> > [ 3611.094512] XFS (dm-56): Failed to recover EFIs
> >
> > [ 3611.095813] XFS (dm-56): log mount finish failed
> >
> > -----------
> >
> >
> >
> > My initial analysis shows, exactly the issue is same as in (but
> > expired)
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382801
> >
> >
> >
> > filesystem getting corrupted is the first problem. But the mount hang
> > instead of failing is making it difficult to repair the filesystem.
> >
> >
> >
> > Can you please help progress on this issue ?
> >
> > I have the metadump of the filesystem, and can provide any details
> required.
> >
> >
> >
> > Thanks
> >
> > -kiru
> 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
