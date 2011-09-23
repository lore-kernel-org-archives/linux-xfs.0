Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NFC570114789 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 10:12:05 -0500
Received: from mail-yi0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADFDF1412ED5
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 08:17:38 -0700 (PDT)
Received: from mail-yi0-f53.google.com (mail-yi0-f53.google.com
	[209.85.218.53]) by cuda.sgi.com with ESMTP id E0xztMTwqrWrCTnl
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 08:17:38 -0700 (PDT)
Received: by yie21 with SMTP id 21so3693946yie.26
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 08:12:02 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 23:12:02 +0800
Message-ID: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
Subject: Directory fsync
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7943675311293072287=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7943675311293072287==
Content-Type: multipart/alternative; boundary=20cf30563c3342f13f04ad9d3b46

--20cf30563c3342f13f04ad9d3b46
Content-Type: text/plain; charset=ISO-8859-1

I note below words in the manual of fsync:
       Calling  fsync()  does  not  necessarily  ensure  that  the entry in
the directory containing the file has also reached disk.  For that an
explicit fsync() on a file
       descriptor for the directory is also needed.

I am wondering is directory sync is essential after below steps if I want to
assure the file can be retrieved after system crash?

1) create file A
2) write file A
3) fsync(file A)

--------------------------------> fsync(parent directory) [Is it essential
to make the inode linked to parent directory?]

--20cf30563c3342f13f04ad9d3b46
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I note below words in the manual of fsync:<br>=A0=A0=A0=A0=A0=A0 Calling=A0=
 fsync()=A0 does=A0 not=A0 necessarily=A0 ensure=A0 that=A0 the entry in th=
e directory containing the file has also reached disk.=A0 For that an expli=
cit fsync() on a file<br>
=A0=A0=A0=A0=A0=A0 descriptor for the directory is also needed.<br><br>I am=
 wondering is directory sync is essential after below steps if I want to as=
sure the file can be retrieved after system crash?<br><br>1) create file A<=
br>2) write file A<br>
3) fsync(file A)<br><br>--------------------------------&gt; fsync(parent d=
irectory) [Is it essential to make the inode linked to parent directory?]<b=
r><br><br>

--20cf30563c3342f13f04ad9d3b46--


--===============7943675311293072287==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7943675311293072287==--
