Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBB2adKN032782 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 20:36:39 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id PuJ2wE79FW8ZXj7r (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Dec 2012 18:39:06 -0800 (PST)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B.13551933155212@bugs.debian.org>
MIME-Version: 1.0
Date: Tue, 11 Dec 2012 13:35:07 +1100
Message-ID: <CAA0ZO6CtLRkgrpXqapg3B5oMwGdLq8tS3y4dYG47aYX5BZkA=g@mail.gmail.com>
From: Brian May <brian@microcomaustralia.com.au>
Reply-To: Brian May <brian@microcomaustralia.com.au>, 695640@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6008248555560092570=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Debian Bug Tracking System <submit@bugs.debian.org>

--===============6008248555560092570==
Content-Type: multipart/alternative; boundary=e0cb4efa6dfcb7d6f404d08a879e

--e0cb4efa6dfcb7d6f404d08a879e
Content-Type: text/plain; charset=UTF-8

Package: xfsprogs
Version: 3.1.4


hq ~ # /usr/sbin/xfs_quota -x -c "quota -N -u brian" /home
xfs_quota: cannot find mount point for path `/share/systems': Success
xfs_quota: cannot find mount point for path `/share/cs': Success
xfs_quota: cannot find mount point for path `/share/cas': Success
xfs_quota: cannot find mount point for path `/share/cfcp': Success
xfs_quota: cannot find mount point for path `/share/lgs': Success
xfs_quota: cannot find mount point for path `/share/common': Success
xfs_quota: cannot find mount point for path `/share/summer': Success
/dev/mapper/hq-home    3763680          0          0   00 [--------] /home


Why is it complaining about success?

These messages only occurred after upgrading a lenny system to squeeze.


strace shows no errors at this point:

write(2, "xfs_quota: cannot find mount poi"..., 70xfs_quota: cannot find
mount point for path `/share/systems': Success
) = 70
stat64("/share/cs", {st_mode=S_IFDIR|S_ISGID|0755, st_size=118, ...}) = 0
write(2, "xfs_quota: cannot find mount poi"..., 65xfs_quota: cannot find
mount point for path `/share/cs': Success
) = 65
stat64("/share/cas", {st_mode=S_IFDIR|S_ISGID|0775, st_size=117, ...}) = 0
write(2, "xfs_quota: cannot find mount poi"..., 66xfs_quota: cannot find
mount point for path `/share/cas': Success
) = 66
stat64("/share/cfcp", {st_mode=S_IFDIR|S_ISGID|0755, st_size=99, ...}) = 0
write(2, "xfs_quota: cannot find mount poi"..., 67xfs_quota: cannot find
mount point for path `/share/cfcp': Success
) = 67
stat64("/share/lgs", {st_mode=S_IFDIR|S_ISGID|0750, st_size=89, ...}) = 0
write(2, "xfs_quota: cannot find mount poi"..., 66xfs_quota: cannot find
mount point for path `/share/lgs': Success
) = 66
stat64("/share/common", {st_mode=S_IFDIR|S_ISGID|0755, st_size=96, ...}) = 0
write(2, "xfs_quota: cannot find mount poi"..., 69xfs_quota: cannot find
mount point for path `/share/common': Success
) = 69
stat64("/share/summer", {st_mode=S_IFDIR|S_ISGID|0770, st_size=4096, ...})
= 0
write(2, "xfs_quota: cannot find mount poi"..., 69xfs_quota: cannot find
mount point for path `/share/summer': Success
) = 69


-- 
Brian May <brian@microcomaustralia.com.au>

