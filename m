Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 020097F50
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 08:45:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD1C6304043
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 06:45:49 -0700 (PDT)
Received: from mail-ie0-f174.google.com (mail-ie0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	LT53w8bOR3CUTl3T (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 06:45:47 -0700 (PDT)
Received: by mail-ie0-f174.google.com with SMTP id 10so992053ied.5
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 06:45:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuKdUJ6U5_tVNGStZRyALp94n=M7x7C_CVqAfAbEwsuBFw@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
	<516798AE.9050908@sandeen.net>
	<CADFMGuK67G85+J3LAjS=w_nkkSrj7At9HnPLSL-DBO6g0V=ThA@mail.gmail.com>
	<CADFMGuLNmSpA+e2Wo0qS5y2evQM=q_oVJJPf6kZkfAP4jfk=6w@mail.gmail.com>
	<CADFMGuJoar_uKB_Lrq0nKFsbdjyZWFaHXU-ni2ky3sToSQwUSQ@mail.gmail.com>
	<516800F7.80502@redhat.com>
	<CADFMGuKH_jYhuxzMQ_4mj_Zv4EgPfpuBYR=fpqBfJPWf=POJPQ@mail.gmail.com>
	<CADFMGuJmNLTcyb4aQmbto--dgFBgP55QWeaP+grAoPL+q8eRCg@mail.gmail.com>
	<CADFMGuKsDHFt_XOvjHKR=s6c7LsJYw=Jr5DXvTyswrXQT2g7yA@mail.gmail.com>
	<CADFMGuJMjKc1QoS-Ewt6wG2uSWjyWfQevQg7ZVMer0XSpx3Vjg@mail.gmail.com>
	<CADFMGuJDhq810CRE1TMJga6LN25i+Xm9EeGEhO_wTZrbXe8EFg@mail.gmail.com>
	<CADFMGuKdUJ6U5_tVNGStZRyALp94n=M7x7C_CVqAfAbEwsuBFw@mail.gmail.com>
Date: Mon, 15 Apr 2013 21:45:46 +0800
Message-ID: <CADFMGuJ5vngJZDKUPn0=i32-Y_8fpJC+DRzutZ7+D9NSrfCy=Q@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0692741384169525566=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0692741384169525566==
Content-Type: multipart/alternative; boundary=14dae9340ee74eaced04da6678b7

--14dae9340ee74eaced04da6678b7
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

And at the same time we got the following error log of glusterfs:
[2013-04-15 20:43:03.851163] I [dht-rebalance.c:1611:gf_defrag_status_get]
0-glusterfs: Rebalance is completed
[2013-04-15 20:43:03.851248] I [dht-rebalance.c:1614:gf_defrag_status_get]
0-glusterfs: Files migrated: 1629, size: 1582329065954, lookups: 11036,
failures: 561
[2013-04-15 20:43:03.887634] W [glusterfsd.c:831:cleanup_and_exit]
(-->/lib64/libc.so.6(clone+0x6d) [0x3bd16e767d]
(-->/lib64/libpthread.so.0() [0x3bd1a07851]
(-->/usr/sbin/glusterfs(glusterfs_sigwaiter+0xdd) [0x405c9d]))) 0-:
received signum (15), shutting down
[2013-04-15 20:43:03.887878] E
[rpcsvc.c:1155:rpcsvc_program_unregister_portmap] 0-rpc-service: Could not
unregister with portmap


2013/4/15 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> More info about it is: It happened exactly when glusterfs rebalance
> complete.
>
>
> 2013/4/15 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>
>> and xfs kernel trace is:
>> Apr 15 20:43:03 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
>> returned error 22.
>> Apr 15 20:43:03 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
>> error 22
>> Apr 15 20:43:03 10 kernel: Pid: 3093, comm: glusterfsd Not tainted
>> 2.6.32-279.el6.x86_64 #1
>> Apr 15 20:43:03 10 kernel: Call Trace:
>> Apr 15 20:43:03 10 kernel: [<ffffffffa02d4212>] ?
>> xfs_inactive+0x442/0x460 [xfs]
>> Apr 15 20:43:03 10 kernel: [<ffffffffa02e1790>] ?
>> xfs_fs_clear_inode+0xa0/0xd0 [xfs]
>> Apr 15 20:43:03 10 kernel: [<ffffffff81195adc>] ? clear_inode+0xac/0x140
>> Apr 15 20:43:03 10 kernel: [<ffffffff81196296>] ?
>> generic_delete_inode+0x196/0x1d0
>> Apr 15 20:43:03 10 kernel: [<ffffffff81196335>] ?
>> generic_drop_inode+0x65/0x80
>> Apr 15 20:43:03 10 kernel: [<ffffffff81195182>] ? iput+0x62/0x70
>> Apr 15 20:43:03 10 kernel: [<ffffffff81191ce0>] ? dentry_iput+0x90/0x100
>> Apr 15 20:43:03 10 kernel: [<ffffffff81191e41>] ? d_kill+0x31/0x60
>> Apr 15 20:43:03 10 kernel: [<ffffffff8119386c>] ? dput+0x7c/0x150
>> Apr 15 20:43:03 10 kernel: [<ffffffff8117c9c9>] ? __fput+0x189/0x210
>> Apr 15 20:43:03 10 kernel: [<ffffffff8117ca75>] ? fput+0x25/0x30
>> Apr 15 20:43:03 10 kernel: [<ffffffff8117849d>] ? filp_close+0x5d/0x90
>> Apr 15 20:43:03 10 kernel: [<ffffffff81178575>] ? sys_close+0xa5/0x100
>> Apr 15 20:43:03 10 kernel: [<ffffffff8100b308>] ? tracesys+0xd9/0xde
>> Apr 15 20:43:03 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
>> from line 1186 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
>> 0xffffffffa02d422b
>> Apr 15 20:43:03 10 kernel: XFS (sdb): I/O Error Detected. Shutting down
>> filesystem
>> Apr 15 20:43:03 10 kernel: XFS (sdb): Please umount the filesystem and
>> rectify the problem(s)
>> Apr 15 20:43:13 10 kernel: XFS (sdb): xfs_log_force: error 5 returned.
>>
>>
>> 2013/4/15 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>
>>> Dear Brian and xfs experts,
>>> Brain your scripts works and I am able to reproduce it with glusterfs
>>> rebalance on our test cluster. 2 of our server xfs shutdown during
>>> glusterfs rebalance, the shutdown userspace stacktrace both related to
>>> pthread. See logs bellow, What's your opinion? Thank you very much!
>>> logs:
>>> [root@10.23.72.93 ~]# cat xfs.log
>>>
>>> --- xfs_imap -- module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:12=
57").return
>>> -- return=3D0x16
>>> vars: mp=3D0xffff882017a50800 tp=3D0xffff881c81797c70 ino=3D0xffffffff
>>> imap=3D0xffff88100e2f7c08 flags=3D0x0 agbno=3D? agino=3D? agno=3D? blks=
_per_cluster=3D?
>>> chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=3D? offset_agbno=3D?=
 __func__=3D[...]
>>> mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20
>>> mp->m_sb: sb_agcount =3D 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =
=3D 0x4,
>>> sb_agblklog =3D 0x1c, sb_dblocks =3D 0x1b4900000
>>> imap: im_blkno =3D 0x0, im_len =3D 0xa078, im_boffset =3D 0x86ea
>>> kernel backtrace:
>>> Returning from:  0xffffffffa02b3ab0 : xfs_imap+0x0/0x280 [xfs]
>>> Returning to  :  0xffffffffa02b9599 : xfs_inotobp+0x49/0xc0 [xfs]
>>>  0xffffffffa02b96f1 : xfs_iunlink_remove+0xe1/0x320 [xfs]
>>>  0xffffffff81501a69
>>>  0x0 (inexact)
>>> user backtrace:
>>>  0x3bd1a0e5ad [/lib64/libpthread-2.12.so+0xe5ad/0x219000]
>>>
>>> --- xfs_iunlink_remove -- module("xfs").function("xfs_iunlink_remove@fs=
/xfs/xfs_inode.c:1680").return
>>> -- return=3D0x16
>>> vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=
=3D? agi=3D?
>>> dip=3D? agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next_agin=
o=3D? last_ibp=3D?
>>> last_dip=3D0xffff882000000000 bucket_index=3D? offset=3D?
>>> last_offset=3D0xffffffffffff8810 error=3D? __func__=3D[...]
>>> ip: i_ino =3D 0x113, i_flags =3D 0x0
>>> ip->i_d: di_nlink =3D 0x0, di_gen =3D 0x0
>>> [root@10.23.72.93 ~]#
>>> [root@10.23.72.94 ~]# cat xfs.log
>>>
>>> --- xfs_imap -- module("xfs").function("xfs_imap@fs/xfs/xfs_ialloc.c:12=
57").return
>>> -- return=3D0x16
>>> vars: mp=3D0xffff881017c6c800 tp=3D0xffff8801037acea0 ino=3D0xffffffff
>>> imap=3D0xffff882017101c08 flags=3D0x0 agbno=3D? agino=3D? agno=3D? blks=
_per_cluster=3D?
>>> chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=3D? offset_agbno=3D?=
 __func__=3D[...]
>>> mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20
>>> mp->m_sb: sb_agcount =3D 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =
=3D 0x4,
>>> sb_agblklog =3D 0x1c, sb_dblocks =3D 0x1b4900000
>>> imap: im_blkno =3D 0x0, im_len =3D 0xd98, im_boffset =3D 0x547
>>> kernel backtrace:
>>> Returning from:  0xffffffffa02b3ab0 : xfs_imap+0x0/0x280 [xfs]
>>> Returning to  :  0xffffffffa02b9599 : xfs_inotobp+0x49/0xc0 [xfs]
>>>  0xffffffffa02b96f1 : xfs_iunlink_remove+0xe1/0x320 [xfs]
>>>  0xffffffff81501a69
>>>  0x0 (inexact)
>>> user backtrace:
>>>  0x30cd40e5ad [/lib64/libpthread-2.12.so+0xe5ad/0x219000]
>>>
>>> --- xfs_iunlink_remove -- module("xfs").function("xfs_iunlink_remove@fs=
/xfs/xfs_inode.c:1680").return
>>> -- return=3D0x16
>>> vars: tp=3D0xffff8801037acea0 ip=3D0xffff880e697c8800 next_ino=3D? mp=
=3D? agi=3D?
>>> dip=3D? agibp=3D0xffff880d846c2d60 ibp=3D? agno=3D? agino=3D? next_agin=
o=3D? last_ibp=3D?
>>> last_dip=3D0xffff881017c6c800 bucket_index=3D? offset=3D?
>>> last_offset=3D0xffffffffffff880e error=3D? __func__=3D[...]
>>> ip: i_ino =3D 0x142, i_flags =3D 0x0
>>> ip->i_d: di_nlink =3D 0x0, di_gen =3D 0x3565732e
>>>
>>>
>>>
>>> 2013/4/15 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>>
>>>> Also glusterfs use a lot of hardlink for self-heal:
>>>> --------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/998416323
>>>> ---------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/999296624
>>>> ---------T 2 root root 0 Apr 15 12:24 /mnt/xfsd/testbug/999568484
>>>> ---------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/999956875
>>>> ---------T 2 root root 0 Apr 15 11:58
>>>> /mnt/xfsd/testbug/.glusterfs/05/2f/052f4e3e-c379-4a3c-b995-a10fdaca33d=
0
>>>> ---------T 2 root root 0 Apr 15 11:58
>>>> /mnt/xfsd/testbug/.glusterfs/05/95/0595272e-ce2b-45d5-8693-d02c00b94d9=
d
>>>> ---------T 2 root root 0 Apr 15 11:58
>>>> /mnt/xfsd/testbug/.glusterfs/05/ca/05ca00a0-92a7-44cf-b6e3-380496aafaa=
4
>>>> ---------T 2 root root 0 Apr 15 12:24
>>>> /mnt/xfsd/testbug/.glusterfs/0a/23/0a238ca7-3cef-4540-9c98-6bf631551b2=
1
>>>> ---------T 2 root root 0 Apr 15 11:58
>>>> /mnt/xfsd/testbug/.glusterfs/0a/4b/0a4b640b-f675-4708-bb59-e2369ffbbb9=
d
>>>> Does it related?
>>>>
>>>>
>>>> 2013/4/15 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>>>
>>>>> Dear xfs experts,
>>>>> Now I'm deploying Brian's system script in out cluster. But from last
>>>>> night till now 5 servers in our 24 servers xfs shutdown with the same
>>>>> error. I run xfs_repair command and found all the lost inodes are glu=
sterfs
>>>>> dht link files. This explains why the xfs shutdown tend to happen dur=
ing
>>>>> glusterfs rebalance. During glusterfs rebalance procedure a lot of dh=
k link
>>>>> files may be unlinked. For example the following inodes are found in
>>>>> lost+found in one of the servers:
>>>>> [root@* lost+found]# pwd
>>>>> /mnt/xfsd/lost+found
>>>>> [root@* lost+found]# ls -l
>>>>> total 740
>>>>> ---------T 1 root root 0 Apr  8 21:06 100119
>>>>> ---------T 1 root root 0 Apr  8 21:11 101123
>>>>> ---------T 1 root root 0 Apr  8 21:19 102659
>>>>> ---------T 1 root root 0 Apr 12 14:46 1040919
>>>>> ---------T 1 root root 0 Apr 12 14:58 1041943
>>>>> ---------T 1 root root 0 Apr  8 21:32 105219
>>>>> ---------T 1 root root 0 Apr  8 21:37 105731
>>>>> ---------T 1 root root 0 Apr 12 17:48 1068055
>>>>> ---------T 1 root root 0 Apr 12 18:38 1073943
>>>>> ---------T 1 root root 0 Apr  8 21:54 108035
>>>>> ---------T 1 root root 0 Apr 12 21:49 1091095
>>>>> ---------T 1 root root 0 Apr 13 00:17 1111063
>>>>> ---------T 1 root root 0 Apr 13 03:51 1121815
>>>>> ---------T 1 root root 0 Apr  8 22:25 112387
>>>>> ---------T 1 root root 0 Apr 13 06:39 1136151
>>>>> ...
>>>>> [root@* lost+found]# getfattr -m . -d -e hex *
>>>>>
>>>>> # file: 96007
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0xa0370d8a9f104dafbebbd0e6dd7ce1f7
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3600
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x0000000049dff000
>>>>>
>>>>> # file: 97027
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0xc1c1fe2ec7034442a623385f43b04c25
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3600
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x000000006ac78000
>>>>>
>>>>> # file: 97559
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0xcf7c17013c914511bda4d1c743fae118
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3500
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x00000000519fb000
>>>>>
>>>>> # file: 98055
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0xe86abc6e2c4b44c28d415fbbe34f2102
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3600
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x000000004c098000
>>>>>
>>>>> # file: 98567
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0x12543a2efbdf4b9fa61c6d89ca396f80
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3500
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x000000006bc98000
>>>>>
>>>>> # file: 98583
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0x760d16d3b7974cfb9c0a665a0982c470
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3500
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x000000006cde9000
>>>>>
>>>>> # file: 99607
>>>>> trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
>>>>> trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
>>>>> trusted.gfid=3D0x0849a732ea204bc3b8bae830b46881da
>>>>>
>>>>> trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d72=
65706c69636174652d3500
>>>>>
>>>>> trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=
=3D0x00000000513f1000
>>>>> ...
>>>>>
>>>>> What do you think about it? Thank you very much.
>>>>>
>>>>>
>>>>> 2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>>>>>
>>>>>> Hi Brian,
>>>>>>
>>>>>> Your scripts works for me now after I installed all the rpm built ou=
t
>>>>>> from kernel srpm. I'll try it. Thank you.
>>>>>>
>>>>>>
>>>>>> 2013/4/12 Brian Foster <bfoster@redhat.com>
>>>>>>
>>>>>>> On 04/12/2013 04:32 AM, =B7=FB=D3=C0=CC=CE wrote:
>>>>>>> > Dear xfs experts,
>>>>>>> > Can I just call xfs_stack_trace(); in the second line of
>>>>>>> > xfs_do_force_shutdown() to print stack and rebuild kernel to chec=
k
>>>>>>> > what's the error?
>>>>>>> >
>>>>>>>
>>>>>>> I suppose that's a start. If you're willing/able to create and run =
a
>>>>>>> modified kernel for the purpose of collecting more debug info,
>>>>>>> perhaps
>>>>>>> we can get a bit more creative in collecting more data on the probl=
em
>>>>>>> (but a stack trace there is a good start).
>>>>>>>
>>>>>>> BTW- you might want to place the call after the
>>>>>>> XFS_FORCED_SHUTDOWN(mp)
>>>>>>> check almost halfway into the function to avoid duplicate messages.
>>>>>>>
>>>>>>> Brian
>>>>>>>
>>>>>>> >
>>>>>>> > 2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtao=
fu@gmail.com>>
>>>>>>> >
>>>>>>> >     Hi Brian,
>>>>>>> >     What else I'm missing? Thank you.
>>>>>>> >     stap -e 'probe module("xfs").function("xfs_iunlink"){}'
>>>>>>> >
>>>>>>> >     WARNING: cannot find module xfs debuginfo: No DWARF
>>>>>>> information found
>>>>>>> >     semantic error: no match while resolving probe point
>>>>>>> >     module("xfs").function("xfs_iunlink")
>>>>>>> >     Pass 2: analysis failed.  Try again with another '--vp 01'
>>>>>>> option.
>>>>>>> >
>>>>>>> >
>>>>>>> >     2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yon=
gtaofu@gmail.com
>>>>>>> >>
>>>>>>> >
>>>>>>> >         ls -l
>>>>>>> >
>>>>>>> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.=
ko.debug
>>>>>>> >         -r--r--r-- 1 root root 21393024 Apr 12 12:08
>>>>>>> >
>>>>>>> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.=
ko.debug
>>>>>>> >
>>>>>>> >         rpm -qa|grep  kernel
>>>>>>> >         kernel-headers-2.6.32-279.el6.x86_64
>>>>>>> >         kernel-devel-2.6.32-279.el6.x86_64
>>>>>>> >         kernel-2.6.32-358.el6.x86_64
>>>>>>> >         kernel-debuginfo-common-x86_64-2.6.32-279.el6.x86_64
>>>>>>> >         abrt-addon-kerneloops-2.0.8-6.el6.x86_64
>>>>>>> >         kernel-firmware-2.6.32-358.el6.noarch
>>>>>>> >         kernel-debug-2.6.32-358.el6.x86_64
>>>>>>> >         kernel-debuginfo-2.6.32-279.el6.x86_64
>>>>>>> >         dracut-kernel-004-283.el6.noarch
>>>>>>> >         libreport-plugin-kerneloops-2.0.9-5.el6.x86_64
>>>>>>> >         kernel-devel-2.6.32-358.el6.x86_64
>>>>>>> >         kernel-2.6.32-279.el6.x86_64
>>>>>>> >
>>>>>>> >         rpm -q kernel-debuginfo
>>>>>>> >         kernel-debuginfo-2.6.32-279.el6.x86_64
>>>>>>> >
>>>>>>> >         rpm -q kernel
>>>>>>> >         kernel-2.6.32-279.el6.x86_64
>>>>>>> >         kernel-2.6.32-358.el6.x86_64
>>>>>>> >
>>>>>>> >         do I need to re probe it?
>>>>>>> >
>>>>>>> >
>>>>>>> >         2013/4/12 Eric Sandeen <sandeen@sandeen.net
>>>>>>> >         <mailto:sandeen@sandeen.net>>
>>>>>>> >
>>>>>>> >             On 4/11/13 11:32 PM, =B7=FB=D3=C0=CC=CE wrote:
>>>>>>> >             > Hi Brian,
>>>>>>> >             > Sorry but when I execute the script it says:
>>>>>>> >             > WARNING: cannot find module xfs debuginfo: No DWARF
>>>>>>> >             information found
>>>>>>> >             > semantic error: no match while resolving probe poin=
t
>>>>>>> >             module("xfs").function("xfs_iunlink")
>>>>>>> >             >
>>>>>>> >             > uname -a
>>>>>>> >             > 2.6.32-279.el6.x86_64
>>>>>>> >             > kernel debuginfo has been installed.
>>>>>>> >             >
>>>>>>> >             > Where can I find the correct xfs debuginfo?
>>>>>>> >
>>>>>>> >             it should be in the kernel-debuginfo rpm (of the same
>>>>>>> >             version/release as the kernel rpm you're running)
>>>>>>> >
>>>>>>> >             You should have:
>>>>>>> >
>>>>>>> >
>>>>>>> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.=
ko.debug
>>>>>>> >
>>>>>>> >             If not, can you show:
>>>>>>> >
>>>>>>> >             # uname -a
>>>>>>> >             # rpm -q kernel
>>>>>>> >             # rpm -q kernel-debuginfo
>>>>>>> >
>>>>>>> >             -Eric
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> >         --
>>>>>>> >         =B7=FB=D3=C0=CC=CE
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> >     --
>>>>>>> >     =B7=FB=D3=C0=CC=CE
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> >
>>>>>>> > --
>>>>>>> > =B7=FB=D3=C0=CC=CE
>>>>>>> >
>>>>>>> >
>>>>>>> > _______________________________________________
>>>>>>> > xfs mailing list
>>>>>>> > xfs@oss.sgi.com
>>>>>>> > http://oss.sgi.com/mailman/listinfo/xfs
>>>>>>> >
>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> =B7=FB=D3=C0=CC=CE
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> =B7=FB=D3=C0=CC=CE
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> =B7=FB=D3=C0=CC=CE
>>>>
>>>
>>>
>>>
>>> --
>>> =B7=FB=D3=C0=CC=CE
>>>
>>
>>
>>
>> --
>> =B7=FB=D3=C0=CC=CE
>>
>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--14dae9340ee74eaced04da6678b7
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">And at the same time we got the following error log of glu=
sterfs:<br>[2013-04-15 20:43:03.851163] I [dht-rebalance.c:1611:gf_defrag_s=
tatus_get] 0-glusterfs: Rebalance is completed<br>[2013-04-15 20:43:03.8512=
48] I [dht-rebalance.c:1614:gf_defrag_status_get] 0-glusterfs: Files migrat=
ed: 1629, size: 1582329065954, lookups: 11036, failures: 561<br>
[2013-04-15 20:43:03.887634] W [glusterfsd.c:831:cleanup_and_exit] (--&gt;/=
lib64/libc.so.6(clone+0x6d) [0x3bd16e767d] (--&gt;/lib64/libpthread.so.0() =
[0x3bd1a07851] (--&gt;/usr/sbin/glusterfs(glusterfs_sigwaiter+0xdd) [0x405c=
9d]))) 0-: received signum (15), shutting down<br>
[2013-04-15 20:43:03.887878] E [rpcsvc.c:1155:rpcsvc_program_unregister_por=
tmap] 0-rpc-service: Could not unregister with portmap<br></div><div class=
=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/15 =B7=FB=D3=C0=
=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=
=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">More info about it is: It h=
appened exactly when glusterfs rebalance complete.<br></div><div class=3D"g=
mail_extra">
<div><div class=3D"h5"><br><br><div class=3D"gmail_quote">2013/4/15 =B7=FB=
=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" t=
arget=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">and xfs kernel trace is:<br=
>Apr 15 20:43:03 10 kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp() re=
turned error 22.<br>

Apr 15 20:43:03 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree returned erro=
r 22<br>Apr 15 20:43:03 10 kernel: Pid: 3093, comm: glusterfsd Not tainted =
2.6.32-279.el6.x86_64 #1<br>
Apr 15 20:43:03 10 kernel: Call Trace:<br>Apr 15 20:43:03 10 kernel: [&lt;f=
fffffffa02d4212&gt;] ? xfs_inactive+0x442/0x460 [xfs]<br>Apr 15 20:43:03 10=
 kernel: [&lt;ffffffffa02e1790&gt;] ? xfs_fs_clear_inode+0xa0/0xd0 [xfs]<br=
>


Apr 15 20:43:03 10 kernel: [&lt;ffffffff81195adc&gt;] ? clear_inode+0xac/0x=
140<br>Apr 15 20:43:03 10 kernel: [&lt;ffffffff81196296&gt;] ? generic_dele=
te_inode+0x196/0x1d0<br>Apr 15 20:43:03 10 kernel: [&lt;ffffffff81196335&gt=
;] ? generic_drop_inode+0x65/0x80<br>


Apr 15 20:43:03 10 kernel: [&lt;ffffffff81195182&gt;] ? iput+0x62/0x70<br>A=
pr 15 20:43:03 10 kernel: [&lt;ffffffff81191ce0&gt;] ? dentry_iput+0x90/0x1=
00<br>Apr 15 20:43:03 10 kernel: [&lt;ffffffff81191e41&gt;] ? d_kill+0x31/0=
x60<br>


Apr 15 20:43:03 10 kernel: [&lt;ffffffff8119386c&gt;] ? dput+0x7c/0x150<br>=
Apr 15 20:43:03 10 kernel: [&lt;ffffffff8117c9c9&gt;] ? __fput+0x189/0x210<=
br>Apr 15 20:43:03 10 kernel: [&lt;ffffffff8117ca75&gt;] ? fput+0x25/0x30<b=
r>


Apr 15 20:43:03 10 kernel: [&lt;ffffffff8117849d&gt;] ? filp_close+0x5d/0x9=
0<br>Apr 15 20:43:03 10 kernel: [&lt;ffffffff81178575&gt;] ? sys_close+0xa5=
/0x100<br>Apr 15 20:43:03 10 kernel: [&lt;ffffffff8100b308&gt;] ? tracesys+=
0xd9/0xde<br>


Apr 15 20:43:03 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called fro=
m line 1186 of file fs/xfs/xfs_vnodeops.c.&nbsp; Return address =3D 0xfffff=
fffa02d422b<br>Apr 15 20:43:03 10 kernel: XFS (sdb): I/O Error Detected. Sh=
utting down filesystem<br>


Apr 15 20:43:03 10 kernel: XFS (sdb): Please umount the filesystem and rect=
ify the problem(s)<br>Apr 15 20:43:13 10 kernel: XFS (sdb): xfs_log_force: =
error 5 returned.<br></div><div class=3D"gmail_extra"><div><div>
<br><br><div class=3D"gmail_quote">
2013/4/15 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongta=
ofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex">


<div dir=3D"ltr"><div><div>Dear Brian and xfs experts,<br></div>Brain your =
scripts works and I am able to reproduce it with glusterfs rebalance on our=
 test cluster. 2 of our server xfs shutdown during glusterfs rebalance, the=
 shutdown userspace stacktrace both related to pthread. See logs bellow, Wh=
at&#39;s your opinion? Thank you very much!<br>



</div>logs:<br>[<a href=3D"mailto:root@10.23.72.93" target=3D"_blank">root@=
10.23.72.93</a> ~]# cat xfs.log <br><br>--- xfs_imap -- module(&quot;xfs&qu=
ot;).function(&quot;xfs_imap@fs/xfs/xfs_ialloc.c:1257&quot;).return -- retu=
rn=3D0x16<br>


vars: mp=3D0xffff882017a50800 tp=3D0xffff881c81797c70 ino=3D0xffffffff imap=
=3D0xffff88100e2f7c08 flags=3D0x0 agbno=3D? agino=3D? agno=3D? blks_per_clu=
ster=3D? chunk_agbno=3D? cluster_agbno=3D? error=3D? offset=3D? offset_agbn=
o=3D? __func__=3D[...]<br>



mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20<br>mp-&gt;m_sb: sb_agcount =3D=
 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =3D 0x4, sb_agblklog =3D 0x1c=
, sb_dblocks =3D 0x1b4900000<br>imap: im_blkno =3D 0x0, im_len =3D 0xa078, =
im_boffset =3D 0x86ea<br>



kernel backtrace:<br>Returning from:&nbsp; 0xffffffffa02b3ab0 : xfs_imap+0x=
0/0x280 [xfs]<br>Returning to&nbsp; :&nbsp; 0xffffffffa02b9599 : xfs_inotob=
p+0x49/0xc0 [xfs]<br>&nbsp;0xffffffffa02b96f1 : xfs_iunlink_remove+0xe1/0x3=
20 [xfs]<br>&nbsp;0xffffffff81501a69<br>



&nbsp;0x0 (inexact)<br>user backtrace:<br>&nbsp;0x3bd1a0e5ad [/lib64/<a hre=
f=3D"http://libpthread-2.12.so" target=3D"_blank">libpthread-2.12.so</a>+0x=
e5ad/0x219000]<br><br>--- xfs_iunlink_remove -- module(&quot;xfs&quot;).fun=
ction(&quot;xfs_iunlink_remove@fs/xfs/xfs_inode.c:1680&quot;).return -- ret=
urn=3D0x16<br>



vars: tp=3D0xffff881c81797c70 ip=3D0xffff881003c13c00 next_ino=3D? mp=3D? a=
gi=3D? dip=3D? agibp=3D0xffff880109b47e20 ibp=3D? agno=3D? agino=3D? next_a=
gino=3D? last_ibp=3D? last_dip=3D0xffff882000000000 bucket_index=3D? offset=
=3D? last_offset=3D0xffffffffffff8810 error=3D? __func__=3D[...]<br>



ip: i_ino =3D 0x113, i_flags =3D 0x0<br>ip-&gt;i_d: di_nlink =3D 0x0, di_ge=
n =3D 0x0<br>[<a href=3D"mailto:root@10.23.72.93" target=3D"_blank">root@10=
.23.72.93</a> ~]# <br>[<a href=3D"mailto:root@10.23.72.94" target=3D"_blank=
">root@10.23.72.94</a> ~]# cat xfs.log <br>


<br>
--- xfs_imap -- module(&quot;xfs&quot;).function(&quot;xfs_imap@fs/xfs/xfs_=
ialloc.c:1257&quot;).return -- return=3D0x16<br>vars: mp=3D0xffff881017c6c8=
00 tp=3D0xffff8801037acea0 ino=3D0xffffffff imap=3D0xffff882017101c08 flags=
=3D0x0 agbno=3D? agino=3D? agno=3D? blks_per_cluster=3D? chunk_agbno=3D? cl=
uster_agbno=3D? error=3D? offset=3D? offset_agbno=3D? __func__=3D[...]<br>



mp: m_agno_log =3D 0x5, m_agino_log =3D 0x20<br>mp-&gt;m_sb: sb_agcount =3D=
 0x1c, sb_agblocks =3D 0xffffff0, sb_inopblog =3D 0x4, sb_agblklog =3D 0x1c=
, sb_dblocks =3D 0x1b4900000<br>imap: im_blkno =3D 0x0, im_len =3D 0xd98, i=
m_boffset =3D 0x547<br>



kernel backtrace:<br>Returning from:&nbsp; 0xffffffffa02b3ab0 : xfs_imap+0x=
0/0x280 [xfs]<br>Returning to&nbsp; :&nbsp; 0xffffffffa02b9599 : xfs_inotob=
p+0x49/0xc0 [xfs]<br>&nbsp;0xffffffffa02b96f1 : xfs_iunlink_remove+0xe1/0x3=
20 [xfs]<br>&nbsp;0xffffffff81501a69<br>



&nbsp;0x0 (inexact)<br>user backtrace:<br>&nbsp;0x30cd40e5ad [/lib64/<a hre=
f=3D"http://libpthread-2.12.so" target=3D"_blank">libpthread-2.12.so</a>+0x=
e5ad/0x219000]<br><br>--- xfs_iunlink_remove -- module(&quot;xfs&quot;).fun=
ction(&quot;xfs_iunlink_remove@fs/xfs/xfs_inode.c:1680&quot;).return -- ret=
urn=3D0x16<br>



vars: tp=3D0xffff8801037acea0 ip=3D0xffff880e697c8800 next_ino=3D? mp=3D? a=
gi=3D? dip=3D? agibp=3D0xffff880d846c2d60 ibp=3D? agno=3D? agino=3D? next_a=
gino=3D? last_ibp=3D? last_dip=3D0xffff881017c6c800 bucket_index=3D? offset=
=3D? last_offset=3D0xffffffffffff880e error=3D? __func__=3D[...]<br>



ip: i_ino =3D 0x142, i_flags =3D 0x0<br>ip-&gt;i_d: di_nlink =3D 0x0, di_ge=
n =3D 0x3565732e<br><br></div><div class=3D"gmail_extra"><div><div><br><br>=
<div class=3D"gmail_quote">2013/4/15 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&=
lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail=
.com</a>&gt;</span><br>



<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Also glusterfs use a l=
ot of hardlink for self-heal:<br>--------T 2 root root 0 Apr 15 11:58 /mnt/=
xfsd/testbug/998416323<br>



---------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/999296624<br>------=
---T 2 root root 0 Apr 15 12:24 /mnt/xfsd/testbug/999568484<br>
---------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/999956875<br>------=
---T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/.glusterfs/05/2f/052f4e3e=
-c379-4a3c-b995-a10fdaca33d0<br>---------T 2 root root 0 Apr 15 11:58 /mnt/=
xfsd/testbug/.glusterfs/05/95/0595272e-ce2b-45d5-8693-d02c00b94d9d<br>




---------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/.glusterfs/05/ca/05=
ca00a0-92a7-44cf-b6e3-380496aafaa4<br>---------T 2 root root 0 Apr 15 12:24=
 /mnt/xfsd/testbug/.glusterfs/0a/23/0a238ca7-3cef-4540-9c98-6bf631551b21<br=
>




---------T 2 root root 0 Apr 15 11:58 /mnt/xfsd/testbug/.glusterfs/0a/4b/0a=
4b640b-f675-4708-bb59-e2369ffbbb9d<br></div>Does it related?<br></div><div =
class=3D"gmail_extra"><div><div><br><br><div class=3D"gmail_quote">
2013/4/15 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongta=
ofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div>Dear xfs experts,=
<br></div>Now I&#39;m deploying Brian&#39;s system script in out cluster. B=
ut from last night till now 5 servers in our 24 servers xfs shutdown with t=
he same error. I run xfs_repair command and found all the lost inodes are g=
lusterfs dht link files. This explains why the xfs shutdown tend to happen =
during glusterfs rebalance. During glusterfs rebalance procedure a lot of d=
hk link files may be unlinked. For example the following inodes are found i=
n lost+found in one of the servers:<br>





[root@* lost+found]# pwd<br>/mnt/xfsd/lost+found<br>[root@* lost+found]# ls=
 -l<br>total 740<br>---------T 1 root root 0 Apr&nbsp; 8 21:06 100119<br>--=
-------T 1 root root 0 Apr&nbsp; 8 21:11 101123<br>---------T 1 root root 0=
 Apr&nbsp; 8 21:19 102659<br>





---------T 1 root root 0 Apr 12 14:46 1040919<br>---------T 1 root root 0 A=
pr 12 14:58 1041943<br>---------T 1 root root 0 Apr&nbsp; 8 21:32 105219<br=
>---------T 1 root root 0 Apr&nbsp; 8 21:37 105731<br>---------T 1 root roo=
t 0 Apr 12 17:48 1068055<br>





---------T 1 root root 0 Apr 12 18:38 1073943<br>---------T 1 root root 0 A=
pr&nbsp; 8 21:54 108035<br>---------T 1 root root 0 Apr 12 21:49 1091095<br=
>---------T 1 root root 0 Apr 13 00:17 1111063<br>---------T 1 root root 0 =
Apr 13 03:51 1121815<br>





---------T 1 root root 0 Apr&nbsp; 8 22:25 112387<br>---------T 1 root root=
 0 Apr 13 06:39 1136151<br>...<br>[root@* lost+found]# getfattr -m . -d -e =
hex *<br><br># file: 96007<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000=
000000000000000000000<br>





trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000<br>trust=
ed.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000<br>trusted.gf=
id=3D0xa0370d8a9f104dafbebbd0e6dd7ce1f7<br>trusted.glusterfs.dht.linkto=3D0=
x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3600<br>





trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
0000049dff000<br><br># file: 97027<br>trusted.afr.mams-cq-mt-video-client-3=
=3D0x000000000000000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x=
000000000000000000000000<br>





trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000<br>trust=
ed.gfid=3D0xc1c1fe2ec7034442a623385f43b04c25<br>trusted.glusterfs.dht.linkt=
o=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3600<br>trusted=
.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000000006a=
c78000<br>





<br># file: 97559<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>





trusted.gfid=3D0xcf7c17013c914511bda4d1c743fae118<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
000519fb000<br>





<br># file: 98055<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>





trusted.gfid=3D0xe86abc6e2c4b44c28d415fbbe34f2102<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3600<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
0004c098000<br>





<br># file: 98567<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>





trusted.gfid=3D0x12543a2efbdf4b9fa61c6d89ca396f80<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
0006bc98000<br>





<br># file: 98583<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>





trusted.gfid=3D0x760d16d3b7974cfb9c0a665a0982c470<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
0006cde9000<br>





<br># file: 99607<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>





trusted.gfid=3D0x0849a732ea204bc3b8bae830b46881da<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
000513f1000<br>





...<br><br></div>What do you think about it? Thank you very much.<br></div>=
<div class=3D"gmail_extra"><div><div><br><br><div class=3D"gmail_quote">201=
3/4/12 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu=
@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>





<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi Brian,<br><br></div=
>Your scripts works for me now after I installed all the rpm built out from=
 kernel srpm. I&#39;ll try it. Thank you.<br>





</div><div class=3D"gmail_extra"><div><div><br><br><div class=3D"gmail_quot=
e">
2013/4/12 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redh=
at.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span><br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">






<div>On 04/12/2013 04:32 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Dear xfs experts,<br>
&gt; Can I just call xfs_stack_trace(); in the second line of<br>
&gt; xfs_do_force_shutdown() to print stack and rebuild kernel to check<br>
&gt; what&#39;s the error?<br>
&gt;<br>
<br>
</div>I suppose that&#39;s a start. If you&#39;re willing/able to create an=
d run a<br>
modified kernel for the purpose of collecting more debug info, perhaps<br>
we can get a bit more creative in collecting more data on the problem<br>
(but a stack trace there is a good start).<br>
<br>
BTW- you might want to place the call after the XFS_FORCED_SHUTDOWN(mp)<br>
check almost halfway into the function to avoid duplicate messages.<br>
<br>
Brian<br>
<br>
&gt;<br>
&gt; 2013/4/12 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com=
" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yo=
ngtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; Hi Brian,<br>
&gt; &nbsp; &nbsp; What else I&#39;m missing? Thank you.<br>
&gt; &nbsp; &nbsp; stap -e &#39;probe module(&quot;xfs&quot;).function(&quo=
t;xfs_iunlink&quot;){}&#39;<br>
&gt;<br>
&gt; &nbsp; &nbsp; WARNING: cannot find module xfs debuginfo: No DWARF info=
rmation found<br>
&gt; &nbsp; &nbsp; semantic error: no match while resolving probe point<br>
&gt; &nbsp; &nbsp; module(&quot;xfs&quot;).function(&quot;xfs_iunlink&quot;=
)<br>
&gt; &nbsp; &nbsp; Pass 2: analysis failed. &nbsp;Try again with another &#=
39;--vp 01&#39; option.<br>
&gt;<br>
&gt;<br>
</div>&gt; &nbsp; &nbsp; 2013/4/12 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto=
:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:=
<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.co=
m</a>&gt;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ls -l<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2.6.32-279.el6.=
x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; -r--r--r-- 1 root root 21393024 Apr 12 12:=
08<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2.6.32-279.el6.=
x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -qa|grep &nbsp;kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-headers-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-devel-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-common-x86_64-2.6.32-279.=
el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; abrt-addon-kerneloops-2.0.8-6.el6.x86_64<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-firmware-2.6.32-358.el6.noarch<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debug-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; dracut-kernel-004-283.el6.noarch<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; libreport-plugin-kerneloops-2.0.9-5.el6.x8=
6_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-devel-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-279.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -q kernel-debuginfo<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-2.6.32-279.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -q kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-358.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; do I need to re probe it?<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/12 Eric Sandeen &lt;<a href=3D"mail=
to:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a><br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen=
@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;&gt;<br>
<div><div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On 4/11/13 11:32 PM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi Brian,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Sorry but when I execut=
e the script it says:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; WARNING: cannot find mo=
dule xfs debuginfo: No DWARF<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; information found<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; semantic error: no matc=
h while resolving probe point<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; module(&quot;xfs&quot;).func=
tion(&quot;xfs_iunlink&quot;)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; uname -a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 2.6.32-279.el6.x86_64<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; kernel debuginfo has be=
en installed.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Where can I find the co=
rrect xfs debuginfo?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; it should be in the kernel-d=
ebuginfo rpm (of the same<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version/release as the kerne=
l rpm you&#39;re running)<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; You should have:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2=
.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; If not, can you show:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # uname -a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # rpm -q kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # rpm -q kernel-debuginfo<br=
>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
</div></div><div><div>&gt; _______________________________________________<=
br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span>=
<font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span><font color=
=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span><font color=
=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span><font color=
=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span><font color=
=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span class=3D"HOE=
nZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--14dae9340ee74eaced04da6678b7--


--===============0692741384169525566==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0692741384169525566==--
