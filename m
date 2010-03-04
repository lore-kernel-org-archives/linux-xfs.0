Return-Path: <xfs-bounces@oss.sgi.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] Re: linux-next: build warning after merge of the xfs tree
Date: Wed, 3 Mar 2010 22:54:05 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE8D0410@cf--amer001e--3.americas.sgi.com>
References: <20100304111930.86f7cc62.sfr@canb.auug.org.au>
	<20100304005709.GE14317@discord.disaster>
From: "Alex Elder" <aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8684731430972473130=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============8684731430972473130==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CABB57.5BA9278B"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CABB57.5BA9278B
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> Dave Chinner <mailto:david@fromorbit.com> wrote:
> On Thu, Mar 04, 2010 at 11:19:30AM +1100, Stephen Rothwell wrote:
> > Hi Dave,
> >=20
> > After merging the xfs tree, today's linux-next build (x86_64 =
allmodconfig)
> > produced this warning:
> >=20
> > fs/xfs/linux-2.6/xfs_aops.c: In function 'xfs_end_io':
> > fs/xfs/linux-2.6/xfs_aops.c:232: warning: 'error' may be used =
uninitialized in this function
> >=20
> > Introduced by commit 77d7a0c2eeb285c9069e15396703d0cb9690ac50 ("xfs:
> > Non-blocking inode locking in IO completion").
> >=20
> > I can't tell if this is a false positive.  If the first two "if"
> > statement bodies are skipped, then error is tested uninitialised.  =
It is
> > possible that at least one of them has to be executed.
>=20
> Right, there is a warning being generated there - I thought I fixed
> that immediately after posting the first version of the patch. The
> second version:
>=20
> http://oss.sgi.com/archives/xfs/2010-02/msg00340.html
>=20
> definitely had it fixed.
>=20
> Alex, can you make sure you take the entire patch rather than
> cutting and pasting bits from one patch version to another?  That
> way you don't miss small changes to the patch that might have been
> forgotten about....

I didn't expect you would change the patch content, only
the description.  I had already tested the previous code
so just grabbed the new description when you re-posted.
Sorry about the warning slipping through.  I'll incorporate
your fix below (tomorrow).

                               -Alex


> Stephen, the patch below should fix the warning.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20
> xfs: fix uninitialised variable warning in xfs_end_io
>=20
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/linux-2.6/xfs_aops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> index f41a2d8..8989c16 100644
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -230,7 +230,7 @@ xfs_end_io(
>  {
>  	xfs_ioend_t	*ioend =3D container_of(work, xfs_ioend_t, io_work);
>  	struct xfs_inode *ip =3D XFS_I(ioend->io_inode);
> -	int		error;
> +	int		error =3D 0;
> =20
>  	/*
>  	 * For unwritten extents we need to issue transactions to convert a
>=20
>=20

------_=_NextPart_001_01CABB57.5BA9278B
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7654.12">
<TITLE>RE: [PATCH] Re: linux-next: build warning after merge of the xfs =
tree</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>&gt; Dave Chinner &lt;<A =
HREF=3D"mailto:david@fromorbit.com">mailto:david@fromorbit.com</A>&gt; =
wrote:<BR>
&gt; On Thu, Mar 04, 2010 at 11:19:30AM +1100, Stephen Rothwell =
wrote:<BR>
&gt; &gt; Hi Dave,<BR>
&gt; &gt;<BR>
&gt; &gt; After merging the xfs tree, today's linux-next build (x86_64 =
allmodconfig)<BR>
&gt; &gt; produced this warning:<BR>
&gt; &gt;<BR>
&gt; &gt; fs/xfs/linux-2.6/xfs_aops.c: In function 'xfs_end_io':<BR>
&gt; &gt; fs/xfs/linux-2.6/xfs_aops.c:232: warning: 'error' may be used =
uninitialized in this function<BR>
&gt; &gt;<BR>
&gt; &gt; Introduced by commit 77d7a0c2eeb285c9069e15396703d0cb9690ac50 =
(&quot;xfs:<BR>
&gt; &gt; Non-blocking inode locking in IO completion&quot;).<BR>
&gt; &gt;<BR>
&gt; &gt; I can't tell if this is a false positive.&nbsp; If the first =
two &quot;if&quot;<BR>
&gt; &gt; statement bodies are skipped, then error is tested =
uninitialised.&nbsp; It is<BR>
&gt; &gt; possible that at least one of them has to be executed.<BR>
&gt;<BR>
&gt; Right, there is a warning being generated there - I thought I =
fixed<BR>
&gt; that immediately after posting the first version of the patch. =
The<BR>
&gt; second version:<BR>
&gt;<BR>
&gt; <A =
HREF=3D"http://oss.sgi.com/archives/xfs/2010-02/msg00340.html">http://oss=
.sgi.com/archives/xfs/2010-02/msg00340.html</A><BR>
&gt;<BR>
&gt; definitely had it fixed.<BR>
&gt;<BR>
&gt; Alex, can you make sure you take the entire patch rather than<BR>
&gt; cutting and pasting bits from one patch version to another?&nbsp; =
That<BR>
&gt; way you don't miss small changes to the patch that might have =
been<BR>
&gt; forgotten about....<BR>
<BR>
I didn't expect you would change the patch content, only<BR>
the description.&nbsp; I had already tested the previous code<BR>
so just grabbed the new description when you re-posted.<BR>
Sorry about the warning slipping through.&nbsp; I'll incorporate<BR>
your fix below (tomorrow).<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -Alex<BR>
<BR>
<BR>
&gt; Stephen, the patch below should fix the warning.<BR>
&gt;<BR>
&gt; Cheers,<BR>
&gt;<BR>
&gt; Dave.<BR>
&gt; --<BR>
&gt; Dave Chinner<BR>
&gt; david@fromorbit.com<BR>
&gt;<BR>
&gt; xfs: fix uninitialised variable warning in xfs_end_io<BR>
&gt;<BR>
&gt; Signed-off-by: Dave Chinner &lt;david@fromorbit.com&gt;<BR>
&gt; ---<BR>
&gt;&nbsp; fs/xfs/linux-2.6/xfs_aops.c |&nbsp;&nbsp;&nbsp; 2 +-<BR>
&gt;&nbsp; 1 files changed, 1 insertions(+), 1 deletions(-)<BR>
&gt;<BR>
&gt; diff --git a/fs/xfs/linux-2.6/xfs_aops.c =
b/fs/xfs/linux-2.6/xfs_aops.c<BR>
&gt; index f41a2d8..8989c16 100644<BR>
&gt; --- a/fs/xfs/linux-2.6/xfs_aops.c<BR>
&gt; +++ b/fs/xfs/linux-2.6/xfs_aops.c<BR>
&gt; @@ -230,7 +230,7 @@ xfs_end_io(<BR>
&gt;&nbsp; {<BR>
&gt;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; xfs_ioend_t&nbsp;&nbsp;&nbsp;&nbsp; =
*ioend =3D container_of(work, xfs_ioend_t, io_work);<BR>
&gt;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; struct xfs_inode *ip =3D =
XFS_I(ioend-&gt;io_inode);<BR>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; error;<BR>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; error =3D 0;<BR>
&gt;&nbsp;<BR>
&gt;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; /*<BR>
&gt;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * For unwritten extents we =
need to issue transactions to convert a<BR>
&gt;<BR>
&gt;<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01CABB57.5BA9278B--


--===============8684731430972473130==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8684731430972473130==--
