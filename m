Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3C667F4E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 00:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8474F8F8035
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 22:06:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DA3CuWpBJwBbsWR6 for <xfs@oss.sgi.com>;
	Sun, 26 Oct 2014 22:06:38 -0700 (PDT)
References: <544DBA20.5040206@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <544DBA20.5040206@gmail.com>
Message-Id: <310E5304-F3A5-44D4-AB50-2EF041C40949@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfs_setattr_size is mid-stack during log-flooding stack traces
Date: Mon, 27 Oct 2014 00:06:35 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5556780690629252599=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============5556780690629252599==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-8523212C-B8D5-4963-80DD-DA969287C274
Content-Transfer-Encoding: 7bit


--Apple-Mail-8523212C-B8D5-4963-80DD-DA969287C274
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

See "[vfs] WARNING: CPU: 3 PID: 2339 at mm/truncate.c:758 pagecache_isize_ex=
tended+0xdd/0x120()" sent earlier today.

-Eric

> On Oct 26, 2014, at 10:21 PM, "Michael L. Semon" <mlsemon35@gmail.com> wro=
te:
>=20
> Hi!  I was having fantastic luck with v5/finobt XFS and kernel
> 3.18.0-rc1, so I decided to disable quota support and debug support
> in XFS...
>=20
> [    0.000000] Linux version 3.18.0-rc1+ (root@kyhorse) (gcc version 4.8.3=
 (GCC) ) #5 SMP Sun Oct 26 14:43:09 EDT 2014
> # i686 Pentium 4, BTW.
> [    0.857655] SGI XFS with ACLs, security attributes, no debug enabled
>=20
> Some other debug items were shut off as well.
>=20
> Now, my logs are getting pelted with items that look like this (first trac=
e,
> on boot):
>=20
> [   14.549583] XFS (sda1): Mounting V5 Filesystem
> [   14.810908] XFS (sda1): Ending clean mount
> [   14.826918] mount (155) used greatest stack depth: 6056 bytes left
> [   15.139152] rc.S (64) used greatest stack depth: 5948 bytes left
> [   29.443780] ------------[ cut here ]------------
> [   29.443801] WARNING: CPU: 0 PID: 387 at mm/truncate.c:758 pagecache_isi=
ze_extended+0x124/0x129()
> [   29.443809] CPU: 0 PID: 387 Comm: gtk-query-immod Not tainted 3.18.0-rc=
1+ #5
> [   29.443813] Hardware name: Gateway                         E-2000      =
                   /D845GRG                        , BIOS RG84510A.15A.0009.=
P03.020
> [   29.443817]  00000000 00000000 ee1e9e20 c144939c 00000000 ee1e9e50 c103=
1b03 c154f66c
> [   29.443828]  00000000 00000183 c1553739 000002f6 c1098458 c1098458 e849=
ed54 00000000
> [   29.443838]  00001000 ee1e9e60 c1031bb8 00000009 00000000 ee1e9e98 c109=
8458 efd69100
> [   29.443848] Call Trace:
> [   29.443858]  [<c144939c>] dump_stack+0x41/0x52
> [   29.443867]  [<c1031b03>] warn_slowpath_common+0x6f/0x86
> [   29.443873]  [<c1098458>] ? pagecache_isize_extended+0x124/0x129
> [   29.443878]  [<c1098458>] ? pagecache_isize_extended+0x124/0x129
> [   29.443884]  [<c1031bb8>] warn_slowpath_null+0x1d/0x1f
> [   29.443889]  [<c1098458>] pagecache_isize_extended+0x124/0x129
> [   29.443895]  [<c1098494>] truncate_setsize+0x37/0x50
> [   29.443902]  [<c117c534>] xfs_setattr_size+0x13d/0x3d6
> [   29.443909]  [<c116a2ed>] ? __xfs_get_blocks+0x5ff/0x5ff
> [   29.443916]  [<c1172c13>] xfs_file_fallocate+0x2fe/0x340
> [   29.443922]  [<c1444ccc>] ? kmemleak_free+0x20/0x43
> [   29.443931]  [<c10ba00d>] ? kmem_cache_free+0x76/0xc4
> [   29.443938]  [<c10bd802>] do_fallocate+0x111/0x18a
> [   29.443943]  [<c10bd8cb>] SyS_fallocate+0x50/0x70
> [   29.443950]  [<c144f6ef>] syscall_call+0x7/0x7
> [   29.443954] ---[ end trace 281f0f955c16f86c ]---
>=20
> In an xfstests run, it seemed to start with generic/012 and hit a
> great many tests after that.  The actual BUG_ON is somewhere in
> mm/truncate.c, though...
>=20
>        WARN_ON(!mutex_is_locked(&inode->i_mutex));
>=20
> Is this an XFS issue at all?  Or is there some kind of extra
> precaution that has to be taken on the XFS side?  Feel free to toss
> me over to mm to ask, "What is this?"
>=20
> Thanks!
>=20
> Michael
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>=20

