Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF77529DF8
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 14:11:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F4018F8050
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 12:11:00 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by cuda.sgi.com with ESMTP id sHFlMF5bcgaiYGhu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 12:10:58 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 21:10:47 +0200
Message-ID: <5585593.Xe5bNQZW47@wuerfel>
In-Reply-To: <C57EA6CA-236A-4C93-95F8-21F46A3622DA@oracle.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401735504.6065.227.camel@montana.filmlight.ltd.uk>
	<C57EA6CA-236A-4C93-95F8-21F46A3622DA@oracle.com>
MIME-Version: 1.0
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
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, xfs@oss.sgi.com, LKML Kernel <linux-kernel@vger.kernel.org>, geert@linux-m68k.org, Christoph Hellwig <hch@infradead.org>, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lftan@altera.com, tglx@linutronix.de, Roger Willcocks <roger@filmlight.ltd.uk>, joseph@codesourcery.com

T24gTW9uZGF5IDAyIEp1bmUgMjAxNCAxNTowNDoyNyBDaHVjayBMZXZlciB3cm90ZToKPiBPbiBK
dW4gMiwgMjAxNCwgYXQgMjo1OCBQTSwgUm9nZXIgV2lsbGNvY2tzIDxyb2dlckBmaWxtbGlnaHQu
bHRkLnVrPiB3cm90ZToKPiAKPiA+IAo+ID4gT24gTW9uLCAyMDE0LTA2LTAyIGF0IDExOjA0IC0w
NDAwLCBDaHVjayBMZXZlciB3cm90ZToKPiA+IAo+ID4+IE5GU3YyLzMgdGltZXN0YW1wcyBhcmUg
YSBwYWlyIG9mIHVuc2lnbmVkIDMyLWJpdCB2YWx1ZXM6IG9uZSB2YWx1ZSBmb3IKPiA+PiBzZWNv
bmRzIHNpbmNlIG1pZG5pZ2h0IEdNVCBKYW4gMSwgMTk3MCwgYW5kIG9uZSB2YWx1ZSBmb3IgbmFu
b3NlY29uZHMuCj4gPj4gKFNlZSB0aGUgZGVmaW5pdGlvbiBvZiBuZnN0aW1lMyBpbiBSRkMgMTgx
MykuCj4gPj4gCj4gPiAKPiA+IG5mc3RpbWUzIGNvdWxkIGJlIGV4dGVuZGVkIGJ5IHJlZGVmaW5p
bmcgdGhlIG90aGVyd2lzZSB1bnVzZWQKPiA+IG5hbm9zZWNvbmRzIGJpdHN7MzEsMzB9IGFzIHNl
Y29uZHN7MzMsMzJ9LCB0byBnaXZlIGEgKHNpZ25lZCkgMzQtYml0Cj4gPiBzZWNvbmRzIGZpZWxk
IGFuZCBhbiB1bnNpZ25lZCAzMC1iaXQgbmFub3NlY29uZHMgZmllbGQuCj4gPiAKPiA+IFRoaXMg
Y291bGQgcmVwcmVzZW50IDE5NzAgKy8tIDI3MiB5ZWFycy4KPiA+IAo+ID4gU2VydmVycyBjb3Vs
ZCBpbmRpY2F0ZSB0aGV5IGNhbiB1bmRlcnN0YW5kIHRoZSBleHRlbmRlZCB0aW1lIGZvcm1hdCBi
eQo+ID4gYWRkaW5nIGEgbmV3IEZTSU5GTyBjYXBhYmlsaXR5IC0gRlNGM19DQU5TRVRUSU1FX0VY
Lgo+ID4gCj4gPiBDbGllbnRzIHdvdWxkIHVzZSBhIG5ldyBTRVRfVE9fQ0xJRU5UX1RJTUVfRVgg
dGltZV9ob3cgZW51bSB3aGVuIHNlbmRpbmcKPiA+IHRpbWVzdGFtcHMgc28gb2xkIHNlcnZlcnMg
d291bGQgYmUgcHJvdGVjdGVkIGZyb20gbmV3IGNsaWVudHMuCj4gCj4gWW91IHdvdWxkIGhhdmUg
dG8gZ2V0IHRoZSBJRVRG4oCZcyBORlN2NCB3b3JraW5nIGdyb3VwIHRvIHNpZ24gb2ZmIG9uCj4g
dGhpcyBjaGFuZ2UuIE90aGVyd2lzZSwgTGludXggd291bGQgYmUgdGhlIG9ubHkgTkZTdjMgaW1w
bGVtZW50YXRpb24KPiB0aGF0IHN1cHBvcnRzIHRoZSBleHRlbnNpb24uCj4gCj4gQnV0IEkgc3Vz
cGVjdCB0aGUgYW5zd2VyIHlvdeKAmWQgZ2V0IGlzIOKAnFVzZSBORlN2NC7igJ0KCldoaWxlIEkn
dmUgbmV2ZXIgZGVhbHQgd2l0aCBhbiBORlMgc3RhbmRhcmRpemF0aW9uLCBJJ2QgYXNzdW1lIHRo
aXMgaXMKYSB3b3JrYWJsZSBhbnN3ZXIuIFRoZSBORlN2MiBhbmQgTkZTdjMgZGVmaW5pdGlvbiBj
bGVhcmx5IGRlZmluZXMgYSB2YWxpZApyYW5nZSBvZiB0aW1lcyB1bnRpbCAyMTA2IHVzaW5nIHVu
c2lnbmVkIHNlY29uZHMsIGFuZCB0aGF0IHNob3VsZCByZWFsbHkKZ2l2ZSBlbm91Z2ggdGltZSB0
byBtaWdyYXRlIHRvIHNvbWV0aGluZyBiZXR0ZXIgKG5vdCBuZWNlc3NhcmlseSBORlN2NCkuCgoJ
QXJuZAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
