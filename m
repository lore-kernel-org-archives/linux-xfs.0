Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OFqnko189253 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 10:52:49 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A065E62D6A
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 09:06:24 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id ur5oucNfFSSXMbVr
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 09:06:24 -0700 (PDT)
Received: by fxm14 with SMTP id 14so2021209fxm.26
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:53:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100917014412.GK24409@dastard>
References: <AANLkTimR-dBLmQQ-Nh0mmjHJMfFidePKxfO6P76y48n8@mail.gmail.com>
	<20100917014412.GK24409@dastard>
Date: Fri, 24 Sep 2010 10:53:43 -0500
Message-ID: <AANLkTi=mGBXYLgwL96VqtF+8eMCxu83mz0V5719YPrkH@mail.gmail.com>
Subject: Re: The segment fault with NULL point using when recovering failure
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6386363360255499679=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>

--===============6386363360255499679==
Content-Type: multipart/alternative; boundary=00163641711919628304910362ff

--00163641711919628304910362ff
Content-Type: text/plain; charset=ISO-8859-1

I am curious about how this happens.
This error is caused by log recovery when mount try to fill super block. As
super block is protected by log or Journaling, it shouldn't be corrupted or
can't be recovery by journaling.

Anyway, this is reported as XFS INTERNAL ERROR.

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4147 of file
fs/xfs/xfs_bmap.c.  Caller 0x871b9c26


Thanks,
Mike

On Thu, Sep 16, 2010 at 8:44 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Sep 15, 2010 at 10:59:07AM -0500, Mike Gao wrote:
> > xlog_recover_process_iunlinks(
> >     xlog_t        *log)
> > {
> >                 /*
> >                  * Reacquire the agibuffer and continue around
> >                  * the loop. This should never fail as we know
> >                  * the buffer was good earlier on.
> >                  */
> >                 error = xfs_read_agi(mp, NULL, agno, &agibp);
> >                 ASSERT(error == 0);
> >                 agi = XFS_BUF_TO_AGI(agibp);
> >
> > }
> > If no defined DEBUG, ASSERT will not work and agibp could be ZERO if
> there
> > is a error in xfs_read_agi.
> > And the comment shouldn't say it never fail because  xfs_read_agi will
> > return error in function and it does when there is forced shutdown.
>
> Have you seen a failure here?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--00163641711919628304910362ff
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I am curious about how this happens.=A0<div>This error is caused by log rec=
overy when mount try to fill super block. As super block is protected by lo=
g or Journaling, it shouldn&#39;t be corrupted or can&#39;t be recovery by =
journaling.</div>
<div><br></div><div>Anyway, this is reported as XFS INTERNAL ERROR.</div><d=
iv><br></div><div>XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4147 o=
f file fs/xfs/xfs_bmap.c. =A0Caller 0x871b9c26<br><br></div><div><br></div>
<div>Thanks,</div><div>Mike</div><div><br><div class=3D"gmail_quote">On Thu=
, Sep 16, 2010 at 8:44 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:david@fromorbit.com">david@fromorbit.com</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex;">
<div><div></div><div class=3D"h5">On Wed, Sep 15, 2010 at 10:59:07AM -0500,=
 Mike Gao wrote:<br>
&gt; xlog_recover_process_iunlinks(<br>
&gt; =A0 =A0 xlog_t =A0 =A0 =A0 =A0*log)<br>
&gt; {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Reacquire the agibuffer and conti=
nue around<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the loop. This should never fail =
as we know<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the buffer was good earlier on.<b=
r>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D xfs_read_agi(mp, NULL, agno,=
 &amp;agibp);<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ASSERT(error =3D=3D 0);<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 agi =3D XFS_BUF_TO_AGI(agibp);<br>
&gt;<br>
&gt; }<br>
&gt; If no defined DEBUG, ASSERT will not work and agibp could be ZERO if t=
here<br>
&gt; is a error in xfs_read_agi.<br>
&gt; And the comment shouldn&#39;t say it never fail because =A0xfs_read_ag=
i will<br>
&gt; return error in function and it does when there is forced shutdown.<br=
>
<br>
</div></div>Have you seen a failure here?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></blockquote></div><br></div>

--00163641711919628304910362ff--


--===============6386363360255499679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6386363360255499679==--
