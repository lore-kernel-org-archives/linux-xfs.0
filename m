Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E77357F50
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 01:58:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9323304032
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 23:58:45 -0800 (PST)
Received: from mail-qg0-f53.google.com (mail-qg0-f53.google.com
	[209.85.192.53]) by cuda.sgi.com with ESMTP id LTt1S6jGsM2gpN3Y
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Dec 2015 23:58:42 -0800 (PST)
Received: by qgcc31 with SMTP id c31so127981975qgc.3
	for <xfs@oss.sgi.com>; Wed, 09 Dec 2015 23:58:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151210021343.GI19802@dastard>
References: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
	<20151210021343.GI19802@dastard>
Date: Wed, 9 Dec 2015 23:58:41 -0800
Message-ID: <CACQ+Yct8ics=YebWFU=h4VHSdVEW3jcpdbZ8=niov9A+fL-HqQ@mail.gmail.com>
Subject: Re: handling device or resource busy errors.
From: Ed Peschko <horos22@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3499329523717998579=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============3499329523717998579==
Content-Type: multipart/alternative; boundary=001a11c1641a447a4805268693c3

--001a11c1641a447a4805268693c3
Content-Type: text/plain; charset=UTF-8

Dave,

futex comes from doing a simple strace, which showed the futex as the call
that was being blocked. My fear is that it is a holdover from an old, dead
process; we went through each process on the system and lsof -p'd it,
didn't see anything.

Thanks for the suggestion of sysrq btw, I'll try that the next time I have
access to the box, but waiting doesn't help.Also,  I don't see in sysrq the
actual ability to *kill* wayward locks however; but it will a great help us
track down the underlying issue.

Thanks,

Ed

The one thing I don't see in sysrq is a way to
As for sys

--001a11c1641a447a4805268693c3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Dave,<br><br>futex comes from doing a simple strace, which=
 showed the futex as the call that was being blocked. My fear is that it is=
 a holdover from an old, dead process; we went through each=C2=A0process on=
 the system and lsof -p&#39;d it, didn&#39;t see anything.<br><br>Thanks fo=
r the suggestion of sysrq btw, I&#39;ll try that the next time I have acces=
s to the box, but waiting doesn&#39;t help.Also, =C2=A0I don&#39;t see in s=
ysrq the actual ability to *kill* wayward locks however; but it will a grea=
t help us track down the underlying issue.<div><br></div><div>Thanks,<br><b=
r>Ed<br><div><font color=3D"#500050"><span style=3D"line-height:21px"><br><=
/span></font></div><div><font color=3D"#500050"><span style=3D"line-height:=
21px">The one thing I don&#39;t see in sysrq is a way to=C2=A0</span></font=
></div><div>As for sys</div></div></div>

--001a11c1641a447a4805268693c3--


--===============3499329523717998579==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3499329523717998579==--
