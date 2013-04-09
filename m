Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7084A29DFA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 07:53:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4ED25304053
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 05:53:50 -0700 (PDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	xAbocTzGHCkUIpR1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 05:53:49 -0700 (PDT)
Received: by mail-ie0-f180.google.com with SMTP id a11so8222856iee.39
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 05:53:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 20:53:48 +0800
Message-ID: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
Subject: need help how to debug xfs crash issue xfs_iunlink_remove:
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
To: xfs@oss.sgi.com

RGVhciB4ZnMgZXhwZXJ0cywKSSByZWFsbHkgbmVlZCB5b3VyIGhlbHAgc2luY2VyZWx5ISEhIElu
IG91ciBwcm9kdWN0aW9uIGVudmlyb21lbnQgd2UKcnVuIGdsdXN0ZXJmcyBvdmVyIHRvcCBvZiB4
ZnMgb24gRGVsbCB4NzIwRChSYWlkIDYpLiBBbmQgdGhlIHhmcyBmaWxlCnN5c3RlbSBjcmFzaCBv
biBzb21lIG9mIHRoZSBzZXJ2ZXIgZnJlcXVlbnRseSBhYm91dCBldmVyeSB0d28gd2Vla3MuCkNh
biB5b3UgaGVscCB0byBnaXZlIG1lIGEgZGlyZWN0aW9uIGFib3V0IGhvdyB0byBkZWJ1ZyB0aGlz
IGlzc3VlIGFuZApob3cgdG8gYXZvaWQgaXQ/IFRoYW5rIHlvdSB2ZXJ5IHZlcnkgbXVjaCEKCnVu
YW1lIC1hCkxpbnV4IGNxZHgubWlhb3lhbi5jbHVzdGVyMS5ub2RlMTEucWl5aS5kb21haW4gMi42
LjMyLTI3OS5lbDYueDg2XzY0CiMxIFNNUCBXZWQgSnVuIDEzIDE4OjI0OjM2IEVEVCAyMDEyIHg4
Nl82NCB4ODZfNjQgeDg2XzY0IEdOVS9MaW51eAoKRXZlcnkgdGltZSB0aGUgY3Jhc2ggbG9nIGlz
IHNhbWUsIGFzIGZvbGxvd2luZwoKMDM4IEFwciAgOSAwOTo0MTozNiBjcWR4IGtlcm5lbDogWEZT
IChzZGIpOiB4ZnNfaXVubGlua19yZW1vdmU6Cnhmc19pbm90b2JwKCkgcmV0dXJuZWQgZXJyb3Ig
MjIuCjEwMzkgQXByICA5IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19pbmFj
dGl2ZTogeGZzX2lmcmVlCnJldHVybmVkIGVycm9yIDIyCjEwNDAgQXByICA5IDA5OjQxOjM2IGNx
ZHgga2VybmVsOiBYRlMgKHNkYik6Cnhmc19kb19mb3JjZV9zaHV0ZG93bigweDEpIGNhbGxlZCBm
cm9tIGxpbmUgMTE4NCBvZiBmaWxlCmZzL3hmcy94ZnNfdm5vZGVvcHMuYy4gIFJldHVybiBhZGRy
ZXNzID0gMHhmZmZmZmZmZmEwMmVlMjBhCjEwNDEgQXByICA5IDA5OjQxOjM2IGNxZHgga2VybmVs
OiBYRlMgKHNkYik6IEkvTyBFcnJvciBEZXRlY3RlZC4KU2h1dHRpbmcgZG93biBmaWxlc3lzdGVt
CjEwNDIgQXByICA5IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IFBsZWFzZSB1bW91
bnQgdGhlCmZpbGVzeXN0ZW0gYW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykKMTA0MyBBcHIgIDkg
MDk6NDE6NTMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNSBy
ZXR1cm5lZC4KMTA0NCBBcHIgIDkgMDk6NDI6MjMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZz
X2xvZ19mb3JjZTogZXJyb3IgNSByZXR1cm5lZC4KMTA0NSBBcHIgIDkgMDk6NDI6NTMgY3FkeCBr
ZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNSByZXR1cm5lZC4KMTA0NiBB
cHIgIDkgMDk6NDM6MjMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJy
b3IgNSByZXR1cm5lZC4KCi0tIAq3+9PAzM4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
