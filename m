Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7551E7F54
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:32:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04567AC007
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:32:30 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8SzqhBLzRRAceL7q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:32:29 -0700 (PDT)
Subject: [PATCH 01/11] xfs_repair: set args.geo in dir2_kill_block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:27 -0700
Message-ID: <20150826003227.23973.77842.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

RnLDuG06IEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldD4KClRoaXMgcGF0aCBpbiB4
ZnNfcmVwYWlyOgoKZGlyMl9raWxsX2Jsb2NrCglsaWJ4ZnNfZGFfc2hyaW5rX2lub2RlCgkJeGZz
X2RpcjJfc2hyaW5rX2lub2RlCgkJCXhmc19kaXIyX2RiX3RvX2RhCgpzZWdmYXVsdHMsIGJlY2F1
c2UgZGlyMl9raWxsX2Jsb2NrKCkgZG9lcyBub3QgaW5pdGlhbGl6ZQphcmdzLmdlbywgYW5kIGEg
bnVsbCBnZW9tZXRyeSB3aW5kcyB1cCBpbiB4ZnNfZGlyMl9kYl90b19kYSgpLAp3aGljaCBkZXJl
ZmVyZW5jZXMgaXQuCgpGaXggdGhhdC4KClNpZ25lZC1vZmYtYnk6IEVyaWMgU2FuZGVlbiA8c2Fu
ZGVlbkByZWRoYXQuY29tPgotLS0KIHJlcGFpci9waGFzZTYuYyB8ICAgIDEgKwogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspCgoKZGlmZiAtLWdpdCBhL3JlcGFpci9waGFzZTYuYyBiL3Jl
cGFpci9waGFzZTYuYwppbmRleCAwNDYzOGMyLi43ZTI3NWNkIDEwMDY0NAotLS0gYS9yZXBhaXIv
cGhhc2U2LmMKKysrIGIvcmVwYWlyL3BoYXNlNi5jCkBAIC0xNDQ0LDYgKzE0NDQsNyBAQCBkaXIy
X2tpbGxfYmxvY2soCiAJYXJncy5maXJzdGJsb2NrID0gJmZpcnN0YmxvY2s7CiAJYXJncy5mbGlz
dCA9ICZmbGlzdDsKIAlhcmdzLndoaWNoZm9yayA9IFhGU19EQVRBX0ZPUks7CisJYXJncy5nZW8g
PSBtcC0+bV9kaXJfZ2VvOwogCWlmIChkYV9ibm8gPj0gbXAtPm1fZGlyX2dlby0+bGVhZmJsayAm
JiBkYV9ibm8gPCBtcC0+bV9kaXJfZ2VvLT5mcmVlYmxrKQogCQllcnJvciA9IC1saWJ4ZnNfZGFf
c2hyaW5rX2lub2RlKCZhcmdzLCBkYV9ibm8sIGJwKTsKIAllbHNlCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
