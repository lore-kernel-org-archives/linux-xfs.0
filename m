Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 304DA7F58
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 22:01:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72F9AAC004
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 20:01:06 -0700 (PDT)
Received: from mail-we0-f176.google.com (mail-we0-f176.google.com
	[74.125.82.176]) by cuda.sgi.com with ESMTP id efToCKimFq1h5bug
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Jul 2014 20:00:59 -0700 (PDT)
Received: by mail-we0-f176.google.com with SMTP id u56so11919829wes.21
	for <xfs@oss.sgi.com>; Wed, 02 Jul 2014 20:00:57 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90]) by mx.google.com with ESMTPSA id
	nb8sm61843318wic.18.2014.07.02.20.00.51 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 02 Jul 2014 20:00:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 381AA6072A
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 05:00:50 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1ebquqKMT-vI for <xfs@oss.sgi.com>;
	Thu,  3 Jul 2014 05:00:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 5F7F1604A0
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 05:00:47 +0200 (CEST)
Date: Thu, 3 Jul 2014 05:00:47 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <20140702120441.GA51757@bfoster.bfoster>
Message-ID: <alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Wednesday, 2014-07-02 at 08:04 -0400, Brian Foster wrote:
> On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:

...

> This is the background eofblocks scanner attempting to free preallocated
> space on a file. The scanner looks for files that have been recently
> grown and since been flushed to disk (i.e., no longer concurrently being
> written to) and trims the post-eof preallocation that comes along with
> growing files.
>
> The corruption errors at xfs_alloc.c:1602,1629 on v3.11 fire if the
> extent we are attempting to free is already accounted for in the
> by-block allocation btree. IOW, this is attempting to free an extent
> that the allocation metadata thinks is already free.
>
>>
>> Brief description:
>>
>>
>>  * It happens only on restore from hibernation.
>
> Interesting, could you elaborate a bit more on the behavior this system
> is typically subjected to? i.e., is this a server that sees a constant
> workload that is also frequently hibernated/awakened?

It is a desktop machine I use for work at home. I typically have many 
applications opened on diferent workspaces in XFCE. Say one has terminals, 
another has Thunderbird/Pine, another Firefox, another LibreOffice; 
another may have gimp, another may be kbabel or lokalize, another may have 
vmplayer, etc, whatever. When I go out or go to sleep, I hibernate the 
machine, instead of powering down, because it is much faster than reboot, 
login, and start the wanted applications, and I want to conserve some 
electricity.

I also use the machine for testing configurations, but these I try to do 
on virtual machines, instead of my work partition.


The machine may be used anywhere from 4 to 16 hours a day, and hibernated 
at least once a day, perhaps three times if I have to go out several 
times. It makes no sense to me to leave the machine powered doing nothing, 
if hibernating is so easy and reliable - till now. If I have to leave for 
more than a week, I tend to do a full "halt".



By the way, this started hapening when I replaced an old 500 GB hard disk 
(Seagate ST3500418AS) with a 2 TB new unit (Seagate ST2000DM001-1CH164). 
Smartctl long test says fine (and seatools from Windows, too).



>> I do not have more info than what appears on the logs, but four times (two
>> different kernels):
>>
>> cer@Telcontar:~> zgrep XFS_WANT_CORRUPTED_GOTO /var/log/messages*xz
>> /var/log/messages-20140402.xz:<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111787] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
>> /var/log/messages-20140402.xz:<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
>> /var/log/messages-20140506.xz:<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
>> /var/log/messages-20140629.xz:<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
>> cer@Telcontar:~>

> So you have reproduced this, reformatted with mkfs, restored from
> backups and continued to reproduce the problem? And still only on this
> particular partition?

Right. Exactly that.

Only that I can not reproduce the issue at will, but about once a month,
randomly.

AFAIK, xfsdump can not carry over a filesystem corruption, right?



**** LONG DESCRIPTION and LOGS start here ********


The first time was on 2014-03-15 03:35:17, instantly after thawing:


<0.7> 2014-03-15 03:35:14 Telcontar kernel - - - [37682.109726] PM: Basic memory bitmaps freed
<3.6> 2014-03-15 03:35:14 Telcontar systemd 1 - -  Time has been changed
<3.4> 2014-03-15 03:35:14 Telcontar rtkit-daemon 4169 - -  The canary thread is apparently starving. Taking action.
<3.6> 2014-03-15 03:35:14 Telcontar rtkit-daemon 4169 - -  Demoting known real-time threads.
<3.5> 2014-03-15 03:35:14 Telcontar rtkit-daemon 4169 - -  Successfully demoted thread 4175 of process 4168 (/usr/bin/pulseaudio).
<3.5> 2014-03-15 03:35:14 Telcontar rtkit-daemon 4169 - -  Successfully demoted thread 4174 of process 4168 (/usr/bin/pulseaudio).
<3.5> 2014-03-15 03:35:14 Telcontar rtkit-daemon 4169 - -  Successfully demoted thread 4168 of process 4168 (/usr/bin/pulseaudio).
<3.5> 2014-03-15 03:35:14 Telcontar rtkit-daemon 4169 - -  Demoted 3 threads.
<3.6> 2014-03-15 03:35:16 Telcontar acpid - - -  1 client rule loaded
<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111787] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_allo
<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111787] 
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111792] CPU: 1 PID: 5245 Comm: thunderbird-bin Tainted: P           O 3.11.10-7-desktop #1
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111793] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111795]  0000000000000002 ffffffff8159ff82 000000000027610d ffffffffa0c53996
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111799]  ffff8802303533c0 ffff8802344e4300 ffff8802263a1f20 0000000000000002
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111801]  0000000000000000 ffff8801a08bfa8c 0000000000000000 0027611300000001
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111804] Call Trace:
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111815]  [<ffffffff81004a18>] dump_trace+0x88/0x310
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111818]  [<ffffffff81004d70>] show_stack_log_lvl+0xd0/0x1d0
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111821]  [<ffffffff810061ac>] show_stack+0x1c/0x50
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111825]  [<ffffffff8159ff82>] dump_stack+0x50/0x89
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111861]  [<ffffffffa0c53996>] xfs_free_ag_extent+0x226/0x860 [xfs]
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111905]  [<ffffffffa0c54fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111948]  [<ffffffffa0c6739e>] xfs_bmap_finish+0x11e/0x170 [xfs]
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111999]  [<ffffffffa0c864c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112073]  [<ffffffffa0c4935b>] xfs_setattr_size+0x41b/0x4a0 [xfs]
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112107]  [<ffffffffa0c4940e>] xfs_vn_setattr+0x2e/0x40 [xfs]
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112130]  [<ffffffff811a060c>] notify_change+0x1dc/0x360
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112135]  [<ffffffff811845ee>] do_truncate+0x5e/0x90
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112139]  [<ffffffff81193c53>] do_last+0x253/0xec0
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112142]  [<ffffffff81194976>] path_openat+0xb6/0x670
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112145]  [<ffffffff81195cb5>] do_filp_open+0x35/0x80
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112147]  [<ffffffff81185599>] do_sys_open+0x129/0x210
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112151]  [<ffffffff815adbed>] system_call_fastpath+0x1a/0x1f
<0.4> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112157]  [<00007f6ec359078d>] 0x7f6ec359078c
<0.5> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.112976] XFS (sdd5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_b
<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.163643] XFS (sdd5): Corruption of in-memory data detected.  Shutting down filesystem
<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.163648] XFS (sdd5): Please umount the filesystem and rectify the problem(s)
<0.4> 2014-03-15 03:35:18 Telcontar kernel - - - [37686.496013] XFS (sdd5): xfs_log_force: error 5 returned.
<3.5> 2014-03-15 03:35:18 Telcontar dbus 1005 - -  [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
<5.4> 2014-03-15 03:35:18 Telcontar pm-utils - - -  Thawing (95)...
<1.5> 2014-03-15 03:35:22 Telcontar network 11556 - -  redirecting to "systemctl  restart network.service"




I managed to halt somehow, and booted. The log says that the partition 
passes automatic boot tests (excerpted):


<0.5> 2014-03-15 03:49:42 Telcontar kernel - - - [   19.173599] XFS (sdd5): Mounting Filesystem
<0.5> 2014-03-15 03:49:42 Telcontar kernel - - - [   19.377918] XFS (sdd5): Starting recovery (logdev: internal)
<0.5> 2014-03-15 03:49:42 Telcontar kernel - - - [   19.747914] XFS (sdd5): Ending recovery (logdev: internal)


But soon after, it oopses:


<3.6> 2014-03-15 03:53:01 Telcontar systemd 4987 - -  Starting Default.
<3.6> 2014-03-15 03:53:01 Telcontar systemd 4987 - -  Reached target Default.
<3.6> 2014-03-15 03:53:01 Telcontar systemd 4987 - -  Startup finished in 57ms.
<3.6> 2014-03-15 03:53:01 Telcontar systemd 1 - -  Started User Manager for 9.
<0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857523] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 350 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_all
<0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857523] 
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857530] CPU: 3 PID: 57 Comm: kworker/3:1 Tainted: P           O 3.11.10-7-desktop #1
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857532] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857570] Workqueue: xfsalloc xfs_bmapi_allocate_worker [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857572]  0000000000000000 ffffffff8159ff82 ffff880192c89080 ffffffffa0c50ee9
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857576]  0000003d30691240 00000000a0c55781 ffff880234917d58 ffff880192c89080
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857579]  000000000000003d 000000000000003d 0000000000000002 0000000000022dab
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857583] Call Trace:
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857583] Call Trace:
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857596]  [<ffffffff81004a18>] dump_trace+0x88/0x310
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857600]  [<ffffffff81004d70>] show_stack_log_lvl+0xd0/0x1d0
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857604]  [<ffffffff810061ac>] show_stack+0x1c/0x50
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857609]  [<ffffffff8159ff82>] dump_stack+0x50/0x89
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857630]  [<ffffffffa0c50ee9>] xfs_alloc_fixup_trees+0x1f9/0x340 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857689]  [<ffffffffa0c5344e>] xfs_alloc_ag_vextent_near+0x9ee/0xcd0 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857751]  [<ffffffffa0c5408d>] xfs_alloc_ag_vextent+0xbd/0x100 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857810]  [<ffffffffa0c54cd6>] xfs_alloc_vextent+0x4e6/0x740 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857870]  [<ffffffffa0c60447>] xfs_bmap_btalloc+0x2a7/0x7a0 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857937]  [<ffffffffa0c63ecd>] __xfs_bmapi_allocate+0xbd/0x2d0 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.858002]  [<ffffffffa0c64107>] xfs_bmapi_allocate_worker+0x27/0x50 [xfs]
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.858069]  [<ffffffff8106ac68>] process_one_work+0x168/0x490
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.858074]  [<ffffffff8106b904>] worker_thread+0x114/0x3a0
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.858079]  [<ffffffff81071c2f>] kthread+0xaf/0xc0
<0.4> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.858084]  [<ffffffff815adb3c>] ret_from_fork+0x7c/0xb0
<0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.858095] XFS (sdd5): page discard on page ffffea0005357d98, inode 0x602084fd, offset 339968.
<0.1> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896051] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 350 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_all
<0.1> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896051] 
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896056] CPU: 2 PID: 56 Comm: kworker/2:1 Tainted: P           O 3.11.10-7-desktop #1
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896057] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896091] Workqueue: xfsalloc xfs_bmapi_allocate_worker [xfs]
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896093]  0000000000000000 ffffffff8159ff82 ffff880192c89150 ffffffffa0c50ee9
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896096]  0000003c30691240 00000000a0c55781 ffff88023490fd58 ffff880192c89150
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896098]  000000000000003c 000000000000003c 0000000000000002 0000000000022dab
<0.4> 2014-03-15 03:54:12 Telcontar kernel - - - [  326.896100] Call Trace:


