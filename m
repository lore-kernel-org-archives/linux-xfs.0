Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E15817F3F
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 05:29:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6BF0304032
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 03:29:32 -0800 (PST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
	[209.85.215.46]) by cuda.sgi.com with ESMTP id Y6W9SFo87C4pgJlu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2015 03:29:27 -0800 (PST)
Received: by lfdo63 with SMTP id o63so72978645lfd.2
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 03:29:26 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: memory reclaim problems on fs usage
Date: Sun, 15 Nov 2015 12:29:23 +0100
References: <201511102313.36685.arekm@maven.pl>
	<201511142140.38245.arekm@maven.pl>
	<201511151135.JGD81717.OFOOSMFJFQHVtL@I-love.SAKURA.ne.jp>
In-Reply-To: <201511151135.JGD81717.OFOOSMFJFQHVtL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Message-Id: <201511151229.23312.arekm@maven.pl>
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
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-mm@kvack.org, cl@linux.com, htejun@gmail.com, mhocko@suse.com, xfs@oss.sgi.com

T24gU3VuZGF5IDE1IG9mIE5vdmVtYmVyIDIwMTUsIFRldHN1byBIYW5kYSB3cm90ZToKPiBBcmth
ZGl1c3ogTWlza2lld2ljeiB3cm90ZToKPiA+ID4gPiB2bXN0YXRfdXBkYXRlKCkgYW5kIHN1Ym1p
dF9mbHVzaGVzKCkgcmVtYWluZWQgcGVuZGluZyBmb3IgYWJvdXQgMTEwCj4gPiA+ID4gc2Vjb25k
cy4gSWYgeGxvZ19jaWxfcHVzaF93b3JrKCkgd2VyZSBzcGlubmluZyBpbnNpZGUgR0ZQX05PRlMK
PiA+ID4gPiBhbGxvY2F0aW9uLCBpdCBzaG91bGQgYmUgcmVwb3J0ZWQgYXMgTWVtQWxsb2M6IHRy
YWNlcywgYnV0IG5vIHN1Y2gKPiA+ID4gPiBsaW5lcyBhcmUgcmVjb3JkZWQuIEkgZG9uJ3Qga25v
dyB3aHkgeGxvZ19jaWxfcHVzaF93b3JrKCkgZGlkIG5vdAo+ID4gPiA+IGNhbGwgc2NoZWR1bGUo
KSBmb3Igc28gbG9uZy4gQW55d2F5LCBhcHBseWluZwo+ID4gPiA+IGh0dHA6Ly9sa21sLmtlcm5l
bC5vcmcvci8yMDE1MTExMTE2MDMzNi5HRDE0MzJAZGhjcDIyLnN1c2UuY3ogc2hvdWxkCj4gPiA+
ID4gc29sdmUgdm1zdGF0X3VwZGF0ZSgpIHBhcnQuCj4gPiA+IAo+ID4gPiBUbyBhcHBseSB0aGF0
IHBhdGNoIG9uIHRvcCBvZiA0LjEuMTMgSSBhbHNvIGhhZCB0byBhcHBseSBwYXRjaGVzIGxpc3Rl
ZAo+ID4gPiBiZWxvdy4KPiA+ID4gCj4gPiA+IFNvIGluIHN1bW1hcnkgYXBwbGxpZWQ6Cj4gPiA+
IGh0dHA6Ly9zcHJ1bmdlLnVzL0dZQmIKPiA+ID4gaHR0cDovL3NwcnVuZ2UudXMvWFdVWAo+ID4g
PiBodHRwOi8vc3BydW5nZS51cy9qWmpWCj4gPiAKPiA+IEkndmUgdHJpZWQgbW9yZSB0byB0cmln
Z2VyICJwYWdlIGFsbG9jYXRpb24gZmFpbHVyZSIgd2l0aCB1c3VhbCBhY3Rpb25zCj4gPiB0aGF0
IHRyaWdnZXJlZCBpdCBwcmV2aW91c2x5IGJ1dCBjb3VsZG4ndCByZXByb2R1Y2UuIFdpdGggdGhl
c2UgcGF0Y2hlcwo+ID4gYXBwbGllZCBpdCBkb2Vzbid0IGhhcHBlbi4KPiA+IAo+ID4gTG9ncyBm
cm9tIG15IHRlc3RzOgo+ID4gCj4gPiBodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20v
bG9nLW1tLTMudHh0Lmd6Cj4gPiBodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20vbG9n
LW1tLTQudHh0Lmd6ICh3aXRoIHN3YXAgYWRkZWQpCj4gCj4gR29vZC4KPiAKPiB2bXN0YXRfdXBk
YXRlKCkgYW5kIHN1Ym1pdF9mbHVzaGVzKCkgYXJlIG5vIGxvbmdlciBwZW5kaW5nIGZvciBsb25n
Lgo+IAo+IGxvZy1tbS00LnR4dDpOb3YgMTQgMTY6NDA6MDggc3J2IGtlcm5lbDogWzE2Nzc1My4z
OTM5NjBdICAgICBwZW5kaW5nOgo+IHZtc3RhdF9zaGVwaGVyZCwgdm1wcmVzc3VyZV93b3JrX2Zu
IGxvZy1tbS00LnR4dDpOb3YgMTQgMTY6NDA6MDggc3J2Cj4ga2VybmVsOiBbMTY3NzUzLjM5Mzk4
NF0gICAgIHBlbmRpbmc6IHN1Ym1pdF9mbHVzaGVzIFttZF9tb2RdCj4gbG9nLW1tLTQudHh0Ok5v
diAxNCAxNjo0MTowOCBzcnYga2VybmVsOiBbMTY3ODEzLjQzOTQwNV0gICAgIHBlbmRpbmc6Cj4g
c3VibWl0X2ZsdXNoZXMgW21kX21vZF0gbG9nLW1tLTQudHh0Ok5vdiAxNCAxNzoxNzoxOSBzcnYg
a2VybmVsOgo+IFsxNjk5ODUuMTA0ODA2XSAgICAgcGVuZGluZzogdm1zdGF0X3NoZXBoZXJkCj4g
Cj4gSSB0aGluayB0aGF0IHRoZSB2bXN0YXQgc3RhdGlzdGljcyBub3cgaGF2ZSBjb3JyZWN0IHZh
bHVlcy4KPiAKPiA+IEJ1dCBhcmUgdGhlc2UgcGF0Y2hlcyBzb2x2aW5nIHRoZSBwcm9ibGVtIG9y
IGp1c3QgaGlkaW5nIGl0Pwo+IAo+IEV4Y3VzZSBtZSBidXQgSSBjYW4ndCBqdWRnZS4KPgo+IElm
IHlvdSBhcmUgaW50ZXJlc3RlZCBpbiBtb25pdG9yaW5nIGhvdyB2bXN0YXQgc3RhdGlzdGljcyBh
cmUgY2hhbmdpbmcKPiB1bmRlciBzdGFsbGVkIGNvbmRpdGlvbiwgeW91IGNhbiB0cnkgYmVsb3cg
cGF0Y2guCgoKSGVyZSBpcyBsb2cgd2l0aCB0aGlzIGFuZCBhbGwgcHJldmlvdXMgcGF0Y2hlcyBh
cHBsaWVkOgpodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20vbG9nLW1tLTUudHh0Lmd6
CgoKPiAKPiBkaWZmIC0tZ2l0IGEvbW0vcGFnZV9hbGxvYy5jIGIvbW0vcGFnZV9hbGxvYy5jCj4g
aW5kZXggMzVhNDZiNC4uM2RlM2ExNCAxMDA2NDQKPiAtLS0gYS9tbS9wYWdlX2FsbG9jLmMKPiAr
KysgYi9tbS9wYWdlX2FsbG9jLmMKPiBAQCAtMjc5NCw4ICsyNzk0LDcgQEAgc3RhdGljIGludCBr
bWFsbG9jd2Qodm9pZCAqdW51c2VkKQo+ICAJcmN1X3JlYWRfdW5sb2NrKCk7Cj4gIAlwcmVlbXB0
X2VuYWJsZSgpOwo+ICAJc2hvd193b3JrcXVldWVfc3RhdGUoKTsKPiAtCWlmIChkdW1wX3Rhcmdl
dF9waWQgPD0gMCkKPiAtCQlkdW1wX3RhcmdldF9waWQgPSAtcGlkOwo+ICsJc2hvd19tZW0oMCk7
Cj4gIAkvKiBXYWl0IHVudGlsIG5leHQgdGltZW91dCBkdXJhdGlvbi4gKi8KPiAgCXNjaGVkdWxl
X3RpbWVvdXRfaW50ZXJydXB0aWJsZShrbWFsbG9jd2RfdGltZW91dCk7Cj4gIAlpZiAobWVtYWxs
b2NfY291bnRlcltpbmRleF0pCgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJla20gLyAo
IG1hdmVuLnBsIHwgcGxkLWxpbnV4Lm9yZyApCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
