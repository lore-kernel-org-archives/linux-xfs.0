Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 012E87CA1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 16:01:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74C88AC002
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 14:01:32 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BsbY9RLblARVeYPo for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 14:01:29 -0700 (PDT)
Date: Thu, 7 Apr 2016 07:01:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
Message-ID: <20160406210128.GC13574@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
	<56FDD750.3040002@sandeen.net>
	<CACj3i71=v+p2=mM75Na0Lujt+gQjB1hX=En0K12he+7WF6q=wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i71=v+p2=mM75Na0Lujt+gQjB1hX=En0K12he+7WF6q=wQ@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

T24gV2VkLCBBcHIgMDYsIDIwMTYgYXQgMTE6MTI6MjFBTSArMDIwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IE9uIEZyaSwgQXByIDEsIDIwMTYgYXQgNDowNSBBTSwgRXJpYyBTYW5kZWVuIDxzYW5kZWVu
QHNhbmRlZW4ubmV0PiB3cm90ZToKPiA+IE9uIDMvMjQvMTYgNjoxNSBBTSwganR1bGFrQHJlZGhh
dC5jb20gd3JvdGU6Cj4gPiAgICAgICAgICAgICAgICAgaWYgKHNiX2ZlYXQuZmlub2J0ICYmIHNi
X2ZlYXQuZmlub2J0ZmxhZykgewo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgZnByaW50Zihz
dGRlcnIsCj4gPiBfKCJ3YXJuaW5nOiBmaW5vYnQgbm90IHN1cHBvcnRlZCB3aXRob3V0IENSQyBz
dXBwb3J0LCBkaXNhYmxlZC5cbiIpKTsKPiA+ICAgICAgICAgICAgICAgICB9Cj4gPiAgICAgICAg
ICAgICAgICAgc2JfZmVhdC5maW5vYnQgPSAwOwo+ID4KPiA+IHdvdWxkIHN1ZmZpY2UgYXMgYmVm
b3JlLCBubz8gTWVoLiAgTm90IGEgYmlnIGRlYWwgSSBndWVzcy4uLi4KPiA+Cj4gCj4g4oCLQ2hh
bmdlZC4gSG9uZXN0bHksIEkgZG9uJ3QgbGlrZSB0aGUgc3RyaW5ncyBzdGFydGluZyBhdCB0aGUg
YmVnaW5uaW5nIG9mCj4gdGhlIGxpbmUsIGJlY2F1c2UgaXQgYnJlYWtzIHRoZSBpbmRlbnRhdGlv
biBmbG93LCBidXQgdGhlIHJlc3Qgb2YgdGhlIGNvZGUKPiB1c2VzIHRoaXMgc3R5bGUsIHNvIEkg
c2hvdWxkIHN0aWNrIHRvIGl0LuKAiwoKVGhlcmUncyBnb29kIHJlYXNvbiBmb3IgZG9pbmcgdGhp
cyAtIGl0IG1ha2VzIGl0IGVhc3kgdG8gZ3JlcCB0aGUKc291cmNlIGNvZGUgZm9yIGEgc3BlY2lm
aWMgZXJyb3IgdGhhdCBoYXMgYmVlbiBlbWl0dGVkLiBJbmRlbnRhdGlvbgppcyB1c2VmdWwgZm9y
IGRlbW9uc3RyYXRpbmcgbG9naWMgZmxvdywgYnV0IGl0J3MgaGFybWZ1bCB3aGVuIGl0CnJlc3Vs
dHMgaW4gc3RyaW5ncyB5b3UgbWlnaHQgd2FudCB0byBmaW5kIGJlaW5nIHNwbGl0IHVwIG92ZXIK
bXVsdGlwbGUgbGluZXMuCgo+IFRoYW5rIHlvdSBmb3IgdGhlIHJldmlldy4gSSB3aWxsIHdhaXQg
YSBsaXR0bGUgbG9uZ2VyIGlmIHNvbWVvbmUgc3BvdHMKPiBzb21ldGhpbmcgbW9yZSwgYmVmb3Jl
IHNlbmRpbmcgYW4gdXBkYXRlZCBwYXRjaHNldC7igIsgOi0pCgpKdXN0IHNlbmQgaXQgLSBJIGFs
bW9zdCBnb3QgdG8gcHVsbGluZyBpbiB0aGlzIHZlcnNpb24gYW5kCmZpeGluZyB0aGUgdmFyaW91
cyBjb21tZW50cyBkaXJlY3RseSBteXNlbGYgeWVzdGVyZGF5Li4uLgoKQ2hlZXJzLAoKRGF2ZS4K
LS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dp
LmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
