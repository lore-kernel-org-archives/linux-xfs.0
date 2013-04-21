Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5B2929DFA
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 17:39:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 946258F8033
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 15:39:05 -0700 (PDT)
Received: from mail-vb0-f54.google.com (mail-vb0-f54.google.com
	[209.85.212.54]) by cuda.sgi.com with ESMTP id 5qKMoZL0qgXB40Mu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Apr 2013 15:39:00 -0700 (PDT)
Received: by mail-vb0-f54.google.com with SMTP id w16so5324514vbf.27
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 15:39:00 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 21 Apr 2013 23:38:59 +0100
Message-ID: <CAEDdjHcoZc2eS=hgb7K7BVf=2z28uh3CMuEU8+qFPp5UFvj-iQ@mail.gmail.com>
Subject: noop or deadline on an SSD?
From: Pedro Ribeiro <pedrib@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8452504996575326520=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8452504996575326520==
Content-Type: multipart/alternative; boundary=20cf307d04384abef704dae69e44

--20cf307d04384abef704dae69e44
Content-Type: text/plain; charset=ISO-8859-1

Hi all,

I recently moved my system to an SSD.

I decided to do what the XFS FAQ says (
http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E)
and I used all the defaults for creating the new XFS file systems.

However the paragraph above also reads: "As of kernel 3.2.12, the default
i/o scheduler, CFQ, will defeat much of the parallelization in XFS."

Ok, I also read that with an SSD I should be using noop or deadline. And
which one of these would perform better with XFS with an SSD? And while I'm
at it, which one would be best for a  mechanical drive?

Thanks in advance.

Regards,
Pedro

--20cf307d04384abef704dae69e44
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div><br></div><div style>I recently moved my syste=
m to an SSD.=A0</div><div style><br></div><div style>I decided to do what t=
he XFS FAQ says (<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_t=
une_my_XFS_filesystems_for_.3Csomething.3E">http://xfs.org/index.php/XFS_FA=
Q#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E</a>) and=A0I use=
d all the defaults for creating the new XFS file systems.=A0</div>
<div style><br></div><div style>However the paragraph above also reads: &qu=
ot;<span style=3D"color:rgb(0,0,0);font-family:sans-serif;font-size:13px;li=
ne-height:19.046875px">As of kernel 3.2.12, the default i/o scheduler, CFQ,=
 will defeat much of the parallelization in XFS.&quot;</span></div>
<div style><span style=3D"color:rgb(0,0,0);font-family:sans-serif;font-size=
:13px;line-height:19.046875px"><br></span></div><div style><span style=3D"c=
olor:rgb(0,0,0);font-family:sans-serif;font-size:13px;line-height:19.046875=
px">Ok, I also read that with an SSD I should be using noop or deadline. An=
d which one of these would perform better with XFS with an SSD? And while I=
&#39;m at it, which one would be best for a =A0mechanical drive?</span></di=
v>
<div style><span style=3D"color:rgb(0,0,0);font-family:sans-serif;font-size=
:13px;line-height:19.046875px"><br></span></div><div style><span style=3D"c=
olor:rgb(0,0,0);font-family:sans-serif;font-size:13px;line-height:19.046875=
px">Thanks in advance.</span></div>
<div style><span style=3D"color:rgb(0,0,0);font-family:sans-serif;font-size=
:13px;line-height:19.046875px"><br>Regards,</span></div><div style><span st=
yle=3D"color:rgb(0,0,0);font-family:sans-serif;font-size:13px;line-height:1=
9.046875px">Pedro</span></div>
</div>

--20cf307d04384abef704dae69e44--


--===============8452504996575326520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8452504996575326520==--
