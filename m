Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D0A60a229441 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 19:10:07 -0500
Received: from smtp.epoch.com (smtp.epoch.com [216.172.133.240]) by
	cuda.sgi.com with ESMTP id OjpO9vUEOxcn3iUJ for
	<xfs@oss.sgi.com>; Thu, 12 Apr 2012 17:10:04 -0700 (PDT)
Received: from smtp.epoch.com (localhost [127.0.0.1])
	by smtp.epoch.com (Postfix) with ESMTP id D7BCB35A2E1
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 17:10:03 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182])
	by smtp.epoch.com (Postfix) with ESMTPS id 85AEF35A2DF
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 17:10:03 -0700 (PDT)
Received: by wibhr14 with SMTP id hr14so2022105wib.5
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 17:10:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120412075747.GB30891@nsrc.org>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
From: David Fuller <dfuller@epoch.com>
Date: Thu, 12 Apr 2012 17:09:40 -0700
Message-ID: <CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
Subject: Re: Fragmentation Issue We Are Having
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7319489116140382185=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

--===============7319489116140382185==
Content-Type: multipart/alternative; boundary=f46d041824ee2c3ed504bd844b53

--f46d041824ee2c3ed504bd844b53
Content-Type: text/plain; charset=ISO-8859-1

Brian,

The total LVM volume group is 4.5 TB.  The logical volume is around 2.3TB
where the mysql data
is stored.


--David F.


<http://www.topshelfads.com/email/sig/epochbestbilling.jpg>


On Thu, Apr 12, 2012 at 12:57 AM, Brian Candler <B.Candler@pobox.com> wrote:

> On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wrote:
> >    Adn here are the mount options on one of our servers:
> >
> >     xfs     rw,noikeep,allocsize=256M,logbufs=8,sunit=128,swidth=2304
>
> What's the total file system size? If it's over 1TB then you almost
> certainly should have 'inode64' as well.
> http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F
>

--f46d041824ee2c3ed504bd844b53
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Brian,<div><br></div><div>The total LVM volume group is 4.5 TB. =A0The logi=
cal volume is around 2.3TB where the mysql data</div><div>is stored.</div><=
div><br></div><div><br></div><div>--David F.</div><div><br><br><a href=3D"h=
ttp://www.topshelfads.com/email/sig/epochbestbilling.jpg" target=3D"_blank"=
></a><br>


<br><br><div class=3D"gmail_quote">On Thu, Apr 12, 2012 at 12:57 AM, Brian =
Candler <span dir=3D"ltr">&lt;<a href=3D"mailto:B.Candler@pobox.com">B.Cand=
ler@pobox.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im">On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wr=
ote:<br>
</div><div class=3D"im">&gt; =A0 =A0Adn here are the mount options on one o=
f our servers:<br>
&gt;<br>
&gt; =A0 =A0 xfs =A0 =A0 rw,noikeep,allocsize=3D256M,logbufs=3D8,sunit=3D12=
8,swidth=3D2304<br>
<br>
</div>What&#39;s the total file system size? If it&#39;s over 1TB then you =
almost<br>
certainly should have &#39;inode64&#39; as well.<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_op=
tion_for.3F" target=3D"_blank">http://xfs.org/index.php/XFS_FAQ#Q:_What_is_=
the_inode64_mount_option_for.3F</a><br>
</blockquote></div><br></div>

--f46d041824ee2c3ed504bd844b53--


--===============7319489116140382185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7319489116140382185==--
