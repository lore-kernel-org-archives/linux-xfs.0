Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D6A147FCA
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 01:19:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C14D2304043
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 23:19:21 -0800 (PST)
Received: from mail-qa0-f47.google.com (mail-qa0-f47.google.com
	[209.85.216.47]) by cuda.sgi.com with ESMTP id 4TXE0kSso30ctAzD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Feb 2014 23:19:17 -0800 (PST)
Received: by mail-qa0-f47.google.com with SMTP id j5so9567780qaq.34
	for <xfs@oss.sgi.com>; Sun, 02 Feb 2014 23:19:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140202213711.GR2212@dastard>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>
	<52EB64DC.4020603@oracle.com> <20140202213711.GR2212@dastard>
Date: Mon, 3 Feb 2014 08:19:16 +0100
Message-ID: <CAMN6oRnBahufcCJ=cxbfOqpXhawuvK14Ttnoe5BOLwr7Hdtp7Q@mail.gmail.com>
Subject: Re: Extended attributes limit in Linux
From: Sun_Blood <sblood@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2634771655898203972=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

--===============2634771655898203972==
Content-Type: multipart/alternative; boundary=001a11c2f5a867950104f17b5701

--001a11c2f5a867950104f17b5701
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Feb 2, 2014 at 10:37 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jan 31, 2014 at 04:54:52PM +0800, Jeff Liu wrote:
> > Hello,
> >
> > On 01/31 2014 15:40 PM, Sun_Blood wrote:
> > > Hello,
> > >
> > > If I understands it correctly XFS don't have a limit to the size of
> > > extended attributes(EA) but Linux impose a limit at 64k.
> > > What I am trying to do is build a backup server that our Apple
> computers
> > > will use together with rsync to backup files to. The problem I face is
> > > that Apple HFS+ don't have a limit to EA so it has files with more then
> > > 64k of EA in it.
> > >
> > > The Linux Kernel has a limit imposed to it in include/linux/limits.h
> > >
> > >     #defineXATTR_SIZE_MAX 65536   /* size of an extended attribute
> value
> > >     (64k) */
> > >
> > >     #defineXATTR_LIST_MAX 65536   /* size of extended attribute
> namelist
> > >     (64k) */
> > >
> >
> > Yes, 64k is the VFS limit per EA value size.
>
> XFS has a limit of 64k as well. I suspect that we could handle
> larger EAs without too much problem as we already have the concept
> of a "remote EA" that is allocated outside of the attribute btree
> (but still inside the attribute address space). The problem with
> them is that they are written synchronously, and so large attributes
> written this way are slow operations.
>
> Still, until the VFS limit is lifted and we do a bunch more work to
> avoid XATTR_SIZE_MAX allocations everywhere there's no point looking
> at raising the XFS limit....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Ok. Just for fun how could we proceed to get the VFS limit lifted? Or any
other way to handle this problem?
It would be nice to be able to say that XFS is the only file system
available fully compatible with OS X HFS+ =)

/Martin

--001a11c2f5a867950104f17b5701
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Sun, Feb 2, 2014 at 10:37 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Fri, Jan 31, 2014 at 04=
:54:52PM +0800, Jeff Liu wrote:<br>
&gt; Hello,<br>
&gt;<br>
&gt; On 01/31 2014 15:40 PM, Sun_Blood wrote:<br>
&gt; &gt; Hello,<br>
&gt; &gt;<br>
&gt; &gt; If I understands it correctly XFS don&#39;t have a limit to the s=
ize of<br>
&gt; &gt; extended attributes(EA) but Linux impose a limit at 64k.<br>
&gt; &gt; What I am trying to do is build a backup server that our Apple co=
mputers<br>
&gt; &gt; will use together with rsync to backup files to. The problem I fa=
ce is<br>
&gt; &gt; that Apple HFS+ don&#39;t have a limit to EA so it has files with=
 more then<br>
&gt; &gt; 64k of EA in it.<br>
&gt; &gt;<br>
</div><div class=3D"im">&gt; &gt; The Linux Kernel has a limit imposed to i=
t in include/linux/limits.h<br>
&gt; &gt;<br>
&gt; &gt; =A0 =A0 #defineXATTR_SIZE_MAX 65536 =A0 /* size of an extended at=
tribute value<br>
&gt; &gt; =A0 =A0 (64k) */<br>
&gt; &gt;<br>
&gt; &gt; =A0 =A0 #defineXATTR_LIST_MAX 65536 =A0 /* size of extended attri=
bute namelist<br>
&gt; &gt; =A0 =A0 (64k) */<br>
&gt; &gt;<br>
&gt;<br>
&gt; Yes, 64k is the VFS limit per EA value size.<br>
<br>
</div>XFS has a limit of 64k as well. I suspect that we could handle<br>
larger EAs without too much problem as we already have the concept<br>
of a &quot;remote EA&quot; that is allocated outside of the attribute btree=
<br>
(but still inside the attribute address space). The problem with<br>
them is that they are written synchronously, and so large attributes<br>
written this way are slow operations.<br>
<br>
Still, until the VFS limit is lifted and we do a bunch more work to<br>
avoid XATTR_SIZE_MAX allocations everywhere there&#39;s no point looking<br=
>
at raising the XFS limit....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div><div class=3D"gmail_extra">Ok. J=
ust for fun how could we proceed to get the VFS limit lifted? Or any other =
way to handle this problem?<br></div><div class=3D"gmail_extra">It would be=
 nice to be able to say that XFS is the only file system available fully co=
mpatible with OS X HFS+ =3D)<br>
<br></div><div class=3D"gmail_extra">/Martin <br></div></div>

--001a11c2f5a867950104f17b5701--


--===============2634771655898203972==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2634771655898203972==--
