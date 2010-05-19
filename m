Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JBO1Pk124936 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:24:02 -0500
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF50C1DF30E8
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:26:17 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com
	[216.241.235.117]) by cuda.sgi.com with ESMTP id
	m4l5Z2lJDAp8x3uh for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 04:26:17 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01CAF746.1730419D"
Subject: RE: xfs crash
Date: Wed, 19 May 2010 04:26:14 -0700
Message-ID: <BE430C874DBA6841A75E65151DCC6E1C0407667D@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <BE430C874DBA6841A75E65151DCC6E1C04076679@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
	<20100518060239.GD2150@dastard>
From: "Jabir M" <Jabir_M@pmc-sierra.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01CAF746.1730419D
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable




-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]
Sent: Tue 5/18/2010 11:32 AM
To: Jabir M
Cc: xfs@oss.sgi.com
Subject: Re: xfs crash
=20
On Mon, May 17, 2010 at 09:45:23PM -0700, Jabir M wrote:
>=20
> Hi all,
>=20
> I am using xfs file system on a MIPS based processor having
> linux-2.6.24. when executed a script to copy an mp4 file of 1GB
> upto 30 instances on back ground. xfs crashed displaying the
> following log. Please suggest me a solution.

I'd suggest upgrading your kernel to somethign recent - there were
lots of fixes between 2.6.24 and 2.6.28 for allocation problems
under this sort of workload....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

Since I am working on an embedded platform it is very hard to ugrade the =
whole kernel. Can i modify some files related to xfs from the newer =
version? if so which version can i choose? which and all files need to =
be modified? Is there any patch available for this issue?

Thanks,

Jabir

------_=_NextPart_001_01CAF746.1730419D
Content-Type: text/plain;
	name="xfs_error.txt"
Content-Transfer-Encoding: base64
Content-Description: xfs_error.txt
Content-Disposition: attachment;
	filename="xfs_error.txt"

