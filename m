Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q378rmxV214219 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 03:53:49 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id pgzNNdprt0Pad53C for
	<xfs@oss.sgi.com>; Sat, 07 Apr 2012 01:53:46 -0700 (PDT)
Date: Sat, 7 Apr 2012 10:53:18 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120407105318.7d31b413@galadriel.home>
In-Reply-To: <CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: stan@hardwarefreak.com, Linux fs XFS <xfs@oss.sgi.com>

TGUgU2F0LCA3IEFwciAyMDEyIDA5OjI3OjUwICswMjAwIHZvdXMgw6ljcml2aWV6OgoKPiBTbyBp
dCBzb3VuZHMgbGlrZSB0aGF0IGZvciBwb29yIGd1eXMgbGlrZSB1cywgd2hvIGNhbuKAmXQgYWZm
b3JkIHRoZQo+IGhhcmR3YXJlIHRvIGhhdmUgZG96ZW5zIG9mIHNwaW5kbGVzLCB0aGUgYmVzdCBv
cHRpb24gd291bGQgYmUgdG8KPiBjcmVhdGUgdGhlIFhGUyBmaWxlIHN5c3RlbSB3aXRoIGFnY291
bnQ9MT8gVGhhdCBzZWVtcyB0byBiZSB0aGUgb25seQo+IHJlYXNvbmFibGUgY29uY2x1c2lvbiB0
byBtZSwgc2luY2UgYSBzaW5nbGUgUkFJRCBkZXZpY2UsIGxpa2UgYSBzaW5nbGUKPiBkaXNrLCBj
YW5ub3Qgd3JpdGUgaW4gcGFyYWxsZWwgYW55d2F5LgoKWW91IGJlc3Qgb3B0aW9uIGlzIHRvIGJ1
eSBhIFNTRC4gU2VyaW91c2x5LCBldmVuIGEgYmFzaWMgZGVjZW50IGNvbnN1bWVyCm1vZGVsIHdp
bGwgYnVyeSB5b3VyIGFycmF5IGluIHRoZSBkdXN0LiBBbHNvLCByZWNlbnQgUkFJRCBjb250cm9s
bGVycwpmcm9tIExTSSBhbmQgQWRhcHRlYyBhcmUgYWJsZSB0byAiZW5oYW5jZSIgYSBzcGlubmlu
ZyBydXN0IGFycmF5IGJ5CnVzaW5nIGFuIFNTRCBhcyBhIGNhY2hlLgoKLS0gCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAg
ICAgICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFj
QGludGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAw
MgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
