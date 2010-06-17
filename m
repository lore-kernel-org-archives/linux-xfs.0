Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5HDFte5177907 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 08:15:56 -0500
Received: from dkcphmx22.softcom.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 322B6159BC6A
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 06:22:15 -0700 (PDT)
Received: from dkcphmx22.softcom.dk (dkcphmx22.softcom.dk [213.150.41.59]) by
	cuda.sgi.com with ESMTP id GZQjUpDUgIpPneu3 for
	<xfs@oss.sgi.com>; Thu, 17 Jun 2010 06:22:15 -0700 (PDT)
MIME-Version: 1.0
Subject: Help with XFS
Message-ID: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
From: =?ISO-8859-1?Q?Thomas_F=F8rde?= <thomas.forde@bergenofs.no>
Date: Thu, 17 Jun 2010 15:18:26 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8126672740807949309=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.
--===============8126672740807949309==
Content-Type: multipart/alternative; boundary="=_alternative 004919A2C1257745_="

This is a multipart message in MIME format.
--=_alternative 004919A2C1257745_=
Content-Type: text/plain; charset="US-ASCII"

during the other day our XFS filesystem had a unexpected shutdown 
according to logs.

un 16 15:48:42 strmng04 kernel: 0x0: 00 00 c0 46 01 00 c0 46 77 02 c0 46 
fe 7d 00 40
Jun 16 15:48:42 strmng04 kernel: Filesystem "sdf1": XFS internal error 
xfs_da_do_buf(2) at line 2276 of file 
/home/buildcentos/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_smp/xfs_da_bt$
Jun 16 15:48:42 strmng04 kernel:
Jun 16 15:48:42 strmng04 kernel: Call 
Trace:<ffffffffa0211762>{:xfs:xfs_corruption_error+236} 
<ffffffffa023c7cc>{:xfs:kmem_zone_alloc+66}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa0202526>{:xfs:xfs_da_do_buf+1335} 
<ffffffffa0202653>{:xfs:xfs_da_read_buf+21}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa0202653>{:xfs:xfs_da_read_buf+21} 
<ffffffffa0207210>{:xfs:xfs_dir2_block_lookup_int+71}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa0207210>{:xfs:xfs_dir2_block_lookup_int+71}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa0207359>{:xfs:xfs_dir2_block_lookup+19} 
<ffffffffa0206457>{:xfs:xfs_dir2_lookup+200}
Jun 16 15:48:42 strmng04 kernel:        <ffffffff801347b0>{__wake_up+54} 
<ffffffff801ef3a1>{__up_read+16}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa0229d22>{:xfs:xfs_dir_lookup_int+53} 
<ffffffffa022e47d>{:xfs:xfs_lookup+74}
Jun 16 15:48:42 strmng04 kernel: <ffffffffa02371e0>{:xfs:linvfs_lookup+48} 
<ffffffff80189fc5>{__lookup_hash+263}
Jun 16 15:48:42 strmng04 kernel: <ffffffff8018a04f>{lookup_one_len+94} 
<ffffffffa03bd2bc>{:nfsd:nfsd_lookup+936}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa03c55fa>{:nfsd:nfsd3_proc_lookup+198} 
<ffffffffa03ba7dc>{:nfsd:nfsd_dispatch+219}
Jun 16 15:48:42 strmng04 kernel: 
<ffffffffa03474ac>{:sunrpc:svc_process+1227} 
<ffffffff80134709>{default_wake_function+0}
Jun 16 15:48:42 strmng04 kernel:        <ffffffffa03ba31b>{:nfsd:nfsd+0} 
<ffffffffa03ba553>{:nfsd:nfsd+568}
Jun 16 15:48:42 strmng04 kernel: <ffffffff80133470>{schedule_tail+55} 
<ffffffff80110fd3>{child_rip+8}
Jun 16 15:48:42 strmng04 kernel:        <ffffffffa03ba31b>{:nfsd:nfsd+0} 
<ffffffffa03ba31b>{:nfsd:nfsd+0}
Jun 16 15:48:42 strmng04 kernel:        <ffffffff80110fcb>{child_rip+0}

many of those. and at the end

Jun 16 15:50:13 strmng04 kernel: xfs_force_shutdown(sdf1,0x8) called from 
line 4092 of file 
/home/buildcentos/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_smp/xfs_bmap.c. 
Return address
 = 0xffffffffa01f7fb4
Jun 16 15:50:13 strmng04 kernel: Filesystem "sdf1": Corruption of 
in-memory data detected.  Shutting down filesystem: sdf1
Jun 16 15:50:13 strmng04 kernel: Please umount the filesystem, and rectify 
the problem(s)


i have run xfs_check without any verbos information given
i have run xfs_repair without any information errors fixed.

when i try to mount the XFS filesystem of 10TB, my 7.8 TB of data is now 
gone.

