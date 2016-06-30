Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB62F7CA1
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 12:39:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62737AC002
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 10:39:49 -0700 (PDT)
Received: from COL004-OMC2S1.hotmail.com (col004-omc2s1.hotmail.com
	[65.55.34.75]) by cuda.sgi.com with ESMTP id guRWqcpXTvLghVDf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 10:39:44 -0700 (PDT)
From: Anthony l <Martinezant2141@live.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Date: Thu, 30 Jun 2016 17:39:41 +0000
Message-ID: <SN1PR05MB231770F5231AF4B51CD9DCF3CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>,
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
In-Reply-To: <dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5445355415217909527=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5445355415217909527==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR05MB231770F5231AF4B51CD9DCF3CC240SN1PR05MB2317namp_"

--_000_SN1PR05MB231770F5231AF4B51CD9DCF3CC240SN1PR05MB2317namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I put that, but I suppose if I am trouble shooting thats not the best idea.=
 That was all I was able to see. I just ran the command and moved all the o=
ut put to a file here is a complete paste of the entire verbosity out.
http://pastebin.com/UW9zRAZ0    (full verbosity out)
Nothing looks like its producing an error which is why I am so confused.

and cat/var/log/dmesg | grep -i st0  (tape connector)
$ cat /var/log/dmesg | grep -i st0
[    1.036623] scsi host0: ata_piix
[   16.613496] st 6:0:0:0: Attached scsi tape st0
[   16.613500] st 6:0:0:0: st0: try direct i/o: yes (alignment 4 B)



$ cat /var/log/dmesg | grep -i scsi
[    0.429954] SCSI subsystem initialized
[    0.827902] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    1.036623] scsi host0: ata_piix
[    1.036699] scsi host1: ata_piix
[    1.192299] scsi host2: ata_piix
[    1.192390] scsi host3: ata_piix
[    1.193129] scsi host4: ata_generic
[    1.193216] scsi host5: ata_generic
[    1.864429] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HE160HJ  0-=
24 PQ: 0 ANSI: 5
[    1.864648] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.867113] scsi 1:0:1:0: CD-ROM            PLDS     DVD+-RW DH-16A6S YD=
12 PQ: 0 ANSI: 5
[    1.882378] sr 1:0:1:0: [sr0] scsi3-mmc drive: 48x/12x writer dvd-ram cd=
/rw xa/form2 cdda tray
[    1.882516] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    1.882574] sr 1:0:1:0: Attached scsi generic sg1 type 5
[    1.898525] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.328020] scsi host6: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[    7.328020]         <Adaptec 29320LP Ultra320 SCSI adapter>
[    7.328020]         aic7901A: Ultra320 Wide Channel A, SCSI Id=3D5, PCI =
33 or 66MHz, 512 SCBs
[    7.329000] scsi target6:0:0: asynchronous
[    7.330396] scsi 6:0:0:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.330404] scsi target6:0:0: Beginning Domain Validation
[    7.334243] scsi target6:0:0: wide asynchronous
[    7.337044] scsi target6:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.349735] scsi target6:0:0: Ending Domain Validation
[    7.352917] scsi target6:0:1: asynchronous
[    7.354313] scsi 6:0:1:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.354319] scsi target6:0:1: Beginning Domain Validation
[    7.358061] scsi target6:0:1: wide asynchronous
[    7.361002] scsi target6:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.373736] scsi target6:0:1: Ending Domain Validation
[    7.376870] scsi target6:0:2: asynchronous
[    7.378273] scsi 6:0:2:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.378279] scsi target6:0:2: Beginning Domain Validation
[    7.381828] scsi target6:0:2: wide asynchronous
[    7.384690] scsi target6:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.397361] scsi target6:0:2: Ending Domain Validation
[    7.400499] scsi target6:0:3: asynchronous
[    7.401901] scsi 6:0:3:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.401907] scsi target6:0:3: Beginning Domain Validation
[    7.405763] scsi target6:0:3: wide asynchronous
[    7.408555] scsi target6:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.421233] scsi target6:0:3: Ending Domain Validation
[    7.424407] scsi target6:0:4: asynchronous
[    7.425819] scsi 6:0:4:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.425825] scsi target6:0:4: Beginning Domain Validation
[    7.429636] scsi target6:0:4: wide asynchronous
[    7.432427] scsi target6:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.445294] scsi target6:0:4: Ending Domain Validation
[    7.448422] scsi target6:0:6: asynchronous
[    7.449838] scsi 6:0:6:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.449845] scsi target6:0:6: Beginning Domain Validation
[    7.453663] scsi target6:0:6: wide asynchronous
[    7.456487] scsi target6:0:6: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.469217] scsi target6:0:6: Ending Domain Validation
[    7.472339] scsi target6:0:7: asynchronous
[    7.473800] scsi 6:0:7:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.473807] scsi target6:0:7: Beginning Domain Validation
[    7.477631] scsi target6:0:7: wide asynchronous
[    7.480481] scsi target6:0:7: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.493222] scsi target6:0:7: Ending Domain Validation
[    7.496351] scsi target6:0:8: asynchronous
[    7.497771] scsi 6:0:8:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.497778] scsi target6:0:8: Beginning Domain Validation
[    7.501488] scsi target6:0:8: wide asynchronous
[    7.504429] scsi target6:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.517155] scsi target6:0:8: Ending Domain Validation
[    7.520280] scsi target6:0:9: asynchronous
[    7.521668] scsi 6:0:9:0: Sequential-Access QUANTUM  SDLT600          2B=
2B PQ: 0 ANSI: 4
[    7.521675] scsi target6:0:9: Beginning Domain Validation
[    7.525473] scsi target6:0:9: wide asynchronous
[    7.528407] scsi target6:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, =
offset 120)
[    7.541143] scsi target6:0:9: Ending Domain Validation
[    7.544314] scsi target6:0:10: asynchronous
[    7.545727] scsi 6:0:10:0: Sequential-Access QUANTUM  SDLT600          2=
B2B PQ: 0 ANSI: 4
[    7.545735] scsi target6:0:10: Beginning Domain Validation
[    7.549442] scsi target6:0:10: wide asynchronous
[    7.552280] scsi target6:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns,=
 offset 120)
