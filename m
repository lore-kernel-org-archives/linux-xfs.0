Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE0597F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 01:46:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E9A8304032
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:46:38 -0700 (PDT)
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com
	[209.85.218.42]) by cuda.sgi.com with ESMTP id oVGNbzaOnS5TKmNX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:46:33 -0700 (PDT)
Received: by mail-oi0-f42.google.com with SMTP id a3so1204460oib.1
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:46:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141029044017.GG16186@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
	<54506CD9.90403@sandeen.net>
	<CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
	<20141029044017.GG16186@dastard>
Date: Wed, 29 Oct 2014 14:46:33 +0800
Message-ID: <CAGdb-8e=wttjj+wTj8wqRWyUUz+AUmz-O0=r3+HoJ5zGgV-dkQ@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2711798739219053311=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

--===============2711798739219053311==
Content-Type: multipart/alternative; boundary=089e01634b7ed954bc05068a1f6f

--089e01634b7ed954bc05068a1f6f
Content-Type: text/plain; charset=UTF-8

it will hang after this message (the kernel in above git repo):

/sbin/xfsdump: dumping non-directory files

console show the below message every 2 minutes:
[  480.387308] INFO: task xfsdump:2717 blocked for more than 120 seconds.



2014-10-29 12:40 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Wed, Oct 29, 2014 at 12:30:33PM +0800, Tommy Wu wrote:
> > both dump and restore with those 2 patches.
>
> Can you try the xfs-fixes-for-3.18-rc3 branch I pushed out this
> morning to the upstream git repo here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 

Tommy Wu

--089e01634b7ed954bc05068a1f6f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>it will hang after this message (the kernel in a=
bove git repo):<br><br>/sbin/xfsdump: dumping non-directory files<br><br></=
div>console show the below message every 2 minutes:<br></div>[=C2=A0 480.38=
7308] INFO: task xfsdump:2717 blocked for more than 120 seconds.<br><br><di=
v><div><br></div></div></div><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">2014-10-29 12:40 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<=
a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com=
</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed,=
 Oct 29, 2014 at 12:30:33PM +0800, Tommy Wu wrote:<br>
&gt; both dump and restore with those 2 patches.<br>
<br>
</span>Can you try the xfs-fixes-for-3.18-rc3 branch I pushed out this<br>
morning to the upstream git repo here:<br>
<br>
git://<a href=3D"http://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-x=
fs.git" target=3D"_blank">git.kernel.org/pub/scm/linux/kernel/git/dgc/linux=
-xfs.git</a><br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--089e01634b7ed954bc05068a1f6f--


--===============2711798739219053311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2711798739219053311==--
