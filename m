Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PCUmAD248156 for <xfs@oss.sgi.com>; Tue, 25 May 2010 07:30:48 -0500
Received: from a.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D62221576706
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 05:34:50 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (alto.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id odDxoOya6ET8pZxH for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 05:34:50 -0700 (PDT)
Subject: Re: Is persistant preallocation possible?
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4BFB41D8.3020402@sandeen.net>
References: <1374176788.272721274754374474.JavaMail.root@mail-au.aconex.com>
	<4BFB41D8.3020402@sandeen.net>
Date: Tue, 25 May 2010 13:33:07 +0100
Message-Id: <1274790787.17233.281.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
Cc: Jeff Zheng <Jeff.Zheng@endace.com>, Nathan Scott <nathans@aconex.com>, xfs@oss.sgi.com

T24gTW9uLCAyMDEwLTA1LTI0IGF0IDIyOjE5IC0wNTAwLCBFcmljIFNhbmRlZW4gd3JvdGU6Cj4g
TmF0aGFuIFNjb3R0IHdyb3RlOgo+ID4gLS0tLS0gIkplZmYgWmhlbmciIDxKZWZmLlpoZW5nQGVu
ZGFjZS5jb20+IHdyb3RlOgo+ID4gCj4gPj4gSGksCj4gPj4KPiA+PiBXZSBhcmUgdHJ5aW5nIHRv
IGNvbnRyb2wgd2hlcmUgdGhlIGZpbGVzIGFyZSBiZWluZyBhbGxvY2F0ZWQgb24gdGhlCj4gPj4g
ZGlza3MsIGFuZCB3ZSB0cmllZCB4ZnMgcHJlYWxsb2NhdGlvbi4gV2hhdCB3ZSBmb3VuZCBpcyB0
aGF0IGVhY2ggdGltZQo+ID4+IHRoZSBmaWxlIGJlaW5nIHJlb3BlbmVkIHRoZSBsb2NhdGlvbiBv
ZiB0aGUgcHJlLWFsbG9jYXRlZCBzcGFjZSBjb3VsZAo+ID4+IGNoYW5nZSAobm90IGFsbCB0aGUg
dGltZSkuIElzIHRoZXJlIGEgd2F5IHRvIGRvIHBlcnNpc3RlbnQKPiA+PiBwcmVhbGxvY2F0aW9u
IGluIHhmcywgbGlrZSB0aGUgc2FtZSBmaWxlIHdpbGwgYWx3YXlzIGJlIG9uIHRoZSBzYW1lCj4g
Pj4gbG9jYXRpb24gb24gdGhlIGRpc2sgZ2l2ZW4gdGhhdCB0aGUgcmVxdWVzdGVkIHNpemUgZG9l
c27igJl0IGNoYW5nZT8KPiA+Pgo+ID4gCj4gPiBTb3VuZHMgbGlrZSB5b3UgYXJlIHRydW5jYXRp
bmcgdGhlIGZpbGUgKG9uIG9wZW4/KSwgYW5kIGhlbmNlIGRpc2NhcmRpbmcKPiA+IHRoZSBwcmVh
bGxvY2F0aW9uLiAgWEZTIHByZWFsbG9jYXRpb24gaXMgcGVyc2lzdGVudCBhbHJlYWR5LCBzbyBJ
IHRoaW5rCj4gPiBzb21ldGhpbmcgeW91IGFyZSBkb2luZyBtdXN0IGJlIGRpc2NhcmRpbmcgdGhv
c2UgcHJlYWxsb2NhdGVkIGV4dGVudHMuCj4gPiAKPiA+IENvdWxkIHlvdSBwb3N0IGEgdGVzdCBw
cm9ncmFtLCBvciBzZXF1ZW5jZSBvZiB4ZnNfaW8gY29tbWFuZHMsIHRoYXQgd291bGQKPiA+IGRl
bW9uc3RyYXRlIHRoZSBwcm9ibGVtPwo+ID4gCj4gPiBjaGVlcnMuCj4gPiAKPiAKPiAuLi4gbWF5
YmUgeW91IG1lYW4gdGhhdCB0cnVuY2F0aW5nIC8gcHJlLWFsbG9jYXRpbmcgdGhlIHNhbWUgc3Bh
Y2UgcmVwZWF0ZWRseQo+IG9uIHRoZSBzYW1lIGZpbGVuYW1lIGVuZHMgdXAgd2l0aCBibG9ja3Mg
bWFwcGVkIGluIGRpZmZlcmVudCBsb2NhdGlvbnMuLi4/Cj4gVGhhdCdzIGVudGlyZWx5IGV4cGVj
dGVkLi4uIG5vdGhpbmcgYWJvdXQgdGhlIHByZWFsbG9jYXRpb24gaW50ZXJmYWNlIGxldHMKPiB5
b3UgImNvbnRyb2wgKndoZXJlKiBmaWxlcyBhcmUgYmVpbmcgYWxsb2NhdGVkIiBhcyB5b3Ugc2Fp
ZCBhYm92ZS4uLgo+IAoKV2F5IGJhY2sgd2hlbiBJIHdyb3RlIHNvbWUgY29kZSB0byBkbyBqdXN0
IHRoaXMsIGJ1dCBJJ3ZlIG5ldmVyIGhhZCB0aGUKdGltZSB0byB3cmFwIGl0IGFsbCB1cC4gVGhl
IGJhc2ljIGlkZWEgaXMgdG8gYWRkIGFub3RoZXIgYXJndW1lbnQgdG8KcHJlYWxsb2NhdGUsIGFz
IGEgaGludCB3aGVyZSB0byB0cnkgZmlyc3QuIFRoZSBhbGxvY2F0b3IgdGhlbiB1c2VzIHRoZQon
ZXh0ZW5kIGZpbGUnIHBhdGgsIHdpdGggdGhlIGhpbnQgdGFraW5nIHRoZSBwbGFjZSBvZiB0aGUg
Y3VycmVudCBlb2YuCgpTZWUgaHR0cDovL29zcy5zZ2kuY29tL2FyY2hpdmVzL3hmcy8yMDA2LTA3
L21zZzAxMDA1Lmh0bWwKCmZvciBteSBvcmlnaW5hbCBwYXRjaGVzLiBJJ2Qgc3RpbGwgbGlrZSB0
byBoYXZlIHRoZXNlIHB1c2hlZCB0aHJvdWdoIC0Kd2hhdCB3b3VsZCBpdCB0YWtlPwoKLS0gClJv
Z2VyIFdpbGxjb2NrcyA8cm9nZXJAZmlsbWxpZ2h0Lmx0ZC51az4KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
