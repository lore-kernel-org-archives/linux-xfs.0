Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1EhZIe141923
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 08:43:35 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B452E14EC26A
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 06:44:04 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id kjYZslGF7su2cB28 for
	<linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 06:44:04 -0800 (PST)
Message-ID: <4B152BAD.1000004@sandeen.net>
Date: Tue, 01 Dec 2009 08:43:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>	<4B14936F.7040401@sandeen.net>	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>	<4B14B077.5090500@sandeen.net>
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>
In-Reply-To: <389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

aGFuayBwZW5nIHdyb3RlOgoKPiBUb2RheSwgSSBlbmNvdW50ZXJlZCBhIHByb2JsZW06Cj4gSSB1
c2UgInhmc19yZXBhaXIgLUwg4oCcIG9uIGEgZGFtYWdlZCBmaWxlc3lzdGVtIGFuZCBhIGxvdCBv
ZiBtZXNzYWdlcwoKd2h5IGRpZCB5b3UgdXNlIC1MLCBkaWQgaXQgZmFpbCB0byBtb3VudCAmIHJl
cGxheSB0aGUgbG9nIHByb3Blcmx5PwoKPiBvdXRwdXQgd2hpY2ggaW5jbHVkZSAibW92aW5nIGRp
c2Nvbm5lY3RlZCBpbm9kZXMgdG8gbG9zdCtmb3VuZCAuLi4iLgo+IFRoZW4gSSBjYW4gcmVtb3Vu
dCB0aGUgZmlsZXN5c3RlbSBzdWNjZXNzZnVsbHkgYW5kIGRlY2lkZWQgdG8gcmVtb3ZlCj4gdGhv
c2UgZmlsZXMgaW4gbG9zdCtmb3VuZCBkaXJlY3RvcnksIGJ1dCBpdCBwcmludGVkIHRoZSBmb2xs
b3dpbmcKPiBtZXNzYWdlOgo+IHJvb3RAMTIzNGRhaHVhOi9tbnQvUG9vbF9tZDEvc3MxL2xvc3Qr
Zm91bmQjIHJtIC1yZiAqCj4gcm06IGNhbm5vdCBzdGF0ICc3MTAnOiBTdHJ1Y3R1cmUgbmVlZHMg
Y2xlYW5pbmcKPiBybTogY2Fubm90IHN0YXQgJzcyOCc6IFN0cnVjdHVyZSBuZWVkcyBjbGVhbmlu
Zwo+IHJtOiBjYW5ub3Qgc3RhdCAnNzI5JzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4gcm06
IGNhbm5vdCBzdGF0ICc3MzAnOiBTdHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcKPiBybTogY2Fubm90
IHN0YXQgJzczMSc6IFN0cnVjdHVyZSBuZWVkcyBjbGVhbmluZwo+IHJtOiBjYW5ub3Qgc3RhdCAn
NzMyJzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4gcm06IGNhbm5vdCBzdGF0ICc3MzMnOiBT
dHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcKPiBybTogY2Fubm90IHN0YXQgJzczNCc6IFN0cnVjdHVy
ZSBuZWVkcyBjbGVhbmluZwo+IHJtOiBjYW5ub3Qgc3RhdCAnNzM1JzogU3RydWN0dXJlIG5lZWRz
IGNsZWFuaW5nCgpMb29rIGF0IGRtZXNnIHRvIHNlZSB3aGF0J3MgZ29uZSB3cm9uZy4uLi4KCj4g
T3RoZXIgZGlyZWN0b3JpZXMgYW5kIGZpbGVzIHNlZW1zIG5vcm1hbCB0byBhY2Nlc3MsIGlzIGl0
IG5vdCBhbGxvd2VkCj4gdG8gZGVsZXRlIGZpbGVzIGluIGxvc3QrZm91bmQgZGlyZWN0b3J5IGFm
dGVyIHJlcGFpciwgdGhlbiB3aGF0IHNob3VsZAo+IEkgZG8/CgpUaGlzIGlzIGluZGljYXRpdmUg
b2YgYSBidWcgb3IgSU8gZXJyb3IgdGhhdCBjYXVzZWQgeGZzIHRvIHNodXQgZG93bi4KCllvdSBo
YXZlbid0IG1lbnRpb25lZCB3aGljaCBrZXJuZWwgdmVyc2lvbiwgYXJjaGl0ZWN0dXJlLCBvcgp2
ZXJzaW9uIG9mIHhmc3Byb2dzIHlvdSdyZSB1c2luZyB5ZXQgLi4uIHRoYXQgbWF5IG9mZmVyIHNv
bWUgY2x1ZXMuCgpJJ20gZ3Vlc3NpbmcgYW4gb2xkZXIga2VybmVsIGFuZCB1c2Vyc3BhY2Ugb24g
YXJtPyA6KQoKLUVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