[    7.564984] scsi target6:0:10: Ending Domain Validation
[    7.568067] scsi target6:0:11: asynchronous
[    7.569451] scsi 6:0:11:0: Sequential-Access QUANTUM  SDLT600          2=
B2B PQ: 0 ANSI: 4
[    7.569459] scsi target6:0:11: Beginning Domain Validation
[    7.573197] scsi target6:0:11: wide asynchronous
[    7.576047] scsi target6:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns,=
 offset 120)
[    7.588771] scsi target6:0:11: Ending Domain Validation
[    7.591894] scsi target6:0:12: asynchronous
[    7.593326] scsi 6:0:12:0: Sequential-Access QUANTUM  SDLT600          2=
B2B PQ: 0 ANSI: 4
[    7.593334] scsi target6:0:12: Beginning Domain Validation
[    7.597156] scsi target6:0:12: wide asynchronous
[    7.599974] scsi target6:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns,=
 offset 120)
[    7.612720] scsi target6:0:12: Ending Domain Validation
[    7.615848] scsi target6:0:13: asynchronous
[    7.617212] scsi 6:0:13:0: Sequential-Access QUANTUM  SDLT600          2=
B2B PQ: 0 ANSI: 4
[    7.617220] scsi target6:0:13: Beginning Domain Validation
[    7.620943] scsi target6:0:13: wide asynchronous
[    7.623937] scsi target6:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns,=
 offset 120)
[    7.636720] scsi target6:0:13: Ending Domain Validation
[    7.639849] scsi target6:0:14: asynchronous
[    7.641217] scsi 6:0:14:0: Sequential-Access QUANTUM  SDLT600          2=
B2B PQ: 0 ANSI: 4
[    7.641225] scsi target6:0:14: Beginning Domain Validation
[    7.644860] scsi target6:0:14: wide asynchronous
[    7.647710] scsi target6:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns,=
 offset 120)
[    7.660427] scsi target6:0:14: Ending Domain Validation
[    7.663613] scsi target6:0:15: asynchronous
[    7.665008] scsi 6:0:15:0: Sequential-Access QUANTUM  SDLT600          2=
B2B PQ: 0 ANSI: 4
[    7.665016] scsi target6:0:15: Beginning Domain Validation
[    7.668828] scsi target6:0:15: wide asynchronous
[    7.671621] scsi target6:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns,=
 offset 120)
