Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32FA3nH194816 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 10:10:03 -0500
Received: from na3sys009aog109.obsmtp.com (na3sys009aog109.obsmtp.com
	[74.125.149.201]) by cuda.sgi.com with SMTP id gzgy8NgCzL1O6NWB
	for <xfs@oss.sgi.com>; Mon, 02 Apr 2012 08:09:59 -0700 (PDT)
Received: by dacx6 with SMTP id x6so2373476dac.4
	for <xfs@oss.sgi.com>; Mon, 02 Apr 2012 08:09:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F763734.9040906@sandeen.net>
References: <CANoMt5NBie68Auyj_V-6QZBbtLPzKu_sWsTFCceO3dYhJu5uZg@mail.gmail.com>
	<4F763734.9040906@sandeen.net>
Date: Mon, 2 Apr 2012 11:09:58 -0400
Message-ID: <CANoMt5O5T+FTrmL-2c5tsT=wm434iVNeFarPdybcs1q_oPtW=g@mail.gmail.com>
Subject: Re: XFS Kernel Panics in CentOS
From: Mark Rechler <mrechler@brightcove.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7131827530227365951=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============7131827530227365951==
Content-Type: multipart/alternative; boundary=14dae93404fb63127904bcb39510

--14dae93404fb63127904bcb39510
Content-Type: text/plain; charset=ISO-8859-1

Hi Eric,

Thank you for the reply. We are running CentOS 5.8, with the
2.6.18-164.10.1.el5.centos.plus kernel as it was mentioned in a bug report
that has similar behavior, but ultimately a different kernel panic (
http://bugs.centos.org/view.php?id=4089). We have tried running xfs_repair
in the past and it has not proved useful. The odd part is that these are
fresh systems (just installed). If it helps, we are also running glusterfs
on these boxes though load does not always correlate to a kernel panic.

Thanks,
Mark

On Fri, Mar 30, 2012 at 6:44 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/30/12 5:02 PM, Mark Rechler wrote:
> > Hi Everyone,
> >
> > We've been getting a lot of errors (across several kernels) and
> eventually a kernel panic. Any insight into these errors would be much
> appreciated.
> >
> > Errors:
> > Filesystem "dm-3": XFS internal error xfs_da_do_buf(2) at line 2112 of
> file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff883c1826
>
> Saying which CentOS it is would help ;)  And, standard disclaimers about
> how CentOS doesn't come with upstream _or_ distro support, etc etc...
>
> But xfs_da_do_buf(2) indicates on-disk corruption, having encountered a
> bad magic number when reading from the disk.  Have you tried xfs_repair?
>
> -Eric
>
> > Call Trace:
> >  [<ffffffff883c1725>] :xfs:xfs_da_do_buf+0x503/0x5b1
> >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
> >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
> >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
> >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
> >  [<ffffffff883aec7f>] :xfs:xfs_attr_fetch+0xa3/0xd5
> >  [<ffffffff883a7aa8>] :xfs:xfs_acl_iaccess+0x64/0xd4
> >  [<ffffffff883f264a>] :xfs:xfs_check_acl+0x1b/0x2b
> >  [<ffffffff8000f550>] generic_permission+0x40/0xca
> >  [<ffffffff8000d902>] permission+0x81/0xc8
> >  [<ffffffff8000999d>] __link_path_walk+0x173/0xf42
> >  [<ffffffff8000e9cc>] link_path_walk+0x42/0xb2
> >  [<ffffffff8000cc9c>] do_path_lookup+0x275/0x2f1
> >  [<ffffffff8001278e>] getname+0x15b/0x1c2
> >  [<ffffffff800236f6>] __user_walk_fd+0x37/0x4c
> >  [<ffffffff8003f1f6>] vfs_lstat_fd+0x18/0x47
> >  [<ffffffff8008c46e>] default_wake_function+0x0/0xe
> >  [<ffffffff800efddf>] sys_lgetxattr+0x4e/0x5f
> >  [<ffffffff8002a996>] sys_newlstat+0x19/0x31
> >  [<ffffffff8005d229>] tracesys+0x71/0xe0
> >  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
> >
> > Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 65
> > RIP [<ffffffffff8841bfaf>] :xfs:xfs_attr_shortform_getvalue+0x24/0xe2
> >   RSP <ffff81020752dbc8>
> > CR2: 00000000000002
> >   <0>Kernel panic - not syncing: Fatal exception
> >
> > Thanks,
> > Mark
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--14dae93404fb63127904bcb39510
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Eric,<br><br>Thank you for the reply. We are running CentOS 5.8, with th=
e 2.6.18-164.10.1.el5.centos.plus kernel as it was mentioned in a bug repor=
t that has similar behavior, but ultimately a different kernel panic (<a hr=
ef=3D"http://bugs.centos.org/view.php?id=3D4089">http://bugs.centos.org/vie=
w.php?id=3D4089</a>). We have tried running xfs_repair in the past and it h=
as not proved useful. The odd part is that these are fresh systems (just in=
stalled). If it helps, we are also running glusterfs on these boxes though =
load does not always correlate to a kernel panic.<br>
<br>Thanks,<br>Mark<br><br><div class=3D"gmail_quote">On Fri, Mar 30, 2012 =
at 6:44 PM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sa=
ndeen.net">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On 3/30/12 5:02 PM, Mark Rechler wrote:<br>
&gt; Hi Everyone,<br>
&gt;<br>
&gt; We&#39;ve been getting a lot of errors (across several kernels) and ev=
entually a kernel panic. Any insight into these errors would be much apprec=
iated.<br>
&gt;<br>
&gt; Errors:<br>
&gt; Filesystem &quot;dm-3&quot;: XFS internal error xfs_da_do_buf(2) at li=
ne 2112 of file fs/xfs/xfs_da_btree.c. =A0Caller 0xffffffff883c1826<br>
<br>
</div>Saying which CentOS it is would help ;) =A0And, standard disclaimers =
about how CentOS doesn&#39;t come with upstream _or_ distro support, etc et=
c...<br>
<br>
But xfs_da_do_buf(2) indicates on-disk corruption, having encountered a bad=
 magic number when reading from the disk. =A0Have you tried xfs_repair?<br>
