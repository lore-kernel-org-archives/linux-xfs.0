Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D9257F51
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 01:03:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C658304032
	for <xfs@oss.sgi.com>; Sun,  7 Jun 2015 23:03:30 -0700 (PDT)
Received: from mail.linuz.in ([192.81.211.93]) by cuda.sgi.com with ESMTP id
	6Hwa6px6oFwauDvG for <xfs@oss.sgi.com>;
	Sun, 07 Jun 2015 23:03:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.linuz.in (Postfix) with ESMTP id 27E221C051E
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:33:23 +0530 (IST)
Received: from mail.linuz.in ([127.0.0.1])
	by localhost (nandana.linuz.in [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R8z4NVHIE_FL for <xfs@oss.sgi.com>;
	Mon,  8 Jun 2015 11:33:21 +0530 (IST)
Received: from mail.linuz.in (localhost [127.0.0.1])
	by mail.linuz.in (Postfix) with ESMTPA id 9D75C1C0456
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:33:21 +0530 (IST)
MIME-Version: 1.0
Date: Mon, 08 Jun 2015 11:33:21 +0530
From: Aravind M D <aravind@linuz.in>
Subject: High %sy cpu usage , server is very slow
Message-ID: <7ba971dae36a523e9cb2c2b115345d0a@mail.linuz.in>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0735959047650600375=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0735959047650600375==
Content-Type: multipart/alternative;
 boundary="=_a767a0530637ac7b219233420863998c"

--=_a767a0530637ac7b219233420863998c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

 

HI, 

On one of the server we are noticing high %sy usage due to
which server is very slow. We have configured one of file system with
xfs which is used to store mail queue. 

Below is the iostat output on
one of the instance when there is high %sy usage 

avg-cpu: %user %nice
%system %iowait %steal %idle 

 0.01 0.00 48.26 0.01 0.00 51.73

Device:
rrqm/s wrqm/s r/s w/s rkB/s wkB/s avgrq-sz avgqu-sz await svctm
%util
cciss/c0d0 0.00 16.99 0.00 8.36 0.00 414.90 99.30 0.77 92.57 46.30
38.69
cciss/c0d0p1 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
0.00
cciss/c0d0p2 0.00 0.00 0.00 6.13 0.00 338.02 110.32 0.77 126.18
63.09 38.66
cciss/c0d0p3 0.00 0.28 0.00 0.84 0.00 4.46 10.67 0.00 0.33
0.33 0.03
cciss/c0d0p4 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
0.00
cciss/c0d0p5 0.00 0.56 0.00 0.28 0.00 3.34 24.00 0.00 0.00 0.00
0.00
cciss/c0d0p6 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
0.00
cciss/c0d0p7 0.00 11.42 0.00 0.56 0.00 47.91 172.00 0.00 0.00 0.00
0.00
cciss/c0d0p8 0.00 4.74 0.00 0.56 0.00 21.17 76.00 0.00 0.00 0.00
0.00

~]# xfs_info /dev/cciss/c0d0p2
meta-data=/dev/cciss/c0d0p2
isize=256 agcount=16, agsize=163787 blks
 = sectsz=512 attr=1
data =
bsize=4096 blocks=2620592, imaxpct=25
 = sunit=0 swidth=0 blks,
unwritten=1
naming =version 2 bsize=4096
log =internal bsize=4096
blocks=2560, version=1
 = sectsz=512 sunit=0 blks, lazy-count=0
realtime
=none extsz=4096 blocks=0, rtextents=0

Are we facing any performance
issue with xfs. Please let me know 

-- 
Regards,

Aravind M D

 
--=_a767a0530637ac7b219233420863998c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html><body style=3D'font-family: Verdana,Geneva,sans-serif'>
<p>HI,</p>
<p>On one of the server we are noticing high %sy usage due to which server =
is very slow. We have configured one of file system with xfs which is used =
to store mail queue.</p>
<p><span>Below is the iostat output on one of the instance when there is hi=
gh %sy usage</span></p>
<p><span style=3D"font-family: 'courier new', courier; white-space: pre-wra=
p;">avg-cpu: %user %nice %system %iowait %steal %idle</span></p>
<pre class=3D"bbcodeblock" dir=3D"ltr"><span style=3D"font-family: 'courier=
 new', courier;">           0.01    0.00   48.26    0.01    0.00   51.73

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgq=
u-sz   await  svctm  %util
cciss/c0d0        0.00    16.99  0.00  8.36     0.00   414.90    99.30     =
0.77   92.57  46.30  38.69
cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00     0.00     =
0.00    0.00   0.00   0.00
cciss/c0d0p2      0.00     0.00  0.00  6.13     0.00   338.02   110.32     =
0.77  126.18  63.09  38.66
cciss/c0d0p3      0.00     0.28  0.00  0.84     0.00     4.46    10.67     =
0.00    0.33   0.33   0.03
cciss/c0d0p4      0.00     0.00  0.00  0.00     0.00     0.00     0.00     =
0.00    0.00   0.00   0.00
cciss/c0d0p5      0.00     0.56  0.00  0.28     0.00     3.34    24.00     =
0.00    0.00   0.00   0.00
cciss/c0d0p6      0.00     0.00  0.00  0.00     0.00     0.00     0.00     =
0.00    0.00   0.00   0.00
cciss/c0d0p7      0.00    11.42  0.00  0.56     0.00    47.91   172.00     =
0.00    0.00   0.00   0.00
cciss/c0d0p8      0.00     4.74  0.00  0.56     0.00    21.17    76.00     =
0.00    0.00   0.00   0.00<br /><br /></span></pre>
<pre class=3D"bbcodeblock" dir=3D"ltr"><span style=3D"font-family: 'courier=
 new', courier;">~]# xfs_info /dev/cciss/c0d0p2
meta-data=3D/dev/cciss/c0d0p2      isize=3D256    agcount=3D16, agsize=3D16=
3787 blks
         =3D                       sectsz=3D512   attr=3D1
data     =3D                       bsize=3D4096   blocks=3D2620592, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks, unwritte=
n=3D1
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D2560, version=3D=
1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0=
</span></pre>
<p>Are we facing any performance issue with xfs. Please let me know</p>
<div>
<pre>-- <br />Regards,

Aravind M D
</pre>
</div>
</body></html>

--=_a767a0530637ac7b219233420863998c--


--===============0735959047650600375==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0735959047650600375==--
