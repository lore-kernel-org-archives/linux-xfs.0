Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q368PFSG154476 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 03:25:16 -0500
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	LQ9nREZCgkKu2KiM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Apr 2012 01:25:15 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so1593106ghb.26
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:25:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120405213740.GA22824@infradead.org>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
Date: Fri, 6 Apr 2012 10:25:14 +0200
Message-ID: <CAAxjCExBcaB6J-u7ivZKWnKiF7oP10JRxzKzQNRuppHkTE2Tzw@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

PiB0aGFua3MgZm9yIHRoZSBkZXRhaWxlZCByZXBvcnQuCgpUaGFua3MgZm9yIHRoZSBkZXRhaWxl
ZCBhbmQga2luZCBhbnN3ZXIuCgo+IENhbiB5b3UgdHJ5IGEgZmV3IG1vdW50IG9wdGlvbnMgZm9y
IG1lIGJvdGggYWxsIHRvZ2V0aGVyIGFuZCBpZiB5b3UgaGF2ZQo+IHNvbWUgdGltZSBhbHNvIGlu
ZGl2aWR1YWxseS4KPgo+IMKgLW8gaW5vZGU2NAo+Cj4gwqAgwqAgwqAgwqBUaGlzIGFsbG93cyBp
bm9kZXMgdG8gYmUgY2xvc2UgdG8gZGF0YSBldmVuIGZvciA+MVRCCj4gwqAgwqAgwqAgwqBmaWxl
c3lzdGVtcy4gwqBJdCdzIHNvbWV0aGluZyB3ZSBob3BlIHRvIG1ha2UgdGhlIGRlZmF1bHQgc29v
bi4KClRoZSBmaWxlc3lzdGVtIGlzIG5vdCB0aGF0IGxhcmdlLiBJdOKAmXMgb25seSA0MDBHQi4g
SSB0dXJuZWQgaXQgb24KYW55d2F5LiBObyBkaWZmZXJlbmNlLgoKPiDCoC1vIGZpbGVzdHJlYW1z
Cj4KPiDCoCDCoCDCoCDCoFRoaXMga2VlcHMgZGF0YSB3cml0dGVuIGluIGEgc2luZ2xlIGRpcmVj
dG9yeSBncm91cCB0b2dldGhlci4KPiDCoCDCoCDCoCDCoE5vdCBzdXJlIHlvdXIgZGlyZWN0b3Jp
ZXMgYXJlIGxhcmdlIGVub3VnaCB0byByZWFsbHkgYmVuZWZpdAo+IMKgIMKgIMKgIMKgZnJvbSBp
dCwgYnV0IGl0J3Mgd29ydGggYSB0cnkuCj4gwqAtbyBhbGxvY3NpemU9NGsKPgo+IMKgIMKgIMKg
IMKgVGhpcyBkaXNhYmxlcyB0aGUgYWdyZXNzaXZlIGZpbGUgcHJlYWxsb2NhdGlvbiB3ZSBkbyBp
biBYRlMsCj4gwqAgwqAgwqAgwqB3aGljaCBzb3VuZHMgbGlrZSBpdCdzIG5vdCB1c2VmdWwgZm9y
IHlvdXIgd29ya2xvYWQuCgppbm9kZTY0K2ZpbGVzdHJlYW1zOiBubyBkaWZmZXJlbmNlCmlub2Rl
NjQrYWxsb2NzaXplOiBubyBkaWZmZXJlbmNlCmlub2RlNjQrZmlsZXN0cmVhbXMrYWxsb2NzaXpl
OiBubyBkaWZmZXJlbmNlIDooCgo+IEZvciBtZXRhZGF0YSBpbnRlbnNpdmUgd29ya2xvYWRzIGxp
a2UgeW91cnMgeW91IHdvdWxkIGJlIG11Y2ggYmV0dGVyCj4gdXNpbmcgYSBub24tc3RyaXBpbmcg
cmFpZCwgZS5nLiBjb25jYXRlbnRhdGlvbiBhbmQgbWlycm9yaW5nIGluc3RlYWQgb2YKPiByYWlk
IDUgb3IgcmFpZCA2LiDCoEkga25vdyB0aGlzIGhhcyBhIGNvc3QgaW4gdGVybXMgb2YgIndhc3Rl
ZCIgc3BhY2UsCj4gYnV0IGZvciBJT1BzIGJvdW5kIHdvcmtsb2FkIHRoZSBkaWZmZXJlbmNlIGlz
IGRyYW1hdGljLgoKSG1tLCBJ4oCZbSBzdXJlIHlvdeKAmXJlIHJpZ2h0LCBidXQgSeKAmW0gb3V0
IG9mIGx1Y2sgaGVyZS4gSWYgSSBoYWQgMjQKZHJpdmVzLCBJIGNvdWxkIHRoaW5rIGFib3V0IGEg
ZGlmZmVyZW50IG9yZ2FuaXphdGlvbi4gQnV0IHdpdGggb25seSA2CmJheXMsIEkgY2Fubm90IGdp
dmUgdXAgYWxsIHRoYXQgc3BhY2UuCgpBbHRob3VnaCAqaW4gdGhlb3J5KiwgaXQgKnNob3VsZCog
YmUgcG9zc2libGUgdG8gcnVuIGZhc3QgZm9yCndyaXRlLW9ubHkgd29ya2xvYWRzLiBUaGUgc3Ry
aXBlIHNpemUgaXMgNjQgS0IgKDR4MTYpLCBhbmQgaXTigJlzIG5vdApsaWtlIGRhdGEgaXMgd3Jp
dHRlbiBhbGwgb3ZlciB0aGUgcGxhY2UuIFNvIGl0IHNob3VsZCB2ZXJ5IHdlbGwgYmUKcG9zc2li
bGUgdG8gd3JpdGUgdGhlIGRhdGEgb3V0IGluIHNvbWUgcmVhc29uYWJseSBzaXplZCBhbmQgYWxp
Z25lZApjaHVua3MuIFRoZSBmaWxlc3lzdGVtIHBhcnRpdGlvbiBpdHNlbGYgaXMgbmljZWx5IGFs
aWduZWQuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
