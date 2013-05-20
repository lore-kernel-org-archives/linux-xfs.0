Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E19D7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 06:42:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B5E0304039
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 04:42:41 -0700 (PDT)
Received: from mail-we0-f178.google.com (mail-we0-f178.google.com
	[74.125.82.178]) by cuda.sgi.com with ESMTP id ufMbqAVDACNlX1is
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 04:42:37 -0700 (PDT)
Received: by mail-we0-f178.google.com with SMTP id q57so4860509wes.23
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 04:42:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130520113045.GB24543@dastard>
References: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
	<20130520113045.GB24543@dastard>
Date: Mon, 20 May 2013 20:42:35 +0900
Message-ID: <CANW9uytQDPaBr_VAGMuwSqhStCfyMCGmV_A3ccNzOExi-KeZfQ@mail.gmail.com>
Subject: Re: [PATCH] xfstests comma separated group names
From: Itaru Kitayama <itaru.kitayama@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4176013698612367931=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4176013698612367931==
Content-Type: multipart/alternative; boundary=001a11c25e4c39a22a04dd24d4ed

--001a11c25e4c39a22a04dd24d4ed
Content-Type: text/plain; charset=ISO-8859-1

Yes, we can do that, but I just thought as you originally proposed last year

-g rw,attr reads better.

Itaru


On Mon, May 20, 2013 at 8:30 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, May 20, 2013 at 05:29:29PM +0900, Itaru Kitayama wrote:
> > This patch lets the -g option take multiple group names.
> >
> > Signed-off-By: Itaru Kitayama <itaru.kitayama@gmail.com>
>
> You can already run multiple test groups by specifying multiple -g
> options. e.g:
>
> # check -g rw -g attr
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c25e4c39a22a04dd24d4ed
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Yes, we can do that, but I just thought as you originally =
proposed last year<div style><br></div><div style>-g rw,attr reads better.<=
/div><div style><br></div><div style>Itaru</div></div><div class=3D"gmail_e=
xtra">
<br><br><div class=3D"gmail_quote">On Mon, May 20, 2013 at 8:30 PM, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On Mon, May 20, 2013 at 05:29:29PM +0900, Itaru Kitayama =
wrote:<br>
&gt; This patch lets the -g option take multiple group names.<br>
&gt;<br>
&gt; Signed-off-By: Itaru Kitayama &lt;<a href=3D"mailto:itaru.kitayama@gma=
il.com">itaru.kitayama@gmail.com</a>&gt;<br>
<br>
</div>You can already run multiple test groups by specifying multiple -g<br=
>
options. e.g:<br>
<br>
# check -g rw -g attr<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001a11c25e4c39a22a04dd24d4ed--


--===============4176013698612367931==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4176013698612367931==--
