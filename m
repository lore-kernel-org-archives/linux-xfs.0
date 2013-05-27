Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1369D7F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 20:16:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E6D9D8F8033
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:16:44 -0700 (PDT)
Received: from mail-qa0-f47.google.com (mail-qa0-f47.google.com
	[209.85.216.47]) by cuda.sgi.com with ESMTP id npicUKloH7TpdwqL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 26 May 2013 18:16:43 -0700 (PDT)
Received: by mail-qa0-f47.google.com with SMTP id o13so754812qaj.13
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:16:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130526231122.GO24543@dastard>
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
	<51A1144A.4020600@gmail.com>
	<CAEH94LgWQcjSMenoT3a81pLWbw2pEYWpKFyGwoxAvDX2FTwbXA@mail.gmail.com>
	<CAEH94Lj4_8PBbhdD2f-ZFG=NxgS2uBkGUfaQvct71H4X7giPZA@mail.gmail.com>
	<20130526231122.GO24543@dastard>
Date: Mon, 27 May 2013 09:16:43 +0800
Message-ID: <CAEH94LikEhB9UA4LZKw9vYUnMsjDLYh3iyUPBFiMvWn9CvB-Cg@mail.gmail.com>
Subject: Re: xfsprogs: is it one issue?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8774184250086846309=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfstests <xfs@oss.sgi.com>

--===============8774184250086846309==
Content-Type: multipart/alternative; boundary=e89a8f647595cd3f7d04dda8e679

--e89a8f647595cd3f7d04dda8e679
Content-Type: text/plain; charset=ISO-8859-1

ah, another way by not building-in loggen, thanks.


On Mon, May 27, 2013 at 7:11 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, May 26, 2013 at 07:11:03AM +0800, Zhi Yong Wu wrote:
> > I remove the lines related to h_chksum, then it can work well, so i
> > guess that i should send out one patch to fix it.
>
> While it will make the code in loggen work the same (it just writes
> 0 to the field but the buffer is already zeroed) as it does now,
> it doesn't necessarily mean it works correctly. The current kernels
> validate the CRC and throw warnings if the CRC isn't correct, and
> CRC enabled kernels will simply refuse to mount.
>
> As it is, my test systems don't build loggen because
> HAVE_XLOG_ASSIGN_LSN isn't set by configure. It only gets set if
> there's an xfs/libxfs.h header file found in an include path. My
> guess is that you've run 'make install-qa' in the xfsprogs package
> at some time in the past, and that's why loggen is trying to be
> built.
>
> So Michael's quick hack to remove it just to make it compile at this
> point is probably appropriate...
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

Zhi Yong Wu

--e89a8f647595cd3f7d04dda8e679
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">ah, another way by not building-in loggen, thanks.</div><d=
iv class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon, May 27,=
 2013 at 7:11 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:davi=
d@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote=
:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Sun, May 26, 2013 at 07=
:11:03AM +0800, Zhi Yong Wu wrote:<br>
&gt; I remove the lines related to h_chksum, then it can work well, so i<br=
>
&gt; guess that i should send out one patch to fix it.<br>
<br>
</div>While it will make the code in loggen work the same (it just writes<b=
r>
0 to the field but the buffer is already zeroed) as it does now,<br>
it doesn&#39;t necessarily mean it works correctly. The current kernels<br>
validate the CRC and throw warnings if the CRC isn&#39;t correct, and<br>
CRC enabled kernels will simply refuse to mount.<br>
<br>
As it is, my test systems don&#39;t build loggen because<br>
HAVE_XLOG_ASSIGN_LSN isn&#39;t set by configure. It only gets set if<br>
there&#39;s an xfs/libxfs.h header file found in an include path. My<br>
guess is that you&#39;ve run &#39;make install-qa&#39; in the xfsprogs pack=
age<br>
at some time in the past, and that&#39;s why loggen is trying to be<br>
built.<br>
<br>
So Michael&#39;s quick hack to remove it just to make it compile at this<br=
>
point is probably appropriate...<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div>Regard=
s,</div><div>=A0</div><div>Zhi Yong Wu</div>
</div>

--e89a8f647595cd3f7d04dda8e679--


--===============8774184250086846309==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8774184250086846309==--
