Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3887A29DFA
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 23:20:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FD30304070
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 21:20:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QKGN97OApGNxSez9 for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 21:20:40 -0700 (PDT)
Message-ID: <51721798.1060501@sandeen.net>
Date: Fri, 19 Apr 2013 21:20:40 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
	<CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
	<CADFMGuL4+vSH9ZpWODXWbHVz9ndMcg2aZY9b0ccq74SJp3XzEw@mail.gmail.com>
	<CADFMGuK7FEbWibRrctK7B=XXAfAKtpjRej3NVB2k7JXhhYFLLg@mail.gmail.com>
	<CADFMGuJozkBQdp5o_BK7HbrPdv6iKUie=jHyz5LrtBBvHY1b4w@mail.gmail.com>
	<CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
	<51720E49.9020001@sandeen.net>
	<CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com
	>
In-Reply-To: <CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com>
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

T24gNC8xOS8xMyA5OjAzIFBNLCC3+9PAzM4gd3JvdGU6Cj4gSGkgRXJpYywKPiBJIHdpbGwgZW5h
YmxlIHRoZW0gYW5kIHJ1biB0ZXN0IGFnYWluLiBJIGNhbiBvbmx5IHJlcHJvZHVjZSBpdCB3aXRo
Cj4gZ2x1c3RlcmZzIHJlYmFsYW5jZS4gR2x1c3RlcmZzIHVzZXMgYSBtZWNoYW5pc20gaXQgY2Fs
bGVkIHN5bmNvcCB0bwo+IHVubGluayBmaWxlLiBGb3IgcmViYWxhbmNlIGl0IHVzZXMKPiBzeW5j
b3BfdW5saW5rKGdsdXN0ZXJmcy9saWJnbHVzdGVyZnMvc3JjL3N5bmNvcC5jKS4gSW4gdGhlIGds
dXN0ZXJmcwo+IHN5bmNfdGFzayBmcmFtZXdvcmsoZ2x1c3RlcmZzL2xpYmdsdXN0ZXJmcy9zcmMv
c3luY29wLmMpIGl0IHVzZXMKPiAibWFrZWNvbnRleHQvc3dhcGNvbnRleHQiCj4gPGh0dHA6Ly93
d3cub3Blbmdyb3VwLm9yZy9vbmxpbmVwdWJzLzAwOTY5NTM5OS9mdW5jdGlvbnMvbWFrZWNvbnRl
eHQuaHRtbD4uCj4gRG9lcyBpdCBsZWFkcyB0byByYWNpbmcgdW5saW5rIGZyb20gZGlmZmVyZW50
IENQVSBjb3JlPwoKWWVwLCBJIHVuZGVyc3RhbmQgdGhhdCBpdCdzIHJlYmFsYW5jZS4gIEl0IGRp
ZXMgd2hlbiByZWJhbGFuY2UgZmluaXNoZXMgYmVjYXVzZSBhbgpvcGVuIGJ1dCB1bmxpbmtlZCBm
aWxlIHRyaXBzIG92ZXIgdGhlIGNvcnJ1cHRlZCBsaXN0IGZyb20gZWFybGllciwgaXQgc2VlbXMu
CgpJIGRvbid0IGtub3cgd2h5IG1ha2Vjb250ZXh0IHdvdWxkIG1hdHRlci4uLgoKSnVzdCB0byBi
ZSBzdXJlLCB5b3UgYXJlIGRlZmluaXRlbHkgbG9hZGluZyB0aGUgeGZzIG1vZHVsZSBmcm9tIHRo
ZSBrZXJuZWwgeW91IGJ1aWx0LCByaWdodCwgYW5kIHlvdSBkb24ndCBoYXZlIGEgInByaW9yaXR5
IiBtb2R1bGUgZ2V0dGluZyBsb2FkZWQgZnJvbSBlbHNld2hlcmU/ICBTZWVtcyB1bmxpa2VseSwg
YnV0IGp1c3QgdG8gYmUgc3VyZS4KCj4gVGhhbmsgeW91LgoKWW91IGNvdWxkIGFsc28gYWRkIHRo
aXMgcGF0Y2ggdG8gdGhlIHhmcyB0cmFjZXBvaW50cyB0byBwcmludCBtb3JlIGluZm9ybWF0aW9u
IGFib3V0IHRoZSBpbm9kZXMgLSB0aGUgbW9kZSAmIGZsYWdzLgoKLUVyaWMKCgpkaWZmIC0tZ2l0
IGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfdHJhY2UuaCBiL2ZzL3hmcy9saW51eC0yLjYveGZzX3Ry
YWNlLmgKaW5kZXggZThjZTY0NC4uYzMxNGI4NyAxMDA2NDQKLS0tIGEvZnMveGZzL2xpbnV4LTIu
Ni94ZnNfdHJhY2UuaAorKysgYi9mcy94ZnMvbGludXgtMi42L3hmc190cmFjZS5oCkBAIC01NDQs
MTQgKzU0NCwxOCBAQCBERUNMQVJFX0VWRU5UX0NMQVNTKHhmc19pbm9kZV9jbGFzcywKIAlUUF9T
VFJVQ1RfX2VudHJ5KAogCQlfX2ZpZWxkKGRldl90LCBkZXYpCiAJCV9fZmllbGQoeGZzX2lub190
LCBpbm8pCisJCV9fZmllbGQoX191MTYsIG1vZGUpCisJCV9fZmllbGQodW5zaWduZWQgbG9uZywg
ZmxhZ3MpCiAJKSwKIAlUUF9mYXN0X2Fzc2lnbigKIAkJX19lbnRyeS0+ZGV2ID0gVkZTX0koaXAp
LT5pX3NiLT5zX2RldjsKIAkJX19lbnRyeS0+aW5vID0gaXAtPmlfaW5vOworCQlfX2VudHJ5LT5t
b2RlID0gVkZTX0koaXApLT5pX21vZGU7CisJCV9fZW50cnktPmZsYWdzID0gaXAtPmlfZmxhZ3M7
CiAJKSwKLQlUUF9wcmludGsoImRldiAlZDolZCBpbm8gMHglbGx4IiwKKwlUUF9wcmludGsoImRl
diAlZDolZCBpbm8gMHglbGx4IG1vZGUgMCVvLCBmbGFncyAweCVseCIsCiAJCSAgTUFKT1IoX19l
bnRyeS0+ZGV2KSwgTUlOT1IoX19lbnRyeS0+ZGV2KSwKLQkJICBfX2VudHJ5LT5pbm8pCisJCSAg
X19lbnRyeS0+aW5vLCBfX2VudHJ5LT5tb2RlLCBfX2VudHJ5LT5mbGFncykKICkKIAogI2RlZmlu
ZSBERUZJTkVfSU5PREVfRVZFTlQobmFtZSkgXAoKCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
