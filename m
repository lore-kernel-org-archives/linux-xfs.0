Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1A6C7CBE
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 17:49:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F8CAAC003
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 15:48:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BHVJlsjtAk6EPUSW for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2015 15:48:54 -0700 (PDT)
Date: Sun, 16 Aug 2015 08:48:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS File system in trouble
Message-ID: <20150815224840.GX3902@dastard>
References: <55BE7C75.4060604@mygrande.net> <55C06F41.4030502@mygrande.net>
	<20150804224240.GU16638@dastard> <55C8006C.8070807@mygrande.net>
	<55CC375C.10902@mygrande.net> <20150814012635.GT3902@dastard>
	<55CE75CA.5070506@mygrande.net>
	<74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
	<55CF8972.8020306@sandeen.net>
	<03EB8070-A6DA-4E55-ACF9-6E0153E84DA0@filmlight.ltd.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <03EB8070-A6DA-4E55-ACF9-6E0153E84DA0@filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>, Leslie Rhorer <lrhorer@mygrande.net>

T24gU2F0LCBBdWcgMTUsIDIwMTUgYXQgMDc6NTc6MDRQTSArMDEwMCwgUm9nZXIgV2lsbGNvY2tz
IHdyb3RlOgo+IAo+IE9uIDE1IEF1ZyAyMDE1LCBhdCAxOTo0OCwgRXJpYyBTYW5kZWVuIDxzYW5k
ZWVuQHNhbmRlZW4ubmV0PiB3cm90ZToKPiAKPiA+IE9uIDgvMTUvMTUgNzoyOCBBTSwgUm9nZXIg
V2lsbGNvY2tzIHdyb3RlOgo+ID4+IHhmc19yZXBhaXIgMy4yLjEgcnVucyBjbGVhbmx5Lgo+ID4+
IAo+ID4+IHhmc19yZXBhaXIgMy4xLjEgY29tcGxhaW5zIGFib3V0IGEgbG9hZCBvZiBzdHVmZiwg
aW5jbHVkaW5nOgo+ID4gCj4gPiBJIHdvdWxkbid0IGV4cGVjdCB2My4xLjEgdG8gd29yayBhdCBh
bGwsIGJlY2F1c2U6Cj4gPiAKPiA+ICMgZGIveGZzX2RiIC1WCj4gPiB4ZnNfZGIgdmVyc2lvbiA0
LjIuMC1yYzEKPiA+ICMgZGIveGZzX2RiIC9tbnQvdGVzdDIvbGVzbGllL21kMC5pbWcgLWMgdmVy
c2lvbgo+ID4gdmVyc2lvbm51bSBbMHhiZGI0KzB4OGFdID0gVjQsTkxJTkssRElSVjIsQVRUUixB
TElHTixEQUxJR04sTE9HVjIsRVhURkxHLFNFQ1RPUixNT1JFQklUUyxBVFRSMixMQVpZU0JDT1VO
VCxQUk9KSUQzMkJJVAo+ID4gCj4gPiB0aGUgZmlsZXN5c3RlbSBoYXMgMzItYml0IHByb2plY3Qg
SURzLCBhbmQ6Cj4gPiAKPiA+ICMgZ2l0IGxvZyAtLW9uZWxpbmUgfCBncmVwIC1pICJwcm9qaWQz
MmJpdCIKPiA+IGRkNTM2ZTEgeGZzcHJvZ3M6IE5vdGUgcHJvamlkMzJiaXQgZGVmYXVsdCBjaGFu
Z2UgaW4gbWtmcy54ZnMgbWFucGFnZQo+ID4gMjJiYzEwZSB4ZnNwcm9nczogcHJvamlkMzJiaXQg
aGFuZGxpbmcKPiA+IAo+ID4gIyBnaXQgZGVzY3JpYmUgLS1jb250YWlucyAyMmJjMTBlCj4gPiB2
My4xLjR+Mgo+ID4gCj4gPiB0aGF0IGZlYXR1cmUgc3VwcG9ydCBkaWRuJ3Qgc2hvdyB1cCB1bnRp
bCB2My4xLjQuICBXZXJlIHlvdSBydW5uaW5nIGEgc3RvY2sgdjMuMS4xPwo+ID4gCj4gPiBBbnl3
YXksIGluIG15IHRlc3RpbmcsIHVwIHRvIHYzLjIuMCwgcmVwYWlyIGZpbmRzIGEgbG90IG9mIGVy
cm9ycyAoYW5kIHNwZW5kcyBzb21lCj4gPiB0aW1lIGxvb2tpbmcgZm9yIGEgcHJvcGVyIHN1cGVy
YmxvY2spCj4gPiAKPiA+IHYzLjIuMSBmaW5kcyBubyBlcnJvcnMuCj4gPiAKPiAKPiBBbmQgdGhl
cmXigJlzIHRoZSBwcm9ibGVtLCAoc2luY2UgWEZTX1NCX1ZFUlNJT04yX0NSQ0JJVCBpcyBub3Qg
c2V0KQo+ICB4ZnMtcmVwYWlyLTMuMi4xIHNob3VsZCBzcG90IGFuZCBmaXggdGhlIHYzIGlub2Rl
Lgo+IAo+IHJlcGFpci9kaW5vZGUuYyAodGlwKSBvbmx5IGNoZWNrcyBmb3IgKGxpbmUgMjMzNSBv
ciBzbyk6Cj4gCj4gICAgICh4ZnNfc2JfdmVyc2lvbl9oYXNjcmMoJm1wLT5tX3NiKSAmJiBkaW5v
LT5kaV92ZXJzaW9uIDwgMykKPiAKPiBub3QgYSBub24tY3JjIGZpbGVzeXN0ZW0gd2l0aCB2ZXJz
aW9uID49IDMuCj4gCj4gQWRkaW5nIHRoZSBtaXNzaW5nIGNoZWNrOgo+IAo+ICAgIHx8ICghIHhm
c19zYl92ZXJzaW9uX2hhc2NyYygmbXAtPm1fc2IpICYmIGRpbm8tPmRpX3ZlcnNpb24gPj0gMykg
CgpZdXAsIHRoYXQgbG9va3MgbGlrZSB0aGUgaXNzdWUuIEdvb2Qgc3BvdHRpbmcsIFJvZ2VyISBD
YW4geW91IHNlbmQgYQpwYXRjaCB3LyBzaWdub2ZmIHRoYXQgSSBjYW4gY29tbWl0PwoKQ2hlZXJz
LAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
