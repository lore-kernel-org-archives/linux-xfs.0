Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AL0Fw7209317 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 16:00:15 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	IMV2iQcUtQ4n16rY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 14:00:13 -0700 (PDT)
Received: by yenq2 with SMTP id q2so213736yen.26
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 14:00:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F849BAE.6070901@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
	<CAAxjCExBcaB6J-u7ivZKWnKiF7oP10JRxzKzQNRuppHkTE2Tzw@mail.gmail.com>
	<201204072057.38286.Martin@lichtvoll.de>
	<CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
	<4F849BAE.6070901@hardwarefreak.com>
Date: Tue, 10 Apr 2012 23:00:12 +0200
Message-ID: <CAAxjCExsZ5kkwdJSJegO13psaF2DO63TjQrG0TQytLbDUiLa0Q@mail.gmail.com>
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
To: stan@hardwarefreak.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

PiBJcyB0aGUgTFZNIHZvbHVtZSBhbGlnbmVkIHRvIHRoZSBSQUlEIHN0cmlwZT8gwqBJcyB0aGVp
ciBhIHBhcnRpdGlvbiBhdG9wCj4gdGhlIFJBSUQgTFVOIGFuZCB1bmRlciBMVk0/IMKgSXMgdGhl
IHBhcnRpdGlvbiBhbGlnbmVkPyDCoFdoeSBMVk0gYW55d2F5PwoKWWVzLCBpdCBpcyBhbGlnbmVk
LiBJIGZvbGxvd2VkIHRoZSBhZHZpY2UgZnJvbQo8aHR0cDovL3d3dy5teXNxbHBlcmZvcm1hbmNl
YmxvZy5jb20vMjAxMS8wNi8wOS9hbGlnbmluZy1pby1vbi1hLWhhcmQtZGlzay1yYWlkLXRoZS10
aGVvcnkvPi4KCldoeSBMVk0/IEJlY2F1c2Ugd2UgdXNlIGl0IG9uIGxvdHMgb2Ygc2VydmVycywg
YW5kIHRoZXJlIGlzIHNvbWUgdmFsdWUKdG8gaGF2aW5nIGEgc29tZXdoYXQgc2ltaWxhciBzZXR1
cCBpbiBkZXZlbG9wbWVudCBhcyBpbiBwcm9kdWN0aW9uLgpJ4oCZdmUgZG9uZSBzaW1pbGFyIHRl
c3RzIHRpbWUgYW5kIGFnYWluIHdpdGggTFZNIGFuZCB3aXRob3V0LCBhbmQgSeKAmXZlCm5ldmVy
IGV2ZXIgbWVhc3VyZWQgYSBzaWduaWZpY2FudCBkaWZmZXJlbmNlLiBJIGhhdmVu4oCZdCByZS10
ZXN0ZWQgaXQKdGhpcyB0aW1lLCB0cnVlLCBidXQgSSB3b3VsZCBiZSBzdXJwcmlzZWQgaWYgaXQg
d291bGQgbWFnaWNhbGx5IGJlaGF2ZQpjb21wbGV0ZWx5IGRpZmZlcmVudGx5IHRoaXMgdGltZS4K
Cj4gVGhlIGRldmlsIGlzIGFsd2F5cyBpbiB0aGUgZGV0YWlscy4gwqBXZXJlIHlvdSB1c2luZyBw
YXJ0aXRpb25zIGFuZCBMVk0KPiB3aXRoIHRoZSBSQUlEMSBjb25jYXQgdGVzaW5nPyDCoFdpdGgg
dGhlIGZyZWUgc3BhY2UgdGVzdGluZz8KCkkgdXNlZCBMVk0gbGluZWFyIGZvciB0aGUgY29uY2F0
ZW5hdGlvbiDigJMgb25lIHZvbHVtZSBncm91cCBtYWRlIGZyb20gMwpwaHlzaWNhbCB2b2x1bWVz
LiBUaGUgcHZvbHMgd2VyZSBvbiBwcmltYXJ5IHBhcnRpdGlvbnMuIFRoZSBvbmUtdm9sdW1lClJB
SUQgNiBpcyBzZXQgdXAgc2ltaWxhcmx5OyBmcm9tIG9ubHkgb25lIHB2b2wgb2YgY291cnNlLgoK
PiBJIGFzc3VtZWQgeW91IHdlcmUgZGlyZWN0bHkgZm9ybWF0dGluZyB0aGUgTFVOIHdpdGggWEZT
LiDCoFdpdGggTFZNIGFuZAo+IHBvc3NpYmx5IHBhcnRpdGlvbnMgaW52b2x2ZWQgaGVyZSwgdGhh
dCBjb3VsZCBleHBsYWluIHNvbWUgb2YgdGhlCj4gbWVkaW9jcmUgcGVyZm9ybWFuY2UgYWNyb3Nz
IHRoZSBib2FyZCwgd2l0aCBib3RoIEVYVDQgYW5kIFhGUy4gwqBJZiBvbmUKPiB3YW50cyBtYXhp
bXVtIHBlcmZvcm1hbmNlIGZyb20gdGhlaXIgZmlsZXN5c3RlbSwgb25lIHNob3VsZCB0eXBpY2Fs
bHkKPiBzdGF5IGF3YXkgZnJvbSBwYXJ0aXRpb25zIGFuZCBMVk0sIGFuZCBhbnkgb3RoZXIgbGF5
ZXJzIHRoYXQgY2FuIHNsb3cgSU8KPiBkb3duLgoKSSBkb27igJl0IHdhbnQgbWF4aW11bSBwZXJm
b3JtYW5jZSwgSSB3YW50IGFjY2VwdGFibGUgcGVyZm9ybWFuY2UgOykuClRoaXMgbWVhbnMsIEkg
YW0gc2F0aXNmaWVkIHdpdGggODAlIG9yIG1vcmUgb2Ygd2hhdOKAmXMgcG9zc2libGUsIGJ1dApJ
4oCZbSBub3Qgc2F0aXNmaWVkIHdpdGggMTUlLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