and pages and pages of log entries (which I'm unsure I saw at the time)

Aparently, I logged in text mode, without reboot, and mounted home again 
(perhaps systemd mounted it automatically, I do not remember).  It is 
possible that I did an xfs repair in the interval, it is not logged.



<0.4> 2014-03-15 04:06:09 Telcontar kernel - - - [ 1044.485279]  [<ffffffff815adb3c>] ret_from_fork+0x7c/0xb0
<0.1> 2014-03-15 04:06:09 Telcontar kernel - - - [ 1044.486104] XFS (sdd5): page discard on page ffffea00053b68e0, inode 0x602084fd, offset 749568.
<3.6> 2014-03-15 04:07:39 Telcontar systemd 1 - -  Starting Session 9 of user root.
<4.6> 2014-03-15 04:07:39 Telcontar systemd-logind 1002 - -  New session 9 of user root.
<10.5> 2014-03-15 04:07:39 Telcontar login - - -  ROOT LOGIN ON tty2
<3.6> 2014-03-15 04:08:01 Telcontar systemd 1 - -  Starting Session 10 of user news.
<0.5> 2014-03-15 04:09:55 Telcontar kernel - - - [ 1270.594691] XFS (sdd5): Mounting Filesystem
<0.6> 2014-03-15 04:09:55 Telcontar kernel - - - [ 1270.681282] XFS (sdd5): Ending clean mount
<3.6> 2014-03-15 04:10:02 Telcontar acpid - - -  1 client rule loaded
<3.6> 2014-03-15 04:11:41 Telcontar acpid - - -  1 client rule loaded
<3.6> 2014-03-15 04:11:47 Telcontar systemd 1 - -  Starting Session 11 of user cer.
<4.6> 2014-03-15 04:11:47 Telcontar systemd-logind 1002 - -  New session 11 of user cer.
<4.6> 2014-03-15 04:11:47 Telcontar systemd-logind 1002 - -  Linked /tmp/.X11-unix/X0 to /run/user/1000/X11-display.
<3.4> 2014-03-15 04:11:47 Telcontar kdm - - -  :0 '[5904]: Cannot update authorization file in home dir /home/cer
<3.3> 2014-03-15 04:11:47 Telcontar kdm - - -  :0 '[5904]: Cannot chdir to cer's home /home/cer: No such file or directory


But as you can see, despite it saying that it was a "clean mount", my 
"/home/cer/", ie, my HOME, is not visible.


<0.5> 2014-03-15 04:12:03 Telcontar kernel - - - [ 1397.853848] XFS (sdd5): Mounting Filesystem
<0.6> 2014-03-15 04:12:03 Telcontar kernel - - - [ 1397.932327] XFS (sdd5): Ending clean mount
<3.6> 2014-03-15 04:12:25 Telcontar systemd 1 - -  Starting Getty on tty3...
<3.6> 2014-03-15 04:12:25 Telcontar systemd 1 - -  Started Getty on tty3.
<3.6> 2014-03-15 04:12:29 Telcontar systemd 1 - -  Starting Session 12 of user cer.
<4.6> 2014-03-15 04:12:29 Telcontar systemd-logind 1002 - -  New session 12 of user cer.
<10.6> 2014-03-15 04:12:29 Telcontar login - - -  LOGIN ON tty3 BY cer


and this time I apparently managed to log in graphical mode:


<3.6> 2014-03-15 04:13:24 Telcontar systemd 1 - -  Starting Session 14 of user cer.
<4.6> 2014-03-15 04:13:24 Telcontar systemd-logind 1002 - -  New session 14 of user cer.
<4.6> 2014-03-15 04:13:24 Telcontar systemd-logind 1002 - -  Linked /tmp/.X11-unix/X0 to /run/user/1000/X11-display.
<23.4> 2014-03-15 04:13:24 Telcontar checkproc - - -  checkproc: can not get session id for process 4131!
<4.5> 2014-03-15 04:13:25 Telcontar gnome-keyring-daemon 6210 - -  Gkm: using old keyring directory: /home/cer/.gnome2/keyrings
<4.5> 2014-03-15 04:13:25 Telcontar gnome-keyring-daemon 6210 - -  Gkm: using old keyring directory: /home/cer/.gnome2/keyrings


Being late, and confident that the issue was solved (which was wrong, I 
maybe did not see those XFS_WANT_CORRUPTED_RETURN above), I hibernated:


<5.4> 2014-03-15 04:23:41 Telcontar pm-utils - - -  Hibernating (1)...
<1.5> 2014-03-15 04:23:41 Telcontar network 7779 - -  redirecting to "systemctl --signal=9 kill network.service"

... next morning:

<5.4> 2014-03-15 13:23:41 Telcontar pm-utils - - -  Thawing (95)...

... afternoon:

<5.4> 2014-03-15 17:50:45 Telcontar pm-utils - - -  Hibernating (1)...
...
<5.4> 2014-03-15 19:47:58 Telcontar pm-utils - - -  Thawing (95)...


... again once more, and crash!


<5.4> 2014-03-15 20:20:56 Telcontar pm-utils - - -  Hibernating (1)...
...
<5.4> 2014-03-15 22:20:21 Telcontar pm-utils - - -  Thawing (95)...
<5.4> 2014-03-15 22:20:32 Telcontar pm-utils - - -  Thawing (1)...
<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_allo
<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] 
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298351] CPU: 0 PID: 28877 Comm: kworker/0:7 Tainted: P           O 3.11.10-7-desktop #1
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298353] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298388] Workqueue: xfs-eofblocks/sdd5 xfs_eofblocks_worker [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298391]  0000000000000000 ffffffff8159ff82 0000000000007121 ffffffffa0c53996
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298395]  ffff880151e21cc0 ffff880234093600 ffff88023016bbe0 0000000000000000
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298398]  0000000000000000 0000000100000000 0000000000000000 0000000000000001
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298402] Call Trace:
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298415]  [<ffffffff81004a18>] dump_trace+0x88/0x310
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298419]  [<ffffffff81004d70>] show_stack_log_lvl+0xd0/0x1d0
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298423]  [<ffffffff810061ac>] show_stack+0x1c/0x50
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298428]  [<ffffffff8159ff82>] dump_stack+0x50/0x89
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298449]  [<ffffffffa0c53996>] xfs_free_ag_extent+0x226/0x860 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298511]  [<ffffffffa0c54fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298571]  [<ffffffffa0c6739e>] xfs_bmap_finish+0x11e/0x170 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298643]  [<ffffffffa0c864c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298734]  [<ffffffffa0c4e633>] xfs_free_eofblocks+0x1e3/0x260 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298786]  [<ffffffffa0c441ef>] xfs_inode_free_eofblocks+0x6f/0x150 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298828]  [<ffffffffa0c42f82>] xfs_inode_ag_walk.isra.10+0x1c2/0x310 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298868]  [<ffffffffa0c43a8e>] xfs_inode_ag_iterator_tag+0x6e/0xb0 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298909]  [<ffffffffa0c43d82>] xfs_eofblocks_worker+0x12/0x20 [xfs]
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298937]  [<ffffffff8106ac68>] process_one_work+0x168/0x490
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298942]  [<ffffffff8106b904>] worker_thread+0x114/0x3a0
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298946]  [<ffffffff81071c2f>] kthread+0xaf/0xc0
<0.4> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298952]  [<ffffffff815adb3c>] ret_from_fork+0x7c/0xb0
<0.5> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298959] XFS (sdd5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_b
<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.331745] XFS (sdd5): Corruption of in-memory data detected.  Shutting down filesystem
<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.331748] XFS (sdd5): Please umount the filesystem and rectify the problem(s)
<4.5> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  Gkm: couldn't stat directory: /home/cer/.gnome2/keyrings: Input/output error
<4.4> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  GLib-GObject: invalid unclassed pointer in cast to 'GkmObject'
<4.3> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  Gkm: gkm_object_expose_full: assertion 'GKM_IS_OBJECT (self)' failed
<4.5> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  Gkm: couldn't stat directory: /home/cer/.gnome2/keyrings: Input/output error
<4.5> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  Gkm: couldn't stat directory: /home/cer/.gnome2/keyrings: Input/output error
<4.4> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  Gkm: couldn't create temporary file for: /home/cer/.gnome2/keyrings/login_1.keyring: Input/output error
<4.4> 2014-03-15 22:20:40 Telcontar gnome-keyring-daemon 6210 - -  couldn't create login keyring: An error occurred on the device
<10.3> 2014-03-15 22:20:40 Telcontar unix2_chkpwd - - -  gkr-pam: the password for the login keyring was invalid.
<0.4> 2014-03-15 22:20:50 Telcontar kernel - - - [20168.032019] XFS (sdd5): xfs_log_force: error 5 returned.
<5.4> 2014-03-15 22:20:57 Telcontar router - - -  (Thawing 1) Logging the current IP= 83.41.119.142
<0.4> 2014-03-15 22:21:20 Telcontar kernel - - - [20198.112018] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:21:50 Telcontar kernel - - - [20228.192016] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:22:21 Telcontar kernel - - - [20258.272013] XFS (sdd5): xfs_log_force: error 5 returned.
<10.5> 2014-03-15 22:22:31 Telcontar polkitd 4115 - -  Unregistered Authentication Agent for unix-session:14 (system bus name :1.93, object path /org/gnome/PolicyKit1/AuthenticationAgent, locale en_US.UTF-8
<3.3> 2014-03-15 22:22:37 Telcontar kdm 3931 - -  X server for display :0 terminated unexpectedly
<3.4> 2014-03-15 22:22:37 Telcontar kdm - - -  :0[31291]: Cannot update authorization file in home dir /home/cer
<0.7> 2014-03-15 22:22:37 Telcontar kernel - - - [20275.208508] nvidia 0000:01:00.0: irq 48 for MSI/MSI-X
<3.6> 2014-03-15 22:22:38 Telcontar acpid - - -  1 client rule loaded
<0.4> 2014-03-15 22:22:51 Telcontar kernel - - - [20288.352018] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-03-15 22:23:01 Telcontar systemd 1 - -  Starting Session 126 of user news.
<0.4> 2014-03-15 22:23:21 Telcontar kernel - - - [20318.432014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:23:51 Telcontar kernel - - - [20348.512013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:24:21 Telcontar kernel - - - [20378.592014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:24:51 Telcontar kernel - - - [20408.672014] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-03-15 22:25:19 Telcontar systemd 1 - -  Stopping User Manager for 9...
<3.6> 2014-03-15 22:25:19 Telcontar systemd 1 - -  Stopping Disk Manager...
<3.6> 2014-03-15 22:25:19 Telcontar systemd 1 - -  Stopping Daemon for power management...
<3.6> 2014-03-15 22:25:19 Telcontar systemd 1 - -  Stopping Bluetooth service...


I was attemtping to go to reboot, I think.


<3.6> 2014-03-15 22:25:20 Telcontar systemd 1 - -  Starting Rescue Shell...
<3.6> 2014-03-15 22:25:20 Telcontar systemd 1 - -  Started Rescue Shell.
<3.6> 2014-03-15 22:20:19 Telcontar systemd 3976 - -  message repeated 3 times: [ Time has been changed]
<3.6> 2014-03-15 22:25:20 Telcontar systemd 3976 - -  Stopping Default.
<3.6> 2014-03-15 22:20:19 Telcontar systemd 4987 - -  message repeated 3 times: [ Time has been changed]
<3.6> 2014-03-15 22:25:20 Telcontar systemd 4987 - -  Stopping Default.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 3976 - -  Stopped target Default.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 4987 - -  Stopped target Default.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 3976 - -  Starting Shutdown.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 4987 - -  Starting Shutdown.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 3976 - -  Reached target Shutdown.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 4987 - -  Reached target Shutdown.
<3.6> 2014-03-15 22:25:20 Telcontar systemd 3976 - -  Starting Exit the Session...
<3.6> 2014-03-15 22:25:20 Telcontar systemd 4987 - -  Starting Exit the Session...
<0.5> 2014-03-15 22:25:20 Telcontar kernel - - - [20437.920075] type=1131 audit(1394918720.685:1133): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:20 Telcontar kernel - - - [20437.920075]  msg=' comm="auditd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:20 Telcontar kernel - - - [20437.920273] type=1131 audit(1394918720.685:1134): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:20 Telcontar kernel - - - [20437.920273]  msg=' comm="systemd-logind" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:20 Telcontar kernel - - - [20437.920490] type=1131 audit(1394918720.685:1135): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:20 Telcontar kernel - - - [20437.920490]  msg=' comm="smb" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.525253] type=1131 audit(1394918721.290:1136): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.525253]  msg=' comm="cron" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.525643] type=1131 audit(1394918721.290:1137): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.525643]  msg=' comm="avahi-daemon" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.525937] type=1131 audit(1394918721.290:1138): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.525937]  msg=' comm="console-kit-daemon" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.526359] type=1131 audit(1394918721.291:1139): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.526359]  msg=' comm="polkit" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.526577] type=1131 audit(1394918721.291:1140): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.526577]  msg=' comm="rtkit-daemon" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.527021] type=1131 audit(1394918721.292:1141): pid=1 uid=0 auid=4294967295 ses=4294967295
<0.5> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.527021]  msg=' comm="bluetooth" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
<0.4> 2014-03-15 22:25:21 Telcontar kernel - - - [20438.752008] XFS (sdd5): xfs_log_force: error 5 returned.
<5.6> 2014-03-15 22:25:22 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="1067" x-info="http://www.rsyslog.com"] exiting on signal 15.
2014-03-15 22:25:23+01:00 - Halting the system now  =========================================== uptime:  22:25pm  up  18:36,  2 users,  load average: 2.08, 1.04, 0.78
2014-03-15 22:25:31+01:00 - Booting the system now  ================================================================================  Linux Telcontar 3.11.10-7-desktop #1 SMP PREEMPT Mon Feb 3 09:41:24 UTC 
<5.6> 2014-03-15 22:25:39 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="32300" x-info="http://www.rsyslog.com"] start
<3.6> 2014-03-15 22:25:39 Telcontar systemd 1 - -  Stopping Rescue Shell...


