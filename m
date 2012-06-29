Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5T4w8mJ093332 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 23:58:08 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	e1HHaFBsY2dOeBJx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Jun 2012 21:58:06 -0700 (PDT)
Received: by obbup19 with SMTP id up19so4485521obb.26
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 21:58:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6B9C8E2F-0AD3-4C99-A671-5FB603F8577A@sandeen.net>
References: <CANoMt5NBie68Auyj_V-6QZBbtLPzKu_sWsTFCceO3dYhJu5uZg@mail.gmail.com>
	<4F763734.9040906@sandeen.net>
	<CANoMt5O5T+FTrmL-2c5tsT=wm434iVNeFarPdybcs1q_oPtW=g@mail.gmail.com>
	<4F79E9F3.6010305@sandeen.net>
	<CAPnto6zUScA9u0rBW4i-BqeBnY1MK09J_H8J2R1KCtE1cYy0Rg@mail.gmail.com>
	<6B9C8E2F-0AD3-4C99-A671-5FB603F8577A@sandeen.net>
Date: Fri, 29 Jun 2012 12:58:05 +0800
Message-ID: <CAPnto6yxng9chxFW6UogxUMKuNAFqu6cJY5xgax0dgsNucosNg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4461826091667910371=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Mark Rechler <mrechler@brightcove.com>

--===============4461826091667910371==
Content-Type: multipart/alternative; boundary=14dae9340b8d280ab804c3954b40

--14dae9340b8d280ab804c3954b40
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi=EF=BC=8C

   We sure that we haven't installed the xfs kmod,and the modinfo are:

# modinfo xfs
filename:       /lib/modules/2.6.18-308.8.2.el5/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, large block/inode
numbers, no debug enabled
author:         Silicon Graphics, Inc.
srcversion:     D37A003AFEE1A42BDD4DD56
depends:
vermagic:       2.6.18-308.8.2.el5 SMP mod_unload gcc-4.1
module_sig:
883f3504fd752a1a91bf303215fc9511247a309f792a2c9d45673dbc457399198719262a501=
35f0a083e666c424dff9de84f1f5eff01e607decb4921e

