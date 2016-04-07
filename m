Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 807707CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 08:09:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED46DAC004
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 06:09:30 -0700 (PDT)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com
	[209.85.213.172]) by cuda.sgi.com with ESMTP id
	TGRtHRthDNZzZmLW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 06:09:25 -0700 (PDT)
Received: by mail-ig0-f172.google.com with SMTP id gy3so101168080igb.0
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 06:09:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5705BB39.5010003@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
	<5705BB39.5010003@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 15:09:04 +0200
Message-ID: <CACj3i72K0JHkGKES8eintQ=+rbN7hrSQc3+BNQ2eHfZtm7ik4g@mail.gmail.com>
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8031118902877015907=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8031118902877015907==
Content-Type: multipart/alternative; boundary=089e01538da08ed1e6052fe4c993

--089e01538da08ed1e6052fe4c993
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E2=80=8B=E2=80=8B

On Thu, Apr 7, 2016 at 2:12 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > @@ -1262,10 +1358,11 @@ main(
> >                               switch (getsubopt(&p, (constpp)iopts,
> &value)) {
> >                               case I_ALIGN:
> >                                       if (!value || *value =3D=3D '\0')
> > -                                             value =3D "1";
> > -                                     iaflag =3D atoi(value);
> > -                                     if (iaflag < 0 || iaflag > 1)
> > +                                             reqval('i', iopts,
> I_ALIGN);
> > +                                     c =3D atoi(value);
> > +                                     if (c < 0 || c > 1)
> >                                               illegal(value, "i align")=
;
> > +                                     sb_feat.inode_align =3D c ? true =
:
> false;
> >                                       break;
> >                               case I_LOG:
> >                                       if (!value || *value =3D=3D '\0')
>
>
> Hm, this seems wrong, as well - per the man page:
>
> "If the value is omitted, 1 is assumed."
>
> but this change with the reqval() removes that, doesn't it?  Why?
> (it's fixed later, but there is no reason to break it mid-series...)

=E2=80=8B
Changed back to default 1. =E2=80=8BAs for the origin of the change, most l=
ikely a
copy&paste from some other place, where wasn't a default value, or it was
there since I took over the patchset.

On Thu, Apr 7, 2016 at 3:43 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> > @@ -981,11 +1077,21 @@ main(
> >       int                     worst_freelist;
> >       libxfs_init_t           xi;
> >       struct fs_topology      ft;
> > -     int                     lazy_sb_counters;
> > -     int                     crcs_enabled;
> > -     int                     finobt;
> > -     bool                    finobtflag;
> > -     int                     spinodes;
> > +     struct sb_feat_args     sb_feat =3D {
> > +             .finobt =3D 1,
> > +             .finobtflag =3D false,
>
>
> should we really have "finobtflag" in this structure?
> This structure should only carry feature selections, not feature
> specification flags I think.  Why is this the only such flag
> in the structure?
>
> Pretty sure finobtflag should stay a variable for now
> just like lvflag (which goes with log_version).
>
>
=E2=80=8BIt might be right to move it out=E2=80=8B, but the flag is removed=
 few patches
later entirely. Is it worth of the work? I would say nah, let it die where
it is. :-)



> ...
>
> > @@ -1517,7 +1617,14 @@ main(
> >                                       c =3D atoi(value);
> >                                       if (c < 0 || c > 1)
> >                                               illegal(value, "m crc");
> > -                                     crcs_enabled =3D c;
> > +                                     if (c && nftype) {
> > +                                             fprintf(stderr,
> > +_("cannot specify both crc and ftype\n"));
> > +                                             usage();
>
> hm, why is conflict checking added?  It's not what the commit says
> the patch does.
>
> It also regresses the bug I fixed in
>
> commit b990de8ba4e2df2bc76a140799d3ddb4a0eac4ce
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Tue Aug 18 17:53:17 2015 +1000
>
>     mkfs.xfs: fix ftype-vs-crc option combination testing
>
> with this patch, it is broken again:
>
> # mkfs/mkfs.xfs -m crc=3D0 -n ftype=3D1 -dfile,name=3Dfsfile,size=3D16g
> <success>
>  # mkfs/mkfs.xfs -n ftype=3D1 -m crc=3D0 -dfile,name=3Dfsfile,size=3D16g
> cannot specify both crc and ftype
> Usage: mkfs.xfs
> ...
>
> =E2=80=8BBecause the patch is much older than your fix, and at the time i=
t was
created, it is possible that there wasn't any such check... I would call it
the risk of necromancy. :-)=E2=80=8B

Anyway, I already fixed this issue in this cycle, and added the the ftype,
crc order into a test checking for options sanity. Just I didn't submitted
the change yet.

...
>
> > @@ -1879,23 +1988,25 @@ _("32 bit Project IDs always enabled on CRC
> enabled filesytems\n"));
> >       } else {
> >               /*
> >                * The kernel doesn't currently support crc=3D0,finobt=3D=
1
> > -              * filesystems. If crcs are not enabled and the user has
> > -              * explicitly turned them off then silently turn them off
> > -              * to avoid an unnecessary warning. If the user explicitl=
y
> > -              * tried to use crc=3D0,finobt=3D1, then issue a warning =
before
> > -              * turning them off.
> > +              * filesystems. If crcs are not enabled and the user has
> not
> > +              * explicitly turned finobt on, then silently turn it off
> to
> > +              * avoid an unnecessary warning. If the user explicitly
> tried
> > +              * to use crc=3D0,finobt=3D1, then issue a warning before
> turning
> > +              * them off.
> >                */
> > -             if (finobt && finobtflag) {
> > -                     fprintf(stderr,
> > -_("warning: finobt not supported without CRC support, disabled.\n"));
> > +             if (sb_feat.finobt){
> > +                     if (sb_feat.finobtflag) {
> > +                             fprintf(stderr,
> > +     _("warning: finobt not supported without CRC support,
> disabled.\n"));
> > +                     }
> > +                     sb_feat.finobt =3D 0;
>
> like I mentioned, just this, I think (assuming we like the silent turning
> off, but that would be a different patch):
>

=E2=80=8BMerging the conditions is indeed cleaner.

And I will change it to failure, if the conflicting options are given
explicitly. Just a small patch adding "usage();" and removing "warning"...=
=E2=80=8B

Cheers,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01538da08ed1e6052fe4c993
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><div class=3D"gmai=
l_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8B=E2=80=
=8B</div><br><div class=3D"gmail_quote">On Thu, Apr 7, 2016 at 2:12 AM, Eri=
c Sandeen=C2=A0<span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net"=
 target=3D"_blank">sandeen@sandeen.net</a>&gt;</span>=C2=A0wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-w=
idth:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding=
-left:1ex"><span class=3D"">On 3/24/16 6:15 AM,=C2=A0<a href=3D"mailto:jtul=
ak@redhat.com">jtulak@redhat.com</a>=C2=A0wrote:<br></span><span class=3D""=
>&gt; @@ -1262,10 +1358,11 @@ main(<br>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0switch (getsubopt(&amp;p, (constpp)iopts, &amp;value)) {<br>&gt;=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case I_ALIGN:<br>&gt;=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!value || *value =3D=3D &#=
39;\0&#39;)<br>&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0value =3D &quot;1&quot;;<br>&gt; -=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iaflag =3D atoi(value);=
<br>&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ia=
flag &lt; 0 || iaflag &gt; 1)<br>&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reqval(&#39;i&#39;, iop=
ts, I_ALIGN);<br>&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0c =3D atoi(value);<br>&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (c &lt; 0 || c &gt; 1)<br>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0illega=
l(value, &quot;i align&quot;);<br>&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0sb_feat.inode_align =3D c ? true : false;<br>&gt;=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br=
>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case I_LOG:<br>&gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!value || *value =
=3D=3D &#39;\0&#39;)<br><br><br></span>Hm, this seems wrong, as well - per =
the man page:<br><br>&quot;If the value is omitted, 1 is assumed.&quot;<br>=
<br>but this change with the reqval() removes that, doesn&#39;t it?=C2=A0 W=
hy?<br>(it&#39;s fixed later, but there is no reason to break it mid-series=
...)</blockquote></div><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif">=E2=80=8B</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">Changed back to default 1. =E2=
=80=8BAs for the origin of the change, most likely a copy&amp;paste from so=
me other place, where wasn&#39;t a default value, or it was there since I t=
ook over the patchset.=C2=A0</div><br><div class=3D"gmail_quote">On Thu, Ap=
r 7, 2016 at 3:43 AM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:=
sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span> w=
rote:<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:so=
lid;padding-left:1ex"><span class=3D"">
&gt; @@ -981,11 +1077,21 @@ main(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0worst_freelist;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0libxfs_init_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0xi;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct fs_topology=C2=A0 =C2=A0 =C2=A0 ft;<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lazy_sb_counters;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crcs_enabled;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0finobt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 finobtflag;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spinodes;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct sb_feat_args=C2=A0 =C2=A0 =C2=A0sb_feat =
=3D {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.finobt =3D 1,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.finobtflag =3D false=
,<br>
<br>
<br>
</span>should we really have &quot;finobtflag&quot; in this structure?<br>
This structure should only carry feature selections, not feature<br>
specification flags I think.=C2=A0 Why is this the only such flag<br>
in the structure?<br>
<br>
Pretty sure finobtflag should stay a variable for now<br>
just like lvflag (which goes with log_version).<br><span class=3D""><br></s=
pan></blockquote><div>=C2=A0</div><div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BIt might be right to m=
ove it out=E2=80=8B, but the flag is removed few patches later entirely. Is=
 it worth of the work? I would say nah, let it die where it is. :-)</div><b=
r></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);=
border-left-style:solid;padding-left:1ex"><span class=3D"">
</span>...<br>
<span class=3D""><br>
&gt; @@ -1517,7 +1617,14 @@ main(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c =3D =
atoi(value);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (c =
&lt; 0 || c &gt; 1)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0illegal(value, &quot;m crc&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crcs_enabled=
 =3D c;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (c &amp;&=
amp; nftype) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +_(&quot;cannot specify both crc and ftype\n&quot;));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0usage();<br>
<br>
</span>hm, why is conflict checking added?=C2=A0 It&#39;s not what the comm=
it says<br>
the patch does.<br>
<br>
It also regresses the bug I fixed in<br>
<br>
commit b990de8ba4e2df2bc76a140799d3ddb4a0eac4ce<br>
Author: Eric Sandeen &lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@san=
deen.net</a>&gt;<br>
Date:=C2=A0 =C2=A0Tue Aug 18 17:53:17 2015 +1000<br>
<br>
=C2=A0 =C2=A0 mkfs.xfs: fix ftype-vs-crc option combination testing<br>
<br>
with this patch, it is broken again:<br>
<br>
# mkfs/mkfs.xfs -m crc=3D0 -n ftype=3D1 -dfile,name=3Dfsfile,size=3D16g<br>
&lt;success&gt;<br>
=C2=A0# mkfs/mkfs.xfs -n ftype=3D1 -m crc=3D0 -dfile,name=3Dfsfile,size=3D1=
6g<br>
<span class=3D"">cannot specify both crc and ftype<br>
</span>Usage: mkfs.xfs<br>
...<br>
<span class=3D""><br></span></blockquote><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BBecause the patch=
 is much older than your fix, and at the time it was created, it is possibl=
e that there wasn&#39;t any such check... I would call it the risk of necro=
mancy. :-)=E2=80=8B</div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif">Anyway, I already fixed this issue=
 in this cycle, and added the the ftype, crc order into a test checking for=
 options sanity. Just I didn&#39;t submitted the change yet.</div></div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-sty=
le:solid;padding-left:1ex">...<br>
<span class=3D""><br>
&gt; @@ -1879,23 +1988,25 @@ _(&quot;32 bit Project IDs always enabled on C=
RC enabled filesytems\n&quot;));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * The kernel do=
esn&#39;t currently support crc=3D0,finobt=3D1<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filesystems. If cr=
cs are not enabled and the user has<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * explicitly turned =
them off then silently turn them off<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * to avoid an unnece=
ssary warning. If the user explicitly<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * tried to use crc=
=3D0,finobt=3D1, then issue a warning before<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * turning them off.<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filesystems. If cr=
cs are not enabled and the user has not<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * explicitly turned =
finobt on, then silently turn it off to<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * avoid an unnecessa=
ry warning. If the user explicitly tried<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * to use crc=3D0,fin=
obt=3D1, then issue a warning before turning<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * them off.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (finobt &amp;&amp;=
 finobtflag) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0fprintf(stderr,<br>
&gt; -_(&quot;warning: finobt not supported without CRC support, disabled.\=
n&quot;));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sb_feat.finobt){<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (sb_feat.finobtflag) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;warning: finobt not supported without CRC=
 support, disabled.\n&quot;));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sb_feat.finobt =3D 0;<br>
<br>
</span>like I mentioned, just this, I think (assuming we like the silent tu=
rning<br>
off, but that would be a different patch):<br></blockquote><div>=C2=A0</div=
><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif">=E2=80=8BMerging the conditions is indeed cleaner.</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">And I will change it to failure, if the conflicting options are given=
 explicitly. Just a small patch adding &quot;usage();&quot; and removing &q=
uot;warning&quot;...=E2=80=8B</div></div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">Cheers,</div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Ja=
n</div></div><div><br></div>-- <br><div class=3D"gmail_signature"><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jt=
ulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"=
mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></=
div>
</div></div>

--089e01538da08ed1e6052fe4c993--


--===============8031118902877015907==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8031118902877015907==--
