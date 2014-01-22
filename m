Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84FE87F89
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 10:09:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D8928F8068
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 08:09:18 -0800 (PST)
Received: from zmail.inovex.de (zmail.inovex.de [85.115.6.137]) by
	cuda.sgi.com with ESMTP id 04GiVOfvhvF81wBf for
	<xfs@oss.sgi.com>; Wed, 22 Jan 2014 08:09:13 -0800 (PST)
Received: from zmail.inovex.de (localhost [127.0.0.1])
	by zmail.inovex.de (Postfix) with ESMTP id B8A473FCD1
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 17:11:01 +0100 (CET)
Received: from [172.20.10.3] (ip-109-43-2-68.web.vodafone.de [109.43.2.68])
	by zmail.inovex.de (Postfix) with ESMTPSA id 617643FB7B
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 17:11:01 +0100 (CET)
From: Sascha Askani <saskani@inovex.de>
Subject: Weird XFS Corruption Error
Message-Id: <CDBC891F-BCF6-4B9B-ADDB-9E143973D188@inovex.de>
Date: Wed, 22 Jan 2014 17:09:10 +0100
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5808305922679062284=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5808305922679062284==
Content-Type: multipart/signed; boundary="Apple-Mail=_8CB756A4-246D-460D-8D78-C4EA53A40F2E"; protocol="application/pgp-signature"; micalg=pgp-sha512


--Apple-Mail=_8CB756A4-246D-460D-8D78-C4EA53A40F2E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hi everybody,

We experienced a weird XFS corruption yesterday and I desperately trying =
to find out what was happening.
First, the setup:

* ProLiant DL380p Gen8
* 256GB RAM
* HP SmartArray P420i Controller
** 1 GB BBWC
** Firmware Version 4.68
** 20x MK0100GCTYU 100GB SSD Drives
** Raid 1+0
* LVM
* Ubuntu 12.10 LTS
* Kernel 3.11.0-15-generic #23~precise1-Ubuntu

fstab Entry:=20
/dev/vg00/opt_mysqlbackup   /opt/mysqlbackup            xfs     =
nobarrier,noatime,nodiratime,logbufs=3D8,logbsize=3D256k       0 2

