Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6F2wvNV164051 for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 21:58:57 -0500
Received: from rlogin.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35255363E2B
	for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 19:59:33 -0700 (PDT)
Received: from rlogin.dk (rlogin.dk [81.161.188.225]) by cuda.sgi.com with
	ESMTP id bchE5XTC3AEtLuAM for <xfs@oss.sgi.com>;
	Tue, 14 Jul 2009 19:59:33 -0700 (PDT)
Date: Wed, 15 Jul 2009 05:00:47 +0200
From: Michael Ole Olsen <gnu@gmx.net>
Subject: xfs+nfs crash in 2.6.30 and 2.6.30.1
Message-ID: <20090715030046.GA28592@rlogin.dk>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7285400528728656752=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>


--===============7285400528728656752==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

            radix_tree_tag_set/xfs_inode_set_reclaim_tag crash

I keep getting kernel crashes with xfs+lvm2+mdadm (raid6) - correct in sync=
,=20
all xfs partitions checked for corruption (but there were none, but the cra=
shes persists).

The raid6 has just resynced now because of this kernel hang.

2.6.30 and 2.6.30.1 kernels on my nfsv3 server keep crashing, both with/wit=
hout SMP, dynticks,
 selinux (although selinux for some reason seems to make it crash very ofte=
n)

The machine has been memtested (memtest86+) for 14hours straight, never any=
 stability issues.

I have around 1-3 complete kernel lockups a day with this nfs kernel server=
 and xfs.

Tried nfs both as module and direct in kernel - both hangs the kernel
 completely (can't even use magic sysrq) when the client uses lots of small=
 files/lots of IO.

The remote export of samba is rock stable, nfs keeps crashing with small fi=
les,=20
without nfs there seems to be no crashes.

The /srv/diskless dir is a 80GB dir with lots of small files (kernels etc)

I also get a=20
    "svc: failed to register lockdv1 RPC service (errno 97)."
in dmesg havn't seen that before in kernels below 2.6.30

Also lots of
    [xxxxx.yyyyy] reconnect_path: npd !=3D pd (see ***)

And stale NFS handles on clients sometimes.

Everything was stable on server+client until the server got 2.6.30 kernel,=
=20
the mdadm raid6 only works in 2.6.30 or above - mdadm fails to initialize i=
t in=20
anything else, so cannot downgrade (custom reshape to raid6 using echo into=
 /sys,
 all Q blocks on one disk).

I have experimented with mount options on the client, and the client has=20
been stable with these mount options before, when the server had a kernel
 below 2.6.30

Ways to reproduce:

o 2.6.30 or 2.6.31 kernel on nfs server

o xfs exports on server with /etc/exports and /etc/fstab on client as paste=
d below

o nfs-kernel-server either as module loaded or in kernel.

o Async on the client seems to make it more reproducible

o dd if=3D/nfs/largefile of=3D/dev/null bs=3D4k on the client can trigger=
=20
    a kernel oops on the server in a few tries

o copying over a large folder with lots of files on the client=20
    import from server will trigger it.

o selinux? seems to make it more unstable - i got instant kernel crash with=
=20
    selinux options on kernel when the nfsd started - now removed but probl=
em is still there.


I saw someone talking about kernel stack size would be the cause for this x=
fs+nfs problem,=20
is there anything to this?

Here is the most common crash trace:
http://rlogin.dk/IMG_7155.JPG    [1]

A bugreport has already been filed, but no known solution:
http://bugzilla.kernel.org/show_bug.cgi?id=3D13375
http://www.google.com/search?hl=3Dda&q=3Dxfs+radix (lots of results but no =
known solution)

The below trace (at the bottom of this mail is not as common as the one in =
the link [1])

SERVER INFO

