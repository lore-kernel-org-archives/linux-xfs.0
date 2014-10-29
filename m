Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3150E7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:23:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1655A8F8035
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:23:09 -0700 (PDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	ppFCcfGUzg1CfACI (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 11:23:07 -0700 (PDT)
Received: by mail-qc0-f174.google.com with SMTP id r5so2826388qcx.19
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:23:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414552144-12627-1-git-send-email-david@fromorbit.com>
References: <1414552144-12627-1-git-send-email-david@fromorbit.com>
Date: Wed, 29 Oct 2014 11:23:06 -0700
Message-ID: <CAO85XkR+aMv2e1GvdatdUdJSqLXykEuvZ+JBJdd=gBpYHMQ0Dw@mail.gmail.com>
Subject: Re: [PATCH 0/2] repair: fix AGFL rebuild problem
From: Barkley Vowk <bvowk@box.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1123446063654318716=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1123446063654318716==
Content-Type: multipart/alternative; boundary=001a11c11ed8f58bb8050693da48

--001a11c11ed8f58bb8050693da48
Content-Type: text/plain; charset=UTF-8

These patches fixed my issue.

Thanks.

On Tue, Oct 28, 2014 at 8:09 PM, Dave Chinner <david@fromorbit.com> wrote:

> Hi folks,
>
> The following two patches fix a repair rebuild issue that was
> reported to me. xfs_repair would appear to succeed, but subsequent
> runs would report a freespace mismatch and then on mount trigger
> a corruption error on the first allocation from AG 0.
>
> The problem as that the AGFL was not being correctly rebuilt due to
> a very particular freespace pattern in AG 0 which required free
> blocks in the AGFL to populate an empty AGFL. reapir silently
> ignored this error, so it triggered allocation corruption errors
> when the same AGFL fixup attempt failed on a mounted filesystem.
>
> The fix is relatively straight forward, as is the fixes to the
> tracing code that I had to make before i could track down the issue.
>
> -Dave.
>
>

--001a11c11ed8f58bb8050693da48
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">These patches fixed my issue.=C2=A0<div><br></div><div>Tha=
nks.=C2=A0</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_qu=
ote">On Tue, Oct 28, 2014 at 8:09 PM, Dave Chinner <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi folks,<br>
<br>
The following two patches fix a repair rebuild issue that was<br>
reported to me. xfs_repair would appear to succeed, but subsequent<br>
runs would report a freespace mismatch and then on mount trigger<br>
a corruption error on the first allocation from AG 0.<br>
<br>
The problem as that the AGFL was not being correctly rebuilt due to<br>
a very particular freespace pattern in AG 0 which required free<br>
blocks in the AGFL to populate an empty AGFL. reapir silently<br>
ignored this error, so it triggered allocation corruption errors<br>
when the same AGFL fixup attempt failed on a mounted filesystem.<br>
<br>
The fix is relatively straight forward, as is the fixes to the<br>
tracing code that I had to make before i could track down the issue.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Dave.<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c11ed8f58bb8050693da48--


--===============1123446063654318716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1123446063654318716==--
