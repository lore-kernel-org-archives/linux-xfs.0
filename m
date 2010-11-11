Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oABEt0Y0057269 for <xfs@oss.sgi.com>; Thu, 11 Nov 2010 08:55:00 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02CAA1C32DDD
	for <xfs@oss.sgi.com>; Thu, 11 Nov 2010 06:56:28 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	luC4JyS6KZ5I8hJx for <xfs@oss.sgi.com>;
	Thu, 11 Nov 2010 06:56:28 -0800 (PST)
Received: by qyk30 with SMTP id 30so819335qyk.5
	for <xfs@oss.sgi.com>; Thu, 11 Nov 2010 06:56:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101111124952.GA11052@infradead.org>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
	<20101104125052.GA22429@infradead.org>
	<AANLkTinqK-HvuHPeaTgxJOJuWMfomP2C12G=uVcqhWdn@mail.gmail.com>
	<20101109140527.GA13041@infradead.org>
	<AANLkTik09-0udnrpAJ-mTxMx8iKZ5UTq-ucduQJOZkws@mail.gmail.com>
	<AANLkTik=-jiE5xeJCTQZnbf7AFk7Wzap5ToBDceqsEdH@mail.gmail.com>
	<20101111124952.GA11052@infradead.org>
Date: Thu, 11 Nov 2010 20:26:27 +0530
Message-ID: <AANLkTinB-EGV9yLd=s174VNWzF-Dat-=v+N0bhZqyWV4@mail.gmail.com>
Subject: Re: XFS mounting fails on MIPS
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9066773664195730114=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mips@linux-mips.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============9066773664195730114==
Content-Type: multipart/alternative; boundary=0015175cb2c2b3c1990494c82db3

--0015175cb2c2b3c1990494c82db3
Content-Type: text/plain; charset=ISO-8859-1

Ah! I got your point
thank you very much
On Thu, Nov 11, 2010 at 6:19 PM, Christoph Hellwig <hch@infradead.org>wrote:

> On Thu, Nov 11, 2010 at 11:10:33AM +0530, Ajeet Yadav wrote:
> > I think mips folks agree with the change. I really wish to have there
> > comment.
> >
> > I also wish to know do we really need fix in XFS for virtual indexed
> > architecture, I think its generic issue as many architecture now use VIVT
> or
> > VIPT caches. Do we want to say XFS is relatively unstable with virtual
> > indexed architecture ?
>
> The vmap flushing APIs I repeatedly pointed you at are the generic
> solution.  They've been implement for arm, parisc and sh already, it's
> just that no one has bothered to do it for mips yet.
>
> Without the proper flushing anything that uses vmap, which includes
> XFS is not "relatively unstable" but in fact not usable on systems
> with virtually indexed caches.
>

--0015175cb2c2b3c1990494c82db3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Ah! I got your point</div>
<div>thank you very much<br></div>
<div class=3D"gmail_quote">On Thu, Nov 11, 2010 at 6:19 PM, Christoph Hellw=
ig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org">hch@infradead=
.org</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Nov 11, 2010 at 11:10:33AM +0530, Ajeet Yadav wro=
te:<br>&gt; I think mips folks agree with the change. I really wish to have=
 there<br>&gt; comment.<br>&gt;<br>&gt; I also wish to know do we really ne=
ed fix in XFS for virtual indexed<br>
&gt; architecture, I think its generic issue as many architecture now use V=
IVT or<br>&gt; VIPT caches. Do we want to say XFS is relatively unstable wi=
th virtual<br>&gt; indexed architecture ?<br><br></div>The vmap flushing AP=
Is I repeatedly pointed you at are the generic<br>
solution. =A0They&#39;ve been implement for arm, parisc and sh already, it&=
#39;s<br>just that no one has bothered to do it for mips yet.<br><br>Withou=
t the proper flushing anything that uses vmap, which includes<br>XFS is not=
 &quot;relatively unstable&quot; but in fact not usable on systems<br>
with virtually indexed caches.<br></blockquote></div><br>

--0015175cb2c2b3c1990494c82db3--


--===============9066773664195730114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9066773664195730114==--
