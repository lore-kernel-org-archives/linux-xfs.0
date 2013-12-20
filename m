Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7226C29DF8
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 08:26:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D70F30407A
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 06:26:31 -0800 (PST)
Received: from mx2.noc1.sys-tech.net (mx2.noc1.sys-tech.net [199.21.216.50])
	by cuda.sgi.com with ESMTP id 9N0fTyvqqWdfA1Tl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Dec 2013 06:26:28 -0800 (PST)
From: Marc Boivin <marc.boivin@libeo.com>
Subject: XFS segfaulting on xfs_repair
Message-Id: <5C03211A-BF4B-485A-97F1-9CE00DACF09D@libeo.com>
Date: Fri, 20 Dec 2013 09:26:26 -0500
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6205454791084932791=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6205454791084932791==
Content-Type: multipart/alternative; boundary="Apple-Mail=_D1AA51C4-9870-42FC-B63E-F4DFFF9D2CB0"


--Apple-Mail=_D1AA51C4-9870-42FC-B63E-F4DFFF9D2CB0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hi,
    We=92ve been having a hard time with our ifs partition but managed =
to get it almost back to working conditions. To give you a bit of =
context we have a LVM sitting on top of 3 RAID 5. The partition is =
encrypted. We had issues with RAID degradation but now the RAIDs are =
healthy.=20

We ran xfs_repair quite a few times (5 if I=92m not mistaken). We are =
stuck with an error:=20

