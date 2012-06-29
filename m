Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5T4kSac092408 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 23:46:28 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	YgQj7XNAuHVfIp2v (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Jun 2012 21:46:25 -0700 (PDT)
Received: by obbup19 with SMTP id up19so4471037obb.26
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 21:46:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F79E9F3.6010305@sandeen.net>
References: <CANoMt5NBie68Auyj_V-6QZBbtLPzKu_sWsTFCceO3dYhJu5uZg@mail.gmail.com>
	<4F763734.9040906@sandeen.net>
	<CANoMt5O5T+FTrmL-2c5tsT=wm434iVNeFarPdybcs1q_oPtW=g@mail.gmail.com>
	<4F79E9F3.6010305@sandeen.net>
Date: Fri, 29 Jun 2012 12:46:24 +0800
Message-ID: <CAPnto6zUScA9u0rBW4i-BqeBnY1MK09J_H8J2R1KCtE1cYy0Rg@mail.gmail.com>
Subject: Re: XFS Kernel Panics in CentOS
From: Changliang Chen <hqucocl@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2880262635873579423=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Mark Rechler <mrechler@brightcove.com>

--===============2880262635873579423==
Content-Type: multipart/alternative; boundary=14dae934064f68c1f304c39521b0

--14dae934064f68c1f304c39521b0
Content-Type: text/plain; charset=ISO-8859-1

Hi Eric,

    Is this issue resolved? We have  been getting the same problem, though
we had upgrated the kernel to 2.6.18-308.8.2.el5.

On Tue, Apr 3, 2012 at 2:03 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/2/12 8:09 AM, Mark Rechler wrote:
> > Hi Eric,
> >
> > Thank you for the reply. We are running CentOS 5.8, with the
> > 2.6.18-164.10.1.el5.centos.plus kernel as it was mentioned in a bug
> > report that has similar behavior, but ultimately a different kernel
> > panic (http://bugs.centos.org/view.php?id=4089). We have tried
> > running xfs_repair in the past and it has not proved useful. The odd
> > part is that these are fresh systems (just installed). If it helps,
> > we are also running glusterfs on these boxes though load does not
> > always correlate to a kernel panic.
>
> I can't say for sure what's in that respun "extra" centos kernel,
> but I can say this:  the error you hit indicates that xfs read a
> buffer, and wound up with a metadata buffer which had unrecognized
> magic - i.e. it did not look like metadata as expected.  Seeing what
> looks like corruption, it shut down.
>
> This reminds me a little of
> https://bugzilla.redhat.com/show_bug.cgi?id=512552
> which I fixed for RHEL customers a while back, where cancelled
> readahead in MD was resulting in xfs thinking a buffer was
> uptodate, but in fact it was uninitialized, hence it found
> garbage and shut down in this way.
>
> Something similar seems to be happening in your case, if xfs_repair
> comes up clean; somehow xfs is getting hold of a buffer which
> apparently doesn't match what xfs_repair found to be a consistent
> filesystem.
>
> So I might suspect something in the storage stack?
>
> Also please be sure you don't have kmod-xfs or xfs-kmod installed
> on your centos box, which is a truly ancient and completely unsupported
> backport of xfs from long, long ago.
>
> -Eric
>
> > Thanks,
> > Mark
> >
> > On Fri, Mar 30, 2012 at 6:44 PM, Eric Sandeen <sandeen@sandeen.net<mailto:
> sandeen@sandeen.net>> wrote:
> >
> >     On 3/30/12 5:02 PM, Mark Rechler wrote:
> >     > Hi Everyone,
> >     >
> >     > We've been getting a lot of errors (across several kernels) and
> eventually a kernel panic. Any insight into these errors would be much
> appreciated.
> >     >
> >     > Errors:
> >     > Filesystem "dm-3": XFS internal error xfs_da_do_buf(2) at line
> 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff883c1826
> >
> >     Saying which CentOS it is would help ;)  And, standard disclaimers
> about how CentOS doesn't come with upstream _or_ distro support, etc etc...
> >
> >     But xfs_da_do_buf(2) indicates on-disk corruption, having
> encountered a bad magic number when reading from the disk.  Have you tried
> xfs_repair?
> >
> >     -Eric
> >
> >     > Call Trace:
> >     >  [<ffffffff883c1725>] :xfs:xfs_da_do_buf+0x503/0x5b1
> >     >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
> >     >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
> >     >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
> >     >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
> >     >  [<ffffffff883aec7f>] :xfs:xfs_attr_fetch+0xa3/0xd5
> >     >  [<ffffffff883a7aa8>] :xfs:xfs_acl_iaccess+0x64/0xd4
> >     >  [<ffffffff883f264a>] :xfs:xfs_check_acl+0x1b/0x2b
> >     >  [<ffffffff8000f550>] generic_permission+0x40/0xca
> >     >  [<ffffffff8000d902>] permission+0x81/0xc8
> >     >  [<ffffffff8000999d>] __link_path_walk+0x173/0xf42
> >     >  [<ffffffff8000e9cc>] link_path_walk+0x42/0xb2
> >     >  [<ffffffff8000cc9c>] do_path_lookup+0x275/0x2f1
> >     >  [<ffffffff8001278e>] getname+0x15b/0x1c2
> >     >  [<ffffffff800236f6>] __user_walk_fd+0x37/0x4c
> >     >  [<ffffffff8003f1f6>] vfs_lstat_fd+0x18/0x47
> >     >  [<ffffffff8008c46e>] default_wake_function+0x0/0xe
> >     >  [<ffffffff800efddf>] sys_lgetxattr+0x4e/0x5f
> >     >  [<ffffffff8002a996>] sys_newlstat+0x19/0x31
> >     >  [<ffffffff8005d229>] tracesys+0x71/0xe0
> >     >  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
> >     >
> >     > Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 65
> >     > RIP [<ffffffffff8841bfaf>]
> :xfs:xfs_attr_shortform_getvalue+0x24/0xe2
> >     >   RSP <ffff81020752dbc8>
> >     > CR2: 00000000000002
> >     >   <0>Kernel panic - not syncing: Fatal exception
> >     >
> >     > Thanks,
> >     > Mark
> >     >
> >     >
> >     > _______________________________________________
> >     > xfs mailing list
> >     > xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
> >     > http://oss.sgi.com/mailman/listinfo/xfs
> >
> >
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 

Regards,

Cocl
ops manager
19lou Operation & Maintenance Dept

--14dae934064f68c1f304c39521b0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Eric,<div><br></div><div>=A0 =A0 Is this issue <font face=3D"Verdana, Ar=
ial, Helvetica, sans-serif">resolved? We have=A0</font>
<span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:1=
3px;background-color:rgb(255,255,255)">been getting the same problem,</span=
>=A0though we had upgrated the kernel to=A02.6.18-308.8.2.el5.<font face=3D=
"Verdana, Arial, Helvetica, sans-serif"><br>
</font><br><div class=3D"gmail_quote">On Tue, Apr 3, 2012 at 2:03 AM, Eric =
Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On 4/2/12 8:09 AM, Mark Rechler wrote:<br>
&gt; Hi Eric,<br>
&gt;<br>
&gt; Thank you for the reply. We are running CentOS 5.8, with the<br>
&gt; 2.6.18-164.10.1.el5.centos.plus kernel as it was mentioned in a bug<br=
>
&gt; report that has similar behavior, but ultimately a different kernel<br=
>
&gt; panic (<a href=3D"http://bugs.centos.org/view.php?id=3D4089" target=3D=
"_blank">http://bugs.centos.org/view.php?id=3D4089</a>). We have tried<br>
&gt; running xfs_repair in the past and it has not proved useful. The odd<b=
r>
&gt; part is that these are fresh systems (just installed). If it helps,<br=
>
&gt; we are also running glusterfs on these boxes though load does not<br>
&gt; always correlate to a kernel panic.<br>
<br>
</div>I can&#39;t say for sure what&#39;s in that respun &quot;extra&quot; =
centos kernel,<br>
but I can say this: =A0the error you hit indicates that xfs read a<br>
buffer, and wound up with a metadata buffer which had unrecognized<br>
magic - i.e. it did not look like metadata as expected. =A0Seeing what<br>
looks like corruption, it shut down.<br>
<br>
This reminds me a little of<br>
<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D512552" target=3D"=
_blank">https://bugzilla.redhat.com/show_bug.cgi?id=3D512552</a><br>
which I fixed for RHEL customers a while back, where cancelled<br>
readahead in MD was resulting in xfs thinking a buffer was<br>
uptodate, but in fact it was uninitialized, hence it found<br>
garbage and shut down in this way.<br>
<br>
Something similar seems to be happening in your case, if xfs_repair<br>
comes up clean; somehow xfs is getting hold of a buffer which<br>
apparently doesn&#39;t match what xfs_repair found to be a consistent<br>
filesystem.<br>
<br>
So I might suspect something in the storage stack?<br>
<br>
Also please be sure you don&#39;t have kmod-xfs or xfs-kmod installed<br>
on your centos box, which is a truly ancient and completely unsupported<br>
backport of xfs from long, long ago.<br>
<br>
-Eric<br>
<br>
&gt; Thanks,<br>
&gt; Mark<br>
<div><div class=3D"h5">&gt;<br>
&gt; On Fri, Mar 30, 2012 at 6:44 PM, Eric Sandeen &lt;<a href=3D"mailto:sa=
ndeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt; =A0 =A0 On 3/30/12 5:02 PM, Mark Rechler wrote:<br>
&gt; =A0 =A0 &gt; Hi Everyone,<br>
&gt; =A0 =A0 &gt;<br>
&gt; =A0 =A0 &gt; We&#39;ve been getting a lot of errors (across several ke=
rnels) and eventually a kernel panic. Any insight into these errors would b=
e much appreciated.<br>
&gt; =A0 =A0 &gt;<br>
&gt; =A0 =A0 &gt; Errors:<br>
&gt; =A0 =A0 &gt; Filesystem &quot;dm-3&quot;: XFS internal error xfs_da_do=
_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c. =A0Caller 0xffffffff883=
c1826<br>
&gt;<br>
&gt; =A0 =A0 Saying which CentOS it is would help ;) =A0And, standard discl=
aimers about how CentOS doesn&#39;t come with upstream _or_ distro support,=
 etc etc...<br>
