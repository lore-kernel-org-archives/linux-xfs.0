Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88EAJZZ038779 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 09:10:19 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3B841E60785
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 07:11:03 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id S3QH2IrK0gNzKD2t for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 07:11:03 -0700 (PDT)
Message-ID: <4C87996F.2040805@kernel.org>
Date: Wed, 08 Sep 2010 16:10:55 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<4C862F8E.7030507@kernel.org> <20100908082249.GT705@dastard>
	<4C874E90.5040405@kernel.org> <20100908100503.GX705@dastard>
In-Reply-To: <20100908100503.GX705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

SGVsbG8sCgpPbiAwOS8wOC8yMDEwIDEyOjA1IFBNLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4+ICog
RG8geW91IHRoaW5rIEBtYXhfYWN0aXZlID4gMSBjb3VsZCBiZSB1c2VmdWwgZm9yIHhmcz8gIElm
IG1vc3Qgd29ya3MKPj4gICBxdWV1ZWQgb24gdGhlIHdxIGFyZSBnb25uYSBjb250ZW5kIGZvciB0
aGUgc2FtZSAoYmxvY2tpbmcpIHNldCBvZgo+PiAgIHJlc291cmNlcywgaXQgd291bGQganVzdCBt
YWtlIG1vcmUgdGhyZWFkcyBzbGVlcGluZyBvbiB0aG9zZQo+PiAgIHJlc291cmNlcyBidXQgb3Ro
ZXJ3aXNlIGl0IHdvdWxkIGhlbHAgcmVkdWNpbmcgZXhlY3V0aW9uIGxhdGVuY3kgYQo+PiAgIGxv
dC4KPiAKPiBJdCBtYXkgaW5kZWVkIGhlbHAsIGJ1dCBJIGNhbid0IHJlYWxseSBzYXkgbXVjaCBt
b3JlIHRoYW4gdGhhdCByaWdodAo+IG5vdy4gSSBuZWVkIGEgZGVlcGVyIHVuZGVyc3RhbmRpbmcg
b2YgdGhlIGltcGFjdCBvZiBpbmNyZWFzaW5nCj4gbWF4X2FjdGl2ZSAoSSBoYXZlIGEgYmFzaWMg
dW5kZXJzdGFuZGluZyBub3cpIGJlZm9yZSBJIGNvdWxkIHNheSBmb3IKPiBjZXJ0YWluLgoKU3Vy
ZSwgdGhpbmdzIHNob3VsZCBiZSBmaW5lIGFzIHRoZXkgY3VycmVudGx5IHN0YW5kLiAgTm8gbmVl
ZCB0byBodXJyeQphbnl0aGluZy4KCj4+ICogeGZzX21ydV9jYWNoZSBpcyBhIHNpbmdsZXRocmVh
ZCB3b3JrcXVldWUuICBEbyB5b3Ugc3BlY2lmaWNhbGx5IG5lZWQKPj4gICBzaW5nbGV0aHJlYWRl
ZG5lc3MgKHN0cmljdCBvcmRlcmluZyBvZiB3b3Jrcykgb3IgaXMgaXQganVzdCB0byBhdm9pZAo+
PiAgIGNyZWF0aW5nIGRlZGljYXRlZCBwZXItY3B1IHdvcmtlcnM/ICBJZiB0aGUgbGF0dGVyLCB0
aGVyZSdzIG5vIG5lZWQKPj4gICB0byB1c2Ugc2luZ2xldGhyZWFkIG9uZSBhbnltb3JlLgo+IAo+
IERpZG4ndCBuZWVkIHBlci1jcHUgd29ya2Vycywgc28gY291bGQgcHJvYmFibHkgZHJvcCBpdCBu
b3cuCgpJIHNlZS4gIEknbGwgc29vbiBzZW5kIG91dCBhIHBhdGNoIHRvIGNvbnZlcnQgeGZzIHRv
IHVzZQphbGxvY193b3JrcXVldWUoKSBpbnN0ZWFkIGFuZCB3aWxsIGRyb3Agc2luZ2xldGhyZWFk
IHJlc3RyaWN0aW9uCnRoZXJlLgoKPj4gICBNYXliZSBzb21lIG9mIHRob3NlIHdvcmtxdWV1ZXMg
Y2FuIGRyb3AgV1FfUkVTQ1VFUiBvciBtZXJnZWQgb3IganVzdAo+PiAgIHVzZSB0aGUgc3lzdGVt
IHdvcmtxdWV1ZT8KPiAKPiBNYXliZSB0aGUgbXJ1IHdxIGNhbiB1c2UgdGhlIHN5c3RlbSB3cSwg
YnV0IEknbSByZWFsbHkgb3Bwb3NlZCB0bwo+IG1lcmdpbmcgWEZTIHdxcyB3aXRoIHN5c3RlbSB3
b3JrIHF1ZXVlcyBzaW1wbHkgZnJvbSBhIGRlYnVnZ2luZyBQT1YuCj4gSSd2ZSBsb3N0IGNvdW50
IG9mIHRoZSBudW1iZXIgb2YgdGltZXMgSSd2ZSB3YWxrZWQgdGhlIElPIGNvbXBsZXRpb24KPiBx
dWV1ZdGVIHdpdGggYSBkZWJ1Z2dlciBvciBjcmFzaCBkdW1wIGFuYWx5c2VyIHRvIHRyeSB0byB3
b3JrIG91dCBpZgo+IG1pc3NpbmcgSU8gdGhhdCB3ZWRnZWQgdGhlIGZpbGVzeXN0ZW0gZ290IHN0
dWNrIG9uIHRoZSBjb21wbGV0aW9uCj4gcXVldWUuIElmIEkgd2FudCB0byBiZSBhYmxlIHRvIHNh
eSAidGhlIElPIHdhcyBsb3N0IGJ5IGEgbG93ZXIKPiBsYXllciIsIHRoZW4gSSBoYXZlIHRvIGJl
IGFibGUgdG8gY29uZmlybSBpdCBpcyBub3Qgc3R1Y2sgaW4gYQo+IGNvbXBsZXRpb24gcXVldWUu
IFRoYXQgbXVjaCBoYXJkZXIgaWYgSSBkb24ndCBrbm93IHdoYXQgdGhlIHdvcmsKPiBjb250YWlu
ZXIgb2JqZWN0cyBvbiB0aGUgcXVldWUgYXJlLi4uLgoKSG1tLi4uIHRoYXQncyBnb25uYSBiZSBh
IGJpdCBtb3JlIGRpZmZpY3VsdCB3aXRoIGNtd3EgYXMgYWxsIHRoZSB3b3JrcwphcmUgbm93IHF1
ZXVlZCBvbiB0aGUgc2hhcmVkIHdvcmtsaXN0IGJ1dCB5b3Ugc2hvdWxkIHN0aWxsIGJlIGFibGUg
dG8KdGVsbC4gIE1heWJlIGNyYXNoIGNhbiBiZSB0YXVnaHQgaG93IHRvIHRlbGwgdGhlIGFzc29j
aWF0ZWQgd29ya3F1ZXVlCmZyb20gYSBwZW5kaW5nIHdvcmsuCgpUaGFua3MuCgotLSAKdGVqdW4K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWls
aW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL3hmcwo=
