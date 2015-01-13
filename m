Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 425AF7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 08:00:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 206828F809B
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 06:00:00 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id XVCougVuOThyYuw6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 05:59:52 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id BB23ED4800D
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:56:40 +0100 (CET)
Date: Tue, 13 Jan 2015 14:59:40 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20150113145940.3bf674ba@harpe.intellique.com>
In-Reply-To: <20150113122108.2d3a5ccc@harpe.intellique.com>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20150113122108.2d3a5ccc@harpe.intellique.com>
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

TGUgVHVlLCAxMyBKYW4gMjAxNSAxMjoyMTowOCArMDEwMApFbW1hbnVlbCBGbG9yYWMgPGVmbG9y
YWNAaW50ZWxsaXF1ZS5jb20+IMOpY3JpdmFpdDoKCj4gKiBYRlMgdjQgb24gcmVidWlsZGluZyBh
ZGFwdGVjIFJBSUQgZmFpbHMgdW5kZXIgaGVhdnkgSU8sIHdpdGggb3IKPiAgIHdpdGhvdXQgTFZN
LCB3aXRoIGtlcm5lbHMgMy4yLnh4IHVwIHRvIDMuMTcuNy4KPiAKPiAqIFRvZGF5IEkndmUgcnVu
IHRoZSBzYW1lIHRlc3Qgd2l0aCBleHQ0IDogbm8gcHJvYmxlbSB3aGF0c29ldmVyLiBJJ20KPiAg
IHJlY2hlY2tpbmcgbWQ1IG9mIGFsbCBmaWxlcyB0byBnZXQgc3VyZSwgYnV0IGl0IGxvb2tzIE9L
IHNvIGZhcgo+IGFmdGVyIHRlc3Rpbmcgc2V2ZXJhbCB0ZXJhYnl0ZXMuIAo+IAo+IEkgZG9uJ3Qg
dW5kZXJzdGFuZCBob3cgdGhlIFJBSUQgZmlybXdhcmUgY291bGQgc2VuZCBiYWNrIGJhZCBkYXRh
Cj4gKGNvcnJ1cHRlZCBtZXRhZGF0YSBBTkQgZGF0YSkgdG8gWEZTIGJ1dCBub3QgdG8gZXh0NC4u
Lgo+IAoKQmVlcCwgdGhlIG1kNSBhcmUgd3JvbmcuIFNvIHdlIHNlZSB3aHkgd2UgbG92ZSBYRlMg
OiB3aGVuIHRoZSBSQUlECmNvbnRyb2xsZXIgc3BpdHMgbm9uc2Vuc2UsIGl0IGJhcmtzIGFuZCBj
cmllcyBhbmQgZGllcyBub2lzaWx5IDopCgpleHQ0IGRpZG4ndCBub3RpY2UgYW55IHByb2JsZW0s
IHRob3VnaCB0aGUgZGF0YSBpcyBtYW5nbGVkLiBUaGlzIGlzCmJhZC4uLgoKLS0gCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAg
ICAgICAgICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxv
cmFjQGludGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4
NCAwMgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
