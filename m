Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p426BuSt216077 for <xfs@oss.sgi.com>; Mon, 2 May 2011 01:11:56 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E0FC511FC0
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 23:15:30 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id AaC7oIEpy54xqAtc for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 23:15:30 -0700 (PDT)
Date: Mon, 2 May 2011 08:15:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110502061528.GA22538@x4.trippels.de>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110429151841.GA893@x4.trippels.de>
	<20110429213524.449e003b@neptune.home>
	<20110430161810.6ccd2c99@neptune.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110430161810.6ccd2c99@neptune.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>

On 2011.04.30 at 16:18 +0200, Bruno Pr=E9mont wrote:
> On Fri, 29 April 2011 Bruno Pr=E9mont wrote:
> > On Fri, 29 April 2011 Markus Trippelsdorf wrote:
> > > On 2011.04.29 at 11:19 +1000, Dave Chinner wrote:
> > > > OK, so the common elements here appears to be root filesystems
> > > > with small log sizes, which means they are tail pushing all the
> > > > time metadata operations are in progress. Definitely seems like a
> > > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > > reproduce this and cook up a patch to fix it.
> > > =

> > > Hmm, I'm wondering if this issue is somehow related to the hrtimer bu=
g,
> > > that Thomas Gleixner fixed yesterday:
> > > http://git.us.kernel.org/?p=3Dlinux/kernel/git/tip/linux-2.6-tip.git;=
a=3Dcommit;h=3Dce31332d3c77532d6ea97ddcb475a2b02dd358b4
> > > http://thread.gmane.org/gmane.linux.kernel.mm/61909/
> > > =

> > > It also looks similar to the issue that James Bottomley reported
> > > earlier: http://thread.gmane.org/gmane.linux.kernel.mm/62185/ =

> > =

> > I'm going to see, I've applied Thomas' fix on the box seeing XFS freeze=
 (without
> > other changes to kernel).
> > Going to run that kernel for the week-end and beyond if it survives to =
see what
> > happens.
> =

> Happened again (after a few hours of uptime), so it definitely is not
> caused by hrtimer bug that Thomas Gleixner fixed.

I've enabled lock debugging and this is what happened after a few hours
uptime. (I can't tell if this is a false positive):

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[ INFO: possible circular locking dependency detected ]
2.6.39-rc5-00130-g3fd9952 #10
-------------------------------------------------------
kio_file/7364 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#5/2){+.+...}, at: [<ffffffff81151e4e>] generic_f=
ile_splice_write+0xce/0x180

but task is already holding lock:
 (xfs_iolock_active){++++++}, at: [<ffffffff811d7d05>] xfs_ilock+0x125/0x1f0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (xfs_iolock_active){++++++}:
       [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
       [<ffffffff8109d9bf>] down_write_nested+0x2f/0x60
       [<ffffffff811d7d05>] xfs_ilock+0x125/0x1f0
       [<ffffffff812061d6>] xfs_file_buffered_aio_write+0x66/0x290
       [<ffffffff81206561>] xfs_file_aio_write+0x161/0x300
       [<ffffffff811261f2>] do_sync_write+0xd2/0x110
       [<ffffffff811262df>] vfs_write+0xaf/0x160
       [<ffffffff8112646a>] sys_write+0x4a/0x90
       [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b

-> #1 (&sb->s_type->i_mutex_key#5){+.+.+.}:
       [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
       [<ffffffff81549981>] mutex_lock_nested+0x51/0x370
       [<ffffffff81135afd>] vfs_rename+0xed/0x420
       [<ffffffff81136037>] sys_renameat+0x207/0x230
       [<ffffffff8113607b>] sys_rename+0x1b/0x20
       [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#5/2){+.+...}:
       [<ffffffff810ac21f>] __lock_acquire+0x169f/0x1b90
       [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
       [<ffffffff81549981>] mutex_lock_nested+0x51/0x370
       [<ffffffff81151e4e>] generic_file_splice_write+0xce/0x180
       [<ffffffff81205334>] xfs_file_splice_write+0xf4/0x250
       [<ffffffff8115024e>] do_splice_from+0x7e/0xb0
       [<ffffffff811502a0>] direct_splice_actor+0x20/0x30
       [<ffffffff81151fde>] splice_direct_to_actor+0xbe/0x1c0
       [<ffffffff81152158>] do_splice_direct+0x78/0x90
       [<ffffffff81125f72>] do_sendfile+0x182/0x1d0
       [<ffffffff81126f1a>] sys_sendfile64+0x5a/0xb0
       [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by kio_file/7364:
 #0:  (xfs_iolock_active){++++++}, at: [<ffffffff811d7d05>] xfs_ilock+0x125=
/0x1f0

stack backtrace:
Pid: 7364, comm: kio_file Not tainted 2.6.39-rc5-00130-g3fd9952 #10
Call Trace:
 [<ffffffff81543f4c>] print_circular_bug+0xb8/0xc7
 [<ffffffff810ac21f>] __lock_acquire+0x169f/0x1b90
 [<ffffffff8115153d>] ? __generic_file_splice_read+0x1cd/0x5c0
 [<ffffffff810ae8a2>] lock_acquire+0x92/0x1f0
 [<ffffffff81151e4e>] ? generic_file_splice_write+0xce/0x180
 [<ffffffff8148de90>] ? sock_def_write_space+0x140/0x140
 [<ffffffff81549981>] mutex_lock_nested+0x51/0x370
 [<ffffffff81151e4e>] ? generic_file_splice_write+0xce/0x180
 [<ffffffff81151e4e>] generic_file_splice_write+0xce/0x180
 [<ffffffff81205334>] xfs_file_splice_write+0xf4/0x250
 [<ffffffff8120510f>] ? xfs_file_splice_read+0xef/0x220
 [<ffffffff8115024e>] do_splice_from+0x7e/0xb0
 [<ffffffff811502a0>] direct_splice_actor+0x20/0x30
 [<ffffffff81151fde>] splice_direct_to_actor+0xbe/0x1c0
 [<ffffffff81150280>] ? do_splice_from+0xb0/0xb0
 [<ffffffff81152158>] do_splice_direct+0x78/0x90
 [<ffffffff81125f72>] do_sendfile+0x182/0x1d0
 [<ffffffff81126f1a>] sys_sendfile64+0x5a/0xb0
 [<ffffffff8154cc6b>] system_call_fastpath+0x16/0x1b


-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
