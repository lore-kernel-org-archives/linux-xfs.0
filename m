Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 816A17CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 08:21:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53050304048
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:21:45 -0700 (PDT)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id beA4jT08ENNU3uKR
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 06:21:41 -0700 (PDT)
Received: by mail-lf0-f52.google.com with SMTP id h129so116172601lfh.1
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b920a8ec-6410-1daa-809c-04b48db24c0a@sandeen.net>
References: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
	<20160622225117.GX12670@dastard>
	<CAC=x_0hdvm7SSP8EOAdUwLa-k3a3p7p7CRj8tyCnEx=As7A6jw@mail.gmail.com>
	<71fbc905-ef05-126a-5c7f-c68c9018763c@sandeen.net>
	<CAC=x_0hnGQHAenv985+FusWxK_63AatB_XK_mqbAmyt=OxqYrg@mail.gmail.com>
	<b920a8ec-6410-1daa-809c-04b48db24c0a@sandeen.net>
From: Danny Shavit <danny@zadarastorage.com>
Date: Fri, 24 Jun 2016 16:21:39 +0300
Message-ID: <CAC=x_0g_iktOKOKiRF5Ku7N-PSbCXOR+Amhm577YjNYQaRPjeA@mail.gmail.com>
Subject: Re: xfs metadata overhead
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1015029016598053676=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============1015029016598053676==
Content-Type: multipart/alternative; boundary=001a114172ec0b9d7c0536060db0

--001a114172ec0b9d7c0536060db0
Content-Type: text/plain; charset=UTF-8

I see.
So using bulk_stat ioctl in similar way to xfs_fsr and summing allocated
size will result with  more accurate number?

Thanks,
Danny

On Fri, Jun 24, 2016 at 4:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 6/24/16 5:34 AM, Danny Shavit wrote:
> >> How do you determine allocated_size, with du?
> > yes via du
> >> How different?  Can you show an example?
> > meta data file size= 5.6 GB (*6,089,374,208*)
> >
> > *df:*
> > Filesystem                   1K-blocks       Used  Available Use%
> Mounted on
> > /dev/dm-39                  2725683200  955900860 1769782340  36%
> /export/v1     = 978,842,480,640 bytes
> >
> > *du:*  du -s /export/v1/
> > 952825644       /export/v1/     = 975,693,459,456 bytes
> > 978,842,480,640 -975,693,459,456  =
> >
> > Metadata size according to calculation=*3,149,021,184* bytes
>
> Oh, right.  I should have thought of this; "du" counts some metadata as
> well, i.e. a directory full of zero-length files still consumes space
> which is reported by du.
>
> so your 975,693,459,456 bytes is file data as well as some metadata.
>
> -Eric
>
> >
> > Thanks,
> > Danny
> >
> > On Thu, Jun 23, 2016 at 9:12 PM, Eric Sandeen <sandeen@sandeen.net
> <mailto:sandeen@sandeen.net>> wrote:
> >
> >     On 6/23/16 10:04 AM, Danny Shavit wrote:
> >     > I see. We will try this direction.
> >     > BTW: I thought that good estimate would be "volume_size -
> >     > allocated_size - free_space". But it produced quite a difference
> >     > compared to metadata dump size.
> >     > Is there a specific reason?
> >
> >     How do you determine allocated_size, with du?
> >
> >     How different?  Can you show an example?
> >
> >     -Eric
> >
> >     > Thanks,
> >     > Danny
> >     >
> >     > On Thu, Jun 23, 2016 at 1:51 AM, Dave Chinner <david@fromorbit.com
> <mailto:david@fromorbit.com> <mailto:david@fromorbit.com <mailto:
> david@fromorbit.com>>> wrote:
> >     >
> >     >     On Wed, Jun 22, 2016 at 06:58:16PM +0300, Danny Shavit wrote:
> >     >     > Hi,
> >     >     >
> >     >     > We are looking for a method to estimate the size of metadata
> overhead for a
> >     >     > given file system.
> >     >     > We would like to use this value as indicator for the amount
> of cache memory
> >     >     > a system for faster operation.
> >     >     > Are there any counters that are maintained in the on-disk
> data
> >     >     > structures like free space for examples?
> >     >
> >     >     No.
> >     >
> >     >     Right now, you'll need to take a metadump of the filesystem to
> >     >     measure it. The size of the dump file will be a close
> indication of
> >     >     the amount of metadata in the filesystem as it only contains
> >     >     the filesystem metadata.
> >     >
> >     >     In future, querying the rmap will enable us to calculate it on
> the
> >     >     fly, (i.e. not requiring the filesystem to be
> snapshotted/taken off
> >     >     line to do a metadump).
> >     >
> >     >     Cheers,
> >     >
> >     >     Dave.
> >     >     --
> >     >     Dave Chinner
> >     >     david@fromorbit.com <mailto:david@fromorbit.com> <mailto:
> david@fromorbit.com <mailto:david@fromorbit.com>>
> >     >
> >     >
> >     >
> >     >
> >     > --
> >     > Regards,
> >     > Danny
> >     >
> >     >
> >     > _______________________________________________
> >     > xfs mailing list
> >     > xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
> >     > http://oss.sgi.com/mailman/listinfo/xfs
> >     >
> >
> >     _______________________________________________
> >     xfs mailing list
> >     xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
> >     http://oss.sgi.com/mailman/listinfo/xfs
> >
> >
> >
> >
> > --
> > Regards,
> > Danny
>



-- 
Regards,
Danny

