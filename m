Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F64E7F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 07:14:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5CEAAC004
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 05:14:26 -0800 (PST)
Received: from mail-pb0-f49.google.com (mail-pb0-f49.google.com
	[209.85.160.49]) by cuda.sgi.com with ESMTP id mRiGyP1z22YqFsJ1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 Jan 2014 05:14:25 -0800 (PST)
Received: by mail-pb0-f49.google.com with SMTP id jt11so7284107pbb.36
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 05:14:25 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 1/2] xfstests: make btrfs/001.out in line with subvol
	delete output
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
Date: Mon, 13 Jan 2014 21:14:22 +0800
Message-Id: <5A6081D2-68E6-47BC-A534-6502B680DDDD@gmail.com>
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
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
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

SGVsbG8gQW5hbmQsCgpJIHdhcyBub3RpY2luZyB0aGlzIHByb2JsZW0gd2hlbiB1c2luZyB0aGUg
bGF0ZXN0IGJ0cmZzLXByb2dzIHRvIHRlc3QgXl9eCgpJIHRoaW5rIGEgYmV0dGVyIHdheSBpcyB0
byBmaWx0ZXIgbWVzc2FnZSAnVHJhbnNhY3Rpb24gY29tbWl0OiBub25lIChkZWZhdWx0KScKUmF0
aGVyIHRoYW4gYWRkIGl0LCBvdGhlcndpc2UsIHBlb3BsZSB3aWxsIGZhaWwgdGhpcyB0ZXN0IGlm
IHRoZXkgdXNlIHByZXZpb3VzCmJ0cmZzLXByb2dzoa2hrQoKVGhhbmtzLApXYW5nCj4gRnJvbTog
QW5hbmQgSmFpbiA8QW5hbmQuSmFpbkBvcmFjbGUuY29tPgo+IAo+IGJ0cmZzLzAwMSBpcyBmYWls
aW5nIGFzIGJlbG93IGJ0cmZzLXByb2dzIHBhdGNoIGNoYW5nZWQgdGhlCj4gb3V0cHV0IGR1cmlu
ZyBzdWJ2b2wgZGVsZXRlLgo+IFBhdGNoIDoKPiBidHJmcy1wcm9nczogYWRkIG9wdGlvbnMgdG8g
c2V0IGNvbW1pdCBtb2RlIGFmdGVyIHN1YnZvbCBkZWxldGUKPiAKPiBzbyBhZGQgaXQgdG8gdGhl
IGJ0cmZzLzAwMS5vdXQKPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbmFuZCBKYWluIDxBbmFuZC5KYWlu
QG9yYWNsZS5jb20+Cj4gLS0tCj4gdGVzdHMvYnRyZnMvMDAxLm91dCB8IDEgKwo+IDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKQo+IAo+IGRpZmYgLS1naXQgYS90ZXN0cy9idHJmcy8wMDEu
b3V0IGIvdGVzdHMvYnRyZnMvMDAxLm91dAo+IGluZGV4IGM3ODJiZGUuLmEyNTU2MTQgMTAwNjQ0
Cj4gLS0tIGEvdGVzdHMvYnRyZnMvMDAxLm91dAo+ICsrKyBiL3Rlc3RzL2J0cmZzLzAwMS5vdXQK
PiBAQCAtMzMsNiArMzMsNyBAQCBzdWJ2b2wKPiBMaXN0aW5nIHN1YnZvbHVtZXMKPiBzbmFwCj4g
c3Vidm9sCj4gK1RyYW5zYWN0aW9uIGNvbW1pdDogbm9uZSAoZGVmYXVsdCkKPiBEZWxldGUgc3Vi
dm9sdW1lICdTQ1JBVENIX01OVC9zbmFwJwo+IExpc3Qgcm9vdCBkaXIKPiBzdWJ2b2wKPiAtLSAK
PiAxLjguNC4yCj4gCj4gLS0KPiBUbyB1bnN1YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0
aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgtYnRyZnMiIGluCj4gdGhlIGJvZHkgb2YgYSBtZXNz
YWdlIHRvIG1ham9yZG9tb0B2Z2VyLmtlcm5lbC5vcmcKPiBNb3JlIG1ham9yZG9tbyBpbmZvIGF0
ICBodHRwOi8vdmdlci5rZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