Q1BVIDEgVW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgdmlydHVhbCBh
ZGRyZXNzIDAwMDAwMDA2LCBlcGMgPT0gODAzMzc1ZTgsIHJhID09IDgwMzM3NWQ0Ck9vcHNbIzFd
OgpDcHUgMQokIDAgICA6IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDI1CiQgNCAg
IDogOGYxYzM4M2MgMDAwMDAwMzggMDAwMDAwMzggMDAwMDAwM2IKJCA4ICAgOiAwMDAwMDAwMiAw
MDAwMDQwMCAwMDAwMDAwYSAwMDAwMDQwMAokMTIgICA6IDAwMDAwMDAwIDgwNTRjNWMwIDAwMDAx
MjNjIDAwMDAwMDAwCiQxNiAgIDogOGYxYzM4M2MgOGQyYzkzNmMgMDAwMDAwMzggMDAwMDAwM2IK
JDIwICAgOiA4NzczODAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMAokMjQgICA6IDhmMzli
MWQwIDgwMzZjYTY0ICAgICAgICAgICAgICAgICAgCiQyOCAgIDogOGYwZWEwMDAgOGYwZWI0Mjgg
OGZiMTg5MDAgODAzMzc1ZDQKSGkgICAgOiAwMDAwMDAwMApMbyAgICA6IDAwMDAxMTA0CmVwYyAg
IDogODAzMzc1ZTggeGZzX3RyYW5zX2xvZ19idWYrMHhhMC8weGUwICAgICBOb3QgdGFpbnRlZApy
YSAgICA6IDgwMzM3NWQ0IHhmc190cmFuc19sb2dfYnVmKzB4OGMvMHhlMApTdGF0dXM6IDExMDBj
MzAzICAgIEtFUk5FTCBFWEwgSUUgCkNhdXNlIDogMDA4MDAwMDgKQmFkVkEgOiAwMDAwMDAwNgpQ
cklkICA6IDAwMDE5NTQ4IChNSVBTIDM0SykKTW9kdWxlcyBsaW5rZWQgaW46IGJsb2NrMm10ZApQ
cm9jZXNzIGNwIChwaWQ6IDE0MDcsIHRocmVhZGluZm89OGYwZWEwMDAsIHRhc2s9OGY4OWI2NDgp
ClN0YWNrIDogMDAwMDAwMDAgMDNhNzBjNzggOGYwY2E0ODAgOGQyYzkzNmMgOGYwMTc0MDAgOGQy
YzkzNmMgOGYzMzYyMDAgMDAwMDAwMDEKICAgICAgICA4ZjA4ZWU5OCA4MDJlMjg1OCAwMDAwMDAw
OCAwMDAxNDAwNSA4ZjMzNjJjMCA4ZjMzNjJjMCA4ZjBlYjQ2OCA4ZjBlYjQ2YwogICAgICAgIDAw
MDAwMDM4IDAwMDAwMDNiIDAwMDAwMDAwIDg3NzM4MDEwIDAwMDAwMDAxIDgwMmU3YTE4IDAwMDAw
MDAxIDAwMDAwMDAwCiAgICAgICAgOGYwOGVlMDggMDAwMDAwMDEgMDAwMDAwMjQgMDAwMDAwMDAg
ODA2NGVlYzAgOGYwOGVlMzAgOGYwMTc0MDAgODAzMDBlYTQKICAgICAgICAwMDAwNDAwNCA4MDMz
N2FmMCAwMDAwMDIwMCAwMDAwMTEwNCAwMDNhNWZjMyAwM2E3MGM3OCAwMDAwMDAwOCAwMDAwMDAw
MAogICAgICAgIC4uLgpDYWxsIFRyYWNlOgpbPDgwMzM3NWU4Pl0geGZzX3RyYW5zX2xvZ19idWYr
MHhhMC8weGUwCls8ODAyZTI4NTg+XSB4ZnNfYWxsb2NfbG9nX2FnZisweDU4LzB4NmMKWzw4MDJl
N2ExOD5dIHhmc19hbGxvY19kZWxyZWMrMHg0YjgvMHhiYTQKWzw4MDJlODE0Yz5dIHhmc19hbGxv
Y19kZWxldGUrMHg0OC8weGVjCls8ODAyZTFlODQ+XSB4ZnNfYWxsb2NfZml4dXBfdHJlZXMrMHg4
Yy8weDQ2YwpbPDgwMmU0MDA0Pl0geGZzX2FsbG9jX2FnX3ZleHRlbnRfbmVhcisweDQyYy8weGFl
OApbPDgwMmU0N2ZjPl0geGZzX2FsbG9jX2FnX3ZleHRlbnQrMHgxM2MvMHgxYTQKWzw4MDJlNTFk
ND5dIHhmc19hbGxvY192ZXh0ZW50KzB4M2Q0LzB4NDkwCls8ODAyZjY5MzA+XSB4ZnNfYm1hcF9i
dGFsbG9jKzB4NjZjLzB4YWJjCls8ODAyZmFjNTg+XSB4ZnNfYm1hcGkrMHhkNDgvMHgxM2Y4Cls8
ODAzMjE1ZDg+XSB4ZnNfaW9tYXBfd3JpdGVfYWxsb2NhdGUrMHgxNzgvMHg1OWMKWzw4MDMyMDQw
OD5dIHhmc19pb21hcCsweDQwYy8weDQ2OApbPDgwMzQ1NzBjPl0geGZzX21hcF9ibG9ja3MrMHg0
OC8weGFjCls8ODAzNDY5Mjg+XSB4ZnNfcGFnZV9zdGF0ZV9jb252ZXJ0KzB4NjU4LzB4OTEwCls8
ODAzNDZmMjg+XSB4ZnNfdm1fd3JpdGVwYWdlKzB4ODQvMHgyMGMKWzw4MDE2OTg3Yz5dIF9fd3Jp
dGVwYWdlKzB4MWMvMHg4OApbPDgwMTZhNmE4Pl0gd3JpdGVfY2FjaGVfcGFnZXMrMHgzMDAvMHg0
MTgKWzw4MDE2YTgyOD5dIGRvX3dyaXRlcGFnZXMrMHg0NC8weDc4Cls8ODAxYWJmODA+XSBfX3dy
aXRlYmFja19zaW5nbGVfaW5vZGUrMHhhMC8weDQ4OApbPDgwMWFjOTM0Pl0gc3luY19zYl9pbm9k
ZXMrMHgzMTgvMHg0NzAKWzw4MDFhY2RkYz5dIHdyaXRlYmFja19pbm9kZXMrMHg5Yy8weDE2MApb
PDgwMTZiM2JjPl0gYmFsYW5jZV9kaXJ0eV9wYWdlc19yYXRlbGltaXRlZF9ucisweDI3OC8weDNj
OApbPDgwMTYzZTY0Pl0gZ2VuZXJpY19maWxlX2J1ZmZlcmVkX3dyaXRlKzB4MWZjLzB4NzU4Cls8
ODAzNGY4ZmM+XSB4ZnNfd3JpdGUrMHg2ODAvMHg5MzQKWzw4MDE4NDYwOD5dIGRvX3N5bmNfd3Jp
dGUrMHhlMC8weDE2OApbPDgwMTg1Mjk4Pl0gc3lzX3dyaXRlKzB4NTgvMHhjMApbPDgwMTBiZWQw
Pl0gc3RhY2tfZG9uZSsweDIwLzB4M2MKCgpDb2RlOiAwMjQwMjgyMSAgMzQ2MzAwMDEgIGFlMjMw
MDYwIDw5MDQ3MDAwNj4gMjQwM2ZmZjcgIDAyNjAzMDIxICAzNGU3MDAwMSAgMDBlMzM4MjQgIGEw
NDcwMDA2IAoK

------_=_NextPart_001_01CAF746.1730419D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------_=_NextPart_001_01CAF746.1730419D--