We created a 120GB LV mounted on /opt/mysqlbackup with which (obviously) =
temporarily hosts our MariaDB Backups until they are transferred to =
tape. We use mylvmbackup (http://www.lenzg.net/mylvmbackup/) to create a =
(approx. 55GB) tar.gz file containing the dump. While testing, I created =
a hardlink for 2 Files in a subdir (=84safe=93) and forgot them for a =
day while the =84original=93 file was deleted and replaced by next day=92s=
 backup.

When I tried cleaning up the no longer needed files, I encountered the =
following:

---------------------------------------------------------
me@hsoi-gts3-de02:/opt/mysqlbackup$ sudo rm -rf safe/
sudo rm -rf safe/
[sudo] password for saskani:
rm: cannot remove `safe/daily_snapshot.tar.gz.md5': Input/output error
---------------------------------------------------------

dmesg told me:
---------------------------------------------------------
[964199.138848] XFS (dm-8): Internal error xfs_bmbt_read_verify at line =
789 of file =
/build/buildd/linux-lts-saucy-3.11.0/fs/xfs/xfs_bmap_btree.c.  Caller =
0xffffffffa0164495
[964199.138848]
[964199.138850] CPU: 1 PID: 3694 Comm: kworker/1:1H Tainted: GF          =
  3.11.0-15-generic #23~precise1-Ubuntu
[964199.138851] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 =
09/18/2013
[964199.138874] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[964199.138876]  0000000000000001 ffff881c6be6fd18 ffffffff8173bc0e =
0000000000004364
[964199.138878]  ffff883f9061c000 ffff881c6be6fd38 ffffffffa016629f =
ffffffffa0164495
[964199.138879]  0000000000000001 ffff881c6be6fd78 ffffffffa016630e =
ffff881c6be6fda8
[964199.138880] Call Trace:
[964199.138886]  [<ffffffff8173bc0e>] dump_stack+0x46/0x58
[964199.138906]  [<ffffffffa016629f>] xfs_error_report+0x3f/0x50 [xfs]
[964199.138913]  [<ffffffffa0164495>] ? xfs_buf_iodone_work+0x95/0xc0 =
[xfs]
[964199.138921]  [<ffffffffa016630e>] xfs_corruption_error+0x5e/0x90 =
[xfs]
[964199.138928]  [<ffffffffa0164495>] ? xfs_buf_iodone_work+0x95/0xc0 =
[xfs]
[964199.138939]  [<ffffffffa01944d6>] xfs_bmbt_read_verify+0x76/0xf0 =
[xfs]
[964199.138946]  [<ffffffffa0164495>] ? xfs_buf_iodone_work+0x95/0xc0 =
[xfs]
[964199.138949]  [<ffffffff81095bb2>] ? finish_task_switch+0x52/0xf0
[964199.138969]  [<ffffffffa0164495>] xfs_buf_iodone_work+0x95/0xc0 =
[xfs]
[964199.138972]  [<ffffffff81081060>] process_one_work+0x170/0x4a0
[964199.138973]  [<ffffffff81082121>] worker_thread+0x121/0x390
[964199.138975]  [<ffffffff81082000>] ? =
manage_workers.isra.21+0x170/0x170
[964199.138977]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
[964199.138979]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
[964199.138981]  [<ffffffff817508ac>] ret_from_fork+0x7c/0xb0
[964199.138983]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
[964199.138984] XFS (dm-8): Corruption detected. Unmount and run =
xfs_repair
[964199.139014] XFS (dm-8): metadata I/O error: block 0x1f0 =
("xfs_trans_read_buf_map") error 117 numblks 8
[964199.139016] XFS (dm-8): xfs_do_force_shutdown(0x1) called from line =
367 of file /build/buildd/linux-lts-saucy-3.11.0/fs/xfs/xfs_trans_buf.c. =
 Return address =3D 0xffffffffa01cadbc
[964199.139324] XFS (dm-8): I/O Error Detected. Shutting down filesystem
[964199.139325] XFS (dm-8): Please umount the filesystem and rectify the =
problem(s)
[964212.367300] XFS (dm-8): xfs_log_force: error 5 returned.
[964242.477283] XFS (dm-8): xfs_log_force: error 5 returned.
---------------------------------------------------------

After that, I tried the following (in order):

1. xfs_repair, which did not find the superblock and started scanning =
the LV, after finding the secondary superblock, it told me there=92s =
still something in the log, so I
2. mounted the filesystem, which gave me a =84Structure needs cleaning=93 =
after a couple of seconds
3. tried mounting again for good measure, same error =84Structure needs =
cleaning=93
4. xfs_repair -L which repaired everything, and effectively cleaned my =
Filesystem in the process.
5. mount the filesystem to find it empty.



Since then, I=92m desperately trying to reproduce the problem, but =
unfortunately to no avail. Can somebody give some insight on the errors =
I encountered. I have previously operated 4,5PB worth of XFS Filesystems =
for 3 years and never got an error similar to this.

Best regards
Sascha

--Apple-Mail=_8CB756A4-246D-460D-8D78-C4EA53A40F2E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQGcBAEBCgAGBQJS3+0mAAoJEPgp1oARaIvki5gL/0ymAjRO9Qj5S+ErILiQ2JlI
+XWzc9eKchd/rcDxHQpTG2TWR9MO2v8LBOSW0AD2XGiHh2MpfaZDSNydBieexBPB
pimeM9/9QydpTU0TUCIlMMRDlldr/GG0Pwy7gD21ErunuRyZKnwPH9Ww3EcJ2lOU
Uesapfqzgvgo19TtHWK3T1uZ15IITTT1Pl4wZ/jlJQJ8D75FvqpG6exnVSqksezS
ngX0Y4byh8gOUrrbNcYiFT64/SZPuOyfXO4qstnRrWwchle7zAnN33puOCB/tKqE
xUy6sMX3Nu/pRCtjPYFwuBIKxvFnZcnbsu37pW3FXCqXgJH36hx6sUir04uCKiQK
KrqgOvq9xLt2bNGq5MJDRqxSMRXqbXrzDx1JgrBqtL33YIJWiRDfUL2M1cFpGnS0
kMWp0FgWkpR1CjcGbjaXPhw1SUagWyOPxRn/X1ZGVJP99QCfSjfOVJN7vJ4GFOa4
jfPQN7g6KndaHQ88lQaandVMiu0/2YxJEKTjFbxt+w==
=gpH/
-----END PGP SIGNATURE-----

--Apple-Mail=_8CB756A4-246D-460D-8D78-C4EA53A40F2E--


--===============5808305922679062284==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5808305922679062284==--
