Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0314D7F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 02:38:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D896830404E
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 00:38:01 -0800 (PST)
Received: from smtpo65.poczta.onet.pl (smtpo33.poczta.onet.pl
	[213.180.142.164]) by cuda.sgi.com with ESMTP id
	gAZ0lT2OcpKPTqP5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 00:37:55 -0800 (PST)
Subject: Re: Which xfsprogs version to which kernel version
References: <5656DD39.8060403@poczta.onet.pl>
	<20151126132638.53ed9fc7@harpe.intellique.com>
	<565706BB.3030006@poczta.onet.pl>
	<20151126135053.GB39911@bfoster.bfoster>
	<5657190A.1050103@poczta.onet.pl>
	<20151127152250.GA64860@bfoster.bfoster>
From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Message-ID: <565C0ADA.908@poczta.onet.pl>
Date: Mon, 30 Nov 2015 09:37:46 +0100
MIME-Version: 1.0
In-Reply-To: <20151127152250.GA64860@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 11/27/15 16:22, Brian Foster wrote:
> On Thu, Nov 26, 2015 at 03:36:58PM +0100, aluno3@poczta.onet.pl wrote:
>> dmesg when mounting volume which was formated xfsprogs 4.3.0:
>>
>> *
>> root@192.168.176.24:~$ mkfs.xfs -V
>> mkfs.xfs version 4.3.0
>>
>> root@192.168.176.24:~$ mkfs.xfs  -f -m crc=3D0,finobt=3D0 /dev/sdc4
>> meta-data=3D/dev/sdc4              isize=3D256    agcount=3D4, agsize=3D=
474552 blks
>>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>>          =3D                       crc=3D0        finobt=3D0, sparse=3D0
>> data     =3D                       bsize=3D4096   blocks=3D1898208, imax=
pct=3D25
>>          =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
>> log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=
=3D2
>>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>>
>> root@192.168.176.24:~$ mount /dev/sdc4 /mnt/sdc4
>> mount: wrong fs type, bad option, bad superblock on /dev/sdc4,
>>        missing codepage or helper program, or other error
>>
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail or so.
>>
>> root@192.168.176.24:~$ dmesg
>> [  212.984534] XFS (sdc4): bad version
>> [  212.984547] ffff88005cccb000: 58 46 53 42 00 00 10 00 00 00 00 00 00
>> 1c f6 e0  XFSB............
>> [  212.984550] ffff88005cccb010: 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00  ................
>> [  212.984551] ffff88005cccb020: 55 9d 20 d9 1c e9 4e a9 a3 ee 8d fd ba
>> 68 b3 70  U. ...N......h.p
>> [  212.984553] ffff88005cccb030: 00 00 00 00 00 10 00 04 00 00 00 00 00
>> 00 00 80  ................
>> [  212.984556] XFS (sdc4): Internal error xfs_sb_read_verify at line 730
>> of file fs/xfs/xfs_mount.c.  Caller 0xffffffff81256c7d
>>
> =

> Interesting... have you tried to format without ftype support? It looks
> like that wasn't introduced until v3.13. E.g.,
> =

> 	mkfs.xfs -f -m crc=3D0 -n ftype=3D0 <dev>
> =


With ftype=3D0 and crc=3D0 options, mounting the volume is possible.


root:~$ mkfs.xfs -f -m crc=3D0 -n ftype=3D0 /dev/sdc
meta-data=3D/dev/sdc               isize=3D256    agcount=3D4, agsize=3D305=
24162
blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0, sparse=3D0
data     =3D                       bsize=3D4096   blocks=3D122096646, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D59617, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
root:~$ mount /dev/sdc /mnt/sdc
root:~$ dmesg
[ 1761.805159]  sdc: unknown partition table
[ 1768.928019] XFS (sdc): Mounting Filesystem
[ 1768.987660] XFS (sdc): Ending clean mount

so is it safe to use xfsprogs 4.3.0 with crc=3D0 and ftype=3D0 with kernel
3.10?