On Fri, Jun 29, 2012 at 12:52 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On Jun 29, 2012, at 12:46 AM, Changliang Chen <hqucocl@gmail.com> wrote:
>
> Hi Eric,
>
>     Is this issue resolved? We have  been getting the same problem, thoug=
h
> we had upgrated the kernel to 2.6.18-308.8.2.el5.
>
> I do not know; if it were rhel I'd suggest logging a support ticket.  I'v=
e
> not seen anything similar on rhel.
>
> Did you make sure there is no xfs kmod rpm installed?  What does modinfo
> xfs say?
>
> On Tue, Apr 3, 2012 at 2:03 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> On 4/2/12 8:09 AM, Mark Rechler wrote:
>> > Hi Eric,
>> >
>> > Thank you for the reply. We are running CentOS 5.8, with the
>> > 2.6.18-164.10.1.el5.centos.plus kernel as it was mentioned in a bug
>> > report that has similar behavior, but ultimately a different kernel
>> > panic (http://bugs.centos.org/view.php?id=3D4089). We have tried
>> > running xfs_repair in the past and it has not proved useful. The odd
>> > part is that these are fresh systems (just installed). If it helps,
>> > we are also running glusterfs on these boxes though load does not
>> > always correlate to a kernel panic.
>>
>> I can't say for sure what's in that respun "extra" centos kernel,
>> but I can say this:  the error you hit indicates that xfs read a
>> buffer, and wound up with a metadata buffer which had unrecognized
>> magic - i.e. it did not look like metadata as expected.  Seeing what
>> looks like corruption, it shut down.
>>
>> This reminds me a little of
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D512552
>> which I fixed for RHEL customers a while back, where cancelled
>> readahead in MD was resulting in xfs thinking a buffer was
>> uptodate, but in fact it was uninitialized, hence it found
>> garbage and shut down in this way.
>>
>> Something similar seems to be happening in your case, if xfs_repair
>> comes up clean; somehow xfs is getting hold of a buffer which
>> apparently doesn't match what xfs_repair found to be a consistent
>> filesystem.
>>
>> So I might suspect something in the storage stack?
>>
>> Also please be sure you don't have kmod-xfs or xfs-kmod installed
>> on your centos box, which is a truly ancient and completely unsupported
>> backport of xfs from long, long ago.
>>
>> -Eric
>>
>> > Thanks,
>> > Mark
>> >
>> > On Fri, Mar 30, 2012 at 6:44 PM, Eric Sandeen <sandeen@sandeen.net<mai=
lto:
>> sandeen@sandeen.net>> wrote:
>> >
>> >     On 3/30/12 5:02 PM, Mark Rechler wrote:
>> >     > Hi Everyone,
>> >     >
>> >     > We've been getting a lot of errors (across several kernels) and
>> eventually a kernel panic. Any insight into these errors would be much
>> appreciated.
>> >     >
>> >     > Errors:
>> >     > Filesystem "dm-3": XFS internal error xfs_da_do_buf(2) at line
>> 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff883c1826
>> >
>> >     Saying which CentOS it is would help ;)  And, standard disclaimers
>> about how CentOS doesn't come with upstream _or_ distro support, etc etc=
...
>> >
>> >     But xfs_da_do_buf(2) indicates on-disk corruption, having
>> encountered a bad magic number when reading from the disk.  Have you tri=
ed
>> xfs_repair?
>> >
>> >     -Eric
>> >
>> >     > Call Trace:
>> >     >  [<ffffffff883c1725>] :xfs:xfs_da_do_buf+0x503/0x5b1
>> >     >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
>> >     >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
>> >     >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
>> >     >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
>> >     >  [<ffffffff883aec7f>] :xfs:xfs_attr_fetch+0xa3/0xd5
>> >     >  [<ffffffff883a7aa8>] :xfs:xfs_acl_iaccess+0x64/0xd4
>> >     >  [<ffffffff883f264a>] :xfs:xfs_check_acl+0x1b/0x2b
>> >     >  [<ffffffff8000f550>] generic_permission+0x40/0xca
>> >     >  [<ffffffff8000d902>] permission+0x81/0xc8
>> >     >  [<ffffffff8000999d>] __link_path_walk+0x173/0xf42
>> >     >  [<ffffffff8000e9cc>] link_path_walk+0x42/0xb2
>> >     >  [<ffffffff8000cc9c>] do_path_lookup+0x275/0x2f1
>> >     >  [<ffffffff8001278e>] getname+0x15b/0x1c2
>> >     >  [<ffffffff800236f6>] __user_walk_fd+0x37/0x4c
>> >     >  [<ffffffff8003f1f6>] vfs_lstat_fd+0x18/0x47
>> >     >  [<ffffffff8008c46e>] default_wake_function+0x0/0xe
>> >     >  [<ffffffff800efddf>] sys_lgetxattr+0x4e/0x5f
>> >     >  [<ffffffff8002a996>] sys_newlstat+0x19/0x31
>> >     >  [<ffffffff8005d229>] tracesys+0x71/0xe0
>> >     >  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
>> >     >
>> >     > Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 6=
5
>> >     > RIP [<ffffffffff8841bfaf>]
>> :xfs:xfs_attr_shortform_getvalue+0x24/0xe2
>> >     >   RSP <ffff81020752dbc8>
>> >     > CR2: 00000000000002
>> >     >   <0>Kernel panic - not syncing: Fatal exception
>> >     >
>> >     > Thanks,
>> >     > Mark
>> >     >
>> >     >
>> >     > _______________________________________________
>> >     > xfs mailing list
>> >     > xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>> >     > http://oss.sgi.com/mailman/listinfo/xfs
>> >
>> >
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>
>
> --
>
> Regards,
>
> Cocl
> ops manager
> 19lou Operation & Maintenance Dept
>
>


--=20

Regards,

Cocl
ops manager
19lou Operation & Maintenance Dept