--001a114172ec0b9d7c0536060db0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I see.<div>So using bulk_stat ioctl in similar way to xfs_=
fsr and summing allocated size will result with =C2=A0more accurate number?=
</div><div><br></div><div>Thanks,</div><div>Danny</div></div><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">On Fri, Jun 24, 2016 at 4:17 PM=
, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net"=
 target=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex"><span class=3D"">On 6/24/16 5:34 AM, Danny Shavit wrote=
:<br>
&gt;&gt; How do you determine allocated_size, with du?<br>
&gt; yes via du<br>
&gt;&gt; How different?=C2=A0 Can you show an example?<br>
</span>&gt; meta data file size=3D 5.6 GB (*6,089,374,208*)<br>
&gt;<br>
&gt; *df:*<br>
<span class=3D"">&gt; Filesystem=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A01K-blocks=C2=A0 =C2=A0 =C2=A0 =C2=A0Used=C2=A0 A=
vailable Use% Mounted on<br>
&gt; /dev/dm-39=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 <a href=3D"tel:2725683200" value=3D"+12725683200">2725683200</a>=C2=A0 =
955900860 1769782340=C2=A0 36% /export/v1=C2=A0 =C2=A0 =C2=A0=3D 978,842,48=
0,640 bytes<br>
&gt;<br>
</span>&gt; *du:*=C2=A0 du -s /export/v1/<br>
<span class=3D"">&gt; 952825644=C2=A0 =C2=A0 =C2=A0 =C2=A0/export/v1/=C2=A0=
 =C2=A0 =C2=A0=3D 975,693,459,456 bytes<br>
&gt; 978,842,480,640 -975,693,459,456=C2=A0 =3D<br>
&gt;<br>
</span>&gt; Metadata size according to calculation=3D*3,149,021,184* bytes<=
br>
<br>
Oh, right.=C2=A0 I should have thought of this; &quot;du&quot; counts some =
metadata as<br>
well, i.e. a directory full of zero-length files still consumes space<br>
which is reported by du.<br>
<br>
so your 975,693,459,456 bytes is file data as well as some metadata.<br>
<br>
-Eric<br>
<br>
&gt;<br>
&gt; Thanks,<br>
&gt; Danny<br>
<span class=3D"">&gt;<br>
&gt; On Thu, Jun 23, 2016 at 9:12 PM, Eric Sandeen &lt;<a href=3D"mailto:sa=
ndeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0On 6/23/16 10:04 AM, Danny Shavit wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; I see. We will try this direction.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; BTW: I thought that good estimate would be &qu=
ot;volume_size -<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; allocated_size - free_space&quot;. But it prod=
uced quite a difference<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; compared to metadata dump size.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Is there a specific reason?<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0How do you determine allocated_size, with du?<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0How different?=C2=A0 Can you show an example?<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0-Eric<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Thanks,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Danny<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
</span><span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0&gt; On Thu, Jun 23, 2016 a=
t 1:51 AM, Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@fr=
omorbit.com</a> &lt;mailto:<a href=3D"mailto:david@fromorbit.com">david@fro=
morbit.com</a>&gt; &lt;mailto:<a href=3D"mailto:david@fromorbit.com">david@=
fromorbit.com</a> &lt;mailto:<a href=3D"mailto:david@fromorbit.com">david@f=
romorbit.com</a>&gt;&gt;&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0On Wed, Jun 22, 2016 at 06:=
58:16PM +0300, Danny Shavit wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Hi,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; We are looking for a m=
ethod to estimate the size of metadata overhead for a<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; given file system.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; We would like to use t=
his value as indicator for the amount of cache memory<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; a system for faster op=
eration.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Are there any counters=
 that are maintained in the on-disk data<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; structures like free s=
pace for examples?<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0No.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0Right now, you&#39;ll need =
to take a metadump of the filesystem to<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0measure it. The size of the=
 dump file will be a close indication of<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0the amount of metadata in t=
he filesystem as it only contains<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0the filesystem metadata.<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0In future, querying the rma=
p will enable us to calculate it on the<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0fly, (i.e. not requiring th=
e filesystem to be snapshotted/taken off<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0line to do a metadump).<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0Cheers,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0Dave.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0--<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0Dave Chinner<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a> &lt;mailto:<a href=3D"mailto:dav=
id@fromorbit.com">david@fromorbit.com</a>&gt; &lt;mailto:<a href=3D"mailto:=
david@fromorbit.com">david@fromorbit.com</a> &lt;mailto:<a href=3D"mailto:d=
avid@fromorbit.com">david@fromorbit.com</a>&gt;&gt;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; --<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Regards,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Danny<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; ______________________________________________=
_<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; xfs mailing list<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@=
oss.sgi.com</a> &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.c=
om</a>&gt;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0&gt; <a href=3D"http://oss.sgi.com=
/mailman/listinfo/xfs" rel=3D"noreferrer" target=3D"_blank">http://oss.sgi.=
com/mailman/listinfo/xfs</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0_______________________________________________<br>
&gt;=C2=A0 =C2=A0 =C2=A0xfs mailing list<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.s=
gi.com</a> &lt;mailto:<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a=
>&gt;<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt;=C2=A0 =C2=A0 =C2=A0<a href=3D"=
http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" target=3D"_blan=
k">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Regards,<br>
&gt; Danny<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div>Regards,<br></div>Danny<br></div></div>
</div>

--001a114172ec0b9d7c0536060db0--


--===============1015029016598053676==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1015029016598053676==--