> Brian
> =

>> [  212.984560] CPU: 0 PID: 440 Comm: kworker/0:1H Tainted: P           O
>> 3.10.92-oe64-ge331686 #15
>> [  212.984562] Hardware name: System manufacturer System Product
>> Name/P5WDG2 WS Pro, BIOS 0905    03/06/2008
>> [  212.984567] Workqueue: xfslogd xfs_buf_iodone_work
>> [  212.984570]  ffffffff81692f75 ffffffff81258c5d ffffffff81256c7d
>> ffffffff818a39e3
>> [  212.984573]  ffff88007aa9ef00 0000000000000016 ffff88007aa8b000
>> 0000000000000000
>> [  212.984576]  ffff88007ea17800 ffffffff812a32ac ffffffff81256c7d
>> ffff88007ea11a40
>> [  212.984579] Call Trace:
>> [  212.984584]  [<ffffffff81692f75>] ? dump_stack+0xc/0x15
>> [  212.984587]  [<ffffffff81258c5d>] ? xfs_corruption_error+0x8d/0x90
>> [  212.984590]  [<ffffffff81256c7d>] ? xfs_buf_iodone_work+0x6d/0x90
>> [  212.984595]  [<ffffffff812a32ac>] ? xfs_sb_read_verify+0xfc/0x120
>> [  212.984598]  [<ffffffff81256c7d>] ? xfs_buf_iodone_work+0x6d/0x90
>> [  212.984600]  [<ffffffff81256c7d>] ? xfs_buf_iodone_work+0x6d/0x90
>> [  212.984604]  [<ffffffff8105ce4d>] ? process_one_work+0x13d/0x3b0
>> [  212.984607]  [<ffffffff8105d7b1>] ? worker_thread+0x121/0x3d0
>> [  212.984609]  [<ffffffff8105d690>] ? manage_workers.isra.26+0x280/0x280
>> [  212.984613]  [<ffffffff81062e92>] ? kthread+0xc2/0xd0
>> [  212.984616]  [<ffffffff81070000>] ? sched_clock_cpu+0x30/0x100
>> [  212.984619]  [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x110
>> [  212.984623]  [<ffffffff8169db98>] ? ret_from_fork+0x58/0x90
>> [  212.984626]  [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x110
>> [  212.984628] XFS (sdc4): Corruption detected. Unmount and run xfs_repa=
ir
>> [  212.984634] XFS (sdc4): SB validate failed with error 22.
>> *
>>
>> On 11/26/15 14:50, Brian Foster wrote:
>>> On Thu, Nov 26, 2015 at 02:18:51PM +0100, aluno3@poczta.onet.pl wrote:
>>>> Yes I used -f option with 4.X version of xfsprogs but mounting the
>>>> volume was not possible - before mkfs.xfs finished successfully
>>>> (mkfs.xfs -f -m crc=3D0,finobt=3D0).
>>>>
>>>
>>> You posted the output associated with the crc=3D1 fs mount failure, what
>>> happens when you try to mount after formatting with crc=3D0?
>>>
>>> Brian
>>>
>>>> Should I stay in 3.1.X family of xfsprogs or is it recommended to use =
at
>>>> least 3.2.x version with kernel 3.10?
>>>>
>>>> The most I care about xfs_repair.
>>>>
>>>> On 11/26/15 13:26, Emmanuel Florac wrote:
>>>>> Le Thu, 26 Nov 2015 11:21:45 +0100
>>>>> "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl> =E9crivait:
>>>>>
>>>>>> mkfs.xfs -m crc=3D0,finobt=3D0
>>>>>>
>>>>>> but it does not work with 4.X version of xfsprogs. Call trace also
>>>>>> occurred so I tried to use 3.2.4 family with crc=3D0,finobt=3D0 and =
volume
>>>>>> mounted successfully.
>>>>>>
>>>>>
>>>>> Did you use -f? else mkfs.xfs won't do anything as it'll detect an
>>>>> existing filesystem.
>>>>>
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
