Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ADF77FF6
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 07:02:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC36FAC004
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:02:43 -0700 (PDT)
Received: from mail-ig0-f177.google.com (mail-ig0-f177.google.com
	[209.85.213.177]) by cuda.sgi.com with ESMTP id
	L5qOgypTuwvFJdII (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 05:02:42 -0700 (PDT)
Received: by mail-ig0-f177.google.com with SMTP id h3so10124316igd.4
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:02:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140925071852.GE4758@dastard>
References: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
	<20140716124757.GC36312@bfoster.bfoster>
	<CAD2VtShVThd0j0-YgGE6fAe28DJ1U-CCRR3Sj9eNjTLKp7FygA@mail.gmail.com>
	<CAD2VtSgdYt2zxmEeWEXmK2B44BKuB-wRKvX4H=jRA9Rj7pyamA@mail.gmail.com>
	<20140925071852.GE4758@dastard>
From: Hrishikesh Barua <talonx@gmail.com>
Date: Fri, 26 Sep 2014 17:32:01 +0530
Message-ID: <CAD2VtShiJSx6uRsqH1ebDNmfDoc25kAb+aCf=ckHdtM3fmpcjw@mail.gmail.com>
Subject: Re: Occassional problems with unfreeze
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0554022761327920563=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

--===============0554022761327920563==
Content-Type: multipart/alternative; boundary=047d7bdc1178b8af110503f6b1b3

--047d7bdc1178b8af110503f6b1b3
Content-Type: text/plain; charset=UTF-8

> Indeed, you are running an old kern (3.2.0-54) which means it won't
> have this fix:
>
> 3948659 xfs: Account log unmount transaction correctly
>
> And that's likely to be the source of all your freeze/unfreeze
> problems because it will eventually hang the log when it's leaked
> all it's space in the ether....
>

We did get a few pointers earlier that 3948659 might be the cause of the
freeze/unfreeze problems but now that you have confirmed it we'll upgrade
the kernel. Thanks.

- Hrish

--047d7bdc1178b8af110503f6b1b3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><br>=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex">
Indeed, you are running an old kern (3.2.0-54) which means it won&#39;t<br>
have this fix:<br>
<br>
3948659 xfs: Account log unmount transaction correctly<br>
<br>
And that&#39;s likely to be the source of all your freeze/unfreeze<br>
problems because it will eventually hang the log when it&#39;s leaked<br>
all it&#39;s space in the ether....<br></blockquote><div><br>We did get a f=
ew pointers earlier that 3948659 might be the cause of the freeze/unfreeze =
problems but now that you have confirmed it we&#39;ll upgrade the kernel. T=
hanks.<br><br></div><div>- Hrish</div></div></div></div>

--047d7bdc1178b8af110503f6b1b3--


--===============0554022761327920563==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0554022761327920563==--
