Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AD527CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 20:41:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2DEF304032
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 18:41:51 -0700 (PDT)
Received: from mail-yw0-f173.google.com (mail-yw0-f173.google.com
	[209.85.161.173]) by cuda.sgi.com with ESMTP id
	9DAHHPOweFcsWcFu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 18:41:48 -0700 (PDT)
Received: by mail-yw0-f173.google.com with SMTP id d68so79489135ywe.1
	for <xfs@oss.sgi.com>; Wed, 06 Apr 2016 18:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570556AE.7080306@redhat.com>
References: <1459964353-25151-1-git-send-email-zlang@redhat.com>
	<570556AE.7080306@redhat.com>
Date: Thu, 7 Apr 2016 09:41:47 +0800
Message-ID: <CADVQ27oHL3K-WRq8R1fF5t5Fh=mWPCGprrLB0E7nQ4DF7cvnyg@mail.gmail.com>
Subject: Re: [PATCH] xfs_quota: print quota id number if the name can't be
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
Content-Type: multipart/mixed; boundary="===============1081983286245415095=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: zlang@redhat.com, xfs@oss.sgi.com

--===============1081983286245415095==
Content-Type: multipart/alternative; boundary=001a114fa4c274fbf7052fdb2ec3

--001a114fa4c274fbf7052fdb2ec3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2016=E5=B9=B44=E6=9C=887=E6=97=A5 02:34=EF=BC=8C"Eric Sandeen" <sandeen@red=
hat.com>=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/6/16 12:39 PM, Zorro Lang wrote:
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
> Thanks, I think this makes sense; so this solves 2 problems.
>
> 1) always print the id # if there is no name mapping during quota report,
and
> 2) always print default project quota information, even if no PRID 0 in
in the projects map.
>
> UID & GID always (?) have an ID 0 defined (if the system has no root user
or group,
> something is very odd, but it is normal to have no PRID 0 defined)
>
> other comments below.

