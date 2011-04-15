Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3F9C27g057121 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 04:12:02 -0500
Received: from smtp-tls.univ-nantes.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14C5B117535D
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 02:15:24 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtp-tls2.univ-nantes.fr
	[193.52.101.146]) by cuda.sgi.com with ESMTP id
	jsuaDJSiaYep6R3P for <xfs@oss.sgi.com>;
	Fri, 15 Apr 2011 02:15:24 -0700 (PDT)
Message-ID: <4DA80C55.7030903@univ-nantes.fr>
Date: Fri, 15 Apr 2011 11:13:57 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: write back inodes during reclaim
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<4DA7F286.8090905@univ-nantes.fr> <20110415075440.GN21395@dastard>
In-Reply-To: <20110415075440.GN21395@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

TGUgMTUvMDQvMjAxMSAwOTo1NCwgRGF2ZSBDaGlubmVyIGEgw6ljcml0IDoKPiB7SW4gZnV0dXJl
IGNhbiB5b3UgbWFrZSBzdXJlIHlvdSBkb24ndCBsaW5lIHdyYXAgc3RhY2sgdHJhY2VzPyB0aGV5
Cj4gdHVybiBpbnRvIGFuIHV0dGVyIG1lc3Mgd2hlbiBiZWluZyBxdW90ZWQgaWYgeW91IHdyYXAg
dGhlbX0KPgoKd29vcHMsIHNvcnJ5IDooIEkganVzdCBjb3BpZWQvcGFzdGUgZnJvbSBvdXIgaW50
ZXJuYWwgcmVxdWVzdCB0cmFja2VyLCAKc28gdGhlIHRyYWNlIG1heSBoYXZlIGJlZW4gbWFuZ2xl
ZCB0aGVyZS4KCj4gVGhpcywgSSdkIHNheSwgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCBYRlMgLSB0
aGUgc3lzdGVtIGhhcyB0YWtlbiBhCj4gbmV0d29yayBpbnRlcnJ1cHQgYW5kIGZhaWxlZCBhbiBh
bGxvY2F0aW9uIGluIGJueDIgTklDIGRyaXZlci4gWW91Cj4gY2hvcHBlZCBvZmYgdGhlIGxpbmUg
dGhhdCBkZXNjcmliZXMgdGhlIGFjdHVhbCBhbGxvY2F0aW9uIHBhcmFtZXRlcnMKPiB0aGF0IGZh
aWxlZCwgc28gSSBjYW4ndCByZWFsbHkgc2F5IHdoeSBpdCBmYWlsZWQuLi4KPgpvbmNlIGFnYWlu
IHNvcnJ5LiBJJ20gbm90IHVzZWQgdG8gc2VuZCBzdGFjayB0cmFjZXMgc28gb2Z0ZW4uCkknbGwg
dHJ5IHRvIHNlbmQgY2xlYW4gdHJhY2VzLCBvbmx5IGlmIHlvdSB0aGluayBpdCBtYXkgaGF2ZSBz
b21ldGhpbmcgCnRvIGRvIHdpdGggeGZzLgoKV2UgaGF2ZSBhIGxvdCBvZiB0aG9zZXMgdHJhY2Vz
LCB0aGlzIHBhcnRpY3VsYXIgb25lIG1heSBub3QgYmUgdGhlIGJlc3QgCnRvIGRlc2NyaWJlIHRo
ZSBwcm9ibGVtLiBNeSBhcG9sb2dpZXMuCgouLi4KPiBOb25lIHJpZ2h0IG5vdyAtIHRoZSBwYXRj
aCBpcyBkZWFkIGluIHRoZSB3YXRlciByaWdodCBub3cgYmVjYXVzZSBvZgo+IGxvY2sgaW52ZXJz
aW9uIGlzc3VlcyBpdCBjYXVzZXMuIEV2ZW4gc28sIEkgZG91YnQgSSdkIGJlIGJhY2sKPiBwb3J0
aW5nIGl0IHRvIGFueSBzdGFibGUga2VybmVsIHdpdGhvdXQgaGF2aW5nIGFueW9uZSByZXBvcnQg
dGhhdCBpdAo+IGlzIHRoZSByb290IGNhdXNlIG9mIHRoZWlyIE9PTSBwcm9ibGVtcy4KPgpvawo+
PiAtIElzIG1vdW50aW5nIHdpdGggbm9hdGltZSBjYW4gYWxsZXZpYXRlIHRoZSBwcm9ibGVtID8K
PiBUaGUgcHJvYmxlbSB0aGF0IHRoZSBwYXRjaCBJIHBvc3RlZCB3ZXJlIHN1cHBvc2VkIHRvIGZp
eCwgeWVzLiBUaGUKPiBwcm9ibGVtIHlvdSBhcmUgcmVwb3J0aW5nIGhlcmUsIG1vc3QgbGlrZWx5
IG5vdC4Kb2ssCnRoYW5rcyBmb3IgeW91ciBxdWljayBhbnN3ZXIsCgpSZWdhcmRzLAoKCi0tIApZ
YW5uIER1cG9udCAtIFNlcnZpY2UgSVJUUywgRFNJIFVuaXZlcnNpdMOpIGRlIE5hbnRlcwpUZWwg
OiAwMi41My40OC40OS4yMCAtIE1haWwvSmFiYmVyIDogWWFubi5EdXBvbnRAdW5pdi1uYW50ZXMu
ZnIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
