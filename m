Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q367Wa7H143225 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 02:32:36 -0500
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	VrwQY1soRWi8qFed (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Apr 2012 00:32:32 -0700 (PDT)
Received: by ggni4 with SMTP id i4so1573851ggn.26
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 00:32:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20350.16033.766746.102885@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.16033.766746.102885@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 09:32:30 +0200
Message-ID: <CAAxjCExJLd9sRNXWLCVfswegGnX=KK90s62e7ZaVUgz9kMwv1Q@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

PiBodHRwOi8vaGFyZGZvcnVtLmNvbS9zaG93cG9zdC5waHA/cz1jMTk5NjQyODVlNzYwYmVlNDdi
ODU1OGFlODI4OTlkNSZwPTEwMzM5NTgwNTEmcG9zdGNvdW50PTQKPiDCoMKrT25lIGlzIGEgc3Rp
Y2sgb2YgbWVtb3J5IHdpdGggYSBiYXR0ZXJ5IGF0dGFjaGVkIHRvIGl0IGFuZCBvbmUKPiDCoHdp
dGhvdXQuIFRoZSBvbmUgd2l0aG91dCBpcyB3aGF0IHRoZSBiYXNpYyBtb2RlbHMgc2hpcCB3aXRo
Cj4gwqBhbmQgdXN1YWxseSBoYXMgZWl0aGVyIDI1NiBvciA1MTJNYiBvZiBtZW1vcnksIGl0IHN1
cHBvcnRzCj4gwqBjYWNoaW5nIGZvciByZWFkIG9wZXJhdGlvbnMgb25seS4gWyAuLi4gXSBZb3Ug
bmVlZCB0aGUgYmF0dGVyeQo+IMKgYmFja2VkIHdyaXRlIGNhY2hlIG1vZHVsZSBpZiB5b3Ugd2Fu
dCB0byBiZSBhYmxlIHRvIHVzZS90dXJuCj4gwqBvbiB3cml0ZSBjYWNoaW5nIG9uIHRoZSBhcnJh
eSBjb250cm9sbGVyIHdoaWNoIG1ha2VzIGEgaHVnZQo+IMKgZGlmZmVyZW5jZSBmb3Igd3JpdGUg
cGVyZm9ybWFuY2UgaW4gZ2VuZXJhbCBhbmQgaXMgcHJldHR5IG11Y2gKPiDCoGNyaXRpY2FsIGZv
ciByYWlkIDUgcGVyZm9ybWFuY2Ugb24gd3JpdGVzLsK7Cj4KPiBJdCBtYXkgYmUgd29ydGh3aGls
ZSB0byBjaGVjayBpZiB0aGVyZSBpcyBhbiBlbmFibGVkIEJCV0MKPiBiZWNhdXNlIGlmIHRoZXJl
IGlzIHRoZSBCQldDIHRoZSBob3N0IGFkYXB0ZXIgc2hvdWxkIGJlCj4gYnVmZmVyaW5nIHdyaXRl
cyB1cCB0byAyNTZNaUIvNTEyTWlCIGFuZCBzb3J0aW5nIHRoZW0gdGh1cyBsb25nCj4gaW50ZXIt
QUcgc2Vla3Mgc2hvdWxkIGJlIGhhcHBlbmluZyBvbmx5IDEwIG9yIDUgdGltZXMgb3Igbm90Cj4g
bXVjaCBtb3JlICg0IHRpbWVzKSB0aGF0LiBJbnN0ZWFkIGl0IG1heSBiZSBoYXBwZW5pbmcgdGhh
dCB0aGUKPiBQNDAwIGlzIGRvaW5nIHdyaXRlLXRocm91Z2gsIHdoaWNoIHdvdWxkIHJlZmxlY3Qg
dGhlIHVuc29ydGVkCj4gc2VlayBwYXR0ZXJuIGF0IHRoZSBMaW51eC0+aG9zdCBhZGFwdGVyIGxl
dmVsIGludG8gdGhlIGhvc3QKPiBhZGFwdGVyLT5kaXNrIGRyaXZlIGxldmVsLgoKVGhlIHdyaXRl
IGNhY2hlIGNhbiBhbHNvIGJlIGVuYWJsZWQgd2l0aG91dCBhIGJhdHRlcnkgcHJlc2VudCAoYXQK
Y29uc2lkZXJhYmxlIHJpc2spLCBidXQgSSBpbnNpc3RlZCB0byBnZXQgYSBiYXR0ZXJ5LiBJdCBp
cyBlbmFibGVkLAphbmQgaXQgbWFrZXMgYSBub3RpY2VhYmxlIGRpZmZlcmVuY2UuIFdpdGhvdXQg
aXQsIGl04oCZcyBldmVuIHNsb3dlcgoobW9yZSB0aGFuIGZhY3RvciAyKS4KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
