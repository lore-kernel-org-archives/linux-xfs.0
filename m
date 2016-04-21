Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D9057CA0
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:22:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 402BD304039
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:22:28 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	nJ1whpoWXamI2eJh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:22:22 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id u185so79835395iod.3
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:22:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5717B3F7.2030904@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
	<CACj3i722h=WVW-637__y6fi4EekAxxB=cwL8y+F1r1LFk-Z5rw@mail.gmail.com>
	<CACj3i71Ff2KS682DRP8zG76ee6rhz3X-NZKst1qsruMZKWaHJA@mail.gmail.com>
	<CACj3i73jk5HjRuRRF7hnX0WoOv0amq-CduAwoHbhoT-=+hTREA@mail.gmail.com>
	<5717B3F7.2030904@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 21 Apr 2016 11:22:02 +0200
Message-ID: <CACj3i73t6CspvjrOMV9kByy2jW+_QAfxcwpa=1TfBaKXkJyftA@mail.gmail.com>
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8395539674727203666=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8395539674727203666==
Content-Type: multipart/alternative; boundary=001a113ecdbe6396270530fb3ff4

--001a113ecdbe6396270530fb3ff4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2016 at 6:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/20/16 9:17 AM, Jan Tulak wrote:
> > =E2=80=8BI'm taking it back, one tests fails, most likely it happened w=
hen I
> > removed patch 17 - xfsprogs: disable truncating of files. If I do
> > "mkfs.xfs $file", it doesn't know the old size to recreate it. I'm
> > working on a change for this patch to fix this issue, but I'm not
> > entirely certain how to proceed. The right place to get the size
> > seems to be get_topology(). I could save it into xi.dsize, but then
> > libxfs_init() zeroes it.
> >
> > So I think that I might rather convert the measured size do char
> > *dsize and pretend that it is an user-given value. But this looks to
> > me more like a hack. On the other side, any other way would require
> > further changes in the code to convert the char* to int as soon as
> > possible - which does not belong to this patch...
> ...
>
> > So, what do you think about this?
> >
> > =E2=80=8B And before anyone will reply, I found that putting a
> > platform_findsizes=E2=80=8B into libxfs_init will fix it too. Which is =
nice,
> > especially because for block devices, the findsizes is already used
> > there. So ignore the previous hack. :-)
>
> Huh - if I take your original patchset and simply remove patch 17,
>
=E2=80=8Band revert this patch to the Dave's version.
=E2=80=8B


> I don't get any problems with "mkfs.xfs file" for an existing file,
> it seems to work fine here.  So it might be something else...
>

=E2=80=8BI bisected it and the issue was really caused by this patch in Dav=
e's
version. But luckily, the fix is as simple as:

@@ -278,6 +278,8 @@ libxfs_init(libxfs_init_t *a)
                        a->ddev=3D libxfs_device_open(dname, a->dcreat, fla=
gs,
                                                    a->setblksize);
                        a->dfd =3D libxfs_device_to_fd(a->ddev);
