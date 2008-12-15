Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFMd6NB012943 for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 16:39:08 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 087D622F9F
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 14:39:03 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	sIiOyL9TXWyWXKDj for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2008 14:39:03 -0800 (PST)
Date: Tue, 16 Dec 2008 09:38:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Message-ID: <20081215223857.GF32301@disturbed>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <18757.33373.744917.457587@tree.ty.sabi.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>

T24gU3VuLCBEZWMgMTQsIDIwMDggYXQgMTA6MDI6MDVQTSArMDAwMCwgUGV0ZXIgR3JhbmRpIHdy
b3RlOgo+IFsgLi4uIF0KPiAKPiA+IEJ1dCAtIGFzIGZhciBhcyBJIHVuZGVyc3Rvb2QgLSB0aGUg
ZmlsZXN5c3RlbSBkb2Vzbid0IGhhdmUgdG8KPiA+IHdhaXQgZm9yIGJhcnJpZXJzIHRvIGNvbXBs
ZXRlLCBidXQgY291bGQgY29udGludWUgaXNzdWluZyBJTwo+ID4gcmVxdWVzdHMgaGFwcGlseS4g
QSBiYXJyaWVyIG9ubHkgbWVhbnMsIGFueSByZXF1ZXN0IHByaW9yIHRvCj4gPiB0aGF0IGhhdmUg
dG8gbGFuZCBiZWZvcmUgYW5kIGFueSBhZnRlciBpdCBhZnRlciBpdC4KPiAKPiA+IEl0IGRvZXNu
J3QgbWVhbiB0aGF0IHRoZSBiYXJyaWVyIGhhcyB0byBsYW5kIGltbWVkaWF0ZWx5IGFuZAo+ID4g
dGhlIGZpbGVzeXN0ZW0gaGFzIHRvIHdhaXQgZm9yIHRoaXMuIEF0IGxlYXN0IHRoYXQgYWx3YXlz
IHdhcwo+ID4gdGhlIHdob2xlIHBvaW50IG9mIGJhcnJpZXJzIGZvciBtZS4gSWYgdGhhdHMgbm90
IHRoZSBjYXNlIEkKPiA+IG1pc3VuZGVyc3Rvb2QgdGhlIHB1cnBvc2Ugb2YgYmFycmllcnMgdG8g
dGhlIG1heGltdW0gZXh0ZW50Cj4gPiBwb3NzaWJsZS4KPiAKPiBVbmZvcnR1bmF0ZWx5IHRoYXQg
c2VlbXMgdGhlIGNhc2UuCj4gCj4gVGhlIHB1cnBvc2Ugb2YgYmFycmllcnMgaXMgdG8gZ3VhcmFu
dGVlIHRoYXQgcmVsZXZhbnQgZGF0YSBpcwo+IGtub3duIHRvIGJlIG9uIHBlcnNpc3RlbnQgc3Rv
cmFnZSAoa2luZCBvZiBoYXJkd2FyZSAnZnN5bmMnKS4KPiAKPiBJbiBlZmZlY3Qgd3JpdGUgYmFy
cmllciBtZWFucyAidGVsbCBtZSB3aGVuIHJlbGV2YW50IGRhdGEgaXMgb24KPiBwZXJzaXN0ZW50
IHN0b3JhZ2UiLCBvciBsZXNzIHByZWNpc2VseSAiZmx1c2gvc3luYyB3cml0ZXMgbm93Cj4gYW5k
IHRlbGwgbWUgd2hlbiBpdCBpcyBkb25lIi4gUHJvcGVydGllcyBhcyB0byBvcmRlcmluZyBhcmUg
anVzdAo+IGEgc2lkZSBlZmZlY3QuCgpObywgdGhhdCBpcyBpbmNvcnJlY3QuCgpCYXJyaWVycyBw
cm92aWRlIHN0cm9uZyBvcmRlcmluZyBzZW1hbnRpY3MuICBJL09zIGlzc3VlZCBiZWZvcmUgdGhl
CmJhcnJpZXIgbXVzdCBiZSBjb21wbGV0ZWQgYmVmb3JlIHRoZSBiYXJyaWVyIEkvTywgYW5kIEkv
T3MgaXNzdWVkCmFmdGVyIHRoZSBiYXJyaWVyIHdyaXRlIG11c3Qgbm90IGJlIHN0YXJ0ZWQgYmVm
b3JlIHRoZSBiYXJyaWVyIHdyaXRlCmNvbXBsZXRlcy4gVGhlIGVsZXZhdG9ycyBhcmUgbm90IGFs
bG93ZWQgdG8gcmUt0L5yZGVyIEkvT3MgYXJvdW5kCmJhcnJpZXJzLgoKVGhpcyBpcyBhbGwgZG9j
dW1lbnRlZCBpbiBEb2N1bWVudGF0aW9uL2Jsb2NrL2JhcnJpZXIudHh0LiBQbGVhc2UKcmVhZCBp
dCBiZWNhdXNlIG1vc3Qgb2Ygd2hhdCB5b3UgYXJlIHNheWluZyBhcHBlYXJzIHRvIGJlIGJhc2Vk
IG9uCmluY29ycmVjdCBhc3N1bXB0aW9ucyBhYm91dCB3aGF0IGJhcnJpZXJzIGRvLgoKQ2hlZXJz
LAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
