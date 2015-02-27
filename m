Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A6677F50
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 02:36:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC3A5AC004
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:36:12 -0800 (PST)
Received: from mail-we0-f174.google.com (mail-we0-f174.google.com
	[74.125.82.174]) by cuda.sgi.com with ESMTP id g0qfUh33vh5NETOO
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:36:10 -0800 (PST)
Received: by wevk48 with SMTP id k48so18339949wev.3
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 00:36:10 -0800 (PST)
Message-ID: <54F02C73.5090601@gmail.com>
Date: Fri, 27 Feb 2015 09:36:03 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
	<54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org>
	<54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org>
	<54F02446.2050008@gmail.com> <20150227080800.GA20442@mew>
In-Reply-To: <20150227080800.GA20442@mew>
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
To: Omar Sandoval <osandov@osandov.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, mtk.manpages@gmail.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

SGVsbG8gT21hciwKCk9uIDAyLzI3LzIwMTUgMDk6MDggQU0sIE9tYXIgU2FuZG92YWwgd3JvdGU6
Cj4gT24gRnJpLCBGZWIgMjcsIDIwMTUgYXQgMDk6MDE6MTBBTSArMDEwMCwgTWljaGFlbCBLZXJy
aXNrIChtYW4tcGFnZXMpIHdyb3RlOgo+PiBPbiAwMi8yNy8yMDE1IDAxOjA0IEFNLCBUaGVvZG9y
ZSBUcydvIHdyb3RlOgo+Pj4gT24gVGh1LCBGZWIgMjYsIDIwMTUgYXQgMDI6MzY6MzNQTSArMDEw
MCwgTWljaGFlbCBLZXJyaXNrIChtYW4tcGFnZXMpIHdyb3RlOgo+Pj4+Cj4+Pj4gICAgIFRoZSBk
aXNhZHZhbnRhZ2Ugb2YgTVNfU1RSSUNUQVRJTUUgfCBNU19MQVpZVElNRSBpcyB0aGF0Cj4+Pj4g
ICAgIGluIHRoZSBjYXNlIG9mIGEgc3lzdGVtIGNyYXNoLCB0aGUgYXRpbWUgYW5kIG10aW1lIGZp
ZWxkcwo+Pj4+ICAgICBvbiBkaXNrIG1pZ2h0IGJlIG91dCBvZiBkYXRlIGJ5IGF0IG1vc3QgMjQg
aG91cnMuCj4+Pgo+Pj4gSSdkIGNoYW5nZSB0byAiVGhlIGRpc2FkdmFudGFnZSBvZiBNU19MQVpZ
VElNRSBpcyB0aGF0Li4uIiAgYW5kCj4+PiBwZXJoYXBzIG1vdmUgdGhhdCBzbyBpdCdzIGNsZWFy
IGl0IGFwcGxpZXMgdG8gYW55IHVzZSBvZiBNU19MQVpZVElNRQo+Pj4gaGFzIHRoaXMgYXMgYSBk
b3duc2lkZS4KPj4+Cj4+PiBEb2VzIHRoYXQgbWFrZSBzZW5zZT8KPj4KPj4gVGhhbmtzLCBUZWQu
IEdvdCBpdC4gU28sIG5vdyB3ZSBoYXZlOgo+Pgo+PiAgICAgICAgTVNfTEFaWVRJTUUgKHNpbmNl
IExpbnV4IDMuMjApCj4+ICAgICAgICAgICAgICAgUmVkdWNlICBvbi1kaXNrICB1cGRhdGVzICBv
ZiAgaW5vZGUgIHRpbWVzdGFtcHMgIChhdGltZSwKPj4gICAgICAgICAgICAgICBtdGltZSwgY3Rp
bWUpIGJ5IG1haW50YWluaW5nIHRoZXNlIGNoYW5nZXMgb25seSBpbiAgbWVt4oCQCj4+ICAgICAg
ICAgICAgICAgb3J5LiAgVGhlIG9uLWRpc2sgdGltZXN0YW1wcyBhcmUgdXBkYXRlZCBvbmx5IHdo
ZW46Cj4+Cj4+ICAgICAgICAgICAgICAgKGEpICB0aGUgaW5vZGUgbmVlZHMgdG8gYmUgdXBkYXRl
ZCBmb3Igc29tZSBjaGFuZ2UgdW5yZeKAkAo+PiAgICAgICAgICAgICAgICAgICAgbGF0ZWQgdG8g
ZmlsZSB0aW1lc3RhbXBzOwo+Pgo+PiAgICAgICAgICAgICAgIChiKSAgdGhlIGFwcGxpY2F0aW9u
ICBlbXBsb3lzICBmc3luYygyKSwgIHN5bmNmcygyKSwgIG9yCj4+ICAgICAgICAgICAgICAgICAg
ICBzeW5jKDIpOwo+Pgo+PiAgICAgICAgICAgICAgIChjKSAgYW4gdW5kZWxldGVkIGlub2RlIGlz
IGV2aWN0ZWQgZnJvbSBtZW1vcnk7IG9yCj4+Cj4+ICAgICAgICAgICAgICAgKGQpICBtb3JlICB0
aGFuIDI0IGhvdXJzIGhhdmUgcGFzc2VkIHNpbmNlIHRoZSBpbm9kZSB3YXMKPj4gICAgICAgICAg
ICAgICAgICAgIHdyaXR0ZW4gdG8gZGlzay4KPj4KPj4gICAgICAgICAgICAgICBUaGlzIG1vdW50
IHNpZ25pZmljYW50bHkgcmVkdWNlcyB3cml0ZXMgbmVlZGVkIHRvIHVwZGF0ZQo+ICJUaGlzIG1v
dW50IG9wdGlvbiI/CgpUaGFua3MsIGZpeGVkLgoKPj4gICAgICAgICAgICAgICB0aGUgIGlub2Rl
J3MgIHRpbWVzdGFtcHMsICBlc3BlY2lhbGx5ICBtdGltZSAgYW5kIGF0aW1lLgo+PiAgICAgICAg
ICAgICAgIEhvd2V2ZXIsIGluIHRoZSBldmVudCBvZiBhIHN5c3RlbSBjcmFzaCwgdGhlICBhdGlt
ZSAgYW5kCj4+ICAgICAgICAgICAgICAgbXRpbWUgIGZpZWxkcyAgb24gIGRpc2sgbWlnaHQgYmUg
b3V0IG9mIGRhdGUgYnkgdXAgdG8gMjQKPj4gICAgICAgICAgICAgICBob3Vycy4KPj4KPj4gICAg
ICAgICAgICAgICBFeGFtcGxlcyBvZiB3b3JrbG9hZHMgd2hlcmUgdGhpcyBvcHRpb24gY291bGQg
YmUgb2Ygc2ln4oCQCj4+ICAgICAgICAgICAgICAgbmlmaWNhbnQgIGJlbmVmaXQgaW5jbHVkZSBm
cmVxdWVudCByYW5kb20gd3JpdGVzIHRvIHByZeKAkAo+PiAgICAgICAgICAgICAgIGFsbG9jYXRl
ZCBmaWxlcywgYXMgd2VsbCBhcyBjYXNlcyB3aGVyZSB0aGUgIE1TX1NUUklDVEHigJAKPj4gICAg
ICAgICAgICAgICBUSU1FICBtb3VudCAgb3B0aW9uICBpcyBhbHNvIGVuYWJsZWQuICAoVGhlIGFk
dmFudGFnZSBvZgo+PiAgICAgICAgICAgICAgIChNU19TVFJJQ1RBVElNRSB8ICBNU19MQVpZVElN
RSkgIGlzICB0aGF0ICBzdGF0KDIpICB3aWxsCj4+ICAgICAgICAgICAgICAgcmV0dXJuICB0aGUg
IGNvcnJlY3RseSAgdXBkYXRlZCAgYXRpbWUsICBidXQgIHRoZSAgYXRpbWUKPj4gICAgICAgICAg
ICAgICB1cGRhdGVzIHdpbGwgYmUgZmx1c2hlZCB0byBkaXNrIG9ubHkgd2hlbiAoMSkgdGhlICBp
bm9kZQo+PiAgICAgICAgICAgICAgIG5lZWRzICB0byAgYmUgIHVwZGF0ZWQgZm9yIGZpbGVzeXN0
ZW0gLyBkYXRhIGNvbnNpc3RlbmN5Cj4+ICAgICAgICAgICAgICAgcmVhc29ucyBvciAoMikgdGhl
IGlub2RlIGlzIHB1c2hlZCBvdXQgb2YgbWVtb3J5LCBvciAoMykKPj4gICAgICAgICAgICAgICB0
aGUgZmlsZXN5c3RlbSBpcyB1bm1vdW50ZWQuKQo+IElzIGl0IG5lY2Vzc2FyeSB0byByZXBlYXQg
dGhlIHJlYXNvbnMgZm9yIGZsdXNoaW5nLCB3aGljaCBhcmUgc3RhdGVkCj4gYWJvdmU/CgpHb29k
IHBvaW50LiBJIHJlcGxhY2VkIHRoaXMgcGllY2Ugd2l0aCBqdXN0IGEgZmV3IHdvcmRzIHJlZmVy
cmluZyAKdG8gdGhlIGxpc3QgYWJvdmUuCgpUaGFua3MsCgpNaWNoYWVsCgoKLS0gCk1pY2hhZWwg
S2VycmlzawpMaW51eCBtYW4tcGFnZXMgbWFpbnRhaW5lcjsgaHR0cDovL3d3dy5rZXJuZWwub3Jn
L2RvYy9tYW4tcGFnZXMvCkxpbnV4L1VOSVggU3lzdGVtIFByb2dyYW1taW5nIFRyYWluaW5nOiBo
dHRwOi8vbWFuNy5vcmcvdHJhaW5pbmcvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
