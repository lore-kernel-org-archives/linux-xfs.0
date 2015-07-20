Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DC177F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 08:08:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9DBCAC006
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 06:08:20 -0700 (PDT)
Received: from nm19-vm2.bullet.mail.sg3.yahoo.com
	(nm19-vm2.bullet.mail.sg3.yahoo.com [106.10.149.113]) by
	cuda.sgi.com with ESMTP id SKdNtMCRbvcN9GIa (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 06:08:18 -0700 (PDT)
Date: Mon, 20 Jul 2015 13:08:15 +0000 (UTC)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Message-ID: <1469853784.545263.1437397695535.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <55ACB2BD.6050601@mygrande.net>
References: <55ACB2BD.6050601@mygrande.net>
Subject: Re: XFS File system in trouble
MIME-Version: 1.0
Reply-To: Gim Leong Chin <chingimleong@yahoo.com.sg>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4433075778157635864=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4433075778157635864==
Content-Type: multipart/alternative;
	boundary="----=_Part_545262_260624072.1437397695529"

------=_Part_545262_260624072.1437397695529
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Leslie,
My two cents here, it appears you are using AMD FX CPU on ASUS Sabertooth m=
otherboard?
I would strongly suggest you use unbuffered ECC DIMMs in your system.=C2=A0=
 Mcelog will warn of ECC errors in your DIMMs.=C2=A0 ECC will correct singl=
e bit errors and at least detect multi bit errors.
I had AMD Opteron servers with registered ECC DIMMs with continuous correct=
able ECC errors running HPC jobs for up to one month without any crashes un=
til I could schedule down time for DIMM replacement.=C2=A0 The errors will =
be flagged either in BMC (service processor) or mcelog.
All my PC / workstations at work place and at home with consumer AMD Althon=
 64 and AMD Phenom II had unbuffered ECC DIMMs on ASUS motherboards.=C2=A0 =
I never had any memory errors; I know that if there are memory errors I wil=
l get notified.

Chin Gim Leong

      From: Leslie Rhorer <lrhorer@mygrande.net>
 To: Martin Papik <mp6058@gmail.com>=20
Cc: xfs@oss.sgi.com=20
 Sent: Monday, 20 July 2015, 16:35
 Subject: Re: XFS File system in trouble
  =20
On 7/20/2015 3:05 AM, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
>
> Since you've already found one HW related fault, would you consider
> booting into memtest for a couple of passes just to be on the safe
> side.

=C2=A0=C2=A0=C2=A0 I did that after confirming the one stick of memory was =
bad.=C2=A0 Twice.=C2=A0 I=20
got over 20,000 errors on the bad stick, and 0 on the good one.=C2=A0 I als=
o=20
swapped the locations on the motherboard, and the bad stick still failed=20
while the good one passed 100%.

> And did you by any chance look at SMART if applicable and
> possibly running a test on the drives.

=C2=A0=C2=A0=C2=A0 Yes. SMART found no errors, but think about it.=C2=A0 Ev=
ery time tar tries=20
to create a directory when untarring that file in that location, the=20
file system croaks when it tries to create a directory. Not when reading=20
and not when writing other than when it creates a directory.=C2=A0 When I=
=20
create the directory manualy, the process quits failing at that point=20
and fails later on during a different directory create.=C2=A0 The array=20
remains intact when reading, and dmesg shows no drive errors.=C2=A0 I've=20
re-synced the array, which reads every byte on all 8 drives without a=20
single mismatch - several times.=C2=A0 To my knowledge, no read has ever=20
failed except after the filesystem goes offline.=C2=A0 I thought reads were=
=20
failing during the CRC checks, but that was a red herring.

> Another test I sometimes do
> when I'm unsure about disks is "cat /dev/sda > /dev/null" (i.e. a
> whole disk read test)

echo repair > /sys/block/md0/md/sync_action reads not one drive, but=20
every byte on all 8 drives.

> and see (dmesg) if any errors show up, unless

