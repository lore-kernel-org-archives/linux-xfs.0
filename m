Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C71E7CA0
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 20:28:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 409DB304051
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 18:28:45 -0700 (PDT)
Received: from mail-yw0-f196.google.com (mail-yw0-f196.google.com
	[209.85.161.196]) by cuda.sgi.com with ESMTP id
	kJxco5SJF2E9AkAp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 18:28:43 -0700 (PDT)
Received: by mail-yw0-f196.google.com with SMTP id y6so2730241ywe.0
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 18:28:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160511000940.GJ26977@dastard>
References: <1460040514-23834-1-git-send-email-zlang@redhat.com>
	<20160511000940.GJ26977@dastard>
Date: Wed, 11 May 2016 09:28:42 +0800
Message-ID: <CADVQ27rUzsof0xT2=+cQ6R906tmWYC3EDS2BMf7DkqZuy5cv2Q@mail.gmail.com>
Subject: Re: [PATCH v3] xfs_quota: print quota id number if the name can't be
	found
From: Zorro Lang <zorro.lang@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7471150082980559583=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

--===============7471150082980559583==
Content-Type: multipart/alternative; boundary=001a114dfc4a4c17a3053286f618

--001a114dfc4a4c17a3053286f618
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2016=E5=B9=B45=E6=9C=8811=E6=97=A5 08:10=EF=BC=8C"Dave Chinner" <david@from=
orbit.com>=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Apr 07, 2016 at 10:48:34PM +0800, Zorro Lang wrote:
> > When use GETNEXTQUOTA ioctl to report project quota, it always
> > report an unexpected quota:
> >
> >   (null) 0 0 0 00 [--------]
> >
> > The ID 0 store the default quota, even if no one set default quota,
> > it still have quota accounting, but not enforced. So GETNEXTQUOTA
> > can find and report this undefined quota.
> >
> > From this problem, I thought if others' quota name miss, (null) will
> > be printed too. e.g.
> >
> >   # xfs_quota -xc "limit -u bsoft=3D300m bhard=3D400m test" $mnt
> >   # xfs_quota -xc "report -u" $mnt
> >   User ID          Used       Soft       Hard    Warn/Grace
> >   ---------- --------------------------------------------------
> >   root                0          0          0     00 [--------]
> >   test                0     307200     409600     00 [--------]
> >   # userdel -r test
> >   # xfs_quota -xc "report -u" $mnt
> >   User ID          Used       Soft       Hard    Warn/Grace
> >   ---------- --------------------------------------------------
> >   root                0          0          0     00 [--------]
> >   (null)              0     307200     409600     00 [--------]
> >
> > So this problem same with above id 0's problem. For deal with this,
> > this patch will print id number if the name can't be found.
> >
> > But if use old GETQUOTA ioctl, it won't print project id 0 quota
> > information(if it's not defined). That's different with GETNEXTQUOTA.
> > For keep consistent, this patch also print project id 0 when use old
> > GETQUOTA.
> >
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
>
> OK, so with this applied xfs/133 and xfs/134 both now fail with
> this extra output:
>
> +#0 0 0 0 00 [--------]
>
> Can you send patches for these tests to filter out these lines so
> that the tests pass again for both old and new xfsprogs?

Hi Dave,

Sure, I'm doing on this. I remember that a patch from Eryu maybe suit for
this xfsprogs change(maybe need some modify). I'll check it and send a
suitable patch as soon as possible.

Thanks,
Zorro

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--001a114dfc4a4c17a3053286f618
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
2016=E5=B9=B45=E6=9C=8811=E6=97=A5 08:10=EF=BC=8C&quot;Dave Chinner&quot; &=
lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;=E5=86=
=99=E9=81=93=EF=BC=9A<br>
&gt;<br>
&gt; On Thu, Apr 07, 2016 at 10:48:34PM +0800, Zorro Lang wrote:<br>
&gt; &gt; When use GETNEXTQUOTA ioctl to report project quota, it always<br=
>
&gt; &gt; report an unexpected quota:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0(null) 0 0 0 00 [--------]<br>
&gt; &gt;<br>
&gt; &gt; The ID 0 store the default quota, even if no one set default quot=
a,<br>
&gt; &gt; it still have quota accounting, but not enforced. So GETNEXTQUOTA=
<br>
&gt; &gt; can find and report this undefined quota.<br>
&gt; &gt;<br>
&gt; &gt; From this problem, I thought if others&#39; quota name miss, (nul=
l) will<br>
&gt; &gt; be printed too. e.g.<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0# xfs_quota -xc &quot;limit -u bsoft=3D300m bhard=3D4=
00m test&quot; $mnt<br>
&gt; &gt;=C2=A0 =C2=A0# xfs_quota -xc &quot;report -u&quot; $mnt<br>
&gt; &gt;=C2=A0 =C2=A0User ID=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Used=C2=A0 =
=C2=A0 =C2=A0 =C2=A0Soft=C2=A0 =C2=A0 =C2=A0 =C2=A0Hard=C2=A0 =C2=A0 Warn/G=
race<br>
&gt; &gt;=C2=A0 =C2=A0---------- ------------------------------------------=
--------<br>
&gt; &gt;=C2=A0 =C2=A0root=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0=C2=A0 =C2=A0 =C2=A000 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0test=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0=C2=A0 =C2=A0 =C2=A0307200=C2=A0 =C2=A0 =C2=A0409600=C2=A0 =C2=A0 =
=C2=A000 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0# userdel -r test<br>
&gt; &gt;=C2=A0 =C2=A0# xfs_quota -xc &quot;report -u&quot; $mnt<br>
&gt; &gt;=C2=A0 =C2=A0User ID=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Used=C2=A0 =
=C2=A0 =C2=A0 =C2=A0Soft=C2=A0 =C2=A0 =C2=A0 =C2=A0Hard=C2=A0 =C2=A0 Warn/G=
race<br>
&gt; &gt;=C2=A0 =C2=A0---------- ------------------------------------------=
--------<br>
&gt; &gt;=C2=A0 =C2=A0root=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0=C2=A0 =C2=A0 =C2=A000 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0(null)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 0=C2=A0 =C2=A0 =C2=A0307200=C2=A0 =C2=A0 =C2=A0409600=C2=A0 =C2=A0 =C2=
=A000 [--------]<br>
&gt; &gt;<br>
&gt; &gt; So this problem same with above id 0&#39;s problem. For deal with=
 this,<br>
