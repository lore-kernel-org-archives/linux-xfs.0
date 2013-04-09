Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD59629DFA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:03:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F4F7304066
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 06:03:12 -0700 (PDT)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	4jH8sc80eadOk0nZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 06:03:06 -0700 (PDT)
Received: by mail-ie0-f178.google.com with SMTP id bn7so8546339ieb.9
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 06:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
Date: Tue, 9 Apr 2013 21:03:06 +0800
Message-ID: <CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
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
To: xfs@oss.sgi.com, yongtaofu@gmail.com

QlRXCnhmc19pbmZvIC9kZXYvc2RiCm1ldGEtZGF0YT0vZGV2L3NkYiAgICAgICAgICAgICAgIGlz
aXplPTI1NiAgICBhZ2NvdW50PTI4LCBhZ3NpemU9MjY4NDM1NDQwIGJsa3MKICAgICAgICAgPSAg
ICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIGF0dHI9MgpkYXRhICAgICA9ICAgICAg
ICAgICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgYmxvY2tzPTczMjQzMDMzNjAsIGltYXhwY3Q9
NQogICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzdW5pdD0xNiAgICAgc3dpZHRoPTE2
MCBibGtzCm5hbWluZyAgID12ZXJzaW9uIDIgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBhc2Np
aS1jaT0wCmxvZyAgICAgID1pbnRlcm5hbCAgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBibG9j
a3M9NTIxNzI4LCB2ZXJzaW9uPTIKICAgICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2Vj
dHN6PTUxMiAgIHN1bml0PTE2IGJsa3MsIGxhenktY291bnQ9MQpyZWFsdGltZSA9bm9uZSAgICAg
ICAgICAgICAgICAgICBleHRzej00MDk2ICAgYmxvY2tzPTAsIHJ0ZXh0ZW50cz0wCgoyMDEzLzQv
OSwgt/vTwMzOIDx5b25ndGFvZnVAZ21haWwuY29tPjoKPiBEZWFyIHhmcyBleHBlcnRzLAo+IEkg
cmVhbGx5IG5lZWQgeW91ciBoZWxwIHNpbmNlcmVseSEhISBJbiBvdXIgcHJvZHVjdGlvbiBlbnZp
cm9tZW50IHdlCj4gcnVuIGdsdXN0ZXJmcyBvdmVyIHRvcCBvZiB4ZnMgb24gRGVsbCB4NzIwRChS
YWlkIDYpLiBBbmQgdGhlIHhmcyBmaWxlCj4gc3lzdGVtIGNyYXNoIG9uIHNvbWUgb2YgdGhlIHNl
cnZlciBmcmVxdWVudGx5IGFib3V0IGV2ZXJ5IHR3byB3ZWVrcy4KPiBDYW4geW91IGhlbHAgdG8g
Z2l2ZSBtZSBhIGRpcmVjdGlvbiBhYm91dCBob3cgdG8gZGVidWcgdGhpcyBpc3N1ZSBhbmQKPiBo
b3cgdG8gYXZvaWQgaXQ/IFRoYW5rIHlvdSB2ZXJ5IHZlcnkgbXVjaCEKPgo+IHVuYW1lIC1hCj4g
TGludXggY3FkeC5taWFveWFuLmNsdXN0ZXIxLm5vZGUxMS5xaXlpLmRvbWFpbiAyLjYuMzItMjc5
LmVsNi54ODZfNjQKPiAjMSBTTVAgV2VkIEp1biAxMyAxODoyNDozNiBFRFQgMjAxMiB4ODZfNjQg
eDg2XzY0IHg4Nl82NCBHTlUvTGludXgKPgo+IEV2ZXJ5IHRpbWUgdGhlIGNyYXNoIGxvZyBpcyBz
YW1lLCBhcyBmb2xsb3dpbmcKPgo+IDAzOCBBcHIgIDkgMDk6NDE6MzYgY3FkeCBrZXJuZWw6IFhG
UyAoc2RiKTogeGZzX2l1bmxpbmtfcmVtb3ZlOgo+IHhmc19pbm90b2JwKCkgcmV0dXJuZWQgZXJy
b3IgMjIuCj4gMTAzOSBBcHIgIDkgMDk6NDE6MzYgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZz
X2luYWN0aXZlOiB4ZnNfaWZyZWUKPiByZXR1cm5lZCBlcnJvciAyMgo+IDEwNDAgQXByICA5IDA5
OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6Cj4geGZzX2RvX2ZvcmNlX3NodXRkb3duKDB4
MSkgY2FsbGVkIGZyb20gbGluZSAxMTg0IG9mIGZpbGUKPiBmcy94ZnMveGZzX3Zub2Rlb3BzLmMu
ICBSZXR1cm4gYWRkcmVzcyA9IDB4ZmZmZmZmZmZhMDJlZTIwYQo+IDEwNDEgQXByICA5IDA5OjQx
OjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IEkvTyBFcnJvciBEZXRlY3RlZC4KPiBTaHV0dGlu
ZyBkb3duIGZpbGVzeXN0ZW0KPiAxMDQyIEFwciAgOSAwOTo0MTozNiBjcWR4IGtlcm5lbDogWEZT
IChzZGIpOiBQbGVhc2UgdW1vdW50IHRoZQo+IGZpbGVzeXN0ZW0gYW5kIHJlY3RpZnkgdGhlIHBy
b2JsZW0ocykKPiAxMDQzIEFwciAgOSAwOTo0MTo1MyBjcWR4IGtlcm5lbDogWEZTIChzZGIpOiB4
ZnNfbG9nX2ZvcmNlOiBlcnJvciA1Cj4gcmV0dXJuZWQuCj4gMTA0NCBBcHIgIDkgMDk6NDI6MjMg
Y3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNQo+IHJldHVybmVk
Lgo+IDEwNDUgQXByICA5IDA5OjQyOjUzIGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19sb2df
Zm9yY2U6IGVycm9yIDUKPiByZXR1cm5lZC4KPiAxMDQ2IEFwciAgOSAwOTo0MzoyMyBjcWR4IGtl
cm5lbDogWEZTIChzZGIpOiB4ZnNfbG9nX2ZvcmNlOiBlcnJvciA1Cj4gcmV0dXJuZWQuCj4KPiAt
LQo+ILf708DMzgo+CgoKLS0gCrf708DMzgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