=C2=A0=C2=A0=C2=A0 'Nary one, and no mismatches.



> you're willing to run badblocks in a read-write nondestructive mode.
> In my experience the read test or badblocks can be run simultaneously
> with smartctl -t long. But as a start I'd look at smartctl --all
> /dev/sd? and see if there are any bad signs. I hope this helps. Good luck
>
>
> On 07/20/2015 10:41 AM, Leslie Rhorer wrote:
>> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>>>
>>>> I found the problem with md5sum (and probably nfs, as well).
>>>> One of the memory modules in the server was bad.=C2=A0 The problem
>>>> with XFS persists.=C2=A0 Every time tar tried to create the
>>>> directory:
>>>
>>> Now you need to run xfs_repair.
>>
>> I do that every time the array implodes.=C2=A0 It makes no difference.
>> It never mentions cleaning the structure tar says needs cleaning,
>> and the next time I run tar on that file, the filesystem craters.
>>
>> _______________________________________________ xfs mailing list
>> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iQIcBAEBCgAGBQJVrKuzAAoJELsEaSRwbVYrdjoP/3n1W9YtcpdiDoylp6tDYcjF
> vEVz7IWLv2cOky8Lp+0WAZ4Z0WMhcutFzT571H1Vc+jT/UgO25pQHa3yLYTboPuZ
> +tBidVUycs7ZIr9QCZFs2uPQ/7YstamB+F7paCTMKtOJJr5CZLiYX4iyJ9sFmWVY
> UFPAIhyoqD5CFgoaAkwCmk50kNiT0aPM7egizIUVEt14cWuxZxMN0NIJ5b0WJfAk
> qtNQjstVI/xYDgsImm2ZAm19SfOG9ltm2G9zafRr6lR6rRtXjtZX8zEg0l/o9XUw
> OifghjoSup8OCzvX6+4+Soj/3mCKZv4rkBm3exf4YzfQ9eVG6Ktele2rLIs1sl3O
> hUrZUNEl8hYGJeb5gBHFV/TLWDMMwNde/6JiBVy0V8EbDF1lvR4jYpUwThOE0jyL
> ZbzZe4N/B0qvB1OpLDkHrMVm9NPtDkfXdTtM2kRmo5955xtkK09yHF/v64kz7IKc
> 2rM5pOwTR6HWE8RF2j9UujgPjw6nEUuY01TvIMGYzMfkJTI+sVjeDQfwnPG8tzIa
> x4uLa4vTrBD5IaICjAmQiY69qqmt5Vg42G4latZVTYQLelvWQ774mXZfgfT/GtbT
> RKzVwvYowWr/EBhtp7ix/1rWANTFiX0lxOPnRmUFvu8UJnyZhR0/EYbJYy1+jTt7
> O7hZMfAayQBsnVcSK1JC
> =3D3Ubd
> -----END PGP SIGNATURE-----
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


  
------=_Part_545262_260624072.1437397695529
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lvetica Neue-Light, Helvetica Neue Light, Helvetica Neue, Helvetica, Arial,=
 Lucida Grande, Sans-Serif;font-size:13px"><div id=3D"yui_3_16_0_1_14373933=
