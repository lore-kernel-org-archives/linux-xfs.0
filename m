Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE69A7F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 18:42:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9DEE7304032
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 16:42:07 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id M9HlJOjhK26AuJBq (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 16:42:06 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.136624189830432@bugs.debian.org>
MIME-Version: 1.0
In-Reply-To: <20130320110935.GE17758@dastard>
References: <CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
	<CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
	<20130318224814.GP6369@dastard>
	<CAA0ZO6BVwPP9McKA=vn1+21gHpRCQP9P963nsSjY_zXHWeszrg@mail.gmail.com>
	<20130319063104.GA6369@dastard>
	<CAA0ZO6AxFzinTv_COhK6GqnRpSiYW95otznKvYKiWZB5+=CyBg@mail.gmail.com>
	<20130320110935.GE17758@dastard>
Date: Thu, 18 Apr 2013 09:38:11 +1000
Message-ID: <CAA0ZO6B8O2LN55K8b=ajptzxD=H7GMTd3RCwwD--jhUBUGWMjw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============8921348247744015126=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: 695640@bugs.debian.org, Ben Myers <bpm@sgi.com>

--===============8921348247744015126==
Content-Type: multipart/alternative; boundary=089e011776eb9eb79e04da96fa23

--089e011776eb9eb79e04da96fa23
Content-Type: text/plain; charset=UTF-8

Oops. Just realized I still hadn't responded. Sorry.


On 20 March 2013 22:09, Dave Chinner <david@fromorbit.com> wrote:

> > > # xfs_quota  -x -c "quota -N -u brian"
> >
> > This prints the quota information 20 times. Huh?
>
> How many mount points do you have? 20?
>

No. More actually. Today I get

hq ~ # cat /proc/mounts  | wc --lines
34
hq ~ # xfs_quota  -x -c "quota -N -u brian" | wc --lines
44
hq ~ # xfs_quota  -x -c "quota -N -u brian" /home /share | wc --lines
4


> The command has once for each of the mount points, and the command
> itself iterates mount points because you haven't given it a mount
> point to look at. So, double iteration.  This same problem was fixed
> for the report command by setting it to be a global command i.e. the
> fix I mentioned previously that you tested should prevent this
> second case, and maybe even the first.
>

As far as I can tell this happens with the patched xfs_quota.

hq /home/brian/xfsprogs # git diff
diff --git a/quota/quot.c b/quota/quot.c
index a7782b4..6cb665d 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -418,6 +418,7 @@ quot_init(void)
        quot_cmd.args = _("[-bir] [-gpu] [-acv] [-f file]");
        quot_cmd.oneline = _("summarize filesystem ownership");
        quot_cmd.help = quot_help;
+       quot_cmd.flags = CMD_FLAG_GLOBAL;

        if (expert)
                add_command(&quot_cmd);

As this version is based on git, I just did a git pull:

hq /home/brian/xfsprogs # git pull
Updating b326e06..64ae7fc
Fast-forward
 mkfs/xfs_mkfs.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

Doesn't look related to this, don't think I need to retest.
-- 
Brian May <brian@microcomaustralia.com.au>

--089e011776eb9eb79e04da96fa23
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Oops. Just realized I still hadn&#39;t responded. Sorry.<b=
r><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On 20 March=
 2013 22:09, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fro=
morbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D"im">&gt; &gt; # xfs_quota =C2=A0-x -c &quot;=
quota -N -u brian&quot;<br>
</div><div class=3D"im">
&gt;<br>
&gt; This prints the quota information 20 times. Huh?<br>
<br>
</div>How many mount points do you have? 20?<br></blockquote><div><br></div=
><div style>No. More actually. Today I get</div><div style><br></div><div>h=
q ~ # cat /proc/mounts =C2=A0| wc --lines</div><div>34</div><div>hq ~ # xfs=
_quota =C2=A0-x -c &quot;quota -N -u brian&quot; | wc --lines</div>
<div>44</div><div><div>hq ~ # xfs_quota =C2=A0-x -c &quot;quota -N -u brian=
&quot; /home /share | wc --lines</div><div>4</div></div><div style>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:sol=
id;padding-left:1ex">
<div class=3D"im"><span style=3D"color:rgb(34,34,34)">The command has once =
for each of the mount points, and the command</span><br></div>
itself iterates mount points because you haven&#39;t given it a mount<br>
point to look at. So, double iteration. =C2=A0This same problem was fixed<b=
r>
for the report command by setting it to be a global command i.e. the<br>
fix I mentioned previously that you tested should prevent this<br>
second case, and maybe even the first.<br></blockquote><div><br></div><div =
style>As far as I can tell this happens with the patched xfs_quota.</div><d=
iv style><br></div><div style><div>hq /home/brian/xfsprogs # git diff</div>
<div>diff --git a/quota/quot.c b/quota/quot.c</div><div>index a7782b4..6cb6=
65d 100644</div><div>--- a/quota/quot.c</div><div>+++ b/quota/quot.c</div><=
div>@@ -418,6 +418,7 @@ quot_init(void)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 quot_cmd.args =3D _(&quot;[-bir] [-gpu] [-acv] [-f file]&quot;);</div>
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 quot_cmd.oneline =3D _(&quot;summarize fil=
esystem ownership&quot;);</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 quot_cmd.he=
lp =3D quot_help;</div><div>+ =C2=A0 =C2=A0 =C2=A0 quot_cmd.flags =3D CMD_F=
LAG_GLOBAL;</div><div>=C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (expe=
rt)</div>
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 add_command(&a=
mp;quot_cmd);</div><div><br></div><div style>As this version is based on gi=
t, I just did a git pull:</div><div style><br></div><div style><div>hq /hom=
e/brian/xfsprogs # git pull</div><div>
Updating b326e06..64ae7fc</div><div>Fast-forward</div><div>=C2=A0mkfs/xfs_m=
kfs.c | =C2=A0 18 ++++++++++++++++++</div><div>=C2=A01 files changed, 18 in=
sertions(+), 0 deletions(-)</div><div><br></div><div style>Doesn&#39;t look=
 related to this, don&#39;t think I need to retest.</div>
</div></div></div>-- <br>Brian May &lt;<a href=3D"mailto:brian@microcomaust=
ralia.com.au" target=3D"_blank">brian@microcomaustralia.com.au</a>&gt;
</div></div>

--089e011776eb9eb79e04da96fa23--


--===============8921348247744015126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8921348247744015126==--
