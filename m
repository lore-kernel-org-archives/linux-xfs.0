Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBV6jAJF106066 for <xfs@oss.sgi.com>; Fri, 31 Dec 2010 00:45:10 -0600
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31A2C1D065A8
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 22:47:13 -0800 (PST)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id bM8OzHKPu82JLRPS
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 22:47:13 -0800 (PST)
Received: by vws8 with SMTP id 8so5098395vws.26
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 22:47:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101230231353.GC15179@dastard>
References: <AANLkTi=Tmh9m_Rwy-bUZQEzcZ3M+6X9tZxFMO-J2Rvec@mail.gmail.com>
	<20101230231353.GC15179@dastard>
Date: Fri, 31 Dec 2010 12:17:12 +0530
Message-ID: <AANLkTi=OK4uGx5476ro8W47icu685gvQea43rNHozPKS@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3638208535079836890=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============3638208535079836890==
Content-Type: multipart/alternative; boundary=001485f8732a11de170498af2cd5

--001485f8732a11de170498af2cd5
Content-Type: text/plain; charset=ISO-8859-1

Dear Dave,

Our Kernel is 2.6.30.9 but XFS is backported from 2.6.34.
But I have seen similar behaviour in another post related to process ls hang
in 2.6.35.9
*

http://oss.sgi.com/pipermail/xfs/2010-December/048691.html

*I have always seen the hang problem comes only if comes when b_relse !=
NULL, and b_hold > 2

I have made below workaround it solved the problem in our case because when
USB is removed we know we get EIO error.

But I think we need to review xfs_buf_error_relse() and xfs_buf_relse()
considering  XBF_LOCK flow path.

@@ -1047,9 +1047,19 @@ xfs_buf_iodone_callbacks(
                        /* We actually overwrite the existing b-relse
                           function at times, but we're gonna be shutting
down
                           anyway. */
-                       XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
-                       XFS_BUF_DONE(bp);
-                       XFS_BUF_FINISH_IOWAIT(bp);
+                       if (XFS_BUF_GETERROR(bp) == EIO){
+                               ASSERT(XFS_BUF_TARGET(bp) ==
mp->m_ddev_targp);
+                               XFS_BUF_SUPER_STALE(bp);
+                               trace_xfs_buf_item_iodone(bp, _RET_IP_);
+                               xfs_buf_do_callbacks(bp, lip);
+                               XFS_BUF_SET_FSPRIVATE(bp, NULL);
+                               XFS_BUF_CLR_IODONE_FUNC(bp);
+                               xfs_biodone(bp);
+                       } else {
+
XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
+                               XFS_BUF_DONE(bp);
+                               XFS_BUF_FINISH_IOWAIT(bp);
+                       }
                }
                return;
        }



 Dec 31, 2010 at 4:43 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Dec 30, 2010 at 05:58:36PM +0530, Ajeet Yadav wrote:
