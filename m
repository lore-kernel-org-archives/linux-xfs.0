Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JENjUe103304 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:23:46 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ahO6r71OKeAEwERj for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:23:44 -0700 (PDT)
Message-ID: <4FE08B65.70303@redhat.com>
Date: Tue, 19 Jun 2012 09:23:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
	<20120619141933.GC10637@thunk.org>
In-Reply-To: <20120619141933.GC10637@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>

T24gNi8xOS8xMiA5OjE5IEFNLCBUZWQgVHMnbyB3cm90ZToKPiBPbiBUdWUsIEp1biAxOSwgMjAx
MiBhdCAwNDowOTo0OFBNICswMjAwLCBMdWvDocWhIEN6ZXJuZXIgd3JvdGU6Cj4+Cj4+IFdpdGgg
dGhpbiBwcm92aXNpb25pbmcgeW91J2xsIGdldCB0b3RhbGx5IGRpZmZlcmVudCBmaWxlIHN5c3Rl
bQo+PiBsYXlvdXQgdGhhbiBvbiBmdWxseSBwcm92aXNpb25lZCBkaXNrIGFzIHlvdSBwdXNoIG1v
cmUgYW5kIG1vcmUKPj4gd3JpdGVzIHRvIHlvdXIgZHJpdmUuIFRoaXMgdW5mb3J0dW5hdGVseSBo
YXMgZ3JlYXQgaW1wYWN0IG9uCj4+IHBlcmZvcm1hbmNlIHNpbmNlIGZpbGUgc3lzdGVtcyB1c3Vh
bGx5IGhhdmUgYSBsb3Qgb2Ygb3B0aW1pemF0aW9uIG9uCj4+IHdoZXJlIHRvIHB1dCBkYXRhL21l
dGFkYXRhIG9uIHRoZSBkcml2ZSBhbmQgaG93IHRvIHJlYWQgdGhlbS4KPj4gSG93ZXZlciBpbiBj
YXNlIG9mIHRoaW5seSBwcm92aXNpb25lZCBzdG9yYWdlIHRob3NlIG9wdGltaXphdGlvbgo+PiB3
b3VsZCBub3QgaGVscC4gQW5kIHllcywgeW91IGp1c3QgaGF2ZSB0byBleHBlY3QgbG93ZXIgcGVy
Zm9ybWFuY2UKPj4gd2l0aCBkbS10aGluIGZyb20gdGhlIGZpbGUgc3lzdGVtIG9uIHRvcCBvZiBp
dC4gSXQgaXMgbm90IGFuZCBpdAo+PiB3aWxsIG5ldmVyIGJlIGlkZWFsIHNvbHV0aW9uIGZvciB3
b3JrbG9hZHMgd2hlcmUgeW91IGV4cGVjdCB0aGUgYmVzdAo+PiBwZXJmb3JtYW5jZS4KPiAKPiBP
bmUgb2YgdGhlIHRoaW5ncyB3aGljaCB3b3VsZCBiZSBuaWNlIHRvIGJlIGFibGUgdG8gZWFzaWx5
IHNldCB1cCBpcyBhCj4gY29uZmlndXJhdGlvbiB3aGVyZSB3ZSBnZXQgdGhlIGJlbmVmaXRzIG9m
IHRoaW4gcHJvdmlzaW9uaW5nIHdpdGgKPiByZXNwZWN0IHRvIHNuYXBzaG9zdCwgYnV0IHdoZXJl
IHRoZSB1bmRlcmx5aW5nIGJsb2NrIGRldmljZSB1c2VkIGJ5Cj4gdGhlIGZpbGUgc3lzdGVtIGlz
IGNvbnRpZ3VvdXMuICBUaGF0IGlzLCBpdCB3b3VsZCBiZSByZWFsbHkgdXNlZnVsIHRvCj4gKm5v
dCogdXNlIHRoaW4gcHJvdmlzaW9uaW5nIGZvciB0aGUgdW5kZXJseWluZyBmaWxlIHN5c3RlbSwg
YnV0IHRvIHVzZQo+IHRoaW4gcHJvdmlzaW9uZWQgc25hcHNob3RzLiAgVGhhdCB3YXkgd2Ugb25s
eSBwYXkgdGhlIHRoaW5wCj4gcGVyZm9ybWFuY2UgcGVuYWx0eSBmb3IgdGhlIHNuYXBzaG90cywg
YW5kIG5vdCBmb3Igbm9ybWFsIGZpbGUgc3lzdGVtCj4gb3BlcmF0aW9ucy4gIFRoaXMgaXMgc29t
ZXRoaW5nIHRoYXQgd291bGQgYmUgdmVyeSB1c2VmdWwgYm90aCBmb3IgZXh0NAo+IGFuZCB4ZnMu
CgpJIGFncmVlLCBhbmQgaGF2ZSBhc2tlZCBmb3IgZXhhY3RseSB0aGUgc2FtZSB0aGluZy4uLiB0
aG91Z2ggSSBoYXZlIG5vCmlkZWEgaG93IGhhcmQgaXQgaXMgdG8gZGlzZW50YW5nbGUgYWxsb2Nh
dGlvbi1hd2FyZSBzbmFwc2hvdHMgZnJvbSB0aGluZwpwcm92aXNpb25lZCBzdG9yYWdlLgoKLUVy
aWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
