Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n159KUdC206368 for <xfs@oss.sgi.com>; Thu, 5 Feb 2009 03:20:31 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B46718CA81E
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 01:19:25 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id qw7vAj5fWSjELFth for
	<xfs@oss.sgi.com>; Thu, 05 Feb 2009 01:19:25 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id B08243D97
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 10:19:24 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id AF508400172
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 10:19:24 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Wiki entry for disk write caches and RAID controllers
Date: Thu, 5 Feb 2009 10:19:24 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902051019.24403@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

SSB1cGRhdGVkIHRoZSBzZWN0aW9ucyBhYm91dCAiZGlzayB3cml0ZSBjYWNoZSIgYW5kICJSQUlE
IGNvbnRyb2xsZXJzIiwgCnBsZWFzZSByZXZpZXcgYW5kIGNvbW1lbnQuCgpodHRwOi8veGZzLm9y
Zy9pbmRleC5waHAvWEZTX0ZBUQoKSSBtZXJnZWQgbXkgb3JpZ2luYWwgcGFyYWdyYXBoIGFib3V0
ICJkaXNrIHdyaXRlIGNhY2hlIiB3aXRoIHRoZSAiV2hhdCAKaXMgdGhlIHByb2JsZW0gd2l0aCB0
aGUgd3JpdGUgY2FjaGUgb24gam91cm5hbGVkIGZpbGVzeXN0ZW1zPyIgdGV4dC4KCk9uIERvbm5l
cnN0YWcgMDUgRmVicnVhciAyMDA5IERhdmUgQ2hpbm5lciB3cm90ZToKPiBXaGF0IEkgbWlzc2Vk
IHdhcyB0aGUgImJhcnJpZXJzIHR1cm5lZCBvbiIgLSBJIHdhcyByZWZlcnJpbmcKPiAoY29udGV4
dCBub3QgcXVvdGVkKSB0byB0aGUgZmFjdCB0aGF0IFJBSUQ1IGlzIG5vdCB1btGWcXVlIGluIGl0
J3MKPiBhYmlsaXR5IHRvIHRyYXNoIHRoZSBmaWxlc3lzdGVtIG9uIHBvd2VyZmFpbC4gWW91IGFy
ZSByaWdodCwKPiBiYXJyaWVycyBvbiBhIHNpbmdsZSBkaXNrIHNob3VsZCBwcmV2ZW50IGZpbGVz
eXN0ZW0gY29ycnVwdGlvbgo+IGFuZCB3aWxsIHByZXZlbnQgbG9zcyBvZiBzeW5jaHJvbm91c2x5
IHdyaXR0ZW4gZGF0YS4gb25seQo+IGFzeW5jaHJvbm91c2x5IHdyaXR0ZW4gZGF0YSB3aWxsIGdl
dCBsb3N0IChqdXN0IGxpa2UgYWxsIHRoZQo+IHN0dWZmIHNpdHRpbmcgaW4gUkFNKS4KClNvIGNh
biB3ZSBzYXkgdGhhdCAxIGRpc2sgY2FuIGxldCB3cml0ZSBjYWNoZSBvbiB3aXRoIGJhcnJpZXJz
IGVuYWJsZWQ/CgpGb3IgdGhlIFh5cmF0ZXggY2FzZTogSWYgYWxsIHdyaXRlIGNhY2hlcyBhcmUg
b2ZmIChvciB3cml0ZSB0aHJvdWdoKSwgCmRvZXMgaXQgbWF0dGVyIGlmIHlvdSB1c2UgW25vXWJh
cnJpZXI/IEkgZ3Vlc3Mgbm8sIGp1c3Qgd2FudCB0byBiZSBzdXJlLgoKbWZnIHptaQotLSAKLy8g
TWljaGFlbCBNb25uZXJpZSwgSW5nLkJTYyAgICAtLS0tLSAgICAgIGh0dHA6Ly9pdC1tYW5hZ2Vt
ZW50LmF0Ci8vIFRlbDogMDY2MCAvIDQxNSA2NSAzMSAgICAgICAgICAgICAgICAgICAgICAubmV0
d29yay55b3VyLmlkZWFzLgovLyBQR1AgS2V5OiAgICAgICAgICJjdXJsIC1zIGh0dHA6Ly96bWku
YXQvem1pLmFzYyB8IGdwZyAtLWltcG9ydCIKLy8gRmluZ2VycHJpbnQ6IEFDMTkgRjlENSAzNkVE
IENEOEEgRUYzOCAgNTAwRSBDRTE0IDkxRjcgMUMxMiAwOUI0Ci8vIEtleXNlcnZlcjogd3d3a2V5
cy5ldS5wZ3AubmV0ICAgICAgICAgICAgICAgICAgS2V5LUlEOiAxQzEyMDlCNAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
