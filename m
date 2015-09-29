Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADD237F37
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 11:07:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5718C304048
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 09:07:56 -0700 (PDT)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	eFT9GUXBuGfl7JnC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2015 09:07:52 -0700 (PDT)
Received: by ioii196 with SMTP id i196so16021847ioi.3
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 09:07:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150924225338.GV19114@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-13-git-send-email-jtulak@redhat.com>
	<20150923033655.GQ3902@dastard>
	<CACj3i70gPpRyO-Mho9WC4SE+=69pTu8d4RCLXJR7hnTxUbOGzA@mail.gmail.com>
	<20150924225338.GV19114@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 29 Sep 2015 18:07:32 +0200
Message-ID: <CACj3i73vNyyn6TQY==ekvjUBBvHnb9SbEH9OijQ1399mVSR6=A@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7923274024692625502=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============7923274024692625502==
Content-Type: multipart/alternative; boundary=001a1140aa70158f1e0520e50483

--001a1140aa70158f1e0520e50483
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2015 at 12:53 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Sep 24, 2015 at 04:38:49PM +0200, Jan Tulak wrote:
> > On Wed, Sep 23, 2015 at 5:36 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Tue, Sep 15, 2015 at 11:59:22AM +0200, Jan Tulak wrote:
> > > > @@ -202,6 +205,27 @@ find_mountpoint(char *mtab, char *argname,
> struct
> > > stat64 *sb)
> > > >       }
> > > >
> > > >       while ((t =3D getmntent(mtabp))) {
> > > > +#elif defined(HAVE_GETMNTINFO)
> > > > +     struct statfs   *stats;
> > > > +     int error, i, count;
> > > > +     // because "t" is a pointer, but we don't need to use
> > > > +     // malloc for this usage
> > > > +     struct mntent t_tmp;
> > > > +     t =3D &t_tmp;
> > > > +
> > > > +
> > > > +     error =3D 0;
> > > > +     if ((count =3D getmntinfo(&stats, 0)) < 0) {
> > > > +             fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
> > > > +                             progname, strerror(errno));
> > > > +             return 0;
> > > > +     }
> > > > +
> > > > +     for (i =3D 0; i < count; i++) {
> > > > +             mntinfo2mntent(&stats[i], t);
> > > > +#else
> > > > +# error "How do I extract info about mounted filesystems on this
> > > platform?"
> > > > +#endif
> > >
> > > No, please don't do that. Having a loop iterator split across two
> > > separate defines is unmaintainable. Write two separate functions
> > > with the different loop iterators, then factor the common bit out
> > > of them into a single function.
> > >
> > >
> > I did a little refactoring to solve it. What I would like to ask ab=E2=
=80=8Bout
> is
> > this:
> > When I can put ifdef just inside of a function like fnc(void) { #ifdef.=
..
> > #else ... #endif }, with little to no code outside of the ifdef, is it
> > better to put the ifdef outside, or keep it inside?
>
> The idea is that the "little differences" are put in functions that
> end up in include/<platform>.h or libxfs/<platform>.c, so there are
> no ifdefs in any of the application or library code. The build will
> automatically include the correct function on the given platform,
> and so the application code does not need such ifdefs at all.
>
> e.g. you could implement these functions to abstract the differences
> away from xfs_fsr and any other code that iterates the mount table:
>
> struct mntent_cursor {
>         /* variables needed to track iteration of the mtab */
> };
>
> platform_first_mntent()
> platform_next_mntent()
> platform_end_mntent()
>
> and so the code would look like:
>
>         struct mntent_cursor    cursor;
>
>         mntent =3D platform_first_mntent(&cursor)
>
>         do {
>                 /* process mntent */
>         } while (mntent =3D platform_next_mntent(&cursor, mntent));
>
>         platform_end_mntent(&cursor);
>
> This completely abstracts the differences related to the the mount
> table traversal, and allows the aplication level code to be written
> in a clean, easily maintainable fashion...
>

=E2=80=8BSo something like what I just posted? I added the same code that w=
orks for
Linux into other platforms other than OS X. =E2=80=8B

=E2=80=8BBecause as it was there before,  it either works on them, =E2=80=
=8Bor no one care.
And I really don't have an idea how to test it on Irix... :-)

Cheers,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a1140aa70158f1e0520e50483
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Se=
p 25, 2015 at 12:53 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font=
-family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><di=
v class=3D"h5">On Thu, Sep 24, 2015 at 04:38:49PM +0200, Jan Tulak wrote:<b=
r>
&gt; On Wed, Sep 23, 2015 at 5:36 AM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Tue, Sep 15, 2015 at 11:59:22AM +0200, Jan Tulak wrote:<br>
&gt; &gt; &gt; @@ -202,6 +205,27 @@ find_mountpoint(char *mtab, char *argna=
me, struct<br>
&gt; &gt; stat64 *sb)<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while ((t =3D getmntent(mtabp))) {=
<br>
&gt; &gt; &gt; +#elif defined(HAVE_GETMNTINFO)<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0struct statfs=C2=A0 =C2=A0*stats;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0int error, i, count;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0// because &quot;t&quot; is a pointer, =
but we don&#39;t need to use<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0// malloc for this usage<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0struct mntent t_tmp;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0t =3D &amp;t_tmp;<br>
&gt; &gt; &gt; +<br>
&gt; &gt; &gt; +<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0error =3D 0;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0if ((count =3D getmntinfo(&amp;stats, 0=
)) &lt; 0) {<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(std=
err, _(&quot;%s: getmntinfo() failed: %s\n&quot;),<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0progname, strerror(errno));<br=
>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<b=
r>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; &gt; +<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; count; i++) {<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mntinfo2mnt=
ent(&amp;stats[i], t);<br>
&gt; &gt; &gt; +#else<br>
&gt; &gt; &gt; +# error &quot;How do I extract info about mounted filesyste=
ms on this<br>
&gt; &gt; platform?&quot;<br>
&gt; &gt; &gt; +#endif<br>
&gt; &gt;<br>
&gt; &gt; No, please don&#39;t do that. Having a loop iterator split across=
 two<br>
&gt; &gt; separate defines is unmaintainable. Write two separate functions<=
br>
&gt; &gt; with the different loop iterators, then factor the common bit out=
<br>
&gt; &gt; of them into a single function.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; I did a little refactoring to solve it. What I would like to ask ab=E2=
=80=8Bout is<br>
&gt; this:<br>
&gt; When I can put ifdef just inside of a function like fnc(void) { #ifdef=
...<br>
&gt; #else ... #endif }, with little to no code outside of the ifdef, is it=
<br>
&gt; better to put the ifdef outside, or keep it inside?<br>
<br>
</div></div>The idea is that the &quot;little differences&quot; are put in =
functions that<br>
end up in include/&lt;platform&gt;.h or libxfs/&lt;platform&gt;.c, so there=
 are<br>
no ifdefs in any of the application or library code. The build will<br>
automatically include the correct function on the given platform,<br>
and so the application code does not need such ifdefs at all.<br>
<br>
e.g. you could implement these functions to abstract the differences<br>
away from xfs_fsr and any other code that iterates the mount table:<br>
<br>
struct mntent_cursor {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* variables needed to track iteration of the m=
tab */<br>
};<br>
<br>
platform_first_mntent()<br>
platform_next_mntent()<br>
platform_end_mntent()<br>
<br>
and so the code would look like:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mntent_cursor=C2=A0 =C2=A0 cursor;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mntent =3D platform_first_mntent(&amp;cursor)<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* process mntent *=
/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } while (mntent =3D platform_next_mntent(&amp;c=
ursor, mntent));<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 platform_end_mntent(&amp;cursor);<br>
<br>
This completely abstracts the differences related to the the mount<br>
table traversal, and allows the aplication level code to be written<br>
in a clean, easily maintainable fashion...<br></blockquote><div><br></div><=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif;display:inline">=E2=80=8BSo something like what I just posted? I adde=
d the same code that works for Linux into other platforms other than OS X. =
=E2=80=8B</div>=C2=A0<div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif;display:inline">=E2=80=8BBecause as it was there bef=
ore, =C2=A0it either works on them, =E2=80=8Bor no one care. And I really d=
on&#39;t have an idea how to test it on Irix... :-)</div></div><div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;displ=
ay:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif;display:inline">Cheers,</div></div><div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;display:inline">Jan</div></div></div><div><br></div>-- <br><div class=3D"g=
mail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></=
div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.co=
m</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me=
</a></div></div></div></div>
</div></div>

--001a1140aa70158f1e0520e50483--


--===============7923274024692625502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7923274024692625502==--
