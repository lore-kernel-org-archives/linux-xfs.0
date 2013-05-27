Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 403657F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 20:21:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 298298F8035
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:21:07 -0700 (PDT)
Received: from mail-qa0-f49.google.com (mail-qa0-f49.google.com
	[209.85.216.49]) by cuda.sgi.com with ESMTP id 6xbY5vaQMXQm2rqI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 26 May 2013 18:21:06 -0700 (PDT)
Received: by mail-qa0-f49.google.com with SMTP id j11so750575qag.15
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:21:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51A280A5.6000507@gmail.com>
References: <1369523732-10649-1-git-send-email-zwu.kernel@gmail.com>
	<51A280A5.6000507@gmail.com>
Date: Mon, 27 May 2013 09:21:05 +0800
Message-ID: <CAEH94Lgbk_7TRgdr3rVHy2KKgY9DN3cZTXWevs6m2KXoOtJHFw@mail.gmail.com>
Subject: Re: [PATCH] xfstests: cleanup the codes related to h_chksum
From: Zhi Yong Wu <zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6488408024654586732=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

--===============6488408024654586732==
Content-Type: multipart/alternative; boundary=001a11c251e871347404dda8f683

--001a11c251e871347404dda8f683
Content-Type: text/plain; charset=ISO-8859-1

HI,

I don't think that this is one hacking, but one formal patch to fix this
issue.


On Mon, May 27, 2013 at 5:37 AM, Michael L. Semon <mlsemon35@gmail.com>wrote:

> On 05/25/2013 07:15 PM, zwu.kernel@gmail.com wrote:
> > From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >
> >   Since h_chksum field has gone away, we should cleanup the related codes
> >
> >     [CC]    loggen
> > loggen.c: In function 'loggen_unmount':
> > loggen.c:137:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> > loggen.c: In function 'loggen_empty':
> > loggen.c:205:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> >
> > Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> > ---
> >  src/loggen.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/src/loggen.c b/src/loggen.c
> > index 4b55667..522c917 100644
> > --- a/src/loggen.c
> > +++ b/src/loggen.c
> > @@ -134,7 +134,6 @@ loggen_unmount(int count)
> >      head->h_cycle = cpu_to_be32(param_cycle);
> >      head->h_version = cpu_to_be32(1);
> >      head->h_len = cpu_to_be32(20);
> > -    head->h_chksum = cpu_to_be32(0);
> >      head->h_prev_block = cpu_to_be32(-1);
> >      head->h_num_logops = cpu_to_be32(1);
> >      head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
> > @@ -202,7 +201,6 @@ loggen_empty(int count)
> >
>  sizeof(xfs_trans_header_t)+
> >
>  sizeof(xfs_buf_log_format_t)+
> >                                                      sizeof(int));
> > -    head->h_chksum         = cpu_to_be32(0);
> >      head->h_prev_block     = cpu_to_be32(-1);
> >      head->h_num_logops     = cpu_to_be32(5);
> >      head->h_cycle_data[0]  = cpu_to_be32(0xb0c0d0d0);
> >
>
> I've been taking a wild guess and changing "h_chksum" to "h_crc", just
> as a pure sysadmin hack to keep going.  Is there more than one correct
> answer on this issue?
>
> Michael
>
>


-- 
Regards,

Zhi Yong Wu

--001a11c251e871347404dda8f683
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>HI,<br><br></div>I don&#39;t think that this is one h=
acking, but one formal patch to fix this issue.<br></div><div class=3D"gmai=
l_extra"><br><br><div class=3D"gmail_quote">On Mon, May 27, 2013 at 5:37 AM=
, Michael L. Semon <span dir=3D"ltr">&lt;<a href=3D"mailto:mlsemon35@gmail.=
com" target=3D"_blank">mlsemon35@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 0=
5/25/2013 07:15 PM, <a href=3D"mailto:zwu.kernel@gmail.com">zwu.kernel@gmai=
l.com</a> wrote:<br>

&gt; From: Zhi Yong Wu &lt;<a href=3D"mailto:wuzhy@linux.vnet.ibm.com">wuzh=
y@linux.vnet.ibm.com</a>&gt;<br>
&gt;<br>
&gt; =A0 Since h_chksum field has gone away, we should cleanup the related =
codes<br>
&gt;<br>
&gt; =A0 =A0 [CC] =A0 =A0loggen<br>
&gt; loggen.c: In function &#39;loggen_unmount&#39;:<br>
&gt; loggen.c:137:9: error: &#39;xlog_rec_header_t&#39; has no member named=
 &#39;h_chksum&#39;<br>
&gt; loggen.c: In function &#39;loggen_empty&#39;:<br>
&gt; loggen.c:205:9: error: &#39;xlog_rec_header_t&#39; has no member named=
 &#39;h_chksum&#39;<br>
&gt;<br>
&gt; Signed-off-by: Zhi Yong Wu &lt;<a href=3D"mailto:wuzhy@linux.vnet.ibm.=
com">wuzhy@linux.vnet.ibm.com</a>&gt;<br>
&gt; ---<br>
&gt; =A0src/loggen.c | =A0 =A02 --<br>
&gt; =A01 files changed, 0 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/src/loggen.c b/src/loggen.c<br>
&gt; index 4b55667..522c917 100644<br>
&gt; --- a/src/loggen.c<br>
&gt; +++ b/src/loggen.c<br>
&gt; @@ -134,7 +134,6 @@ loggen_unmount(int count)<br>
&gt; =A0 =A0 =A0head-&gt;h_cycle =3D cpu_to_be32(param_cycle);<br>
&gt; =A0 =A0 =A0head-&gt;h_version =3D cpu_to_be32(1);<br>
&gt; =A0 =A0 =A0head-&gt;h_len =3D cpu_to_be32(20);<br>
&gt; - =A0 =A0head-&gt;h_chksum =3D cpu_to_be32(0);<br>
&gt; =A0 =A0 =A0head-&gt;h_prev_block =3D cpu_to_be32(-1);<br>
&gt; =A0 =A0 =A0head-&gt;h_num_logops =3D cpu_to_be32(1);<br>
&gt; =A0 =A0 =A0head-&gt;h_cycle_data[0] =3D cpu_to_be32(0xb0c0d0d0);<br>
&gt; @@ -202,7 +201,6 @@ loggen_empty(int count)<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(xfs_trans_header_t)+<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(xfs_buf_log_format_t)+<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(int));<br>
&gt; - =A0 =A0head-&gt;h_chksum =A0 =A0 =A0 =A0 =3D cpu_to_be32(0);<br>
&gt; =A0 =A0 =A0head-&gt;h_prev_block =A0 =A0 =3D cpu_to_be32(-1);<br>
&gt; =A0 =A0 =A0head-&gt;h_num_logops =A0 =A0 =3D cpu_to_be32(5);<br>
&gt; =A0 =A0 =A0head-&gt;h_cycle_data[0] =A0=3D cpu_to_be32(0xb0c0d0d0);<br=
>
&gt;<br>
<br>
</div></div>I&#39;ve been taking a wild guess and changing &quot;h_chksum&q=
uot; to &quot;h_crc&quot;, just<br>
as a pure sysadmin hack to keep going. =A0Is there more than one correct<br=
>
answer on this issue?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Michael<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div>Rega=
rds,</div><div>=A0</div><div>Zhi Yong Wu</div>
</div>

--001a11c251e871347404dda8f683--


--===============6488408024654586732==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6488408024654586732==--