--14dae9340b8d280ab804c3954b40
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi=EF=BC=8C<div>=C2=A0</div><div>=C2=A0 =C2=A0We sure that we haven&#39;t i=
nstalled the xfs kmod,and the modinfo are:</div><div><br></div><div><div># =
modinfo xfs</div><div>filename: =C2=A0 =C2=A0 =C2=A0 /lib/modules/2.6.18-30=
8.8.2.el5/kernel/fs/xfs/xfs.ko</div>
<div>license: =C2=A0 =C2=A0 =C2=A0 =C2=A0GPL</div><div>description: =C2=A0 =
=C2=A0SGI XFS with ACLs, security attributes, large block/inode numbers, no=
 debug enabled</div><div>author: =C2=A0 =C2=A0 =C2=A0 =C2=A0 Silicon Graphi=
cs, Inc.</div><div>srcversion: =C2=A0 =C2=A0 D37A003AFEE1A42BDD4DD56</div>
<div>depends: =C2=A0 =C2=A0 =C2=A0 =C2=A0</div><div>vermagic: =C2=A0 =C2=A0=
 =C2=A0 2.6.18-308.8.2.el5 SMP mod_unload gcc-4.1</div><div>module_sig: =C2=
=A0 =C2=A0 883f3504fd752a1a91bf303215fc9511247a309f792a2c9d45673dbc45739919=
8719262a50135f0a083e666c424dff9de84f1f5eff01e607decb4921e</div>
</div><div><br><div class=3D"gmail_quote">On Fri, Jun 29, 2012 at 12:52 PM,=
 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" =
target=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">
<div bgcolor=3D"#FFFFFF"><div class=3D"im"><div>On Jun 29, 2012, at 12:46 A=
M, Changliang Chen &lt;<a href=3D"mailto:hqucocl@gmail.com" target=3D"_blan=
k">hqucocl@gmail.com</a>&gt; wrote:<br><br></div><div></div><blockquote typ=
e=3D"cite">
<div>Hi Eric,<div><br></div><div>=C2=A0 =C2=A0 Is this issue <font face=3D"=
Verdana, Arial, Helvetica, sans-serif">resolved? We have=C2=A0</font>
<span style=3D"color:rgb(34,34,34);font-size:13px;font-family:arial,sans-se=
rif">been getting the same problem,</span>=C2=A0though we had upgrated the =
kernel to=C2=A02.6.18-308.8.2.el5.<font face=3D"Verdana, Arial, Helvetica, =
sans-serif"><br>

</font><br></div></div></blockquote></div>I do not know; if it were rhel I&=
#39;d suggest logging a support ticket. =C2=A0I&#39;ve not seen anything si=
milar on rhel.<div><br></div><div>Did you make sure there is no xfs kmod rp=
m installed? =C2=A0What does modinfo xfs say?</div>
<div><div class=3D"h5"><div><br><blockquote type=3D"cite"><div><div><div cl=
ass=3D"gmail_quote">On Tue, Apr 3, 2012 at 2:03 AM, Eric Sandeen <span dir=
=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sande=
en@sandeen.net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<div>On 4/2/12 8:09 AM, Mark Rechler wrote:<br>
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
but I can say this: =C2=A0the error you hit indicates that xfs read a<br>
buffer, and wound up with a metadata buffer which had unrecognized<br>
magic - i.e. it did not look like metadata as expected. =C2=A0Seeing what<b=
r>
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
<div><div>&gt;<br>
&gt; On Fri, Mar 30, 2012 at 6:44 PM, Eric Sandeen &lt;<a href=3D"mailto:sa=
ndeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a> &lt;mailto:<a =
href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</=
a>&gt;&gt; wrote:<br>

&gt;<br>
&gt; =C2=A0 =C2=A0 On 3/30/12 5:02 PM, Mark Rechler wrote:<br>
&gt; =C2=A0 =C2=A0 &gt; Hi Everyone,<br>
&gt; =C2=A0 =C2=A0 &gt;<br>
&gt; =C2=A0 =C2=A0 &gt; We&#39;ve been getting a lot of errors (across seve=
ral kernels) and eventually a kernel panic. Any insight into these errors w=
ould be much appreciated.<br>
&gt; =C2=A0 =C2=A0 &gt;<br>
&gt; =C2=A0 =C2=A0 &gt; Errors:<br>
&gt; =C2=A0 =C2=A0 &gt; Filesystem &quot;dm-3&quot;: XFS internal error xfs=
_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c. =C2=A0Caller 0xff=
ffffff883c1826<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 Saying which CentOS it is would help ;) =C2=A0And, stand=
ard disclaimers about how CentOS doesn&#39;t come with upstream _or_ distro=
 support, etc etc...<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 But xfs_da_do_buf(2) indicates on-disk corruption, havin=
