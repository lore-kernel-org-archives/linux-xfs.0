Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F25207F5E
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 12:03:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DEBCAC005
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 10:03:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wHHRFj7wtfxawZB6 for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 10:03:23 -0700 (PDT)
Message-ID: <5170275A.7070202@sandeen.net>
Date: Thu, 18 Apr 2013 10:03:22 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com> <20130416162417.GC13938@destitution>
	<516D87E3.2010605@redhat.com>
	<CADFMGuLgU2++ym4U9axhevV_L2t-2CMVaDoT5cyQcew2YZMsBA@mail.gmail.com>
	<CADFMGuK3cPSmqZoMdFSSqOnUz3GLv+c01xXHDhzv9_dfUNUPPA@mail.gmail.com>
	<CADFMGu+XD=-NJm3CAsnKpiMWykPj67t2LHgtxkPpyTpVmG3LDA@mail.gmail.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
	<BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
	<CADFMGuKfXwY=Z9dg6+wyX7mKzppu1hQhsqxcr9Fd=DjP4hii9w@mail.gmail.com>
	<CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
	<CADFMGuKmmJCz+FxsFL9KegqzNhhHsG2ZbVjrwCDyNCh1R_Zgpw@mail.gmail.com>
	<516FDBDE.1070406@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
In-Reply-To: <CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gNC8xOC8xMyA4OjIzIEFNLCC3+9PAzM4gd3JvdGU6Cj4gSGkgQnJpYW4gYW5kIEVyaWMsCj4g
VGhlIHNodXRkb3duIGlzIG5vdCBlYXN5IHRvIHByb2R1Y2UgYnV0IGZpbmFsbHkgcmlnaHQgbm93
IDIgb2Ygb3VyIHNlcnZlcnMgaW4gb3VyIHRlc3QgY2x1c3RlciB4ZnMgd2FzIHNodXRkb3duLgo+
IAo+IHRoZSB0cmFjZSBvdXRwdXQgYXMgZm9sbG93aW5nCj4gaHR0cHM6Ly9kb2NzLmdvb2dsZS5j
b20vZmlsZS9kLzBCN24yQzRUNXRmTkNMWFJZVVdKMGIxOUpjV2MvZWRpdD91c3A9c2hhcmluZwo+
IAo+IFNvcnJ5IGJ1dCB0aGUgc3lzdGVtdGFwIGlzIGludGVycnVwdCBhbmQgSSBkaWRuJ3Qgbm90
aWNlZCB0aGF0IHNvIEkgZGlkbid0IGdldCBzeXN0ZW10YXAgbG9ncy4KPiAKPiAvdmFyL2xvZy9t
ZXNzYWdlIGlzIHNhbWUgYXMgYmVmb3JlCj4gQXByIDE4IDIyOjQzOjE0IDEwIGtlcm5lbDogWEZT
IChzZGIpOiAJOiB4ZnNfaW5vdG9icCgpIHJldHVybmVkIGVycm9yIDIyLgo+IEFwciAxOCAyMjo0
MzoxNCAxMCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2luYWN0aXZlOiB4ZnNfaWZyZWUgcmV0dXJu
ZWQgZXJyb3IgMjIKPiBBcHIgMTggMjI6NDM6MTQgMTAga2VybmVsOiBYRlMgKHNkYik6IHhmc19k
b19mb3JjZV9zaHV0ZG93bigweDEpIGNhbGxlZCBmcm9tIGxpbmUgMTE4NCBvZiBmaWxlIGZzL3hm
cy94ZnNfdm5vZGVvcHMuYy4gIFJldHVybiBhZGRyZXNzID0gMHhmZmZmZmZmZmEwMmQ0NGFhCj4g
QXByIDE4IDIyOjQzOjE0IDEwIGtlcm5lbDogWEZTIChzZGIpOiBJL08gRXJyb3IgRGV0ZWN0ZWQu
IFNodXR0aW5nIGRvd24gZmlsZXN5c3RlbQo+IEFwciAxOCAyMjo0MzoxNCAxMCBrZXJuZWw6IFhG
UyAoc2RiKTogUGxlYXNlIHVtb3VudCB0aGUgZmlsZXN5c3RlbSBhbmQgcmVjdGlmeSB0aGUgcHJv
YmxlbShzKQo+IEFwciAxOCAyMjo0MzoyMCAxMCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19m
b3JjZTogZXJyb3IgNSByZXR1cm5lZC4KPiAKPiBUaGUgbWV0YWR1bXAgZmlsZSBpcyBsYXJnZSBJ
J2xsIHNoYXJlIGl0IHRvIHlvdSBzb29uLgo+IAoKVGhhbmtzLCB3ZSdsbCB0YWtlIGEgbG9vay4g
IEp1c3QgdG8gZG91YmxlIGNoZWNrLCBpbiB0aGUga2VybmVsIHRoYXQgcmFuIHRoZSB0cmFjZXBv
aW50cywgZGlkIHlvdSB1c2UgYnJpYW4ncyAybmQgdmVyc2lvbiBvZiB0aGUgcGF0Y2g/ICBJIHdh
bnQgdG8gbWFrZSBzdXJlIHRoZSB0cmFjZXBvaW50cyB3ZXJlIGF0IHRoZSB0b3Agb2YgdGhlIGZ1
bmN0aW9uLgoKU2luY2UgeW91J3JlIHBhdGNoaW5nIHhmcyBhbnl3YXksIGNhbiB5b3UgYWRkIHNv
bWV0aGluZyBsaWtlIHRoaXMgZm9yIG5leHQgdGltZToKCmRpZmYgLS1naXQgYS9mcy94ZnMveGZz
X2lub2RlLmMgYi9mcy94ZnMveGZzX2lub2RlLmMKaW5kZXggNzk2ZWRjZS4uY2FkMGU4ZSAxMDA2
NDQKLS0tIGEvZnMveGZzL3hmc19pbm9kZS5jCisrKyBiL2ZzL3hmcy94ZnNfaW5vZGUuYwpAQCAt
MTc3Nyw4ICsxNzc3LDkgQEAgeGZzX2l1bmxpbmtfcmVtb3ZlKAogCQkJCQkgICAgJmxhc3RfaWJw
LCAmbGFzdF9vZmZzZXQsIDApOwogCQkJaWYgKGVycm9yKSB7CiAJCQkJeGZzX3dhcm4obXAsCi0J
CQkJCSIlczogeGZzX2lub3RvYnAoKSByZXR1cm5lZCBlcnJvciAlZC4iLAotCQkJCQlfX2Z1bmNf
XywgZXJyb3IpOworCQkJCQkiJXM6IHhmc19pbm90b2JwKCkgcmV0dXJuZWQgZXJyb3IgJWQgIgor
CQkJCQkiZm9yIGlub2RlIDB4JWxseCBhZyAlZCBhZ2lubyAleFxuIiwKKwkJCQkJX19mdW5jX18s
IGVycm9yLCBpcC0+aV9pbm8sIGFnbm8sIGFnaW5vKTsKIAkJCQlyZXR1cm4gZXJyb3I7CiAJCQl9
CiAJCQluZXh0X2FnaW5vID0gYmUzMl90b19jcHUobGFzdF9kaXAtPmRpX25leHRfdW5saW5rZWQp
OwoKc28gdGhhdCB3aGVuIHdlIGVuY291bnRlciB0aGUgZXJyb3Igd2UncmUgc3VyZSB0byBoYXZl
IHRoZSBwcm9ibGVtYXRpYyBpbm9kZSBudW1iZXIuCgpUaGFua3MsCi1FcmljCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