&gt; &gt; this patch will print id number if the name can&#39;t be found.<b=
r>
&gt; &gt;<br>
&gt; &gt; But if use old GETQUOTA ioctl, it won&#39;t print project id 0 qu=
ota<br>
&gt; &gt; information(if it&#39;s not defined). That&#39;s different with G=
ETNEXTQUOTA.<br>
&gt; &gt; For keep consistent, this patch also print project id 0 when use =
old<br>
&gt; &gt; GETQUOTA.<br>
&gt; &gt;<br>
&gt; &gt; Signed-off-by: Zorro Lang &lt;<a href=3D"mailto:zlang@redhat.com"=
>zlang@redhat.com</a>&gt;<br>
&gt;<br>
&gt; OK, so with this applied xfs/133 and xfs/134 both now fail with<br>
&gt; this extra output:<br>
&gt;<br>
&gt; +#0 0 0 0 00 [--------]<br>
&gt;<br>
&gt; Can you send patches for these tests to filter out these lines so<br>
&gt; that the tests pass again for both old and new xfsprogs?</p>
<p dir=3D"ltr">Hi Dave,</p>
<p dir=3D"ltr">Sure, I&#39;m doing on this. I remember that a patch from Er=
yu maybe suit for this xfsprogs change(maybe need some modify). I&#39;ll ch=
eck it and send a suitable patch as soon as possible.</p>
<p dir=3D"ltr">Thanks,<br>
Zorro</p>
<p dir=3D"ltr">&gt;<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Dave.<br>
&gt; --<br>
&gt; Dave Chinner<br>
&gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com=
/mailman/listinfo/xfs</a><br>
</p>

--001a114dfc4a4c17a3053286f618--


--===============7471150082980559583==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7471150082980559583==--
