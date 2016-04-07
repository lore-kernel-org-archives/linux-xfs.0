Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 361BA7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 08:27:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE8A530404E
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 06:27:28 -0700 (PDT)
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com
	[209.85.213.180]) by cuda.sgi.com with ESMTP id
	slEfjRQn2qAdjG8L (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 06:27:26 -0700 (PDT)
Received: by mail-ig0-f180.google.com with SMTP id gy3so13284819igb.1
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 06:27:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57065E19.9070401@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
	<5705BB39.5010003@sandeen.net>
	<CACj3i72K0JHkGKES8eintQ=+rbN7hrSQc3+BNQ2eHfZtm7ik4g@mail.gmail.com>
	<57065E19.9070401@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 15:27:06 +0200
Message-ID: <CACj3i73VP0WCgqE6gzn7dbZBc53PU-NtFj6kxStUUU00oC-wqw@mail.gmail.com>
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0287178948099930389=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============0287178948099930389==
Content-Type: multipart/alternative; boundary=089e01538da0048bf5052fe50a4d

--089e01538da0048bf5052fe50a4d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 7, 2016 at 3:18 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/7/16 8:09 AM, Jan Tulak wrote:
> >
> ...
>
> > On Thu, Apr 7, 2016 at 3:43 AM, Eric Sandeen <sandeen@sandeen.net
> <mailto:sandeen@sandeen.net>> wrote:
> >
> >     > @@ -981,11 +1077,21 @@ main(
> >     >       int                     worst_freelist;
> >     >       libxfs_init_t           xi;
> >     >       struct fs_topology      ft;
> >     > -     int                     lazy_sb_counters;
> >     > -     int                     crcs_enabled;
> >     > -     int                     finobt;
> >     > -     bool                    finobtflag;
> >     > -     int                     spinodes;
> >     > +     struct sb_feat_args     sb_feat =3D {
> >     > +             .finobt =3D 1,
> >     > +             .finobtflag =3D false,
> >
> >
> >     should we really have "finobtflag" in this structure?
> >     This structure should only carry feature selections, not feature
> >     specification flags I think.  Why is this the only such flag
> >     in the structure?
> >
> >     Pretty sure finobtflag should stay a variable for now
> >     just like lvflag (which goes with log_version).
> >
> >
> > =E2=80=8BIt might be right to move it out=E2=80=8B, but the flag is rem=
oved few
> > patches later entirely. Is it worth of the work? I would say nah, let
> > it die where it is. :-)
>
> Given that it doesn't seem to be a bug, I guess that might be ok,
> but in general introducing incorrect things and fixing them later
> in the series is strongly discouraged...
>
> >
> >
> >     ...
> >
> >     > @@ -1517,7 +1617,14 @@ main(
> >     >                                       c =3D atoi(value);
> >     >                                       if (c < 0 || c > 1)
> >     >                                               illegal(value, "m
> crc");
> >     > -                                     crcs_enabled =3D c;
> >     > +                                     if (c && nftype) {
> >     > +                                             fprintf(stderr,
> >     > +_("cannot specify both crc and ftype\n"));
> >     > +                                             usage();
> >
> >     hm, why is conflict checking added?  It's not what the commit says
> >     the patch does.
> >
> >     It also regresses the bug I fixed in
> >
> >     commit b990de8ba4e2df2bc76a140799d3ddb4a0eac4ce
> >     Author: Eric Sandeen <sandeen@sandeen.net <mailto:
> sandeen@sandeen.net>>
> >     Date:   Tue Aug 18 17:53:17 2015 +1000
> >
> >         mkfs.xfs: fix ftype-vs-crc option combination testing
> >
> >     with this patch, it is broken again:
> >
> >     # mkfs/mkfs.xfs -m crc=3D0 -n ftype=3D1 -dfile,name=3Dfsfile,size=
=3D16g
> >     <success>
> >      # mkfs/mkfs.xfs -n ftype=3D1 -m crc=3D0 -dfile,name=3Dfsfile,size=
=3D16g
> >     cannot specify both crc and ftype
> >     Usage: mkfs.xfs
> >     ...
> >
> > =E2=80=8BBecause the patch is much older than your fix, and at the time=
 it
> > was created, it is possible that there wasn't any such check... I
> > would call it the risk of necromancy. :-)=E2=80=8B
>
> Most likely a forward-port or merge error I think.
>
> > Anyway, I already fixed this issue in this cycle, and added the the
> > ftype, crc order into a test checking for options sanity. Just I
> > didn't submitted the change yet.
>
> Ok, so it is fixed in your new version of this patch?
>

=E2=80=8BYes.
=E2=80=8B


>
> >
> >     ...
> >
> >     > @@ -1879,23 +1988,25 @@ _("32 bit Project IDs always enabled on
> CRC enabled filesytems\n"));
> >     >       } else {
> >     >               /*
> >     >                * The kernel doesn't currently support
> crc=3D0,finobt=3D1
> >     > -              * filesystems. If crcs are not enabled and the use=
r
> has
> >     > -              * explicitly turned them off then silently turn
> them off
> >     > -              * to avoid an unnecessary warning. If the user
> explicitly
> >     > -              * tried to use crc=3D0,finobt=3D1, then issue a wa=
rning
> before
> >     > -              * turning them off.
> >     > +              * filesystems. If crcs are not enabled and the use=
r
> has not
> >     > +              * explicitly turned finobt on, then silently turn
> it off to
> >     > +              * avoid an unnecessary warning. If the user
> explicitly tried
> >     > +              * to use crc=3D0,finobt=3D1, then issue a warning
> before turning
> >     > +              * them off.
> >     >                */
> >     > -             if (finobt && finobtflag) {
> >     > -                     fprintf(stderr,
> >     > -_("warning: finobt not supported without CRC support,
> disabled.\n"));
> >     > +             if (sb_feat.finobt){
> >     > +                     if (sb_feat.finobtflag) {
> >     > +                             fprintf(stderr,
> >     > +     _("warning: finobt not supported without CRC support,
> disabled.\n"));
> >     > +                     }
> >     > +                     sb_feat.finobt =3D 0;
> >
> >     like I mentioned, just this, I think (assuming we like the silent
> turning
> >     off, but that would be a different patch):
> >
> >
> > =E2=80=8BMerging the conditions is indeed cleaner.
> >
> > And I will change it to failure, if the conflicting options are given
> > explicitly. Just a small patch adding "usage();" and removing
> > "warning"...=E2=80=8B
>
> Ok, so for this patch, nothing but the mechanical change matching all the
> others,
> right?  If there is any change in behavior to be done, that should be a
> different patch.
>

=E2=80=8BExactly.
=E2=80=8B


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

--089e01538da0048bf5052fe50a4d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 7, 2016 at 3:18 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">On 4/7/16 8:09 AM, Jan Tu=
lak wrote:<br>
&gt;<br>
...<br>
<span class=3D""><br>
&gt; On Thu, Apr 7, 2016 at 3:43 AM, Eric Sandeen &lt;<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:sand=
een@sandeen.net">sandeen@sandeen.net</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; @@ -981,11 +1077,21 @@ main(<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0worst_freelist;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0libxfs_init_t=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0xi;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct fs_topology=
=C2=A0 =C2=A0 =C2=A0 ft;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lazy_sb_counters;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crcs_enabled;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0finobt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 finobtflag;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spinodes;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0struct sb_feat_args=C2=A0=
 =C2=A0 =C2=A0sb_feat =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0.finobt =3D 1,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0.finobtflag =3D false,<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0should we really have &quot;finobtflag&quot; in thi=
s structure?<br>
&gt;=C2=A0 =C2=A0 =C2=A0This structure should only carry feature selections=
, not feature<br>
&gt;=C2=A0 =C2=A0 =C2=A0specification flags I think.=C2=A0 Why is this the =
only such flag<br>
&gt;=C2=A0 =C2=A0 =C2=A0in the structure?<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Pretty sure finobtflag should stay a variable for n=
ow<br>
&gt;=C2=A0 =C2=A0 =C2=A0just like lvflag (which goes with log_version).<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BIt might be right to move it out=E2=80=8B, but the flag is re=
moved few<br>
&gt; patches later entirely. Is it worth of the work? I would say nah, let<=
br>
&gt; it die where it is. :-)<br>
<br>
</span>Given that it doesn&#39;t seem to be a bug, I guess that might be ok=
,<br>
but in general introducing incorrect things and fixing them later<br>
in the series is strongly discouraged...<br>
<span class=3D""><br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0...<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; @@ -1517,7 +1617,14 @@ main(<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0c =3D atoi(value);<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (c &lt; 0 || c &gt; 1)<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0illegal(value, &quot;m crc&=
quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0crcs_enabled =3D c;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (c &amp;&amp; nftype) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +_(&quot;cannot specify both crc and ftype\n&q=
uot;));<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0usage();<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0hm, why is conflict checking added?=C2=A0 It&#39;s =
not what the commit says<br>
&gt;=C2=A0 =C2=A0 =C2=A0the patch does.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0It also regresses the bug I fixed in<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0commit b990de8ba4e2df2bc76a140799d3ddb4a0eac4ce<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0Author: Eric Sandeen &lt;<a href=3D"mailto:s=
andeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:sa=
ndeen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0Date:=C2=A0 =C2=A0Tue Aug 18 17:53=
:17 2015 +1000<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkfs.xfs: fix ftype-vs-crc option com=
bination testing<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0with this patch, it is broken again:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# mkfs/mkfs.xfs -m crc=3D0 -n ftype=3D1 -dfile,name=
=3Dfsfile,size=3D16g<br>
&gt;=C2=A0 =C2=A0 =C2=A0&lt;success&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 # mkfs/mkfs.xfs -n ftype=3D1 -m crc=3D0 -dfile,nam=
e=3Dfsfile,size=3D16g<br>
&gt;=C2=A0 =C2=A0 =C2=A0cannot specify both crc and ftype<br>
&gt;=C2=A0 =C2=A0 =C2=A0Usage: mkfs.xfs<br>
&gt;=C2=A0 =C2=A0 =C2=A0...<br>
&gt;<br>
&gt; =E2=80=8BBecause the patch is much older than your fix, and at the tim=
e it<br>
&gt; was created, it is possible that there wasn&#39;t any such check... I<=
br>
&gt; would call it the risk of necromancy. :-)=E2=80=8B<br>
<br>
</span>Most likely a forward-port or merge error I think.<br>
<span class=3D""><br>
&gt; Anyway, I already fixed this issue in this cycle, and added the the<br=
>
&gt; ftype, crc order into a test checking for options sanity. Just I<br>
&gt; didn&#39;t submitted the change yet.<br>
<br>
</span>Ok, so it is fixed in your new version of this patch?<br></blockquot=
e><div><br></div><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif;display:inline">=E2=80=8BYes.</div></div><div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;dis=
play:inline">=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div><div class=3D"im trimless-h5 trimless-content"><br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0...<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; @@ -1879,23 +1988,25 @@ _(&quot;32 bit Project=
 IDs always enabled on CRC enabled filesytems\n&quot;));<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 * The kernel doesn&#39;t currently support crc=3D0,finobt=3D1<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * filesystems. If crcs are not enabled and the user has<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * explicitly turned them off then silently turn them off<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * to avoid an unnecessary warning. If the user explicitly<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * tried to use crc=3D0,finobt=3D1, then issue a warning before<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * turning them off.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * filesystems. If crcs are not enabled and the user has not<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * explicitly turned finobt on, then silently turn it off to<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * avoid an unnecessary warning. If the user explicitly tried<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * to use crc=3D0,finobt=3D1, then issue a warning before turning<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * them off.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0if (finobt &amp;&amp; finobtflag) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -_(&quot;warning: finobt not supported without=
 CRC support, disabled.\n&quot;));<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0if (sb_feat.finobt){<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sb_feat.finobtflag) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;warning: finobt n=
ot supported without CRC support, disabled.\n&quot;));<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb_feat.finobt =3D 0;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0like I mentioned, just this, I think (assuming we l=
ike the silent turning<br>
&gt;=C2=A0 =C2=A0 =C2=A0off, but that would be a different patch):<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BMerging the conditions is indeed cleaner.<br>
&gt;<br>
&gt; And I will change it to failure, if the conflicting options are given<=
br>
&gt; explicitly. Just a small patch adding &quot;usage();&quot; and removin=
g<br>
&gt; &quot;warning&quot;...=E2=80=8B<br>
<br>
</div></div>Ok, so for this patch, nothing but the mechanical change matchi=
ng all the others,<br>
right?=C2=A0 If there is any change in behavior to be done, that should be =
a different patch.<br></blockquote><div><br></div><div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=
=E2=80=8BExactly.</div></div><div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B</div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex">
<div class=3D"HOEnZb"><div class=3D"im trimless-h5 trimless-content"><br>
-Eric<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>=
Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">j=
tulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blan=
k">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e01538da0048bf5052fe50a4d--


--===============0287178948099930389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0287178948099930389==--