> > Kernel: 2.6.30.9
> >
> > I am trouble shooting a hang in XFS during umount.
> > Test scenerio: Copy large number of files files using below script, and
> > remove the USB after 3-5 second
>
> FWIW, in future can you please report what kernel you are testing on?
>
> >
> > index=0
> > while [ "$?" == 0 ]
> > do
> >         index=$((index+1))
> >         sync
> >         cp $1/1KB.txt $2/"$index".test
> > done
> >
> > In rare scenerio during USB unplug the umount process hang at
> xfs_buf_lock.
> > Below log shows the hung process
> >
> > We have put printk to buffer handling functions
> xfs_buf_iodone_callbacks(),
> > xfs_buf_error_relse(), xfs_buf_relse() and xfs_buf_rele()
> >
> > We always observed the hang only comes when bp->b_relse =
> > xfs_buf_error_relse(). i.e when xfs_buf_iodone_callbacks() execute
> > XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
> > XFS_BUF_DONE(bp);
> > XFS_BUF_FINISH_IOWAIT(bp);
> >
> >  buf its never called by xfs_buf_relse() because b_hold = 3.
> >
> > Also we have seen that this problem always comes when bp->relse != NULL
> &&
> > bp->hold > 1.
>
> This appears to be the same problem as reported here:
>
> http://oss.sgi.com/archives/xfs/2010-12/msg00380.html
>
>
> > I do not know whether below prints will help you, but I have taken printk
> > for super block buffer tracing
> > S-functionname ( Start of function)
> > E-functionname (End of function)
>
> If you have a recent enough kernel, you can get all this information
> from the tracing built into XFS.
>
> As it is, the cause of the problem is that setting bp->b_relse
> changes the behaviour of xfs_buf_relse() - if bp->b_relse is set, it
> doesn't unlock the buffer. This is normally just fine, because
> xfs_buf_rele() has a special case to handle buffers with
> bp->b_relse(), which adds a hold count and call the release function
> when the hold count drops to zero. The b_relse function is supposed
> to unlock the buffer by calling xfs_buf_relse() again.
>
> Unfortunately, the superblock buffer is special - the hold count on
> it never drops to zero until very late in the unmont process because
> it is managed by the filesystem.  Hence the bp->b_relse function is
> never called, and hence the buffer is never unlocked in this case.
> Hence future attempts to access it hang.
>
> I'll need to think about this one for a bit...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001485f8732a11de170498af2cd5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Dear Dave,</div>
<div>=A0</div>
<div>Our Kernel is 2.6.30.9 but XFS is backported from 2.6.34.</div>
<div>But I have seen similar behaviour in another post related to=A0process=
 ls hang in 2.6.35.9</div>
<div><u><font color=3D"#0000ff" size=3D"2"><font color=3D"#0000ff" size=3D"=
2">
<p><a href=3D"http://oss.sgi.com/pipermail/xfs/2010-December/048691.html">h=
ttp://oss.sgi.com/pipermail/xfs/2010-December/048691.html</a></p>
<p></p></font></font></u>I have always seen the hang problem comes=A0only i=
f comes when b_relse !=3D NULL, and b_hold &gt; 2=A0
<p>I have made below=A0workaround it solved the problem in our case because=
=A0when USB is removed we know we get EIO error.</p>
<p>But I think we need to review xfs_buf_error_relse() and xfs_buf_relse() =
considering =A0XBF_LOCK flow path.</p>
<p>@@ -1047,9 +1047,19 @@ xfs_buf_iodone_callbacks(<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* We actually overwrit=
e the existing b-relse<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 function at times, but we&#39;re gonna be sh=
utting down<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 anyway. */<br>
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_BUF=
_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);<br>-=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_BUF_DONE(bp);<br>-=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_BUF_FINISH_IOWAI=
T(bp);<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 if (XFS_BUF_GETERROR(bp) =3D=3D EIO){<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ASSERT(XFS_BUF_TARGET(bp) =3D=3D mp-&gt;m_ddev_targp);<b=
r>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 XFS_BUF_SUPER_STALE(bp);<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 trace_xfs_b=
uf_item_iodone(bp, _RET_IP_);<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 xfs_buf_do_callbacks(bp, lip);<br>+=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_B=
UF_SET_FSPRIVATE(bp, NULL);<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_BUF_CLR_IODONE_FUNC(bp=
);<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 xfs_biodone(bp);<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else =
{<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);<br>+=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 XFS_BUF_DONE(bp);<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_BUF_FINISH_IOWAI=
T(bp);<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return;<br>=A0=A0=A0=A0=A0=A0=A0 }</p>
<p>=A0</p>
<p>=A0Dec 31, 2010 at 4:43 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span> wrote:<br></p></div>
<div class=3D"gmail_quote">
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>On Thu, Dec 30, 2010 at 05:58:36PM +0530, Ajeet Yadav wrote:<br>&gt; K=
ernel: 2.6.30.9<br>&gt;<br>&gt; I am trouble shooting a hang in XFS during =
umount.<br>&gt; Test scenerio: Copy large number of files files using below=
 script, and<br>
