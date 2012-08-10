Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7A8N6t8037570 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 03:23:06 -0500
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id QuRCarHDpxEFAd59
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 10 Aug 2012 01:23:04 -0700 (PDT)
Received: by wgbds1 with SMTP id ds1so1006504wgb.2
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 01:23:03 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 10:23:03 +0200
Message-ID: <CADcDJaR52zwL+aMaUuQTvbYx2d11LRmzdURE2Ok8z0tKsYTv8A@mail.gmail.com>
Subject: xfs_repair - segemnation fault | git error
From: Velimir Galic <veli.galic@gmail.com>
Content-Type: multipart/mixed; boundary=f46d04428de88544fa04c6e50d78
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
To: xfs@oss.sgi.com

--f46d04428de88544fa04c6e50d78
Content-Type: multipart/alternative; boundary=f46d04428de88544eb04c6e50d76

--f46d04428de88544eb04c6e50d76
Content-Type: text/plain; charset=ISO-8859-1

hi Guys,

I hope you are able to help me, because i think that i
tried everything that i know off to repair my raid after a disk failure.

Systemspecs:

   - HP N40L
      - CPU: AMD Turion II @ 1,5GHZ
      - 8GB ECC RAM
      - Disks:
         - 250GB | OS
         - 4x2GB | RAID 5 | Softraid
      - OS: Openmediavault @ 3.0.20 (last version)


Problem:

In my raid a disk was fault so mdadm kicked the disk out of the raid. I put
a replacement in the box and started a resync of the raid and than
is happened, a second disk got lost in the raid. The raidsync wasn't
finished and now i'm fighting 3 weeks or more i don't no any more :-( to
repair the file system.

I tried a lot of different versions of xfs_repair (2.9.4, 2.9.8, 2.10.2,
3.0.4, 3.1.2, 3.1.6, 3.1,8), but every precompiled version got an
"segmentation fault" or hung at phase 3 with 100% cpu load for few day. I
also tried different distros like ubuntu, debian, redhat, gentoo (yes, i'm
a little bit desperate :-) )  Than i tried the git version and at first it
looked good but than i got an another error but i don't understand what the
problem is.

tried options without any luck: xfs_repair -v -P | xfs_repair -v -P -m 6144
| xfs_repair -v -P -L

Metadump of the filesystem isn't possible at this moment, but i could
bootup a live cd and give it a try with it. I'm pretty stuck and don't no
what to do any more.


with kind regards
Veli

--f46d04428de88544eb04c6e50d76
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hi Guys,<div><br></div><div>I hope you are able to help me, because i think=
 that i tried=A0everything=A0that i=A0know=A0off to repair my raid after a =
