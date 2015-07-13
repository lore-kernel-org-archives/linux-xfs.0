Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB7FE7F66
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 13:10:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 89FB58F8035
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 11:10:17 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	evNGJTBJ5mMORbmq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jul 2015 11:10:13 -0700 (PDT)
Received: by widic2 with SMTP id ic2so19241761wid.0
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 11:10:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150713170158.GB50787@bfoster.bfoster>
References: <5582DCDA.9070200@sandeen.net>
	<CA++_uhuFL0DhwH3ENBHmFmzmBm5SGx45P9tqVTEdj-bCsHBSVA@mail.gmail.com>
	<20150709125119.GC63282@bfoster.bfoster>
	<CA++_uhuoQ76uOUikbetw5ocfHDGAFMERcbgX9R4Shha2GUxWmQ@mail.gmail.com>
	<20150709151811.GE63282@bfoster.bfoster>
	<CA++_uhu=VNKtjax_JjsCZwDFT0Vk-CAjS5j=ba5+A5HL4nxpmA@mail.gmail.com>
	<20150709183255.GG63282@bfoster.bfoster>
	<CA++_uht5N6MtqUQfbB9A3R__UvR4aLN2q5-mFKiO__vU-Cxwpw@mail.gmail.com>
	<20150713125214.GA50787@bfoster.bfoster>
	<CA++_uhvrDBuP9nANTc0ZxZudDriYKrrtnaQUZzXPRLs0otD22w@mail.gmail.com>
	<20150713170158.GB50787@bfoster.bfoster>
Date: Tue, 14 Jul 2015 02:10:12 +0800
Message-ID: <CA++_uhvDrO2BmQ+q0bN=M_L-vUUaLZO9bHoKh0ntFveM5t-DNQ@mail.gmail.com>
Subject: Re: Data can't be wrote to XFS RIP [<ffffffffa041a99a>]
	xfs_dir2_sf_get_parent_ino+0xa/0x20
From: Kuo Hugo <tonytkdk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8611441357489344061=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============8611441357489344061==
Content-Type: multipart/alternative; boundary=047d7bacbd88ff1506051ac5a135

--047d7bacbd88ff1506051ac5a135
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Brain,

The sdb is mounted on /srv/node/d224 on this server. That's one of three
disks that the process was making I/O on it.
Those openfiles on /srv/node/d224 were made by the process to
storing/deleting data at that moment while the kernel panic appeared.

```
36 ffff8808703ed6c0 ffff88086fd65540 ffff8805eb03ed88 REG
/srv/node/d205/quarantined/objects/cd1d68f515006d443a54ff4f658091bc-
a114bba1449b45238abf38dc741d7c27/1436254020.89801.ts 37 ffff8810718343c0
ffff88105b9d32c0 ffff8808745aa5e8 REG [eventpoll] 38 ffff8808713da780
ffff880010c9a900 ffff88096368a188 REG /srv/node/d224/quarantined/objects/
b146865bf8034bfc42570b747c341b32/1436266042.57775.ts 39 ffff880871cb03c0
ffff880495a8b380 ffff8808a5e6c988 REG /srv/node/d224/tmp/tmpSpnrHg 40
ffff8808715b4540 ffff8804819c58c0 ffff8802381f8d88 DIR
/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32
```

I'll check the dir location of the inode number.

Nice information.

Thanks // Hugo

2015-07-14 1:01 GMT+08:00 Brian Foster <bfoster@redhat.com>:

