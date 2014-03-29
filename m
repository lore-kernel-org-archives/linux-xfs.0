Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E63AC7F4E
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 21:09:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9FC18F8074
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 19:09:02 -0700 (PDT)
Received: from mail-vc0-f177.google.com (mail-vc0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	pdKQf1DsMbE6r0tt (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 19:08:59 -0700 (PDT)
Received: by mail-vc0-f177.google.com with SMTP id if17so6476435vcb.8
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 19:08:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53362834.7090900@sandeen.net>
References: <20140328080313.GA25192@mwanda>
	<53362834.7090900@sandeen.net>
Date: Fri, 28 Mar 2014 23:08:58 -0300
Message-ID: <CACz=WefaDYh6ceQeBdfqJuSnnWfUXA9+U6K-wJ5FH+gvfDTB5w@mail.gmail.com>
Subject: Re: [patch] xfs: extra semi-colon breaks a condition
From: Raphael S Carvalho <raphael.scarv@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5216081594890269080=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, xfs@oss.sgi.com

--===============5216081594890269080==
Content-Type: multipart/alternative; boundary=089e013a1fcc1d888604f5b54de0

--089e013a1fcc1d888604f5b54de0
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 28, 2014 at 10:56 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/28/14, 3:03 AM, Dan Carpenter wrote:
> > There were some extra semi-colons here which mean that we return true
> > unintentionally.
> >
> > Fixes: a49935f200e2 ('xfs: xfs_check_page_type buffer checks need help')
>
> that's terrifying.
>
Wonder how errors like this one get into the kernel :-) Suppose it's not
the main tree, but instead xfs private one.

>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>

> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 98016b3..75df77d 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -659,10 +659,10 @@ xfs_check_page_type(
> >                       if (type == XFS_IO_UNWRITTEN)
> >                               return true;
> >               } else if (buffer_delay(bh)) {
> > -                     if (type == XFS_IO_DELALLOC);
> > +                     if (type == XFS_IO_DELALLOC)
> >                               return true;
> >               } else if (buffer_dirty(bh) && buffer_mapped(bh)) {
> > -                     if (type == XFS_IO_OVERWRITE);
> > +                     if (type == XFS_IO_OVERWRITE)
> >                               return true;
> >               }
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Raphael S. Carvalho

--089e013a1fcc1d888604f5b54de0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Fri, Mar 28, 2014 at 10:56 PM, Eric Sandeen <span dir=3D"ltr">&l=
t;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.=
net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex"><div class=3D"">On 3/28/1=
4, 3:03 AM, Dan Carpenter wrote:<br>
&gt; There were some extra semi-colons here which mean that we return true<=
br>
&gt; unintentionally.<br>
&gt;<br>
&gt; Fixes: a49935f200e2 (&#39;xfs: xfs_check_page_type buffer checks need =
help&#39;)<br>
<br>
</div>that&#39;s terrifying.<br></blockquote><div>Wonder how errors like th=
is one get into the kernel :-) Suppose it&#39;s not the main tree, but inst=
ead xfs private one.<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex">

<br>
Reviewed-by: Eric Sandeen &lt;<a href=3D"mailto:sandeen@redhat.com">sandeen=
@redhat.com</a>&gt;<br></blockquote><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">

<div class=3D"im"><br>
&gt; Signed-off-by: Dan Carpenter &lt;<a href=3D"mailto:dan.carpenter@oracl=
e.com">dan.carpenter@oracle.com</a>&gt;<br>
&gt;<br>
&gt; diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c<br>
&gt; index 98016b3..75df77d 100644<br>
&gt; --- a/fs/xfs/xfs_aops.c<br>
&gt; +++ b/fs/xfs/xfs_aops.c<br>
&gt; @@ -659,10 +659,10 @@ xfs_check_page_type(<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D XFS_IO_UNW=
RITTEN)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return tru=
e;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (buffer_delay(bh)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D XFS_IO_DELAL=
LOC);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D XFS_IO_DELAL=
LOC)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return tru=
e;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (buffer_dirty(bh) &amp;&amp; buf=
fer_mapped(bh)) {<br>
&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D XFS_IO_OVERW=
RITE);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D XFS_IO_OVERW=
RITE)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return tru=
e;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt;<br>
&gt;<br>
</div><div class=3D"im">&gt; ______________________________________________=
_<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div><div class=3D""><div class=3D"h5">--<br>
To unsubscribe from this list: send the line &quot;unsubscribe kernel-janit=
ors&quot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>Raphael S. =
Carvalho
</div></div>

--089e013a1fcc1d888604f5b54de0--


--===============5216081594890269080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5216081594890269080==--
