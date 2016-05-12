Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 445917CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 19:22:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D0F368F8054
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 17:22:28 -0700 (PDT)
Received: from mail-yw0-f196.google.com (mail-yw0-f196.google.com
	[209.85.161.196]) by cuda.sgi.com with ESMTP id
	OpFIOC7qz2eIA3jm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 17:22:26 -0700 (PDT)
Received: by mail-yw0-f196.google.com with SMTP id v81so5901725ywa.2
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 17:22:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <469fcded-5869-239c-8668-1b58a6b0eedd@sandeen.net>
References: <1462979156-7648-1-git-send-email-zlang@redhat.com>
	<e0126658-70f7-f8f9-d3bd-a47df2c6ce96@sandeen.net>
	<20160511173621.GC17859@dhcp12-143.nay.redhat.com>
	<469fcded-5869-239c-8668-1b58a6b0eedd@sandeen.net>
Date: Thu, 12 May 2016 08:22:25 +0800
Message-ID: <CADVQ27r3=to8gzLHrODAM2geDFu=XNTcXuD4219kNs+Rf4WKEA@mail.gmail.com>
Subject: Re: [PATCH] xfs/133 134: filter redundant projid 0 quota report
From: Zorro Lang <zorro.lang@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2634306169011919658=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

--===============2634306169011919658==
Content-Type: multipart/alternative; boundary=001a113cb006138cff05329a2788

--001a113cb006138cff05329a2788
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2016=E5=B9=B45=E6=9C=8812=E6=97=A5 02:54=EF=BC=8C"Eric Sandeen" <sandeen@sa=
ndeen.net>=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 5/11/16 12:36 PM, Zorro Lang wrote:
> > On Wed, May 11, 2016 at 11:04:28AM -0500, Eric Sandeen wrote:
> >> On 5/11/16 10:05 AM, Zorro Lang wrote:
> >>> After GETNEXTQUOTA ioctl be supported, xfs_quota -c "report" always
> >>> outputs one more quota info about default quota (as project ID 0).
> >>> For fix this problem, xfsprogs has merged commit 3d607a1.
> >>
> >> This is only for project quota, right?  user & group quota always
> >> reports id 0 / root, because it exists in the passwd and group files.
> >
> > Yes, only for project quota. The truth is we decide to report project
> > quota #0 always, so we can just add one line "#0 0 0 0 00 ...." into
> > xfs/133 and xfs/134 golden output file simply.
> >
> > But for history reason, we can't do that. Mostly old xfsprogs still
> > report "(null) 0 0 0 00 ..."(if use GETNEXTQUOTA), or don't report
> > project id #0 (if use old GETQUOTA).
>
> Right, so filter that out? ;)
>
> ...
>
> >> Why not just do it as an actual filter, i.e.:
> >>
> >>
> >>
> >> diff --git a/common/filter b/common/filter
> >> index 1be377c..2012729 100644
> >> --- a/common/filter
> >> +++ b/common/filter
> >> @@ -302,6 +302,13 @@ _filter_quota()
> >>      sed -e 'N;s/TEST_DEV\n/TEST_DEV/g'
> >>  }
> >>
> >> +_filter_project_quota()
> >> +{
> >> +    # Project ID 0 is always present on disk but was not reported
> >> +    # until the GETNEXTQUOTA ioctl came into use.  Filter it out.
> >> +    _filter_quota | grep -v "^\#0"
> >> +}
> >
> > I thought about this before I send this patch. But I don't know if it's
> > necessary to add a new common function. I thought the one who write
> > a case need to report project, who can decide how to deal with
> > its project id #0 output.
> >
> > Likes what I did in xfs/133. I named projid 0 to "root", then fileter
> > project name root directly. If we add a function named
_filter_project_quota,
> > and we tell others it can filter project ID 0. But if someone named
> > projid #0, this function become hard to understand.
>
> yes, but that's a lot of manual fiddling for every test that does a repor=
t
> of a project quota.  Most don't care at all about id 0.
>
> If someone wants project ID 0 reported, just use _filter_quota instead
> of _filter_project_quota.
>
> If someone gives prjid 0 a name "foobarbaz" then it won't be filtered,
> and I think that's fine, they were doing something quite intentional.
> All the filter does is suppress the default output which is new to any
> test reporting project quota.
>
> > Likes xfs/299, it named projid #0 to "root", and add "root" quota outpu=
t
> > into golden image. That's another way to deal with this bug. Maybe
better?
>
> I really think that a single, common filter function for a common form
> of output makes more sense than expecting each test to handle it on a
> case-by-case basis.

Hmm, I can't find more reason to refute this. So l'll follow your
suggestion and send the v2 patch soon :)

