Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55FB27CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:19:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 293A68F8040
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:19:57 -0700 (PDT)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com
	[209.85.214.54]) by cuda.sgi.com with ESMTP id kv6Jeb4tUfrZKkEu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2016 06:19:54 -0700 (PDT)
Received: by mail-it0-f54.google.com with SMTP id e62so89603559ita.1
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:19:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160510061054.GI26977@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<20160510061054.GI26977@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 1 Jun 2016 15:19:34 +0200
Message-ID: <CACj3i715X7X65=BjSW8GZLhUF-YjQVShC-_Udmxe24XB1ACb1w@mail.gmail.com>
Subject: Re: [PATCH 00/19 v2] mkfs cleaning
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3147238390785758349=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============3147238390785758349==
Content-Type: multipart/alternative; boundary=001a11449b2860ead7053437581e

--001a11449b2860ead7053437581e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, May 10, 2016 at 8:10 AM, Dave Chinner <david@fromorbit.com> wrote:

>
> Looking at xfstests runs, new failures are:
>
> generic/054 -
> generic/055 - both fail with:
>
> +*** mkfs failed: -l version=3D2,su=3D4096 ***
>
> and the .full file has this specific error:
>
> Illegal value 4096 for -l su option. value is too small
>
> indicating that we should be allowing (2^N * block size) log
> stripe units to be set. This will be a limit configuration issue,
> most likely needing fixing in mkfs.
>

=E2=80=8BI'm looking on it, but this issue was introduced by Eric's fix for
patch "mkfs:
table based parsing for converted parameters":

=E2=80=8B> =E2=80=8B
The kernel enforces a max of XLOG_MAX_RECORD_BSIZE,
=E2=80=8B> =E2=80=8B
and it should match the limits in L_SUNIT after all ...

And looking on fs/xfs/xfs_super.c, the MIN value is enforced too. So maybe
it is the test what needs fixing? Otherwise, I would put something
like XFS_MIN_SECTORSIZE there.

See http://lxr.free-electrons.com/source/fs/xfs/xfs_super.c#L435



>
> xfs/096 6s ... - output mismatch (see
> /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad)
>     --- tests/xfs/096.out       2016-04-05 11:11:36.814382107 +1000
>     +++ /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad
> 2016-05-10 12:54:25.956199714 +1000
>     @@ -2,18 +2,62 @@
>
>      # su too big but must be a multiple of fs block size too
>      --- mkfs=3D-l version=3D2,su=3D262656 ---
>     -log stripe unit (262656) must be a multiple of the block size (4096)
>     +Illegal value 262656 for -l su option. value is too large
>     +Usage: mkfs.xfs
>     +/* blocksize */            [-b log=3Dn|size=3Dnum]
>     ...
>     (Run 'diff -u tests/xfs/096.out
> /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad'  to see the
> entire diff)
>
> This test is explicitly testing an invalid value, checking that it
> falls back to a sane default. This patchset has changed the
> behaviour, so the xfstest will need some rework to handle both old
> and new mkfs behaviour.
>
> Can you send patches to fix all these up?
>

=E2=80=8BSure.

Jan
=E2=80=8B



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11449b2860ead7053437581e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Tue, Ma=
y 10, 2016 at 8:10 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span></div><div class=3D"gmail_extra"><div class=
=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-style:solid;border-left-color:r=
gb(204,204,204);padding-left:1ex"><span class=3D""><br>
</span>Looking at xfstests runs, new failures are:<br>
<br>
generic/054 -<br>
generic/055 - both fail with:<br>
<br>
+*** mkfs failed: -l version=3D2,su=3D4096 ***<br>
<br>
and the .full file has this specific error:<br>
<br>
Illegal value 4096 for -l su option. value is too small<br>
<br>
indicating that we should be allowing (2^N * block size) log<br>
stripe units to be set. This will be a limit configuration issue,<br>
most likely needing fixing in mkfs.<br></blockquote><div><br></div><div><di=
v class=3D"gmail_default"><font face=3D"arial, helvetica, sans-serif">=E2=
=80=8BI&#39;m looking on it, but this issue was introduced by Eric&#39;s fi=
x for patch=C2=A0</font>&quot;mkfs: table based parsing for converted param=
eters&quot;:</div></div><br><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;display:inline">=E2=80=8B&gt; =E2=80=8B</div>=
The kernel enforces a max of XLOG_MAX_RECORD_BSIZE,<br><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=
=E2=80=8B&gt; =E2=80=8B</div>and it should match the limits in L_SUNIT afte=
r all ...</div><div class=3D"gmail_quote"><br></div><div class=3D"gmail_quo=
te"><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif">And looking on=C2=A0fs/xfs/xfs_super.c, the MIN value is enforced to=
o. So maybe it is the test what needs fixing? Otherwise, I would put someth=
ing like=C2=A0XFS_MIN_SECTORSIZE there.</div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gma=
il_default" style=3D"font-family:arial,helvetica,sans-serif">See <a href=3D=
"http://lxr.free-electrons.com/source/fs/xfs/xfs_super.c#L435">http://lxr.f=
ree-electrons.com/source/fs/xfs/xfs_super.c#L435</a></div></div><div class=
=3D"gmail_quote"><div><br></div><div>=C2=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left=
-style:solid;border-left-color:rgb(204,204,204);padding-left:1ex">
<br>
xfs/096 6s ... - output mismatch (see /home/dave/src/xfstests-dev/results//=
xfs/xfs/096.out.bad)<br>
=C2=A0 =C2=A0 --- tests/xfs/096.out=C2=A0 =C2=A0 =C2=A0 =C2=A02016-04-05 11=
:11:36.814382107 +1000<br>
=C2=A0 =C2=A0 +++ /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 2016-05-10 12:54:25.956199714 +1000<br>
=C2=A0 =C2=A0 @@ -2,18 +2,62 @@<br>
<br>
=C2=A0 =C2=A0 =C2=A0# su too big but must be a multiple of fs block size to=
o<br>
=C2=A0 =C2=A0 =C2=A0--- mkfs=3D-l version=3D2,su=3D262656 ---<br>
=C2=A0 =C2=A0 -log stripe unit (262656) must be a multiple of the block siz=
e (4096)<br>
=C2=A0 =C2=A0 +Illegal value 262656 for -l su option. value is too large<br=
>
=C2=A0 =C2=A0 +Usage: mkfs.xfs<br>
=C2=A0 =C2=A0 +/* blocksize */=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [-b=
 log=3Dn|size=3Dnum]<br>
=C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 (Run &#39;diff -u tests/xfs/096.out /home/dave/src/xfstests-d=
ev/results//xfs/xfs/096.out.bad&#39;=C2=A0 to see the entire diff)<br>
<br>
This test is explicitly testing an invalid value, checking that it<br>
falls back to a sane default. This patchset has changed the<br>
behaviour, so the xfstest will need some rework to handle both old<br>
and new mkfs behaviour.<br>
<br>
Can you send patches to fix all these up?<br></blockquote><div><br></div><d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif;display:inline">=E2=80=8BSure.</div></div><div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br><=
/div></div><div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif;display:inline">Jan</div></div><div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=
=80=8B</div>=C2=A0</div></div><br clear=3D"all"><div><br></div>-- <br><div =
class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"lt=
r"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@r=
edhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto=
:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a11449b2860ead7053437581e--


--===============3147238390785758349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3147238390785758349==--