*** glibc detected *** xfs_repair: malloc(): smallbin double linked list =
corrupted: 0x00007f5dc7642570 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/x86_64-linux-gnu/libc.so.6(+0x76d76)[0x7f6149f96d76]
/lib/x86_64-linux-gnu/libc.so.6(+0x7a658)[0x7f6149f9a658]
/lib/x86_64-linux-gnu/libc.so.6(__libc_malloc+0x70)[0x7f6149f9bb90]
xfs_repair[0x42da83]
xfs_repair[0x42db16]
xfs_repair[0x42dd62]
xfs_repair[0x430b74]
xfs_repair[0x4492de]
xfs_repair[0x44e634]
xfs_repair[0x451976]
xfs_repair[0x44c4ba]
xfs_repair[0x41f126]
xfs_repair[0x421e55]
xfs_repair[0x4039d8]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xfd)[0x7f6149f3eead]
xfs_repair[0x403ff9]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00400000-0047e000 r-xp 00000000 fe:00 1703949                            =
/sbin/xfs_repair
0067d000-00680000 rw-p 0007d000 fe:00 1703949                            =
/sbin/xfs_repair
00680000-00681000 rw-p 00000000 00:00 0
01f02000-dbafa000 rw-p 00000000 00:00 0                                  =
[heap]
7f59bc000000-7f59c03e9000 rw-p 00000000 00:00 0
7f59c03e9000-7f59c4000000 ---p 00000000 00:00 0
7f59c4000000-7f59c8000000 rw-p 00000000 00:00 0
7f59c8000000-7f59c9103000 rw-p 00000000 00:00 0
7f59c9103000-7f59cc000000 ---p 00000000 00:00 0
7f59cc000000-7f59d4000000 rw-p 00000000 00:00 0
7f59d4000000-7f59dc000000 rw-p 00000000 00:00 0
7f59dc000000-7f59e4000000 rw-p 00000000 00:00 0
7f59e4000000-7f59e8000000 rw-p 00000000 00:00 0
7f59e8000000-7f59ec000000 rw-p 00000000 00:00 0
7f59ec000000-7f59f4000000 rw-p 00000000 00:00 0
7f59f4000000-7f59f7fff000 rw-p 00000000 00:00 0
7f59f7fff000-7f59f8000000 ---p 00000000 00:00 0
7f59f8000000-7f59f91ca000 rw-p 00000000 00:00 0
7f59f91ca000-7f59fc000000 ---p 00000000 00:00 0
7f59fc000000-7f59fe063000 rw-p 00000000 00:00 0
7f59fe063000-7f5a00000000 ---p 00000000 00:00 0
7f5a00000000-7f5a04000000 rw-p 00000000 00:00 0
7f5a04000000-7f5a0c000000 rw-p 00000000 00:00 0
7f5a0c000000-7f5a14000000 rw-p 00000000 00:00 0
7f5a14000000-7f5a14b97000 rw-p 00000000 00:00 0
7f5a14b97000-7f5a18000000 ---p 00000000 00:00 0
7f5a18000000-7f5a1c000000 rw-p 00000000 00:00 0
7f5a1c000000-7f5a24000000 rw-p 00000000 00:00 0
7f5a24000000-7f5a28000000 rw-p 00000000 00:00 0
7f5a2c000000-7f5a34000000 rw-p 00000000 00:00 0
7f5a34000000-7f5a3c000000 rw-p 00000000 00:00 0
7f5a40000000-7f5a48000000 rw-p 00000000 00:00 0
7f5a48000000-7f5a50000000 rw-p 00000000 00:00 0
7f5a50000000-7f5a54809000 rw-p 00000000 00:00 0
7f5a54809000-7f5a58000000 ---p 00000000 00:00 0
7f5a58000000-7f5a68000000 rw-p 00000000 00:00 0
7f5a68000000-7f5a7c000000 rw-p 00000000 00:00 0
7f5a80000000-7f5a84000000 rw-p 00000000 00:00 0
7f5a84000000-7f5a8c000000 rw-p 00000000 00:00 0
7f5a8c000000-7f5a94000000 rw-p 00000000 00:00 0
7f5a94000000-7f5a9c000000 rw-p 00000000 00:00 0
7f5aa0000000-7f5aa4000000 rw-p 00000000 00:00 0
7f5aa4000000-7f5aa8000000 rw-p 00000000 00:00 0
7f5aac000000-7f5aaffff000 rw-p 00000000 00:00 0
7f5aaffff000-7f5ab0000000 ---p 00000000 00:00 0
7f5ab0000000-7f5ab4000000 rw-p 00000000 00:00 0
7f5ab4000000-7f5abc000000 rw-p 00000000 00:00 0
7f5abc000000-7f5ac4000000 rw-p 00000000 00:00 0
7f5ac4000000-7f5acc000000 rw-p 00000000 00:00 0
7f5acc000000-7f5acffff000 rw-p 00000000 00:00 0
7f5acffff000-7f5ad0000000 ---p 00000000 00:00 0
7f5ad0000000-7f5ad4000000 rw-p 00000000 00:00 0
7f5ad4000000-7f5adc000000 rw-p 00000000 00:00 0
7f5adc000000-7f5ae4000000 rw-p 00000000 00:00 0
7f5ae8000000-7f5aec000000 rw-p 00000000 00:00 0
7f5aec000000-7f5af0000000 rw-p 00000000 00:00 0
7f5af4000000-7f5af9318000 rw-p 00000000 00:00 0
7f5af9318000-7f5afc000000 ---p 00000000 00:00 0
7f5afc000000-7f5b04000000 rw-p 00000000 00:00 0
7f5b04000000-7f5b0c000000 rw-p 00000000 00:00 0
7f5b0c000000-7f5b14000000 rw-p 00000000 00:00 0
7f5b14000000-7f5b1c000000 rw-p 00000000 00:00 0
7f5b1c000000-7f5b24000000 rw-p 00000000 00:00 0
7f5b24000000-7f5b27fff000 rw-p 00000000 00:00 0
7f5b27fff000-7f5b28000000 ---p 00000000 00:00 0
7f5b28000000-7f5b2bfff000 rw-p 00000000 00:00 0
7f5b2bfff000-7f5b2c000000 ---p 00000000 00:00 0
7f5b2c000000-7f5b30a33000 rw-p 00000000 00:00 0
7f5b30a33000-7f5b34000000 ---p 00000000 00:00 0
7f5b34000000-7f5b3c000000 rw-p 00000000 00:00 0
7f5b3c000000-7f5b44000000 rw-p 00000000 00:00 0
7f5b44000000-7f5b4c000000 rw-p 00000000 00:00 0
7f5b4c000000-7f5b54000000 rw-p 00000000 00:00 0
7f5b54000000-7f5b5c000000 rw-p 00000000 00:00 0
7f5b5c000000-7f5b64000000 rw-p 00000000 00:00 0
7f5b64000000-7f5b68000000 rw-p 00000000 00:00 0
7f5b68000000-7f5b6c000000 rw-p 00000000 00:00 0
7f5b6c000000-7f5b74000000 rw-p 00000000 00:00 0
7f5b74000000-7f5b7c000000 rw-p 00000000 00:00 0
7f5b7c000000-7f5b80000000 rw-p 00000000 00:00 0
7f5b84000000-7f5b8c000000 rw-p 00000000 00:00 0
7f5b8c000000-7f5b94000000 rw-p 00000000 00:00 0
7f5b94000000-7f5b9c000000 rw-p 00000000 00:00 0
7f5b9c000000-7f5ba4000000 rw-p 00000000 00:00 0
7f5ba4000000-7f5bac000000 rw-p 00000000 00:00 0
7f5bac000000-7f5bb4000000 rw-p 00000000 00:00 0
7f5bb4000000-7f5bbc000000 rw-p 00000000 00:00 0
7f5bbc000000-7f5bc4000000 rw-p 00000000 00:00 0
7f5bc4000000-7f5bcbfff000 rw-p 00000000 00:00 0
7f5bcbfff000-7f5bcc000000 ---p 00000000 00:00 0
7f5bcc000000-7f5bd4000000 rw-p 00000000 00:00 0
7f5bd4000000-7f5bdc000000 rw-p 00000000 00:00 0
...
7f5c04000000-7f5c08000000 rw-p 00000000 00:00 0
7f5c08000000-7f5c0bffe000 rw-p 00000000 00:00 0
7f5c0bffe000-7f5c0c000000 ---p 00000000 00:00 0
7f5c0c000000-7f5c10000000 rw-p 00000000 00:00 0
7f5c10000000-7f5c14000000 rw-p 00000000 00:00 0
7f5c14000000-7f5c17fff000 rw-p 00000000 00:00 0
7f5c17fff000-7f5c18000000 ---p 00000000 00:00 0
7f5c18000000-7f5c1c000000 rw-p 00000000 00:00 0
7f5c1c000000-7f5c22964000 rw-p 00000000 00:00 0
7f5c22964000-7f5c24000000 ---p 00000000 00:00 0
7f5c24000000-7f5c2c000000 rw-p 00000000 00:00 0
7f5c2c000000-7f5c34000000 rw-p 00000000 00:00 0
7f5c34000000-7f5c3c000000 rw-p 00000000 00:00 0
7f5c3c000000-7f5c44000000 rw-p 00000000 00:00 0
7f5c44000000-7f5c4c000000 rw-p 00000000 00:00 0
7f5c4c000000-7f5c54000000 rw-p 00000000 00:00 0
7f5c54000000-7f5c5c000000 rw-p 00000000 00:00 0
7f5c5c000000-7f5c64000000 rw-p 00000000 00:00 0
7f5c64000000-7f5c68000000 rw-p 00000000 00:00 0
7f5c68000000-7f5c6c000000 rw-p 00000000 00:00 0
7f5c6c000000-7f5c74000000 rw-p 00000000 00:00 0
7f5c74000000-7f5c78000000 rw-p 00000000 00:00 0
7f5c78000000-7f5c7c000000 rw-p 00000000 00:00 0
7f5c7c000000-7f5c83fff000 rw-p 00000000 00:00 0
7f5c83fff000-7f5c84000000 ---p 00000000 00:00 0
7f5c84000000-7f5c8c000000 rw-p 00000000 00:00 0
7f5c8c000000-7f5c94000000 rw-p 00000000 00:00 0
7f5c94000000-7f5c98000000 rw-p 00000000 00:00 0
7f5c98000000-7f5c9c000000 rw-p 00000000 00:00 0
7f5c9c000000-7f5ca4000000 rw-p 00000000 00:00 0
7f5ca4000000-7f5cac000000 rw-p 00000000 00:00 0
7f5cac000000-7f5cb4000000 rw-p 00000000 00:00 0
7f5cb4000000-7f5cbc000000 rw-p 00000000 00:00 0
7f5cbc000000-7f5cc363d000 rw-p 00000000 00:00 0
7f5cc363d000-7f5cc4000000 ---p 00000000 00:00 0
7f5cc4000000-7f5ccc000000 rw-p 00000000 00:00 0
7f5ccc000000-7f5cd4000000 rw-p 00000000 00:00 0
7f5cd4000000-7f5cd8000000 rw-p 00000000 00:00 0
7f5cd8000000-7f5cdc000000 rw-p 00000000 00:00 0 Abandon