--Apple-Mail-8523212C-B8D5-4963-80DD-DA969287C274
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div>See "<span style=3D"font-size: 12pt; f=
ont-family: Helvetica;">[vfs] WARNING: CPU: 3 PID: 2339 at mm/truncate.c:758=
 pagecache_isize_extended+0xdd/0x120()" sent earlier today.</span></div><div=
><p style=3D"margin: 0px; font-size: 12px; font-family: Helvetica;"><span st=
yle=3D"font-size: 12pt;"><br></span></p><p style=3D"margin: 0px; font-size: 1=
2px; font-family: Helvetica;"><span style=3D"font-size: 12pt;">-Eric</span><=
/p><p style=3D"margin: 0px; font-size: 12px; font-family: Helvetica;"><span s=
tyle=3D"font-size: 12pt;"><br></span></p>On Oct 26, 2014, at 10:21 PM, "Mich=
ael L. Semon" &lt;<a href=3D"mailto:mlsemon35@gmail.com">mlsemon35@gmail.com=
</a>&gt; wrote:<br><br></div><blockquote type=3D"cite"><div><span>Hi! &nbsp;=
I was having fantastic luck with v5/finobt XFS and kernel</span><br><span>3.=
18.0-rc1, so I decided to disable quota support and debug support</span><br>=
<span>in XFS...</span><br><span></span><br><span>[ &nbsp;&nbsp;&nbsp;0.00000=
0] Linux version 3.18.0-rc1+ (root@kyhorse) (gcc version 4.8.3 (GCC) ) #5 SM=
P Sun Oct 26 14:43:09 EDT 2014</span><br><span># i686 Pentium 4, BTW.</span>=
<br><span>[ &nbsp;&nbsp;&nbsp;0.857655] SGI XFS with ACLs, security attribut=
es, no debug enabled</span><br><span></span><br><span>Some other debug items=
 were shut off as well.</span><br><span></span><br><span>Now, my logs are ge=
tting pelted with items that look like this (first trace,</span><br><span>on=
 boot):</span><br><span></span><br><span>[ &nbsp;&nbsp;14.549583] XFS (sda1)=
: Mounting V5 Filesystem</span><br><span>[ &nbsp;&nbsp;14.810908] XFS (sda1)=
: Ending clean mount</span><br><span>[ &nbsp;&nbsp;14.826918] mount (155) us=
ed greatest stack depth: 6056 bytes left</span><br><span>[ &nbsp;&nbsp;15.13=
9152] rc.S (64) used greatest stack depth: 5948 bytes left</span><br><span>[=
 &nbsp;&nbsp;29.443780] ------------[ cut here ]------------</span><br><span=
