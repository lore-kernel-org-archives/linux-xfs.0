Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD9C87F4E
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 09:04:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CAC98F8084
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 07:04:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IcASonhvDWHD9wHN for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 07:04:48 -0700 (PDT)
Message-ID: <519CD080.2030501@sandeen.net>
Date: Wed, 22 May 2013 09:04:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [BUG] XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
	file: fs/xfs/xfs_mount.c, line: 272
References: <519B6738.9030603@open-e.com> <20130521233937.GX29466@dastard>
	<519C7D97.50909@open-e.com>
In-Reply-To: <519C7D97.50909@open-e.com>
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
To: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
Cc: xfs@oss.sgi.com

T24gNS8yMi8xMyAzOjExIEFNLCBBcmthZGl1c3ogQnViYcWCYSB3cm90ZToKPiBIZWxsbywKPj4g
T24gVHVlLCBNYXkgMjEsIDIwMTMgYXQgMDI6MjM6MjBQTSArMDIwMCwgQXJrYWRpdXN6IEJ1YmHF
gmEgd3JvdGU6Cj4+ICAgCj4+PiBIZWxsbywKPj4+IEkndmUgZ290IGEgY2FsbCB0cmFjZSB3aGlj
aCBzaG91bGQgYmUgZml4ZWQgYnkgImRyb3AgYnVmZmVyIGlvCj4+PiByZWZlcmVuY2Ugd2hlbiBh
IGJhZCBiaW8gaXMgYnVpbHQiIHBhdGNoCj4+PiAoaHR0cDovL3BhdGNod29yay54ZnMub3JnL3Bh
dGNoLzM5NTYvKS4gRXJyb3Igb2NjdXJlZCBvbiBhbHJlYWR5Cj4+PiBwYXRjaGVkIExpbnV4IGtl
cm5lbCAzLjIuNDIuCj4+PiAgICAgIAo+PiBUaGF0J3MgYW4gb2xkIGtlcm5lbC4gQ2FuIHlvdSBy
ZXByb2R1Y2Ugb24gYSBjdXJyZW50IFRPVCBrZXJuZWw/Cj4+IEl0J3MgZW50aXJlbHkgcG9zc2li
bGUgdGhhdCB0aGlzIHByb2JsZW0gaGFzIGJlZW4gZml4ZWQgYXMgd2UKPj4gZGVmaW5pdGVseSBt
YWUgc29tZSBjaGFuZ2VzIHRvIHRoZSBtb3VudCBlcnJvciBoYW5kbGluZyBwYXRoIHNpbmNlCj4+
IDMuMi4uLi4KPj4KPj4gICAgCj4gT2suIEknbGwgdHJ5Lgo+Pj4gVGVzdCBlbnZpcm9ubWVudCBj
b25zaXN0IHR3byBtYWNoaW5lcyB0YXJnZXQgYW5kIGluaXRpYXRvci4KPj4+IEZpcnN0IG1hY2hp
bmUgd29ya3MgYXMgdGFyZ2V0IHdpdGggUUxvZ2ljIENvcnAuIElTUDI0MzItYmFzZWQgNEdiCj4+
PiBGaWJyZSBDaGFubmVsIGRldmljZS4gU3RvcmFnZSBpcyBwbGFjZWQgb24gdHdvIEtJTkdTVE9O
IFNOVjQyNVMgU1NECj4+PiB3b3JraW5nIGFzIFJBSUQwIGFycmF5LiBSQUlEIGlzIG1hbmFnZWQg
YnkgTFNJIE1lZ2FSQUlEIFNBUyAxMDY4Cj4+PiBjb250cm9sbGVyLgo+Pj4gU2Vjb25kIG1hY2hp
bmUgd29ya3MgYXMgaW5pdGlhdG9yIHdpdGggdGhlIHNhbWUgUUxvZ2ljIGNhcmQuCj4+Pgo+Pj4g
QWZ0ZXIgZmV3IGRheXMgb2YgcnVubmluZyB0ZXN0IHNjcmlwdCBJIGdvdCBmb2xsb3dpbmcgY2Fs
bCB0cmFjZSBhbmQKPj4+IFhGUyBzdG9wcGVkIHdvcmtpbmcuCj4+PiAgICAgIAo+PiBDYW4geW91
IG5hcnJvdyB0aGlzIGRvd24gZnJvbSAidGFrZXMgc2V2ZXJhbCBkYXlzIiB0byB0aGUgc2ltcGxl
c3QKPj4gcG9zc2libGUgcmVwcm9kdWNlcj8gSXQgaGFwcGVuZWQgZHVlIHRvIElPIGVycm9ycyBk
dXJpbmcgbW91bnQsIHNvCj4+IG1heWJlIHlvdSBjYW4gZGlkIHRoYXQgcGFydCBvdXQgb2YgeW91
ciBzY3JpcHQgYW5kIGdpdmUgdXMgYSB0ZXN0Cj4+IGNhc2UgdGhhdCByZXByb2R1Y2VzIG9uIHRo
ZSBmaXJzdCBtb3VudD8KPj4KPj4gICAgCj4gSSAnbGwgdHJ5LiBUaGlzIGVycm9ycyBvY2N1cnMg
b25seSBvbiBoZWF2eSBsb2FkLgo+IElzIHRoZXJlIGFueSBwb3NzaWJpbGl0eSB0byBzaW11bGF0
ZSBJL08gZXJyb3JzIG9uIFhGUyBmaWxlc3lzdGVtPwoKWW91IGNhbiB1c2Ugc29tZXRoaW5nIGxp
a2UgYSBkbS1mbGFrZXkgb3IgbWQtZmF1bHR5IGJsb2NrIGRldmljZXMgcGVyaGFwcy4KCi1Fcmlj
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