Anything we can do?=20


Regards,

Marc

Marc Boivin
Directeur Technologique

418 520-0739, poste 169
marc.boivin@libeo.com

Lib=E9o / Web et applications libres
6700, boulevard Pierre-Bertrand, bureau 209
Qu=E9bec (Qu=E9bec)  G2J 0B4
S. F. : 1 877 969-8324
T=E9l=E9c. : 418 520-4554

www.libeo.com
Aimez-nous sur Facebook : www.facebook.com/libeocom







--Apple-Mail=_D1AA51C4-9870-42FC-B63E-F4DFFF9D2CB0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;">Hi,<div>&nbsp; &nbsp; We=92ve been having a hard =
time with our ifs partition but managed to get it almost back to working =
conditions. To give you a bit of context we have a LVM sitting on top of =
3 RAID 5. The partition is encrypted. We had issues with RAID =
degradation but now the RAIDs are =
healthy.&nbsp;</div><div><br></div><div>We ran xfs_repair quite a few =
times (5 if I=92m not mistaken). We are stuck with an =
error:&nbsp;</div><div><br></div><div><span style=3D"background-color: =
rgb(255, 255, 255);">*** glibc detected *** xfs_repair: malloc(): =
smallbin double linked list corrupted: 0x00007f5dc7642570 =
***</span><br><span style=3D"background-color: rgb(255, 255, =
255);">=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D</span>=
<br><span style=3D"background-color: rgb(255, 255, =
255);">/lib/x86_64-linux-gnu/libc.so.6(+0x76d76)[0x7f6149f96d76]</span><br=
><span style=3D"background-color: rgb(255, 255, =
255);">/lib/x86_64-linux-gnu/libc.so.6(+0x7a658)[0x7f6149f9a658]</span><br=
><span style=3D"background-color: rgb(255, 255, =
255);">/lib/x86_64-linux-gnu/libc.so.6(__libc_malloc+0x70)[0x7f6149f9bb90]=
</span><br><span style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x42da83]</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">xfs_repair[0x42db16]</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x42dd62]</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">xfs_repair[0x430b74]</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x4492de]</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">xfs_repair[0x44e634]</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x451976]</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">xfs_repair[0x44c4ba]</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x41f126]</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">xfs_repair[0x421e55]</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x4039d8]</span><br><span style=3D"background-color: =
rgb(255, 255, =
255);">/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xfd)[0x7f6149f3e=
ead]</span><br><span style=3D"background-color: rgb(255, 255, =
255);">xfs_repair[0x403ff9]</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">=3D=3D=3D=3D=3D=3D=3D Memory map: =
=3D=3D=3D=3D=3D=3D=3D=3D</span><br><span style=3D"background-color: =
rgb(255, 255, 255);">00400000-0047e000 r-xp 00000000 fe:00 =
1703949&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; /sbin/xfs_repair</span><br><span =
style=3D"background-color: rgb(255, 255, 255);">0067d000-00680000 rw-p =
0007d000 fe:00 =
1703949&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; /sbin/xfs_repair</span><br><span =
style=3D"background-color: rgb(255, 255, 255);">00680000-00681000 rw-p =
00000000 00:00 0</span><br><span style=3D"background-color: rgb(255, =
255, 255);">01f02000-dbafa000 rw-p 00000000 00:00 =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
[heap]</span><br><span style=3D"background-color: rgb(255, 255, =
255);">7f59bc000000-7f59c03e9000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59c03e9000-7f59c4000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59c4000000-7f59c8000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59c8000000-7f59c9103000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59c9103000-7f59cc000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59cc000000-7f59d4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59d4000000-7f59dc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59dc000000-7f59e4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59e4000000-7f59e8000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59e8000000-7f59ec000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59ec000000-7f59f4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59f4000000-7f59f7fff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59f7fff000-7f59f8000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59f8000000-7f59f91ca000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59f91ca000-7f59fc000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59fc000000-7f59fe063000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f59fe063000-7f5a00000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a00000000-7f5a04000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a04000000-7f5a0c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a0c000000-7f5a14000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a14000000-7f5a14b97000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a14b97000-7f5a18000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a18000000-7f5a1c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a1c000000-7f5a24000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a24000000-7f5a28000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a2c000000-7f5a34000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a34000000-7f5a3c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a40000000-7f5a48000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a48000000-7f5a50000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a50000000-7f5a54809000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a54809000-7f5a58000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a58000000-7f5a68000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a68000000-7f5a7c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a80000000-7f5a84000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a84000000-7f5a8c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a8c000000-7f5a94000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5a94000000-7f5a9c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5aa0000000-7f5aa4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5aa4000000-7f5aa8000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5aac000000-7f5aaffff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5aaffff000-7f5ab0000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ab0000000-7f5ab4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ab4000000-7f5abc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5abc000000-7f5ac4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ac4000000-7f5acc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5acc000000-7f5acffff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5acffff000-7f5ad0000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ad0000000-7f5ad4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ad4000000-7f5adc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5adc000000-7f5ae4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ae8000000-7f5aec000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5aec000000-7f5af0000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5af4000000-7f5af9318000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5af9318000-7f5afc000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5afc000000-7f5b04000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b04000000-7f5b0c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b0c000000-7f5b14000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b14000000-7f5b1c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b1c000000-7f5b24000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b24000000-7f5b27fff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b27fff000-7f5b28000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b28000000-7f5b2bfff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b2bfff000-7f5b2c000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b2c000000-7f5b30a33000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b30a33000-7f5b34000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b34000000-7f5b3c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b3c000000-7f5b44000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b44000000-7f5b4c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b4c000000-7f5b54000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b54000000-7f5b5c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b5c000000-7f5b64000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b64000000-7f5b68000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b68000000-7f5b6c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b6c000000-7f5b74000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b74000000-7f5b7c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b7c000000-7f5b80000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b84000000-7f5b8c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b8c000000-7f5b94000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b94000000-7f5b9c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5b9c000000-7f5ba4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ba4000000-7f5bac000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bac000000-7f5bb4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bb4000000-7f5bbc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bbc000000-7f5bc4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bc4000000-7f5bcbfff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bcbfff000-7f5bcc000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bcc000000-7f5bd4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5bd4000000-7f5bdc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, 255);">...</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c04000000-7f5c08000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c08000000-7f5c0bffe000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c0bffe000-7f5c0c000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c0c000000-7f5c10000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c10000000-7f5c14000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c14000000-7f5c17fff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c17fff000-7f5c18000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c18000000-7f5c1c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c1c000000-7f5c22964000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c22964000-7f5c24000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c24000000-7f5c2c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c2c000000-7f5c34000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c34000000-7f5c3c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c3c000000-7f5c44000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c44000000-7f5c4c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c4c000000-7f5c54000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c54000000-7f5c5c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c5c000000-7f5c64000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c64000000-7f5c68000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c68000000-7f5c6c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c6c000000-7f5c74000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c74000000-7f5c78000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c78000000-7f5c7c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c7c000000-7f5c83fff000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c83fff000-7f5c84000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c84000000-7f5c8c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c8c000000-7f5c94000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c94000000-7f5c98000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c98000000-7f5c9c000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5c9c000000-7f5ca4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ca4000000-7f5cac000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cac000000-7f5cb4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cb4000000-7f5cbc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cbc000000-7f5cc363d000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cc363d000-7f5cc4000000 ---p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cc4000000-7f5ccc000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5ccc000000-7f5cd4000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cd4000000-7f5cd8000000 rw-p 00000000 00:00 0</span><br><span =
style=3D"background-color: rgb(255, 255, =
255);">7f5cd8000000-7f5cdc000000 rw-p 00000000 00:00 0 =
Abandon</span></div><div><span style=3D"background-color: rgb(255, 255, =
255);"><br></span></div><div>Anything we can =
do?&nbsp;</div><div><br></div><div><br></div><div>Regards,</div><div><br><=
/div><div>Marc</div><div><br><div apple-content-edited=3D"true">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
border-spacing: 0px;"><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px;  "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-variant: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: =
0px; -webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-variant: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><span class=3D"Apple-style-span" =
style=3D"font-weight: normal; font-style: normal; color: rgb(121, 173, =
54); font-family: Helvetica, sans-serif; font-size: 16px; "><b>Marc =
Boivin</b></span><div><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-variant: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: =
0px; -webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: 13px; ">Directeur =
Technologique</span></div><div style=3D"font-weight: normal; font-style: =
normal; font-family: Helvetica;  "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-style: normal; font-variant: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><span class=3D"Apple-style-span" =
style=3D"font-family: Helvetica, sans-serif; font-size: 16px; =
"><br></span></span></div></div></span><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-variant: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: =
0px; -webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><div style=3D"font-style: normal; font-family: =
Helvetica;  font-weight: normal; color: rgb(0, 0, 0); ">418 520-0739, =
poste 169</div><div style=3D"color: rgb(0, 0, 0); font-style: normal; =
font-family: Helvetica;  font-weight: normal; "><a =
href=3D"mailto:marc.boivin@libeo.com"><font class=3D"Apple-style-span" =
color=3D"#000000">marc.boivin@libeo.com</font></a></div></div></span><span=
 class=3D"Apple-style-span" style=3D"color: rgb(0, 0, 0); font-style: =
