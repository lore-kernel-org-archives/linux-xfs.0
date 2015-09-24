Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F4797F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 09:39:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CC238F8052
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 07:39:11 -0700 (PDT)
Received: from mail-ig0-f181.google.com (mail-ig0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	NH7WRnUQPWRfPvKg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 07:39:09 -0700 (PDT)
Received: by igcpb10 with SMTP id pb10so16409981igc.1
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 07:39:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150923033655.GQ3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-13-git-send-email-jtulak@redhat.com>
	<20150923033655.GQ3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 24 Sep 2015 16:38:49 +0200
Message-ID: <CACj3i70gPpRyO-Mho9WC4SE+=69pTu8d4RCLXJR7hnTxUbOGzA@mail.gmail.com>
Subject: Re: [PATCH 12/14] xfsprogs: make fsr use mntinfo when there is no
	mntent
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4344800904538190095=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============4344800904538190095==
Content-Type: multipart/alternative; boundary=089e01184e649766d205207f3198

--089e01184e649766d205207f3198
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2015 at 5:36 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 15, 2015 at 11:59:22AM +0200, Jan Tulak wrote:
> > @@ -202,6 +205,27 @@ find_mountpoint(char *mtab, char *argname, struct
> stat64 *sb)
> >       }
> >
> >       while ((t =3D getmntent(mtabp))) {
> > +#elif defined(HAVE_GETMNTINFO)
> > +     struct statfs   *stats;
> > +     int error, i, count;
> > +     // because "t" is a pointer, but we don't need to use
> > +     // malloc for this usage
> > +     struct mntent t_tmp;
> > +     t =3D &t_tmp;
> > +
> > +
> > +     error =3D 0;
> > +     if ((count =3D getmntinfo(&stats, 0)) < 0) {
> > +             fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
> > +                             progname, strerror(errno));
> > +             return 0;
> > +     }
> > +
> > +     for (i =3D 0; i < count; i++) {
> > +             mntinfo2mntent(&stats[i], t);
> > +#else
> > +# error "How do I extract info about mounted filesystems on this
> platform?"
> > +#endif
>
> No, please don't do that. Having a loop iterator split across two
> separate defines is unmaintainable. Write two separate functions
> with the different loop iterators, then factor the common bit out
> of them into a single function.
>
>
I did a little refactoring to solve it. What I would like to ask ab=E2=80=
=8Bout is
this:
When I can put ifdef just inside of a function like fnc(void) { #ifdef...
#else ... #endif }, with little to no code outside of the ifdef, is it
better to put the ifdef outside, or keep it inside?

I suppose the outside placement allows for easier changes for one of the
branches when there would be a new function just for a specific branch. But
on the other side, it makes it easier to forget the second function in
another branch when making some change later.

=E2=80=8BCheers,
Jan=E2=80=8B

--
=E2=80=8B-=E2=80=8B

Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01184e649766d205207f3198
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Sep 23, 2015 at 5:36 AM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=
=3D"HOEnZb"><div class=3D"h5">On Tue, Sep 15, 2015 at 11:59:22AM +0200, Jan=
 Tulak wrote:<br>
&gt; @@ -202,6 +205,27 @@ find_mountpoint(char *mtab, char *argname, struct=
 stat64 *sb)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while ((t =3D getmntent(mtabp))) {<br>
&gt; +#elif defined(HAVE_GETMNTINFO)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct statfs=C2=A0 =C2=A0*stats;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int error, i, count;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0// because &quot;t&quot; is a pointer, but we don=
&#39;t need to use<br>
&gt; +=C2=A0 =C2=A0 =C2=A0// malloc for this usage<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct mntent t_tmp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0t =3D &amp;t_tmp;<br>
&gt; +<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0error =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((count =3D getmntinfo(&amp;stats, 0)) &lt; 0)=
 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, _(&qu=
ot;%s: getmntinfo() failed: %s\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0progname, strerror(errno));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; count; i++) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mntinfo2mntent(&amp;s=
tats[i], t);<br>
&gt; +#else<br>
&gt; +# error &quot;How do I extract info about mounted filesystems on this=
 platform?&quot;<br>
&gt; +#endif<br>
<br>
</div></div>No, please don&#39;t do that. Having a loop iterator split acro=
ss two<br>
separate defines is unmaintainable. Write two separate functions<br>
with the different loop iterators, then factor the common bit out<br>
of them into a single function.<br>
<div><div class=3D"h5"><br></div></div></blockquote><div><br></div><div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;d=
isplay:inline">I did a little refactoring to solve it. What I would like to=
 ask ab=E2=80=8Bout is this:</div></div><div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif;display:inline">When I can p=
ut ifdef just inside of a function like fnc(void) { #ifdef... #else ... #en=
dif }, with little to no code outside of the ifdef, is it better to put the=
 ifdef outside, or keep it inside?=C2=A0</div></div><div><div class=3D"gmai=
l_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=
<br></div></div><div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif;display:inline">I suppose the outside placement allo=
ws for easier changes for one of the branches when there would be a new fun=
ction just for a specific branch. But on the other side, it makes it easier=
 to forget the second function in another branch when making some change la=
ter.</div></div></div><div class=3D"gmail_extra"><br></div><div class=3D"gm=
ail_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BChee=
rs,</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,=
sans-serif">Jan=E2=80=8B</div><div><br></div>--<div class=3D"gmail_default"=
 style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B-=
=E2=80=8B</div><br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><di=
v dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" =
target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.=
me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e01184e649766d205207f3198--


--===============4344800904538190095==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4344800904538190095==--