Yes, I should add some comments. And I will add one line in xfs_quota man
page about report command too.
>
> > ---
> >
> > Hi,
> >
> > This's a problem from GETNEXTQUOTA feature. The original disscussion
> > is as below:
> >
> > http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=3D19=
68
> >
> > Then Eryu send a patch to xfstests, try to fix the test failure bring
> > by this bug. The disscussion is as below:
> >
> > http://oss.sgi.com/archives/xfs/2016-04/msg00002.html
> >
> > Finally we decided to fix this problem in xfsprogs. After talked with
> > Eric Sandeen, I wrote this patch. At first, Eric thought we shouldn't
> > print project id 0 quota information, if no one set limit for it.
> >
> > Then he change his mind to always print "root" as project id 0's name,
> > if no one define a name for it. But there's another problem, if we
> > print "root" for project id 0, but we can't run:
> >
> >   xfs_quota -xc "limit -p xxx xxx root" $mnt
> >
> > Because the "root" is a fake name. Then I suggest to print id number,
> > if the name can't be found. This method not only used for project id
> > 0, it used for all user/group/project IDs which no name defined.
> >
> > So this patch should be the V3 patch. We can't sure which one is the
> > best idea. If anyone have better idea, please tell me.
> >
> > Thanks,
> > Zorro
> >
> >  quota/report.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/quota/report.c b/quota/report.c
> > index 48a3f29..557d667 100644
> > --- a/quota/report.c
> > +++ b/quota/report.c
> > @@ -389,7 +389,10 @@ report_mount(
> >                                       name =3D p->pr_name;
> >                       }
> >               }
> > -             fprintf(fp, "%-10s", name);
>
> Could use a comment:
>
> +               /* If no name is found, print the id # instead of (null)
*/
>
> > +             if (name !=3D NULL)
> > +                     fprintf(fp, "%-10s", name);
> > +             else
> > +                     fprintf(fp, "#%-10u", d.d_id);
> >       }
> >
> >       if (form & XFS_BLOCK_QUOTA) {
> > @@ -571,6 +574,12 @@ report_project_mount(
> >                       id =3D oid + 1;
> >               }
> >       } else {
>
> Comment:
>
> +               /* Print default project quota even if PRID 0 isn't
defined */
>
> > +             if (!getprprid(0)) {
> > +                     report_mount(fp, 0, "#0", NULL, form,
XFS_PROJ_QUOTA,
>
> If you pass in NULL instead of "#0" does report_mount do the right thing?
> If so, better to not hard-code "#0" here.

This's a good idea! Better than use hard=E2=80=93code #0 which looks ugly.

I will send V2 patch to fix all above problems.

Thanks,
Zorro
>
> -Eric
>
> > +                                  mount, flags);
> > +                     flags |=3D NO_HEADER_FLAG;
> > +             }
> > +
> >               setprent();
> >               while ((p =3D getprent()) !=3D NULL) {
> >                       if (report_mount(fp, p->pr_prid, p->pr_name, NULL=
,
> >
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--001a114fa4c274fbf7052fdb2ec3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
2016=E5=B9=B44=E6=9C=887=E6=97=A5 02:34=EF=BC=8C&quot;Eric Sandeen&quot; &l=
t;<a href=3D"mailto:sandeen@redhat.com">sandeen@redhat.com</a>&gt;=E5=86=99=
=E9=81=93=EF=BC=9A<br>
&gt;<br>
&gt; On 4/6/16 12:39 PM, Zorro Lang wrote:<br>
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
&gt; Thanks, I think this makes sense; so this solves 2 problems.<br>
&gt;<br>
&gt; 1) always print the id # if there is no name mapping during quota repo=
rt, and<br>
&gt; 2) always print default project quota information, even if no PRID 0 i=
n in the projects map.<br>
&gt;<br>
&gt; UID &amp; GID always (?) have an ID 0 defined (if the system has no ro=
ot user or group,<br>
&gt; something is very odd, but it is normal to have no PRID 0 defined)<br>
&gt;<br>
&gt; other comments below.</p>
<p dir=3D"ltr">Yes, I should add some comments. And I will add one line in =
xfs_quota man page about report command too.<br>
&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;<br>
&gt; &gt; Hi,<br>
&gt; &gt;<br>
&gt; &gt; This&#39;s a problem from GETNEXTQUOTA feature. The original diss=
cussion<br>
&gt; &gt; is as below:<br>
&gt; &gt;<br>
&gt; &gt; <a href=3D"http://thread.gmane.org/gmane.comp.file-systems.fstest=
s/1852/focus=3D1968">http://thread.gmane.org/gmane.comp.file-systems.fstest=
s/1852/focus=3D1968</a><br>
&gt; &gt;<br>
&gt; &gt; Then Eryu send a patch to xfstests, try to fix the test failure b=
ring<br>
&gt; &gt; by this bug. The disscussion is as below:<br>
&gt; &gt;<br>
&gt; &gt; <a href=3D"http://oss.sgi.com/archives/xfs/2016-04/msg00002.html"=
>http://oss.sgi.com/archives/xfs/2016-04/msg00002.html</a><br>
&gt; &gt;<br>
&gt; &gt; Finally we decided to fix this problem in xfsprogs. After talked =
with<br>
&gt; &gt; Eric Sandeen, I wrote this patch. At first, Eric thought we shoul=
dn&#39;t<br>
&gt; &gt; print project id 0 quota information, if no one set limit for it.=
<br>
&gt; &gt;<br>
&gt; &gt; Then he change his mind to always print &quot;root&quot; as proje=
ct id 0&#39;s name,<br>
&gt; &gt; if no one define a name for it. But there&#39;s another problem, =
if we<br>
&gt; &gt; print &quot;root&quot; for project id 0, but we can&#39;t run:<br=
>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0xfs_quota -xc &quot;limit -p xxx xxx root&quot; $mnt<=
br>
&gt; &gt;<br>
&gt; &gt; Because the &quot;root&quot; is a fake name. Then I suggest to pr=
int id number,<br>
&gt; &gt; if the name can&#39;t be found. This method not only used for pro=
ject id<br>
&gt; &gt; 0, it used for all user/group/project IDs which no name defined.<=
br>
&gt; &gt;<br>
&gt; &gt; So this patch should be the V3 patch. We can&#39;t sure which one=
 is the<br>
&gt; &gt; best idea. If anyone have better idea, please tell me.<br>
&gt; &gt;<br>
&gt; &gt; Thanks,<br>
&gt; &gt; Zorro<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 quota/report.c | 11 ++++++++++-<br>
&gt; &gt;=C2=A0 1 file changed, 10 insertions(+), 1 deletion(-)<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/quota/report.c b/quota/report.c<br>
&gt; &gt; index 48a3f29..557d667 100644<br>
&gt; &gt; --- a/quota/report.c<br>
&gt; &gt; +++ b/quota/report.c<br>
&gt; &gt; @@ -389,7 +389,10 @@ report_mount(<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0na=
me =3D p-&gt;pr_name;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(fp, &quo=
t;%-10s&quot;, name);<br>
&gt;<br>
&gt; Could use a comment:<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* If no name =
is found, print the id # instead of (null) */<br>
&gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (name !=3D NU=
LL)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0fprintf(fp, &quot;%-10s&quot;, name);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0fprintf(fp, &quot;#%-10u&quot;, d.d_id);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (form &amp; XFS_BLOCK_QUOTA) {<br>
&gt; &gt; @@ -571,6 +574,12 @@ report_project_mount(<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0id =3D oid + 1;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;<br>
&gt; Comment:<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Print defau=
lt project quota even if PRID 0 isn&#39;t defined */<br>
&gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!getprprid(0=
)) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0report_mount(fp, 0, &quot;#0&quot;, NULL, form, XFS_PROJ_QUOTA=
,<br>
&gt;<br>
&gt; If you pass in NULL instead of &quot;#0&quot; does report_mount do the=
 right thing?<br>
&gt; If so, better to not hard-code &quot;#0&quot; here.</p>
<p dir=3D"ltr">This&#39;s a good idea! Better than use hard=E2=80=93code #0=
 which looks ugly.</p>
<p dir=3D"ltr">I will send V2 patch to fix all above problems.</p>
<p dir=3D"ltr">Thanks,<br>
Zorro<br>
&gt;<br>
&gt; -Eric<br>
&gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mount, flags);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0flags |=3D NO_HEADER_FLAG;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0setprent();=
<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while ((p =
=3D getprent()) !=3D NULL) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (report_mount(fp, p-&gt;pr_prid, p-&gt;pr_name, NULL,<b=
r>
&gt; &gt;<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com=
/mailman/listinfo/xfs</a><br>
</p>

--001a114fa4c274fbf7052fdb2ec3--


--===============1081983286245415095==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1081983286245415095==--