[    7.684311] scsi target6:0:15: Ending Domain Validation
[    7.686630] scsi 6:0:0:0: Attached scsi generic sg2 type 1
[    7.686795] scsi 6:0:1:0: Attached scsi generic sg3 type 1
[    7.686956] scsi 6:0:2:0: Attached scsi generic sg4 type 1
[    7.687115] scsi 6:0:3:0: Attached scsi generic sg5 type 1
[    7.687276] scsi 6:0:4:0: Attached scsi generic sg6 type 1
[    7.687437] scsi 6:0:6:0: Attached scsi generic sg7 type 1
[    7.687598] scsi 6:0:7:0: Attached scsi generic sg8 type 1
[    7.687761] scsi 6:0:8:0: Attached scsi generic sg9 type 1
[    7.687924] scsi 6:0:9:0: Attached scsi generic sg10 type 1
[    7.688089] scsi 6:0:10:0: Attached scsi generic sg11 type 1
[    7.688249] scsi 6:0:11:0: Attached scsi generic sg12 type 1
[    7.688409] scsi 6:0:12:0: Attached scsi generic sg13 type 1
[    7.688569] scsi 6:0:13:0: Attached scsi generic sg14 type 1
[    7.688731] scsi 6:0:14:0: Attached scsi generic sg15 type 1
[    7.688893] scsi 6:0:15:0: Attached scsi generic sg16 type 1
[   16.613496] st 6:0:0:0: Attached scsi tape st0
[   16.617070] st 6:0:1:0: Attached scsi tape st1
[   16.638012] st 6:0:2:0: Attached scsi tape st2
[   16.638789] st 6:0:3:0: Attached scsi tape st3
[   16.639266] st 6:0:4:0: Attached scsi tape st4
[   16.639837] st 6:0:6:0: Attached scsi tape st5
[   16.640425] st 6:0:7:0: Attached scsi tape st6
[   16.640905] st 6:0:8:0: Attached scsi tape st7
[   16.641381] st 6:0:9:0: Attached scsi tape st8
[   16.641998] st 6:0:10:0: Attached scsi tape st9
[   16.642563] st 6:0:11:0: Attached scsi tape st10
[   16.643069] st 6:0:12:0: Attached scsi tape st11
[   16.643545] st 6:0:13:0: Attached scsi tape st12
[   16.644117] st 6:0:14:0: Attached scsi tape st13
[   16.644597] st 6:0:15:0: Attached scsi tape st14

<http://oss.sgi.com/mailman/listinfo/xfs>

--_000_SN1PR05MB231770F5231AF4B51CD9DCF3CC240SN1PR05MB2317namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
<font size=3D"2"><span style=3D"font-size:10pt;">I put that, but I suppose =
if I am trouble shooting thats not the best idea. That was all I was able t=
o see. I just ran the command and moved all the out put to a file here is a=
 complete paste of the entire verbosity
 out. <br>
<a disabled=3D"true" tabindex=3D"-1" title=3D"Ctrl&#43;Click or tap to foll=
ow the link" id=3D"LPlnk580685" href=3D"http://pastebin.com/UW9zRAZ0" class=
=3D"OWAAutoLink">http://pastebin.com/UW9zRAZ0</a>&nbsp;&nbsp;&nbsp; (full v=
erbosity out)<br>
Nothing looks like its producing an error which is why I am so confused. <b=
r>
<br>
and cat/var/log/dmesg | grep -i st0&nbsp; (tape connector) <br>
<div>$ cat /var/log/dmesg | grep -i st0<br>
[&nbsp;&nbsp;&nbsp; 1.036623] scsi host0: ata_piix<br>
[&nbsp;&nbsp; 16.613496] st 6:0:0:0: Attached scsi tape st0<br>
[&nbsp;&nbsp; 16.613500] st 6:0:0:0: st0: try direct i/o: yes (alignment 4 =
B)<br>
</div>
<br>
<br>
<br>
<div>$ cat /var/log/dmesg | grep -i scsi<br>
[&nbsp;&nbsp;&nbsp; 0.429954] SCSI subsystem initialized<br>
[&nbsp;&nbsp;&nbsp; 0.827902] Block layer SCSI generic (bsg) driver version=
 0.4 loaded (major 249)<br>
