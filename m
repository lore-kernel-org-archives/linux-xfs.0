Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J0jTeu001182 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 19:45:29 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	vlKiw8IL4NpiROws (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 17:45:28 -0700 (PDT)
Received: by obbup19 with SMTP id up19so4179950obb.26
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 17:45:28 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 09:45:28 +0900
Message-ID: <CABF-5Wryz4QXMzDb12zViPytSEi67Tm0ZwPkYLJaCbDix+91fg@mail.gmail.com>
Subject: [QUESTION] Too much time to delete file on xfs filesystem
From: Ryan Lee <ryanlee.lahk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5282372338543504146=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5282372338543504146==
Content-Type: multipart/alternative; boundary=e89a8ff1c4e64eeb8404c2c89959

--e89a8ff1c4e64eeb8404c2c89959
Content-Type: text/plain; charset=ISO-8859-1

Hi, My name is Ryan.

 Nowadays, Our company product has a new problem which is taking too much
time to delete file on xfs filesystem.

 When I try to delete the file (18GByte, It was just one file), it would
take around 7 minutes 30 seconds.

I've known like this, the XFS filesystem's deleting time is less than other
filesystems such as EXT3, EXT4 and reiserFS.


 What I did here.

-rw-r--r--   1 root     root     18924699648 Jan  2  1971 hdd_write_test6.ts

# time rm hdd_write_test6.ts



real    7m 28.10s

user    0m 0.00s

sys     0m 9.79s

#

 Again, I have an opinion about XFS.

XFS is faster than other filesystem as I told you. and I've got this
information from internet.

But, the test result makes me confusing about that I've belived about XFS
filesystem.



Am I right??

 So, Please, give me any information about this what you have.

Our product use this version like below.

kernel  2.6.37

xfsprogs 3.1.7



Thanks, Ryan.

--e89a8ff1c4e64eeb8404c2c89959
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>Hi, My name is Ryan.</p><p>=A0Nowadays, Our company product has a new pr=
oblem which is taking too much time to delete file on xfs filesystem.</p><p=
>=A0When=A0I try to delete the file (18GByte, It was just one file), it wou=
ld take around 7 minutes 30 seconds.</p>
<p>I&#39;ve known like this, the XFS filesystem&#39;s deleting time is less=
 than other filesystems such as EXT3, EXT4 and reiserFS.</p><p>=A0</p><div>=
=A0What I did here.</div><div><br>-rw-r--r--=A0=A0 1 root=A0=A0=A0=A0 root=
=A0=A0=A0=A0 18924699648 Jan=A0 2=A0 1971 hdd_write_test6.ts</div>
<p># time rm hdd_write_test6.ts</p><p>=A0</p><p>real=A0=A0=A0 7m 28.10s</p>=
<p>user=A0=A0=A0 0m 0.00s</p><p>sys=A0=A0=A0=A0 0m 9.79s</p><p>#</p><p>=A0A=
gain, I have an opinion about XFS.</p><p>XFS is faster than other filesyste=
m as I told you. and I&#39;ve got this information from internet.</p>
<p>But, the test result makes me confusing about that I&#39;ve belived abou=
t XFS filesystem.</p><p>=A0</p><p>Am I right??</p><p>=A0So, Please, give me=
 any information about this what you have.</p><div>=A0</div><div>Our produc=
t use this version like below.</div>
<p>kernel=A0 2.6.37</p><p>xfsprogs 3.1.7</p><p>=A0=A0</p><p>Thanks, Ryan.</=
p>

--e89a8ff1c4e64eeb8404c2c89959--


--===============5282372338543504146==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5282372338543504146==--