57643_40462">Hi Leslie,</div><div id=3D"yui_3_16_0_1_1437393357643_40460"><=
br></div><div dir=3D"ltr" id=3D"yui_3_16_0_1_1437393357643_40461">My two ce=
nts here, it appears you are using AMD FX CPU on ASUS Sabertooth motherboar=
d?</div><div id=3D"yui_3_16_0_1_1437393357643_40621" dir=3D"ltr"><br></div>=
<div id=3D"yui_3_16_0_1_1437393357643_40678" dir=3D"ltr">I would strongly s=
uggest you use unbuffered ECC DIMMs in your system.&nbsp; Mcelog will warn =
of ECC errors in your DIMMs.&nbsp; ECC will correct single bit errors and a=
t least detect multi bit errors.</div><div id=3D"yui_3_16_0_1_1437393357643=
_41242" dir=3D"ltr"><br></div><div id=3D"yui_3_16_0_1_1437393357643_41355" =
dir=3D"ltr">I had AMD Opteron servers with registered ECC DIMMs with contin=
uous correctable ECC errors running HPC jobs for up to one month without an=
y crashes until I could schedule down time for DIMM replacement.&nbsp; The =
errors will be flagged either in BMC (service processor) or mcelog.</div><d=
iv id=3D"yui_3_16_0_1_1437393357643_41968" dir=3D"ltr"><br></div><div id=3D=
"yui_3_16_0_1_1437393357643_41967" dir=3D"ltr">All my PC / workstations at =
work place and at home with consumer AMD Althon 64 and AMD Phenom II had un=
buffered ECC DIMMs on ASUS motherboards.&nbsp; I never had any memory error=
s; I know that if there are memory errors I will get notified.</div><div id=
=3D"yui_3_16_0_1_1437393357643_42818" dir=3D"ltr"><br></div><div id=3D"yui_=
3_16_0_1_1437393357643_42819" dir=3D"ltr"><br></div><div id=3D"yui_3_16_0_1=
_1437393357643_42820" dir=3D"ltr">Chin Gim Leong<br></div><div id=3D"yui_3_=
16_0_1_1437393357643_40452"><span></span></div><br>  <div id=3D"yui_3_16_0_=
1_1437393357643_40393" style=3D"font-family: Helvetica Neue-Light, Helvetic=
a Neue Light, Helvetica Neue, Helvetica, Arial, Lucida Grande, Sans-Serif; =
font-size: 13px;"> <div id=3D"yui_3_16_0_1_1437393357643_40392" style=3D"fo=
nt-family: HelveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, =
Sans-Serif; font-size: 16px;"> <div id=3D"yui_3_16_0_1_1437393357643_40391"=
 dir=3D"ltr"> <hr id=3D"yui_3_16_0_1_1437393357643_40505" size=3D"1">  <fon=
t id=3D"yui_3_16_0_1_1437393357643_42082" face=3D"Arial" size=3D"2"> <b><sp=
an style=3D"font-weight:bold;">From:</span></b> Leslie Rhorer &lt;lrhorer@m=
ygrande.net&gt;<br> <b><span style=3D"font-weight: bold;">To:</span></b> Ma=
rtin Papik &lt;mp6058@gmail.com&gt; <br><b><span style=3D"font-weight: bold=
;">Cc:</span></b> xfs@oss.sgi.com <br> <b><span style=3D"font-weight: bold;=
">Sent:</span></b> Monday, 20 July 2015, 16:35<br> <b><span style=3D"font-w=
eight: bold;">Subject:</span></b> Re: XFS File system in trouble<br> </font=
> </div> <div id=3D"yui_3_16_0_1_1437393357643_40503" class=3D"y_msg_contai=
ner"><br>On 7/20/2015 3:05 AM, Martin Papik wrote:<br clear=3D"none">&gt; -=
----BEGIN PGP SIGNED MESSAGE-----<br clear=3D"none">&gt; Hash: SHA512<br cl=
ear=3D"none">&gt;<br clear=3D"none">&gt;<br clear=3D"none">&gt; Since you'v=
e already found one HW related fault, would you consider<br clear=3D"none">=
&gt; booting into memtest for a couple of passes just to be on the safe<br =
clear=3D"none">&gt; side.<br clear=3D"none"><br clear=3D"none">&nbsp;&nbsp;=
&nbsp; I did that after confirming the one stick of memory was bad.&nbsp; T=
wice.&nbsp; I <br clear=3D"none">got over 20,000 errors on the bad stick, a=
nd 0 on the good one.&nbsp; I also <br clear=3D"none">swapped the locations=
 on the motherboard, and the bad stick still failed <br clear=3D"none">whil=
