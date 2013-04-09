Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6A617FAF
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:06:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A529730406A
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:06:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MWbLlcqaBAlzqSGY for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:06:07 -0700 (PDT)
Message-ID: <51642E5E.3040403@sandeen.net>
Date: Tue, 09 Apr 2013 10:06:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
In-Reply-To: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
Cc: xfs@oss.sgi.com

T24gNC85LzEzIDc6NTMgQU0sILf708DMziB3cm90ZToKPiBEZWFyIHhmcyBleHBlcnRzLAo+IEkg
cmVhbGx5IG5lZWQgeW91ciBoZWxwIHNpbmNlcmVseSEhISBJbiBvdXIgcHJvZHVjdGlvbiBlbnZp
cm9tZW50IHdlCj4gcnVuIGdsdXN0ZXJmcyBvdmVyIHRvcCBvZiB4ZnMgb24gRGVsbCB4NzIwRChS
YWlkIDYpLiBBbmQgdGhlIHhmcyBmaWxlCj4gc3lzdGVtIGNyYXNoIG9uIHNvbWUgb2YgdGhlIHNl
cnZlciBmcmVxdWVudGx5IGFib3V0IGV2ZXJ5IHR3byB3ZWVrcy4KPiBDYW4geW91IGhlbHAgdG8g
Z2l2ZSBtZSBhIGRpcmVjdGlvbiBhYm91dCBob3cgdG8gZGVidWcgdGhpcyBpc3N1ZSBhbmQKPiBo
b3cgdG8gYXZvaWQgaXQ/IFRoYW5rIHlvdSB2ZXJ5IHZlcnkgbXVjaCEKClNvIHRoaXMgaGFwcGVu
cyByZWxpYWJseSwgYnV0IGluZnJlcXVlbnRseT8gKG9ubHkgZXZlcnkgMiB3ZWVrcyBvciBzbz8p
CgpDYW4geW91IHByb3Zva2UgaXQgYW55IG1vcmUgb2Z0ZW4/Cgo+IHVuYW1lIC1hCj4gTGludXgg
Y3FkeC5taWFveWFuLmNsdXN0ZXIxLm5vZGUxMS5xaXlpLmRvbWFpbiAyLjYuMzItMjc5LmVsNi54
ODZfNjQKPiAjMSBTTVAgV2VkIEp1biAxMyAxODoyNDozNiBFRFQgMjAxMiB4ODZfNjQgeDg2XzY0
IHg4Nl82NCBHTlUvTGludXgKClRoYXQncyBhIFJIRUw2IGtlcm5lbDsgSSdtIGFzc3VtaW5nIHRo
YXQgdGhpcyBpcyBhIFJIRUwgY2xvbmUgdy9vIFJIIHN1cHBvcnQ/CgpJIGFncmVlIHdpdGggQmVu
IHRoYXQgSSdkIGxpa2UgdG8gc2VlIHhmc19yZXBhaXIgb3V0cHV0LgoKU2luY2UgdGhlIGZzIGhh
cyBzaHV0IGRvd24sIHlvdSBzaG91bGQgdW5tb3VudCwgcmVtb3VudCwgYW5kIHVubW91bnQKYWdh
aW4gdG8gcmVwbGF5IHRoZSBkaXJ0eSBsb2cuICBUaGVuIGRvIHhmc19yZXBhaXIgLW4sIGFuZCBw
cm92aWRlIHRoZSBvdXRwdXQKaWYgaXQgZGlzY292ZXJzIGFueSBlcnJvcnMuCgpUaGFua3MsCi1F
cmljCgo+IEV2ZXJ5IHRpbWUgdGhlIGNyYXNoIGxvZyBpcyBzYW1lLCBhcyBmb2xsb3dpbmcKPiAK
PiAwMzggQXByICA5IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19pdW5saW5r
X3JlbW92ZToKPiB4ZnNfaW5vdG9icCgpIHJldHVybmVkIGVycm9yIDIyLgo+IDEwMzkgQXByICA5
IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19pbmFjdGl2ZTogeGZzX2lmcmVl
Cj4gcmV0dXJuZWQgZXJyb3IgMjIKPiAxMDQwIEFwciAgOSAwOTo0MTozNiBjcWR4IGtlcm5lbDog
WEZTIChzZGIpOgo+IHhmc19kb19mb3JjZV9zaHV0ZG93bigweDEpIGNhbGxlZCBmcm9tIGxpbmUg
MTE4NCBvZiBmaWxlCj4gZnMveGZzL3hmc192bm9kZW9wcy5jLiAgUmV0dXJuIGFkZHJlc3MgPSAw
eGZmZmZmZmZmYTAyZWUyMGEKPiAxMDQxIEFwciAgOSAwOTo0MTozNiBjcWR4IGtlcm5lbDogWEZT
IChzZGIpOiBJL08gRXJyb3IgRGV0ZWN0ZWQuCj4gU2h1dHRpbmcgZG93biBmaWxlc3lzdGVtCj4g
MTA0MiBBcHIgIDkgMDk6NDE6MzYgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogUGxlYXNlIHVtb3Vu
dCB0aGUKPiBmaWxlc3lzdGVtIGFuZCByZWN0aWZ5IHRoZSBwcm9ibGVtKHMpCj4gMTA0MyBBcHIg
IDkgMDk6NDE6NTMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3Ig
NSByZXR1cm5lZC4KPiAxMDQ0IEFwciAgOSAwOTo0MjoyMyBjcWR4IGtlcm5lbDogWEZTIChzZGIp
OiB4ZnNfbG9nX2ZvcmNlOiBlcnJvciA1IHJldHVybmVkLgo+IDEwNDUgQXByICA5IDA5OjQyOjUz
IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19sb2dfZm9yY2U6IGVycm9yIDUgcmV0dXJuZWQu
Cj4gMTA0NiBBcHIgIDkgMDk6NDM6MjMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19m
b3JjZTogZXJyb3IgNSByZXR1cm5lZC4KPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
