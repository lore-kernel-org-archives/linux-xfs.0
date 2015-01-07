Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F80B7F54
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:41:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F38AE304039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 19:41:50 -0800 (PST)
Received: from mail-qc0-f175.google.com (mail-qc0-f175.google.com
	[209.85.216.175]) by cuda.sgi.com with ESMTP id
	JVQ0r2yepCGE0dms (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 19:41:48 -0800 (PST)
Received: by mail-qc0-f175.google.com with SMTP id p6so399331qcv.20
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 19:41:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150106121817.GA5874@bfoster.bfoster>
References: <CAL2gTc0nwvHcdev_HPoiYfNyAuT-SVENjt5zhmm1X0NcVzqp6g@mail.gmail.com>
	<20150106121817.GA5874@bfoster.bfoster>
From: Mingfan Lu <mingfan.lu@gmail.com>
Date: Wed, 7 Jan 2015 11:41:28 +0800
Message-ID: <CAL2gTc1jrVAQPK981UiSN9O90mq4QhTh5etZNEZLfVOpYuyrCw@mail.gmail.com>
Subject: Re: xfs down
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1898554808040539367=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============1898554808040539367==
Content-Type: multipart/alternative; boundary=047d7bea31c406a679050c07b41c

--047d7bea31c406a679050c07b41c
Content-Type: text/plain; charset=UTF-8

I have tried run xfs_repair -L /dev/sdb (umount the device first)
It seems the partition is repaired now.
Here is xfs_info output

[root@~]# xfs_info /dev/sdb
meta-data=/dev/sdb               isize=256    agcount=41, agsize=268435440
blks
         =                       sectsz=4096  attr=2, projid32bit=0
data     =                       bsize=4096   blocks=10742792192, imaxpct=5
         =                       sunit=16     swidth=176 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


On Tue, Jan 6, 2015 at 8:18 PM, Brian Foster <bfoster@redhat.com> wrote:

> On Mon, Jan 05, 2015 at 11:20:39AM +0800, Mingfan Lu wrote:
> >  I saw such xfs corruption information in /var/log/messages, and the xfs
> > partition could not be accessed now.
> > Any suggestion? Just to run xfs_repair ?
> >
>
> Note that this is a distro kernel...
>
> It looks like something is up with an allocation btree block. The output
> of 'xfs_repair -n' would be interesting. You might also want to provide
> some basic info about the fs (xfs_info), etc.:
>
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Brian
>
> > 2015-01-04T23:01:26.130998+08:00 jylt kernel: ffff8808ede89000: 41 42 54
> 43
> > 00 00 00 ff ff ff ff ff 00 00 00 00  ABTC............
> > 2015-01-04T23:01:26.131024+08:00 jylt kernel: XFS (sdb): Internal error
> > xfs_btree_check_sblock at line 120 of file fs/xfs/xfs_btree.c.  Caller
> > 0xffffffffa0303d44
> > 2015-01-04T23:01:26.131027+08:00 jylt kernel:
> > 2015-01-04T23:01:26.138526+08:00 jylt kernel: Pid: 9163, comm:
> xfsalloc/10
> > Not tainted 2.6.32-358.6.2.01.el6.x86_64 #1
> > 2015-01-04T23:01:26.138537+08:00 jylt kernel: Call Trace:
> > 2015-01-04T23:01:26.138542+08:00 jylt kernel: [<ffffffffa031732f>] ?
> > xfs_error_report+0x3f/0x50 [xfs]
> > 2015-01-04T23:01:26.138544+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> > xfs_btree_check_block+0x14/0x30 [xfs]
> > 2015-01-04T23:01:26.138547+08:00 jylt kernel: [<ffffffffa031739e>] ?
> > xfs_corruption_error+0x5e/0x90 [xfs]
> > 2015-01-04T23:01:26.138549+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> > xfs_btree_check_block+0x14/0x30 [xfs]
> > 2015-01-04T23:01:26.138551+08:00 jylt kernel: [<ffffffffa0303c8e>] ?
> > xfs_btree_check_sblock+0xbe/0x160 [xfs]
> > 2015-01-04T23:01:26.138553+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> > xfs_btree_check_block+0x14/0x30 [xfs]
> > 2015-01-04T23:01:26.138555+08:00 jylt kernel: [<ffffffffa0336a4d>] ?
> > xfs_trans_read_buf+0x5d/0x410 [xfs]
> > 2015-01-04T23:01:26.138570+08:00 jylt kernel: [<ffffffffa0303d44>] ?
> > xfs_btree_check_block+0x14/0x30 [xfs]
> > 2015-01-04T23:01:26.138579+08:00 jylt kernel: [<ffffffffa0303ee9>] ?
> > xfs_btree_read_buf_block+0xa9/0xd0 [xfs]
> > 2015-01-04T23:01:26.138586+08:00 jylt kernel: [<ffffffffa02ef7b1>] ?
> > xfs_allocbt_set_root+0x91/0xb0 [xfs]
> > 2015-01-04T23:01:26.138589+08:00 jylt kernel: [<ffffffffa0306a49>] ?
> > xfs_btree_new_root+0x229/0x550 [xfs]
> > 2015-01-04T23:01:26.138591+08:00 jylt kernel: [<ffffffffa0307d58>] ?
> > xfs_btree_insrec+0x348/0x5a0 [xfs]
> > 2015-01-04T23:01:26.138593+08:00 jylt kernel: [<ffffffffa03058fc>] ?
> > xfs_btree_delrec+0x3ac/0x10c0 [xfs]
> > 2015-01-04T23:01:26.138595+08:00 jylt kernel: [<ffffffffa03025a2>] ?
> > xfs_lookup_get_search_key+0x52/0x60 [xfs]
> > 2015-01-04T23:01:26.138597+08:00 jylt kernel: [<ffffffffa0308043>] ?
> > xfs_btree_insert+0x93/0x180 [xfs]
> > 2015-01-04T23:01:26.138599+08:00 jylt kernel: [<ffffffffa02ebe58>] ?
> > xfs_alloc_fixup_trees+0x138/0x350 [xfs]
> > 2015-01-04T23:01:26.138606+08:00 jylt kernel: [<ffffffffa02ee43b>] ?
> > xfs_alloc_ag_vextent_near+0x98b/0xb20 [xfs]
> > 2015-01-04T23:01:26.138609+08:00 jylt kernel: [<ffffffffa02eec4d>] ?
> > xfs_alloc_fix_freelist+0x40d/0x4a0 [xfs]
> > 2015-01-04T23:01:26.138611+08:00 jylt kernel: [<ffffffffa02ee6a5>] ?
> > xfs_alloc_ag_vextent+0xd5/0x100 [xfs]
> > 2015-01-04T23:01:26.138614+08:00 jylt kernel: [<ffffffffa02ef0cc>] ?
> > xfs_alloc_vextent+0x2bc/0x610 [xfs]
> > 2015-01-04T23:01:26.138616+08:00 jylt kernel: [<ffffffffa02f97c7>] ?
> > xfs_bmap_btalloc+0x267/0x700 [xfs]
> > 2015-01-04T23:01:26.138618+08:00 jylt kernel: [<ffffffffa02f9c6e>] ?
> > xfs_bmap_alloc+0xe/0x10 [xfs]
> > 2015-01-04T23:01:26.138620+08:00 jylt kernel: [<ffffffffa02f9d4a>] ?
> > xfs_bmapi_allocate_worker+0x4a/0x80 [xfs]
> > 2015-01-04T23:01:26.138622+08:00 jylt kernel: [<ffffffffa02f9d00>] ?
> > xfs_bmapi_allocate_worker+0x0/0x80 [xfs]
> > 2015-01-04T23:01:26.138626+08:00 jylt kernel: [<ffffffff81090ae0>] ?
> > worker_thread+0x170/0x2a0
> > 2015-01-04T23:01:26.138629+08:00 jylt kernel: [<ffffffff81096ca0>] ?
> > autoremove_wake_function+0x0/0x40
> > 2015-01-04T23:01:26.138630+08:00 jylt kernel: [<ffffffff81090970>] ?
> > worker_thread+0x0/0x2a0
> > 2015-01-04T23:01:26.138632+08:00 jylt kernel: [<ffffffff81096936>] ?
> > kthread+0x96/0xa0
> > 2015-01-04T23:01:26.138634+08:00 jylt kernel: [<ffffffff8100c0ca>] ?
> > child_rip+0xa/0x20
> > 2015-01-04T23:01:26.138636+08:00 jylt kernel: [<ffffffff810968a0>] ?
> > kthread+0x0/0xa0
> > 2015-01-04T23:01:26.138638+08:00 jylt kernel: [<ffffffff8100c0c0>] ?
> > child_rip+0x0/0x20
> > 2015-01-04T23:01:26.138642+08:00 jylt kernel: XFS (sdb): Corruption
> > detected. Unmount and run xfs_repair
> > 2015-01-04T23:01:26.138644+08:00 jylt kernel: XFS (sdb): Internal error
> > xfs_trans_cancel at line 1948 of file fs/xfs/xfs_trans.c.  Caller
> > 0xffffffffa0322e0d
> > 2015-01-04T23:01:26.138646+08:00 jylt kernel:
> > 2015-01-04T23:01:26.138648+08:00 jylt kernel: Pid: 10003, comm:
> flush-8:16
> > Not tainted 2.6.32-358.6.2.01.el6.x86_64 #1
> > 2015-01-04T23:01:26.138655+08:00 jylt kernel: Call Trace:
> > 2015-01-04T23:01:26.138657+08:00 jylt kernel: [<ffffffffa031732f>] ?
> > xfs_error_report+0x3f/0x50 [xfs]
> > 2015-01-04T23:01:26.138660+08:00 jylt kernel: [<ffffffffa0322e0d>] ?
> > xfs_iomap_write_allocate+0x26d/0x370 [xfs]
> > 2015-01-04T23:01:26.138662+08:00 jylt kernel: [<ffffffffa0334635>] ?
> > xfs_trans_cancel+0xf5/0x120 [xfs]
> > 2015-01-04T23:01:26.138664+08:00 jylt kernel: [<ffffffffa0322e0d>] ?
> > xfs_iomap_write_allocate+0x26d/0x370 [xfs]
> > 2015-01-04T23:01:26.138666+08:00 jylt kernel: [<ffffffffa033daf3>] ?
> > xfs_map_blocks+0x193/0x250 [xfs]
> > 2015-01-04T23:01:26.138668+08:00 jylt kernel: [<ffffffffa033e641>] ?
> > xfs_vm_writepage+0x261/0x5a0 [xfs]
> > 2015-01-04T23:01:26.138670+08:00 jylt kernel: [<ffffffff8112cb87>] ?
> > __writepage+0x17/0x40
> > 2015-01-04T23:01:26.138672+08:00 jylt kernel: [<ffffffff8112de99>] ?
> > write_cache_pages+0x1c9/0x4b0
> > 2015-01-04T23:01:26.138674+08:00 jylt kernel: [<ffffffff8112cb70>] ?
> > __writepage+0x0/0x40
> > 2015-01-04T23:01:26.138676+08:00 jylt kernel: [<ffffffff8112e1a4>] ?
> > generic_writepages+0x24/0x30
> > 2015-01-04T23:01:26.138678+08:00 jylt kernel: [<ffffffffa033d91d>] ?
> > xfs_vm_writepages+0x5d/0x80 [xfs]
> > 2015-01-04T23:01:26.138679+08:00 jylt kernel: [<ffffffff8112e1d1>] ?
> > do_writepages+0x21/0x40
> > 2015-01-04T23:01:26.138684+08:00 jylt kernel: [<ffffffff811ac78d>] ?
> > writeback_single_inode+0xdd/0x290
> > 2015-01-04T23:01:26.138686+08:00 jylt kernel: [<ffffffff811acb9e>] ?
> > writeback_sb_inodes+0xce/0x180
> > 2015-01-04T23:01:26.138688+08:00 jylt kernel: [<ffffffff811accfb>] ?
> > writeback_inodes_wb+0xab/0x1b0
> > 2015-01-04T23:01:26.138690+08:00 jylt kernel: [<ffffffff811ad09b>] ?
> > wb_writeback+0x29b/0x3f0
> > 2015-01-04T23:01:26.138692+08:00 jylt kernel: [<ffffffff8150dbb0>] ?
> > thread_return+0x4e/0x76e
> > 2015-01-04T23:01:26.138693+08:00 jylt kernel: [<ffffffff81081ae2>] ?
> > del_timer_sync+0x22/0x30
> > 2015-01-04T23:01:26.138695+08:00 jylt kernel: [<ffffffff811ad389>] ?
> > wb_do_writeback+0x199/0x240
> > 2015-01-04T23:01:26.138699+08:00 jylt kernel: [<ffffffff811ad493>] ?
> > bdi_writeback_task+0x63/0x1b0
> > 2015-01-04T23:01:26.138701+08:00 jylt kernel: [<ffffffff81096b67>] ?
> > bit_waitqueue+0x17/0xd0
> > 2015-01-04T23:01:26.138703+08:00 jylt kernel: [<ffffffff8113cb20>] ?
> > bdi_start_fn+0x0/0x100
> > 2015-01-04T23:01:26.138705+08:00 jylt kernel: [<ffffffff8113cba6>] ?
> > bdi_start_fn+0x86/0x100
> > 2015-01-04T23:01:26.138707+08:00 jylt kernel: [<ffffffff8113cb20>] ?
> > bdi_start_fn+0x0/0x100
> > 2015-01-04T23:01:26.138709+08:00 jylt kernel: [<ffffffff81096936>] ?
> > kthread+0x96/0xa0
> > 2015-01-04T23:01:26.138710+08:00 jylt kernel: [<ffffffff8100c0ca>] ?
> > child_rip+0xa/0x20
> > 2015-01-04T23:01:26.138712+08:00 jylt kernel: [<ffffffff810968a0>] ?
> > kthread+0x0/0xa0
> > 2015-01-04T23:01:26.138716+08:00 jylt kernel: [<ffffffff8100c0c0>] ?
> > child_rip+0x0/0x20
> > 2015-01-04T23:01:26.138727+08:00 jylt kernel: XFS (sdb):
> > xfs_do_force_shutdown(0x8) called from line 1949 of file
> > fs/xfs/xfs_trans.c.  Return address = 0xffffffffa033464e
> > 2015-01-04T23:01:26.138729+08:00 jylt kernel: XFS (sdb): Corruption of
> > in-memory data detected.  Shutting down filesystem
> > 2015-01-04T23:01:26.138731+08:00 jylt kernel: XFS (sdb): Please umount
> the
> > filesystem and rectify the problem(s)
> > 2015-01-04T23:01:29.367810+08:00 jylt
> data1-jy_ugc_mams_source_cold[3406]:
> > [2015-01-04 15:01:29.359018] M
> > [posix-helpers.c:1502:posix_health_check_thread_proc]
> > 0-jy_ugc_mams_source_cold-posix: health-check failed, going down
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--047d7bea31c406a679050c07b41c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I have tried run xfs_repair -L /dev/sdb (umount the d=
evice first)</div><div>It seems the partition is repaired now.</div>Here is=
 xfs_info output<div><br></div><div><div>[root@~]# xfs_info /dev/sdb=C2=A0<=
/div><div>meta-data=3D/dev/sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 isize=3D256 =C2=A0 =C2=A0agcount=3D41, agsize=3D268435440 blks</div>=
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D4096 =C2=A0attr=3D2,=
 projid32bit=3D0</div><div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 bl=
ocks=3D10742792192, imaxpct=3D5</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sunit=3D16 =C2=A0 =C2=A0 swidth=3D176 blks</div><div>naming =C2=
=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D40=
96 =C2=A0 ascii-ci=3D0</div><div>log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D521=
728, version=3D2</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=
=3D4096 =C2=A0sunit=3D1 blks, lazy-count=3D1</div><div>realtime =3Dnone =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extsz=3D4096 =
=C2=A0 blocks=3D0, rtextents=3D0</div></div><div><br></div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Jan 6, 2015 at 8:18=
 PM, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.co=
m" target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wrote:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">On Mon, Jan 05, 2015 at 11:20:39AM +0800, Mingfan Lu w=
rote:<br>
&gt;=C2=A0 I saw such xfs corruption information in /var/log/messages, and =
the xfs<br>
&gt; partition could not be accessed now.<br>
&gt; Any suggestion? Just to run xfs_repair ?<br>
&gt;<br>
<br>
Note that this is a distro kernel...<br>
<br>
It looks like something is up with an allocation btree block. The output<br=
>
of &#39;xfs_repair -n&#39; would be interesting. You might also want to pro=
vide<br>
some basic info about the fs (xfs_info), etc.:<br>
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F=
</a><br>
<br>
Brian<br>
<br>
&gt; 2015-01-04T23:01:26.130998+08:00 jylt kernel: ffff8808ede89000: 41 42 =
54 43<br>
&gt; 00 00 00 ff ff ff ff ff 00 00 00 00=C2=A0 ABTC............<br>
&gt; 2015-01-04T23:01:26.131024+08:00 jylt kernel: XFS (sdb): Internal erro=
r<br>
&gt; xfs_btree_check_sblock at line 120 of file fs/xfs/xfs_btree.c.=C2=A0 C=
aller<br>
&gt; 0xffffffffa0303d44<br>
&gt; 2015-01-04T23:01:26.131027+08:00 jylt kernel:<br>
&gt; 2015-01-04T23:01:26.138526+08:00 jylt kernel: Pid: 9163, comm: xfsallo=
c/10<br>
&gt; Not tainted 2.6.32-358.6.2.01.el6.x86_64 #1<br>
&gt; 2015-01-04T23:01:26.138537+08:00 jylt kernel: Call Trace:<br>
&gt; 2015-01-04T23:01:26.138542+08:00 jylt kernel: [&lt;ffffffffa031732f&gt=
;] ?<br>
&gt; xfs_error_report+0x3f/0x50 [xfs]<br>
&gt; 2015-01-04T23:01:26.138544+08:00 jylt kernel: [&lt;ffffffffa0303d44&gt=
;] ?<br>
&gt; xfs_btree_check_block+0x14/0x30 [xfs]<br>
&gt; 2015-01-04T23:01:26.138547+08:00 jylt kernel: [&lt;ffffffffa031739e&gt=
;] ?<br>
&gt; xfs_corruption_error+0x5e/0x90 [xfs]<br>
&gt; 2015-01-04T23:01:26.138549+08:00 jylt kernel: [&lt;ffffffffa0303d44&gt=
;] ?<br>
&gt; xfs_btree_check_block+0x14/0x30 [xfs]<br>
&gt; 2015-01-04T23:01:26.138551+08:00 jylt kernel: [&lt;ffffffffa0303c8e&gt=
;] ?<br>
&gt; xfs_btree_check_sblock+0xbe/0x160 [xfs]<br>
&gt; 2015-01-04T23:01:26.138553+08:00 jylt kernel: [&lt;ffffffffa0303d44&gt=
;] ?<br>
&gt; xfs_btree_check_block+0x14/0x30 [xfs]<br>
&gt; 2015-01-04T23:01:26.138555+08:00 jylt kernel: [&lt;ffffffffa0336a4d&gt=
;] ?<br>
&gt; xfs_trans_read_buf+0x5d/0x410 [xfs]<br>
&gt; 2015-01-04T23:01:26.138570+08:00 jylt kernel: [&lt;ffffffffa0303d44&gt=
;] ?<br>
&gt; xfs_btree_check_block+0x14/0x30 [xfs]<br>
&gt; 2015-01-04T23:01:26.138579+08:00 jylt kernel: [&lt;ffffffffa0303ee9&gt=
;] ?<br>
&gt; xfs_btree_read_buf_block+0xa9/0xd0 [xfs]<br>
&gt; 2015-01-04T23:01:26.138586+08:00 jylt kernel: [&lt;ffffffffa02ef7b1&gt=
;] ?<br>
&gt; xfs_allocbt_set_root+0x91/0xb0 [xfs]<br>
&gt; 2015-01-04T23:01:26.138589+08:00 jylt kernel: [&lt;ffffffffa0306a49&gt=
;] ?<br>
&gt; xfs_btree_new_root+0x229/0x550 [xfs]<br>
&gt; 2015-01-04T23:01:26.138591+08:00 jylt kernel: [&lt;ffffffffa0307d58&gt=
;] ?<br>
&gt; xfs_btree_insrec+0x348/0x5a0 [xfs]<br>
&gt; 2015-01-04T23:01:26.138593+08:00 jylt kernel: [&lt;ffffffffa03058fc&gt=
;] ?<br>
&gt; xfs_btree_delrec+0x3ac/0x10c0 [xfs]<br>
&gt; 2015-01-04T23:01:26.138595+08:00 jylt kernel: [&lt;ffffffffa03025a2&gt=
;] ?<br>
&gt; xfs_lookup_get_search_key+0x52/0x60 [xfs]<br>
&gt; 2015-01-04T23:01:26.138597+08:00 jylt kernel: [&lt;ffffffffa0308043&gt=
;] ?<br>
&gt; xfs_btree_insert+0x93/0x180 [xfs]<br>
&gt; 2015-01-04T23:01:26.138599+08:00 jylt kernel: [&lt;ffffffffa02ebe58&gt=
;] ?<br>
&gt; xfs_alloc_fixup_trees+0x138/0x350 [xfs]<br>
&gt; 2015-01-04T23:01:26.138606+08:00 jylt kernel: [&lt;ffffffffa02ee43b&gt=
;] ?<br>
&gt; xfs_alloc_ag_vextent_near+0x98b/0xb20 [xfs]<br>
&gt; 2015-01-04T23:01:26.138609+08:00 jylt kernel: [&lt;ffffffffa02eec4d&gt=
;] ?<br>
&gt; xfs_alloc_fix_freelist+0x40d/0x4a0 [xfs]<br>
&gt; 2015-01-04T23:01:26.138611+08:00 jylt kernel: [&lt;ffffffffa02ee6a5&gt=
;] ?<br>
&gt; xfs_alloc_ag_vextent+0xd5/0x100 [xfs]<br>
&gt; 2015-01-04T23:01:26.138614+08:00 jylt kernel: [&lt;ffffffffa02ef0cc&gt=
;] ?<br>
&gt; xfs_alloc_vextent+0x2bc/0x610 [xfs]<br>
&gt; 2015-01-04T23:01:26.138616+08:00 jylt kernel: [&lt;ffffffffa02f97c7&gt=
;] ?<br>
&gt; xfs_bmap_btalloc+0x267/0x700 [xfs]<br>
&gt; 2015-01-04T23:01:26.138618+08:00 jylt kernel: [&lt;ffffffffa02f9c6e&gt=
;] ?<br>
&gt; xfs_bmap_alloc+0xe/0x10 [xfs]<br>
&gt; 2015-01-04T23:01:26.138620+08:00 jylt kernel: [&lt;ffffffffa02f9d4a&gt=
;] ?<br>
&gt; xfs_bmapi_allocate_worker+0x4a/0x80 [xfs]<br>
&gt; 2015-01-04T23:01:26.138622+08:00 jylt kernel: [&lt;ffffffffa02f9d00&gt=
;] ?<br>
&gt; xfs_bmapi_allocate_worker+0x0/0x80 [xfs]<br>
&gt; 2015-01-04T23:01:26.138626+08:00 jylt kernel: [&lt;ffffffff81090ae0&gt=
;] ?<br>
&gt; worker_thread+0x170/0x2a0<br>
&gt; 2015-01-04T23:01:26.138629+08:00 jylt kernel: [&lt;ffffffff81096ca0&gt=
;] ?<br>
&gt; autoremove_wake_function+0x0/0x40<br>
&gt; 2015-01-04T23:01:26.138630+08:00 jylt kernel: [&lt;ffffffff81090970&gt=
;] ?<br>
&gt; worker_thread+0x0/0x2a0<br>
&gt; 2015-01-04T23:01:26.138632+08:00 jylt kernel: [&lt;ffffffff81096936&gt=
;] ?<br>
&gt; kthread+0x96/0xa0<br>
&gt; 2015-01-04T23:01:26.138634+08:00 jylt kernel: [&lt;ffffffff8100c0ca&gt=
;] ?<br>
&gt; child_rip+0xa/0x20<br>
&gt; 2015-01-04T23:01:26.138636+08:00 jylt kernel: [&lt;ffffffff810968a0&gt=
;] ?<br>
&gt; kthread+0x0/0xa0<br>
&gt; 2015-01-04T23:01:26.138638+08:00 jylt kernel: [&lt;ffffffff8100c0c0&gt=
;] ?<br>
&gt; child_rip+0x0/0x20<br>
&gt; 2015-01-04T23:01:26.138642+08:00 jylt kernel: XFS (sdb): Corruption<br=
>
&gt; detected. Unmount and run xfs_repair<br>
&gt; 2015-01-04T23:01:26.138644+08:00 jylt kernel: XFS (sdb): Internal erro=
r<br>
&gt; xfs_trans_cancel at line 1948 of file fs/xfs/xfs_trans.c.=C2=A0 Caller=
<br>
&gt; 0xffffffffa0322e0d<br>
&gt; 2015-01-04T23:01:26.138646+08:00 jylt kernel:<br>
&gt; 2015-01-04T23:01:26.138648+08:00 jylt kernel: Pid: 10003, comm: flush-=
8:16<br>
&gt; Not tainted 2.6.32-358.6.2.01.el6.x86_64 #1<br>
&gt; 2015-01-04T23:01:26.138655+08:00 jylt kernel: Call Trace:<br>
&gt; 2015-01-04T23:01:26.138657+08:00 jylt kernel: [&lt;ffffffffa031732f&gt=
;] ?<br>
&gt; xfs_error_report+0x3f/0x50 [xfs]<br>
&gt; 2015-01-04T23:01:26.138660+08:00 jylt kernel: [&lt;ffffffffa0322e0d&gt=
;] ?<br>
&gt; xfs_iomap_write_allocate+0x26d/0x370 [xfs]<br>
&gt; 2015-01-04T23:01:26.138662+08:00 jylt kernel: [&lt;ffffffffa0334635&gt=
;] ?<br>
&gt; xfs_trans_cancel+0xf5/0x120 [xfs]<br>
&gt; 2015-01-04T23:01:26.138664+08:00 jylt kernel: [&lt;ffffffffa0322e0d&gt=
;] ?<br>
&gt; xfs_iomap_write_allocate+0x26d/0x370 [xfs]<br>
&gt; 2015-01-04T23:01:26.138666+08:00 jylt kernel: [&lt;ffffffffa033daf3&gt=
;] ?<br>
&gt; xfs_map_blocks+0x193/0x250 [xfs]<br>
&gt; 2015-01-04T23:01:26.138668+08:00 jylt kernel: [&lt;ffffffffa033e641&gt=
;] ?<br>
&gt; xfs_vm_writepage+0x261/0x5a0 [xfs]<br>
&gt; 2015-01-04T23:01:26.138670+08:00 jylt kernel: [&lt;ffffffff8112cb87&gt=
;] ?<br>
&gt; __writepage+0x17/0x40<br>
&gt; 2015-01-04T23:01:26.138672+08:00 jylt kernel: [&lt;ffffffff8112de99&gt=
;] ?<br>
&gt; write_cache_pages+0x1c9/0x4b0<br>
&gt; 2015-01-04T23:01:26.138674+08:00 jylt kernel: [&lt;ffffffff8112cb70&gt=
;] ?<br>
&gt; __writepage+0x0/0x40<br>
&gt; 2015-01-04T23:01:26.138676+08:00 jylt kernel: [&lt;ffffffff8112e1a4&gt=
;] ?<br>
&gt; generic_writepages+0x24/0x30<br>
&gt; 2015-01-04T23:01:26.138678+08:00 jylt kernel: [&lt;ffffffffa033d91d&gt=
;] ?<br>
&gt; xfs_vm_writepages+0x5d/0x80 [xfs]<br>
&gt; 2015-01-04T23:01:26.138679+08:00 jylt kernel: [&lt;ffffffff8112e1d1&gt=
;] ?<br>
&gt; do_writepages+0x21/0x40<br>
&gt; 2015-01-04T23:01:26.138684+08:00 jylt kernel: [&lt;ffffffff811ac78d&gt=
;] ?<br>
&gt; writeback_single_inode+0xdd/0x290<br>
&gt; 2015-01-04T23:01:26.138686+08:00 jylt kernel: [&lt;ffffffff811acb9e&gt=
;] ?<br>
&gt; writeback_sb_inodes+0xce/0x180<br>
&gt; 2015-01-04T23:01:26.138688+08:00 jylt kernel: [&lt;ffffffff811accfb&gt=
;] ?<br>
&gt; writeback_inodes_wb+0xab/0x1b0<br>
&gt; 2015-01-04T23:01:26.138690+08:00 jylt kernel: [&lt;ffffffff811ad09b&gt=
;] ?<br>
&gt; wb_writeback+0x29b/0x3f0<br>
&gt; 2015-01-04T23:01:26.138692+08:00 jylt kernel: [&lt;ffffffff8150dbb0&gt=
;] ?<br>
&gt; thread_return+0x4e/0x76e<br>
&gt; 2015-01-04T23:01:26.138693+08:00 jylt kernel: [&lt;ffffffff81081ae2&gt=
;] ?<br>
&gt; del_timer_sync+0x22/0x30<br>
&gt; 2015-01-04T23:01:26.138695+08:00 jylt kernel: [&lt;ffffffff811ad389&gt=
;] ?<br>
&gt; wb_do_writeback+0x199/0x240<br>
&gt; 2015-01-04T23:01:26.138699+08:00 jylt kernel: [&lt;ffffffff811ad493&gt=
;] ?<br>
&gt; bdi_writeback_task+0x63/0x1b0<br>
&gt; 2015-01-04T23:01:26.138701+08:00 jylt kernel: [&lt;ffffffff81096b67&gt=
;] ?<br>
&gt; bit_waitqueue+0x17/0xd0<br>
&gt; 2015-01-04T23:01:26.138703+08:00 jylt kernel: [&lt;ffffffff8113cb20&gt=
;] ?<br>
&gt; bdi_start_fn+0x0/0x100<br>
&gt; 2015-01-04T23:01:26.138705+08:00 jylt kernel: [&lt;ffffffff8113cba6&gt=
;] ?<br>
&gt; bdi_start_fn+0x86/0x100<br>
&gt; 2015-01-04T23:01:26.138707+08:00 jylt kernel: [&lt;ffffffff8113cb20&gt=
;] ?<br>
&gt; bdi_start_fn+0x0/0x100<br>
&gt; 2015-01-04T23:01:26.138709+08:00 jylt kernel: [&lt;ffffffff81096936&gt=
;] ?<br>
&gt; kthread+0x96/0xa0<br>
&gt; 2015-01-04T23:01:26.138710+08:00 jylt kernel: [&lt;ffffffff8100c0ca&gt=
;] ?<br>
&gt; child_rip+0xa/0x20<br>
&gt; 2015-01-04T23:01:26.138712+08:00 jylt kernel: [&lt;ffffffff810968a0&gt=
;] ?<br>
&gt; kthread+0x0/0xa0<br>
&gt; 2015-01-04T23:01:26.138716+08:00 jylt kernel: [&lt;ffffffff8100c0c0&gt=
;] ?<br>
&gt; child_rip+0x0/0x20<br>
&gt; 2015-01-04T23:01:26.138727+08:00 jylt kernel: XFS (sdb):<br>
&gt; xfs_do_force_shutdown(0x8) called from line 1949 of file<br>
&gt; fs/xfs/xfs_trans.c.=C2=A0 Return address =3D 0xffffffffa033464e<br>
&gt; 2015-01-04T23:01:26.138729+08:00 jylt kernel: XFS (sdb): Corruption of=
<br>
&gt; in-memory data detected.=C2=A0 Shutting down filesystem<br>
&gt; 2015-01-04T23:01:26.138731+08:00 jylt kernel: XFS (sdb): Please umount=
 the<br>
&gt; filesystem and rectify the problem(s)<br>
&gt; 2015-01-04T23:01:29.367810+08:00 jylt data1-jy_ugc_mams_source_cold[34=
06]:<br>
&gt; [2015-01-04 15:01:29.359018] M<br>
&gt; [posix-helpers.c:1502:posix_health_check_thread_proc]<br>
&gt; 0-jy_ugc_mams_source_cold-posix: health-check failed, going down<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br></div>

--047d7bea31c406a679050c07b41c--


--===============1898554808040539367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1898554808040539367==--