>[ &nbsp;&nbsp;29.443801] WARNING: CPU: 0 PID: 387 at mm/truncate.c:758 page=
cache_isize_extended+0x124/0x129()</span><br><span>[ &nbsp;&nbsp;29.443809] C=
PU: 0 PID: 387 Comm: gtk-query-immod Not tainted 3.18.0-rc1+ #5</span><br><s=
pan>[ &nbsp;&nbsp;29.443813] Hardware name: Gateway &nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;E-2000 &nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/D845GRG &nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;, BIOS RG84510A.15A.0009.P03.020</span=
><br><span>[ &nbsp;&nbsp;29.443817] &nbsp;00000000 00000000 ee1e9e20 c144939=
c 00000000 ee1e9e50 c1031b03 c154f66c</span><br><span>[ &nbsp;&nbsp;29.44382=
8] &nbsp;00000000 00000183 c1553739 000002f6 c1098458 c1098458 e849ed54 0000=
0000</span><br><span>[ &nbsp;&nbsp;29.443838] &nbsp;00001000 ee1e9e60 c1031b=
b8 00000009 00000000 ee1e9e98 c1098458 efd69100</span><br><span>[ &nbsp;&nbs=
p;29.443848] Call Trace:</span><br><span>[ &nbsp;&nbsp;29.443858] &nbsp;[&lt=
;c144939c&gt;] dump_stack+0x41/0x52</span><br><span>[ &nbsp;&nbsp;29.443867]=
 &nbsp;[&lt;c1031b03&gt;] warn_slowpath_common+0x6f/0x86</span><br><span>[ &=
nbsp;&nbsp;29.443873] &nbsp;[&lt;c1098458&gt;] ? pagecache_isize_extended+0x=
124/0x129</span><br><span>[ &nbsp;&nbsp;29.443878] &nbsp;[&lt;c1098458&gt;] ?=
 pagecache_isize_extended+0x124/0x129</span><br><span>[ &nbsp;&nbsp;29.44388=
4] &nbsp;[&lt;c1031bb8&gt;] warn_slowpath_null+0x1d/0x1f</span><br><span>[ &=
nbsp;&nbsp;29.443889] &nbsp;[&lt;c1098458&gt;] pagecache_isize_extended+0x12=
4/0x129</span><br><span>[ &nbsp;&nbsp;29.443895] &nbsp;[&lt;c1098494&gt;] tr=
uncate_setsize+0x37/0x50</span><br><span>[ &nbsp;&nbsp;29.443902] &nbsp;[&lt=
;c117c534&gt;] xfs_setattr_size+0x13d/0x3d6</span><br><span>[ &nbsp;&nbsp;29=
.443909] &nbsp;[&lt;c116a2ed&gt;] ? __xfs_get_blocks+0x5ff/0x5ff</span><br><=
span>[ &nbsp;&nbsp;29.443916] &nbsp;[&lt;c1172c13&gt;] xfs_file_fallocate+0x=
2fe/0x340</span><br><span>[ &nbsp;&nbsp;29.443922] &nbsp;[&lt;c1444ccc&gt;] ?=
 kmemleak_free+0x20/0x43</span><br><span>[ &nbsp;&nbsp;29.443931] &nbsp;[&lt=
;c10ba00d&gt;] ? kmem_cache_free+0x76/0xc4</span><br><span>[ &nbsp;&nbsp;29.=
443938] &nbsp;[&lt;c10bd802&gt;] do_fallocate+0x111/0x18a</span><br><span>[ &=
nbsp;&nbsp;29.443943] &nbsp;[&lt;c10bd8cb&gt;] SyS_fallocate+0x50/0x70</span=
><br><span>[ &nbsp;&nbsp;29.443950] &nbsp;[&lt;c144f6ef&gt;] syscall_call+0x=
7/0x7</span><br><span>[ &nbsp;&nbsp;29.443954] ---[ end trace 281f0f955c16f8=
6c ]---</span><br><span></span><br><span>In an xfstests run, it seemed to st=
art with generic/012 and hit a</span><br><span>great many tests after that. &=
nbsp;The actual BUG_ON is somewhere in</span><br><span>mm/truncate.c, though=
...</span><br><span></span><br><span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;WARN_ON(!mutex_is_locked(&amp;inode-&gt;i_mutex));</span><br><span></spa=
n><br><span>Is this an XFS issue at all? &nbsp;Or is there some kind of extr=
a</span><br><span>precaution that has to be taken on the XFS side? &nbsp;Fee=
l free to toss</span><br><span>me over to mm to ask, "What is this?"</span><=
br><span></span><br><span>Thanks!</span><br><span></span><br><span>Michael</=
span><br><span></span><br><span>____________________________________________=
___</span><br><span>xfs mailing list</span><br><span><a href=3D"mailto:xfs@o=
ss.sgi.com">xfs@oss.sgi.com</a></span><br><span><a href=3D"http://oss.sgi.co=
m/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a></span><b=
r><span></span><br></div></blockquote></body></html>=

--Apple-Mail-8523212C-B8D5-4963-80DD-DA969287C274--


--===============5556780690629252599==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5556780690629252599==--
