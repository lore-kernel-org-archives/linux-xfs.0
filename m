Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VNBNdC130590 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 17:11:23 -0600
Received: from postoffice2.aconex.com (mail.aconex.com [203.166.49.3]) by
	cuda.sgi.com with ESMTP id d26njuFQDFQLnRiF for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 15:11:20 -0800 (PST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.35.100])
	by postoffice2.aconex.com with ESMTP id RWyX1mxFajaGpIlf for
	<xfs@oss.sgi.com>; Wed, 01 Feb 2012 10:11:17 +1100 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.35.102])
	by postoffice.aconex.com (Postfix) with ESMTP id 820A43CE00C5
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:11:01 +1100 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 9B9059E0002
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:11:17 +1100 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id bDPA+luNA1dv for <xfs@oss.sgi.com>;
	Wed,  1 Feb 2012 10:11:17 +1100 (EST)
Received: from acxmail-au2.aconex.com (acxmail-au2.aconex.com [192.168.35.104])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 1D47D9E0001
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:11:17 +1100 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by acxmail-au2.aconex.com (Postfix) with ESMTP id 14D2A3B20003
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:11:17 +1100 (EST)
Received: from acxmail-au2.aconex.com ([127.0.0.1])
	by localhost (acxmail-au2.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id Vr2Zz2bhPHnZ for <xfs@oss.sgi.com>;
	Wed,  1 Feb 2012 10:11:16 +1100 (EST)
Received: from acxmail-au2.aconex.com (acxmail-au2.aconex.com [192.168.35.104])
	by acxmail-au2.aconex.com (Postfix) with ESMTP id D4CAF3B20001
	for <xfs@oss.sgi.com>; Wed,  1 Feb 2012 10:11:16 +1100 (EST)
Date: Wed, 1 Feb 2012 10:11:16 +1100 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1247398017.69749.1328051476851.JavaMail.root@acxmail-au2.aconex.com>
In-Reply-To: <519369070.69746.1328051417713.JavaMail.root@acxmail-au2.aconex.com>
Subject: [patch] xfsprogs: extend fiemap configure check
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_69748_1420656309.1328051476850"
Reply-To: Nathan Scott <nathans@debian.org>
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

------=_Part_69748_1420656309.1328051476850
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Make the fiemap configure check consistent with the other
libc interface checks - perform a compile and link with a
complete set of symbols, macros and interfaces needed, as
opposed to a build with just the headers.

Signed-off-by: Nathan Scott <nathans@debian.org>
------=_Part_69748_1420656309.1328051476850
Content-Type: text/x-patch; name=fiemap.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=fiemap.patch

ZGlmZiAtLWdpdCBhL200L3BhY2thZ2VfbGliY2Rldi5tNCBiL200L3BhY2thZ2VfbGliY2Rldi5t
NAppbmRleCA4MTkyMTgxLi4xZTJjMjU2IDEwMDY0NAotLS0gYS9tNC9wYWNrYWdlX2xpYmNkZXYu
bTQKKysrIGIvbTQvcGFja2FnZV9saWJjZGV2Lm00CkBAIC0xMjEsNiArMTIxLDE3IEBAIEFDX0RF
RlVOKFtBQ19IQVZFX0ZBTExPQ0FURV0sCiAjIENoZWNrIGlmIHdlIGhhdmUgdGhlIGZpZW1hcCBp
b2N0bCAoTGludXgpCiAjCiBBQ19ERUZVTihbQUNfSEFWRV9GSUVNQVBdLAotICBbIEFDX0NIRUNL
X0hFQURFUlMoW2xpbnV4L2ZpZW1hcC5oXSwgWyBoYXZlX2ZpZW1hcD15ZXMgXSwgWyBoYXZlX2Zp
ZW1hcD1ubyBdKQorICBbIEFDX01TR19DSEVDS0lORyhbZm9yIGZpZW1hcF0pCisgICAgQUNfVFJZ
X0xJTksoWworI2RlZmluZSBfR05VX1NPVVJDRQorI2RlZmluZSBfRklMRV9PRkZTRVRfQklUUyA2
NAorI2luY2x1ZGUgPGxpbnV4L2ZzLmg+CisjaW5jbHVkZSA8bGludXgvZmllbWFwLmg+CisgICAg
XSwgWworICAgICAgICAgc3RydWN0IGZpZW1hcCAqZmllbWFwOworICAgICAgICAgaW9jdGwoMCwg
RlNfSU9DX0ZJRU1BUCwgKHVuc2lnbmVkIGxvbmcpZmllbWFwKTsKKyAgICBdLCBoYXZlX2ZpZW1h
cD15ZXMKKyAgICAgICBBQ19NU0dfUkVTVUxUKHllcyksCisgICAgICAgQUNfTVNHX1JFU1VMVChu
bykpCiAgICAgQUNfU1VCU1QoaGF2ZV9maWVtYXApCiAgIF0pCg==
------=_Part_69748_1420656309.1328051476850
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_69748_1420656309.1328051476850--