g encountered a bad magic number when reading from the disk. =C2=A0Have you=
 tried xfs_repair?<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 -Eric<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 &gt; Call Trace:<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883c1725&gt;] :xfs:xfs_da_do_buf=
+0x503/0x5b1<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_b=
uf+0x16/0x1b<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883c1826&gt;] :xfs:xfs_da_read_b=
uf+0x16/0x1b<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf=
_get+0x2e/0x99<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883aeb71&gt;] :xfs:xfs_attr_leaf=
_get+0x2e/0x99<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883aec7f&gt;] :xfs:xfs_attr_fetc=
h+0xa3/0xd5<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883a7aa8&gt;] :xfs:xfs_acl_iacce=
ss+0x64/0xd4<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff883f264a&gt;] :xfs:xfs_check_acl=
+0x1b/0x2b<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8000f550&gt;] generic_permission=
+0x40/0xca<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8000d902&gt;] permission+0x81/0x=
c8<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8000999d&gt;] __link_path_walk+0=
x173/0xf42<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8000e9cc&gt;] link_path_walk+0x4=
2/0xb2<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8000cc9c&gt;] do_path_lookup+0x2=
75/0x2f1<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8001278e&gt;] getname+0x15b/0x1c=
2<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff800236f6&gt;] __user_walk_fd+0x3=
7/0x4c<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8003f1f6&gt;] vfs_lstat_fd+0x18/=
0x47<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8008c46e&gt;] default_wake_funct=
ion+0x0/0xe<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff800efddf&gt;] sys_lgetxattr+0x4e=
/0x5f<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8002a996&gt;] sys_newlstat+0x19/=
0x31<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8005d229&gt;] tracesys+0x71/0xe0=
<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0[&lt;ffffffff8005d28d&gt;] tracesys+0xd5/0xe0=
<br>
&gt; =C2=A0 =C2=A0 &gt;<br>
&gt; =C2=A0 =C2=A0 &gt; Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f =
b6 Z3 44 3b 65<br>
&gt; =C2=A0 =C2=A0 &gt; RIP [&lt;ffffffffff8841bfaf&gt;] :xfs:xfs_attr_shor=
tform_getvalue+0x24/0xe2<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0 RSP &lt;ffff81020752dbc8&gt;<br>
&gt; =C2=A0 =C2=A0 &gt; CR2: 00000000000002<br>
&gt; =C2=A0 =C2=A0 &gt; =C2=A0 &lt;0&gt;Kernel panic - not syncing: Fatal e=
xception<br>
&gt; =C2=A0 =C2=A0 &gt;<br>
&gt; =C2=A0 =C2=A0 &gt; Thanks,<br>
&gt; =C2=A0 =C2=A0 &gt; Mark<br>
&gt; =C2=A0 =C2=A0 &gt;<br>
&gt; =C2=A0 =C2=A0 &gt;<br>
&gt; =C2=A0 =C2=A0 &gt; _______________________________________________<br>
&gt; =C2=A0 =C2=A0 &gt; xfs mailing list<br>
</div></div>&gt; =C2=A0 =C2=A0 &gt; <a href=3D"mailto:xfs@oss.sgi.com" targ=
et=3D"_blank">xfs@oss.sgi.com</a> &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.=
com" target=3D"_blank">xfs@oss.sgi.com</a>&gt;<br>
&gt; =C2=A0 =C2=A0 &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<div><div>&gt;<br>
&gt;<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<br>Regards,<br><br>Cocl<br>ops manager<br>19lou Operation &amp; Maintenanc=
e Dept<br>
</div>
</div></blockquote></div></div></div></div></blockquote></div><br><br clear=
=3D"all"><div><br></div>-- <br><br>Regards,<br><br>Cocl<br>ops manager<br>1=
9lou Operation &amp; Maintenance Dept<br>
</div>

--14dae9340b8d280ab804c3954b40--


--===============4461826091667910371==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4461826091667910371==--