root@mfs:~# rpcinfo -p
   program vers proto   port
    100000    2   tcp    111  portmapper
    100000    2   udp    111  portmapper
    100024    1   udp  58792  status
    100024    1   tcp  43201  status
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100021    1   udp  51962  nlockmgr
    100021    3   udp  51962  nlockmgr
    100021    4   udp  51962  nlockmgr
    100021    1   tcp  57205  nlockmgr
    100021    3   tcp  57205  nlockmgr
    100021    4   tcp  57205  nlockmgr
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100005    1   udp  44137  mountd
    100005    1   tcp  46627  mountd
    100005    2   udp  44137  mountd
    100005    2   tcp  46627  mountd
    100005    3   udp  44137  mountd
    100005    3   tcp  46627  mountd

Module                  Size  Used by
xts                     2612  4=20
gf128mul                7020  1 xts
nfsd                  208736  9=20
lockd                  56984  1 nfsd
nfs_acl                 2384  1 nfsd
auth_rpcgss            31180  1 nfsd
sunrpc                150648  10 nfsd,lockd,nfs_acl,auth_rpcgss
uhci_hcd               17252  0=20
tun                    11040  0=20
sg                     22332  0=20
usb_storage            45104  1=20
e1000                 101476  0=20
forcedeth              46244  0=20
pata_amd                9100  0=20
ata_generic             4184  0=20
sd_mod                 21592  12=20
ehci_hcd               26968  0=20
usbcore               104356  4 uhci_hcd,usb_storage,ehci_hcd
xfs                   417604  12=20
exportfs                3408  2 nfsd,xfs
linear                  4608  0=20

/bigdaddy           *.local(rw,async,insecure,no_subtree_check,no_root_squa=
sh)

/crypt/scan         *.local(rw,async,insecure,no_subtree_check,no_root_squa=
sh)
/crypt/backup       *.local(rw,async,insecure,no_subtree_check,no_root_squa=
sh)
/crypt/pictures     *.local(rw,async,insecure,no_subtree_check,no_root_squa=
sh)

/crypt/private/music    mws*.local(rw,async,insecure,no_subtree_check,no_ro=
ot_squash)
/crypt/private          mws*.local(rw,async,insecure,no_subtree_check,no_ro=
ot_squash)

/bigdaddy/Music     *.local(ro,async,insecure,no_subtree_check,no_root_squa=
sh)
/torrents           *.local(rw,async,insecure,no_subtree_check,no_root_squa=
sh)


/srv/diskless/mws              *.local(rw,async,insecure,no_subtree_check,n=
o_root_squash)
/srv/diskless/mfs              *.local(rw,async,insecure,no_subtree_check,n=
o_root_squash)
/srv/diskless/generic          *.local(rw,async,insecure,no_subtree_check,n=
o_root_squash)

/srv/diskless/tftp/kernels/src              *.local(rw,async,insecure,no_su=
btree_check,no_root_squash)

DISKLESS CLIENT
michael@mws:~% cat /etc/fstab=20
cpq:/diskless/mws                       /               nfs             pro=
to=3Dudp                               0   0
none                                    /proc           proc            def=
aults                                0   0
tmpfs                                   /tmp            tmpfs           rw,=
size=3D1G                              0   0
mfs:/srv/diskless/tftp/kernels/src      /usr/src        nfs             noa=
uto,defaults                         0   0
mfs:/srv/michael/.private/latex         /latex          nfs             pro=
to=3Dudp                               0   0
mfs:/crypt/private/music                /nfs/music      nfs             pro=
to=3Dudp                               0   0
mfs:/crypt/private                      /nfs/private    nfs             pro=
to=3Dudp                               0   0

mfs:/bigdaddy                           /nfs/bigdaddy   nfs             rw,=
user,exec,proto=3Dudp                  0   0
mfs:/torrents                           /nfs/torrents   nfs             rw,=
user,exec,proto=3Dudp                  0   0
mfs:/crypt/pictures                     /nfs/pictures   nfs             rw,=
user,exec,proto=3Dudp                  0   0
mfs:/crypt/scan                         /nfs/scan       nfs             rw,=
user,exec,rsize=3D4096,wsize=3D4096      0   0
mfs:/crypt/backup                       /nfs/backup     nfs             rw,=
user,exec,proto=3Dudp                  0   0