normal; font-family: Calibri, sans-serif; font-size: 15px; "><b><span =
style=3D"font-size: 13.5pt; font-family: Helvetica, sans-serif; color: =
rgb(121, 173, 54); "><div><span class=3D"Apple-style-span" =
style=3D"font-family: Calibri, sans-serif; font-size: 15px; "><b><span =
style=3D"font-size: 13.5pt; font-family: Helvetica, sans-serif; color: =
rgb(121, 173, 54); "><br></span></b></span></div>Lib=E9o</span></b><span =
style=3D"font-size: 12pt; font-family: 'Times New Roman', serif; =
">&nbsp;</span><b><span style=3D"font-size: 12pt; font-family: =
Helvetica, sans-serif; color: rgb(79, 79, 79); ">/ Web et applications =
libres</span></b></span><div style=3D"color: rgb(0, 0, 0); font-style: =
normal; font-family: Helvetica;  "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-style: normal; font-variant: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><span class=3D"Apple-style-span" =
style=3D"font-family: Helvetica, sans-serif; font-size: 16px; ">6700, =
boulevard Pierre-Bertrand, bureau 209</span></span></div><div =
style=3D"color: rgb(0, 0, 0); font-style: normal; font-family: =
Helvetica;  "><span class=3D"Apple-style-span" style=3D"border-collapse: =
separate; font-style: normal; font-variant: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: -webkit-auto; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><span class=3D"Apple-style-span" =
style=3D"font-family: Helvetica, sans-serif; font-size: 16px; ">Qu=E9bec =
(Qu=E9bec)&nbsp;&nbsp;G2J 0B4</span></span></div><div style=3D"color: =
rgb(0, 0, 0); font-style: normal; font-family: Helvetica; font-size: =
medium; "><span class=3D"Apple-style-span" style=3D"font-family: =
Helvetica, sans-serif; font-size: 16px; ">S. F. : 1 877 =
969-8324</span></div><div style=3D"color: rgb(0, 0, 0); font-style: =
normal; font-family: Helvetica;  "><span class=3D"Apple-style-span" =
style=3D"font-family: Helvetica, sans-serif; font-size: 16px; ">T=E9l=E9c.=
 : 418 520-4554</span></div><div style=3D"color: rgb(0, 0, 0); =
