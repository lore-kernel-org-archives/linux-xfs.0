Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCABB7CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 11:18:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B656AC001
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 09:17:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZjAcuAkocb0mX0pA for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 09:17:56 -0700 (PDT)
Subject: Re: [PATCH 02/19] mkfs: sanitise ftype parameter values.
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-3-git-send-email-jtulak@redhat.com>
	<56F416E8.5000704@sandeen.net>
	<CACj3i71Ae1p8E35SrmpEiMen+mFY7MgQa2fHPueALDnF+HNRrQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56FAAAB4.7090602@sandeen.net>
Date: Tue, 29 Mar 2016 11:17:56 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i71Ae1p8E35SrmpEiMen+mFY7MgQa2fHPueALDnF+HNRrQ@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

CgpPbiAzLzI5LzE2IDExOjExIEFNLCBKYW4gVHVsYWsgd3JvdGU6Cj4gT24gVGh1LCBNYXIgMjQs
IDIwMTYgYXQgNTozMyBQTSwgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0IDxtYWls
dG86c2FuZGVlbkBzYW5kZWVuLm5ldD4+d3JvdGU6Cj4gCj4gCj4gCj4gICAgIE9uIDMvMjQvMTYg
NjoxNSBBTSwganR1bGFrQHJlZGhhdC5jb20gPG1haWx0bzpqdHVsYWtAcmVkaGF0LmNvbT4gd3Jv
dGU6Cj4gICAgID4gRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tIDxtYWls
dG86ZGNoaW5uZXJAcmVkaGF0LmNvbT4+Cj4gICAgID4KPiAgICAgPiBCZWNhdXNlIHBhc3Npbmcg
Ii1uIGZ0eXBlPTIiIHNob3VsZCBmYWlsLgo+IAo+ICAgICBidXQgcGFzc2luZyBjcmM9MSBmdHlw
ZT0xIHNob3VsZG4ndCBmYWlsLCBzaG91bGQgaXQ/Cj4gICAgIFNlZW1zIGxpa2UgaXQgd2lsbCBo
ZXJlLgo+IAo+IAo+IOKAi0Zyb20gbWFuIHBhZ2U6Cj4gV2hlbiAgQ1JDcyBhcmUgZW5hYmxlZCB2
aWEgLW0gY3JjPTEsIHRoZSBmdHlwZSBmdW5jdGlvbmFsaXR5IGlzIGFsd2F5cyBlbmFibGVkLiBU
aGlzIGZlYXR1cmUgY2FuIG5vdCBiZQo+IOKAiyAKPiB0dXJuZWQgb2ZmIGZvciBzdWNoIGZpbGVz
eXN0ZW0gY29uZmlndXJhdGlvbnMu4oCLCj4gIAo+IAo+IOKAi1NvIEkgdGhpbmsgaXQgc2hvdWxk
IG5vdCBiZSBwb3NzaWJsZSB0byBlbnRlciBib3RoIGNyYyBhbmQgZnR5cGUgYXQKPiB0aGUgc2Ft
ZSB0aW1lIC0gd2hpY2ggaXMgdGhlIGN1cnJlbnQgYmVoYXZpb3VyLiBJdCBmZWVscyBzdHJhbmdl
IGEKPiBiaXQgdG8gYWxsb3cgZnR5cGU9MSAod2hpY2ggZG9lcyBub3RoaW5nIHdpdGggY3JjPTEp
LCBidXQgZmFpbCBvbgo+IGZ0eXBlPTDigIsKCk15IHBvaW50IGlzIHRoYXQgLW0gY3JjPTEgLWQg
ZnR5cGU9MSBzaW1wbHkgcmVzdGF0ZXMgdGhlIGRlZmF1bHRzLgpXaHkgc2hvdWxkIHRoYXQgY29t
YmluYXRpb24gZmFpbD8KCkFuZCAtbSBjcmM9MCAtZCBmdHlwZT0wIGlzIGFsc28gcGVyZmVjdGx5
IGFjY2VwdGFibGUuCgpJbiBmYWN0LCAtbSBjcmM9MSAtZCBmdHlwZT0wIGlzIHRoZSBvbmx5IG9u
ZSBvZiB0aGUgNCBjb21iaW5hdGlvbnMKd2hpY2ggaXMgbm90IG9rLCBidXQgQUZBSUNUIHlvdXIg
cGF0Y2ggZmFpbHMgdGhlIG90aGVyIDMgYXMgd2VsbC4KCi1FcmljCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
