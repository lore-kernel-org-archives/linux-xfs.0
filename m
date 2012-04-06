Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q36FbX7C000505 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 10:37:34 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id Edc7C1hKtIhYNbTW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Apr 2012 08:37:33 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so1746960yhj.26
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 08:37:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20350.65390.662663.682964@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20349.63706.913104.777446@tree.ty.sabi.co.UK>
	<20350.65390.662663.682964@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 17:37:32 +0200
Message-ID: <CAAxjCEwNAOMUypaORP=BcJmdT3=GBykAYFjJD54_ixnLc+O6SQ@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

PiBBcyB0byAnZXh0NCcgYW5kIGRvaW5nIChldXBoZW1pc20pIGluc2lwaWQgdGVzdHMgaW52b2x2
aW5nCj4gcGVjdWxpYXIgc2V0dXBzLCB0aGVyZSBpcyBhbiBpbnRlcmVzdGluZyBzdG9yeSBpbiB0
aGlzIHBvc3Q6Cj4KPiDCoGh0dHA6Ly9vc3Muc2dpLmNvbS9hcmNoaXZlcy94ZnMvMjAxMi0wMy9t
c2cwMDQ2NS5odG1sCgpJIHJlYWxseSBkb24ndCBzZWUgdGhlIGNvbm5lY3Rpb24gdG8gdGhpcyB0
aHJlYWQuIFlvdSdyZSBhZHZvY2F0aW5nCm1vc3RseSB0aGF0IHRhciB1c2UgZnN5bmMgb24gZXZl
cnkgZmlsZSwgd2hpY2ggdG8gbWUgc2VlbXMgYWJzdXJkLiBJZgp0aGUgc3lzdGVtIGdvZXMgZG93
biBoYWxmd2F5IHRocm91Z2ggdGFyIGV4dHJhY3Rpb24sIEkgd291bGQgZGVsZXRlCnRoZSB0cmVl
IGFuZCB1bnRhciBhZ2Fpbi4gV2hhdCBkbyBJIGNhcmUgaWYgc29tZSBmaWxlcyBhcmUgY29ycnVw
dCwKd2hlbiB0aGUgZW50aXJlIHRyZWUgaXMgaW5jb21wbGV0ZSBhbnl3YXk/CgpEZXNwaXRlIHRo
ZSBzb21ld2hhdCBpbmZsYW1tYXRvcnkgdGhyZWFkIHN1YmplY3QsIEkgZG9uJ3Qgd2FudCB0byBi
YXNoCmFueW9uZS4gSXQncyBqdXN0IHRoYXQgdW50YXJyaW5nIGxhcmdlIHNvdXJjZSB0cmVlcyBp
cyBhIHZlcnkgdHlwaWNhbAp3b3JrbG9hZCBmb3IgbWUuIEFuZCBJIGp1c3QgZG9uJ3Qgd2FudCB0
byBhY2NlcHQgdGhhdCBYRlMgY2Fubm90IGRvCmJldHRlciB0aGFuIGJlaW5nIHNldmVyYWwgb3Jk
ZXJzIG9mIG1hZ25pdHVkZSBzbG93ZXIgdGhhbiBleHQ0CihzcGVha2luZyBvZiBiaW5hcnkgb3Jk
ZXJzIG9mIG1hZ25pdHVkZSkuIEFzIEkgc2VlIGl0LCBib3RoIGZpbGUKc3lzdGVtcyBnaXZlIHRo
ZSBzYW1lIGd1YXJhbnRlZXM6CgoxKSBUaGF0IHVwb24gY29tcGxldGlvbiBvZiBzeW5jLCBhbGwg
ZGF0YSBpcyByZWFkaWx5IGF2YWlsYWJsZSBvbgpwZXJtYW5lbnQgc3RvcmFnZS4KMikgVGhhdCB0
aGUgZmlsZSBzeXN0ZW0gbWV0YWRhdGEgZG9lc24ndCBzdWZmZXIgY29ycnVwdGlvbiwgc2hvdWxk
IHRoZQpzeXN0ZW0gbG9zZSBwb3dlciBkdXJpbmcgdGhlIG9wZXJhdGlvbi4KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