before:         /dev/sdf1            10527858560 8801101708 1726756852 84% 
/D5
after:          /dev/sdf1            10527858560       528 10527858032 1% 
/D5

help, where did my data go, and how can i get it back.
--=_alternative 004919A2C1257745_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">during the other day our XFS filesystem
had a unexpected shutdown according to logs.</font>
<br>
<br><font size=2 face="sans-serif">un 16 15:48:42 strmng04 kernel: 0x0:
00 00 c0 46 01 00 c0 46 77 02 c0 46 fe 7d 00 40</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: Filesystem
&quot;sdf1&quot;: XFS internal error xfs_da_do_buf(2) at line 2276 of file
/home/buildcentos/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_smp/xfs_da_bt$</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel:</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: Call
Trace:&lt;ffffffffa0211762&gt;{:xfs:xfs_corruption_error+236} &lt;ffffffffa023c7cc&gt;{:xfs:kmem_zone_alloc+66}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa0202526&gt;{:xfs:xfs_da_do_buf+1335} &lt;ffffffffa0202653&gt;{:xfs:xfs_da_read_buf+21}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa0202653&gt;{:xfs:xfs_da_read_buf+21} &lt;ffffffffa0207210&gt;{:xfs:xfs_dir2_block_lookup_int+71}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa0207210&gt;{:xfs:xfs_dir2_block_lookup_int+71}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa0207359&gt;{:xfs:xfs_dir2_block_lookup+19}
&lt;ffffffffa0206457&gt;{:xfs:xfs_dir2_lookup+200}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffff801347b0&gt;{__wake_up+54} &lt;ffffffff801ef3a1&gt;{__up_read+16}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa0229d22&gt;{:xfs:xfs_dir_lookup_int+53}
&lt;ffffffffa022e47d&gt;{:xfs:xfs_lookup+74}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa02371e0&gt;{:xfs:linvfs_lookup+48} &lt;ffffffff80189fc5&gt;{__lookup_hash+263}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffff8018a04f&gt;{lookup_one_len+94} &lt;ffffffffa03bd2bc&gt;{:nfsd:nfsd_lookup+936}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa03c55fa&gt;{:nfsd:nfsd3_proc_lookup+198}
&lt;ffffffffa03ba7dc&gt;{:nfsd:nfsd_dispatch+219}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa03474ac&gt;{:sunrpc:svc_process+1227}
&lt;ffffffff80134709&gt;{default_wake_function+0}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa03ba31b&gt;{:nfsd:nfsd+0} &lt;ffffffffa03ba553&gt;{:nfsd:nfsd+568}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffff80133470&gt;{schedule_tail+55} &lt;ffffffff80110fd3&gt;{child_rip+8}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffffa03ba31b&gt;{:nfsd:nfsd+0} &lt;ffffffffa03ba31b&gt;{:nfsd:nfsd+0}</font>
<br><font size=2 face="sans-serif">Jun 16 15:48:42 strmng04 kernel: &nbsp;
&nbsp; &nbsp; &nbsp;&lt;ffffffff80110fcb&gt;{child_rip+0}</font>
<br>
<br><font size=2 face="sans-serif">many of those. and at the end</font>
<br>
<br><font size=2 face="sans-serif">Jun 16 15:50:13 strmng04 kernel: xfs_force_shutdown(sdf1,0x8)
called from line 4092 of file /home/buildcentos/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_smp/xfs_bmap.c.
&nbsp;Return address</font>
<br><font size=2 face="sans-serif">&nbsp;= 0xffffffffa01f7fb4</font>
<br><font size=2 face="sans-serif">Jun 16 15:50:13 strmng04 kernel: Filesystem
&quot;sdf1&quot;: Corruption of in-memory data detected. &nbsp;Shutting
down filesystem: sdf1</font>
<br><font size=2 face="sans-serif">Jun 16 15:50:13 strmng04 kernel: Please
umount the filesystem, and rectify the problem(s)</font>
<br>
<br>
<br><font size=2 face="sans-serif">i have run xfs_check without any verbos
information given</font>
<br><font size=2 face="sans-serif">i have run xfs_repair without any information
errors fixed.</font>
<br>
<br><font size=2 face="sans-serif">when i try to mount the XFS filesystem
of 10TB, my 7.8 TB of data is now gone.</font>
<br>
<br><font size=2 face="Calibri">before: &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp;/dev/sdf1 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;10527858560 8801101708 1726756852 &nbsp;84% /D5</font>
<br><font size=2 face="Calibri">after: &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp;/dev/sdf1 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;10527858560 &nbsp; &nbsp; &nbsp; 528 10527858032 &nbsp; 1%
/D5</font>
<br>
<br><font size=2 face="Calibri">help, where did my data go, and how can
i get it back.</font>
--=_alternative 004919A2C1257745_=--


--===============8126672740807949309==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8126672740807949309==--