font-style: normal; font-family: Helvetica;  "><span =
class=3D"Apple-style-span" style=3D"font-family: 'Times New Roman', =
serif; font-size: 16px; "><br></span></div><div style=3D"color: rgb(0, =
0, 0); font-style: normal; font-family: Helvetica;  "><span =
class=3D"Apple-style-span" style=3D"font-family: 'Times New Roman', =
serif; font-size: 16px; "><span style=3D"text-decoration: underline; =
font-family: Helvetica, sans-serif; "><font class=3D"Apple-style-span" =
style=3D"text-decoration: underline; "><a href=3D"http://www.libeo.com/" =
style=3D"text-decoration: underline; =
">www.libeo.com</a></font></span></span></div><div style=3D"color: =
rgb(0, 0, 0); font-style: normal; font-family: Helvetica; font-size: =
medium; "><span style=3D"font-weight: normal; font-size: 10pt; =
font-family: Helvetica, sans-serif; color: black; ">Aimez-nous =
sur&nbsp;<b>Facebook</b></span><span style=3D"font-weight: normal; =
font-size: 12pt; font-family: 'Times New Roman', serif; color: black; =
">&nbsp;</span><span style=3D"font-weight: normal; font-size: 10pt; =
font-family: Helvetica, sans-serif; color: black; ">:&nbsp;</span><span =
style=3D"color: rgb(0, 0, 0); font-weight: normal; font-size: 12pt; =
font-family: 'Times New Roman', serif; "><a =
href=3D"http://www.facebook.com/libeocom" style=3D"color: blue; =
text-decoration: underline; "><span style=3D"font-size: 10pt; =
font-family: Helvetica, sans-serif; color: black; =
">www.facebook.com/libeocom</span></a></span></div><div style=3D"color: =
rgb(0, 0, 0); font-style: normal; font-family: Helvetica; font-size: =
medium; "><br class=3D"Apple-interchange-newline"></div></div></span><br =
class=3D"Apple-interchange-newline"></div></span><br =
class=3D"Apple-interchange-newline"></div></span><br =
class=3D"Apple-interchange-newline"></span><br =
class=3D"Apple-interchange-newline">
</div>
<br></div></body></html>=

--Apple-Mail=_D1AA51C4-9870-42FC-B63E-F4DFFF9D2CB0--


--===============6205454791084932791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6205454791084932791==--