disk=A0failure.</div><div><br></div><div>Systemspecs:</div><div><ul><li>HP =
N40L</li>
<ul><li>CPU: AMD Turion II @ 1,5GHZ</li><li>8GB ECC RAM</li><li>Disks:</li>=
<ul><li>250GB | OS</li><li>4x2GB | RAID 5 | Softraid</li></ul><li>OS: Openm=
ediavault @ 3.0.20 (last version)</li></ul></ul><div><br></div></div><div>
Problem:</div><div><br></div><div>In my raid a disk was fault so mdadm kick=
ed the disk out of the raid. I put a replacement in the box and started a r=
esync of the raid and than is=A0happened, a second disk got lost in the rai=
d. The raidsync wasn&#39;t finished and now i&#39;m fighting 3 weeks or mor=
e i don&#39;t no any more :-( to repair the=A0file system.=A0</div>
<div><br></div><div>I=A0tried a lot of different versions of xfs_repair (2.=
9.4, 2.9.8, 2.10.2, 3.0.4, 3.1.2, 3.1.6, 3.1,8), but every precompiled vers=
ion got an &quot;segmentation fault&quot; or hung at phase 3 with 100% cpu =
load for few day. I also tried different distros like ubuntu, debian, redha=
t, gentoo (yes, i&#39;m a=A0little=A0bit=A0desperate=A0:-) )=A0 Than i trie=
d the git version and at first it looked good but than i got an another err=
or but i don&#39;t understand what the problem is.</div>
<div><br></div><div>tried options without any luck: xfs_repair -v -P | xfs_=
repair -v -P -m 6144 | xfs_repair -v -P -L=A0</div><div><br></div><div>Meta=
dump of the filesystem isn&#39;t possible at this moment, but i could bootu=
p a live cd and give it a try with it. I&#39;m pretty stuck and don&#39;t n=
o what to do any more.</div>
<div><br></div><div><br></div><div>with kind regards</div><div>Veli</div><d=
iv><br></div><div><br></div><div><br></div><div><br></div><div><br></div>

--f46d04428de88544eb04c6e50d76--

--f46d04428de88544fa04c6e50d78
Content-Type: application/octet-stream; name="md127.metadump.err"
Content-Disposition: attachment; filename="md127.metadump.err"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h5ozhx8e0

cm9vdEBocGJveDp+IyB4ZnNfbWV0YWR1bXAgL2Rldi9tZDEyNyAvbWVkaWEvbG9jYWxoZGQvbWQx
MjcubWV0YWR1bXAKKioqIGdsaWJjIGRldGVjdGVkICoqKiB4ZnNfZGI6IGRvdWJsZSBmcmVlIG9y
IGNvcnJ1cHRpb24gKCFwcmV2KTogMHgwMDAwMDAwMDAxY2NiMDAwICoqKgo9PT09PT09IEJhY2t0
cmFjZTogPT09PT09PT09Ci9saWIvbGliYy5zby42KCsweDcxYmQ2KVsweDdmNWUzNGI1NWJkNl0K
L2xpYi9saWJjLnNvLjYoY2ZyZWUrMHg2YylbMHg3ZjVlMzRiNWE5NGNdCnhmc19kYlsweDQxYThl
M10KeGZzX2RiWzB4NDFjM2VjXQp4ZnNfZGJbMHg0MWUyYmNdCnhmc19kYlsweDQxYzE1Ml0KeGZz
X2RiWzB4NDFkZmQ0XQp4ZnNfZGJbMHg0MWMxNTJdCnhmc19kYlsweDQxZWVkYl0KeGZzX2RiWzB4
NDE4ZDA4XQovbGliL2xpYmMuc28uNihfX2xpYmNfc3RhcnRfbWFpbisweGZkKVsweDdmNWUzNGIw
MmM4ZF0KeGZzX2RiWzB4NDAyN2Q5XQo9PT09PT09IE1lbW9yeSBtYXA6ID09PT09PT09CjAwNDAw
MDAwLTAwNDc1MDAwIHIteHAgMDAwMDAwMDAgMDg6NDEgMjMzOCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAvdXNyL3NiaW4veGZzX2RiCjAwNjc1MDAwLTAwNjc2MDAwIHJ3LXAgMDAwNzUw
MDAgMDg6NDEgMjMzOCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvdXNyL3NiaW4veGZz
X2RiCjAwNjc2MDAwLTAwNjg5MDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAKMDFjODMwMDAtMDFm
MWQwMDAgcnctcCAwMDAwMDAwMCAwMDowMCAwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIFtoZWFwXQo3ZjVlMzAwMDAwMDAtN2Y1ZTMwMDIxMDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAg
MCAKN2Y1ZTMwMDIxMDAwLTdmNWUzNDAwMDAwMCAtLS1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmNWUz
NDhjNzAwMC03ZjVlMzQ4ZGQwMDAgci14cCAwMDAwMDAwMCAwODo0MSAyMTEwNSAgICAgICAgICAg
ICAgICAgICAgICAvbGliL2xpYmdjY19zLnNvLjEKN2Y1ZTM0OGRkMDAwLTdmNWUzNGFkYzAwMCAt
LS1wIDAwMDE2MDAwIDA4OjQxIDIxMTA1ICAgICAgICAgICAgICAgICAgICAgIC9saWIvbGliZ2Nj
X3Muc28uMQo3ZjVlMzRhZGMwMDAtN2Y1ZTM0YWRkMDAwIHJ3LXAgMDAwMTUwMDAgMDg6NDEgMjEx
MDUgICAgICAgICAgICAgICAgICAgICAgL2xpYi9saWJnY2Nfcy5zby4xCjdmNWUzNGFlNDAwMC03
ZjVlMzRjM2QwMDAgci14cCAwMDAwMDAwMCAwODo0MSAzMjIyICAgICAgICAgICAgICAgICAgICAg
ICAvbGliL2xpYmMtMi4xMS4zLnNvCjdmNWUzNGMzZDAwMC03ZjVlMzRlM2MwMDAgLS0tcCAwMDE1
OTAwMCAwODo0MSAzMjIyICAgICAgICAgICAgICAgICAgICAgICAvbGliL2xpYmMtMi4xMS4zLnNv
CjdmNWUzNGUzYzAwMC03ZjVlMzRlNDAwMDAgci0tcCAwMDE1ODAwMCAwODo0MSAzMjIyICAgICAg
ICAgICAgICAgICAgICAgICAvbGliL2xpYmMtMi4xMS4zLnNvCjdmNWUzNGU0MDAwMC03ZjVlMzRl
NDEwMDAgcnctcCAwMDE1YzAwMCAwODo0MSAzMjIyICAgICAgICAgICAgICAgICAgICAgICAvbGli
L2xpYmMtMi4xMS4zLnNvCjdmNWUzNGU0MTAwMC03ZjVlMzRlNDYwMDAgcnctcCAwMDAwMDAwMCAw
MDowMCAwIAo3ZjVlMzRlNDYwMDAtN2Y1ZTM0ZTVkMDAwIHIteHAgMDAwMDAwMDAgMDg6NDEgMzIx
NyAgICAgICAgICAgICAgICAgICAgICAgL2xpYi9saWJwdGhyZWFkLTIuMTEuMy5zbwo3ZjVlMzRl
NWQwMDAtN2Y1ZTM1MDVjMDAwIC0tLXAgMDAwMTcwMDAgMDg6NDEgMzIxNyAgICAgICAgICAgICAg
ICAgICAgICAgL2xpYi9saWJwdGhyZWFkLTIuMTEuMy5zbwo3ZjVlMzUwNWMwMDAtN2Y1ZTM1MDVk
MDAwIHItLXAgMDAwMTYwMDAgMDg6NDEgMzIxNyAgICAgICAgICAgICAgICAgICAgICAgL2xpYi9s
aWJwdGhyZWFkLTIuMTEuMy5zbwo3ZjVlMzUwNWQwMDAtN2Y1ZTM1MDVlMDAwIHJ3LXAgMDAwMTcw
MDAgMDg6NDEgMzIxNyAgICAgICAgICAgICAgICAgICAgICAgL2xpYi9saWJwdGhyZWFkLTIuMTEu
My5zbwo3ZjVlMzUwNWUwMDAtN2Y1ZTM1MDYyMDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAKN2Y1
ZTM1MDYyMDAwLTdmNWUzNTA2OTAwMCByLXhwIDAwMDAwMDAwIDA4OjQxIDMyMTkgICAgICAgICAg
ICAgICAgICAgICAgIC9saWIvbGlicnQtMi4xMS4zLnNvCjdmNWUzNTA2OTAwMC03ZjVlMzUyNjgw
MDAgLS0tcCAwMDAwNzAwMCAwODo0MSAzMjE5ICAgICAgICAgICAgICAgICAgICAgICAvbGliL2xp
YnJ0LTIuMTEuMy5zbwo3ZjVlMzUyNjgwMDAtN2Y1ZTM1MjY5MDAwIHItLXAgMDAwMDYwMDAgMDg6
NDEgMzIxOSAgICAgICAgICAgICAgICAgICAgICAgL2xpYi9saWJydC0yLjExLjMuc28KN2Y1ZTM1
MjY5MDAwLTdmNWUzNTI2YTAwMCBydy1wIDAwMDA3MDAwIDA4OjQxIDMyMTkgICAgICAgICAgICAg
ICAgICAgICAgIC9saWIvbGlicnQtMi4xMS4zLnNvCjdmNWUzNTI2YTAwMC03ZjVlMzUyNmUwMDAg
ci14cCAwMDAwMDAwMCAwODo0MSAyMTE5NSAgICAgICAgICAgICAgICAgICAgICAvbGliL2xpYnV1
aWQuc28uMS4zLjAKN2Y1ZTM1MjZlMDAwLTdmNWUzNTQ2ZDAwMCAtLS1wIDAwMDA0MDAwIDA4OjQx
IDIxMTk1ICAgICAgICAgICAgICAgICAgICAgIC9saWIvbGlidXVpZC5zby4xLjMuMAo3ZjVlMzU0
NmQwMDAtN2Y1ZTM1NDZlMDAwIHJ3LXAgMDAwMDMwMDAgMDg6NDEgMjExOTUgICAgICAgICAgICAg
ICAgICAgICAgL2xpYi9saWJ1dWlkLnNvLjEuMy4wCjdmNWUzNTQ2ZTAwMC03ZjVlMzU0OGMwMDAg
ci14cCAwMDAwMDAwMCAwODo0MSAzMjE4ICAgICAgICAgICAgICAgICAgICAgICAvbGliL2xkLTIu
MTEuMy5zbwo3ZjVlMzU0YzcwMDAtN2Y1ZTM1NTA5MDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAK
N2Y1ZTM1NTA5MDAwLTdmNWUzNTY3ZTAwMCByLS1wIDAwMDAwMDAwIDA4OjQxIDIxMDQgICAgICAg
ICAgICAgICAgICAgICAgIC91c3IvbGliL2xvY2FsZS9sb2NhbGUtYXJjaGl2ZQo3ZjVlMzU2N2Uw
MDAtN2Y1ZTM1NjgyMDAwIHJ3LXAgMDAwMDAwMDAgMDA6MDAgMCAKN2Y1ZTM1Njg5MDAwLTdmNWUz
NTY4YjAwMCBydy1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmNWUzNTY4YjAwMC03ZjVlMzU2OGMwMDAg
ci0tcCAwMDAxZDAwMCAwODo0MSAzMjE4ICAgICAgICAgICAgICAgICAgICAgICAvbGliL2xkLTIu
MTEuMy5zbwo3ZjVlMzU2OGMwMDAtN2Y1ZTM1NjhkMDAwIHJ3LXAgMDAwMWUwMDAgMDg6NDEgMzIx
OCAgICAgICAgICAgICAgICAgICAgICAgL2xpYi9sZC0yLjExLjMuc28KN2Y1ZTM1NjhkMDAwLTdm
NWUzNTY4ZTAwMCBydy1wIDAwMDAwMDAwIDAwOjAwIDAgCjdmZmYzM2I1MjAwMC03ZmZmMzNiNzMw
MDAgcnctcCAwMDAwMDAwMCAwMDowMCAwICAgICAgICAgICAgICAgICAgICAgICAgICBbc3RhY2td
CjdmZmYzM2JmZjAwMC03ZmZmMzNjMDAwMDAgci14cCAwMDAwMDAwMCAwMDowMCAwICAgICAgICAg
ICAgICAgICAgICAgICAgICBbdmRzb10KZmZmZmZmZmZmZjYwMDAwMC1mZmZmZmZmZmZmNjAxMDAw
IHIteHAgMDAwMDAwMDAgMDA6MDAgMCAgICAgICAgICAgICAgICAgIFt2c3lzY2FsbF0KQWJvcnRl
ZAo=
--f46d04428de88544fa04c6e50d78
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--f46d04428de88544fa04c6e50d78--