[&nbsp;&nbsp;&nbsp; 1.036623] scsi host0: ata_piix<br>
[&nbsp;&nbsp;&nbsp; 1.036699] scsi host1: ata_piix<br>
[&nbsp;&nbsp;&nbsp; 1.192299] scsi host2: ata_piix<br>
[&nbsp;&nbsp;&nbsp; 1.192390] scsi host3: ata_piix<br>
[&nbsp;&nbsp;&nbsp; 1.193129] scsi host4: ata_generic<br>
[&nbsp;&nbsp;&nbsp; 1.193216] scsi host5: ata_generic<br>
[&nbsp;&nbsp;&nbsp; 1.864429] scsi 0:0:0:0: Direct-Access&nbsp;&nbsp;&nbsp;=
&nbsp; ATA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SAMSUNG HE160HJ&nbsp; 0-24 PQ: 0 A=
NSI: 5<br>
[&nbsp;&nbsp;&nbsp; 1.864648] sd 0:0:0:0: Attached scsi generic sg0 type 0<=
br>
[&nbsp;&nbsp;&nbsp; 1.867113] scsi 1:0:1:0: CD-ROM&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PLDS&nbsp;&nbsp;&nbsp;&nbsp; DVD&=
#43;-RW DH-16A6S YD12 PQ: 0 ANSI: 5<br>
[&nbsp;&nbsp;&nbsp; 1.882378] sr 1:0:1:0: [sr0] scsi3-mmc drive: 48x/12x wr=
iter dvd-ram cd/rw xa/form2 cdda tray<br>
[&nbsp;&nbsp;&nbsp; 1.882516] sr 1:0:1:0: Attached scsi CD-ROM sr0<br>
[&nbsp;&nbsp;&nbsp; 1.882574] sr 1:0:1:0: Attached scsi generic sg1 type 5<=
br>
[&nbsp;&nbsp;&nbsp; 1.898525] sd 0:0:0:0: [sda] Attached SCSI disk<br>
[&nbsp;&nbsp;&nbsp; 7.328020] scsi host6: Adaptec AIC79XX PCI-X SCSI HBA DR=
IVER, Rev 3.0<br>
[&nbsp;&nbsp;&nbsp; 7.328020]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; &lt;Adaptec 29320LP Ultra320 SCSI adapter&gt;<br>
[&nbsp;&nbsp;&nbsp; 7.328020]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; aic7901A: Ultra320 Wide Channel A, SCSI Id=3D5, PCI 33 or 66MHz, 512 SCB=
s<br>
[&nbsp;&nbsp;&nbsp; 7.329000] scsi target6:0:0: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.330396] scsi 6:0:0:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.330404] scsi target6:0:0: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.334243] scsi target6:0:0: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.337044] scsi target6:0:0: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.349735] scsi target6:0:0: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.352917] scsi target6:0:1: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.354313] scsi 6:0:1:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.354319] scsi target6:0:1: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.358061] scsi target6:0:1: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.361002] scsi target6:0:1: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.373736] scsi target6:0:1: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.376870] scsi target6:0:2: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.378273] scsi 6:0:2:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.378279] scsi target6:0:2: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.381828] scsi target6:0:2: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.384690] scsi target6:0:2: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.397361] scsi target6:0:2: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.400499] scsi target6:0:3: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.401901] scsi 6:0:3:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.401907] scsi target6:0:3: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.405763] scsi target6:0:3: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.408555] scsi target6:0:3: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.421233] scsi target6:0:3: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.424407] scsi target6:0:4: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.425819] scsi 6:0:4:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.425825] scsi target6:0:4: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.429636] scsi target6:0:4: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.432427] scsi target6:0:4: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.445294] scsi target6:0:4: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.448422] scsi target6:0:6: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.449838] scsi 6:0:6:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.449845] scsi target6:0:6: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.453663] scsi target6:0:6: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.456487] scsi target6:0:6: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.469217] scsi target6:0:6: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.472339] scsi target6:0:7: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.473800] scsi 6:0:7:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.473807] scsi target6:0:7: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.477631] scsi target6:0:7: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.480481] scsi target6:0:7: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.493222] scsi target6:0:7: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.496351] scsi target6:0:8: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.497771] scsi 6:0:8:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.497778] scsi target6:0:8: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.501488] scsi target6:0:8: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.504429] scsi target6:0:8: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.517155] scsi target6:0:8: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.520280] scsi target6:0:9: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.521668] scsi 6:0:9:0: Sequential-Access QUANTUM&nbsp;=
 SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 A=
NSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.521675] scsi target6:0:9: Beginning Domain Validation=
<br>
[&nbsp;&nbsp;&nbsp; 7.525473] scsi target6:0:9: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.528407] scsi target6:0:9: FAST-80 WIDE SCSI 160.0 MB/=
s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.541143] scsi target6:0:9: Ending Domain Validation<br=
>
[&nbsp;&nbsp;&nbsp; 7.544314] scsi target6:0:10: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.545727] scsi 6:0:10:0: Sequential-Access QUANTUM&nbsp=
; SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 =
ANSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.545735] scsi target6:0:10: Beginning Domain Validatio=
n<br>
[&nbsp;&nbsp;&nbsp; 7.549442] scsi target6:0:10: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.552280] scsi target6:0:10: FAST-80 WIDE SCSI 160.0 MB=
/s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.564984] scsi target6:0:10: Ending Domain Validation<b=
r>
[&nbsp;&nbsp;&nbsp; 7.568067] scsi target6:0:11: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.569451] scsi 6:0:11:0: Sequential-Access QUANTUM&nbsp=
; SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 =
ANSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.569459] scsi target6:0:11: Beginning Domain Validatio=
n<br>
[&nbsp;&nbsp;&nbsp; 7.573197] scsi target6:0:11: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.576047] scsi target6:0:11: FAST-80 WIDE SCSI 160.0 MB=
/s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.588771] scsi target6:0:11: Ending Domain Validation<b=
r>
[&nbsp;&nbsp;&nbsp; 7.591894] scsi target6:0:12: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.593326] scsi 6:0:12:0: Sequential-Access QUANTUM&nbsp=
; SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 =
ANSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.593334] scsi target6:0:12: Beginning Domain Validatio=
n<br>
[&nbsp;&nbsp;&nbsp; 7.597156] scsi target6:0:12: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.599974] scsi target6:0:12: FAST-80 WIDE SCSI 160.0 MB=
/s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.612720] scsi target6:0:12: Ending Domain Validation<b=
r>
[&nbsp;&nbsp;&nbsp; 7.615848] scsi target6:0:13: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.617212] scsi 6:0:13:0: Sequential-Access QUANTUM&nbsp=
; SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 =
ANSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.617220] scsi target6:0:13: Beginning Domain Validatio=
n<br>
[&nbsp;&nbsp;&nbsp; 7.620943] scsi target6:0:13: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.623937] scsi target6:0:13: FAST-80 WIDE SCSI 160.0 MB=
/s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.636720] scsi target6:0:13: Ending Domain Validation<b=
r>
[&nbsp;&nbsp;&nbsp; 7.639849] scsi target6:0:14: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.641217] scsi 6:0:14:0: Sequential-Access QUANTUM&nbsp=
; SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 =
ANSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.641225] scsi target6:0:14: Beginning Domain Validatio=
n<br>
[&nbsp;&nbsp;&nbsp; 7.644860] scsi target6:0:14: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.647710] scsi target6:0:14: FAST-80 WIDE SCSI 160.0 MB=
/s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.660427] scsi target6:0:14: Ending Domain Validation<b=
r>
[&nbsp;&nbsp;&nbsp; 7.663613] scsi target6:0:15: asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.665008] scsi 6:0:15:0: Sequential-Access QUANTUM&nbsp=
; SDLT600&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2B2B PQ: 0 =
ANSI: 4<br>
[&nbsp;&nbsp;&nbsp; 7.665016] scsi target6:0:15: Beginning Domain Validatio=
n<br>
[&nbsp;&nbsp;&nbsp; 7.668828] scsi target6:0:15: wide asynchronous<br>
[&nbsp;&nbsp;&nbsp; 7.671621] scsi target6:0:15: FAST-80 WIDE SCSI 160.0 MB=
/s DT (12.5 ns, offset 120)<br>
[&nbsp;&nbsp;&nbsp; 7.684311] scsi target6:0:15: Ending Domain Validation<b=
r>
[&nbsp;&nbsp;&nbsp; 7.686630] scsi 6:0:0:0: Attached scsi generic sg2 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.686795] scsi 6:0:1:0: Attached scsi generic sg3 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.686956] scsi 6:0:2:0: Attached scsi generic sg4 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.687115] scsi 6:0:3:0: Attached scsi generic sg5 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.687276] scsi 6:0:4:0: Attached scsi generic sg6 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.687437] scsi 6:0:6:0: Attached scsi generic sg7 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.687598] scsi 6:0:7:0: Attached scsi generic sg8 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.687761] scsi 6:0:8:0: Attached scsi generic sg9 type =
1<br>
[&nbsp;&nbsp;&nbsp; 7.687924] scsi 6:0:9:0: Attached scsi generic sg10 type=
 1<br>