e the good one passed 100%.<br clear=3D"none"><br clear=3D"none">&gt; And d=
id you by any chance look at SMART if applicable and<br clear=3D"none">&gt;=
 possibly running a test on the drives.<br clear=3D"none"><br clear=3D"none=
">&nbsp;&nbsp;&nbsp; Yes. SMART found no errors, but think about it.&nbsp; =
Every time tar tries <br clear=3D"none">to create a directory when untarrin=
g that file in that location, the <br clear=3D"none">file system croaks whe=
n it tries to create a directory. Not when reading <br clear=3D"none">and n=
ot when writing other than when it creates a directory.&nbsp; When I <br cl=
ear=3D"none">create the directory manualy, the process quits failing at tha=
t point <br clear=3D"none">and fails later on during a different directory =
create.&nbsp; The array <br clear=3D"none">remains intact when reading, and=
 dmesg shows no drive errors.&nbsp; I've <br clear=3D"none">re-synced the a=
rray, which reads every byte on all 8 drives without a <br clear=3D"none">s=
ingle mismatch - several times.&nbsp; To my knowledge, no read has ever <br=
 clear=3D"none">failed except after the filesystem goes offline.&nbsp; I th=
ought reads were <br clear=3D"none">failing during the CRC checks, but that=
 was a red herring.<br clear=3D"none"><br clear=3D"none">&gt; Another test =
I sometimes do<br clear=3D"none">&gt; when I'm unsure about disks is "cat /=
dev/sda &gt; /dev/null" (i.e. a<br clear=3D"none">&gt; whole disk read test=
)<br clear=3D"none"><br clear=3D"none">echo repair &gt; /sys/block/md0/md/s=
ync_action reads not one drive, but <br clear=3D"none">every byte on all 8 =
drives.<br clear=3D"none"><br clear=3D"none">&gt; and see (dmesg) if any er=
rors show up, unless<br clear=3D"none"><br clear=3D"none">&nbsp;&nbsp;&nbsp=
; 'Nary one, and no mismatches.<div class=3D"qtdSeparateBR"><br><br></div><=
div class=3D"yqt5741585799" id=3D"yqtfd69759"><br clear=3D"none"><br clear=
=3D"none">&gt; you're willing to run badblocks in a read-write nondestructi=
ve mode.<br clear=3D"none">&gt; In my experience the read test or badblocks=
 can be run simultaneously<br clear=3D"none">&gt; with smartctl -t long. Bu=
t as a start I'd look at smartctl --all<br clear=3D"none">&gt; /dev/sd? and=
 see if there are any bad signs. I hope this helps. Good luck<br clear=3D"n=
one">&gt;<br clear=3D"none">&gt;<br clear=3D"none">&gt; On 07/20/2015 10:41=
 AM, Leslie Rhorer wrote:<br clear=3D"none">&gt;&gt; On 7/19/2015 6:27 PM, =
Dave Chinner wrote:<br clear=3D"none">&gt;&gt;&gt; On Sat, Jul 18, 2015 at =
08:02:50PM -0500, Leslie Rhorer wrote:<br clear=3D"none">&gt;&gt;&gt;&gt;<b=
r clear=3D"none">&gt;&gt;&gt;&gt; I found the problem with md5sum (and prob=
ably nfs, as well).<br clear=3D"none">&gt;&gt;&gt;&gt; One of the memory mo=
dules in the server was bad.&nbsp; The problem<br clear=3D"none">&gt;&gt;&g=
t;&gt; with XFS persists.&nbsp; Every time tar tried to create the<br clear=
=3D"none">&gt;&gt;&gt;&gt; directory:<br clear=3D"none">&gt;&gt;&gt;<br cle=
ar=3D"none">&gt;&gt;&gt; Now you need to run xfs_repair.<br clear=3D"none">=
&gt;&gt;<br clear=3D"none">&gt;&gt; I do that every time the array implodes=
.&nbsp; It makes no difference.<br clear=3D"none">&gt;&gt; It never mention=
s cleaning the structure tar says needs cleaning,<br clear=3D"none">&gt;&gt=
; and the next time I run tar on that file, the filesystem craters.<br clea=
r=3D"none">&gt;&gt;<br clear=3D"none">&gt;&gt; ____________________________=
___________________ xfs mailing list<br clear=3D"none">&gt;&gt; <a shape=3D=
"rect" ymailto=3D"mailto:xfs@oss.sgi.com" href=3D"mailto:xfs@oss.sgi.com">x=
fs@oss.sgi.com</a> <a shape=3D"rect" href=3D"http://oss.sgi.com/mailman/lis=
tinfo/xfs" target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br=
 clear=3D"none">&gt;<br clear=3D"none">&gt; -----BEGIN PGP SIGNATURE-----<b=
