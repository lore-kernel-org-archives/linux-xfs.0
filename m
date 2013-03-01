Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 761D37FAB
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 03:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08B8CAC002
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 01:20:29 -0800 (PST)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id ipolb2r5VtKvGM0z for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 01:20:27 -0800 (PST)
Date: Fri, 1 Mar 2013 04:20:18 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <220575861.7590457.1362129618880.JavaMail.root@redhat.com>
In-Reply-To: <20130228115410.GN5551@dastard>
Subject: Re: possible fsync02() xfs slowness regression on power7
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Steve Best <sbest@redhat.com>, xfs@oss.sgi.com

CgotLS0tLSDljp/lp4vpgq7ku7YgLS0tLS0KPiDlj5Hku7bkuro6ICJEYXZlIENoaW5uZXIiIDxk
YXZpZEBmcm9tb3JiaXQuY29tPgo+IOaUtuS7tuS6ujogIkNBSSBRaWFuIiA8Y2FpcWlhbkByZWRo
YXQuY29tPgo+IOaKhOmAgTogeGZzQG9zcy5zZ2kuY29tLCAiU3RldmUgQmVzdCIgPHNiZXN0QHJl
ZGhhdC5jb20+Cj4g5Y+R6YCB5pe26Ze0OiDmmJ/mnJ/lm5ssIDIwMTPlubQgMiDmnIggMjjml6Ug
5LiL5Y2IIDc6NTQ6MTAKPiDkuLvpopg6IFJlOiBwb3NzaWJsZSBmc3luYzAyKCkgeGZzIHNsb3du
ZXNzIHJlZ3Jlc3Npb24gb24gcG93ZXI3Cj4gCj4gT24gVGh1LCBGZWIgMjgsIDIwMTMgYXQgMDQ6
Mjg6MzVBTSAtMDUwMCwgQ0FJIFFpYW4gd3JvdGU6Cj4gPiBUaGlzIExUUCB0ZXN0IHN0YXJ0aW5n
IHRvIGZhaWwgdXNpbmcgdGhlIGxhdGVzdCB1cHN0cmVhbSBrZXJuZWwgb24KPiA+IG9uZSBvZiB0
aGUgcG93ZXI3Cj4gPiBzeXN0ZW1zIGhlcmUsIGh0dHA6Ly90aW55dXJsLmNvbS9ibmd3b3VqCj4g
PiAKPiA+ICMgLi9mc3luYzAyCj4gPiBmc3luYzAyICAgICAxICBURkFJTCAgOiAgZnN5bmMgdG9v
ayB0b28gbG9uZzogMjUyLjAwMDAwMCBzZWNvbmRzOwo+ID4gbWF4X2Jsb2NrOiAyMTQKPiA+IAo+
ID4gV2hlbiBpdCBpcyB3b3JraW5nLCB0aGUgdGVzdCBpcyBhbG1vc3QgcmV0dXJuZWQgaW1tZWRp
YXRlbHkuIFRoZQo+ID4gYmlzZWN0aW5nIHNvIGZhcgo+ID4gaW5kaWNhdGVkIHRoYXQgb25lIG9y
IGEgZmV3IG9mIHRoZSBmb2xsb3dpbmcgY291bGQgYmUgY3VscHJpdHMuCj4gPiAKPiA+ICMgZ2l0
IGxvZyAtLXByZXR0eT1vbmVsaW5lCj4gPiA0OThmN2Y1MDVkYzc5OTM0Yzg3OGM3NjY3ODQwYzUw
YzY0ZjIzMmZjLi5iMTk5YzhhNGJhMTE4NzlkZjg3ZGFhZDQ5NmNlZWU0MWZkYzZhYTgyCj4gCj4g
VGhleSBhcmUgYWxsIHBhdGNoZXMgY29tbWl0dGVkIG1vcmUgdGhhbiAyIHllYXJzIGFnbywgYW5k
IG5vbmUgb2YKPiB0aGVtIGFyZSBwbGF0Zm9ybSBzcGVjaWZpYy4gVGhpcyBzb3VuZHMgbW9yZSBs
aWtlIGEgbWFjaGluZSBzcGVjaWZpYwo+IGlzc3VlIHRoYW4gYSBwbGF0Zm9ybSBzcGVjaWZpYyBw
cm9ibGVtIChpLmUuIGxvdHMgb2YgUkFNLCBzbG93LAo+IHNsb3cgZGlzaykuCj4gCj4gSW4gZnV0
dXJlIHdoZW4gcmVwb3J0aW5nIGEgYnVnLCBwbGVhc2UgdGVsbCB1c2UgaGFyZHdhcmUgeW91IGFy
ZQo+IHVzaW5nIGFzIHBlcjoKPiAKPiBodHRwOi8veGZzLm9yZy9pbmRleC5waHAvWEZTX0ZBUSNR
Ol9XaGF0X2luZm9ybWF0aW9uX3Nob3VsZF9JX2luY2x1ZGVfd2hlbl9yZXBvcnRpbmdfYV9wcm9i
bGVtLjNGCj4gCj4gR2l2ZW4gdGhhdCB0aGlzIGlzIGEgc3BhcnNlIGZpbGUgdGVzdCB0aGF0IHJl
cGVhdGVkbHkgZXh0ZW5kcyB0aGUKPiBmaWxlLCB0aGlzIGlzIHRoZSBsaWtlbHkgY3VscHJpdDoK
PiAKPiA+IDA1NTM4OGEzMTg4ZjU2Njc2YzIxZTkyOTYyZmMzNjZhYzhiNWNiNzIgeGZzOiBkeW5h
bWljIHNwZWN1bGF0aXZlCj4gPiBFT0YgcHJlYWxsb2NhdGlvbgpZZXMsIHlvdSBhcmUgcmlnaHQs
IGp1c3QgY29uZmlybWVkIGl0LiBOaWNlIGNhdGNoIQo+IAo+IEFuZCB0aGlzIGNvbW1pdCBpbiAz
LjktcmMxOgo+IAo+IGExZTE2YzIgeGZzOiBsaW1pdCBzcGVjdWxhdGl2ZSBwcmVhbGxvYyBzaXpl
IG9uIHNwYXJzZSBmaWxlcwpKdXN0IGJhY2stcG9ydGVkIGl0IGFuZCBydW5uaW5nIGF0IHRoZSBt
b21lbnQgYW5kIHdpbGwgbGV0IHlvdSBrbm93LiBUaGFua3MgRGF2ZS4KPiAKPiBzaG91bGQgZml4
IHRoZSBwcm9ibGVtLiBQbGVhc2UgY29uZmlybSB0aGVzZSBjb21taXRzIGFyZSB0aGUgY2F1c2UK
PiBhbmQgdGhlIGZpeCByZXNwZWN0aXZlbHkuLi4uCj4gCj4gQ2hlZXJzLAo+IAo+IERhdmUuCj4g
LS0KPiBEYXZlIENoaW5uZXIKPiBkYXZpZEBmcm9tb3JiaXQuY29tCj4gCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
