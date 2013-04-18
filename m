Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 081CB7F5E
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 13:35:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E98C230406A
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 11:35:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6Erf6f4Gh0wOQ8OE for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 11:35:49 -0700 (PDT)
Message-ID: <51703D05.6060308@sandeen.net>
Date: Thu, 18 Apr 2013 11:35:49 -0700
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
IAoKaGVyZSdzIHNvbWV0aGluZyBpbnRlcmVzdGluZywgZm9yIDIgaW5vZGVzIHdlIGhhdmUgZG91
YmxlL3JhY2luZyBjYWxscyB0byB4ZnNfaXVubGluazoKCj09PSAweDVjYzBiID09PQogICAgICAg
ICAgIDwuLi4+LTgzMzYgIFswMDRdICA2OTMxLjM3MjkyNDogeGZzX2l1bmxpbms6IGRldiA4OjE2
IGlubyAweDVjYzBiCiAgICAgICAgICAgPC4uLj4tODMzNiAgWzAwNF0gIDY5MzEuMzcyOTY1OiB4
ZnNfaXVubGlua19yZW1vdmU6IGRldiA4OjE2IGlubyAweDVjYzBiCiAgICAgICAgICAgPC4uLj4t
Mjc1NDEgWzAwMV0gMzUwNjEuMzQ5NzQ3OiB4ZnNfaXVubGluazogZGV2IDg6MTYgaW5vIDB4NWNj
MGIKICAgICAgICAgICA8Li4uPi0zMzU2ICBbMDAxXSAzNjQ0OS43NjI1MDQ6IHhmc19pdW5saW5r
X3JlbW92ZTogZGV2IDg6MTYgaW5vIDB4NWNjMGIKICAgICAgICAgICA8Li4uPi0zMzAwICBbMDAz
XSA0MTAxMy4zOTg1NjY6IHhmc19pdW5saW5rOiBkZXYgODoxNiBpbm8gMHg1Y2MwYgogICAgICAg
ICAgIDwuLi4+LTI2MTE1IFswMTJdIDQxMDEzLjM5OTg4NDogeGZzX2l1bmxpbms6IGRldiA4OjE2
IGlubyAweDVjYzBiCiAgICAgICAgICAgPC4uLj4tMjYxMTUgWzAxMl0gNDEwMTMuMzk5OTM1OiB4
ZnNfaXVubGlua19yZW1vdmU6IGRldiA4OjE2IGlubyAweDVjYzBiCiAgICAgICAgICAgPC4uLj4t
Mjg5NjEgWzAwMF0gNjg5NzcuOTUxMjA4OiB4ZnNfaXVubGluazogZGV2IDg6MTYgaW5vIDB4NWNj
MGIKICAgICAgICAgICA8Li4uPi0zMzY0ICBbMDIxXSA4MTYxNi4yMTA1MzM6IHhmc19pdW5saW5r
X3JlbW92ZTogZGV2IDg6MTYgaW5vIDB4NWNjMGIKCj09PSAweDdlZjhjID09PQogICAgICAgICAg
IDwuLi4+LTEzMTY5IFswMDFdIDExODc1MS41MzYwMjU6IHhmc19pdW5saW5rOiBkZXYgODoxNiBp
bm8gMHg3ZWY4YwogICAgICAgICAgIDwuLi4+LTEzMTY5IFswMDFdIDExODc1MS41MzYwNDk6IHhm
c19pdW5saW5rX3JlbW92ZTogZGV2IDg6MTYgaW5vIDB4N2VmOGMKICAgICAgICAgICA8Li4uPi0z
NTk0ICBbMDE1XSAxMTkwMjcuMDA2MTYxOiB4ZnNfaXVubGluazogZGV2IDg6MTYgaW5vIDB4N2Vm
OGMKICAgICAgICAgICA8Li4uPi0zNTk0ICBbMDE1XSAxMTkwMjcuMDA2MTg2OiB4ZnNfaXVubGlu
a19yZW1vdmU6IGRldiA4OjE2IGlubyAweDdlZjhjCiAgICAgICAgICAgPC4uLj4tMzU5MSAgWzAw
MV0gMTIxNDIzLjI4NjAwNDogeGZzX2l1bmxpbms6IGRldiA4OjE2IGlubyAweDdlZjhjCiAgICAg
ICAgICAgPC4uLj4tNDE0MSAgWzAxOV0gMTIxNDIzLjI4ODUxODogeGZzX2l1bmxpbms6IGRldiA4
OjE2IGlubyAweDdlZjhjCiAgICAgICAgICAgPC4uLj4tNDE0MSAgWzAxOV0gMTIxNDIzLjI4ODU0
MTogeGZzX2l1bmxpbmtfcmVtb3ZlOiBkZXYgODoxNiBpbm8gMHg3ZWY4YwoKMiB0aHJlYWRzIG9u
IDIgZGlmZmVyZW50IENQVXMgYWRkaW5nIHRoZSBzYW1lIGlub2RlIHRvIHRoZSB1bmxpbmtlZCBs
aXN0IGluIGEgcmFjZTsKdGhpcyB3aWxsIGNvcnJ1cHQgdGhlIGxpc3QgYW5kIGxlYWQgdG8gdGhl
IGZhaWx1cmUgdG8gZmluZCB0aGUgb3RoZXIgaW5vZGUgd2UncmUKbG9va2luZyBmb3IuICBTbywg
cHJvZ3Jlc3MhICBXZSdsbCB0YWtlIGEgbG9vayBhdCB0aGUgaXVubGluayBwYXRocy4KCi1Fcmlj
CgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
