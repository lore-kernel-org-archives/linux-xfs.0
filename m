Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDF5A8030
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 13:19:54 -0600 (CST)
Date: Thu, 14 Feb 2013 13:19:52 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs_mkfs: Do not discard if '-N' is provided
Message-ID: <20130214191952.GG22182@sgi.com>
References: <1360670381-19838-1-git-send-email-lczerner@redhat.com>
	<511A5BAA.5000203@sandeen.net>
	<alpine.LFD.2.00.1302121635070.2315@(none)>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1302121635070.2315@(none)>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

SGV5IEx1a2FzLAoKT24gVHVlLCBGZWIgMTIsIDIwMTMgYXQgMDQ6Mzc6MzdQTSArMDEwMCwgTHVr
w6HFoSBDemVybmVyIHdyb3RlOgo+IE9uIFR1ZSwgMTIgRmViIDIwMTMsIEVyaWMgU2FuZGVlbiB3
cm90ZToKPiAKPiA+IERhdGU6IFR1ZSwgMTIgRmViIDIwMTMgMDk6MTE6MzggLTA2MDAKPiA+IEZy
b206IEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldD4KPiA+IFRvOiBMdWthcyBDemVy
bmVyIDxsY3plcm5lckByZWRoYXQuY29tPgo+ID4gQ2M6IHhmc0Bvc3Muc2dpLmNvbQo+ID4gU3Vi
amVjdDogUmU6IFtQQVRDSF0geGZzX21rZnM6IERvIG5vdCBkaXNjYXJkIGlmICctTicgaXMgcHJv
dmlkZWQKPiA+IAo+ID4gT24gMi8xMi8xMyA1OjU5IEFNLCBMdWthcyBDemVybmVyIHdyb3RlOgo+
ID4gPiBXaGVuICctTicgaXMgc3BlY2lmaWVkIHdlIHJlYWxseSBzaG91bGQgbm90IHdyaXRlIGFu
eXRoaW5nIHRvIHRoZQo+ID4gPiBkZXZpY2UsIG5laXRoZXIgd2Ugc2hvdWxkIGF0dGVtcHQgdG8g
ZGlzY2FyZCB0aGUgZGV2aWNlLgo+ID4gPiAKPiA+ID4gVGhpcyBjb21taXQgZml4ZXMgeGZzX21r
ZnMgdG8gbm90IGF0dGVtcHQgdG8gZGlzY2FyZCB0aGUgZGV2aWNlIGluIHRoZQo+ID4gPiBjYXNl
IHVzZXIgc3BlY2lmaWVkICctTicgZmxhZy4KPiA+IAo+ID4gVGhhbmtzLCBhbmQgeWVzIC0gb3Vj
aCwgdGhpcyBzaG91bGRuJ3QgaGFwcGVuIHdpdGggLU4sIHRoYXQncyBiYWQhCj4gPiAKPiA+IEJ1
dCBpdCBkb2Vzbid0IGxvb2sgbGlrZSB0aGlzIGlzIGFnYWluc3QgdGhlIGN1cnJlbnQgZ2l0IHRy
ZWUsCj4gPiBpdCBhcHBsaWVzIG9ubHkgd2l0aCBhIGxvdCBvZiBmdXp6ICYgb2Zmc2V0cy4KPiAK
PiBBaCwgSSd2ZSBiZWVuIHVzaW5nIAo+IAo+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
ZnMveGZzL3hmc3Byb2dzLWRldi5naXQKPiAKPiBhbmQgSSBjYW4gcmVtZW1iZXIgdGhhdCBpdCdz
IG5vdCB0aGUgZmlyc3QgdGltZSBJJ3ZlIHJlYWxpemVkIHRoYXQgSQo+IGFtIHVzaW5nIHdyb25n
IHJlcG8uIE9idmlvdXNseSBpIGFtIG5vdCBwYXlpbmcgYSBsb3Qgb2YgYXR0ZW50aW9uIHRvCj4g
dGhlIHhmcyBjaGFubmVsLCBidXQgZG9lcyB0aGlzIGtlZXAgY2hhbmdpbmcsIG9yIGlzIGl0IGp1
c3QgbWUgPyA6KQoKSXQgY2hhbmdlZCBqdXN0IHR3aWNlLCBBRkFJSy4KCkNocmlzdG9waCwgY291
bGQgeW91IGNsZWFuIHVwIHRoZSBrZXJuZWwub3JnIHRyZWVzIHRvIGhlbHAgcmVzb2x2ZSB0aGUK
Y29uZnVzaW9uPwoKPiBXaWxsIHJlc2VuZCB0aGUgcGF0Y2ggYmFzZWQgb24gdGhlCj4gCj4gZ2l0
Oi8vb3NzLnNnaS5jb20veGZzL2NtZHMveGZzcHJvZ3MuZ2l0CgpUaGlzIGlzIHRoZSByaWdodCBw
bGFjZSwgdGhhbmtzLgoKUmVnYXJkcywKCUJlbgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
