Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B6FF7F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 11:21:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF87FAC006
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 09:21:06 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id UDpM4MrQb2jPWHu9 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 09:21:05 -0700 (PDT)
Subject: Bug#705483: xfsprogs: xfs_quota misinterprets usernames with leading
	digits
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.705483.B.136604263930074@bugs.debian.org>
Message-ID: <516C25AC.60506@sgi.com>
Date: Mon, 15 Apr 2013 11:07:08 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
References: <516C12DB.3060806@bytemark.co.uk>
In-Reply-To: <516C12DB.3060806@bytemark.co.uk>
Reply-To: Rich Johnston <rjohnston@sgi.com>, 705483@bugs.debian.org
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: James Carter <james.carter@bytemark.co.uk>, 705483@bugs.debian.org
Cc: submit@bugs.debian.org

T24gMDQvMTUvMjAxMyAwOTo0NiBBTSwgSmFtZXMgQ2FydGVyIHdyb3RlOgo+IFN1YmplY3Q6IHhm
c3Byb2dzOiB4ZnNfcXVvdGEgbWlzaW50ZXJwcmV0cyB1c2VybmFtZXMgd2l0aCBsZWFkaW5nIGRp
Z2l0cwo+IFBhY2thZ2U6IHhmc3Byb2dzCj4gVmVyc2lvbjogMy4xLjQKPiBTZXZlcml0eTogbm9y
bWFsCj4KPiAqKiogUGxlYXNlIHR5cGUgeW91ciByZXBvcnQgYmVsb3cgdGhpcyBsaW5lICoqKgo+
Cj4geGZzX3F1b3RhIGludGVycHJldHMgdXNlcm5hbWVzIHdpdGggbGVhZGluZyBkaWdpdHMgYXMg
YSBudW1lcmljIFVJRCBzbywKPiBmb3IgZXhhbXBsZToKPgo+ICMgeGZzX3F1b3RhIC1jICdxdW90
YSAtaCAtdSAyMDAwYWQnIC9zdG9yZQo+IERpc2sgcXVvdGFzIGZvciBVc2VyIHRlc3QgKDIwMDAp
Cj4gRmlsZXN5c3RlbSAgIEJsb2NrcyAgUXVvdGEgIExpbWl0IFdhcm4vVGltZSAgICBNb3VudGVk
IG9uCj4gL2Rldi9zZGIxICAgICAgIDEySyAgICAgMUcgICAgIDFHICAwMCBbLS0tLS0tXSAvc3Rv
cmUKPgo+IFRoaXMgaXMgcmV0dXJuaW5nIHF1b3RhIGluZm9ybWF0aW9uIGZvciB0aGUgdXNlciAi
dGVzdCIgKFVJRCAyMDAwKSwgcmF0aGVyCj4gdGhhbiB0aGUgdXNlciAiMjAwMGFkIi4KPgoKSSBk
b24ndCB0aGluayB0aGlzIGlzIGEgYnVnLCB1c2VybmFtZSBtdXN0IGJlZ2luIHdpdGggYSBjaGFy
YWN0ZXIgCih1bmxlc3MgeW91IGNyZWF0ZWQgdGhlIHVzZXIgdXNpbmcgTklTIG9yIGFkZHVzZXIg
LS1mb3JjZS1iYWRuYW1lKS4KCiMgRGVmYXVsdCBmcm9tIC9ldGMvYWRkdXNlci5jb25mCiMgY2hl
Y2sgdXNlciBhbmQgZ3JvdXAgbmFtZXMgYWxzbyBhZ2FpbnN0IHRoaXMgcmVndWxhciBleHByZXNz
aW9uLgojTkFNRV9SRUdFWD0iXlthLXpdWy1hLXowLTlfXSpcJCIKCiBGcm9tIGFkZHVzZXIgbWFu
IHBhZ2U6CgogICAgICAgLS1mb3JjZS1iYWRuYW1lCiAgICAgICAgICAgICAgICBCeSBkZWZhdWx0
LCB1c2VyIGFuZCBncm91cCBuYW1lcyBhcmUgY2hlY2tlZCBhZ2FpbnN0IHRoZSAKY29uZmln4oCQ
CiAgICAgICAgICAgICAgICB1cmFibGUgcmVndWxhciBleHByZXNzaW9uIE5BTUVfUkVHRVggIChv
ciAKTkFNRV9SRUdFWF9TWVNURU0gIGlmCiAgICAgICAgICAgICAgIC0tc3lzdGVtIGlzIHNwZWNp
ZmllZCkgc3BlY2lmaWVkIGluIHRoZSBjb25maWd1cmF0aW9uIApmaWxlLiBUaGlzCiAgICAgICAg
ICAgICAgIG9wdGlvbiBmb3JjZXMgYWRkdXNlciBhbmQgYWRkZ3JvdXAgdG8gYXBwbHkgb25seSAg
YSAgd2VhayAKICBjaGVjawogICAgICAgICAgICAgICBmb3IgdmFsaWRpdHkgb2YgdGhlIG5hbWUu
CgpUaGFua3MKLS1SaWNoCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
