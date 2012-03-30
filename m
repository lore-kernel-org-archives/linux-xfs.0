Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UM35s5212570 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 17:03:05 -0500
Received: from na3sys009aog112.obsmtp.com (na3sys009aog112.obsmtp.com
	[74.125.149.207]) by cuda.sgi.com with SMTP id slyHX5ZeCXYgorz3
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 15:02:56 -0700 (PDT)
Received: by pbcuo15 with SMTP id uo15so2743962pbc.11
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 15:02:55 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Mar 2012 18:02:55 -0400
Message-ID: <CANoMt5NBie68Auyj_V-6QZBbtLPzKu_sWsTFCceO3dYhJu5uZg@mail.gmail.com>
Subject: XFS Kernel Panics in CentOS
From: Mark Rechler <mrechler@brightcove.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8773941950340157211=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8773941950340157211==
Content-Type: multipart/alternative; boundary=047d7b33d88cb64fd504bc7d0021

--047d7b33d88cb64fd504bc7d0021
Content-Type: text/plain; charset=ISO-8859-1

Hi Everyone,

We've been getting a lot of errors (across several kernels) and eventually
a kernel panic. Any insight into these errors would be much appreciated.

Errors:
Filesystem "dm-3": XFS internal error xfs_da_do_buf(2) at line 2112 of file
fs/xfs/xfs_da_btree.c.  Caller 0xffffffff883c1826

Call Trace:
 [<ffffffff883c1725>] :xfs:xfs_da_do_buf+0x503/0x5b1
 [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
 [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
 [<ffffffff883aec7f>] :xfs:xfs_attr_fetch+0xa3/0xd5
 [<ffffffff883a7aa8>] :xfs:xfs_acl_iaccess+0x64/0xd4
 [<ffffffff883f264a>] :xfs:xfs_check_acl+0x1b/0x2b
 [<ffffffff8000f550>] generic_permission+0x40/0xca
 [<ffffffff8000d902>] permission+0x81/0xc8
 [<ffffffff8000999d>] __link_path_walk+0x173/0xf42
 [<ffffffff8000e9cc>] link_path_walk+0x42/0xb2
 [<ffffffff8000cc9c>] do_path_lookup+0x275/0x2f1
 [<ffffffff8001278e>] getname+0x15b/0x1c2
 [<ffffffff800236f6>] __user_walk_fd+0x37/0x4c
 [<ffffffff8003f1f6>] vfs_lstat_fd+0x18/0x47
 [<ffffffff8008c46e>] default_wake_function+0x0/0xe
 [<ffffffff800efddf>] sys_lgetxattr+0x4e/0x5f
 [<ffffffff8002a996>] sys_newlstat+0x19/0x31
 [<ffffffff8005d229>] tracesys+0x71/0xe0
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0

Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 65
RIP [<ffffffffff8841bfaf>] :xfs:xfs_attr_shortform_getvalue+0x24/0xe2
  RSP <ffff81020752dbc8>
CR2: 00000000000002
  <0>Kernel panic - not syncing: Fatal exception

Thanks,
Mark

--047d7b33d88cb64fd504bc7d0021
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Everyone,<br><br>We&#39;ve been getting a lot of errors (across several =
kernels) and eventually a kernel panic. Any insight into these errors would=
 be much appreciated.<br><br>Errors:<br>Filesystem &quot;dm-3&quot;: XFS in=
ternal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.=
=A0 Caller 0xffffffff883c1826<br>
<br>Call Trace:<br>=A0[&lt;ffffffff883c1725&gt;] :xfs:xfs_da_do_buf+0x503/0=
x5b1<br>=A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_buf+0x16/0x1b<br>=A0=
[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_buf+0x16/0x1b<br>=A0[&lt;ffffff=
ff883aeb71&gt;] :xfs:xfs_attr_leaf_get+0x2e/0x99<br>
=A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf_get+0x2e/0x99<br>=A0[&lt;f=
fffffff883aec7f&gt;] :xfs:xfs_attr_fetch+0xa3/0xd5<br>=A0[&lt;ffffffff883a7=
aa8&gt;] :xfs:xfs_acl_iaccess+0x64/0xd4<br>=A0[&lt;ffffffff883f264a&gt;] :x=
fs:xfs_check_acl+0x1b/0x2b<br>
=A0[&lt;ffffffff8000f550&gt;] generic_permission+0x40/0xca<br>=A0[&lt;fffff=
fff8000d902&gt;] permission+0x81/0xc8<br>=A0[&lt;ffffffff8000999d&gt;] __li=
nk_path_walk+0x173/0xf42<br>=A0[&lt;ffffffff8000e9cc&gt;] link_path_walk+0x=
42/0xb2<br>
=A0[&lt;ffffffff8000cc9c&gt;] do_path_lookup+0x275/0x2f1<br>=A0[&lt;fffffff=
f8001278e&gt;] getname+0x15b/0x1c2<br>=A0[&lt;ffffffff800236f6&gt;] __user_=
walk_fd+0x37/0x4c<br>=A0[&lt;ffffffff8003f1f6&gt;] vfs_lstat_fd+0x18/0x47<b=
r>=A0[&lt;ffffffff8008c46e&gt;] default_wake_function+0x0/0xe<br>
=A0[&lt;ffffffff800efddf&gt;] sys_lgetxattr+0x4e/0x5f<br>=A0[&lt;ffffffff80=
02a996&gt;] sys_newlstat+0x19/0x31<br>=A0[&lt;ffffffff8005d229&gt;] tracesy=
s+0x71/0xe0<br>=A0[&lt;ffffffff8005d28d&gt;] tracesys+0xd5/0xe0<br><br>Code=
: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 65<br>
RIP [&lt;ffffffffff8841bfaf&gt;] :xfs:xfs_attr_shortform_getvalue+0x24/0xe2=
<br>=A0 RSP &lt;ffff81020752dbc8&gt;<br>CR2: 00000000000002<br>=A0 &lt;0&gt=
;Kernel panic - not syncing: Fatal exception<br><br>Thanks,<br>Mark<br>

--047d7b33d88cb64fd504bc7d0021--


--===============8773941950340157211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8773941950340157211==--