--e0cb4efa6dfcb7d6f404d08a879e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Package: xfsprogs<div>Version:=C2=A03.1.4</div><div><br></div><div><br></di=
v><div><div>hq ~ # /usr/sbin/xfs_quota -x -c &quot;quota -N -u brian&quot; =
/home</div><div>xfs_quota: cannot find mount point for path `/share/systems=
&#39;: Success</div>
<div>xfs_quota: cannot find mount point for path `/share/cs&#39;: Success</=
div><div>xfs_quota: cannot find mount point for path `/share/cas&#39;: Succ=
ess</div><div>xfs_quota: cannot find mount point for path `/share/cfcp&#39;=
: Success</div>
<div>xfs_quota: cannot find mount point for path `/share/lgs&#39;: Success<=
/div><div>xfs_quota: cannot find mount point for path `/share/common&#39;: =
Success</div><div>xfs_quota: cannot find mount point for path `/share/summe=
r&#39;: Success</div>
<div>/dev/mapper/hq-home =C2=A0 =C2=A03763680 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 00 [--------] /home</div=
><div><br></div><div><br></div><div>Why is it complaining about success?</d=
iv><div><br></div><div>These messages only occurred after upgrading a lenny=
 system to squeeze.</div>
<div><br></div><div><br></div><div>strace shows no errors at this point:</d=
iv><div><br></div><div><div>write(2, &quot;xfs_quota: cannot find mount poi=
&quot;..., 70xfs_quota: cannot find mount point for path `/share/systems&#3=
9;: Success</div>
<div>) =3D 70</div><div>stat64(&quot;/share/cs&quot;, {st_mode=3DS_IFDIR|S_=
ISGID|0755, st_size=3D118, ...}) =3D 0</div><div>write(2, &quot;xfs_quota: =
cannot find mount poi&quot;..., 65xfs_quota: cannot find mount point for pa=
th `/share/cs&#39;: Success</div>
<div>) =3D 65</div><div>stat64(&quot;/share/cas&quot;, {st_mode=3DS_IFDIR|S=
_ISGID|0775, st_size=3D117, ...}) =3D 0</div><div>write(2, &quot;xfs_quota:=
 cannot find mount poi&quot;..., 66xfs_quota: cannot find mount point for p=
ath `/share/cas&#39;: Success</div>
<div>) =3D 66</div><div>stat64(&quot;/share/cfcp&quot;, {st_mode=3DS_IFDIR|=
S_ISGID|0755, st_size=3D99, ...}) =3D 0</div><div>write(2, &quot;xfs_quota:=
 cannot find mount poi&quot;..., 67xfs_quota: cannot find mount point for p=
ath `/share/cfcp&#39;: Success</div>
<div>) =3D 67</div><div>stat64(&quot;/share/lgs&quot;, {st_mode=3DS_IFDIR|S=
_ISGID|0750, st_size=3D89, ...}) =3D 0</div><div>write(2, &quot;xfs_quota: =
cannot find mount poi&quot;..., 66xfs_quota: cannot find mount point for pa=
th `/share/lgs&#39;: Success</div>
<div>) =3D 66</div><div>stat64(&quot;/share/common&quot;, {st_mode=3DS_IFDI=
R|S_ISGID|0755, st_size=3D96, ...}) =3D 0</div><div>write(2, &quot;xfs_quot=
a: cannot find mount poi&quot;..., 69xfs_quota: cannot find mount point for=
 path `/share/common&#39;: Success</div>
<div>) =3D 69</div><div>stat64(&quot;/share/summer&quot;, {st_mode=3DS_IFDI=
R|S_ISGID|0770, st_size=3D4096, ...}) =3D 0</div><div>write(2, &quot;xfs_qu=
ota: cannot find mount poi&quot;..., 69xfs_quota: cannot find mount point f=
or path `/share/summer&#39;: Success</div>
<div>) =3D 69</div></div><div><br></div><div><br></div>-- <br>Brian May &lt=
;<a href=3D"mailto:brian@microcomaustralia.com.au" target=3D"_blank">brian@=
microcomaustralia.com.au</a>&gt;<br>
</div>

--e0cb4efa6dfcb7d6f404d08a879e--


--===============6008248555560092570==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6008248555560092570==--