&gt;<br>
&gt; =A0 =A0 But xfs_da_do_buf(2) indicates on-disk corruption, having enco=
untered a bad magic number when reading from the disk. =A0Have you tried xf=
s_repair?<br>
&gt;<br>
&gt; =A0 =A0 -Eric<br>
&gt;<br>
&gt; =A0 =A0 &gt; Call Trace:<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883c1725&gt;] :xfs:xfs_da_do_buf+0x503/0x=
5b1<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_buf+0x16/0=
x1b<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_buf+0x16/0=
x1b<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf_get+0x2e=
/0x99<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf_get+0x2e=
/0x99<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883aec7f&gt;] :xfs:xfs_attr_fetch+0xa3/0x=
d5<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883a7aa8&gt;] :xfs:xfs_acl_iaccess+0x64/0=
xd4<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff883f264a&gt;] :xfs:xfs_check_acl+0x1b/0x2=
b<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8000f550&gt;] generic_permission+0x40/0xc=
a<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8000d902&gt;] permission+0x81/0xc8<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8000999d&gt;] __link_path_walk+0x173/0xf4=
2<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8000e9cc&gt;] link_path_walk+0x42/0xb2<br=
>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8000cc9c&gt;] do_path_lookup+0x275/0x2f1<=
br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8001278e&gt;] getname+0x15b/0x1c2<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff800236f6&gt;] __user_walk_fd+0x37/0x4c<br=
>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8003f1f6&gt;] vfs_lstat_fd+0x18/0x47<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8008c46e&gt;] default_wake_function+0x0/0=
xe<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff800efddf&gt;] sys_lgetxattr+0x4e/0x5f<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8002a996&gt;] sys_newlstat+0x19/0x31<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8005d229&gt;] tracesys+0x71/0xe0<br>
&gt; =A0 =A0 &gt; =A0[&lt;ffffffff8005d28d&gt;] tracesys+0xd5/0xe0<br>
&gt; =A0 =A0 &gt;<br>
&gt; =A0 =A0 &gt; Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 =
44 3b 65<br>
&gt; =A0 =A0 &gt; RIP [&lt;ffffffffff8841bfaf&gt;] :xfs:xfs_attr_shortform_=
getvalue+0x24/0xe2<br>
&gt; =A0 =A0 &gt; =A0 RSP &lt;ffff81020752dbc8&gt;<br>
&gt; =A0 =A0 &gt; CR2: 00000000000002<br>
&gt; =A0 =A0 &gt; =A0 &lt;0&gt;Kernel panic - not syncing: Fatal exception<=
br>
&gt; =A0 =A0 &gt;<br>
&gt; =A0 =A0 &gt; Thanks,<br>
&gt; =A0 =A0 &gt; Mark<br>
&gt; =A0 =A0 &gt;<br>
&gt; =A0 =A0 &gt;<br>
&gt; =A0 =A0 &gt; _______________________________________________<br>
&gt; =A0 =A0 &gt; xfs mailing list<br>
</div></div>&gt; =A0 =A0 &gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sg=
i.com</a> &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>=
&gt;<br>
&gt; =A0 =A0 &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" targe=
t=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt;<br>
&gt;<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<br>Regards,<br><br>Cocl<br>ops manager<br>19lou Operation &amp; Maintenanc=
e Dept<br>
</div>

--14dae934064f68c1f304c39521b0--


--===============2880262635873579423==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2880262635873579423==--
