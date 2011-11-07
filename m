Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA72CW2e024806 for <xfs@oss.sgi.com>; Sun, 6 Nov 2011 20:12:32 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70001225E92
	for <xfs@oss.sgi.com>; Sun,  6 Nov 2011 18:12:30 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	X5SYsWwB76xSOHSJ for <xfs@oss.sgi.com>;
	Sun, 06 Nov 2011 18:12:30 -0800 (PST)
Received: by ggdk6 with SMTP id k6so2671390ggd.26
	for <xfs@oss.sgi.com>; Sun, 06 Nov 2011 18:12:30 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Nov 2011 10:12:30 +0800
Message-ID: <CAF7KpS_g1Zt9ubuXG3kqoUORUq04FNFwKbSYGKHLxkPWbcyR4A@mail.gmail.com>
Subject: Advanced format disk
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8086422561075512392=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8086422561075512392==
Content-Type: multipart/alternative; boundary=20cf3056409f473d6e04b11b969a

--20cf3056409f473d6e04b11b969a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I got several advanced format disk, whose physical size is 4096 bytes, but
its logical size is 512 bytes:
$ sudo fdisk -l /dev/sdb

Disk /dev/sdb: 750.2 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

Disk /dev/sdb doesn't contain a valid partition table

Is there any special tuning knob I should notice before formating it? IMHO,
set the sector size as 4096 bytes is enough. The default block size is 4096
bytes.
$ sudo xfs_info /dev/sdb
meta-data=3D/dev/sdb         isize=3D256    agcount=3D4, agsize=3D45785912 =
blks
                  =3D                       sectsz=3D4096  attr=3D2
data          =3D                       bsize=3D4096   blocks=3D183143646,
imaxpct=3D25
                  =3D                       sunit=3D0      swidth=3D0 blks
naming      =3D                        version 2              bsize=3D4096
ascii-ci=3D0
log            =3Dinternal               bsize=3D4096   blocks=3D89425, ver=
sion=3D2
                 =3D                       sectsz=3D4096  sunit=3D1 blks,
lazy-count=3D1
realtime   =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0


best regards,
=E9=9F=A9=E7=AB=B9(Zhu Han)

--20cf3056409f473d6e04b11b969a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

SGksPGJyPjxicj5JIGdvdCBzZXZlcmFsIGFkdmFuY2VkIGZvcm1hdCBkaXNrLCB3aG9zZSBwaHlz
aWNhbCBzaXplIGlzIDQwOTYgYnl0ZXMsIGJ1dCBpdHMgbG9naWNhbCBzaXplIGlzIDUxMiBieXRl
czo8YnI+JCBzdWRvIGZkaXNrIC1sIC9kZXYvc2RiPGJyPjxicj5EaXNrIC9kZXYvc2RiOiA3NTAu
MiBHQiwgNzUwMTU2Mzc0MDE2IGJ5dGVzPGJyPjI1NSBoZWFkcywgNjMgc2VjdG9ycy90cmFjaywg
OTEyMDEgY3lsaW5kZXJzPGJyPgpVbml0cyA9IGN5bGluZGVycyBvZiAxNjA2NSAqIDUxMiA9IDgy
MjUyODAgYnl0ZXM8YnI+U2VjdG9yIHNpemUgKGxvZ2ljYWwvcGh5c2ljYWwpOiA1MTIgYnl0ZXMg
LyA0MDk2IGJ5dGVzPGJyPkkvTyBzaXplIChtaW5pbXVtL29wdGltYWwpOiA0MDk2IGJ5dGVzIC8g
NDA5NiBieXRlczxicj5EaXNrIGlkZW50aWZpZXI6IDB4MDAwMDAwMDA8YnI+PGJyPkRpc2sgL2Rl
di9zZGIgZG9lc24mIzM5O3QgY29udGFpbiBhIHZhbGlkIHBhcnRpdGlvbiB0YWJsZTxicj4KPGJy
PklzIHRoZXJlIGFueSBzcGVjaWFsIHR1bmluZyBrbm9iIEkgc2hvdWxkIG5vdGljZSBiZWZvcmUg
Zm9ybWF0aW5nIGl0PyBJTUhPLCBzZXQgdGhlIHNlY3RvciBzaXplIGFzIDQwOTYgYnl0ZXMgaXMg
ZW5vdWdoLiBUaGUgZGVmYXVsdCBibG9jayBzaXplIGlzIDQwOTYgYnl0ZXMuPGJyPiQgc3VkbyB4
ZnNfaW5mbyAvZGV2L3NkYjxicj5tZXRhLWRhdGE9L2Rldi9zZGLCoMKgwqDCoMKgwqDCoMKgIGlz
aXplPTI1NsKgwqDCoCBhZ2NvdW50PTQsIGFnc2l6ZT00NTc4NTkxMiBibGtzPGJyPgrCoMKgwqDC
oMKgwqDCoCDCoCDCoCDCoCDCoCDCoCA9wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc2VjdHN6PTQwOTbCoCBhdHRyPTI8YnI+ZGF0YcKgwqDCoCDCoCDCoCDCoCA9
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnNpemU9NDA5NsKg
wqAgYmxvY2tzPTE4MzE0MzY0NiwgaW1heHBjdD0yNTxicj7CoMKgwqDCoMKgwqDCoCDCoCDCoCDC
oCDCoCDCoCA9wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Vu
aXQ9MMKgwqDCoMKgwqAgc3dpZHRoPTAgYmxrczxicj5uYW1pbmfCoMKgwqDCoMKgID3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZlcnNpb24gMsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGJzaXplPTQwOTbCoMKgIGFzY2lpLWNpPTA8YnI+CmxvZ8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgPWludGVybmFswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBi
c2l6ZT00MDk2wqDCoCBibG9ja3M9ODk0MjUsIHZlcnNpb249Mjxicj7CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCA9wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgc2VjdHN6PTQwOTbCoCBzdW5pdD0xIGJsa3MsIGxhenktY291bnQ9MTxicj5yZWFsdGlt
ZcKgwqAgPW5vbmXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXh0c3o9NDA5
NsKgwqAgYmxvY2tzPTAsIHJ0ZXh0ZW50cz0wPGJyPgo8YnI+PGJyIGNsZWFyPSJhbGwiPmJlc3Qg
cmVnYXJkcyw8YnI+6Z+p56u5KFpodSBIYW4pPGJyPjxicj4K
--20cf3056409f473d6e04b11b969a--


--===============8086422561075512392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8086422561075512392==--
