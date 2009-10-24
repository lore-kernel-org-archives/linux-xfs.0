Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9O8QRj2026030 for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 03:26:27 -0500
Received: from mail-px0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7620D33E43
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 01:28:02 -0700 (PDT)
Received: from mail-px0-f193.google.com (mail-px0-f193.google.com
	[209.85.216.193]) by cuda.sgi.com with ESMTP id
	z5hpDvKHmpXvUtxL for <xfs@oss.sgi.com>;
	Sat, 24 Oct 2009 01:28:02 -0700 (PDT)
Received: by pxi31 with SMTP id 31so2459787pxi.20
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 01:28:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE116E1.5050008@sandeen.net>
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
	<4ADF2EE8.6010700@sandeen.net>
	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
	<4ADF4882.70106@sandeen.net>
	<c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>
	<4AE06BAE.8090706@sandeen.net>
	<c2dcdfa40910220930l19a8dab0y88e80630a2453b39@mail.gmail.com>
	<4AE08AED.1020702@sandeen.net>
	<c2dcdfa40910220955q586bdcabn268ddbc30d9b785d@mail.gmail.com>
	<4AE116E1.5050008@sandeen.net>
Date: Sat, 24 Oct 2009 13:58:02 +0530
Message-ID: <c2dcdfa40910240128n7895d5c1s92fb88952a4bddcf@mail.gmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3004747193637862198=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============3004747193637862198==
Content-Type: multipart/alternative; boundary=000e0cd20fb85ae4cf0476aa1b83

--000e0cd20fb85ae4cf0476aa1b83
Content-Type: text/plain; charset=ISO-8859-1

Hi Eric,

Can this issue be related to some timing issue/synchronization with disk?
Test case is something like this..

I create thousands of files... (simply keep touching to create '0' bytes
files from a shell script) and in between I do Ctrl + C, to stop.
Then, I issue command to remove files (rm -rf *) and crash appears.

Thanks & Regards,
Amit Sahrawat

On Fri, Oct 23, 2009 at 8:07 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Amit Sahrawat wrote:
>
>> that means it highely unlikey to get a fix for this issue :(
>>  Yes, backporting just doest not suits for me.
>>  I am trying to dig into the code, but really dont know if that's going to
>> be that easy.
>>  Thanks Eric for all the help.
>> W'll you know if I am able to fix this.
>>
>
> One other thought on the backporting side; RHEL5.4 now has xfs merged into
> a 2.6.18-ish kernel.  There are still some other supporting bits in that
> kernel, it's hardly vanilla 2.6.18, but if you want to try a backport route
> it might be one option.
>
> Testing an upstream kernel w/ your testcase in an emulator would also be a
> reasonable thing to do, I think.
>
> -eric
>
> Thanks & Regards,
>> Amit Sahrawat
>>
>>

--000e0cd20fb85ae4cf0476aa1b83
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi Eric,</div>
<div>=A0</div>
<div>Can this issue be related to some timing issue/synchronization with di=
sk?</div>
<div>Test case is something like this..</div>
<div>=A0</div>
<div>I create thousands of files... (simply keep touching to create &#39;0&=
#39; bytes files from a shell script) and in between I do Ctrl + C, to stop=
.</div>
<div>Then, I issue command to remove files (rm -rf *) and crash appears.=A0=
</div>
<div>=A0</div>
<div>Thanks &amp; Regards,</div>
<div>Amit Sahrawat<br><br></div>
<div class=3D"gmail_quote">On Fri, Oct 23, 2009 at 8:07 AM, Eric Sandeen <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.=
net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">Amit Sahrawat wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">that means it highely unlikey to=
 get a fix for this issue :(<br>=A0Yes, backporting just doest not suits fo=
r me.<br>
=A0I am trying to dig into the code, but really dont know if that&#39;s goi=
ng to be that easy.<br>=A0Thanks Eric for all the help.<br>W&#39;ll you kno=
w if I am able to fix this.<br></blockquote><br></div>One other thought on =
the backporting side; RHEL5.4 now has xfs merged into a 2.6.18-ish kernel. =
=A0There are still some other supporting bits in that kernel, it&#39;s hard=
ly vanilla 2.6.18, but if you want to try a backport route it might be one =
option.<br>
<br>Testing an upstream kernel w/ your testcase in an emulator would also b=
e a reasonable thing to do, I think.<br><br>-eric<br><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Thanks &amp; Regards,<br>Amit Sa=
hrawat<br><br></blockquote></blockquote></div><br>

--000e0cd20fb85ae4cf0476aa1b83--


--===============3004747193637862198==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3004747193637862198==--
