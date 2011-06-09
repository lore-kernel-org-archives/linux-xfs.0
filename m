Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59FuSpM186643 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 10:56:28 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63B0BF4EA24
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 08:56:24 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id W83RdUqD8eJcLgK8
	for <xfs@oss.sgi.com>; Thu, 09 Jun 2011 08:56:24 -0700 (PDT)
Received: by fxm8 with SMTP id 8so1177151fxm.26
	for <xfs@oss.sgi.com>; Thu, 09 Jun 2011 08:56:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jun 2011 08:56:24 -0700
Message-ID: <BANLkTi=tj1azoQ6vpTWFpH866erD+trwXg@mail.gmail.com>
Subject: Problems with xfs_fsr stdout when run by cron.
From: Larry Johnson <keepitsimpleengineer@gmail.com>
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

VGhpcyBpcyBvbiBhIHVidW50dSAxMC4xMCA2NGJpdCBteXRodHYgc3lzdGVtLgoKcm9vdEBodHBj
On4jIGRmIC1oIC1sIC1UIC0tdG90YWwgLXQgeGZzCkZpbGVzeXN0ZW0gICAgVHlwZSAgICBTaXpl
ICBVc2VkIEF2YWlsIFVzZSUgTW91bnRlZCBvbgovZGV2L3NkYTMgICAgICB4ZnMgICAgMTQ0RyAg
MTE4RyAgIDI2RyAgODIlIC9pc28KL2Rldi9zZGIxICAgICAgeGZzICAgIDEuOVQgIDEuNFQgIDQz
M0cgIDc3JSAvcHZyCi9kZXYvc2RjMSAgICAgIHhmcyAgICAxLjlUICAyMjZHICAxLjZUICAxMyUg
L3B2cwp0b3RhbCAgICAgICAgICAgIC0gICAgMy44VCAgMS44VCAgMi4xVCAgNDYlCgpJIGhhZCBz
ZXZlcmUgZnJhZ21lbnRhdGlvbiBvbiAvZGV2L3NkYjEgd2hpY2ggd2FzIHJlc29sdmVkIGJ5IHJ1
bm5pbmcKeGZzX2ZzciBhYm91dCAxMCB0aW1lcy4gIFN1YnNlcXVlbnRseSBJIGhhdmUgYWRkZWQg
L2Rldi9zZGMxLgoKVGhlIHByb2JsZW0gb2NjdXJzIHdoZW4gSSB3cm90ZSBhIHNjcmlwdCB0byBi
ZSBydW4gd2l0aCBjcm9uLApyZW9yZ2FuaXplIHRoZSB4ZnMgcGFydGl0aW9ucyBhbmQgd3JpdGUg
YSByZXBvcnQgaW4gL3Zhci9sb2cgYW5kIHdyaXRlCmEgbGluZSBvciB0d28gaW4gc3lzbG9nLgoK
VGhlIG91dHB1dCBvZiAieGZzX2ZzciAtdiAtdCAkdGltZV9mb3JfcnVuIC1mICRsZWZ0X29mZiAt
bSAkdXNlZF9tdGFiIgp3aGVuIHJ1biBhcyBjcm9uIGVpdGhlciBnb2VzIHRvIHN5c2xvZyBpbnN0
ZWFkIG9mIHN0ZG91dCBvciBjb3JydXB0cwp0aGUgbG9nIGZpbGUuICBXaGVuIHJ1biBmcm9tIGEg
bG9naW4gdGVybWluYWwsIGl0IGJlaGF2ZXMgYXMgZXhwZWN0ZWQuCgpBIHRocmVhZCBhdCB1bml4
LmNvbSBmb3J1bSBoYXZlIG5vdCByZXN1bHRlZCBpbiBleHBsYWluaW5nIHRoaXMKYmVoYXZpb3Iu
ICBodHRwOi8vd3d3LnVuaXguY29tL3VuaXgtYWR2YW5jZWQtZXhwZXJ0LXVzZXJzLzE2MDk3OS1k
aWZmZXJlbnQtcmVkaXJlY3Rpb24tYmVoYXZpb3ItYmFzaC1saW51eC13aGVuLXJ1bi11bmRlci1j
cm9uLXZpY2UtbG9naW4uaHRtbCNwb3N0MzAyNTI5NDc1CgpJbml0aWFsbHkgSSB0aG91Z2h0IGl0
IHdhcyBzb21lIGVycm9yIG9uIG15IHBhcnQgYnV0IEkgY2Fubm90IHJ1bGUgb3V0CnNvbWUgcHJv
YmxlbSB3aXRoIHhmc19mc3IuICAieGZzX2RiIC1yIC1jIGZyYWcgJGRldmljZV9maWxlX3BhdGgg
Mj4mMSIKcnVuIGJvdGggYmVmb3JlIGFuZCBhZnRlciB4ZnNfZnNyIGJvdGggYmVoYXZlIGFzIGV4
cGVjdGVkIHdoZW4gcnVuIGJ5CmNyb24gb3IgZnJvbSBhIGxvZ2luIHNlc3Npb24uCgpBbnlib2R5
IGhhdmUgYW55IHN1Z2dlc3Rpb25zPwoK4ouvbGFycnkKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
