Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RN7iDA153765 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 18:07:44 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2384B1E52E37
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 16:07:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qs0q28M7uuDFwZ47 for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 16:07:42 -0700 (PDT)
Date: Tue, 28 Jun 2011 09:07:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfstests: fsx fallocate support is b0rked
Message-ID: <20110627230739.GG32466@dastard>
References: <1309153722-1231-1-git-send-email-david@fromorbit.com>
	<1309153722-1231-3-git-send-email-david@fromorbit.com>
	<4E08F324.5040703@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E08F324.5040703@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

T24gTW9uLCBKdW4gMjcsIDIwMTEgYXQgMDQ6MTY6MjBQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIDYvMjcvMTEgMTI6NDggQU0sIERhdmUgQ2hpbm5lciB3cm90ZToKPiA+IEZyb206
IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiA+IAo+ID4gVGhlIHJlY2VudCBm
YWxsb2NhdGUvZnB1bmNoIGFkZGl0aW9ucyB0byBmc3ggaGF2ZSBub3QgYWN0dWFsbHkgYmUKPiA+
IGV4ZWN1dGluZyBmYWxsb2NhdGUvZnB1bmNoIG9wZXJhdGlvbnMuIFRoZSBsb2dpYyB0byBzZWxl
Y3Qgd2hhdAo+ID4gb3BlcmF0aW9uIHRvIHJ1biBpcyBicm9rZW4gaW4gc3VjaCBhIHdheSB0aGF0
IGZzeCBoYXMgYmVlbiBleGVjdXRpbmcKPiA+IG1hcHBlZCB3cml0ZXMgYW5kIHRydW5jYXRlcyBp
bnN0ZWFkIG9mIGZhbGxvY2F0ZSBhbmQgZnB1bmNoCj4gPiBvcGVyYXRpb25zLgo+ID4gCj4gPiBS
ZW1vdmUgYWxsIHRoZSAoYjBya2VuKSBzbWFydHktcGFudHMgc2VsZWN0aW9uIGxvZ2ljIGZyb20g
dGhlIHRlc3QoKQo+IAo+IEkgaG9wZSBJIG9ubHkgZXh0ZW5kZWQgdGhhdCBzbWFydHktcGFudHMg
bG9naWMgYW5kIGRpZG4ndCBpbnZlbnQgaXQuCj4gSSBzdXBwb3NlIG1heWJlIEkgYnJva2UgaXQg
Zmlyc3QgdGhvdWdoLCBkYW1uLgoKSXQgd2FzIGNvbnZvbHV0ZWQgYmVmb3JlIHRoZSBmYWxsb2Nh
dGUgY29kZSB3YXMgYWRkZWQuIEkgY2FuIHNlZSB3aHkKaXQgd2FzIGVhc3kgdG8gYnJlYWsuLi4u
Cgo+ID4gZnVuY3Rpb24uIFJlcGxhY2UgaXQgd2l0aCBhIGNsZWFybHkgZGVmaW5lZCBzZXQgb2Yg
b3BlcmF0aW9ucyBmb3IKPiA+IGVhY2ggbW9kZSBhbmQgdXNlIHVuZGVyc3RhbmRhYmxlIGZhbGxi
YWNrIGxvZ2ljIHdoZW4gdmFyaW91cwo+ID4gb3BlcmF0aW9uIHR5cGVzIGhhdmUgYmVlbiBkaXNh
YmxlZC4gVGhlbiB1c2UgYSBzaW1wbGUgc3dpdGNoCj4gPiBzdGF0ZW1lbnQgdG8gZXhlY3V0ZSBl
YWNoIG9mIHRoZSBkaWZmZXJlbnQgb3BlcmF0aW9ucywgcmVtb3ZpbmcgdGhlCj4gPiB0b3J0dXJl
ZCBuZXN0aW5nIG9mIGlmL2Vsc2Ugc3RhdGVtZW50cyB0aGF0IG9ubHkgc2VydmUgdG8gb2JmdXNj
YXRlCj4gPiB0aGUgY29kZS4KPiA+IAo+ID4gTkFzIGEgcmVzdWx0LCBmc3ggdXNlcyBmYWxsb2Nh
dGUvZnB1bmNoIGFwcHJvcHJpYXRlbHkgZHVyaW5nCj4gPiBvcGVyYXRpb25zLCBhbmQgdXNlcy9k
aXNhYmxl0ZUgdGhlIG9wZXJhdGlvbnMgYXMgZGVmaW5lZCBvbiB0aGUKPiA+IGNvbW1hbmQgbGlu
ZSBjb3JyZWN0bHkuCj4gCj4gSG0gd2UncmUgYmFjayBpbiB0aGUgZnN4IG1haW50ZW5hbmNlIGJ1
c2luZXNzIEkgZ3Vlc3MuCgpBcyBzb29uIGFzIHdlIHN0YXJ0IG1vZGlmeWluZyBpdC4uLgoKPiBX
b3VsZCBpdCBiZSB3b3J0aCBkb2luZyBkZWZpbmVzIG9yIGFuIGVudW0gZm9yIHRoZSBvcHMvY2Fz
ZXMsIHRvIG1ha2UgaXQKPiBhIGxpdHRsZSBtb3JlIHJlYWRhYmxlPwoKSSB0aGluayBiZXR0ZXIg
d2lsbCBiZSB0byByZWRlZmluZSB0aGUgT1BfKiBudW1iZXJzIHRvIG1hdGNoIHRoaXMKZ2VuZXJh
dGlvbiB0ZWNobmlxdWUgc28gd2UgZG9uJ3QgaGF2ZSB0d28gZGlmZmVyZW50IHNldHMgb2Ygb3AK
bnVtYmVycy4KCkknbGwgZG8gdGhpcyBhbmQgcG9zdCBhIG5ldyB2ZXJzaW9uLgoKQ2hlZXJzLAoK
RGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
