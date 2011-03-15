Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2F6hAsY113186 for <xfs@oss.sgi.com>; Tue, 15 Mar 2011 01:43:16 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18817AD9F72
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 23:46:04 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id NUUy5zPwyeV3tLPz
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 23:46:04 -0700 (PDT)
Received: by vws18 with SMTP id 18so294159vws.26
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 23:46:04 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Mar 2011 14:46:04 +0800
Message-ID: <AANLkTimHb2J80CDYPKCXN3yB5=iQ=1ZvQd4iVBFRuiri@mail.gmail.com>
Subject: Some problem about the xfs_db??
From: "Vincent,Wei" <weikun0905@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1939413315312298110=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1939413315312298110==
Content-Type: multipart/alternative; boundary=bcaec5014bf33b5c53049e7fc833

--bcaec5014bf33b5c53049e7fc833
Content-Type: text/plain; charset=ISO-8859-1

Hi all
     I used the xfs_db to check the fragment about my disk.
First I had format the disk,then I try to write the file on it.
5min later, we use df -h to check:
/dev/sda1               465.6G    295.4M    465.3G   0% /mnt/hdd0
Now I use the :
xfs_db -c frag  -r /dev/sda1
actual 616, ideal 30, fragmentation factor 95.13%

why?? this is nearly a new disk!!! How can it so many fragments?


Thanks for your help!!

--bcaec5014bf33b5c53049e7fc833
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi all</div>
<div>=A0=A0=A0=A0=A0<font style=3D"BACKGROUND-COLOR: #c7edcc">I used the xf=
s_db to check the fragment about my disk.</font></div>
<div><font style=3D"BACKGROUND-COLOR: #c7edcc">First I had format the disk,=
then I try to write the file on it.</font></div>
<div><font style=3D"BACKGROUND-COLOR: #c7edcc">5min later, we use df -h to =
check:</font></div>
<div>/dev/sda1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 465.6G=A0=A0=A0 29=
5.4M=A0=A0=A0 465.3G=A0=A0 0% /mnt/hdd0</div>
<div>Now I use the :</div>
<div>xfs_db -c frag=A0 -r /dev/sda1<br>actual 616, ideal 30, fragmentation =
factor 95.13%</div>
<div>=A0</div>
<div>why?? this is nearly a new disk!!! How can it so many fragments?</div>
<div>=A0</div>
<div>=A0</div>
<div>Thanks for your help!!</div>

--bcaec5014bf33b5c53049e7fc833--


--===============1939413315312298110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1939413315312298110==--
