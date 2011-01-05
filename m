Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p058OPcx129580 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 02:24:25 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B37DFA479E
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 00:26:32 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	jLyNsbcGCFQgkCpy for <xfs@oss.sgi.com>;
	Wed, 05 Jan 2011 00:26:32 -0800 (PST)
Received: by qyk12 with SMTP id 12so16985830qyk.5
	for <xfs@oss.sgi.com>; Wed, 05 Jan 2011 00:26:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110104051947.GI15179@dastard>
References: <AANLkTi=Tmh9m_Rwy-bUZQEzcZ3M+6X9tZxFMO-J2Rvec@mail.gmail.com>
	<20101230231353.GC15179@dastard>
	<AANLkTi=OK4uGx5476ro8W47icu685gvQea43rNHozPKS@mail.gmail.com>
	<20110104051947.GI15179@dastard>
Date: Wed, 5 Jan 2011 17:26:31 +0900
Message-ID: <AANLkTing_nBZXQXN=9Dph10vuHx+MMMZkqqmGiZZe73j@mail.gmail.com>
Subject: Re: XFS handling of synchronous buffers in case of EIO error
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0013131223730584769=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0013131223730584769==
Content-Type: multipart/alternative; boundary=0016367f985e71d4e704991524b0

--0016367f985e71d4e704991524b0
Content-Type: text/plain; charset=ISO-8859-1

Thanks, I think its better to end this mail by rerering to your patch.

http://oss.sgi.com/archives/xfs/2011-01/msg00020.html



On Tue, Jan 4, 2011 at 2:19 PM, Dave Chinner <david@fromorbit.com> wrote:

>  On Fri, Dec 31, 2010 at 12:17:12PM +0530, Ajeet Yadav wrote:
> > Dear Dave,
> >
> > Our Kernel is 2.6.30.9 but XFS is backported from 2.6.34.
> > But I have seen similar behaviour in another post related to process ls
> hang
> > in 2.6.35.9
> > *
> >
> > http://oss.sgi.com/pipermail/xfs/2010-December/048691.html
> >
> > *I have always seen the hang problem comes only if comes when b_relse !=
> > NULL, and b_hold > 2
> >
> > I have made below workaround it solved the problem in our case because
> when
> > USB is removed we know we get EIO error.
> >
> > But I think we need to review xfs_buf_error_relse() and xfs_buf_relse()
> > considering  XBF_LOCK flow path.
> >
> > @@ -1047,9 +1047,19 @@ xfs_buf_iodone_callbacks(
> >                         /* We actually overwrite the existing b-relse
> >                            function at times, but we're gonna be shutting
> > down
> >                            anyway. */
> > -                       XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
> > -                       XFS_BUF_DONE(bp);
> > -                       XFS_BUF_FINISH_IOWAIT(bp);
> > +                       if (XFS_BUF_GETERROR(bp) == EIO){
> > +                               ASSERT(XFS_BUF_TARGET(bp) ==
> > mp->m_ddev_targp);
> > +                               XFS_BUF_SUPER_STALE(bp);
> > +                               trace_xfs_buf_item_iodone(bp, _RET_IP_);
> > +                               xfs_buf_do_callbacks(bp, lip);
> > +                               XFS_BUF_SET_FSPRIVATE(bp, NULL);
> > +                               XFS_BUF_CLR_IODONE_FUNC(bp);
> > +                               xfs_biodone(bp);
> > +                       } else {
> > +
> > XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
> > +                               XFS_BUF_DONE(bp);
> > +                               XFS_BUF_FINISH_IOWAIT(bp);
> > +                       }
> >                 }
> >                 return;
> >         }
>
> This won't work reliably because it only handles one specific type
> of error. We can get more than just EIO back from the lower layers,
> and so if the superblock write gets a different error then we'll
> still get the same hang.
>
> Effectively what you are doing here is running the
> xfs_buf_error_relse() callback directly in line. This will result in
> the buffer being unlocked before the error is pulled off the buffer
> after xfs_buf_iowait() completes. Essentially that means that some
> other thread can reuse the buffer and clear the error before the
> waiter has received the error.
>
> I think the correct fix is to call the bp->b_relse function when the
> waiter is woken to clear the error and unlock the buffer. I've just
> posted a patch to do this for 2.6.38, but it won't trivially backport
> to 2.6.34 or 2.6.30 as the synchronous write interfaces into the
> buffer cache have been cleaned up and simplified recently. It should
> still be relatively easy to handle, though.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016367f985e71d4e704991524b0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Thanks, I think its better to end this mail by rerering to your patch.=
</div>
<div>=A0</div>
<div><a href=3D"http://oss.sgi.com/archives/xfs/2011-01/msg00020.html">http=
://oss.sgi.com/archives/xfs/2011-01/msg00020.html</a></div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Tue, Jan 4, 2011 at 2:19 PM, Dave Chinner <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.c=
om</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>
<div></div>
<div class=3D"h5">On Fri, Dec 31, 2010 at 12:17:12PM +0530, Ajeet Yadav wro=
te:<br>&gt; Dear Dave,<br>&gt;<br>&gt; Our Kernel is 2.6.30.9 but XFS is ba=
ckported from 2.6.34.<br>&gt; But I have seen similar behaviour in another =
post related to process ls hang<br>
&gt; in 2.6.35.9<br>&gt; *<br>&gt;<br>&gt; <a href=3D"http://oss.sgi.com/pi=
permail/xfs/2010-December/048691.html" target=3D"_blank">http://oss.sgi.com=
/pipermail/xfs/2010-December/048691.html</a><br>&gt;<br>&gt; *I have always=
 seen the hang problem comes only if comes when b_relse !=3D<br>
