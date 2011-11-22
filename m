Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMLrB6k173994 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 15:53:11 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19E2B26E90A
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 13:53:09 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6dMsqCN52SynmY5e for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 13:53:09 -0800 (PST)
Message-ID: <4ECC19C3.5070905@sandeen.net>
Date: Tue, 22 Nov 2011 15:53:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: EFSCORRUPTED on mount?
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
	<CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
	<4ECBEF83.5020607@sandeen.net>
	<CAF3hT9CA23aDfYTF__mVEM7jRq=ZEgqhfX49hK9kcBqM_+h0CQ@mail.gmail.com>
In-Reply-To: <CAF3hT9CA23aDfYTF__mVEM7jRq=ZEgqhfX49hK9kcBqM_+h0CQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gregory Farnum <gregory.farnum@dreamhost.com>
Cc: xfs@oss.sgi.com

On 11/22/11 1:29 PM, Gregory Farnum wrote:
> On Tue, Nov 22, 2011 at 10:52 AM, Eric Sandeen <sandeen@sandeen.net> wrot=
e:
>> Ok, error 5 is EIO:
>>
>> 8 include/asm-generic/errno-base.h        8 #define EIO 5
>>
>> So the very first error you saw was "xfs_do_force_shutdown(0x1) called f=
rom line..." ?
>> Or the "xfs_log_force error 5 returned?"  I'm wondering if there was more
>> before this.
>>
>> It's worth looking carefully to see the very first problem reported by x=
fs,
>> and posibly from storage before that. (i.e. did your storage go wonky?)
> Oh, we have a few more logs than I'd thought to look for. The xfs
> related messages from bootup after the kernel upgrade:
> Nov 17 16:01:01 cephstore6358 kernel: [    1.924668] SGI XFS with
> security attributes, large block/inode numbers, no debug enabled
> ...
> Nov 17 16:01:01 cephstore6358 kernel: [  190.047204] XFS (sdc1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  190.198126] XFS (sdc1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  190.281929] XFS (sdc1):
> Ending recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  190.296303] XFS (sde1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  190.430809] XFS (sde1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  197.486417] XFS (sde1):
> Ending recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  197.492596] XFS (sdg1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  197.652085] XFS (sdg1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  197.724493] XFS (sdg1):
> Ending recovery (logdev: internal)

so by here sdg1 had to go through recovery, but was otherwise happy.

> Nov 17 16:01:01 cephstore6358 kernel: [  197.730526] XFS (sdi1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  197.871074] XFS (sdi1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  206.570177] XFS (sdi1):
> Ending recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  206.576329] XFS (sdk1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  206.738760] XFS (sdk1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  206.823346] XFS (sdk1):
> Ending recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  206.837938] XFS (sdm1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  206.962455] XFS (sdm1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  207.062120] XFS (sdm1):
> Ending recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  207.078134] XFS (sdo1):
> Mounting Filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  207.240052] XFS (sdo1):
> Starting recovery (logdev: internal)
> Nov 17 16:01:01 cephstore6358 kernel: [  207.321602] XFS (sdo1):
> Ending recovery (logdev: internal)
> ...

All that recovery a result of the icky shutdown procedure I guess....

> Nov 17 16:01:01 cephstore6358 kernel: [  214.214688] XFS: Internal
> error XFS_WANT_CORRUPTED_GOTO at line 1664 of file fs/xfs/xfs_alloc.c.
>  Caller 0xffffffff811d6b71

And this was the first indication of trouble.