> On Mon, Jul 13, 2015 at 10:06:39PM +0800, Kuo Hugo wrote:
> > Hi Brain,
> >
> > Sorry for the wrong file in previous message. I believe this the right
> one.
> >
> > https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko.debug
> >
> >
> /usr/lib/debug/lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.k=
o.debug
> >
> > MD5 : 27829c9c55f4f5b095d29a7de7c27254
> >
>
> Yes, that works. I have a few bits of information so far, but nothing
> obvious to me as to what caused the problem. Some info:
>
> - The crash is indeed at xfs_dir2_sf_get_inumber():
>
> /usr/src/debug/kernel-2.6.32-504.23.4.el6/linux-2.6.32-504.23.4.el6.x86_6=
4/fs/xfs/xfs_dir2_sf.h:
> 101
> 0xffffffffa0362d60 <xfs_dir2_sf_getdents+672>:  cmpb   $0x0,0x1(%r12)
> ...
>
> - %r12 above has a value of 0 and is set as follows:
>
> /usr/src/debug/kernel-2.6.32-504.23.4.el6/linux-2.6.32-504.23.4.el6.x86_6=
4/fs/xfs/xfs_dir2_sf.c:
> 727
> 0xffffffffa0362b11 <xfs_dir2_sf_getdents+81>:   mov    0x50(%rdi),%r12
>
> ... which is the sfp pointer assignment in the getdents function:
>
>         sfp =3D (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
>
> This implies a NULL if_data.
>
> - The backtrace lists a couple of inodes on the stack in this frame. I'm
> not sure why, but one looks like a valid directory and the other looks
> bogus. The valid inode has an inode number of 13668207561.
>
> - The fsname for this inode is "sdb."
>
> - The inode does appear to have a non-NULL if_data:
>
>     ...
>     if_u1 =3D {
>       if_extents =3D 0xffff88084feaf5c0,
>       if_ext_irec =3D 0xffff88084feaf5c0,
>       if_data =3D 0xffff88084feaf5c0 "\004"
>     },
>     ...
>
> So it's not totally clear what's going on there. It might be interesting
> to see what directory this refers to, if it still exists on the sdb fs.
> For example, is it an external directory or some kind of internal
> directory created by the application? You could use something like the
> following to try and locate the directory based on inode number:
>
>         find <mntpath> -inum 13668207561
>
> Brian
>
> > Thanks // Hugo
> > =E2=80=8B
> >
> > 2015-07-13 20:52 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> >
> > > On Fri, Jul 10, 2015 at 01:36:41PM +0800, Kuo Hugo wrote:
> > > > Hi Brain,
> > > >
> > > > Is this the file which you need ?
> > > >
> > > > https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko
> > > >
> > > > $> modinfo xfs
> > > >
> > > > filename:
> /lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko
> > > > license: GPL
> > > > description: SGI XFS with ACLs, security attributes, large
> block/inode
> > > > numbers, no debug enabled
> > > > author: Silicon Graphics, Inc.
> > > > srcversion: 0C1B17926BDDA4F121479EE
> > > > depends: exportfs
> > > > vermagic: 2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversion
> > > >
> > >
> > > No, this isn't the debug version. We need the one from the debug
> package
> > > that was installed (/usr/lib/debug?).
> > >
> > > Brian
> > >
> > > > Thanks // Hugo
> > > > =E2=80=8B
> > > >
> > > > 2015-07-10 2:32 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> > > >
> > > > > On Fri, Jul 10, 2015 at 12:40:00AM +0800, Kuo Hugo wrote:
> > > > > > Hi Brain,
> > > > > >
> > > > > > There you go.
> > > > > >
> > > > > > https://cloud.swiftstack.com/v1/AUTH_hugo/public/vmlinux
> > > > > >
> > > > >
> > >
> https://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.23=
.4.el6.x86_64
> > > > > >
> > > > > > $ md5sum vmlinux
> > > > > > 82aaa694a174c0a29e78c05e73adf5d8  vmlinux
> > > > > >
> > > > > > Yes, I can read it with this vmlinux image. Put all files
> > > > > > (vmcore,vmlinux,System.map) in a folder and run $crash vmlinux
> vmcore
> > > > > >
> > > > >
> > > > > Thanks, I can actually load that up now. Note that we'll probably
> need
> > > > > the modules and whatnot (xfs.ko) also to be able to look at any X=
FS
> > > > > bits. It might be easiest to just tar up and compress whatever
> > > directory
> > > > > structure has the debug-enabled vmlinux and all the kernel module=
s.
> > > > > Thanks.
> > > > >
> > > > > Brian
> > > > >
> > > > > > Hugo
> > > > > > =E2=80=8B
> > > > > >
> > > > > > 2015-07-09 23:18 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> > > > > >
> > > > > > > On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo Hugo wrote:
> > > > > > > > Hi Brian,
> > > > > > > >
> > > > > > > > *Operating System Version:*
> > > > > > > > Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Fin=
al
> > > > > > > >
> > > > > > > > *NODE 1*
> > > > > > > >
> > > > > > > > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcor=
e
> > > > > > > >
> > > > >
> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt
> > > > > > > >
> > > > > > > >
> > > > > > > > *NODE 2*
> > > > > > > >
> > > > > > > >
> > > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02
> > > > > > > >
> > > > > > >
> > > > >
> > >
> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj0=
2.txt
> > > > > > > >
> > > > > > > >
> > > > > > > > Any thoughts would be appreciate
> > > > > > > >
> > > > > > >
> > > > > > > I'm not able to fire up crash with these core files and the
> kernel
> > > > > debug
> > > > > > > info from the following centos kernel debuginfo package:
> > > > > > >
> > > > > > > kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64.rpm
> > > > > > >
> > > > > > > It complains about a version mismatch between the vmlinux and
> core
> > > > > file.
> > > > > > > I'm no crash expert... are you sure the cores above correspon=
d
> to
> > > this
> > > > > > > kernel? Does crash load up for you on said box if you run
> something
> > > > > like
> > > > > > > the following?
> > > > > > >
> > > > > > >         crash /usr/lib/debug/lib/modules/.../vmlinux vmcore
> > > > > > >
> > > > > > > Note that you might need to install the above kernel-debuginf=
o
> > > package
> > > > > > > to get the debug (vmlinux) file. If so, could you also upload
> that
> > > > > > > debuginfo rpm somewhere?
> > > > > > >
> > > > > > > Brian
> > > > > > >
> > > > > > > > Thanks // Hugo
> > > > > > > >
> > > > > > > >
> > > > > > > > 2015-07-09 20:51 GMT+08:00 Brian Foster <bfoster@redhat.com
> >:
> > > > > > > >
> > > > > > > > > On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrote:
> > > > > > > > > > Hi Folks,
> > > > > > > > > >
> > > > > > > > > > As the results of 32 disks with xfs_repair -n seems no
> any
> > > error
> > > > > > > shows
> > > > > > > > > up.
> > > > > > > > > > We currently tried to deploy CentOS 6.6 for testing. (T=
he
> > > > > previous
> > > > > > > kernel
> > > > > > > > > > panic was came from Ubuntu).
> > > > > > > > > > The CentOS nodes encountered kernel panic with same
> daemon
> > > but
> > > > > the
> > > > > > > > > problem
> > > > > > > > > > may a bit differ.
> > > > > > > > > >
> > > > > > > > > >    - It was broken on
> xfs_dir2_sf_get_parent_ino+0xa/0x20 in
> > > > > Ubuntu.
> > > > > > > > > >    - Here=E2=80=99s the log in CentOS. It=E2=80=99s bro=
ken on
> > > > > > > > > >    xfs_dir2_sf_getdents+0x2a0/0x3a0
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > I'd venture to guess it's the same behavior here. The
> previous
> > > > > kernel
> > > > > > > > > had a callback for the parent inode number that was calle=
d
> via
> > > > > > > > > xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it
> has a
> > > > > static
> > > > > > > > > inline here instead.
> > > > > > > > >
> > > > > > > > > > <1>BUG: unable to handle kernel NULL pointer dereferenc=
e
> at
> > > > > > > > > 0000000000000001
> > > > > > > > > > <1>IP: [<ffffffffa0362d60>]
> xfs_dir2_sf_getdents+0x2a0/0x3a0
> > > > > [xfs]
> > > > > > > > > > <4>PGD 1072327067 PUD 1072328067 PMD 0
> > > > > > > > > > <4>Oops: 0000 [#1] SMP
> > > > > > > > > > <4>last sysfs file:
> > > > > > > > > >
> > > > > > > > >
> > > > > > >
> > > > >
> > >
> /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/expand=
er-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sdz/q=
ueue/rotational
> > > > > > > > > > <4>CPU 17
> > > > > > > > > > <4>Modules linked in: xt_conntrack tun xfs exportfs
> > > > > iptable_filter
> > > > > > > > > > ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4
> > > nf_conntrack
> > > > > > > > > > nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt
> > > > > > > > > > iTCO_vendor_support ses enclosure igb i2c_algo_bit
> sb_edac
> > > > > edac_core
> > > > > > > > > > i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca
> ptp
> > > > > pps_core
> > > > > > > > > > mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4
> jbd2
> > > > > mbcache
> > > > > > > > > > sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class
> > > xhci_hcd
> > > > > ahci
> > > > > > > > > > wmi dm_mirror dm_region_hash dm_log dm_mod [last
> unloaded:
> > > > > > > > > > scsi_wait_scan]
> > > > > > > > > > <4>
> > > > > > > > > > <4>Pid: 4454, comm: swift-object-se Not tainted
> > > > > > > > > > 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storfor=
m
> > > > > > > > > > R518.v5P/X10DRi-T4+
> > > > > > > > > > <4>RIP: 0010:[<ffffffffa0362d60>]  [<ffffffffa0362d60>]
> > > > > > > > > > xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > > > > > > > > > <4>RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
> > > > > > > > > > <4>RAX: 0000000000000000 RBX: 0000000000000004 RCX:
> > > > > 0000000000000000
> > > > > > > > > > <4>RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> > > > > 00007faa74006203
> > > > > > > > > > <4>RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09:
> > > > > 0000000000000004
> > > > > > > > > > <4>R10: 0000000000008030 R11: 0000000000000246 R12:
> > > > > 0000000000000000
> > > > > > > > > > <4>R13: 0000000000000002 R14: ffff88106eff7000 R15:
> > > > > ffff8808715b4580
> > > > > > > > > > <4>FS:  00007faa85425700(0000) GS:ffff880028360000(0000=
)
> > > > > > > > > knlGS:0000000000000000
> > > > > > > > > > <4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > > > > > > <4>CR2: 0000000000000001 CR3: 0000001072325000 CR4:
> > > > > 00000000001407e0
> > > > > > > > > > <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > > 0000000000000000
> > > > > > > > > > <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > > > > 0000000000000400
> > > > > > > > > > <4>Process swift-object-se (pid: 4454, threadinfo
> > > > > ffff880871f6c000,
> > > > > > > > > > task ffff880860f18ab0)
> > > > > > > > > > <4>Stack:
> > > > > > > > > > <4> ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38
> > > > > > > ffff880874749cc0
> > > > > > > > > > <4><d> 0000000100000103 ffff8802381f8c00 ffff880871f6df=
38
> > > > > > > > > ffff8808715b4580
> > > > > > > > > > <4><d> 0000000000000082 ffff8802381f8d88 ffff880871f6de=
c8
> > > > > > > > > ffffffffa035ab31
> > > > > > > > > > <4>Call Trace:
> > > > > > > > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > > > > > > > > > <4> [<ffffffffa035ab31>] xfs_readdir+0xe1/0x130 [xfs]
> > > > > > > > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > > > > > > > > > <4> [<ffffffffa038fe29>] xfs_file_readdir+0x39/0x50 [xf=
s]
> > > > > > > > > > <4> [<ffffffff811a4e30>] vfs_readdir+0xc0/0xe0
> > > > > > > > > > <4> [<ffffffff8119bd86>] ? final_putname+0x26/0x50
> > > > > > > > > > <4> [<ffffffff811a4fb9>] sys_getdents+0x89/0xf0
> > > > > > > > > > <4> [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > > > > > > > > <4>Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 f=
f
> 55
> > > b8
> > > > > 85 c0
> > > > > > > > > > 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 0=
0
> 00
> > > 00
> > > > > 00 00
> > > > > > > > > > <41> 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03
> 41
> > > 0f b6
> > > > > > > > > > <1>RIP  [<ffffffffa0362d60>]
> xfs_dir2_sf_getdents+0x2a0/0x3a0
> > > > > [xfs]
> > > > > > > > > > <4> RSP <ffff880871f6de18>
> > > > > > > > > > <4>CR2: 0000000000000001
> > > > > > > > > >
> > > > > > > > > ...
> > > > > > > > > >
> > > > > > > > > > I=E2=80=99ve got the vmcore dump from operator. Does vm=
core help
> for
> > > > > > > > > > troubleshooting kind issue ?
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Hmm, well it couldn't hurt. Is the vmcore based on this 6=
.6
> > > > > kernel? Can
> > > > > > > > > you provide the exact kernel version and post the vmcore
> > > somewhere?
> > > > > > > > >
> > > > > > > > > Brian
> > > > > > > > >
> > > > > > > > > > Thanks // Hugo
> > > > > > > > > > =E2=80=8B
> > > > > > > > > >
> > > > > > > > > > 2015-06-18 22:59 GMT+08:00 Eric Sandeen <
> sandeen@sandeen.net
> > > >:
> > > > > > > > > >
> > > > > > > > > > > On 6/18/15 9:29 AM, Kuo Hugo wrote:
> > > > > > > > > > > >>- Have you tried an 'xfs_repair -n' of the affected
> > > > > filesystem?
> > > > > > > Note
> > > > > > > > > > > that -n will report problems only and prevent any
> > > modification
> > > > > by
> > > > > > > > > repair.
> > > > > > > > > > > >
> > > > > > > > > > > > *We might to to xfs_repair if we can address which
> disk
> > > > > causes
> > > > > > > the
> > > > > > > > > > > issue. *
> > > > > > > > > > >
> > > > > > > > > > > If you do, please save the output, and if it finds
> > > anything,
> > > > > please
> > > > > > > > > > > provide the output in this thread.
> > > > > > > > > > >
> > > > > > > > > > > Thanks,
> > > > > > > > > > > -Eric
> > > > > > > > > > >
> > > > > > > > >
> > > > > > > > > > _______________________________________________
> > > > > > > > > > xfs mailing list
> > > > > > > > > > xfs@oss.sgi.com
> > > > > > > > > > http://oss.sgi.com/mailman/listinfo/xfs
> > > > > > > > >
> > > > > > > > >
> > > > > > >
> > > > >
> > >
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > >
> > >
>

--047d7bacbd88ff1506051ac5a135
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Brain,=C2=A0<div><br></div><div>The sdb is mounted on /=
srv/node/d224 on this server. That&#39;s one of three disks that the proces=
s was making I/O on it.=C2=A0</div><div>Those openfiles on /srv/node/d224 w=
ere made by the process to storing/deleting data at that moment while the k=
ernel panic appeared.=C2=A0</div><div><br></div><div>```</div><div><span st=
yle=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:11.8999=
996185303px;line-height:16.8000011444092px;white-space:pre-wrap;background-=
color:rgb(248,248,248)"> 36 ffff8808703ed6c0 ffff88086fd65540 ffff8805eb03e=
d88 REG  /srv/node/d205/quarantined/</span><span style=3D"font-family:Conso=
las,Inconsolata,Courier,monospace;font-size:11.8999996185303px;line-height:=
16.8000011444092px;white-space:pre-wrap;background-color:rgb(248,248,248)">=
objects/</span><span style=3D"font-family:Consolas,Inconsolata,Courier,mono=
space;font-size:11.8999996185303px;line-height:16.8000011444092px;white-spa=
ce:pre-wrap;background-color:rgb(248,248,248)">cd1d68f515006d443a54ff4f6580=
91</span><span style=3D"font-family:Consolas,Inconsolata,Courier,monospace;=
font-size:11.8999996185303px;line-height:16.8000011444092px;white-space:pre=
-wrap;background-color:rgb(248,248,248)">bc-</span><span style=3D"font-fami=
ly:Consolas,Inconsolata,Courier,monospace;font-size:11.8999996185303px;line=
-height:16.8000011444092px;white-space:pre-wrap;background-color:rgb(248,24=
8,248)">a114bba1449b45238abf38dc741d7c</span><span style=3D"font-family:Con=
solas,Inconsolata,Courier,monospace;font-size:11.8999996185303px;line-heigh=
t:16.8000011444092px;white-space:pre-wrap;background-color:rgb(248,248,248)=
">27/1436254020.89801.ts
 37 ffff8810718343c0 ffff88105b9d32c0 ffff8808745aa5e8 REG  [eventpoll]
 38 ffff8808713da780 ffff880010c9a900 ffff88096368a188 REG  /srv/node/d224/=
quarantined/</span><span style=3D"font-family:Consolas,Inconsolata,Courier,=
monospace;font-size:11.8999996185303px;line-height:16.8000011444092px;white=
-space:pre-wrap;background-color:rgb(248,248,248)">objects/</span><span sty=
le=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:11.89999=
96185303px;line-height:16.8000011444092px;white-space:pre-wrap;background-c=
olor:rgb(248,248,248)">b146865bf8034bfc42570b747c341b</span><span style=3D"=
font-family:Consolas,Inconsolata,Courier,monospace;font-size:11.89999961853=
03px;line-height:16.8000011444092px;white-space:pre-wrap;background-color:r=
gb(248,248,248)">32/1436266042.57775.ts
 39 ffff880871cb03c0 ffff880495a8b380 ffff8808a5e6c988 REG  /srv/node/d224/=
tmp/tmpSpnrHg
 40 ffff8808715b4540 ffff8804819c58c0 ffff8802381f8d88 DIR  /srv/node/d224/=
quarantined/</span><span style=3D"font-family:Consolas,Inconsolata,Courier,=
monospace;font-size:11.8999996185303px;line-height:16.8000011444092px;white=
-space:pre-wrap;background-color:rgb(248,248,248)">objects/</span><span sty=
le=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:11.89999=
96185303px;line-height:16.8000011444092px;white-space:pre-wrap;background-c=
olor:rgb(248,248,248)">b146865bf8034bfc42570b747c341b</span><span style=3D"=
font-family:Consolas,Inconsolata,Courier,monospace;font-size:11.89999961853=
03px;line-height:16.8000011444092px;white-space:pre-wrap;background-color:r=
gb(248,248,248)">32</span><br></div><div>```</div><div><br></div><div>I&#39=
;ll check the dir location of the inode number.=C2=A0</div><div><br></div><=
div>Nice information.=C2=A0</div><div><br></div><div>Thanks // Hugo=C2=A0</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2015-07=
-14 1:01 GMT+08:00 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfo=
ster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span>:<br><b=
lockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px =
#ccc solid;padding-left:1ex"><span class=3D"">On Mon, Jul 13, 2015 at 10:06=
:39PM +0800, Kuo Hugo wrote:<br>
&gt; Hi Brain,<br>
&gt;<br>
</span><span class=3D"">&gt; Sorry for the wrong file in previous message. =
I believe this the right one.<br>
&gt;<br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko.deb=
ug" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.com/v1/AU=
TH_hugo/public/xfs.ko.debug</a><br>
&gt;<br>
&gt; /usr/lib/debug/lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xf=
s.ko.debug<br>
&gt;<br>
&gt; MD5 : 27829c9c55f4f5b095d29a7de7c27254<br>
&gt;<br>
<br>
</span>Yes, that works. I have a few bits of information so far, but nothin=
g<br>
obvious to me as to what caused the problem. Some info:<br>
<br>
- The crash is indeed at xfs_dir2_sf_get_inumber():<br>
<br>
/usr/src/debug/kernel-2.6.32-504.23.4.el6/linux-2.6.32-504.23.4.el6.x86_64/=
fs/xfs/xfs_dir2_sf.h: 101<br>
0xffffffffa0362d60 &lt;xfs_dir2_sf_getdents+672&gt;:=C2=A0 cmpb=C2=A0 =C2=
=A0$0x0,0x1(%r12)<br>
...<br>
<br>
- %r12 above has a value of 0 and is set as follows:<br>
<br>
/usr/src/debug/kernel-2.6.32-504.23.4.el6/linux-2.6.32-504.23.4.el6.x86_64/=
fs/xfs/xfs_dir2_sf.c: 727<br>
0xffffffffa0362b11 &lt;xfs_dir2_sf_getdents+81&gt;:=C2=A0 =C2=A0mov=C2=A0 =
=C2=A0 0x50(%rdi),%r12<br>
<br>
... which is the sfp pointer assignment in the getdents function:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sfp =3D (xfs_dir2_sf_t *)dp-&gt;i_df.if_u1.if_d=
ata;<br>
<br>
This implies a NULL if_data.<br>
<br>
- The backtrace lists a couple of inodes on the stack in this frame. I&#39;=
m<br>
not sure why, but one looks like a valid directory and the other looks<br>
bogus. The valid inode has an inode number of 13668207561.<br>
<br>
- The fsname for this inode is &quot;sdb.&quot;<br>
<br>
- The inode does appear to have a non-NULL if_data:<br>
<br>
=C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 if_u1 =3D {<br>
=C2=A0 =C2=A0 =C2=A0 if_extents =3D 0xffff88084feaf5c0,<br>
=C2=A0 =C2=A0 =C2=A0 if_ext_irec =3D 0xffff88084feaf5c0,<br>
=C2=A0 =C2=A0 =C2=A0 if_data =3D 0xffff88084feaf5c0 &quot;\004&quot;<br>
=C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 ...<br>
<br>
So it&#39;s not totally clear what&#39;s going on there. It might be intere=
sting<br>
to see what directory this refers to, if it still exists on the sdb fs.<br>
For example, is it an external directory or some kind of internal<br>
directory created by the application? You could use something like the<br>
following to try and locate the directory based on inode number:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 find &lt;mntpath&gt; -inum 13668207561<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Thanks // Hugo<br>
&gt; =E2=80=8B<br>
&gt;<br>
&gt; 2015-07-13 20:52 GMT+08:00 Brian Foster &lt;<a href=3D"mailto:bfoster@=
redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt;<br>
&gt; &gt; On Fri, Jul 10, 2015 at 01:36:41PM +0800, Kuo Hugo wrote:<br>
&gt; &gt; &gt; Hi Brain,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Is this the file which you need ?<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/=
xfs.ko" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.com/v=
1/AUTH_hugo/public/xfs.ko</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $&gt; modinfo xfs<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; filename: /lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/=
xfs/xfs.ko<br>
&gt; &gt; &gt; license: GPL<br>
&gt; &gt; &gt; description: SGI XFS with ACLs, security attributes, large b=
lock/inode<br>
&gt; &gt; &gt; numbers, no debug enabled<br>
&gt; &gt; &gt; author: Silicon Graphics, Inc.<br>
&gt; &gt; &gt; srcversion: 0C1B17926BDDA4F121479EE<br>
&gt; &gt; &gt; depends: exportfs<br>
&gt; &gt; &gt; vermagic: 2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversi=
on<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; No, this isn&#39;t the debug version. We need the one from the de=
bug package<br>
&gt; &gt; that was installed (/usr/lib/debug?).<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 2015-07-10 2:32 GMT+08:00 Brian Foster &lt;<a href=3D"mailto=
:bfoster@redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; On Fri, Jul 10, 2015 at 12:40:00AM +0800, Kuo Hugo wrot=
e:<br>
&gt; &gt; &gt; &gt; &gt; Hi Brain,<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; There you go.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hu=
go/public/vmlinux" rel=3D"noreferrer" target=3D"_blank">https://cloud.swift=
stack.com/v1/AUTH_hugo/public/vmlinux</a><br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/Syste=
m.map-2.6.32-504.23.4.el6.x86_64" rel=3D"noreferrer" target=3D"_blank">http=
s://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.23.4.el6=
.x86_64</a><br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; $ md5sum vmlinux<br>
&gt; &gt; &gt; &gt; &gt; 82aaa694a174c0a29e78c05e73adf5d8=C2=A0 vmlinux<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Yes, I can read it with this vmlinux image. Put al=
l files<br>
&gt; &gt; &gt; &gt; &gt; (vmcore,vmlinux,System.map) in a folder and run $c=
rash vmlinux vmcore<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Thanks, I can actually load that up now. Note that we&#=
39;ll probably need<br>
&gt; &gt; &gt; &gt; the modules and whatnot (xfs.ko) also to be able to loo=
k at any XFS<br>
&gt; &gt; &gt; &gt; bits. It might be easiest to just tar up and compress w=
hatever<br>
&gt; &gt; directory<br>
&gt; &gt; &gt; &gt; structure has the debug-enabled vmlinux and all the ker=
nel modules.<br>
&gt; &gt; &gt; &gt; Thanks.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Brian<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Hugo<br>
&gt; &gt; &gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; 2015-07-09 23:18 GMT+08:00 Brian Foster &lt;<a hre=
f=3D"mailto:bfoster@redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo=
 Hugo wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi Brian,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; *Operating System Version:*<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Linux-2.6.32-504.23.4.el6.x86_64-x86_64-=
with-centos-6.6-Final<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; *NODE 1*<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/=
v1/AUTH_burton/brtnswift/vmcore" rel=3D"noreferrer" target=3D"_blank">https=
://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/=
brtnswift/vmcore-dmesg.txt" rel=3D"noreferrer" target=3D"_blank">https://cl=
oud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; *NODE 2*<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/=
vmcore_r2obj02" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftsta=
ck.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/=
vmcore-dmesg_r2obj02.txt" rel=3D"noreferrer" target=3D"_blank">https://clou=
d.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj02.txt</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Any thoughts would be appreciate<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; I&#39;m not able to fire up crash with these =
core files and the kernel<br>
&gt; &gt; &gt; &gt; debug<br>
&gt; &gt; &gt; &gt; &gt; &gt; info from the following centos kernel debugin=
fo package:<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; kernel-debuginfo-2.6.32-504.23.4.el6.centos.p=
lus.x86_64.rpm<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; It complains about a version mismatch between=
 the vmlinux and core<br>
&gt; &gt; &gt; &gt; file.<br>
&gt; &gt; &gt; &gt; &gt; &gt; I&#39;m no crash expert... are you sure the c=
ores above correspond to<br>
&gt; &gt; this<br>
&gt; &gt; &gt; &gt; &gt; &gt; kernel? Does crash load up for you on said bo=
x if you run something<br>
&gt; &gt; &gt; &gt; like<br>
&gt; &gt; &gt; &gt; &gt; &gt; the following?<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crash /usr/l=
ib/debug/lib/modules/.../vmlinux vmcore<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Note that you might need to install the above=
 kernel-debuginfo<br>
&gt; &gt; package<br>
&gt; &gt; &gt; &gt; &gt; &gt; to get the debug (vmlinux) file. If so, could=
 you also upload that<br>
&gt; &gt; &gt; &gt; &gt; &gt; debuginfo rpm somewhere?<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Brian<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; 2015-07-09 20:51 GMT+08:00 Brian Foster =
&lt;<a href=3D"mailto:bfoster@redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; On Thu, Jul 09, 2015 at 06:57:55PM =
+0800, Kuo Hugo wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi Folks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; As the results of 32 disks wit=
h xfs_repair -n seems no any<br>
&gt; &gt; error<br>
&gt; &gt; &gt; &gt; &gt; &gt; shows<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; up.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; We currently tried to deploy C=
entOS 6.6 for testing. (The<br>
&gt; &gt; &gt; &gt; previous<br>
&gt; &gt; &gt; &gt; &gt; &gt; kernel<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; panic was came from Ubuntu).<b=
r>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; The CentOS nodes encountered k=
ernel panic with same daemon<br>
&gt; &gt; but<br>
&gt; &gt; &gt; &gt; the<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; problem<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; may a bit differ.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 - It was broken o=
n xfs_dir2_sf_get_parent_ino+0xa/0x20 in<br>
&gt; &gt; &gt; &gt; Ubuntu.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 - Here=E2=80=99s =
the log in CentOS. It=E2=80=99s broken on<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 xfs_dir2_sf_getde=
nts+0x2a0/0x3a0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I&#39;d venture to guess it&#39;s t=
he same behavior here. The previous<br>
&gt; &gt; &gt; &gt; kernel<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; had a callback for the parent inode=
 number that was called via<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; xfs_dir2_sf_getdents(). Taking a lo=
ok at a 6.6 kernel, it has a<br>
&gt; &gt; &gt; &gt; static<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; inline here instead.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;1&gt;BUG: unable to handle=
 kernel NULL pointer dereference at<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 0000000000000001<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;1&gt;IP: [&lt;ffffffffa036=
2d60&gt;] xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt; &gt; &gt; &gt; [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;PGD 1072327067 PUD 10=
72328067 PMD 0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Oops: 0000 [#1] SMP<b=
r>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;last sysfs file:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:=
1/expander-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/blo=
ck/sdz/queue/rotational<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CPU 17<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Modules linked in: xt=
_conntrack tun xfs exportfs<br>
&gt; &gt; &gt; &gt; iptable_filter<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; ipt_REDIRECT iptable_nat nf_na=
t nf_conntrack_ipv4<br>
&gt; &gt; nf_conntrack<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; nf_defrag_ipv4 ip_tables ip_vs=
 ipv6 libcrc32c iTCO_wdt<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; iTCO_vendor_support ses enclos=
ure igb i2c_algo_bit sb_edac<br>
&gt; &gt; &gt; &gt; edac_core<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; i2c_i801 i2c_core sg shpchp lp=
c_ich mfd_core ixgbe dca ptp<br>
&gt; &gt; &gt; &gt; pps_core<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; mdio power_meter acpi_ipmi ipm=
i_si ipmi_msghandler ext4 jbd2<br>
&gt; &gt; &gt; &gt; mbcache<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; sd_mod crc_t10dif mpt3sas scsi=
_transport_sas raid_class<br>
&gt; &gt; xhci_hcd<br>
&gt; &gt; &gt; &gt; ahci<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; wmi dm_mirror dm_region_hash d=
m_log dm_mod [last unloaded:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; scsi_wait_scan]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Pid: 4454, comm: swif=
t-object-se Not tainted<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2.6.32-504.23.4.el6.x86_64 #1 =
Silicon Mechanics Storform<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; R518.v5P/X10DRi-T4+<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RIP: 0010:[&lt;ffffff=
ffa0362d60&gt;]=C2=A0 [&lt;ffffffffa0362d60&gt;]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; xfs_dir2_sf_getdents+0x2a0/0x3=
a0 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RSP: 0018:ffff880871f=
6de18=C2=A0 EFLAGS: 00010202<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RAX: 0000000000000000=
 RBX: 0000000000000004 RCX:<br>
&gt; &gt; &gt; &gt; 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RDX: 0000000000000001=
 RSI: 0000000000000000 RDI:<br>
&gt; &gt; &gt; &gt; 00007faa74006203<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RBP: ffff880871f6de68=
 R08: 000000032eb04bc9 R09:<br>
&gt; &gt; &gt; &gt; 0000000000000004<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;R10: 0000000000008030=
 R11: 0000000000000246 R12:<br>
&gt; &gt; &gt; &gt; 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;R13: 0000000000000002=
 R14: ffff88106eff7000 R15:<br>
&gt; &gt; &gt; &gt; ffff8808715b4580<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;FS:=C2=A0 00007faa854=
25700(0000) GS:ffff880028360000(0000)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; knlGS:0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CS:=C2=A0 0010 DS: 00=
00 ES: 0000 CR0: 0000000080050033<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001=
 CR3: 0000001072325000 CR4:<br>
&gt; &gt; &gt; &gt; 00000000001407e0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;DR0: 0000000000000000=
 DR1: 0000000000000000 DR2:<br>
&gt; &gt; &gt; &gt; 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7:<br>
&gt; &gt; &gt; &gt; 0000000000000400<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Process swift-object-=
se (pid: 4454, threadinfo<br>
&gt; &gt; &gt; &gt; ffff880871f6c000,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; task ffff880860f18ab0)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Stack:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; ffff880871f6de28 fff=
fffff811a4bb0 ffff880871f6df38<br>
&gt; &gt; &gt; &gt; &gt; &gt; ffff880874749cc0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 00000001000=
00103 ffff8802381f8c00 ffff880871f6df38<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; ffff8808715b4580<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 00000000000=
00082 ffff8802381f8d88 ffff880871f6dec8<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; ffffffffa035ab31<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Call Trace:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb=
0&gt;] ? filldir+0x0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa035ab3=
1&gt;] xfs_readdir+0xe1/0x130 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb=
0&gt;] ? filldir+0x0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa038fe2=
9&gt;] xfs_file_readdir+0x39/0x50 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4e3=
0&gt;] vfs_readdir+0xc0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8119bd8=
6&gt;] ? final_putname+0x26/0x50<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4fb=
9&gt;] sys_getdents+0x89/0xf0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8100b0f=
2&gt;] system_call_fastpath+0x16/0x1b<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Code: 01 00 00 00 48 =
c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55<br>
&gt; &gt; b8<br>
&gt; &gt; &gt; &gt; 85 c0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 0f 85 af 00 00 00 49 8b 37 e9 =
ec fd ff ff 66 0f 1f 84 00 00<br>
&gt; &gt; 00<br>
&gt; &gt; &gt; &gt; 00 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;41&gt; 80 7c 24 01 00 0f 8=
4 9c 00 00 00 45 0f b6 44 24 03 41<br>
&gt; &gt; 0f b6<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;1&gt;RIP=C2=A0 [&lt;ffffff=
ffa0362d60&gt;] xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt; &gt; &gt; &gt; [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; RSP &lt;ffff880871f6=
de18&gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001=
<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; ...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I=E2=80=99ve got the vmcore du=
mp from operator. Does vmcore help for<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; troubleshooting kind issue ?<b=
r>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Hmm, well it couldn&#39;t hurt. Is =
the vmcore based on this 6.6<br>
&gt; &gt; &gt; &gt; kernel? Can<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; you provide the exact kernel versio=
n and post the vmcore<br>
&gt; &gt; somewhere?<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Brian<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2015-06-18 22:59 GMT+08:00 Eri=
c Sandeen &lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a=
><br>
&gt; &gt; &gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; On 6/18/15 9:29 AM, Kuo H=
ugo wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;- Have you tried =
an &#39;xfs_repair -n&#39; of the affected<br>
&gt; &gt; &gt; &gt; filesystem?<br>
&gt; &gt; &gt; &gt; &gt; &gt; Note<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; that -n will report probl=
ems only and prevent any<br>
&gt; &gt; modification<br>
&gt; &gt; &gt; &gt; by<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; repair.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; *We might to to xfs_=
repair if we can address which disk<br>
&gt; &gt; &gt; &gt; causes<br>
&gt; &gt; &gt; &gt; &gt; &gt; the<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; issue. *<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; If you do, please save th=
e output, and if it finds<br>
&gt; &gt; anything,<br>
&gt; &gt; &gt; &gt; please<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; provide the output in thi=
s thread.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Eric<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; ______________________________=
_________________<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.=
com">xfs@oss.sgi.com</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"http://oss.sgi.com/=
mailman/listinfo/xfs" rel=3D"noreferrer" target=3D"_blank">http://oss.sgi.c=
om/mailman/listinfo/xfs</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt; _______________________________________________<br>
&gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; &gt; &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"n=
oreferrer" target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br=
>
&gt; &gt;<br>
&gt; &gt;<br>
</div></div></blockquote></div><br></div>

--047d7bacbd88ff1506051ac5a135--


--===============8611441357489344061==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8611441357489344061==--
