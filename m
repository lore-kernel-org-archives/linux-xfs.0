Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8O1KaeF183615 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 20:20:36 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 373B71C3CB29
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 18:20:32 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	rdAGprqnpEa2TFUK for <xfs@oss.sgi.com>;
	Fri, 23 Sep 2011 18:20:32 -0700 (PDT)
Received: by gyd10 with SMTP id 10so4003090gyd.26
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 18:20:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109240109.45532@zmi.at>
References: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
	<20110923163354.GA24319@infradead.org> <201109240109.45532@zmi.at>
Date: Sat, 24 Sep 2011 09:20:31 +0800
Message-ID: <CAF7KpS_zugTJUBnSXpHGJ8XR9N=+LZXNfPT-cuXx-LY2e=uCtA@mail.gmail.com>
Subject: Re: Directory fsync
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4771588203156933848=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

--===============4771588203156933848==
Content-Type: multipart/alternative; boundary=20cf305e25515d204b04ada5bbf4

--20cf305e25515d204b04ada5bbf4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 24, 2011 at 7:09 AM, Michael Monnerie <
michael.monnerie@is.it-management.at> wrote:

> On Freitag, 23. September 2011 Christoph Hellwig wrote:
> > As far as standards are concerned it is.  As far as the current XFS
> > implementation is concerned you don't need it as the file fsync will
> > also force out all transactions that belong to the create.
>
> Aren't you giving O_PONIES to the users? ;-)
>
> I understand your description, but we should always tell people to use a
> directory fsync to be sure. Their applications might run on other
> filesystems, or run for 10 years, and maybe XFS's implementation changes
> in between. And maybe in historical kernels even XFS's implementation
> wasn't like it's now?
>

Thank you all.

I see the importance of following the standard. But I am glad to know the
current implementation of XFS enforce more strict fsync semantic, just as
every application developer wishes.

What I worry is not much applications syncs the directory after new files
are created, even if PostgreSQL[1] and many other NoSQL database.  If the
current implementation forces more strict semantic, it makes our mind much
much more peaceful.

And , not many runtime supports sync of directory, e.g. java ecosystem does
not have such support... So it is very very hard to follow this standard.

For God's sake, the right semantic of fsync should be "The users wants to
assure the file is retrievable after system crash or power failure if fsync
returned successfully".

[1]
http://postgresql.1045698.n5.nabble.com/fsync-reliability-td4330289.html

>
> @schumi: If your application should be able to run in a safe way on
> other filesystems, or other kernel releases, or other unixes, it's best
> to fsync the directory inode too. It's better to use it always, then
> nothing won't break.
>
> --
> mit freundlichen Gr=FCssen,
> Michael Monnerie, Ing. BSc
>
> it-management Internet Services: Prot=E9ger
> http://proteger.at [gesprochen: Prot-e-schee]
> Tel: +43 660 / 415 6531
>
> // Haus zu verkaufen: http://zmi.at/langegg/
>

--20cf305e25515d204b04ada5bbf4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div class=3D"gmail_quote">On Sat, Sep 24, 2011 at 7:09 AM, Michael Mon=
nerie <span dir=3D"ltr">&lt;<a href=3D"mailto:michael.monnerie@is.it-manage=
ment.at">michael.monnerie@is.it-management.at</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex;">
<div class=3D"im">On Freitag, 23. September 2011 Christoph Hellwig wrote:<b=
r>
&gt; As far as standards are concerned it is. =A0As far as the current XFS<=
br>
&gt; implementation is concerned you don&#39;t need it as the file fsync wi=
ll<br>
&gt; also force out all transactions that belong to the create.<br>
<br>
</div>Aren&#39;t you giving O_PONIES to the users? ;-)<br>
<br>
I understand your description, but we should always tell people to use a<br=
>
directory fsync to be sure. Their applications might run on other<br>
filesystems, or run for 10 years, and maybe XFS&#39;s implementation change=
s<br>
in between. And maybe in historical kernels even XFS&#39;s implementation<b=
r>
wasn&#39;t like it&#39;s now?<br></blockquote><div><br>Thank you all. <br><=
br>I see the importance of following the standard. But I am glad to know th=
e current implementation of XFS enforce more strict fsync semantic, just as=
 every application developer wishes.<br>
<br>What I worry is not much applications syncs the directory after new fil=
es are created, even if PostgreSQL[1] and many other NoSQL database.=A0 If =
the current implementation forces more strict semantic, it makes our mind m=
uch much more peaceful.<br>
<br>And , not many runtime supports sync of directory, e.g. java ecosystem =
does not have such support... So it is very very hard to follow this standa=
rd. <br><br>For God&#39;s sake, the right semantic of fsync should be &quot=
;The users wants to assure the file is retrievable after system crash or po=
wer failure if fsync returned successfully&quot;.=A0 <br>
<br>[1]=A0 <a href=3D"http://postgresql.1045698.n5.nabble.com/fsync-reliabi=
lity-td4330289.html">http://postgresql.1045698.n5.nabble.com/fsync-reliabil=
ity-td4330289.html</a><br></div><blockquote class=3D"gmail_quote" style=3D"=
margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); paddi=
ng-left: 1ex;">

<br>
@schumi: If your application should be able to run in a safe way on<br>
other filesystems, or other kernel releases, or other unixes, it&#39;s best=
<br>
to fsync the directory inode too. It&#39;s better to use it always, then<br=
>
nothing won&#39;t break.<br>
<br>
--<br>
mit freundlichen Gr=FCssen,<br>
Michael Monnerie, Ing. BSc<br>
<br>
it-management Internet Services: Prot=E9ger<br>
<a href=3D"http://proteger.at" target=3D"_blank">http://proteger.at</a> [ge=
sprochen: Prot-e-schee]<br>
Tel: <a href=3D"tel:%2B43%20660%20%2F%20415%206531" value=3D"+436604156531"=
>+43 660 / 415 6531</a><br>
<br>
// Haus zu verkaufen: <a href=3D"http://zmi.at/langegg/" target=3D"_blank">=
http://zmi.at/langegg/</a><br>
</blockquote></div><br>

--20cf305e25515d204b04ada5bbf4--


--===============4771588203156933848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4771588203156933848==--