r clear=3D"none">&gt; Version: GnuPG v1<br clear=3D"none">&gt;<br clear=3D"=
none">&gt; iQIcBAEBCgAGBQJVrKuzAAoJELsEaSRwbVYrdjoP/3n1W9YtcpdiDoylp6tDYcjF=
<br clear=3D"none">&gt; vEVz7IWLv2cOky8Lp+0WAZ4Z0WMhcutFzT571H1Vc+jT/UgO25p=
QHa3yLYTboPuZ<br clear=3D"none">&gt; +tBidVUycs7ZIr9QCZFs2uPQ/7YstamB+F7paC=
TMKtOJJr5CZLiYX4iyJ9sFmWVY<br clear=3D"none">&gt; UFPAIhyoqD5CFgoaAkwCmk50k=
NiT0aPM7egizIUVEt14cWuxZxMN0NIJ5b0WJfAk<br clear=3D"none">&gt; qtNQjstVI/xY=
DgsImm2ZAm19SfOG9ltm2G9zafRr6lR6rRtXjtZX8zEg0l/o9XUw<br clear=3D"none">&gt;=
 OifghjoSup8OCzvX6+4+Soj/3mCKZv4rkBm3exf4YzfQ9eVG6Ktele2rLIs1sl3O<br clear=
=3D"none">&gt; hUrZUNEl8hYGJeb5gBHFV/TLWDMMwNde/6JiBVy0V8EbDF1lvR4jYpUwThOE=
0jyL<br clear=3D"none">&gt; ZbzZe4N/B0qvB1OpLDkHrMVm9NPtDkfXdTtM2kRmo5955xt=
kK09yHF/v64kz7IKc<br clear=3D"none">&gt; 2rM5pOwTR6HWE8RF2j9UujgPjw6nEUuY01=
TvIMGYzMfkJTI+sVjeDQfwnPG8tzIa<br clear=3D"none">&gt; x4uLa4vTrBD5IaICjAmQi=
Y69qqmt5Vg42G4latZVTYQLelvWQ774mXZfgfT/GtbT<br clear=3D"none">&gt; RKzVwvYo=
wWr/EBhtp7ix/1rWANTFiX0lxOPnRmUFvu8UJnyZhR0/EYbJYy1+jTt7<br clear=3D"none">=
&gt; O7hZMfAayQBsnVcSK1JC<br clear=3D"none">&gt; =3D3Ubd<br clear=3D"none">=
&gt; -----END PGP SIGNATURE-----<br clear=3D"none">&gt;<br clear=3D"none"><=
br clear=3D"none">_______________________________________________<br clear=
=3D"none">xfs mailing list<br clear=3D"none"><a shape=3D"rect" ymailto=3D"m=
ailto:xfs@oss.sgi.com" href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><=
br clear=3D"none"><a shape=3D"rect" href=3D"http://oss.sgi.com/mailman/list=
info/xfs" target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br =
clear=3D"none"></div><br><br></div> </div> </div>  </div></body></html>
------=_Part_545262_260624072.1437397695529--


--===============4433075778157635864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4433075778157635864==--
