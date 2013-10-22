Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0544B7F6B
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 03:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84D50AC001
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 01:08:11 -0700 (PDT)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	l9BQOk7q02fQsWim (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 01:08:10 -0700 (PDT)
Received: by mail-ob0-f169.google.com with SMTP id wp4so7106967obc.0
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 01:08:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131022001218.GH4446@dastard>
References: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
	<20131022001218.GH4446@dastard>
Date: Tue, 22 Oct 2013 10:08:09 +0200
Message-ID: <CAPU9cc2EsoeNE+mMQSwmLVXyyPoE9jLVhDRcQLJxvWYTNU-33w@mail.gmail.com>
Subject: Re: 128 bits extent bmap for file format 2
From: Pradeep Kumar <praks411@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4505169289179177739=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4505169289179177739==
Content-Type: multipart/alternative; boundary=047d7b3a9b12b7b7f304e94fe6dc

--047d7b3a9b12b7b7f304e94fe6dc
Content-Type: text/plain; charset=ISO-8859-1

Hi Dave,

Thanks for the reply. I think I may get my solution. Can you explain the
difference between the two?
I've created sample xfs file using mkfs.xfs with mostly default parameter
1. Sector Size = 512
2. Block size = 4096
3. AG Number = 2
4. Number of blocks per AG = 6400.

So when I get absolute block 9420 from file extent data  I'm going to (6400
+ 3020) , 3020 block of second AG which is wrong. The file start from 7628
absolute block or (6400 + 1228), 1228 block of second AG.
Please describe in some detail above the conversion which you are talking
about.

Thanks and Regards,
Pradeep



On 22 October 2013 02:12, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 22, 2013 at 01:32:22AM +0200, Pradeep Kumar wrote:
> > Hi,
> >
> > I'm writing a small utility to parse XFS fs image on windows.
> > I'm able to fetch the files in the first AG (0).
> > However when it comes to the files which are in different AG I'm facing
> > some problem in parsing extent bmap 128bits data of file inode (format ==
> > 2).
>
> Extents use filesystem block encodings, not disk addresses. Look up
> the macros XFS_DADDR_TO_FSB and XFS_FSB_TO_DADDR.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b3a9b12b7b7f304e94fe6dc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div><br><div>Thanks for the reply. I think I may =
get my solution. Can you explain the difference between the two?</div><div>=
I&#39;ve created sample xfs file using mkfs.xfs with mostly default paramet=
er=A0</div>
<div>1. Sector Size =3D 512</div><div>2. Block size =3D 4096</div><div>3. A=
G Number =3D 2</div><div>4. Number of blocks per AG =3D 6400.</div><div><br=
></div><div>So when I get absolute block 9420 from file extent data =A0I&#3=
9;m going to (6400 + 3020) , 3020 block of second AG which is wrong. The fi=
le start from 7628 absolute block or (6400 + 1228), 1228 block of second AG=
.=A0</div>
<div>Please describe in some detail above the conversion which you are talk=
ing about.</div><div><br></div><div>Thanks and Regards,</div><div>Pradeep</=
div><div><br></div></div></div><div class=3D"gmail_extra"><br><br><div clas=
s=3D"gmail_quote">
On 22 October 2013 02:12, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</spa=
n> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On Tue, Oct 22, 2013 at 01:32:22AM +0200, Pradeep Kumar w=
rote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;m writing a small utility to parse XFS fs image on windows.<br>
&gt; I&#39;m able to fetch the files in the first AG (0).<br>
&gt; However when it comes to the files which are in different AG I&#39;m f=
acing<br>
&gt; some problem in parsing extent bmap 128bits data of file inode (format=
 =3D=3D<br>
&gt; 2).<br>
<br>
</div>Extents use filesystem block encodings, not disk addresses. Look up<b=
r>
the macros XFS_DADDR_TO_FSB and XFS_FSB_TO_DADDR.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--047d7b3a9b12b7b7f304e94fe6dc--


--===============4505169289179177739==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4505169289179177739==--