[&nbsp;&nbsp;&nbsp; 7.688089] scsi 6:0:10:0: Attached scsi generic sg11 typ=
e 1<br>
[&nbsp;&nbsp;&nbsp; 7.688249] scsi 6:0:11:0: Attached scsi generic sg12 typ=
e 1<br>
[&nbsp;&nbsp;&nbsp; 7.688409] scsi 6:0:12:0: Attached scsi generic sg13 typ=
e 1<br>
[&nbsp;&nbsp;&nbsp; 7.688569] scsi 6:0:13:0: Attached scsi generic sg14 typ=
e 1<br>
[&nbsp;&nbsp;&nbsp; 7.688731] scsi 6:0:14:0: Attached scsi generic sg15 typ=
e 1<br>
[&nbsp;&nbsp;&nbsp; 7.688893] scsi 6:0:15:0: Attached scsi generic sg16 typ=
e 1<br>
[&nbsp;&nbsp; 16.613496] st 6:0:0:0: Attached scsi tape st0<br>
[&nbsp;&nbsp; 16.617070] st 6:0:1:0: Attached scsi tape st1<br>
[&nbsp;&nbsp; 16.638012] st 6:0:2:0: Attached scsi tape st2<br>
[&nbsp;&nbsp; 16.638789] st 6:0:3:0: Attached scsi tape st3<br>
[&nbsp;&nbsp; 16.639266] st 6:0:4:0: Attached scsi tape st4<br>
[&nbsp;&nbsp; 16.639837] st 6:0:6:0: Attached scsi tape st5<br>
[&nbsp;&nbsp; 16.640425] st 6:0:7:0: Attached scsi tape st6<br>
[&nbsp;&nbsp; 16.640905] st 6:0:8:0: Attached scsi tape st7<br>
[&nbsp;&nbsp; 16.641381] st 6:0:9:0: Attached scsi tape st8<br>
[&nbsp;&nbsp; 16.641998] st 6:0:10:0: Attached scsi tape st9<br>
[&nbsp;&nbsp; 16.642563] st 6:0:11:0: Attached scsi tape st10<br>
[&nbsp;&nbsp; 16.643069] st 6:0:12:0: Attached scsi tape st11<br>
[&nbsp;&nbsp; 16.643545] st 6:0:13:0: Attached scsi tape st12<br>
[&nbsp;&nbsp; 16.644117] st 6:0:14:0: Attached scsi tape st13<br>
[&nbsp;&nbsp; 16.644597] st 6:0:15:0: Attached scsi tape st14<br>
</div>
<br>
</span></font>
<div style=3D"color: rgb(0, 0, 0);"><font size=3D"2"><span style=3D"font-si=
ze:10pt;">
<div class=3D"PlainText"><a disabled=3D"true" tabindex=3D"-1" href=3D"http:=
//oss.sgi.com/mailman/listinfo/xfs"></a><br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_SN1PR05MB231770F5231AF4B51CD9DCF3CC240SN1PR05MB2317namp_--


--===============5445355415217909527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5445355415217909527==--