/usr/src/diskless_mws                   /usr/src/linux  bind            noa=
uto,defaults,bind                    0   0
/dev/ipod                               /ipod           vfat            def=
aults,user,noauto,umask=3D000          0   0

michael@mws:~% uname -r
2.6.22.1mws_diskless

SERVER DMESG (i also have a lot of radix_tree hangs but i dont have a=20
trace for them except the [1] picture, they didn't get logged,
 but they seem more common - they crash the kernel completely):

***:
this is not the newest dump, but it is one of the dumps that I have of it:
normally there is also a svc: failed to register lockdv1 RPC service (errno=
 97). in dmesg
and a lot of=20
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
[xxxxx.yyyyy] reconnect_path: npd !=3D pd
(easily 100 of those in dmesg on the server when the client uses lots of fi=
les or bandwidth)

the kernel oops always comes after these messages, not before and is always=
 a=20
reclaim inode bug or xfs radix tree bug (i think the bug happens when the c=
lient tries to -delete- files).
an aMule client or rtorrent on the client will trigger the oops easily - or=
 just deleting a large folder=20
or mv'ing one on the client.

[  117.895574] BUG: unable to handle kernel NULL pointer dereference at 000=
00004
[  117.895749] IP: [<c113d95c>] inode_has_perm+0x1e/0x62
[  117.895883] *pde =3D 00000000
[  117.896011] Oops: 0000 [#4] SMP
[  117.896167] last sysfs file: /sys/kernel/uevent_seqnum
[  117.896269] Modules linked in: uhci_hcd usb_storage sg sr_mod ehci_hcd c=
drom forcedeth ohci_hcd usbcore raid10 raid0 pata_amd ata_generic aic7xxx s=
csi_transport_spi sd_mod
[  117.897007]
[  117.897097] Pid: 3799, comm: nfsd Tainted: G      D    (2.6.30 #14) Syst=
em Product Name
[  117.897254] EIP: 0060:[<c113d95c>] EFLAGS: 00010246 CPU: 0
[  117.897351] EIP is at inode_has_perm+0x1e/0x62
[  117.897445] EAX: 00000000 EBX: 00000000 ECX: 00000002 EDX: f2ba0424
[  117.897543] ESI: f1b90380 EDI: f194ce80 EBP: f194ce80 ESP: f5719e2c
[  117.897640]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  117.897737] Process nfsd (pid: 3799, ti=3Df5718000 task=3Df687e080 task.=
ti=3Df5718000)
[  117.897891] Stack:
[  117.897980]  00000002 f1aec0c0 f5bd6000 46000000 f5690000 f5690010 c10ca=
3a8 00000020
[  117.898284]  00000018 f1be5a80 f269a36c f5690010 c106d73d f269a300 f194c=
eec 00000002
[  117.898708]  f1b90380 f2ba0424 f194ce80 c1140568 00000000 f1b90380 f2b7b=
660 f2ba0424
[  117.899191] Call Trace:
[  117.899191]  [<c10ca3a8>] ? nfsd_setuser_and_check_port+0x53/0x58
[  117.899191]  [<c106d73d>] ? kmemdup+0x16/0x30
[  117.899191]  [<c1140568>] ? selinux_dentry_open+0xd6/0xdc
[  117.899191]  [<c113a820>] ? security_dentry_open+0xc/0xd
[  117.899191]  [<c1082c9e>] ? __dentry_open+0xfb/0x208
[  117.899191]  [<c1082e0c>] ? dentry_open+0x61/0x68
[  117.899191]  [<c10cbf9b>] ? nfsd_open+0x16b/0x1a0
[  117.899191]  [<c10cc309>] ? nfsd_read+0x64/0x9f
[  117.899191]  [<c10c9b5d>] ? nfsd_proc_read+0x109/0x13d
[  117.899191]  [<c134013c>] ? cache_check+0x52/0x414
[  117.899191]  [<c102d385>] ? groups_alloc+0x2a/0x94
[  117.899191]  [<c10d0685>] ? nfssvc_decode_readargs+0x8a/0xde
[  117.899191]  [<c10c7e1e>] ? nfsd_dispatch+0xca/0x196
[  117.899191]  [<c1339a3b>] ? svc_process+0x379/0x656
[  117.899191]  [<c10c8299>] ? nfsd+0xde/0x11a
[  117.899191]  [<c10c81bb>] ? nfsd+0x0/0x11a
[  117.899191]  [<c10317c8>] ? kthread+0x42/0x67
[  117.899191]  [<c1031786>] ? kthread+0x0/0x67
[  117.899191]  [<c100320f>] ? kernel_thread_helper+0x7/0x10
[  117.899191] Code: a0 ef ff ff 5b 5e eb 02 31 c0 5b 5e c3 55 57 56 53 83 =
ec 3c 89 c7 89 0c 24 8b 5c 24 50 31 c0 f6 82 4d 01 00 00 02 75 3f 8b 47 58 =
<8b> 68 04 8b b2 54 01 00 00 85 db 75 1a b9 0e 00 00 00 8d 7c 24
[  117.899191] EIP: [<c113d95c>] inode_has_perm+0x1e/0x62 SS:ESP 0068:f5719=
e2c
[  117.899191] CR2: 0000000000000004
[  117.904295] ---[ end trace df59a076396b4ee6 ]---
[  251.771477] BUG: unable to handle kernel NULL pointer dereference at 000=
00004
[  251.771640] IP: [<c113d95c>] inode_has_perm+0x1e/0x62
[  251.771771] *pde =3D 00000000
[  251.771892] Oops: 0000 [#5] SMP
[  251.772041] last sysfs file: /sys/kernel/uevent_seqnum
[  251.772137] Modules linked in: uhci_hcd usb_storage sg sr_mod ehci_hcd c=
drom forcedeth ohci_hcd usbcore raid10 raid0 pata_amd ata_generic aic7xxx s=
csi_transport_spi sd_mod
[  251.772876]
[  251.772974] Pid: 3798, comm: nfsd Tainted: G      D    (2.6.30 #14) Syst=
em Product Name
[  251.772974] EIP: 0060:[<c113d95c>] EFLAGS: 00010246 CPU: 0
[  251.772974] EIP is at inode_has_perm+0x1e/0x62
[  251.772974] EAX: 00000000 EBX: 00000000 ECX: 00000002 EDX: f45bf324
[  251.772974] ESI: f53f2700 EDI: f3d5e400 EBP: f3d5e400 ESP: f569be2c
[  251.772974]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  251.772974] Process nfsd (pid: 3798, ti=3Df569a000 task=3Df71ab4d0 task.=
ti=3Df569a000)
[  251.772974] Stack:
[  251.772974]  00000002 f27d2e40 f5bd5000 46000000 f5587a00 f5587a10 c10ca=
3a8 00000020
[  251.772974]  00000018 f1bdddc0 f53f2eec f5587a10 c106d73d f53f2e80 f3d5e=
46c 00000002
[  251.772974]  f53f2700 f45bf324 f3d5e400 c1140568 00000000 f53f2700 f45d8=
110 f45bf324
[  251.772974] Call Trace:
[  251.772974]  [<c10ca3a8>] ? nfsd_setuser_and_check_port+0x53/0x58
[  251.772974]  [<c106d73d>] ? kmemdup+0x16/0x30
[  251.772974]  [<c1140568>] ? selinux_dentry_open+0xd6/0xdc
[  251.772974]  [<c113a820>] ? security_dentry_open+0xc/0xd
[  251.772974]  [<c1082c9e>] ? __dentry_open+0xfb/0x208
[  251.772974]  [<c1082e0c>] ? dentry_open+0x61/0x68
[  251.772974]  [<c10cbf9b>] ? nfsd_open+0x16b/0x1a0
[  251.772974]  [<c10cc309>] ? nfsd_read+0x64/0x9f
[  251.772974]  [<c10c9b5d>] ? nfsd_proc_read+0x109/0x13d
[  251.772974]  [<c134013c>] ? cache_check+0x52/0x414
[  251.772974]  [<c102d385>] ? groups_alloc+0x2a/0x94
[  251.772974]  [<c10d0685>] ? nfssvc_decode_readargs+0x8a/0xde
[  251.772974]  [<c10c7e1e>] ? nfsd_dispatch+0xca/0x196
[  251.772974]  [<c1339a3b>] ? svc_process+0x379/0x656
[  251.772974]  [<c10c8299>] ? nfsd+0xde/0x11a
[  251.772974]  [<c10c81bb>] ? nfsd+0x0/0x11a
[  251.772974]  [<c10317c8>] ? kthread+0x42/0x67
[  251.772974]  [<c1031786>] ? kthread+0x0/0x67
[  251.772974]  [<c100320f>] ? kernel_thread_helper+0x7/0x10
[  251.772974] Code: a0 ef ff ff 5b 5e eb 02 31 c0 5b 5e c3 55 57 56 53 83 =
ec 3c 89 c7 89 0c 24 8b 5c 24 50 31 c0 f6 82 4d 01 00 00 02 75 3f 8b 47 58 =
<8b> 68 04 8b b2 54 01 00 00 85 db 75 1a b9 0e 00 00 00 8d 7c 24
[  251.772974] EIP: [<c113d95c>] inode_has_perm+0x1e/0x62 SS:ESP 0068:f569b=
e2c
[  251.772974] CR2: 0000000000000004
[  251.780353] ---[ end trace df59a076396b4ee7 ]---


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKXUZbAAoJECXlragqp/ZIQ5kP/jfB9meM6sHhjjTUQJO79mda
gtRMZBzwhUt6fDLdbzQkhia0thFp+1WRQJfZarv9gazea3OKAzuB6+67gpBviuJj
2wgxUSBWLSI9L0YYlb5BR9pPsiviiG0/7+/b196PDKi2vLr18LYuOkq8QUWGM8Cy
HLrND7z1i8ebUp6zyJYu+nUyYy2gPt6HUr7JHDhxkQUmyaTrwm4+elwa/+vx5Rd+
6s7TZd/9MaNaB3SjkoQj4CGhZdRMYpN7jxPxA3SxR8HdNIgEfzC43s4tioLFUr7g
om7LL+nYvEAAMjw1yM8vMmG6Obc/Fsrx00Sm1BZwmWzuAz5paOft9jlwKgB7Whs/
+50Pn5yKLiqHByEga7tomIuhh+hAX/g5kjV5MaL0U/C28L28sk6+9kEp5XEeL6ju
uGx0oecD49mC5CCtS+G0TPfYJHdG8qK11QyE5Tx9Pv7qn0WuhfJqAwxE/0L4RQUr
kHaurxtwzvyuSbumbsq/7smBTI9LkyacT2xsp/P98xb4E+He+CVoELJUFLG6R9Ks
rRxSj8X2uLT2cJ/ypaWyZXJ1c4/2oC/tH80l7vy7e/llg6HUE+QCibftbkYYYUnN
EShGHAjyFZF+ihLGNid67xFxwRDCn45/fMNzjp9vWa3Yz+6OMha1qNxcu0ipT452
iAwcmEMeArZhPERQCVTs
=/wH9
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--


--===============7285400528728656752==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7285400528728656752==--
