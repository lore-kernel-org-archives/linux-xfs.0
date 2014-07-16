Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B32A87FB6
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 08:24:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45BBFAC002
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 06:24:33 -0700 (PDT)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	HiMNDugKSxNglVq3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 06:24:31 -0700 (PDT)
Received: by mail-ie0-f176.google.com with SMTP id tr6so744441ieb.35
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 06:24:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140716124757.GC36312@bfoster.bfoster>
References: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
	<20140716124757.GC36312@bfoster.bfoster>
From: Hrishikesh Barua <talonx@gmail.com>
Date: Wed, 16 Jul 2014 18:53:51 +0530
Message-ID: <CAD2VtShVThd0j0-YgGE6fAe28DJ1U-CCRR3Sj9eNjTLKp7FygA@mail.gmail.com>
Subject: Re: Occassional problems with unfreeze
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3025466282814670834=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============3025466282814670834==
Content-Type: multipart/alternative; boundary=20cf301d40cec2a60a04fe4f71ed

--20cf301d40cec2a60a04fe4f71ed
Content-Type: text/plain; charset=UTF-8

On 16 July 2014 18:17, Brian Foster <bfoster@redhat.com> wrote:

>
> That one looks like a freeze hang whereas you see an unfreeze hang.
>
You are right. My bad.


> Perhaps similar to this:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1052004
>
Looks like I can't access that bug report, even after logging in. The error
message says  "Most likely the bug has been restricted for internal
development processes and we cannot grant access."

>
> >
> > No resolution seems to have happened there. Is this a known bug, or has
> it
> > been fixed since (I'm running xfsprogs 3.1.7) ?
> >
>
> Do you have the hung task output for when this occurs (echo w >
> /proc/sysrq-trigger)?
>
No, but I'll get it the next time it happens. Thanks for the tip.

>
> Brian
>
> > Regards
> > Hrish
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--20cf301d40cec2a60a04fe4f71ed
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On 16 July 2014 18:17, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto=
:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wr=
ote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex">

<div class=3D"">
<br>
</div>That one looks like a freeze hang whereas you see an unfreeze hang.<b=
r></blockquote><div>You are right. My bad.<br>=C2=A0<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">


Perhaps similar to this:<br>
<br>
<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D1052004" target=3D=
"_blank">https://bugzilla.redhat.com/show_bug.cgi?id=3D1052004</a><br></blo=
ckquote><div>Looks like I can&#39;t access that bug report, even after logg=
ing in. The error message says=C2=A0 &quot;Most likely the bug has been res=
tricted for internal development processes and we cannot grant access.&quot=
; <br>

</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left:1px solid rgb(204,204,204);padding-left:1ex">
<div class=3D""><br>
&gt;<br>
&gt; No resolution seems to have happened there. Is this a known bug, or ha=
s it<br>
&gt; been fixed since (I&#39;m running xfsprogs 3.1.7) ?<br>
&gt;<br>
<br>
</div>Do you have the hung task output for when this occurs (echo w &gt;<br=
>
/proc/sysrq-trigger)?<br></blockquote><div>No, but I&#39;ll get it the next=
 time it happens. Thanks for the tip.<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">


<br>
Brian<br>
<br>
&gt; Regards<br>
&gt; Hrish<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br></div></div>

--20cf301d40cec2a60a04fe4f71ed--


--===============3025466282814670834==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3025466282814670834==--
