Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3G6A0D027296 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 11:06:12 -0500
Date: Thu, 3 Nov 2011 12:05:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 6/8] xfstests: add fiemap operation to fsstress
Message-ID: <20111103160559.GB15045@thunk.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
	<20111102195534.GB22500@infradead.org>
	<FA2EDC7F-92EC-449E-9FBC-B7955283DFAC@mit.edu>
	<87wrbhxya6.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87wrbhxya6.fsf@dmbot.sw.ru>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de, aelder@sgi.com

T24gVGh1LCBOb3YgMDMsIDIwMTEgYXQgMDM6MDQ6MTdQTSArMDQwMCwgRG1pdHJ5IE1vbmFraG92
IHdyb3RlOgo+IE9uIFRodSwgMyBOb3YgMjAxMSAwNjo1NDoxNiAtMDQwMCwgVGhlb2RvcmUgVHNv
IDx0eXRzb0BtaXQuZWR1PiB3cm90ZToKPiA+IAo+ID4gT24gTm92IDIsIDIwMTEsIGF0IDM6NTUg
UE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+ID4gCj4gPiA+IEFsZXgsIEVyaWMsIERhdmUg
LSBzaG91bGQgd2UgYWRkIG5ldyB0ZXN0cyB3aXRoIHRoZSBuZXcgb3BlcmF0aW9ucwo+ID4gPiBE
bWl0cnkgYWRkZWQsIG9yIGlzIGFkZGluZyBuZXcgb3BzIHRvIHRoZSBleGlzdGluZyB0ZXN0cyBm
aW5lPwo+ID4gCj4gPiBPbmUgYXJndW1lbnQgZm9yIGFkZGluZyBuZXcgb3BzIHRvIGV4aXN0aW5n
IHRlc3RzIGlzIHRoYXQgaXQgbWFrZXMKPiA+IHRoZSBydW4gdGltZSBvZiB0aGUgZW50aXJlIHRl
c3Qgc3VpdGUgdGFrZSBsb25nZXIuICBBIFFBIHBhc3MgaXMKPiA+IGFscmVhZHkgdGFraW5nIHF1
aXRlIGEgd2hpbGUsIGFuZCBpdCB3b3VsZCBiZSBuaWNlIGlmIHdlIGNvdWxkCj4gPiBrZWVwIHhm
c3Rlc3RzIGFzIGVmZmljaWVudCBhcyBwb3NzaWJsZSBpbiB0ZXJtcyBvZiB0aGUgbWF4aW11bQo+
ID4gdGVzdGluZyBjb3ZlcmFnZSBwZXIgdGltZSBzcGVudCBydW5uaW5nIHRoZSB0ZXN0IHN1aXRl
4oCmLgo+Cj4gWWVzLCBidXQgcmVncmVzc2lvbiB0ZXN0IHdpdGggZXhwbGljaXQgc2VlZCBvcHRp
b24gc2hvdWxkIGJlCj4gcHJlc2VydmVkLiBOdW1iZXIgb2Ygc3VjaCB0ZXN0IGlzIG5vdCB0b28g
YmlnLCBzbyBpdCBpcyByZWFzb25hYmxlIHRvCj4gaGFyZGNvZGUgc2V0IG9mIG9wZXJhdGlvbnMg
aW4gc3VjaCB0ZXN0cyBhbmQgbGV0IGFsbCBvdGhlcnMgdXNlIG5ldyBmZWF0dXJlcy4KClRoYXQn
cyBub3Qgd2hhdCBJIHdhcyB0YWxraW5nIGFib3V0LiAgT2YgY291cnNlIHRoZXJlIHNob3VsZCBi
ZSBhIHdheQp0byBydW4gYSByZWdyZXNzaW9uIHRlc3Qgd2l0aCBhbiBleHBsaWNpdCBzZWVkIG9w
dGlvbiAoYWx0aG91Z2ggaW4KZ2VuZXJhbCBJIHRoaW5rIGEgc3BlY2lmaWMgdGVzdCBpbiB4ZnN0
ZXN0cyBzaG91bGQgYnkgZGVmYXVsdCB1c2UgYQpyYW5kb20gc2VlZCwgYW5kIGhhdmUgYSB3YXkg
dG8gZWFzaWx5IHNwZWNpZnkgYW4gZXhwbGljaXQgc2VlZCB3aXRob3V0CmhhdmluZyB0byByZXZl
cnNlIGVuZ2luZWVyIHRoZSB0ZXN0IGFuZCBydW5uaW5nIGZzc3RyZXNzIG1hbnVhbGx5KS4KCldo
YXQgSSB3YXMgdGFsa2luZyBhYm91dCB3YXMgdGhlIGZhY3Qgd2UgYWxyZWFkeSBoYXZlIHNldmVy
YWwgKGhhbGYgYQpkb3plbiBvciBzbywgaWYgbWVtb3J5IHNlcnZlcyBjb3JyZWN0bHkpIHhmc3Rl
c3RzIHRoYXQgdXNlIGZzc3RyZXNzCndpdGggYSBkaWZmZXJlbnQgc2V0IG9mIGZzc3RyZXNzIG9w
dGlvbnMuICBJbiBzb21lIGNhc2VzIGl0IG1ha2VzIHRvCmFkZCBhIG5ldyBudW1iZXJlZCB4ZnN0
ZXN0IHN1YnRlc3QsIGJ1dCBJJ2QgcmF0aGVyIG5vdCBmaW5kIHRoYXQgd2UndmUKZG91YmxlZCB0
aGUgbnVtYmVyIG9mIHRlc3RzIHVzaW5nIGZzc3RyZXNzIGluIHRoZSBmdXR1cmUsIGFuZCB3aXRo
IGl0LApkb3VibGVkIHRoZSBydW4tdGltZSBvZiB0aGUgYXV0byBvciBxdWljayB4ZnN0ZXN0cyBn
cm91cC4uLi4KCgkgICAgCSAgICAgCSAgICAJICAgIC0gVGVkCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dp
LmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