Thanks,
Zorro
>
> -Eric
>
> > Thanks,
> > Zorro
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--001a113cb006138cff05329a2788
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
2016=E5=B9=B45=E6=9C=8812=E6=97=A5 02:54=EF=BC=8C&quot;Eric Sandeen&quot; &=
lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;=E5=86=
=99=E9=81=93=EF=BC=9A<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On 5/11/16 12:36 PM, Zorro Lang wrote:<br>
&gt; &gt; On Wed, May 11, 2016 at 11:04:28AM -0500, Eric Sandeen wrote:<br>
&gt; &gt;&gt; On 5/11/16 10:05 AM, Zorro Lang wrote:<br>
&gt; &gt;&gt;&gt; After GETNEXTQUOTA ioctl be supported, xfs_quota -c &quot=
;report&quot; always<br>
&gt; &gt;&gt;&gt; outputs one more quota info about default quota (as proje=
ct ID 0).<br>
&gt; &gt;&gt;&gt; For fix this problem, xfsprogs has merged commit 3d607a1.=
<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; This is only for project quota, right?=C2=A0 user &amp; group=
 quota always<br>
&gt; &gt;&gt; reports id 0 / root, because it exists in the passwd and grou=
p files.<br>
&gt; &gt;<br>
&gt; &gt; Yes, only for project quota. The truth is we decide to report pro=
ject<br>
&gt; &gt; quota #0 always, so we can just add one line &quot;#0 0 0 0 00 ..=
..&quot; into<br>
&gt; &gt; xfs/133 and xfs/134 golden output file simply.<br>
&gt; &gt;<br>
&gt; &gt; But for history reason, we can&#39;t do that. Mostly old xfsprogs=
 still<br>
&gt; &gt; report &quot;(null) 0 0 0 00 ...&quot;(if use GETNEXTQUOTA), or d=
on&#39;t report<br>
&gt; &gt; project id #0 (if use old GETQUOTA).<br>
&gt;<br>
&gt; Right, so filter that out? ;)<br>
&gt;<br>
&gt; ...<br>
&gt;<br>
&gt; &gt;&gt; Why not just do it as an actual filter, i.e.:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; diff --git a/common/filter b/common/filter<br>
&gt; &gt;&gt; index 1be377c..2012729 100644<br>
&gt; &gt;&gt; --- a/common/filter<br>
&gt; &gt;&gt; +++ b/common/filter<br>
&gt; &gt;&gt; @@ -302,6 +302,13 @@ _filter_quota()<br>
&gt; &gt;&gt;=C2=A0 =C2=A0 =C2=A0 sed -e &#39;N;s/TEST_DEV\n/TEST_DEV/g&#39=
;<br>
&gt; &gt;&gt;=C2=A0 }<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; +_filter_project_quota()<br>
&gt; &gt;&gt; +{<br>
&gt; &gt;&gt; +=C2=A0 =C2=A0 # Project ID 0 is always present on disk but w=
as not reported<br>
&gt; &gt;&gt; +=C2=A0 =C2=A0 # until the GETNEXTQUOTA ioctl came into use.=
=C2=A0 Filter it out.<br>
&gt; &gt;&gt; +=C2=A0 =C2=A0 _filter_quota | grep -v &quot;^\#0&quot;<br>
&gt; &gt;&gt; +}<br>
&gt; &gt;<br>
&gt; &gt; I thought about this before I send this patch. But I don&#39;t kn=
ow if it&#39;s<br>
&gt; &gt; necessary to add a new common function. I thought the one who wri=
te<br>
&gt; &gt; a case need to report project, who can decide how to deal with<br=
>
&gt; &gt; its project id #0 output.<br>
&gt; &gt;<br>
&gt; &gt; Likes what I did in xfs/133. I named projid 0 to &quot;root&quot;=
, then fileter<br>
&gt; &gt; project name root directly. If we add a function named _filter_pr=
oject_quota,<br>
&gt; &gt; and we tell others it can filter project ID 0. But if someone nam=
ed<br>
&gt; &gt; projid #0, this function become hard to understand.<br>
&gt;<br>
&gt; yes, but that&#39;s a lot of manual fiddling for every test that does =
a report<br>
&gt; of a project quota.=C2=A0 Most don&#39;t care at all about id 0.<br>
&gt;<br>
&gt; If someone wants project ID 0 reported, just use _filter_quota instead=
<br>
&gt; of _filter_project_quota.<br>
&gt;<br>
&gt; If someone gives prjid 0 a name &quot;foobarbaz&quot; then it won&#39;=
t be filtered,<br>
&gt; and I think that&#39;s fine, they were doing something quite intention=
al.<br>
&gt; All the filter does is suppress the default output which is new to any=
<br>
&gt; test reporting project quota.<br>
&gt;<br>
&gt; &gt; Likes xfs/299, it named projid #0 to &quot;root&quot;, and add &q=
uot;root&quot; quota output<br>
&gt; &gt; into golden image. That&#39;s another way to deal with this bug. =
Maybe better?<br>
&gt;<br>
&gt; I really think that a single, common filter function for a common form=
<br>
&gt; of output makes more sense than expecting each test to handle it on a<=
br>
&gt; case-by-case basis.</p>
<p dir=3D"ltr">Hmm, I can&#39;t find more reason to refute this. So l&#39;l=
l follow your suggestion and send the v2 patch soon :)</p>
<p dir=3D"ltr">Thanks,<br>
Zorro<br>
&gt;<br>
&gt; -Eric<br>
&gt;<br>
&gt; &gt; Thanks,<br>
&gt; &gt; Zorro<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com=
/mailman/listinfo/xfs</a><br>
</p>

--001a113cb006138cff05329a2788--


--===============2634306169011919658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2634306169011919658==--