+                       platform_findsizes(dname, a->dfd, &a->dsize,
+                                               &a->dbsize);
                } else {
                        if (!check_open(dname, flags, &rawfile, &blockfile)=
)
                                goto done;=E2=80=8B

=E2=80=8B(and dtto for log/rt variants).=E2=80=8B

I'm going to send for review what I have, and work on the remaining issues
in the meantime.

Unless I find something else, the last thing to fix is that it changes the
size of the file on -d size=3Dxxx, even when O_TRUNCATE is not used (that i=
s,
no -d file is specified). Old behaviour was to keep the file size and just
don't use the entire file. This affects xfs/206 and xfs/216.

Jan


>
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ecdbe6396270530fb3ff4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Ap=
r 20, 2016 at 6:53 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span>On 4/20/16 9:17 AM, Jan Tulak wro=
te:<br>
&gt; =E2=80=8BI&#39;m taking it back, one tests fails, most likely it happe=
ned when I<br>
&gt; removed patch 17 - xfsprogs: disable truncating of files. If I do<br>
&gt; &quot;mkfs.xfs $file&quot;, it doesn&#39;t know the old size to recrea=
te it. I&#39;m<br>
&gt; working on a change for this patch to fix this issue, but I&#39;m not<=
br>
&gt; entirely certain how to proceed. The right place to get the size<br>
&gt; seems to be get_topology(). I could save it into xi.dsize, but then<br=
>
&gt; libxfs_init() zeroes it.<br>
&gt;<br>
&gt; So I think that I might rather convert the measured size do char<br>
&gt; *dsize and pretend that it is an user-given value. But this looks to<b=
r>
&gt; me more like a hack. On the other side, any other way would require<br=
>
&gt; further changes in the code to convert the char* to int as soon as<br>
&gt; possible - which does not belong to this patch...<br>
</span>...<br>
<span><br>
&gt; So, what do you think about this?<br>
&gt;<br>
&gt; =E2=80=8B And before anyone will reply, I found that putting a<br>
&gt; platform_findsizes=E2=80=8B into libxfs_init will fix it too. Which is=
 nice,<br>
&gt; especially because for block devices, the findsizes is already used<br=
>
&gt; there. So ignore the previous hack. :-)<br>
<br>
</span>Huh - if I take your original patchset and simply remove patch 17,<b=
r></blockquote><div><div class=3D"gmail_default" style=3D"font-family:arial=
,helvetica,sans-serif;display:inline">=E2=80=8Band revert this patch to the=
 Dave&#39;s version.</div></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B</div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-styl=
e:solid;padding-left:1ex">
I don&#39;t get any problems with &quot;mkfs.xfs file&quot; for an existing=
 file,<br>
it seems to work fine here.=C2=A0 So it might be something else...<br></blo=
ckquote><div><br></div><div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif">=E2=80=8BI bisected it and the issue was rea=
lly caused by this patch in Dave&#39;s version. But luckily, the fix is as =
simple as:</div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif">@@ -278,6 +278,8 @@ libxfs_init(libxfs_init=
_t *a)</div><div class=3D"gmail_default" style=3D"font-family:arial,helveti=
ca,sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 a-&gt;ddev=3D libxfs_device_open(dname, a-&gt;dcre=
at, flags,</div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 a-&gt;setblksize);</di=
v><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-se=
rif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 a-&gt;dfd =3D libxfs_device_to_fd(a-&gt;ddev);</div><div clas=
s=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">+ =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p=
latform_findsizes(dname, a-&gt;dfd, &amp;a-&gt;dsize,</div><div class=3D"gm=
ail_default" style=3D"font-family:arial,helvetica,sans-serif">+ =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 &amp;a-&gt;dbsize);</div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 } else {</div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!check_open(dname, flags, &am=
p;rawfile, &amp;blockfile))</div><div class=3D"gmail_default" style=3D"font=
-family:arial,helvetica,sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 g=
oto done;=E2=80=8B</div><br></div><div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8B(and dtto for log/rt v=
ariants).=E2=80=8B</div><div class=3D"gmail_default" style=3D"font-family:a=
rial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif">I&#39;m going to send for review wh=
at I have, and work on the remaining issues in the meantime.=C2=A0<br></div=
><div><br></div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif">Unless I find something else, the last thing to fix is t=
hat it changes the size of the file on -d size=3Dxxx, even when O_TRUNCATE =
is not used (that is, no -d file is specified). Old behaviour was to keep t=
he file size and just don&#39;t use the entire file. This affects xfs/206 a=
nd xfs/216.</div><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div></div><div class=3D"gmail_default" style=3D"f=
ont-family:arial,helvetica,sans-serif">Jan</div><div>=C2=A0</div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width=
:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-lef=
t:1ex">
<span><font color=3D"#888888"><br>
-Eric<br>
</font></span><div><div><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=
=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0=
/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div><=
/div></div></div>
</div></div>

--001a113ecdbe6396270530fb3ff4--


--===============8395539674727203666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8395539674727203666==--
