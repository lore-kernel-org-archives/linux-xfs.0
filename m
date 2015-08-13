Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C55C37F61
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 18:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9FD77304043
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 16:51:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7rzGM6HHKYgJRY7M for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 16:51:50 -0700 (PDT)
Date: Fri, 14 Aug 2015 09:51:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH][RFC] xfs_copy: don't use DIRECT IO to copy 4k sector
	device
Message-ID: <20150813235147.GQ3902@dastard>
References: <1439478465-14072-1-git-send-email-zlang@redhat.com>
	<55CCC47A.5030706@sandeen.net>
	<510394920.8151266.1439484022770.JavaMail.zimbra@redhat.com>
	<55CCCBC3.6040404@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55CCCBC3.6040404@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Zirong Lang <zlang@redhat.com>, xfs@oss.sgi.com

T24gVGh1LCBBdWcgMTMsIDIwMTUgYXQgMTE6NTQ6MjdBTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIDgvMTMvMTUgMTE6NDAgQU0sIFppcm9uZyBMYW5nIHdyb3RlOgo+ID4gCj4gPiAK
PiA+IC0tLS0tIOWOn+Wni+mCruS7tiAtLS0tLQo+ID4+IOWPkeS7tuS6ujogIkVyaWMgU2FuZGVl
biIgPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+Cj4gPj4g5pS25Lu25Lq6OiAiWm9ycm8gTGFuZyIgPHps
YW5nQHJlZGhhdC5jb20+LCB4ZnNAb3NzLnNnaS5jb20KPiA+PiDlj5HpgIHml7bpl7Q6IOaYn+ac
n+S6lCwgMjAxNeW5tCA4IOaciCAxNOaXpSDkuIrljYggMTI6MjM6MjIKPiA+PiDkuLvpopg6IFJl
OiBbUEFUQ0hdW1JGQ10geGZzX2NvcHk6IGRvbid0IHVzZSBESVJFQ1QgSU8gdG8gY29weSA0ayBz
ZWN0b3IgZGV2aWNlCj4gPj4KPiA+PiBPbiA4LzEzLzE1IDEwOjA3IEFNLCBab3JybyBMYW5nIHdy
b3RlOgo+ID4+PiBXaGVuIEkgcnVuIHhmc3Rlc3RzIHhmcy8wMzIgaW4gcHBjNjRsZSwgSSBoaXQg
YSBmYWlsdXJlOgo+ID4+Pgo+ID4+PiAgICAgIHhmc19jb3B5OiByZWFkIGZhaWxlZDogSW52YWxp
ZCBhcmd1bWVudAo+ID4+PiAgICAgIHhmc19jb3B5OiBzaXplIGNoZWNrIGZhaWxlZAo+ID4+PiAg
ICAgIHhmc19jb3B5OiAvZGV2L3NkYTUgZmlsZXN5c3RlbSBmYWlsZWQgdG8gaW5pdGlhbGl6ZQo+
ID4+PiAgICAgIHhmc19jb3B5OiBBYm9ydGluZy4KPiA+Pj4gICAgICBDb3B5IGZhaWxlZCBmb3Ig
U2VjdG9yIHNpemUgNDA5NiBCbG9jayBzaXplIDQwOTYKPiA+Pj4KPiA+Pj4gSSB0cnkgdG8gdXNl
IGdkYiB0cmFjZSB4ZnNfY29weS4gSSBmaW5kIGl0IHRyeSB0byBvcGVuIHRoZQo+ID4+PiBzb3Vy
Y2UgZGV2aWNlIHdpdGggRElSRUNUIGZsYWcsIHRoZW4gcmVhZCB0aGUgZGV2aWNlIHdpdGgKPiA+
Pj4gKCgxPDxCQlNISUZUKSk9NTEyIGJ5dGVzIGxlbmd0aC4gSWYgdGhlIHNvdXJjZSBkZXZpY2Ug
aXMKPiA+Pj4gNGsgc2VjdG9yLCBkaXJlY3RseSByZWFkIDUxMiBieXRlcyB3aWxsIGJlIGZhaWxl
ZC4KPiA+Pj4KPiA+Pj4geGZzX2NvcHkgJy1iJyBvcHRpb24gb25seSB3b3JrIGZvciB0YXJnZXQg
ZmlsZS9kZXZpY2UsIHRvCj4gPj4+IHN1cmUgaXQgd2lsbCBvcGVuIHRoZSB0YXJnZXQgd2l0aG91
dCBESVJFQ1QgZmxhZy4gQnV0IHVzZWxlc3MKPiA+Pj4gZm9yIHNvdXJjZSBkZXZpY2Ugb3Blbi4K
PiA+Pj4KPiA+Pj4gU28gSSBtYWtlIERJUkVDVCBmbGFnIG9ubHkgYmUgZW5hYmxlZCB3aGVuIHNv
dXJjZSBkZXZpY2UKPiA+Pj4gc2VjdG9yIHNpemUgZXF1YWwgQkJTSVpFLgo+ID4+Cj4gPj4gV2hp
Y2ggdmVyc2lvbiBvZiB4ZnNwcm9ncyBkaWQgeW91IHRlc3Q/ICBUaGlzIGlzIHJlY2VudGx5IHVw
c3RyZWFtOgo+ID4gCj4gPiBTb3JyeSBJIGRpZG4ndCBub3RpY2UgdGhhdCB5b3UgaGF2ZSBmaXgg
dGhpcyBwcm9ibGVtLiBJIHRlc3Qgb24gdGhlCj4gPiBuZXdlc3QgdmVyc2lvbiBmcm9tIGdpdDov
L29zcy5zZ2kuY29tL3hmcy9jbWRzL3hmc3Byb2dzLCBpdCBoYXZlbid0Cj4gPiBmaXggdGhpcyBw
cm9ibGVtLiBJIHRlc3QgdGhpcyBwYXRjaCBvbiBpdCBhdCBmaXJzdC4gVGhlbiBJIGZpbmQKPiA+
IHRoZXJlIGlzIGFub3RoZXIgdmVyc2lvbiBpbiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2ZzL3hmcy94ZnNwcm9ncy1kZXYuZ2l0Cj4gPiAKPiA+IEkgZG9uJ3Qga25vdyB0aGV5IGFyZSB0
b28gZGlmZmVyZW50LCBzbyBJIGRpZG4ndCBjaGVjayBpZiB0aGlzIHhmc3Byb2dzLWRldiBoYXMK
PiA+ICBmaXhlZCBpdCwgYW5kIGp1c3QgZGlkIHRoaXMgcGF0Y2ggb24gaXQgYW5kIHNlbmQgb3V0
Lgo+ID4gCj4gPiBTb3JyeSBmb3IgdGhpcyBtaXN0YWtlLCBhbmQgeW91ciBwYXRjaCBpcyByZWFs
bHkgYmV0dGVyOikKPiAKPiBObyBwcm9ibGVtLCB0aGFua3MgZm9yIGxvb2tpbmcgaW50byBpdCEg
IEknbSBub3Qgc3VyZSB3aHkgdGhlIHNnaSBnaXQgdHJlZQo+IGlzIGEgYml0IGJlaGluZCByaWdo
dCBub3cuCgpJIGRpZG4ndCBwdXNoIDQuMi4wLXJjMSBpbiBjYXNlIGFueW9uZSBvYmplY3RlZCB0
byB0aGUgY2hhbmdlIG9mCnZlcnNpb24gbnVtYmVyaW5nIEkgd2FzIHByb3Bvc2luZy4gTm9ib2R5
IGhhcyBjb21tZW50ZWQsIHNvIHdoZW4gSQpwdXNoIDQuMi4wLXJjMiBvdXQsIEknbGwgYWxzbyB1
cGRhdGUgdGhlIG9zcy5zZ2kuY29tIHJlcG8uCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlu
bmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
