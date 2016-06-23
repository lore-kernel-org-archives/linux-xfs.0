Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C818B7CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 10:04:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 956CD304039
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 08:04:52 -0700 (PDT)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com
	[209.85.215.50]) by cuda.sgi.com with ESMTP id uwxKlHV6ndzzYL6y
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 08:04:49 -0700 (PDT)
Received: by mail-lf0-f50.google.com with SMTP id f6so97418525lfg.0
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 08:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160622225117.GX12670@dastard>
References: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
	<20160622225117.GX12670@dastard>
From: Danny Shavit <danny@zadarastorage.com>
Date: Thu, 23 Jun 2016 18:04:46 +0300
Message-ID: <CAC=x_0hdvm7SSP8EOAdUwLa-k3a3p7p7CRj8tyCnEx=As7A6jw@mail.gmail.com>
Subject: Re: xfs metadata overhead
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0787762644722944672=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0787762644722944672==
Content-Type: multipart/alternative; boundary=001a113ca60601c33b0535f3605e

--001a113ca60601c33b0535f3605e
Content-Type: text/plain; charset=UTF-8

I see. We will try this direction.
BTW: I thought that good estimate would be "volume_size - allocated_size -
free_space". But it produced quite a difference compared to metadata dump
size.
Is there a specific reason?

Thanks,
Danny

On Thu, Jun 23, 2016 at 1:51 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jun 22, 2016 at 06:58:16PM +0300, Danny Shavit wrote:
> > Hi,
> >
> > We are looking for a method to estimate the size of metadata overhead
> for a
> > given file system.
> > We would like to use this value as indicator for the amount of cache
> memory
> > a system for faster operation.
> > Are there any counters that are maintained in the on-disk data
> > structures like free space for examples?
>
> No.
>
> Right now, you'll need to take a metadump of the filesystem to
> measure it. The size of the dump file will be a close indication of
> the amount of metadata in the filesystem as it only contains
> the filesystem metadata.
>
> In future, querying the rmap will enable us to calculate it on the
> fly, (i.e. not requiring the filesystem to be snapshotted/taken off
> line to do a metadump).
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 
Regards,
Danny

--001a113ca60601c33b0535f3605e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I see. We will try this direction.</div><div>BTW: I t=
hought that good estimate would be &quot;volume_size - allocated_size - fre=
e_space&quot;. But it produced quite a difference compared to metadata dump=
 size.</div><div>Is there a specific reason?</div><div><br></div><div>Thank=
s,</div><div>Danny</div></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Thu, Jun 23, 2016 at 1:51 AM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On Wed, Jun 22, 2016 at 06:58:16PM +0300, Danny Shavit wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; We are looking for a method to estimate the size of metadata overhead =
for a<br>
&gt; given file system.<br>
&gt; We would like to use this value as indicator for the amount of cache m=
emory<br>
&gt; a system for faster operation.<br>
&gt; Are there any counters that are maintained in the on-disk data<br>
&gt; structures like free space for examples?<br>
<br>
</span>No.<br>
<br>
Right now, you&#39;ll need to take a metadump of the filesystem to<br>
measure it. The size of the dump file will be a close indication of<br>
the amount of metadata in the filesystem as it only contains<br>
the filesystem metadata.<br>
<br>
In future, querying the rmap will enable us to calculate it on the<br>
fly, (i.e. not requiring the filesystem to be snapshotted/taken off<br>
line to do a metadump).<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div di=
r=3D"ltr"><div>Regards,<br></div>Danny<br></div></div>
</div>

--001a113ca60601c33b0535f3605e--


--===============0787762644722944672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0787762644722944672==--
