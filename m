Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74F487F4E
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 02:24:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3784D30406B
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 00:24:18 -0700 (PDT)
Received: from orion.efm.de (orion.efm.de [195.190.148.230]) by cuda.sgi.com
	with ESMTP id EWdQ1VdHb074xD5Y (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 00:24:16 -0700 (PDT)
Date: Thu, 21 Aug 2014 09:24:14 +0200 (CEST)
From: Thomas Klaube <thomas@klaube.net>
Message-ID: <290396821.4233459.1408605854867.JavaMail.zimbra@klaube.net>
In-Reply-To: <20140819225507.GS20518@dastard>
References: <159192779.3859815.1408461799560.JavaMail.zimbra@klaube.net>
	<362338960.3862279.1408462470243.JavaMail.zimbra@klaube.net>
	<20140819225507.GS20518@dastard>
Subject: Re: xlog_write: reservation ran out. Need to up reservation
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
To: xfs@oss.sgi.com

LS0tLS0gVXJzcHLDvG5nbGljaGUgTWFpbCAtLS0tLQo+IFZvbjogIkRhdmUgQ2hpbm5lciIgPGRh
dmlkQGZyb21vcmJpdC5jb20+Cj4gQW46ICJUaG9tYXMgS2xhdWJlIiA8dGhvbWFzQGtsYXViZS5u
ZXQ+Cj4gQ0M6IHhmc0Bvc3Muc2dpLmNvbQo+IEdlc2VuZGV0OiBNaXR0d29jaCwgMjAuIEF1Z3Vz
dCAyMDE0IDAwOjU1OjA3Cj4gQmV0cmVmZjogUmU6IHhsb2dfd3JpdGU6IHJlc2VydmF0aW9uIHJh
biBvdXQuIE5lZWQgdG8gdXAgcmVzZXJ2YXRpb24KCkhpLAoKPiBDYW4geW91IHBvc3QgdGhlIGZp
byBqb2IgY29uZmlndXJhdGlvbj8KCmZpcnN0IEkgcnVuIHRoaXMgam9iIGZvciA2MDAgc2VjOgp3
dGtAdWJ1bnR1IH4gJCBjYXQgd3JpdGUuZmlvCltybmRdCnJ3PXJhbmR3cml0ZQpyYW1wX3RpbWU9
MzAKcnVudGltZT02MDAKdGltZV9iYXNlZApndG9kX3JlZHVjZT0xCnNpemU9MTAwZwpyZWZpbGxf
YnVmZmVycz0xCmRpcmVjdG9yeT0uCmlvZGVwdGg9NjQKZGlyZWN0PTEKYmxvY2tzaXplPTE2awpu
dW1qb2JzPTY0Cm5yZmlsZXM9MQpncm91cF9yZXBvcnRpbmcKaW9lbmdpbmU9bGliYWlvCmxvb3Bz
PTEKClRoZW4gSSBydW4gdGhpcyBqb2IgZm9yIDJob3VyczoKd3RrQHVidW50dSB+ICQgY2F0IHJh
bmRvbS5maW8KW3JuZF0Kcnc9cmFuZHJ3CnJhbXBfdGltZT0zMApydW50aW1lPTcyMDAKdGltZV9i
YXNlZApyd21peHJlYWQ9MzAKc2l6ZT0xMDBnCnJlZmlsbF9idWZmZXJzPTEKZGlyZWN0b3J5PS4K
aW9kZXB0aD02NApkaXJlY3Q9MQpibG9ja3NpemU9NGsKbnVtam9icz02NApncm91cF9yZXBvcnRp
bmcKaW9lbmdpbmU9bGliYWlvCmxvb3BzPTEKCkkgcnVuIHRoaXMgd29ya2xvYWQgb24gMiBkZXZp
Y2VzIGluIHBhcmFsbGVsLiBPbmUgaXMgdGhlIGJjYWNoZSBkZXZpY2UgKHdpdGggeGZzKSwgdGhl
IG90aGVyIGlzCmEgbm9uIGNhY2hlZCBkZXZpY2UuIFRoZSByYW5kb20uZmlvIGpvYiBjYXVzZXMg
dGhlIHByb2JsZW0gb24gdGhlIGJjYWNoZSBkZXZpY2UgYWZ0ZXIgfjMwLTc1bWlucy4KCj4gaHR0
cDovL3hmcy5vcmcvaW5kZXgucGhwL1hGU19GQVEjUTpfV2hhdF9pbmZvcm1hdGlvbl9zaG91bGRf
SV9pbmNsdWRlX3doZW5fcmVwb3J0aW5nX2FfcHJvYmxlbS4zRgoKSSBoYXZlIHNlbnQgYSBtYWls
IHdpdGggYWxsIGNvbGxlY3RlZCBkYXRhIHRvIERhdmUuCgo+IFJ1biB0aGUgd29ya2xvYWQgZGly
ZWN0bHkgb24gdGhlIFNTRCByYXRoZXIgdGhhbiB3aXRoIGJjYWNoZS4gVXNlCj4gbWtmcyBwYXJh
bWV0ZXJzIHRvIGdpdmUgeW91IDggYWdzIGFuZCB0aGUgc2FtZSBzaXplIGxvZywgYW5kIHNlZQo+
IGlmIHlvdSBnZXQgdGhlIHNhbWUgcHJvYmxlbS4KCkkgY3JlYXRlZCBhIHhmcyBkaXJlY2x0eSBv
biB0aGUgU1NEOgpta2ZzLnhmcyAtZiAtZCBhZ2NvdW50PTggLWwgc2l6ZT01MjE3MjhiIC9kZXYv
c2RjMQoKVGhlbiBJIHN0YXJ0ZWQgdGhvIGZpbyBqb2JzIGFzIGRlc2NyaWJlZCBhYm92ZSBmb3Ig
MTAgaG91cnMuIEkgY291bGQgbm90IHJlcHJvZHVjZSB0aGUKcHJvYmxlbS4gSSB3aWxsIHNlbmQg
YSBtYWlsIHRvIHRoZSBiY2FjaGUgbWFpbGluZyBsaXN0IGFzIHdlbGwuLi4KClRoYW54IGFuZCBS
ZWdhcmRzClRob21hcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
