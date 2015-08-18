Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 751487F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 03:00:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EBFC6AC00B
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 01:00:12 -0700 (PDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
	[209.85.213.170]) by cuda.sgi.com with ESMTP id
	yuLEw6ZHcFemxO4r (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 01:00:11 -0700 (PDT)
Received: by igui7 with SMTP id i7so73943924igu.0
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 01:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150817193913.GD8444@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-12-git-send-email-jtulak@redhat.com>
	<20150817193913.GD8444@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 18 Aug 2015 09:59:51 +0200
Message-ID: <CACj3i70WL9GenAzFhp0ZMGvWCX+mnVciYM77dCY5iE0p1D+sAw@mail.gmail.com>
Subject: Re: [PATCH 11/11] xfsprogs: Add a way to compile without blkid
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9022553521658850229=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============9022553521658850229==
Content-Type: multipart/alternative; boundary=089e01160a02ab0b8e051d914e5f

--089e01160a02ab0b8e051d914e5f
Content-Type: text/plain; charset=UTF-8

On Mon, Aug 17, 2015 at 9:39 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> On Mon, Aug 17, 2015 at 06:23:26PM +0200, Jan Tulak wrote:
> > UPDATE: default to "signature found", so without blkid is
> >         -f mandatory.
>
> Belongs in the cover letter, not this patch.
>

I forgot to remove it from the patch, sorry for that.


>
> >               } else
> >                       ft->psectorsize = ft->lsectorsize = BBSIZE;
> >       } else {
> > +#ifdef ENABLE_BLKID
> >               blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
> >                                  &ft->lsectorsize, &ft->psectorsize,
> >                                  force_overwrite);
> > +#endif /* ENABLE_BLKID */
> >       }
> >
> >       if (xi->rtname && !xi->risfile) {
> >               int sunit, lsectorsize, psectorsize;
> >
> > +#ifdef ENABLE_BLKID
> >               blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
> >                                  &lsectorsize, &psectorsize,
> force_overwrite);
> > +#endif /* ENABLE_BLKID */
>
> I think you need to proide a dummy blkid_get_topology which at least
> sets the two sector sizes to 512.
>

I don't think so. blkid_get_topology is used only for block devices, not
when mkfs-ing a file. And there are multiple further issues with mkfs
on OS X with system calls, so such dummy call would be for no use.

Although, when I think about it, removing few ifdef would certainly make
the code
cleaner, so I think I can make a dummy call for this reason.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--089e01160a02ab0b8e051d914e5f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Aug 17, 2015 at 9:39 PM, Christoph Hellwig <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infradead.org</a>&gt;<=
/span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex"><span>On Mon, Aug 17, 2015 =
at 06:23:26PM +0200, Jan Tulak wrote:<br>
&gt; UPDATE: default to &quot;signature found&quot;, so without blkid is<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-f mandatory.<br>
<br>
</span>Belongs in the cover letter, not this patch.<br></blockquote><div><b=
r></div><div>I forgot to remove it from the patch, sorry for that.</div><di=
v>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">
<span><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ft-&gt;psectorsize =3D ft-&gt;lsectorsize =3D BBSIZE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +#ifdef ENABLE_BLKID<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blkid_get_topolo=
gy(dfile, &amp;ft-&gt;dsunit, &amp;ft-&gt;dswidth,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;ft-&gt;lsectorsize, &=
amp;ft-&gt;psectorsize,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_overwrite);<br>
&gt; +#endif /* ENABLE_BLKID */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (xi-&gt;rtname &amp;&amp; !xi-&gt;risfile=
) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int sunit, lsect=
orsize, psectorsize;<br>
&gt;<br>
&gt; +#ifdef ENABLE_BLKID<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blkid_get_topolo=
gy(xi-&gt;rtname, &amp;sunit, &amp;ft-&gt;rtswidth,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;lsectorsize, &amp;pse=
ctorsize, force_overwrite);<br>
&gt; +#endif /* ENABLE_BLKID */<br>
<br>
</span>I think you need to proide a dummy blkid_get_topology which at least=
<br>
sets the two sector sizes to 512.<br></blockquote><div><br></div><div>I don=
&#39;t think so. blkid_get_topology is used only for block devices, not</di=
v><div>when mkfs-ing a file. And there are multiple further issues with mkf=
s</div><div>on OS X with system calls, so such dummy call would be for no u=
se.</div><div><br></div><div>Although, when I think about it, removing few =
ifdef would certainly make the code</div><div>cleaner, so I think I can mak=
e a dummy call for this reason.=C2=A0</div><div><br></div><div>Cheers,</div=
><div>Jan</div><div><br></div></div>-- <br><div><div dir=3D"ltr"><div>Jan T=
ulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak=
@redhat.com</a><br></div></div>
</div></div>

--089e01160a02ab0b8e051d914e5f--


--===============9022553521658850229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9022553521658850229==--
