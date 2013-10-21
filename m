Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B768F7F54
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 18:32:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 976858F8050
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 16:32:24 -0700 (PDT)
Received: from mail-ob0-f171.google.com (mail-ob0-f171.google.com
	[209.85.214.171]) by cuda.sgi.com with ESMTP id
	XjqdmpbnkmnYxVa0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 16:32:23 -0700 (PDT)
Received: by mail-ob0-f171.google.com with SMTP id wn1so5201089obc.30
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 16:32:22 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Oct 2013 01:32:22 +0200
Message-ID: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
Subject: 128 bits extent bmap for file format 2
From: Pradeep Kumar <praks411@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8749165894699543737=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8749165894699543737==
Content-Type: multipart/alternative; boundary=001a11c1c93a28b99404e948b214

--001a11c1c93a28b99404e948b214
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I'm writing a small utility to parse XFS fs image on windows.
I'm able to fetch the files in the first AG (0).
However when it comes to the files which are in different AG I'm facing
some problem in parsing extent bmap 128bits data of file inode (format ==
2).

Here is the sample 128bits data
1. 00 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)

After unpacking the bits are per doc and source code
In the above case I'm getting following
Num Of blocks = 1 (correct) (0 to 20 bits)
absolute block number = 9420 (0x24CC) (wrong) (21 to 72)
file offset = 0 (72 to 126)

I'm always getting wrong absolute block number . Actual data is in block
7628 (0x1DCC).
No matter what I try I'm always getting the same result. I've even verified
this
by using the code from xfs_bmbt_get_all function from xfs source which too
gives me same result (9420).
Please someone help me with this. I'm stuck on this from 3 days.

Thanks and Regards,
Pradeep

--001a11c1c93a28b99404e948b214
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I&#39;m writing a small utility to =
parse XFS fs image on windows.</div><div>I&#39;m able to fetch the files in=
 the first AG (0).=A0</div><div>However when it comes to the files which ar=
e in different AG I&#39;m facing some problem in parsing extent bmap 128bit=
s data of file inode (format =3D=3D 2).</div>
<div><br></div><div>Here is the sample 128bits data</div><div>1. 00 00 00 0=
0 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)</div><div><br></div><div>After =
unpacking the bits are per doc and source code</div><div>In the above case =
I&#39;m getting following</div>
<div>Num Of blocks =3D 1 (correct) (0 to 20 bits)</div><div>absolute block =
number =3D 9420 (0x24CC) (wrong) (21 to 72)</div><div>file offset =3D 0 (72=
 to 126)</div><div><br></div><div>I&#39;m always getting wrong absolute blo=
ck number . Actual data is in block 7628 (0x1DCC).</div>
<div>No matter what I try I&#39;m always getting the same result. I&#39;ve =
even verified this=A0</div><div>by using the code from xfs_bmbt_get_all fun=
ction from xfs source which too gives me same result (9420).=A0</div><div>P=
lease someone help me with this. I&#39;m stuck on this from 3 days.=A0</div=
>
<div><br></div><div>Thanks and Regards,</div><div>Pradeep</div></div>

--001a11c1c93a28b99404e948b214--


--===============8749165894699543737==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8749165894699543737==--
