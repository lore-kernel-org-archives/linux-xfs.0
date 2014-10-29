Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3679F7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 04:22:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 241CD304039
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:21:57 -0700 (PDT)
Received: from mail-ob0-f171.google.com (mail-ob0-f171.google.com
	[209.85.214.171]) by cuda.sgi.com with ESMTP id
	B6NFtgzK5ccbtssd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 02:21:52 -0700 (PDT)
Received: by mail-ob0-f171.google.com with SMTP id wp18so2038124obc.2
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:21:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141029075134.GB13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
	<54506CD9.90403@sandeen.net>
	<CAGdb-8cGAzT_0ck-pJyQX-OcnE_3FPCA9TesHW7c_raDSKEXWg@mail.gmail.com>
	<20141029044017.GG16186@dastard>
	<CAGdb-8e=wttjj+wTj8wqRWyUUz+AUmz-O0=r3+HoJ5zGgV-dkQ@mail.gmail.com>
	<20141029075134.GB13323@dastard>
Date: Wed, 29 Oct 2014 17:21:52 +0800
Message-ID: <CAGdb-8dhPe9wvoGnUsFo2Q3EZWka+i2DcFN-AqJV_G09+=4f2w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1651465645225078082=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

--===============1651465645225078082==
Content-Type: multipart/alternative; boundary=001a1141c712503dd405068c4bc5

--001a1141c712503dd405068c4bc5
Content-Type: text/plain; charset=UTF-8

Same testing in same machine (just different kernel).

3.18-rc2:
xfsdump will hang (the test.xfsdump.gz size stop around 57M)

3.17.1 (with 2 patches):
xfsdump generate the dump file, but xfsrestore can't restore all files from
the dump file.
I think the dump is corrupted, can't restore it also in kernel 3.16.5.

3.16.5:
everything work fine.


2014-10-29 15:51 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Wed, Oct 29, 2014 at 02:46:33PM +0800, Tommy Wu wrote:
> > it will hang after this message (the kernel in above git repo):
> >
> > /sbin/xfsdump: dumping non-directory files
> >
> > console show the below message every 2 minutes:
> > [  480.387308] INFO: task xfsdump:2717 blocked for more than 120 seconds.
>
> I think there might be something else wrong with your system.
>
> What's the stack trace associated with that? If there's none,
> what's the output of 'echo w > /proc/sysrq-trigger' in dmesg?
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

--001a1141c712503dd405068c4bc5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Same testing in same machine (just different kernel).=
<br><br></div><div>3.18-rc2:<br>xfsdump will hang (the test.xfsdump.gz size=
 stop around 57M)<br><br></div><div>3.17.1 (with 2 patches): <br>xfsdump ge=
nerate the dump file, but xfsrestore can&#39;t restore all files from the d=
ump file.<br></div><div>I think the dump is corrupted, can&#39;t restore it=
 also in kernel 3.16.5.<br><br></div>3.16.5: <br>everything work fine.<br><=
div><br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quot=
e">2014-10-29 15:51 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D=
"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;<=
/span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, Oct 29, =
2014 at 02:46:33PM +0800, Tommy Wu wrote:<br>
&gt; it will hang after this message (the kernel in above git repo):<br>
&gt;<br>
&gt; /sbin/xfsdump: dumping non-directory files<br>
&gt;<br>
&gt; console show the below message every 2 minutes:<br>
&gt; [=C2=A0 480.387308] INFO: task xfsdump:2717 blocked for more than 120 =
seconds.<br>
<br>
</span>I think there might be something else wrong with your system.<br>
<br>
What&#39;s the stack trace associated with that? If there&#39;s none,<br>
what&#39;s the output of &#39;echo w &gt; /proc/sysrq-trigger&#39; in dmesg=
?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--001a1141c712503dd405068c4bc5--


--===============1651465645225078082==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1651465645225078082==--
