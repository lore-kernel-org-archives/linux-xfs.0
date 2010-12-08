Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB8JUh5c140869 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 13:30:43 -0600
Received: from mail-ey0-f179.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 341741431218
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 11:32:29 -0800 (PST)
Received: from mail-ey0-f179.google.com (mail-ey0-f179.google.com
	[209.85.215.179]) by cuda.sgi.com with ESMTP id
	hWfGWacONSYFAf1A for <xfs@oss.sgi.com>;
	Wed, 08 Dec 2010 11:32:29 -0800 (PST)
Received: by eyg24 with SMTP id 24so1137538eyg.38
	for <xfs@oss.sgi.com>; Wed, 08 Dec 2010 11:32:28 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 8 Dec 2010 20:32:28 +0100
Message-ID: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>
Subject: xfs tuning for a 830 GB partition (mkfs.xfs options)
From: Abel Coto <whitewolf573@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4048477307600624126=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4048477307600624126==
Content-Type: multipart/alternative; boundary=000e0cd1e32a82577f0496eb2e94

--000e0cd1e32a82577f0496eb2e94
Content-Type: text/plain; charset=ISO-8859-1

I want to create a 830 GB partition, to mount as /home in my Centos 5.4
workstation.

Actually i have /home not mounted ,so i would have to create the new
partition in the lvm,format it and use rsync to copy /home directory to it.

for a 830 GB partition that i will use to save my data in general and also
3d / CG projects and renders once finished them what agcount value should be
used. I have read that mkfs default option creates 1 allocation group each
4G , so i understand that for a 830 GB partition agcount should be 208.

It is this correct ?

so i would use for format the partition

mkfs.xfs -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=208 -L
VolumeName <dev>

I have read that some people instead use a 8GB allocation size , and agcount
Size partition / 8 GB (in my case 104) , but i don't know if that would be
good , as would result in less allocation groups.

i understand if agcount > 208  (for example 416 ) , the allocation size (2GB
for agcount=416) would be less than 4 GB , to have in total 830 GB.

I have read that too much allocation groups are bad , but i don't now if 416
are  too much for a 830 GB partition (and shoukd use 208 to 300) or not.

I will mount the partition with logbufs=8. (i use a 128m journal and
logbufs=8 to improve a bit deleting performance). I will perhaps use noatime
too ,but i have to see if my backup app, uses atime or not.


I have another 1,5 TB HDD where i want to create a 350 GB xfs partition to
save the 3d projects and render output when working with the 3d software i
use (Maya 2011). My thoughts are to use /home to save both music ,
photography,isos,etc also of finished 3d / cg work and iso dvd / tutorials
and video-tutorials ,and this 350 GB partition use it only for data and
projects that i am still working with,and once finished copy to /home.

for this partition , that will handle mostly big files (500 MB to 2-3 GB at
least) what mkfs.xfs options should i use ?

something like:

mkfs.xfs -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=90 -L
VolumeName <dev>  (350/4 --> 88)

I prefer to have a separate partition to save projects at least when i am
working with them , although 3d modelling is not too much filesystem bounded
, and then copy it to /home , as i think having a good backup strategy shoud
not be a problem to have my music and data along with 3d work finished in
the same partition (3d is for me a hobby,that i like a lot but a hobby)

I will have to compile a custom kernel from kernel.org because my centos
kernel is 2.6.18,and there is no higher one available, only compiling it,
but this shouldn't be a problem.

--000e0cd1e32a82577f0496eb2e94
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I want to create a 830 GB partition, to mount as /home in my Centos 5.4 wor=
kstation. <br><br>Actually i have /home not mounted ,so i would have to cre=
ate the new partition in the lvm,format it and use rsync to copy /home dire=
ctory to it.<br>
<br>for a 830 GB partition that i will use to save my data in general and a=
lso 3d / CG projects and renders once finished them what agcount value shou=
ld be used. I have read that mkfs default option creates 1 allocation group=
 each 4G , so i understand that for a 830 GB partition agcount should be 20=
8.<br>
<br>It is this correct ? <br><br>so i would use for format the partition <b=
r><br>mkfs.xfs -l lazy-count=3D1,version=3D2,size=3D128m -i attr=3D2 -d agc=
ount=3D208 -L VolumeName &lt;dev&gt;<br><br>I have read that some people in=
stead use a 8GB allocation size , and agcount Size partition / 8 GB (in my =
case 104) , but i don&#39;t know if that would be good , as would result in=
 less allocation groups. <br>
<br>i understand if agcount &gt; 208=A0 (for example 416 ) , the allocation=
 size (2GB for agcount=3D416) would be less than 4 GB , to have in total 83=
0 GB.<br><br>I have read that too much allocation groups are bad , but i do=
n&#39;t now if 416 are=A0 too much for a 830 GB partition (and shoukd use 2=
08 to 300) or not.<br>
<br>I will mount the partition with logbufs=3D8. (i use a 128m journal and =
logbufs=3D8 to improve a bit deleting performance). I will perhaps use noat=
ime too ,but i have to see if my backup app, uses atime or not.<br><br><br>
I have another 1,5 TB HDD where i want to create a 350 GB xfs partition to =
save the 3d projects and render output when working with the 3d software i =
use (Maya 2011). My thoughts are to use /home to save both music , photogra=
phy,isos,etc also of finished 3d / cg work and iso dvd / tutorials and vide=
o-tutorials ,and this 350 GB partition use it only for data and projects th=
at i am still working with,and once finished copy to /home.<br>
<br>for this partition , that will handle mostly big files (500 MB to 2-3 G=
B at least) what mkfs.xfs options should i use ?<br><br>something like:<br>=
<br>mkfs.xfs -l lazy-count=3D1,version=3D2,size=3D128m -i attr=3D2 -d agcou=
nt=3D90 -L VolumeName &lt;dev&gt;=A0 (350/4 --&gt; 88)<br>
<br>I prefer to have a separate partition to save projects at least when i =
am working with them , although 3d modelling is not too much filesystem bou=
nded , and then copy it to /home , as i think having a good backup strategy=
 shoud not be a problem to have my music and data along with 3d work finish=
ed in the same partition (3d is for me a hobby,that i like a lot but a hobb=
y)<br>
<br>I will have to compile a custom kernel from <a href=3D"http://kernel.or=
g">kernel.org</a> because my centos kernel is 2.6.18,and there is no higher=
 one available, only compiling it, but this shouldn&#39;t be a problem.<br>


--000e0cd1e32a82577f0496eb2e94--


--===============4048477307600624126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4048477307600624126==--