This time, the system detects problems:


<0.4> 2014-03-15 22:25:51 Telcontar kernel - - - [20468.832024] XFS (sdd5): xfs_log_force: error 5 returned.
...
<3.6> 2014-03-15 22:26:16 Telcontar systemd 1 - -  Started Console Manager.
<10.5> 2014-03-15 22:26:16 Telcontar login - - -  ROOT LOGIN ON tty1
<3.6> 2014-03-15 22:26:16 Telcontar systemd 878 - -  Mounted /sys/fs/fuse/connections.
<3.6> 2014-03-15 22:26:16 Telcontar systemd 878 - -  Stopped target Sound Card.
<3.6> 2014-03-15 22:26:16 Telcontar systemd 878 - -  Starting Default.
<3.6> 2014-03-15 22:26:16 Telcontar systemd 878 - -  Reached target Default.
<3.6> 2014-03-15 22:26:16 Telcontar systemd 878 - -  Startup finished in 316ms.
<3.6> 2014-03-15 22:26:16 Telcontar systemd 1 - -  Started User Manager for 0.
<0.4> 2014-03-15 22:26:21 Telcontar kernel - - - [20498.912018] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:26:51 Telcontar kernel - - - [20528.992014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:27:21 Telcontar kernel - - - [20559.072014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-03-15 22:27:51 Telcontar kernel - - - [20589.152013] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-03-15 22:28:01 Telcontar systemd 1 - -  Starting user-9.slice.


But aparently I decided to abort:


2014-03-15 22:28:03+01:00 - Halting the system now  =========================================== uptime:  22:28pm  up  18:39,  0 users,  load average: 0.70, 1.40, 1.01
2014-03-16 14:07:21+01:00 - Booting the system now  ================================================================================  Linux Telcontar 3.11.10-7-desktop #1 SMP PREEMPT Mon Feb 3 09:41:24 UTC


Judging from the time of the next boot, I guess that it was here that I 
decided to use the live system and reformat.

    The cloned image I have of the filesystem is dated Mar 16 05:42, so it
    was made somewhere here - at late hours, you see, if I started to
    attempt recovery at 22:30 (I used dd, rsync, and xfsdump, so that took
    time).

    Unfortunately, I do not remember where I placed my notes on the repair
    procedure, so I do not know for certain at which point in my attempts
    to repair I took the photo.  Seeing that I probably started around
    midnight, and the file is dated 05:42, I guess I did it too late.  But
    that surprises me, as I'm absolutely sure I took the photo to be able
    to provide it for investigation.

As it was evident by now that xfsrepair failed to repair the partition, 
which crashed soon after "repair", and as it was mountable, I decided to 
do an both an rsync copy and an xfsdump copy.  I then reformatted the 
affected partition, but I don't remember if I used gparted (probably) or 
mkfs.xfs, and when done, I copied back the data from the backup made just 
an hour before, with xfsrestore.  I remember I also used rsync to verify 
the copy, and it was correct.



And the procedure succeeded:

<0.5> 2014-03-16 14:07:23 Telcontar kernel - - - [   20.239542] XFS (sdd5): Mounting Filesystem
<0.5> 2014-03-16 14:07:23 Telcontar kernel - - - [   20.280604] XFS (sdd8): Mounting Filesystem
<0.6> 2014-03-16 14:07:23 Telcontar kernel - - - [   20.450123] XFS (sdd8): Ending clean mount
<0.6> 2014-03-16 14:07:23 Telcontar kernel - - - [   20.459463] XFS (sdd5): Ending clean mount


Next log entry related to "sdd5" was days later, all normal:

<3.6> 2014-03-19 00:18:12 Telcontar dbus-daemon 1004 - -  **** ADDING /sys/devices/pci0000:00/0000:00:1f.2/ata10/host9/target9:0:0/9:0:0:0/block/sdd/sdd5







Next crash event happened on 2014-04-17 22:47:08, after 15 sucesful 
hibernation cycles:


<5.4> 2014-04-17 20:15:56 Telcontar pm-utils - - -  Hibernating (1)...
<1.5> 2014-04-17 20:15:56 Telcontar network 314 - -  redirecting to "systemctl --signal=9 kill network.service"
<3.5> 2014-04-17 20:15:56 Telcontar systemd 1 - -  network@eth0.service: main process exited, code=killed, status=9/KILL
<5.4> 2014-04-17 20:15:56 Telcontar pm-utils - - -  Hibernating (95)...
<0.7> 2014-04-17 20:15:59 Telcontar kernel - - - [280263.870791] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
<0.7> 2014-04-17 20:15:59 Telcontar kernel - - - [280263.870797] PM: Marking nosave pages: [mem 0xbff90000-0xffffffff]
<0.7> 2014-04-17 20:15:59 Telcontar kernel - - - [280263.871414] PM: Basic memory bitmaps created
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280264.493703] Syncing filesystems ... done.
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280265.043237] Freezing user space processes ... (elapsed 0.002 seconds) done.
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280265.046032] PM: Preallocating image memory... done (allocated 1140779 pages)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.609430] PM: Allocated 4563116 kbytes in 1.56 seconds (2925.07 MB/s)
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.609554] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.611525] Suspending console(s) (use no_console_suspend to debug)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.612352] serial 00:05: disabled
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.812165] PM: freeze of devices complete after 200.520 msecs
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.812452] PM: late freeze of devices complete after 0.285 msecs
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.812999] PM: noirq freeze of devices complete after 0.544 msecs
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.812999] Disabling non-boot CPUs ...
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.814329] smpboot: CPU 1 is now offline
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.816455] smpboot: CPU 2 is now offline
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.818199] smpboot: CPU 3 is now offline
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.818656] PM: Creating hibernation image:
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.819191] PM: Need to copy 923283 pages
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.819191] PM: Normal pages needed: 923283 + 1024, available pages: 1173501
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.819191] Enabling non-boot CPUs ...
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.819191] smpboot: Booting Node 0 Processor 1 APIC 0x1
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.832336] CPU1 is up
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.832467] smpboot: Booting Node 0 Processor 2 APIC 0x2
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.845865] CPU2 is up
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.846034] smpboot: Booting Node 0 Processor 3 APIC 0x3
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.859609] CPU3 is up
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.887223] PM: noirq restore of devices complete after 22.590 msecs
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.887356] PM: early restore of devices complete after 0.107 msecs
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059840] uhci_hcd 0000:00:1a.0: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059859] usb usb3: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059869] uhci_hcd 0000:00:1a.1: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059885] usb usb4: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059893] uhci_hcd 0000:00:1a.2: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059910] usb usb5: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059919] ehci-pci 0000:00:1a.7: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.059937] usb usb1: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061145] uhci_hcd 0000:00:1d.0: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061167] usb usb6: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061177] uhci_hcd 0000:00:1d.1: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061196] usb usb7: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061205] uhci_hcd 0000:00:1d.2: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061225] usb usb8: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061236] ehci-pci 0000:00:1d.7: setting latency timer to 64
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.061254] usb usb2: root hub lost power or was reset
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.062031] pci 0000:00:1e.0: setting latency timer to 64
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.062123] ata_piix 0000:00:1f.2: setting latency timer to 64
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.062182] ata_piix 0000:00:1f.5: setting latency timer to 64
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.063832] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.065134] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162023] pciehp 0000:00:1c.4:pcie04: Device 0000:06:00.0 already exists at 0000:06:00, cannot hot-add
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162025] pciehp 0000:00:1c.4:pcie04: Cannot add device at 0000:06:00
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162047] pciehp 0000:00:1c.2:pcie04: Device 0000:04:00.0 already exists at 0000:04:00, cannot hot-add
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162049] pciehp 0000:00:1c.2:pcie04: Cannot add device at 0000:04:00
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162051] pciehp 0000:00:1c.5:pcie04: Device 0000:07:00.0 already exists at 0000:07:00, cannot hot-add
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162053] pciehp 0000:00:1c.5:pcie04: Cannot add device at 0000:07:00
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162098] pciehp 0000:00:1c.0:pcie04: Device 0000:02:00.0 already exists at 0000:02:00, cannot hot-add
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162100] pciehp 0000:00:1c.0:pcie04: Cannot add device at 0000:02:00
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162123] pciehp 0000:00:1c.3:pcie04: Device 0000:05:00.0 already exists at 0000:05:00, cannot hot-add
<0.3> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162125] pciehp 0000:00:1c.3:pcie04: Cannot add device at 0000:05:00
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.162308] pata_jmicron 0000:05:00.1: setting latency timer to 64
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.163546] serial 00:05: activated
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.164041] pata_jmicron 0000:04:00.1: setting latency timer to 64
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.173271] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.386975] ata11: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.467054] ata2: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.468030] ata1: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.481019] usb 1-2: reset high-speed USB device number 3 using ehci-pci
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.485262] r8169 0000:07:00.0 eth1: link down
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.538037] ata12: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.541148] ata12.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.541149] ata12.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.541151] ata12.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.563113] ata12.00: configured for UDMA/100
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.621020] firewire_core 0000:08:02.0: rediscovered device fw0
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.622018] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.624027] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.624176] ata3.00: configured for UDMA/133
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.624207] sd 2:0:0:0: [sda] Starting disk
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.625665] ata4.00: configured for UDMA/133
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.626090] sd 3:0:0:0: [sdb] Starting disk
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.656005] /dev/vmmon[0]: HostIFReadUptimeWork: detected settimeofday: fixed uptimeBase old 18445346595345864640 new 18445346586286024561 attempts 1
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.833055] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.833064] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.836117] ata9.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.836119] ata9.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.836296] ata9.01: ACPI cmd c6/00:10:00:00:00:b0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.836298] ata9.01: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.842067] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.842082] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.842175] ata9.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.842176] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.842344] ata9.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.842345] ata9.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.845187] ata10.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.845189] ata10.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.845378] ata10.01: ACPI cmd c6/00:10:00:00:00:b0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.845380] ata10.01: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.847015] usb 3-1: reset low-speed USB device number 2 using uhci_hcd
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.851234] ata10.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.851235] ata10.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.851359] ata9.00: configured for UDMA/133
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.851456] ata10.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.851458] ata10.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.857339] ata9.01: configured for UDMA/133
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.857369] sd 8:0:0:0: [sdc] Starting disk
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.857371] sd 8:0:1:0: [sdd] Starting disk
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.879326] ata10.00: configured for UDMA/133
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.885331] ata10.01: configured for UDMA/133
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.885365] sd 9:0:0:0: [sde] Starting disk
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280267.885369] sd 9:0:1:0: [sdf] Starting disk
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280268.242014] usb 2-5: reset high-speed USB device number 2 using ehci-pci
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280268.608013] usb 8-2: reset low-speed USB device number 2 using uhci_hcd
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280268.959113] usb 2-5.4: reset high-speed USB device number 4 using ehci-pci
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280269.287977] r8169 0000:06:00.0 eth0: link up
<0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280269.796130] PM: restore of devices complete after 2736.343 msecs
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.081655] Restarting kernel threads ... done.
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.086714] Restarting tasks ... done.
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.115233] PM: Basic memory bitmaps freed
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.191345] bridge-eth0: disabling the bridge
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.196021] bridge-eth0: down
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.196026] bridge-eth0: detached
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.762859] /dev/vmnet: open called by PID 3122 (vmnet-bridge)
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.762873] /dev/vmnet: hub 0 does not exist, allocating memory.
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.762888] /dev/vmnet: port on hub 0 successfully opened
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.762899] bridge-eth0: up
<0.7> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.762904] bridge-eth0: attached
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.396460] userif-2: sent link down event.
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.396463] userif-2: sent link up event.
<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] 
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851709] CPU: 0 PID: 27785 Comm: kworker/0:4 Tainted: P           O 3.11.10-7-desktop #1
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851864] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852074] Workqueue: xfs-eofblocks/sde5 xfs_eofblocks_worker [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852211]  0000000000000000 ffffffff8159ff82 0000000000216bae ffffffffa0c53996
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852486]  ffff88019907e0c0 ffff880234160740 ffff88012e9e5cb0 0000000000000000
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852638]  0000000000000000 0000000100000000 0000000000000000 0000000000000001
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852790] Call Trace:
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852847]  [<ffffffff81004a18>] dump_trace+0x88/0x310
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.852947]  [<ffffffff81004d70>] show_stack_log_lvl+0xd0/0x1d0
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853063]  [<ffffffff810061ac>] show_stack+0x1c/0x50
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853164]  [<ffffffff8159ff82>] dump_stack+0x50/0x89
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853275]  [<ffffffffa0c53996>] xfs_free_ag_extent+0x226/0x860 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853439]  [<ffffffffa0c54fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853594]  [<ffffffffa0c6739e>] xfs_bmap_finish+0x11e/0x170 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853761]  [<ffffffffa0c864c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.853950]  [<ffffffffa0c4e633>] xfs_free_eofblocks+0x1e3/0x260 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854110]  [<ffffffffa0c441ef>] xfs_inode_free_eofblocks+0x6f/0x150 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854268]  [<ffffffffa0c42f82>] xfs_inode_ag_walk.isra.10+0x1c2/0x310 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854428]  [<ffffffffa0c43a8e>] xfs_inode_ag_iterator_tag+0x6e/0xb0 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854585]  [<ffffffffa0c43d82>] xfs_eofblocks_worker+0x12/0x20 [xfs]
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854725]  [<ffffffff8106ac68>] process_one_work+0x168/0x490
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854835]  [<ffffffff8106b904>] worker_thread+0x114/0x3a0
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.854941]  [<ffffffff81071c2f>] kthread+0xaf/0xc0
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.855037]  [<ffffffff815adb3c>] ret_from_fork+0x7c/0xb0
<0.5> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.855142] XFS (sde5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa0c673d8
<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.901296] XFS (sde5): Corruption of in-memory data detected.  Shutting down filesystem
<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.901447] XFS (sde5): Please umount the filesystem and rectify the problem(s)
<0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280272.480011] XFS (sde5): xfs_log_force: error 5 returned.
<3.4> 2014-04-17 22:47:06 Telcontar rtkit-daemon 4749 - -  The canary thread is apparently starving. Taking action.
<3.6> 2014-04-17 22:47:06 Telcontar rtkit-daemon 4749 - -  Demoting known real-time threads.
<3.5> 2014-04-17 22:47:06 Telcontar rtkit-daemon 4749 - -  Successfully demoted thread 31337 of process 31334 (/usr/bin/pulseaudio).
<3.5> 2014-04-17 22:47:06 Telcontar rtkit-daemon 4749 - -  Successfully demoted thread 31336 of process 31334 (/usr/bin/pulseaudio).
<3.5> 2014-04-17 22:47:06 Telcontar rtkit-daemon 4749 - -  Successfully demoted thread 31334 of process 31334 (/usr/bin/pulseaudio).
<3.5> 2014-04-17 22:47:06 Telcontar rtkit-daemon 4749 - -  Demoted 3 threads.
<3.6> 2014-04-17 22:47:06 Telcontar vmnetBridge - - -  RTM_NEWLINK: name:eth0 index:2 flags:0x00001003
<3.6> 2014-04-17 22:47:06 Telcontar vmnetBridge - - -  Removing interface eth0 index:2
<3.6> 2014-04-17 22:47:06 Telcontar vmnetBridge - - -  Stopped bridge eth0 to virtual network 0.
<3.6> 2014-04-17 22:47:06 Telcontar vmnetBridge - - -  RTM_NEWLINK: name:eth0 index:2 flags:0x00011043
<3.6> 2014-04-17 22:47:07 Telcontar vmnet-natd - - -  RTM_NEWLINK: name:eth0 index:2 flags:0x00001003
<3.6> 2014-04-17 22:47:08 Telcontar systemd 1 - -  Time has been changed
<3.6> 2014-04-17 22:47:11 Telcontar acpid - - -  1 client rule loaded
<3.5> 2014-04-17 22:47:12 Telcontar dbus 1013 - -  [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
<5.4> 2014-04-17 22:47:12 Telcontar pm-utils - - -  Thawing (95)...
<3.5> 2014-04-17 22:47:14 Telcontar dbus 1013 - -  [system] Activated service 'org.freedesktop.PackageKit' failed: Cannot launch daemon, file not found or permissions invalid
<1.5> 2014-04-17 22:47:16 Telcontar network 788 - -  redirecting to "systemctl  restart network.service"
<3.6> 2014-04-17 22:47:16 Telcontar systemd 1 - -  Stopping ifup managed network interface eth1...
<3.6> 2014-04-17 22:47:16 Telcontar systemd 1 - -  Stopping ifup managed network interface eth0...
<3.6> 2014-04-17 22:47:16 Telcontar systemd 1 - -  Stopping LSB: Configure network interfaces and set up routing...


Apparently, I rebooted:


2014-04-17 23:27:32+02:00 - Halting the system now  =========================================== uptime:  23:27pm  up 6 days 19:54,  1 user,  load average: 12.51, 3.63, 1.38
2014-04-17 23:32:17+02:00 - Booting the system now  ================================================================================  Linux Telcontar 3.11.10-7-desktop #1 SMP PREEMPT Mon Feb 3 09:41:24 UTC

<10.5> 2014-04-17 23:33:13 Telcontar login - - -  ROOT LOGIN ON tty1
<10.5> 2014-04-17 23:39:17 Telcontar login - - -  ROOT LOGIN ON tty2
<10.5> 2014-04-17 23:43:14 Telcontar login - - -  ROOT LOGIN ON tty3
<10.5> 2014-04-17 23:43:21 Telcontar login - - -  ROOT LOGIN ON tty4



I have reason to believe, looking at my logs, that I restored my home 
here, using the same procedure, but using this work system, instead of the 
rescue live stick (oS 13.1 XFCE), using text mode tools.  Thus I guess 
this time I used plain mkfs.xfs.  Later I see dozens of hibernate cycles, 
till I halt normally about two weeks later, on 2014-05-02, so the 
procedure succeded.






Next crash event was this Sunday:


Hibernating and thawing sequence, complete:


<3.4> 2014-06-29 04:51:49 Telcontar pm-utils - - -  Hibernating the system now (04)...
<3.5> 2014-06-29 04:51:49 Telcontar pm-utils - - -  There appears not be any pending nntp post to be sent. I just checked :-)
<1.5> 2014-06-29 04:51:50 Telcontar network 29169 - -  redirecting to "systemctl --signal=9 kill network.service"
<3.5> 2014-06-29 04:51:50 Telcontar systemd 1 - -  network@eth0.service: main process exited, code=killed, status=9/KILL
<3.4> 2014-06-29 04:51:50 Telcontar pm-utils - - -  Hibernating (95)...
<0.7> 2014-06-29 04:51:53 Telcontar kernel - - - [212878.926048] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
<0.7> 2014-06-29 04:51:53 Telcontar kernel - - - [212878.926052] PM: Marking nosave pages: [mem 0xbff90000-0xffffffff]
<0.7> 2014-06-29 04:51:53 Telcontar kernel - - - [212878.927502] PM: Basic memory bitmaps created
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212879.561676] Syncing filesystems ... done.
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212880.077132] Freezing user space processes ... (elapsed 0.002 seconds) done.
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212880.080024] PM: Preallocating image memory... done (allocated 1140811 pages)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.351277] PM: Allocated 4563244 kbytes in 7.27 seconds (627.68 MB/s)
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.351400] Freezing remaining freezable tasks ... (elapsed 0.080 seconds) done.
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.432284] Suspending console(s) (use no_console_suspend to debug)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.433051] serial 00:05: disabled
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.633138] PM: freeze of devices complete after 200.734 msecs
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.633370] PM: late freeze of devices complete after 0.230 msecs
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.633913] PM: noirq freeze of devices complete after 0.541 msecs
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.633913] Disabling non-boot CPUs ...
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.635222] smpboot: CPU 1 is now offline
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.637153] smpboot: CPU 2 is now offline
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.639195] smpboot: CPU 3 is now offline
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.639658] PM: Creating hibernation image:
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.640186] PM: Need to copy 923219 pages
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.640186] PM: Normal pages needed: 923219 + 1024, available pages: 1173563
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.640186] microcode: CPU0 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.640186] Enabling non-boot CPUs ...
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.640186] smpboot: Booting Node 0 Processor 1 APIC 0x1
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.653119] microcode: CPU1 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.653307] CPU1 is up
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.653440] smpboot: Booting Node 0 Processor 2 APIC 0x2
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.666704] microcode: CPU2 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.666844] CPU2 is up
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.667011] smpboot: Booting Node 0 Processor 3 APIC 0x3
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.680398] microcode: CPU3 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.680598] CPU3 is up
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.708225] PM: noirq restore of devices complete after 22.576 msecs
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.708358] PM: early restore of devices complete after 0.109 msecs
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880083] uhci_hcd 0000:00:1a.0: setting latency timer to 64
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880086] uhci_hcd 0000:00:1a.1: setting latency timer to 64
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880107] usb usb3: root hub lost power or was reset
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880110] usb usb4: root hub lost power or was reset
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880120] uhci_hcd 0000:00:1a.2: setting latency timer to 64
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880124] ehci-pci 0000:00:1a.7: setting latency timer to 64
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880139] usb usb5: root hub lost power or was reset
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880188] usb usb1: root hub lost power or was reset
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880243] uhci_hcd 0000:00:1d.0: setting latency timer to 64
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880265] usb usb6: root hub lost power or was reset
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880275] uhci_hcd 0000:00:1d.1: setting latency timer to 64
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880296] usb usb7: root hub lost power or was reset
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880306] uhci_hcd 0000:00:1d.2: setting latency timer to 64
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880326] usb usb8: root hub lost power or was reset
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880338] ehci-pci 0000:00:1d.7: setting latency timer to 64
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.880349] usb usb2: root hub lost power or was reset
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.881094] pci 0000:00:1e.0: setting latency timer to 64
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.881199] ata_piix 0000:00:1f.2: setting latency timer to 64
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.881237] ata_piix 0000:00:1f.5: setting latency timer to 64
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.884086] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.884236] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981023] pciehp 0000:00:1c.0:pcie04: Device 0000:02:00.0 already exists at 0000:02:00, cannot hot-add
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981025] pciehp 0000:00:1c.2:pcie04: Device 0000:04:00.0 already exists at 0000:04:00, cannot hot-add
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981026] pciehp 0000:00:1c.0:pcie04: Cannot add device at 0000:02:00
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981028] pciehp 0000:00:1c.2:pcie04: Cannot add device at 0000:04:00
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981032] pciehp 0000:00:1c.5:pcie04: Device 0000:07:00.0 already exists at 0000:07:00, cannot hot-add
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981034] pciehp 0000:00:1c.5:pcie04: Cannot add device at 0000:07:00
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981058] pciehp 0000:00:1c.3:pcie04: Device 0000:05:00.0 already exists at 0000:05:00, cannot hot-add
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981059] pciehp 0000:00:1c.3:pcie04: Cannot add device at 0000:05:00
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981089] pciehp 0000:00:1c.4:pcie04: Device 0000:06:00.0 already exists at 0000:06:00, cannot hot-add
<0.3> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981090] pciehp 0000:00:1c.4:pcie04: Cannot add device at 0000:06:00
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.981220] pata_jmicron 0000:04:00.1: setting latency timer to 64
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.982188] serial 00:05: activated
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.982714] pata_jmicron 0000:05:00.1: setting latency timer to 64
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.186275] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.192270] r8169 0000:07:00.0 eth1: link down
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.206012] ata11: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.286032] ata1: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.287030] ata4: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.357035] ata12: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.360116] ata12.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.360118] ata12.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.360119] ata12.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.366112] ata12.00: configured for UDMA/100
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.440022] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.440024] firewire_core 0000:08:02.0: rediscovered device fw0
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.442190] ata3.00: configured for UDMA/133
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.442223] sd 2:0:0:0: [sdb] Starting disk
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.450017] usb 8-2: reset low-speed USB device number 2 using uhci_hcd
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.659048] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.659058] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.661048] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.661058] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.662114] ata9.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.662115] ata9.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.662293] ata9.01: ACPI cmd c6/00:10:00:00:00:b0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.662295] ata9.01: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.664113] ata10.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.664114] ata10.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.664326] ata10.01: ACPI cmd c6/00:10:00:00:00:b0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.664327] ata10.01: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.668112] ata9.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.668113] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.668293] ata9.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.668294] ata9.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.670113] ata10.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.670114] ata10.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.670323] ata10.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.670324] ata10.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.677300] ata9.00: configured for UDMA/133
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.683286] ata9.01: configured for UDMA/133
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.683311] sd 8:0:0:0: [sdc] Starting disk
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.683369] sd 8:0:1:0: [sdd] Starting disk
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.698321] ata10.00: configured for UDMA/133
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.704335] ata10.01: configured for UDMA/133
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.704361] sd 9:0:0:0: [sde] Starting disk
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.704418] sd 9:0:1:0: [sdf] Starting disk
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.829028] usb 2-5: reset high-speed USB device number 2 using ehci-pci
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.901026] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.903237] ata2.00: configured for UDMA/133
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212888.903279] sd 1:0:0:0: [sda] Starting disk
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212889.045020] usb 1-2: reset high-speed USB device number 3 using ehci-pci
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212889.411014] usb 3-1: reset low-speed USB device number 2 using uhci_hcd
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212889.778047] usb 2-5.4: reset high-speed USB device number 4 using ehci-pci
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.186436] r8169 0000:06:00.0 eth0: link up
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.615073] PM: restore of devices complete after 2735.034 msecs
<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] 
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626348] CPU: 0 PID: 28875 Comm: kworker/0:2 Tainted: P           O 3.11.10-11-desktop #1
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626348] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626388] Workqueue: xfs-eofblocks/sde5 xfs_eofblocks_worker [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626390]  0000000000000002 ffffffff815a0252 00000000002a61c2 ffffffffa0c38996
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626391]  ffff8800b7025680 ffff88022eb74180 ffff880121c3fe50 0000000000000002
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626393]  0000000000000000 0000000100000000 0000000000000000 0000000000000001
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626393] Call Trace:
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626403]  [<ffffffff81004a28>] dump_trace+0x88/0x310
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626406]  [<ffffffff81004d80>] show_stack_log_lvl+0xd0/0x1d0
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626408]  [<ffffffff810061bc>] show_stack+0x1c/0x50
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626411]  [<ffffffff815a0252>] dump_stack+0x50/0x89
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626425]  [<ffffffffa0c38996>] xfs_free_ag_extent+0x226/0x860 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626468]  [<ffffffffa0c39fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626510]  [<ffffffffa0c4c39e>] xfs_bmap_finish+0x11e/0x170 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626560]  [<ffffffffa0c6b4c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626623]  [<ffffffffa0c33633>] xfs_free_eofblocks+0x1e3/0x260 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626659]  [<ffffffffa0c291ef>] xfs_inode_free_eofblocks+0x6f/0x150 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626688]  [<ffffffffa0c27f82>] xfs_inode_ag_walk.isra.10+0x1c2/0x310 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626716]  [<ffffffffa0c28a8e>] xfs_inode_ag_iterator_tag+0x6e/0xb0 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626744]  [<ffffffffa0c28d82>] xfs_eofblocks_worker+0x12/0x20 [xfs]
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626763]  [<ffffffff8106ac78>] process_one_work+0x168/0x490
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626765]  [<ffffffff8106b914>] worker_thread+0x114/0x3a0
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626768]  [<ffffffff81071c3f>] kthread+0xaf/0xc0
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626771]  [<ffffffff815addfc>] ret_from_fork+0x7c/0xb0
<0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626776] XFS (sde5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa0c4c3d8
<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Corruption of in-memory data detected.  Shutting down filesystem
<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Please umount the filesystem and rectify the problem(s)
<0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.026207] usb 1-6: USB disconnect, device number 4
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.025944] Restarting kernel threads ... done.
<0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.026371] Restarting tasks ... done.
<0.7> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.079743] PM: Basic memory bitmaps freed
<3.4> 2014-06-29 12:32:19 Telcontar rtkit-daemon 4287 - -  The canary thread is apparently starving. Taking action.
<3.6> 2014-06-29 12:32:20 Telcontar rtkit-daemon 4287 - -  Demoting known real-time threads.
<3.5> 2014-06-29 12:32:20 Telcontar rtkit-daemon 4287 - -  Successfully demoted thread 4293 of process 4286 (/usr/bin/pulseaudio).
<3.5> 2014-06-29 12:32:20 Telcontar rtkit-daemon 4287 - -  Successfully demoted thread 4292 of process 4286 (/usr/bin/pulseaudio).
<3.5> 2014-06-29 12:32:20 Telcontar rtkit-daemon 4287 - -  Successfully demoted thread 4286 of process 4286 (/usr/bin/pulseaudio).
<3.5> 2014-06-29 12:32:20 Telcontar rtkit-daemon 4287 - -  Demoted 3 threads.
<3.6> 2014-06-29 12:32:20 Telcontar systemd 1 - -  Time has been changed
<3.3> 2014-06-29 12:32:21 Telcontar systemd-udevd 29550 - -  inotify_add_watch(7, /dev/sdg, 10) failed: No such file or directory
<3.3> 2014-06-29 12:32:21 Telcontar systemd-udevd 29551 - -  inotify_add_watch(7, /dev/sdh, 10) failed: No such file or directory
<0.4> 2014-06-29 12:32:25 Telcontar kernel - - - [212898.656011] XFS (sde5): xfs_log_force: error 5 returned.
<3.5> 2014-06-29 12:32:26 Telcontar dbus 1033 - -  [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
<3.4> 2014-06-29 12:32:27 Telcontar pm-utils - - -  Thawing (95)...
<3.5> 2014-06-29 12:32:29 Telcontar dbus 1033 - -  [system] Activated service 'org.freedesktop.PackageKit' failed: Cannot launch daemon, file not found or permissions invalid
<1.5> 2014-06-29 12:32:30 Telcontar network 29606 - -  redirecting to "systemctl  restart network.service"
<3.6> 2014-06-29 12:32:30 Telcontar systemd 1 - -  Stopping ifup managed network interface eth1...
<3.6> 2014-06-29 12:32:30 Telcontar systemd 1 - -  Stopping ifup managed network interface eth0...
<3.6> 2014-06-29 12:32:30 Telcontar systemd 1 - -  Stopping LSB: Configure network interfaces and set up routing...
<3.6> 2014-06-29 12:32:31 Telcontar systemd 1 - -  Starting LSB: Configure network interfaces and set up routing...
<3.6> 2014-06-29 12:32:32 Telcontar acpid - - -  1 client rule loaded
<3.6> 2014-06-29 12:32:32 Telcontar ifdown 29624 - -  eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<3.6> 2014-06-29 12:32:32 Telcontar ifdown 29625 - -  eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-06-29 12:32:32 Telcontar ifdown 29624 - -      eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-06-29 12:32:32 Telcontar ifdown 29625 - -      eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<3.6> 2014-06-29 12:32:32 Telcontar network 29638 - -  Setting up network interfaces:
<3.6> 2014-06-29 12:32:34 Telcontar network 29638 - -  lo
<1.5> 2014-06-29 12:32:34 Telcontar ifup 30165 - -      lo
<1.5> 2014-06-29 12:32:34 Telcontar ifup 30165 - -      lo
<1.5> 2014-06-29 12:32:34 Telcontar ifup 30165 - -  IP address: 127.0.0.1/8
<3.6> 2014-06-29 12:32:34 Telcontar network 29638 - -  lo        IP address: 127.0.0.1/8
<1.5> 2014-06-29 12:32:34 Telcontar ifup 30165 - - 
<0.6> 2014-06-29 12:32:49 Telcontar kernel - - - [212922.866033] Chrome_ChildThr[14100]: segfault at 0 ip 00007fd3d820d596 sp 00007fd3cbc5c410 error 6 in libmozalloc.so[7fd3d820c000+2000]
<16.3> 2014-06-29 12:32:49 Telcontar dhcpcd 30417 - -  eth1: dhcpcd not running
<16.6> 2014-06-29 12:32:49 Telcontar dhcpcd 30417 - -  eth1: exiting
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Interface eth0.IPv6 no longer relevant for mDNS.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Leaving mDNS multicast group on interface eth0.IPv6 with address fc00::14.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Interface eth0.IPv4 no longer relevant for mDNS.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Leaving mDNS multicast group on interface eth0.IPv4 with address 192.168.1.14.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Withdrawing address record for fc00::14 on eth0.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Withdrawing address record for 192.168.1.14 on eth0.
<3.5> 2014-06-29 12:32:49 Telcontar systemd 1 - -  Unit network@eth0.service entered failed state.
<3.6> 2014-06-29 12:32:49 Telcontar systemd 1 - -  Starting ifup managed network interface eth0...
<3.6> 2014-06-29 12:32:49 Telcontar ifup 30485 - -  eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-06-29 12:32:49 Telcontar ifup 30485 - -      eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<0.6> 2014-06-29 12:32:49 Telcontar kernel - - - [212923.549298] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-06-29 12:32:49 Telcontar kernel - - - [212923.549323] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-06-29 12:32:49 Telcontar kernel - - - [212923.549369] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Joining mDNS multicast group on interface eth0.IPv4 with address 192.168.1.14.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  New relevant interface eth0.IPv4 for mDNS.
<3.6> 2014-06-29 12:32:49 Telcontar avahi-daemon 1020 - -  Registering new address record for 192.168.1.14 on eth0.IPv4.
<3.6> 2014-06-29 12:32:50 Telcontar systemd 1 - -  Starting ifup managed network interface eth1...
<3.6> 2014-06-29 12:32:50 Telcontar ifplugd(eth1) 30800 - -  ifplugd 0.28 initializing.
<3.6> 2014-06-29 12:32:50 Telcontar ifplugd(eth1) 30800 - -  Using interface eth1/00:21:85:16:2D:0C with driver <r8169> (version: 2.3LK-NAPI)
<0.6> 2014-06-29 12:32:50 Telcontar kernel - - - [212924.375304] r8169 0000:07:00.0 eth1: link down
<0.6> 2014-06-29 12:32:50 Telcontar kernel - - - [212924.375373] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
<3.6> 2014-06-29 12:32:50 Telcontar ifplugd(eth1) 30800 - -  Using detection mode: SIOCETHTOOL
<3.6> 2014-06-29 12:32:50 Telcontar ifplugd(eth1) 30800 - -  Initialization complete, link beat not detected.
<3.6> 2014-06-29 12:32:50 Telcontar ifup 30780 - -  eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<3.6> 2014-06-29 12:32:50 Telcontar ifup 30780 - -  eth1      is controlled by ifplugd
<1.5> 2014-06-29 12:32:50 Telcontar ifup 30780 - -      eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-06-29 12:32:50 Telcontar ifup 30780 - -      eth1      is controlled by ifplugd
<3.6> 2014-06-29 12:32:50 Telcontar systemd 1 - -  Started ifup managed network interface eth1.
<0.6> 2014-06-29 12:32:52 Telcontar kernel - - - [212925.693147] r8169 0000:06:00.0 eth0: link up
<0.6> 2014-06-29 12:32:52 Telcontar kernel - - - [212925.693155] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  Joining mDNS multicast group on interface eth0.IPv6 with address fe80::221:85ff:fe16:2d0b.
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  New relevant interface eth0.IPv6 for mDNS.
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  Registering new address record for fe80::221:85ff:fe16:2d0b on eth0.*.
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  Leaving mDNS multicast group on interface eth0.IPv6 with address fe80::221:85ff:fe16:2d0b.
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  Joining mDNS multicast group on interface eth0.IPv6 with address fc00::14.
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  Registering new address record for fc00::14 on eth0.*.
<3.6> 2014-06-29 12:32:53 Telcontar avahi-daemon 1020 - -  Withdrawing address record for fe80::221:85ff:fe16:2d0b on eth0.
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Withdrawing workstation service for eth1.
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Withdrawing address record for 192.168.1.14 on eth0.
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Withdrawing workstation service for eth0.
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Withdrawing workstation service for lo.
<3.4> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Host name conflict, retrying with Telcontar-2
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Registering new address record for fc00::14 on eth0.*.
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Registering new address record for 192.168.1.14 on eth0.IPv4.
<3.6> 2014-06-29 12:32:54 Telcontar avahi-daemon 1020 - -  Registering HINFO record with values 'X86_64'/'LINUX'.
<0.4> 2014-06-29 12:32:55 Telcontar kernel - - - [212928.736057] XFS (sde5): xfs_log_force: error 5 returned.
<3.6> 2014-06-29 12:32:55 Telcontar avahi-daemon 1020 - -  Server startup complete. Host name is Telcontar-2.local. Local service cookie is 580789639.
<4.6> 2014-06-29 12:32:55 Telcontar SuSEfirewall2 - - -  Setting up rules from /etc/sysconfig/SuSEfirewall2 ...
<4.6> 2014-06-29 12:32:55 Telcontar SuSEfirewall2 - - -  using default zone 'ext' for interface eth1
<4.6> 2014-06-29 12:32:55 Telcontar SuSEfirewall2 - - -  Firewall customary rules loaded from /etc/sysconfig/scripts/SuSEfirewall2-custom
<3.6> 2014-06-29 12:32:56 Telcontar avahi-daemon 1020 - -  Service "Telcontar-2" (/etc/avahi/services/udisks.service) successfully established.
<3.6> 2014-06-29 12:32:56 Telcontar avahi-daemon 1020 - -  Service "Telcontar-2" (/etc/avahi/services/ssh.service) successfully established.
<3.6> 2014-06-29 12:32:56 Telcontar avahi-daemon 1020 - -  Service "Telcontar-2" (/etc/avahi/services/sftp-ssh.service) successfully established.
<4.6> 2014-06-29 12:32:58 Telcontar SuSEfirewall2 - - -  Firewall rules successfully set
<3.6> 2014-06-29 12:32:58 Telcontar avahi-autoipd(eth0) 31694 - -  Found user 'avahi-autoipd' (UID 495) and group 'avahi-autoipd' (GID 491).
<3.6> 2014-06-29 12:32:58 Telcontar avahi-autoipd(eth0) 31694 - -  Successfully called chroot().
<3.6> 2014-06-29 12:32:58 Telcontar avahi-autoipd(eth0) 31694 - -  Successfully dropped root privileges.
<3.6> 2014-06-29 12:32:58 Telcontar avahi-autoipd(eth0) 31694 - -  Starting with address 169.254.3.89
<3.6> 2014-06-29 12:32:58 Telcontar avahi-autoipd(eth0) 31694 - -  Routable address already assigned, sleeping.
<3.6> 2014-06-29 12:32:58 Telcontar systemd 1 - -  Started ifup managed network interface eth0.
<3.6> 2014-06-29 12:32:58 Telcontar systemd 1 - -  Started ifup managed network interface eth1.
<3.6> 2014-06-29 12:32:58 Telcontar network 29638 - -  ..done..done..done    ppp0      Startmode is 'manual' -> skipping
<1.5> 2014-06-29 12:32:58 Telcontar ifup 31756 - -      ppp0      Startmode is 'manual' -> skipping
<3.6> 2014-06-29 12:32:58 Telcontar network 29638 - -  ..skippedSetting up service network  .  .  .  .  .  .  .  .  .  .  .  .  ...done
<3.6> 2014-06-29 12:32:58 Telcontar systemd 1 - -  Started LSB: Configure network interfaces and set up routing.
<3.4> 2014-06-29 12:32:58 Telcontar pm-utils - - -  Thawing the system now (04)...
<3.6> 2014-06-29 12:33:01 Telcontar systemd 1 - -  Starting Session 1605 of user news.
<3.4> 2014-06-29 12:33:21 Telcontar router - - -  (Thawing 04) Logging the current IP= 79.150.228.90
<0.4> 2014-06-29 12:33:25 Telcontar kernel - - - [212958.816015] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:33:55 Telcontar kernel - - - [212988.896014] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:34:25 Telcontar kernel - - - [213018.976015] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:34:55 Telcontar kernel - - - [213049.056014] XFS (sde5): xfs_log_force: error 5 returned.
<3.6> 2014-06-29 12:35:01 Telcontar systemd 1 - -  Starting Session 1606 of user news.
<0.4> 2014-06-29 12:35:25 Telcontar kernel - - - [213079.136015] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:35:55 Telcontar kernel - - - [213109.216011] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:36:25 Telcontar kernel - - - [213139.296014] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:36:55 Telcontar kernel - - - [213169.376016] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:37:25 Telcontar kernel - - - [213199.456013] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:37:55 Telcontar kernel - - - [213229.536014] XFS (sde5): xfs_log_force: error 5 returned.
<3.6> 2014-06-29 12:38:01 Telcontar systemd 1 - -  Starting Session 1607 of user news.
<0.4> 2014-06-29 12:38:25 Telcontar kernel - - - [213259.616018] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:38:56 Telcontar kernel - - - [213289.696014] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:39:26 Telcontar kernel - - - [213319.776019] XFS (sde5): xfs_log_force: error 5 returned.
<0.4> 2014-06-29 12:39:56 Telcontar kernel - - - [213349.856014] XFS (sde5): xfs_log_force: error 5 returned.
<3.6> 2014-06-29 12:40:01 Telcontar systemd 1 - -  Starting Session 1608 of user cer.
...
<5.6> 2014-06-29 12:48:34 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="1111" x-info="http://www.rsyslog.com"] exiting on signal 15.
2014-06-29 12:48:35+02:00 - Halting the system now  =========================================== uptime:  12:48pm  up 4 days  8:43,  33 users,  load average: 1.40, 0.53, 0.67
2014-06-29 12:57:41+02:00 - Booting the system now  ================================================================================  Linux Telcontar 3.11.10-11-desktop #1 SMP PREEMPT Mon May 12 13:37:06 UTC 2014 (3d22b5f) x86_64 x86_64 x86_64 GNU/Linux