<br>
-Eric<br>
<div><div class=3D"h5"><br>
&gt; Call Trace:<br>
&gt; =A0[&lt;ffffffff883c1725&gt;] :xfs:xfs_da_do_buf+0x503/0x5b1<br>
&gt; =A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_buf+0x16/0x1b<br>
&gt; =A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_buf+0x16/0x1b<br>
&gt; =A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf_get+0x2e/0x99<br>
&gt; =A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf_get+0x2e/0x99<br>
&gt; =A0[&lt;ffffffff883aec7f&gt;] :xfs:xfs_attr_fetch+0xa3/0xd5<br>
&gt; =A0[&lt;ffffffff883a7aa8&gt;] :xfs:xfs_acl_iaccess+0x64/0xd4<br>
&gt; =A0[&lt;ffffffff883f264a&gt;] :xfs:xfs_check_acl+0x1b/0x2b<br>
&gt; =A0[&lt;ffffffff8000f550&gt;] generic_permission+0x40/0xca<br>
&gt; =A0[&lt;ffffffff8000d902&gt;] permission+0x81/0xc8<br>
&gt; =A0[&lt;ffffffff8000999d&gt;] __link_path_walk+0x173/0xf42<br>
&gt; =A0[&lt;ffffffff8000e9cc&gt;] link_path_walk+0x42/0xb2<br>
&gt; =A0[&lt;ffffffff8000cc9c&gt;] do_path_lookup+0x275/0x2f1<br>
&gt; =A0[&lt;ffffffff8001278e&gt;] getname+0x15b/0x1c2<br>
&gt; =A0[&lt;ffffffff800236f6&gt;] __user_walk_fd+0x37/0x4c<br>
&gt; =A0[&lt;ffffffff8003f1f6&gt;] vfs_lstat_fd+0x18/0x47<br>
&gt; =A0[&lt;ffffffff8008c46e&gt;] default_wake_function+0x0/0xe<br>
&gt; =A0[&lt;ffffffff800efddf&gt;] sys_lgetxattr+0x4e/0x5f<br>
&gt; =A0[&lt;ffffffff8002a996&gt;] sys_newlstat+0x19/0x31<br>
&gt; =A0[&lt;ffffffff8005d229&gt;] tracesys+0x71/0xe0<br>
&gt; =A0[&lt;ffffffff8005d28d&gt;] tracesys+0xd5/0xe0<br>
&gt;<br>
&gt; Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 65<br>
&gt; RIP [&lt;ffffffffff8841bfaf&gt;] :xfs:xfs_attr_shortform_getvalue+0x24=
/0xe2<br>
&gt; =A0 RSP &lt;ffff81020752dbc8&gt;<br>
&gt; CR2: 00000000000002<br>
&gt; =A0 &lt;0&gt;Kernel panic - not syncing: Fatal exception<br>
&gt;<br>
&gt; Thanks,<br>
&gt; Mark<br>
&gt;<br>
&gt;<br>
</div></div>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br>

--14dae93404fb63127904bcb39510--


--===============7131827530227365951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7131827530227365951==--
