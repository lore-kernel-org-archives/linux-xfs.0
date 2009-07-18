Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6I0Wi9e124009 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 19:32:44 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBBE136E863
	for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 17:33:23 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id dvZPervzzyUIhNDE for
	<xfs@oss.sgi.com>; Fri, 17 Jul 2009 17:33:23 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by Ishtar.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6I0XLF4030333 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 17:33:23 -0700
Message-ID: <4A611851.8060904@tlinx.org>
Date: Fri, 17 Jul 2009 17:33:21 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: concerning 'optimal' strip size on RAID disks...
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

CkNvbmNlcm5pbmcgc3RyaXAtc2l6ZS4gIFdoYXQgYXJlIHRoZSBjb25zaWRlcmF0aW9ucyBmb3Ig
dGhhdD8gIEFueSByZWFzb24Kbm90IHRvIGNob3NlIHRoZSBsYXJnZXN0PyAgU2VlbXMgdGhhdCBh
dCBzaXplcyB1cCB0byAxTUIsIHRoZSBsYXJnZXIgdGhlCmJldHRlci4KCkZvciBkaXJlY3QgSS9P
ICh3aGljaCBpcyB3aGF0IHRoZSBSQUlEIGNvbnRyb2xsZXIgd291bGQgYmUgZG9pbmcgdG8KaXQn
cyBkaXNrcywgc2VlbXMgYSBsYXJnZXIgd3JpdGUgd291bGQgYmUgYmV0dGVyKS4gIAoKV291bGQg
SSBiZSBuYcOvdmUgdG8gYXNzdW1lIHRoYXQgaWYgYSBSQUlEIGNvbnRyb2xsZXIgb25seSBuZWVk
ZWQgdG8gCnVwZGF0ZSAxIGJsb2NrLCBpdCB3b3VsZG4ndCBuZWVkIHRvIHVwZGF0ZSB0aGUgZW50
aXJlIHN0cmlwPyAKCldvdWxkIHRoZXJlIGJlIGEgYmVuZWZpdCBpbiBydW5uaW5nIGEgc21hbGxl
ciBzdHJpcCBzaXplPyAKCkkga25vdyB3aGVuIEkgY2FuIGNvbnRyb2wgdGhlIGhhcmQgZGlza3Ms
IEkgY2FuIGVuYWJsZSB0aGVpciB3cml0ZSBjYWNoZXMsCnNvIGhhdmluZyB0aGVtIGRvIHBoeXNp
Y2FsIHdyaXRlcyB0aGUga2VlcCB0aGVpciB3cml0ZSBidWZmZXJzIHNhdHVyYXRlZAp3b3VsZCBv
cHRpbWl6ZSB3cml0ZSBwZXJmb3JtYW5jZSwgYXQgbGVhc3QsIGJ1dCBpZiBpdCdzIGEgQklPUyBv
ciBoYXJkd2FyZQpjb250cm9sbGVkIFJBSUQsIEkgZG9uJ3Qga25vdyBpZiBJJ2QgaGF2ZSB0aGUg
b3B0aW9uIHRvIHR1cm4gdGhlIGRpc2sncwp3cml0ZSBidWZmZXIgb24gb3Igb2ZmLiAgU28gdGhh
dCBsaWtlbHkgd291bGRuJ3QgbWF0dGVyIG11Y2guCgpJZGVhbGx5LCBJIHRoaW5rLCBpdCBiZSBv
cHRpbWFsIGlmIGEgUkFJRCBjb250cm9sbGVyIChoYXJkd2FyZSBvciBzb2Z0d2FyZSkgCnJlYWxs
eSBrbmV3IHRoZSB0aGUgbGF5b3V0IG9mIHRoZSBkYXRhIG9uIGRpc2sgLS0gYXMgaW4gc2VjdG9y
cy90cmFjay4KVGhlbiBpdCByZWFsbHkgbWlnaHQgYmUgYWJsZSB0byBpbnRlcmxlYXZlIHRyYWNr
cyBhbW9uZyBkaXNrIHVuaXRzICh1bmxlc3MKYWxsIHRoZSB0cmFja3MgY2FuIGJlIHdyaXR0ZW4g
Y29udGlndW91c2x5IHcvbm8gZGVsYXksIHRoZW4gSSdkIGd1ZXNzIHRoZXJlJ2QKYmUgbm8gYmVu
ZWZpdC4uLm9oIHdlbGwuLgoKQnV0IGhvdyBkb2VzIG9uZSBkZWNpZGUgYSBzdHJpcCBzaXplIGZv
ciBSQUlEIGRpc2tzPwoKV2hhdCBjcml0ZXJpYSBkb2VzIG9uZSB1c2U/CgpUaGFua3MhCi1saW5k
YQoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