(it does not show in the log that I had to hit the hardware reset button, 
the machine refused to reboot normally, apparently)


    (If you ask why I took so long to notice the problem after thawing,
    my routine is to power up the machine, then go prepare tea.  :-)
    When I come back with the mug, I'm dismayed to see I can not
    start working; and this day I was in a a hurry)


So I reboot (text mode, level 3), umount home, run xfsrepair, mount again, 
do xfsdump, do simultanesouly an rsync (it is a file by file copy, in case 
of problems with dump), umount, use YaST in text mode to reformat the 
partition, mount, and then xfsrestore.  It did not occur to me to make a 
'dd' photo this time: I was tired and busy.

Maybe next time I can take the photo with dd before doing anything else 
(it takes about 80 minutes), or simply do an "xfs_metadump", which should 
be faster.  And I might not have then 500 GiB of free space to make a dd 
copy, anyway.






Question.

As this always happens on recovery from hibernation, and seeing the message
"Corruption of in-memory data detected", could it be that thawing does a bad
memory recovery from the swap?  I thought that the procedure includes some
checksum, but I don't know for sure.






> This is interesting because the corruption appears to be associated with
> post-eof space, which is generally transient. The worst case is that
> this space is trimmed off files when they are evicted from cache, such
> as during a umount. To me, that seems to correlate with a more
> recent/runtime problem rather than something that might be lingering on
> disk, but we don't really know for sure.