&gt; remove the USB after 3-5 second<br><br></div>FWIW, in future can you p=
lease report what kernel you are testing on?<br>
<div><br>&gt;<br>&gt; index=3D0<br>&gt; while [ &quot;$?&quot; =3D=3D 0 ]<b=
r>&gt; do<br>&gt; =A0 =A0 =A0 =A0 index=3D$((index+1))<br>&gt; =A0 =A0 =A0 =
=A0 sync<br>&gt; =A0 =A0 =A0 =A0 cp $1/1KB.txt $2/&quot;$index&quot;.test<b=
r>&gt; done<br>&gt;<br>&gt; In rare scenerio during USB unplug the umount p=
rocess hang at xfs_buf_lock.<br>
&gt; Below log shows the hung process<br>&gt;<br>&gt; We have put printk to=
 buffer handling functions xfs_buf_iodone_callbacks(),<br>&gt; xfs_buf_erro=
r_relse(), xfs_buf_relse() and xfs_buf_rele()<br>&gt;<br>&gt; We always obs=
erved the hang only comes when bp-&gt;b_relse =3D<br>
&gt; xfs_buf_error_relse(). i.e when xfs_buf_iodone_callbacks() execute<br>=
&gt; XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);<br>&gt; XFS_BUF_DONE(=
bp);<br>&gt; XFS_BUF_FINISH_IOWAIT(bp);<br>&gt;<br>&gt; =A0buf its never ca=
lled by xfs_buf_relse() because b_hold =3D 3.<br>
&gt;<br>&gt; Also we have seen that this problem always comes when bp-&gt;r=
else !=3D NULL &amp;&amp;<br>&gt; bp-&gt;hold &gt; 1.<br><br></div>This app=
ears to be the same problem as reported here:<br><br><a href=3D"http://oss.=
sgi.com/archives/xfs/2010-12/msg00380.html" target=3D"_blank">http://oss.sg=
i.com/archives/xfs/2010-12/msg00380.html</a><br>

<div><br><br>&gt; I do not know whether below prints will help you, but I h=
ave taken printk<br>&gt; for super block buffer tracing<br>&gt; S-functionn=
ame ( Start of function)<br>&gt; E-functionname (End of function)<br><br>
</div>If you have a recent enough kernel, you can get all this information<=
br>from the tracing built into XFS.<br><br>As it is, the cause of the probl=
em is that setting bp-&gt;b_relse<br>changes the behaviour of xfs_buf_relse=
() - if bp-&gt;b_relse is set, it<br>
doesn&#39;t unlock the buffer. This is normally just fine, because<br>xfs_b=
uf_rele() has a special case to handle buffers with<br>bp-&gt;b_relse(), wh=
ich adds a hold count and call the release function<br>when the hold count =
drops to zero. The b_relse function is supposed<br>
to unlock the buffer by calling xfs_buf_relse() again.<br><br>Unfortunately=
, the superblock buffer is special - the hold count on<br>it never drops to=
 zero until very late in the unmont process because<br>it is managed by the=
 filesystem. =A0Hence the bp-&gt;b_relse function is<br>
never called, and hence the buffer is never unlocked in this case.<br>Hence=
 future attempts to access it hang.<br><br>I&#39;ll need to think about thi=
s one for a bit...<br><br>Cheers,<br><br>Dave.<br><font color=3D"#888888">-=
-<br>
Dave Chinner<br><a href=3D"mailto:david@fromorbit.com" target=3D"_blank">da=
vid@fromorbit.com</a><br></font></blockquote></div><br>

--001485f8732a11de170498af2cd5--


--===============3638208535079836890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3638208535079836890==--
