Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFF547CBB
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 10:52:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52870AC002
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 08:52:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KJqHOABIwCNwiREr for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 08:52:46 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id CAE5216C16D
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 10:52:46 -0500 (CDT)
Subject: Re: [PATCH 09/19] mkfs: use getnum_checked for all ranged parameters
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-10-git-send-email-jtulak@redhat.com>
	<5706AEC9.7030002@sandeen.net>
	<CACj3i73peJznTYx6xS6mtD=bBNbLz1o=giNvz-QJE48oVV1y_w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5707D3CE.1010305@sandeen.net>
Date: Fri, 8 Apr 2016 10:52:46 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i73peJznTYx6xS6mtD=bBNbLz1o=giNvz-QJE48oVV1y_w@mail.gmail.com>
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
To: xfs@oss.sgi.com

CgpPbiA0LzgvMTYgNTo0NyBBTSwgSmFuIFR1bGFrIHdyb3RlOgo+IE9uIFRodSwgQXByIDcsIDIw
MTYgYXQgOTowMiBQTSwgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0IDxtYWlsdG86
c2FuZGVlbkBzYW5kZWVuLm5ldD4+d3JvdGU6Cj4gCj4gCj4gCj4gICAgIE9uIDMvMjQvMTYgNjox
NSBBTSwganR1bGFrQHJlZGhhdC5jb20gPG1haWx0bzpqdHVsYWtAcmVkaGF0LmNvbT4gd3JvdGU6
Cj4gICAgID4gRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tIDxtYWlsdG86
ZGNoaW5uZXJAcmVkaGF0LmNvbT4+Cj4gICAgID4KPiAgICAgPiBOb3cgdGhhdCBnZXRudW1fY2hl
Y2tlZCBjYW4gaGFuZGxlIG1pbi9tYXggY2hlY2tpbmcsIHVzZSB0aGlzIGZvcgo+ICAgICA+IGFs
bCBwYXJhbWV0ZXJzIHRoYXQgdGFrZSBzdHJhaWdodCBudW1iZXJzIGFuZCBkb24ndCByZXF1aXJl
IHVuaXQKPiAgICAgPiBjb252ZXJzaW9ucy4KPiAgICAgPgo+ICAgICA+IFNpZ25lZC1vZmYtYnk6
IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbSA8bWFpbHRvOmRjaGlubmVyQHJlZGhh
dC5jb20+Pgo+ICAgICA+IFNpZ25lZC1vZmYtYnk6IEphbiBUdWxhayA8anR1bGFrQHJlZGhhdC5j
b20gPG1haWx0bzpqdHVsYWtAcmVkaGF0LmNvbT4+Cj4gCj4gICAgIExvb2tzIG9rLgo+IAo+ICAg
ICBTaWduZWQtb2ZmLWJ5OiBFcmljIFNhbmRlZW4gPHNhbmRlZW5AcmVkaGF0LmNvbSA8bWFpbHRv
OnNhbmRlZW5AcmVkaGF0LmNvbT4+Cj4gCj4gCj4g4oCLT3IgUmV2aWV3ZWQtYnk/IDotKQoKWWVz
LCB0aGF0IDopCgpSZXZpZXdlZC1ieTogRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHJlZGhhdC5jb20+
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
