Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 365247F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 06:47:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 151E7304032
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 04:47:38 -0700 (PDT)
Received: from mail-qk0-f169.google.com (mail-qk0-f169.google.com
	[209.85.220.169]) by cuda.sgi.com with ESMTP id
	sQBEnCapHv7gcGXP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 04:47:36 -0700 (PDT)
Received: by qkei195 with SMTP id i195so183749064qke.3
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2015 04:47:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150709084602.GA2900@quack.suse.cz>
References: <CAMcfJ7sZaLwO7Gz8f7E9GBrX75Ddc8JvLntPRpjw=KPNOV7TLg@mail.gmail.com>
	<20150709084602.GA2900@quack.suse.cz>
Date: Thu, 9 Jul 2015 17:17:35 +0530
Message-ID: <CAMcfJ7uS52POb+8TrWa_CVTHN7O4dZNAWZi=8HBQ0v+RXLit4Q@mail.gmail.com>
Subject: Re: regarding journaling mode
From: Rakesh Patel <patelrakeshcomp@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2768572570816074539=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

--===============2768572570816074539==
Content-Type: multipart/alternative; boundary=001a1135bfe44d5c87051a6fd2cd

--001a1135bfe44d5c87051a6fd2cd
Content-Type: text/plain; charset=UTF-8

Ok. Thanks for your information.


On Thu, Jul 9, 2015 at 2:16 PM, Jan Kara <jack@suse.cz> wrote:

> On Thu 09-07-15 10:18:55, Rakesh Patel wrote:
> > https://www.kernel.org/doc/Documentation/filesystems/ext4.txt
> >
> > data=writeback                Data ordering is not preserved, data may
> be written
> >                       into the main file system after its metadata has
> been
> >                       committed to the journal.
>
> But this is about ext4, not xfs. XFS works differently and provides
> necessary data safety guarantees.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>

--001a1135bfe44d5c87051a6fd2cd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ok. Thanks for your information.<br><br></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Jul 9, 2015 at 2:16=
 PM, Jan Kara <span dir=3D"ltr">&lt;<a href=3D"mailto:jack@suse.cz" target=
=3D"_blank">jack@suse.cz</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Thu 09-07-15 10:18:55, Rak=
esh Patel wrote:<br>
&gt; <a href=3D"https://www.kernel.org/doc/Documentation/filesystems/ext4.t=
xt" rel=3D"noreferrer" target=3D"_blank">https://www.kernel.org/doc/Documen=
tation/filesystems/ext4.txt</a><br>
&gt;<br>
&gt; data=3Dwriteback=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Data ordering is not preserved, data may be written<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0into the main file system after its metadata has been<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0committed to the journal.<br>
<br>
</div></div>But this is about ext4, not xfs. XFS works differently and prov=
ides<br>
necessary data safety guarantees.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Honza<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>
SUSE Labs, CR<br>
</font></span></blockquote></div><br></div>

--001a1135bfe44d5c87051a6fd2cd--


--===============2768572570816074539==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2768572570816074539==--
