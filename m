Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 259E97F37
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 02:03:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 057AB304039
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 00:03:10 -0700 (PDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	jtFF8vIoLfQSl0tz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 00:03:00 -0700 (PDT)
Received: by wizk4 with SMTP id k4so22716868wiz.1
	for <xfs@oss.sgi.com>; Mon, 06 Apr 2015 00:02:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <551C26FC.10803@sandeen.net>
References: <CAC=x_0iFLbJwbKCKEe7XTKexex29wvbVQDvuN=SO5j9gX=u4rw@mail.gmail.com>
	<551C26FC.10803@sandeen.net>
Date: Mon, 6 Apr 2015 10:02:59 +0300
Message-ID: <CAC=x_0h0RmubmS7akk1nouBDY6AM_XPXSYZSQNfkZKz3bm=6eg@mail.gmail.com>
Subject: Re: xfs corruption issue
From: Danny Shavit <danny@zadarastorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3579525903424411335=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lev Vainblat <lev@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

--===============3579525903424411335==
Content-Type: multipart/alternative; boundary=047d7b86df386a105a051308e3a7

--047d7b86df386a105a051308e3a7
Content-Type: text/plain; charset=UTF-8

Thanks guys.
So far we did not figure out the bit fllip.
Will update if there is interesting information.

Best regards,
Danny

On Wed, Apr 1, 2015 at 8:12 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/1/15 10:09 AM, Danny Shavit wrote:
> > Hello Dave,
> > My name is Danny Shavit and I am with Zadara storage.
> > We will appreciate your feedback reagrding an xfs_corruption and
> xfs_reapir issue.
> >
> > We found a corrupted xfs volume in one of our systems. It is around 1 TB
> size and about 12 M files.
> > We run xfs_repair on the volume which succeeded after 42 minutes.
> > We noticed that memory consumption raised to about 7.5 GB.
> > Since some customers are using only 4GB (and sometimes even 2 GB) we
> tried running "xfs_repair -m 3200" on a 4GB RAM machine.
> > However, this time an OOM event happened during handling of AG 26 during
> step 3.
> > The log of xfs_repair is enclosed below.
> > We will appreciate your feedback on the amount of memory needed for
> xfs_repair in general and when using "-m" option specifically.
> > The xfs metadata dump (prior to xfs_repair) can be found here:
> >
> https://zadarastorage-public.s3.amazonaws.com/xfs/xfsdump-prod-ebs_2015-03-30_23-00-38.tgz
> > It is a 1.2 GB file (and 5.7 GB uncompressed).
> >
> > We will appreciate your feedback on the corruption pattern as well.
> > --
> > Thank you,
> > Danny Shavit
> > Zadarastorage
> >
> > ---------- xfs_repair log  ----------------
>
> Just a note ...
>
> > bad . entry in directory inode 5691013154, was 5691013170: correcting
>
> 101010011001101011111100000100100
> 101010011001101011111100000110100
>                             ^ bit flip
>
> > bad . entry in directory inode 5691013156, was 5691013172: correcting
>
> 101010011001101011111100000100100
> 101010011001101011111100000110100
>                             ^ bit flip
>
> etc ...
>
> > bad . entry in directory inode 5691013157, was 5691013173: correcting
> > bad . entry in directory inode 5691013163, was 5691013179: correcting
>
>


-- 
Regards,
Danny

--047d7b86df386a105a051308e3a7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Thanks guys.<br></div>So far we did no=
t figure out the bit fllip.<br></div>Will update if there is interesting in=
formation.<br><br></div>Best regards,<br></div>Danny<br></div><div class=3D=
"gmail_extra"><br><div class=3D"gmail_quote">On Wed, Apr 1, 2015 at 8:12 PM=
, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net"=
 target=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex"><span class=3D"">On 4/1/15 10:09 AM, Danny Shavit wrote=
:<br>
&gt; Hello Dave,<br>
&gt; My name is Danny Shavit and I am with Zadara storage.<br>
&gt; We will appreciate your feedback reagrding an xfs_corruption and xfs_r=
eapir issue.<br>
&gt;<br>
&gt; We found a corrupted xfs volume in one of our systems. It is around 1 =
TB size and about 12 M files.<br>
&gt; We run xfs_repair on the volume which succeeded after 42 minutes.<br>
&gt; We noticed that memory consumption raised to about 7.5 GB.<br>
&gt; Since some customers are using only 4GB (and sometimes even 2 GB) we t=
ried running &quot;xfs_repair -m 3200&quot; on a 4GB RAM machine.<br>
&gt; However, this time an OOM event happened during handling of AG 26 duri=
ng step 3.<br>
&gt; The log of xfs_repair is enclosed below.<br>
&gt; We will appreciate your feedback on the amount of memory needed for xf=
s_repair in general and when using &quot;-m&quot; option specifically.<br>
&gt; The xfs metadata dump (prior to xfs_repair) can be found here:<br>
&gt; <a href=3D"https://zadarastorage-public.s3.amazonaws.com/xfs/xfsdump-p=
rod-ebs_2015-03-30_23-00-38.tgz" target=3D"_blank">https://zadarastorage-pu=
blic.s3.amazonaws.com/xfs/xfsdump-prod-ebs_2015-03-30_23-00-38.tgz</a><br>
&gt; It is a 1.2 GB file (and 5.7 GB uncompressed).<br>
&gt;<br>
&gt; We will appreciate your feedback on the corruption pattern as well.<br=
>
&gt; --<br>
&gt; Thank you,<br>
&gt; Danny Shavit<br>
&gt; Zadarastorage<br>
&gt;<br>
&gt; ---------- xfs_repair log=C2=A0 ----------------<br>
<br>
</span>Just a note ...<br>
<span class=3D""><br>
&gt; bad . entry in directory inode 5691013154, was 5691013170: correcting<=
br>
<br>
</span>101010011001101011111100000100100<br>
101010011001101011111100000110100<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 ^ bit flip<br>
<span class=3D""><br>
&gt; bad . entry in directory inode 5691013156, was 5691013172: correcting<=
br>
<br>
</span>101010011001101011111100000100100<br>
101010011001101011111100000110100<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 ^ bit flip<br>
<br>
etc ...<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; bad . entry in directory inode 5691013157, was 5691013173: correcting<=
br>
&gt; bad . entry in directory inode 5691013163, was 5691013179: correcting<=
br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature"><div dir=3D"ltr"><div>Regards,<br></div>Danny<br></div=
></div>
</div>

--047d7b86df386a105a051308e3a7--


--===============3579525903424411335==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3579525903424411335==--