&gt; NULL, and b_hold &gt; 2<br>&gt;<br>&gt; I have made below workaround i=
t solved the problem in our case because when<br>&gt; USB is removed we kno=
w we get EIO error.<br>&gt;<br>&gt; But I think we need to review xfs_buf_e=
rror_relse() and xfs_buf_relse()<br>
&gt; considering =A0XBF_LOCK flow path.<br>&gt;<br>&gt; @@ -1047,9 +1047,19=
 @@ xfs_buf_iodone_callbacks(<br>&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 /* We actually overwrite the existing b-relse<br>&gt; =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0function at times, but we&#3=
9;re gonna be shutting<br>
&gt; down<br>&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0an=
yway. */<br>&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_BUF_SET_=
BRELSE_FUNC(bp,xfs_buf_error_relse);<br>&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 XFS_BUF_DONE(bp);<br>&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 XFS_BUF_FINISH_IOWAIT(bp);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (XFS_BUF_GETERROR(bp)=
 =3D=3D EIO){<br>&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ASSERT(XFS_BUF_TARGET(bp) =3D=3D<br>&gt; mp-&gt;m_ddev_targp);<br>=
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_BUF_=
SUPER_STALE(bp);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_xf=
s_buf_item_iodone(bp, _RET_IP_);<br>&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_do_callbacks(bp, lip);<br>&gt; + =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_BUF_SET_FSPRIVA=
TE(bp, NULL);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_BUF_=
CLR_IODONE_FUNC(bp);<br>&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 xfs_biodone(bp);<br>&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 } else {<br>&gt; +<br>&gt; XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_e=
rror_relse);<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XFS_BUF_=
DONE(bp);<br>&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 XFS_BUF_FINISH_IOWAIT(bp);<br>&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 }<br>&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>&gt; =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 return;<br>&gt; =A0 =A0 =A0 =A0 }<br>
<br></div></div>This won&#39;t work reliably because it only handles one sp=
ecific type<br>of error. We can get more than just EIO back from the lower =
layers,<br>and so if the superblock write gets a different error then we&#3=
9;ll<br>
still get the same hang.<br><br>Effectively what you are doing here is runn=
ing the<br>xfs_buf_error_relse() callback directly in line. This will resul=
t in<br>the buffer being unlocked before the error is pulled off the buffer=
<br>
after xfs_buf_iowait() completes. Essentially that means that some<br>other=
 thread can reuse the buffer and clear the error before the<br>waiter has r=
eceived the error.<br><br>I think the correct fix is to call the bp-&gt;b_r=
else function when the<br>
waiter is woken to clear the error and unlock the buffer. I&#39;ve just<br>=
posted a patch to do this for 2.6.38, but it won&#39;t trivially backport<b=
r>to 2.6.34 or 2.6.30 as the synchronous write interfaces into the<br>buffe=
r cache have been cleaned up and simplified recently. It should<br>
still be relatively easy to handle, though.<br>
<div>
<div></div>
<div class=3D"h5"><br>Cheers,<br><br>Dave.<br>--<br>Dave Chinner<br><a href=
=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br></div></div></bl=
ockquote></div><br>

--0016367f985e71d4e704991524b0--


--===============0013131223730584769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0013131223730584769==--
