Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFD427F37
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 16:36:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1775304039
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 14:36:27 -0800 (PST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id bqBaEE04NzSdzgLy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Nov 2015 14:36:22 -0800 (PST)
Received: by lfdo63 with SMTP id o63so36488798lfd.2
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 14:36:20 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: memory reclaim problems on fs usage
Date: Wed, 18 Nov 2015 23:36:18 +0100
References: <201511102313.36685.arekm@maven.pl>
	<201511151549.35299.arekm@maven.pl>
	<20151116161518.GI14116@dhcp22.suse.cz>
In-Reply-To: <20151116161518.GI14116@dhcp22.suse.cz>
MIME-Version: 1.0
Message-Id: <201511182336.18231.arekm@maven.pl>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org, cl@linux.com, htejun@gmail.com, xfs@oss.sgi.com

T24gTW9uZGF5IDE2IG9mIE5vdmVtYmVyIDIwMTUsIE1pY2hhbCBIb2NrbyB3cm90ZToKPiBPbiBT
dW4gMTUtMTEtMTUgMTU6NDk6MzUsIEFya2FkaXVzeiBNacWba2lld2ljeiB3cm90ZToKPiA+IE9u
IFN1bmRheSAxNSBvZiBOb3ZlbWJlciAyMDE1LCBUZXRzdW8gSGFuZGEgd3JvdGU6Cj4gPiA+IEFy
a2FkaXVzeiBNaXNraWV3aWN6IHdyb3RlOgo+ID4gPiA+IE9uIFN1bmRheSAxNSBvZiBOb3ZlbWJl
ciAyMDE1LCBUZXRzdW8gSGFuZGEgd3JvdGU6Cj4gPiA+ID4gPiBJIHRoaW5rIHRoYXQgdGhlIHZt
c3RhdCBzdGF0aXN0aWNzIG5vdyBoYXZlIGNvcnJlY3QgdmFsdWVzLgo+ID4gPiA+ID4gCj4gPiA+
ID4gPiA+IEJ1dCBhcmUgdGhlc2UgcGF0Y2hlcyBzb2x2aW5nIHRoZSBwcm9ibGVtIG9yIGp1c3Qg
aGlkaW5nIGl0Pwo+ID4gPiA+ID4gCj4gPiA+ID4gPiBFeGN1c2UgbWUgYnV0IEkgY2FuJ3QganVk
Z2UuCj4gPiA+ID4gPiAKPiA+ID4gPiA+IElmIHlvdSBhcmUgaW50ZXJlc3RlZCBpbiBtb25pdG9y
aW5nIGhvdyB2bXN0YXQgc3RhdGlzdGljcyBhcmUKPiA+ID4gPiA+IGNoYW5naW5nIHVuZGVyIHN0
YWxsZWQgY29uZGl0aW9uLCB5b3UgY2FuIHRyeSBiZWxvdyBwYXRjaC4KPiA+ID4gPiAKPiA+ID4g
PiBIZXJlIGlzIGxvZyB3aXRoIHRoaXMgYW5kIGFsbCBwcmV2aW91cyBwYXRjaGVzIGFwcGxpZWQ6
Cj4gPiA+ID4gaHR0cDovL2l4aW9uLnBsZC1saW51eC5vcmcvfmFyZWttL2xvZy1tbS01LnR4dC5n
ego+ID4gPiAKPiA+ID4gUmVnYXJkaW5nICJOb2RlIDAgTm9ybWFsIiAobWluOjcxMDRrQiBsb3c6
ODg4MGtCIGhpZ2g6MTA2NTZrQiksCj4gPiA+IGFsbCBmcmVlOiB2YWx1ZXMgbG9vayBzYW5lIHRv
IG1lLiBJIHRoaW5rIHRoYXQgeW91ciBwcm9ibGVtIHdhcyBzb2x2ZWQuCj4gPiAKPiA+IEdyZWF0
LCB0aGFua3MhCj4gPiAKPiA+IFdpbGwgYWxsIChvciBwYXJ0KSBvZiB0aGVzZSBwYXRjaGVzCj4g
PiAKPiA+IGh0dHA6Ly9zcHJ1bmdlLnVzL0dZQmIKPiAKPiBNaWdyYXRlIHJlc2VydmVzIGFyZSBu
b3QgYSBzdGFibGUgbWF0ZXJpYWwgSSBhbSBhZnJhaWQuICJ2bXN0YXQ6Cj4gZXhwbGljaXRseSBz
Y2hlZHVsZSBwZXItY3B1IHdvcmsgb24gdGhlIENQVSB3ZSBuZWVkIGl0IHRvIHJ1biBvbiIKPiB3
YXMgbm90IG1hcmtlZCBmb3Igc3RhYmxlIGVpdGhlciBidXQgSSBhbSBub3Qgc3VyZSB3aHkgaXQg
c2hvdWxkIG1ha2UKPiBhbnkgZGlmZmVyZW5jZSBmb3IgeW91ciBsb2FkLiBJIHVuZGVyc3RhbmQg
dGhhdCB0ZXN0aW5nIHRoaXMgaXMgcmVhbGx5Cj4gdGVkaW91cyBidXQgaXQgd291bGQgYmUgYmV0
dGVyIHRvIGtub3cgd2hpY2ggb2YgdGhlIHBhdGNoZXMgYWN0dWFsbHkKPiBtYWRlIGEgZGlmZmVy
ZW5jZS4KCk9rLiBJbiBtZWFuIHRpbWUgSSd2ZSB0cmllZCA0LjMuMCBrZXJuZWwgKyBwYXRjaGVz
ICh0aGUgc2FtZSBhcyBiZWZvcmUgKyBvbmUgCm1vcmUpIG9uIHNlY29uZCBzZXJ2ZXIgd2hpY2gg
cnVucyBldmVuIG1vcmUgcnNuYXBzaG90IHByb2Nlc3NlcyBhbmQgYWxzbyB1c2VzIAp4ZnMgb24g
bWQgcmFpZCA2LgoKUGF0Y2hlczoKaHR0cDovL3NwcnVuZ2UudXMvRGZJUSAoZGVidWcgcGF0Y2gg
ZnJvbSBUZXRzdW8pCmh0dHA6Ly9zcHJ1bmdlLnVzL0xRUEYgKGJhY2twb3J0IG9mIHRoaW5ncyBm
cm9tIGdpdCArIG9uZSBmcm9tIG1sKQoKVGhlIHByb2JsZW0gaXMgbm93IHdpdGggaGlnaCBvcmRl
ciBhbGxvY2F0aW9ucyBwcm9iYWJseToKaHR0cDovL2l4aW9uLnBsZC1saW51eC5vcmcvfmFyZWtt
L2xvZy1tbS0yc3J2LTEudHh0Lmd6CgpTeXN0ZW0gaXMgZG9pbmcgdmVyeSBzbG93IHByb2dyZXNz
IGFuZCBmb3IgZXhhbXBsZSBkZXBtb2QgcnVuIHRvb2sgMiBob3VycwpodHRwOi8vc3BydW5nZS51
cy9IR2JFClNvbWV0aW1lcyBJIHdhcyBhYmxlIHRvIHNzaC1pbiwgZG1lc2cgdG9vayAxMC0xNSBt
aW51dGVzIGJ1dCBzb21ldGltZXMgaXQgCndvcmtlZCBmYXN0IGZvciBzaG9ydCBwZXJpb2QuCgpJ
ZGVhcz8KCnBzLiBJIGFsc28gaGFkIG9uZSBwcm9ibGVtIHdpdGggbG93IG9yZGVyIGFsbG9jYXRp
b24gYnV0IG9ubHkgb25jZSBhbmQgd2Fzbid0IAphYmxlIHRvIHJlcHJvZHVjZSBzbyBmYXIuIEkg
d2FzIHJ1bm5pbmcga2VybmVsIHdpdGggYmFja3BvcnQgcGF0Y2hlcyBidXQgbm8gCmRlYnVnIHBh
dGNoLCBzbyBnb3Qgb25seSB0aGlzIGluIGxvZ3M6Cmh0dHA6Ly9zcHJ1bmdlLnVzL1dQWGkKCi0t
IApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFyZWttIC8gKCBtYXZlbi5wbCB8IHBsZC1saW51eC5v
cmcgKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