Dunno.

To me, there are two problems:

  1) The corruption itself.
  2) That xfs_repair fails to repair the filesystem. In fact, I believe
     it does not detect it!

To me, #2 is the worst, and it is what makes me do the backup, format, 
restore cycle for recovery. An occassional kernel crash is somewhat 
acceptable :-}



>> Wait! I have a "dd" copy of the entire partition (500 GB), made on March
>> 16th, 5 AM, so hard data could be obtained from there. I had forgotten. I'll
>> get something for you now:

...

>> I could do a "xfs_metadump" on it - just tell me what options to use, and
>> where can the result be uploaded to, if big.
>>
>
> A metadump would be helpful, though that only gives us the on-disk
> state. What was the state of this fs at the time the dd image was
> created?

I'm sorry, I'm not absolutely sure. I believe it is corrupted, but I can 
not vouch it.

> I'm curious if something like an 'rm -rf *' on the metadump
> would catch any other corruptions or if this is indeed limited to
> something associated with recent (pre)allocations.

Sorry, run 'rm -rf *' where???


> Run 'xfs_metadump <src> <tgtfile>' to create a metadump that will
> obfuscate filenames by default. It should also be compressible. In the
> future, it's probably worth grabbing a metadump as a first step (before
> repair, zeroing the log, etc.) so we can look at the fs in the state
> most recent to the crash.

