Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JHbCJZ219222 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 12:37:22 -0500
Received: from internal.actusa.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E133514C0BBD
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 10:37:55 -0700 (PDT)
Received: from internal.actusa.net (internal.actusa.net [208.83.100.16]) by
	cuda.sgi.com with ESMTP id r776NDo59bK7buIa for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 10:37:55 -0700 (PDT)
Message-ID: <4A8C37F3.90300@actusa.net>
Date: Wed, 19 Aug 2009 10:35:47 -0700
From: Stuart Sheldon <stu@actusa.net>
MIME-Version: 1.0
Subject: Kernel crash with >2.6.28.10 + drbd + nfs + xfs + heartbeat
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
Cc: support@actusa.net

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi all,

I've traced this down to what looks to be a XFS problem. When executing
a hb_standby the system crashes with the following error on the console:

- ------ Start Errors --------
Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel:last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel:invalid opcode: 0000 [#1] SMP

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel:Stack:

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: ffff880217dfad10 ffff880217dfad00 ffff880217dfad10 ffffffffa034b8ea

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel:Call Trace:

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffffa034cfda>] ? xfs_inode_set_reclaim_tag+0x69/0x89 [xfs]

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: ffff88021197de58 0000000000000001 ffff88021197de58 ffffffffa033ff6e

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffffa033ff6e>] ? xfs_reclaim+0x99/0x9f [xfs]

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffffa034b8ea>] ? xfs_fs_destroy_inode+0x2f/0x4d [xfs]

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8029b034>] ? dispose_list+0xcd/0xfb

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8029b386>] ? invalidate_inodes+0xfe/0x11c

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8028c01f>] ? generic_shutdown_super+0x49/0xfd

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8028c0f5>] ? kill_block_super+0x22/0x3a

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8028c740>] ? deactivate_super+0x5f/0x77

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8029e62a>] ? sys_umount+0x2d8/0x307

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel: [<ffffffff8020b96b>] ? system_call_fastpath+0x16/0x1b

Message from syslogd@drbd-1 at Aug 19 09:30:43 ...
 kernel:Code: 18 02 00 00 48 d3 e8 89 c1 83 e1 3f 41 0f a3 0c 11 19 c0
85 c0 75 07 49 8d 04 11 0f ab 08 48 63 c1 4d 8b 44 c0 18 4d 85 c0 75 04
<0f> 0b eb fe 41 83 eb 06 41 ff ca 45 85 d2 75 bc 4d 85 c0 74 16
- --------- End Errors --------

System info:
Intel(R) Celeron(R) CPU        E1400  @ 2.00GHz

flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl
est tm2 ssse3 cx16 xtpr pdcm lahf_lm

Kernel: Vanilla 2.6.30.5 amd64 (anything past 2.6.28.10 will produce
problem)

Distro: Debian Lenny

XFS is built as a module. Here is the Heartbeat command file that creams
the machine:

drbd-1 IPaddr::xxx.xxx.xxx.xxx/26/eth0 \
        drbddisk::r0 \
        Filesystem::/dev/drbd0::/data::xfs::noatime,nodiratime \
        killnfsd \
        nfs-common \
        nfs-kernel-server \
        MailTo::root::NFS_Fallover_Notice

I can pretty much duplicate this at will. I just need to slot a
maintenance window.

Let me know if you need any more info... I'd really like to help get
this resolved.

Thanks in advance.

Stuart Sheldon
ACT USA

- --
And so it was, that later, as the miller told his tale,
that her face at first just ghostly, turned a whiter shade of pale...
                -- Procol Harum - "Whiter Shade of Pale Lyrics"
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKjDfzAAoJEFKVLITDJSGSuCcP/i0noYmVN4s1dVRzyDuXXLoM
nIt/cdvMZM2KjkrYlDtRZcd3HF3SyDQX024f0hbncvPQrVBcgEeH18WJpXPTLHw1
S47ETIZHwVeI8Jm174rl/uVHZS9YyPlUMysNgOhdT+CZYLIxWCzVXWLenSdL5n7O
YaFPEJRKwNvX8iui9DaWkXJdEmRM0LADDkMO4MtrclBeS6GP8+DMgIBJb0mKNkie
y6L67lUiqm6QYaUaGA4hotQJ5IKUbxxRGllil9TB3goQ+lfeUBgBwmKEdPIWb+DV
8V5LG3/o2gbfPSWksmTuk2+A2M/6g3x/2btfvOlS8/DX3lMzTEdDIdM4+YlK9Uvf
drKLvKGwAfaqBwfE45ax6Kc7deOWGTAKD6zxXtVIvryGit+aHSJ9Ygf6BdTzK/nA
qa4+sa7t669bcg2YJztjinrsrwHnSroZCM5a6Nrg8geKt/WlBDXdykYtXhWnvF0s
zulVLWkFhv4vnkjVi8Dx0SvpkII6T7b4x/ldMvdegxQWP0uzME4Ek6W4BwRzV/mQ
+pi7X+Nvgc/zoEQEpmj62dIzxr8NS927pR+dmG8xF6z1VcYsyfxUPxMXCs4uMW4m
IfzqBC9E48NyTkHmaCyR6yNTA7HtkEtFeTm/6Gj4C3jAV5DylfmMVsyO1cOdhj7y
JlLJD0Oe8NGORnjt3Xs9
=zccl
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
