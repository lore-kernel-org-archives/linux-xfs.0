Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3ADxcl8153437 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 08:59:39 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id UQSlVtV1aHnr4FAK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Apr 2012 06:59:37 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so3318362yhj.26
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 06:59:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F83E293.8000509@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com> <4F82063F.4070609@hardwarefreak.com>
	<4F826FFA.4050207@hardwarefreak.com>
	<CAAxjCExcd6T9gUM5AHzZM535e1kyb9WJd_ib2MFkeC_DbU7TXA@mail.gmail.com>
	<4F83E293.8000509@hardwarefreak.com>
Date: Tue, 10 Apr 2012 15:59:37 +0200
Message-ID: <CAAxjCEybL_mXEED6sM=q52FW7KYjsOEQNek8rVUYAMK76ncHDQ@mail.gmail.com>
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

PiBXaXRoIDQgQUdzIHRoaXMgbXVzdCByZXByZXNlbnQgdGhlIFJBSUQ2IG9yIFJBSUQxMCBjYXNl
LgoKWWVzLCB0aGUgb3JpZ2luYWwgUkFJRCA2IGNhc2UuCgo+PiBZZXMsIGluIHRoZW9yeSwgYSBn
b29kIGNhY2hlIGNvbnRyb2xsZXIgc2hvdWxkIGJlIGFibGUgdG8gc29ydCB0aGlzCj4+IG91dC4g
QnV0IGF0IGxlYXN0IHRoaXMgcGFydGljdWxhciBjb250cm9sbGVyIGlzIG5vdCBhYmxlIHRvIGRv
IHNvIGFuZAo+PiBjb3VsZCB1c2UgYSBsaXR0bGUgaGVscC4KPgo+IElzIHRoZSBjYWNoZSBpbiB3
cml0ZS10aHJvdWdoIG9yIHdyaXRlLWJhY2sgbW9kZT8gwqBUaGUgbGF0dGVyIHNob3VsZAo+IGFs
bG93IGZvciBhZ2dyZXNzaXZlIHJlb3JkZXJpbmcuIMKgVGhlIGZvcm1lciBub25lLCBvciB2ZXJ5
IGxpdHRsZS4gwqBBbmQKPiBpcyBhbGwgb2YgaXQgZGVkaWNhdGVkIHRvIHdyaXRlcywgb3IgaXMg
aXQgc3BsaXQ/IMKgSWYgc3BsaXQsIGRlZGljYXRlIGl0Cj4gYWxsIHRvIHdyaXRlcy4gwqBMaW51
eCBpcyBnb2luZyB0byBjYWNoZSBibG9jayByZWFkcyBhbnl3YXksIHNvIGl0IG1ha2VzCj4gbGl0
dGxlIHNlbnNlIHRvIGNhY2hlIHRoZW0gaW4gdGhlIGNvbnRyb2xsZXIgYXMgd2VsbC4KClRoZSBj
YWNoZSBpcyBhIHdyaXRlLWJhY2sgY2FjaGUuIFllcywgaXTigJlzIHNwbGl0IDc1JSB3cml0ZSAv
IDI1JSByZWFkLgpDaGFuZ2luZyB0byAxMDAlIHdyaXRlIGRvZXMgbm90IG1ha2UgYSBkaWZmZXJl
bmNlLgoKSSBjYW4gaW1hZ2luZSB0aGF0IHRoZSBzbWFsbCByZWFkIGNhY2hlIG1pZ2h0IGJlIGJl
bmVmaWNpYWwgZm9yCnBhcnRpYWwgc3RyaXBlIHdyaXRlcywgd2hlbiB0aGUgc3RyaXBlIGNvbnRl
bnRzIGZyb20gdGhlIHVudG91Y2hlZApkcml2ZXMgYXJlIGluIGNhY2hlLgoKPj4gQWxzbywgYSBz
aW5nbGUgY29uc3VtZXItZ3JhZGUgZHJpdmUgaXMKPj4gY2VydGFpbmx5IG5vdCBoZWxwZWQgYnkg
dGhpcyB3cml0ZSBvcmRlcmluZy4KPgo+IEFyZSB5b3UgcmVmZXJyaW5nIHRvIHRoZSBNdXNoa2lu
IFNTRCBJIG1lbnRpb25lZD8KCk5vLCBJIG1lYW50IHJvdGF0aW9uYWwgc3RvcmFnZS4gQnV0IGV2
ZW4gU1NEcyBzaG91bGQgZ2FpbiBhdCBsZWFzdCBhCmxpdHRsZSBmcm9tIGEgbGluZWFyIHdyaXRl
IHBhdHRlcm4uCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMK
