Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q755kgJD137431 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 00:46:42 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id VIPK5aYHzIWrdsGB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 04 Aug 2012 22:46:39 -0700 (PDT)
References: <5017E426.2040709@profihost.ag> <20120804224336.GS2877@dastard>
In-Reply-To: <20120804224336.GS2877@dastard>
Mime-Version: 1.0 (1.0)
Message-Id: <C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: xfs_growfs / planned resize / performance impact
Date: Sun, 5 Aug 2012 07:46:33 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3385456761802703068=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============3385456761802703068==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative;
	boundary=Apple-Mail-3FC41BFA-C889-4588-9DF4-F1334EB3CD1B


--Apple-Mail-3FC41BFA-C889-4588-9DF4-F1334EB3CD1B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Am 05.08.2012 um 00:43 schrieb Dave Chinner <david@fromorbit.com>:

> On Tue, Jul 31, 2012 at 03:56:54PM +0200, Stefan Priebe - Profihost AG wro=
te:
>> Hello list,
>>=20
>> i'm planning to create a couple of VMs with just 30GB of space while
>> using xfs as the main filesystem.
>>=20
>> Now i alreay know that some of the VMs will grow up to 250GB while
>> resizing the block device and using xfs_growfs.
>=20
> Just use thin provisioning and make it 250GB to begin with. Thin
> provisioning mades filsystem grow/shrink pretty much redundant....

But dm thin isn't stable isn't it? Does xfs reallocate used parts of the blo=
ck
Device before using new parts? Otherwise deleting and recreating files will r=
esult in full used space pretty fast.

>> Is it a problem if this grow will happen in small portions (30GB =3D>
>> 50GB =3D> 75GB =3D> 100GB =3D> ... 300GB)?
>=20
> Growing a filesystem by an order of magnitude is the limit of what
> I'd suggest is sane. Growing it by two orders of magnitude
> (espcially if you start with a 16 AG filesystem because of stripe
> alignment) is going to cause problems with the number of AGs and
> the subsequent freespace management scale issue....
I would start with ag=3D4 and end up in ag 48 in my tests.

> Growing it by two orders of magnitude
what does that mean? (sorry no native speaker)

Thanks!

Stefan=

--Apple-Mail-3FC41BFA-C889-4588-9DF4-F1334EB3CD1B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head></head><body bgcolor=3D"#FFFFFF"><div>Am 05.08.2012 um 00:43 sch=
rieb Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit=
.com</a>&gt;:<br><br></div><div></div><blockquote type=3D"cite"><div><span>O=
n Tue, Jul 31, 2012 at 03:56:54PM +0200, Stefan Priebe - Profihost AG wrote:=
</span><br><blockquote type=3D"cite"><span>Hello list,</span><br></blockquot=
e><blockquote type=3D"cite"><span></span><br></blockquote><blockquote type=3D=
"cite"><span>i'm planning to create a couple of VMs with just 30GB of space w=
hile</span><br></blockquote><blockquote type=3D"cite"><span>using xfs as the=
 main filesystem.</span><br></blockquote><blockquote type=3D"cite"><span></s=
pan><br></blockquote><blockquote type=3D"cite"><span>Now i alreay know that s=
ome of the VMs will grow up to 250GB while</span><br></blockquote><blockquot=
e type=3D"cite"><span>resizing the block device and using xfs_growfs.</span>=
<br></blockquote><span></span><br><span>Just use thin provisioning and make i=
t 250GB to begin with. Thin</span><br><span>provisioning mades filsystem gro=
w/shrink pretty much redundant....</span><br></div></blockquote><div><br></d=
iv><div>But dm thin isn't stable isn't it? Does xfs reallocate used parts of=
 the block</div><div>Device before using new parts? Otherwise deleting and r=
ecreating files will result in full used space pretty fast.</div><br><blockq=
uote type=3D"cite"><div><span></span><blockquote type=3D"cite"><span>Is it a=
 problem if this grow will happen in small portions (30GB =3D&gt;</span><br>=
</blockquote><blockquote type=3D"cite"><span>50GB =3D&gt; 75GB =3D&gt; 100GB=
 =3D&gt; ... 300GB)?</span><br></blockquote><span></span><br><span>Growing a=
 filesystem by an order of magnitude is the limit of what</span><br><span>I'=
d suggest is sane. Growing it by two orders of magnitude</span><br><span>(es=
pcially if you start with a 16 AG filesystem because of stripe</span><br><sp=
an>alignment) is going to cause problems with the number of AGs and</span><b=
r><span>the subsequent freespace management scale issue....</span><br></div>=
</blockquote>I would start with ag=3D4 and end up in ag 48 in my tests.<div>=
<br></div><div><blockquote type=3D"cite"><div><font class=3D"Apple-style-spa=
n" color=3D"#000000">Growing it by two orders of magnitude</font></div></blo=
ckquote>what does that mean? (sorry no native speaker)</div><div><br></div><=
div>Thanks!<br><br><div>Stefan</div></div></body></html>=

--Apple-Mail-3FC41BFA-C889-4588-9DF4-F1334EB3CD1B--


--===============3385456761802703068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3385456761802703068==--
