Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 605B67F5A
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 23:54:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46B8E8F8035
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 21:54:08 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 4ujK7vpLlFtpNSR0 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 21:54:06 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.136366869818567@bugs.debian.org>
MIME-Version: 1.0
In-Reply-To: <20130318224814.GP6369@dastard>
References: <CAA0ZO6CtLRkgrpXqapg3B5oMwGdLq8tS3y4dYG47aYX5BZkA=g@mail.gmail.com>
	<20121211221419.GZ27055@sgi.com>
	<CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
	<CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
	<20130318224814.GP6369@dastard>
Date: Tue, 19 Mar 2013 15:51:30 +1100
Message-ID: <CAA0ZO6BVwPP9McKA=vn1+21gHpRCQP9P963nsSjY_zXHWeszrg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5326825068726295382=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: 695640@bugs.debian.org, Ben Myers <bpm@sgi.com>

--===============5326825068726295382==
Content-Type: multipart/alternative; boundary=089e013a2586ea48cc04d83fdbba

--089e013a2586ea48cc04d83fdbba
Content-Type: text/plain; charset=UTF-8

On 19 March 2013 09:48, Dave Chinner <david@fromorbit.com> wrote:

> > Did my strace output help diagnose this bug?
>
> No, but it's most likely the same problem as fixed in commit
> 19473a2ac. Can you add this to quota/quot.c:quot_init():
>
> +       quot_cmd.flags = CMD_FLAG_GLOBAL;
>
> And see if the problem goes away?
>

I made this change to the version in Debian squeeze.

I didn't see any change in behaviour :-(

hq ~ # xfs_quota  -x -c "quota -N -u brian" /home
xfs_quota: cannot find mount point for path `/share/systems': Success
xfs_quota: cannot find mount point for path `/share/cs': Success
xfs_quota: cannot find mount point for path `/share/cas': Success
xfs_quota: cannot find mount point for path `/share/cfcp': Success
xfs_quota: cannot find mount point for path `/share/lgs': Success
xfs_quota: cannot find mount point for path `/share/common': Success
xfs_quota: cannot find mount point for path `/share/summer': Success
/dev/mapper/hq-home    3800752          0          0   00 [--------] /home

Also tried the same patch against the latest git version, and got the same
problem.

--089e013a2586ea48cc04d83fdbba
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On 19 March 2013 09:48, Dave Chinner <span dir=3D"ltr">&lt=
;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.c=
om</a>&gt;</span> wrote:<br><div class=3D"gmail_extra"><div class=3D"gmail_=
quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:=
solid;padding-left:1ex">
<div class=3D"im">&gt; Did my strace output help diagnose this bug?<br>
<br>
</div>No, but it&#39;s most likely the same problem as fixed in commit<br>
19473a2ac. Can you add this to quota/quot.c:quot_init():<br>
<br>
+ =C2=A0 =C2=A0 =C2=A0 quot_cmd.flags =3D CMD_FLAG_GLOBAL;<br>
<br>
And see if the problem goes away?<br>
<div class=3D""><div class=3D"h5"></div></div></blockquote></div><br></div>=
<div class=3D"gmail_extra" style><font color=3D"#500050">I made this change=
 to the version in Debian squeeze.</font></div><div class=3D"gmail_extra" s=
tyle>
<font color=3D"#500050"><br></font></div><div class=3D"gmail_extra" style><=
font color=3D"#500050">I didn&#39;t see any change in behaviour :-(</font><=
/div><div class=3D"gmail_extra" style><font color=3D"#500050"><br></font></=
div><div class=3D"gmail_extra" style>
<font color=3D"#500050"><div class=3D"gmail_extra">hq ~ # xfs_quota =C2=A0-=
x -c &quot;quota -N -u brian&quot; /home=C2=A0</div><div class=3D"gmail_ext=
ra">xfs_quota: cannot find mount point for path `/share/systems&#39;: Succe=
ss</div><div class=3D"gmail_extra">
xfs_quota: cannot find mount point for path `/share/cs&#39;: Success</div><=
div class=3D"gmail_extra">xfs_quota: cannot find mount point for path `/sha=
re/cas&#39;: Success</div><div class=3D"gmail_extra">xfs_quota: cannot find=
 mount point for path `/share/cfcp&#39;: Success</div>
<div class=3D"gmail_extra">xfs_quota: cannot find mount point for path `/sh=
are/lgs&#39;: Success</div><div class=3D"gmail_extra">xfs_quota: cannot fin=
d mount point for path `/share/common&#39;: Success</div><div class=3D"gmai=
l_extra">
xfs_quota: cannot find mount point for path `/share/summer&#39;: Success</d=
iv><div class=3D"gmail_extra">/dev/mapper/hq-home =C2=A0 =C2=A03800752 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 00 [--------] /home</div><div><br></div><div style>Also tried the same pat=
ch against the latest git version, and got the same problem.</div>
</font></div></div>

--089e013a2586ea48cc04d83fdbba--


--===============5326825068726295382==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5326825068726295382==--
