Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SBSdAP155459 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 05:28:39 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B1E88DEFE8
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 03:31:03 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	7TxIyzJcZpDuIbua for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 03:31:03 -0800 (PST)
Received: by qyk12 with SMTP id 12so3506355qyk.5
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 03:31:03 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 20:31:02 +0900
Message-ID: <AANLkTimoZE8kD2Qz+ynZhceGuHqZxe9VSHKXho_tbdWi@mail.gmail.com>
Subject: [patch] xfsprogs: repair never return if device removed
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Content-Type: multipart/mixed; boundary=0015175cd0fcb36742049ae66661
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

--0015175cd0fcb36742049ae66661
Content-Type: multipart/alternative; boundary=0015175cd0fcb3672c049ae6665f

--0015175cd0fcb3672c049ae6665f
Content-Type: text/plain; charset=ISO-8859-1

xfsprogs all version, delete primary superblock of xfs partition

dd if=/dev/zero of=/dev/sda1 bs=512 count=1
sync

Run xfs_repair in partition, while its searching for secondary superblock,
remove the disk (USB) xfs_repair will never exit and will loop in never
ending ............

Please find patch attached with mail

--0015175cd0fcb3672c049ae6665f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>xfsprogs all version, delete primary superblock of xfs partition</div>
<div>=A0</div>
<div>dd if=3D/dev/zero of=3D/dev/sda1 bs=3D512 count=3D1</div>
<div>sync</div>
<div>=A0</div>
<div>Run xfs_repair in partition, while its searching for secondary superbl=
ock, remove the disk (USB) xfs_repair will never exit and will loop in neve=
r ending ............</div>
<div>=A0</div>
<div>Please find patch attached with mail</div>

--0015175cd0fcb3672c049ae6665f--

--0015175cd0fcb36742049ae66661
Content-Type: application/octet-stream;
	name="xfs_repair_hang_on_device_removal.patch"
Content-Disposition: attachment;
	filename="xfs_repair_hang_on_device_removal.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjh0hcy90

ZGlmZiAtTnVycCB4ZnNwcm9ncy0zLjAuNS9yZXBhaXIvc2IuYyB4ZnNwcm9ncy0zLjAuNS1kaXJ0
eS9yZXBhaXIvc2IuYwotLS0geGZzcHJvZ3MtMy4wLjUvcmVwYWlyL3NiLmMJMjAxMS0wMS0yOCAy
MDoyMzowMi4wMDAwMDAwMDAgKzA5MDAKKysrIHhmc3Byb2dzLTMuMC41LWRpcnR5L3JlcGFpci9z
Yi5jCTIwMTEtMDEtMjggMjA6MjE6MDYuMDAwMDAwMDAwICswOTAwCkBAIC0xMjIsOCArMTIyLDkg
QEAgZmluZF9zZWNvbmRhcnlfc2IoeGZzX3NiX3QgKnJzYikKIAkJCWRvbmUgPSAxOwogCQl9CiAK
LQkJaWYgKCFkb25lICYmIChic2l6ZSA9IHJlYWQoeC5kZmQsIHNiLCBCU0laRSkpID09IDApICB7
CisJCWlmICghZG9uZSAmJiAoYnNpemUgPSByZWFkKHguZGZkLCBzYiwgQlNJWkUpKSA8PSAwKSAg
ewogCQkJZG9uZSA9IDE7CisJCQlkb193YXJuKF8oIkNvdWxkbid0IGZpbmQgY2FuZGlkYXRlIHNl
Y29uZGFyeSBzdXBlcmJsb2NrLCBleGl0aW5nLi4uXG4iKSk7CiAJCX0KIAogCQlkb193YXJuKCIu
Iik7Cg==
--0015175cd0fcb36742049ae66661
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--0015175cd0fcb36742049ae66661--
