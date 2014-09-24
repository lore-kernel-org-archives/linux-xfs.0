Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 929807F3F
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 03:42:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80BDB8F8035
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:42:18 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	Y7atORvWRxpTbzoq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 01:42:16 -0700 (PDT)
Received: by mail-wi0-f177.google.com with SMTP id q5so6733003wiv.4
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:42:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201409240903.46899.arekm@maven.pl>
References: <201409240903.46899.arekm@maven.pl>
Date: Wed, 24 Sep 2014 10:42:15 +0200
Message-ID: <CAM5tkX-mOO6EtJczQZC-23-vk7LwSczTL8CB6pgLTSLH0q94fg@mail.gmail.com>
Subject: Re: "No space left on device" from hell
From: =?UTF-8?Q?Fran_Tsao_Sant=C3=ADn?= <tsao@members.fsf.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4471387697769802843=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

--===============4471387697769802843==
Content-Type: multipart/alternative; boundary=bcaec53f398136b64d0503cba94d

--bcaec53f398136b64d0503cba94d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2014-09-24 9:03 GMT+02:00 Arkadiusz Mi=C5=9Bkiewicz <arekm@maven.pl>:

>
> Hello.
>
> 3.10.40 kernel and creating files causes "No space left on device". After
> deleting some files I can create new files again until the problem happen=
s
> again.


Are you sure the problem is the filesystem device? Maybe you are running a
process that fills up another device i.e. shm.

--bcaec53f398136b64d0503cba94d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><div class=3D"gmail_quote">=
2014-09-24 9:03 GMT+02:00 Arkadiusz Mi=C5=9Bkiewicz <span dir=3D"ltr">&lt;<=
a href=3D"mailto:arekm@maven.pl" target=3D"_blank">arekm@maven.pl</a>&gt;</=
span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><br>
Hello.<br>
<br>
3.10.40 kernel and creating files causes &quot;No space left on device&quot=
;. After<br>
deleting some files I can create new files again until the problem happens<=
br>
again.</blockquote><div><br>Are you sure the problem is the filesystem devi=
ce? Maybe you are running
 a process that fills up another device i.e. shm.<br><br>=C2=A0</div></div>=
</div></div>

--bcaec53f398136b64d0503cba94d--


--===============4471387697769802843==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4471387697769802843==--