I will take that photo next time, using a rescue system in order to impede 
the system from mounting the partition and replaying the log. Dunno how 
long that will take to happen, though... usually a month - but at least 
now I know how to do it.




Meanwhile, I have done a xfs_metadump of the image, and compressed it with 
xz. It has 10834536 bytes. What do I do with it? I'm not sure I can email 
that, and even less to a mail list.

Do you still have a bugzilla system where I can upload it? I had an 
account at <http://oss.sgi.com/bugzilla/>, made on 2010. I don't know if 
it still runs :-?

If you don't, I can try to create it a bugzilla on openSUSE instead, and 
tell you the number... but I don't know if it takes files that big. If it 
doesn't, I'll fragment the file. You need to have an account there, I 
think, to retrieve the attachment, and I would prefer to mark the bug 
private, or at least the attachment.




I did the following.

First I made a copy, with "dd", of the partition image, all 489G of it. On 
this copy I ran "xfs_check", "xfs_repair -n", and "xfs_repair", with these 
results:


Telcontar:/data/storage_d/old_backup # xfs_check xfs_copy_home_workonit
xfs_check is deprecated and scheduled for removal in June 2014.
Please use xfs_repair -n <dev> instead.
Telcontar:/data/storage_d/old_backup # xfs_repair -n xfs_copy_home_workonit
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
Telcontar:/data/storage_d/old_backup # time xfs_repair xfs_copy_home_workonit
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - zero log...
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
Phase 5 - rebuild AG headers and trees...
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

real    0m28.058s
user    0m1.692s
sys     0m2.265s
Telcontar:/data/storage_d/old_backup #


Maybe the image was made after repair, or maybe xfs_repair doesn't detect 
anything, which as far as I remember, was the case.



I recreate the copy, to try "mount" on an unaltered copy.


Telcontar:/data/storage_d/old_backup # time dd if=xfs_copy_home 
of=xfs_copy_home_workonit && mount -v xfs_copy_home_workonit mount/
1024000000+0 records in
1024000000+0 records out
524288000000 bytes (524 GB) copied, 4662.7 s, 112 MB/s

real    77m43.697s
user    3m1.420s
sys     28m41.958s
mount: /dev/loop0 mounted on /data/storage_d/old_backup/mount.
(reverse-i-search)`mount': time dd if=xfs_copy_home 
Telcontar:/data/storage_d/old_backup #


So it mounts...





- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlO0x18ACgkQtTMYHG2NR9X6QwCcD8r5qXIHVh4ELklM/tzXASds
yskAoIcwxYNC2tKsS7wE9Jp+g4MNUdpd
=pIZI
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