> Nov 17 16:01:01 cephstore6358 kernel: [  214.214692]
> Nov 17 16:01:01 cephstore6358 kernel: [  214.227313] Pid: 11196, comm:
> ceph-osd Not tainted 3.1.0-dho-00004-g1ffcb5c-dirty #1
> Nov 17 16:01:01 cephstore6358 kernel: [  214.235056] Call Trace:
> Nov 17 16:01:01 cephstore6358 kernel: [  214.237530]
> [<ffffffff811d606e>] ? xfs_free_ag_extent+0x4e3/0x698
> Nov 17 16:01:01 cephstore6358 kernel: [  214.243717]
> [<ffffffff811d6b71>] ? xfs_free_extent+0xb6/0xf9
> Nov 17 16:01:01 cephstore6358 kernel: [  214.249468]
> [<ffffffff811d3034>] ? kmem_zone_alloc+0x58/0x9e
> Nov 17 16:01:01 cephstore6358 kernel: [  214.255220]
> [<ffffffff812095f9>] ? xfs_trans_get_efd+0x21/0x2a
> Nov 17 16:01:01 cephstore6358 kernel: [  214.261159]
> [<ffffffff811e2011>] ? xfs_bmap_finish+0xeb/0x160
> Nov 17 16:01:01 cephstore6358 kernel: [  214.266993]
> [<ffffffff811f8634>] ? xfs_itruncate_extents+0xe8/0x1d0
> Nov 17 16:01:01 cephstore6358 kernel: [  214.273361]
> [<ffffffff811f879f>] ? xfs_itruncate_data+0x83/0xee
> Nov 17 16:01:01 cephstore6358 kernel: [  214.279362]
> [<ffffffff811cb0a2>] ? xfs_setattr_size+0x246/0x36c
> Nov 17 16:01:01 cephstore6358 kernel: [  214.285363]
> [<ffffffff811cb1e3>] ? xfs_vn_setattr+0x1b/0x2f
> Nov 17 16:01:01 cephstore6358 kernel: [  214.291031]
> [<ffffffff810e7875>] ? notify_change+0x16d/0x23e
> Nov 17 16:01:01 cephstore6358 kernel: [  214.296776]
> [<ffffffff810d2982>] ? do_truncate+0x68/0x86
> Nov 17 16:01:01 cephstore6358 kernel: [  214.302172]
> [<ffffffff810d2b11>] ? sys_truncate+0x171/0x173
> Nov 17 16:01:01 cephstore6358 kernel: [  214.307846]
> [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
> Nov 17 16:01:01 cephstore6358 kernel: [  214.314031] XFS (sdg1):
> xfs_do_force_shutdown(0x8) called from line 3864 of file
> fs/xfs/xfs_bmap.c.  Return address =3D 0xffffffff811e2046

by here it had shut down, and you were just riding along when
it went kablooey.  Any non-xfs error just before this point?

> Nov 17 16:01:01 cephstore6358 kernel: [  214.340451] XFS (sdg1):
> Corruption of in-memory data detected.  Shutting down filesystem
> Nov 17 16:01:01 cephstore6358 kernel: [  214.348518] XFS (sdg1):
> Please umount the filesystem and rectify the problem(s)
> Nov 17 16:01:01 cephstore6358 kernel: [  227.789285] XFS (sdg1):
> xfs_log_force: error 5 returned.
> Nov 17 16:01:01 cephstore6358 kernel: [  229.820255] XFS (sdg1):
> xfs_log_force: error 5 returned.

To be honest I'm not sure offhand if this error 5 (EIO) is a
result of the shutdown, or the cause of it.

-Eric

> Nov 17 16:01:01 cephstore6358 kernel: [  229.825550] XFS (sdg1):
> xfs_do_force_shutdown(0x1) called from line 1037 of file
> fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff811c2aa8
> Nov 17 16:01:01 cephstore6358 kernel: [  229.845089] XFS (sdg1):
> xfs_log_force: error 5 returned.
> Nov 17 16:01:01 cephstore6358 kernel: [  229.850388] XFS (sdg1):
> xfs_do_force_shutdown(0x1) called from line 1037 of file
> fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff811c2aa8
> (etc)
> =

> I don't know the xfs code at all, but that looks like a bug to me =97
> either the system got itself into a broken state from valid on-disk
> structures, or else the (best I can tell properly-ordered, barriered,
> etc) journal didn't properly protect against brokenness elsewhere.
> Also note that the initial post-reboot mount succeeded (it didn't
> break until after doing a series of truncates), and the subsequent
> ones are failing.
> -Greg
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
