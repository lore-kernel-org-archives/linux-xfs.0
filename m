Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6E5F7CBF
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 12:04:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A579F8F8059
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 10:04:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nKr4vylMqvdYhFQx for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 10:04:15 -0700 (PDT)
Message-ID: <5171790C.70400@sandeen.net>
Date: Fri, 19 Apr 2013 10:04:12 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
	<BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
	<CADFMGuKfXwY=Z9dg6+wyX7mKzppu1hQhsqxcr9Fd=DjP4hii9w@mail.gmail.com>
	<CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
	<CADFMGuKmmJCz+FxsFL9KegqzNhhHsG2ZbVjrwCDyNCh1R_Zgpw@mail.gmail.com>
	<516FDBDE.1070406@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
	<51705EC4.4000306@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
In-Reply-To: <CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
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

T24gNC8xOS8xMyAxMDowMCBBTSwgt/vTwMzOIHdyb3RlOgo+IERlYXIgRXJpYywKPiAKPiBJIGNo
ZWNrZWQgcmggc3JwbSBodHRwczovL2NvbnRlbnQtd2ViLnJobi5yZWRoYXQuY29tL3Jobi9wdWJs
aWMvTlVMTC9rZXJuZWwvMi42LjMyLTI3OS4xOS4xLmVsNi9TUlBNUy9rZXJuZWwtMi42LjMyLTI3
OS4xOS4xLmVsNi5zcmMucnBtP19fZ2RhX189MTM2NjM5MDg0N184NTUwYjg1NjhjNTBlYTQ2YjMx
ODAyNjZiNDc2MzUzZCZleHQ9LnJwbQo+IEFuZCB0aGUgY29kZSBpcyBzYW1lLCBhcyBmb2xsb3dp
bmc6Cj4gCj4gX19yd3NlbV9kb193YWtlKHN0cnVjdCByd19zZW1hcGhvcmUgKnNlbSwgaW50IHdh
a2V3cml0ZSkKPiB7CgpuZWVkIHRvIGxvb2sgaW4gbGliL3J3c2VtLmMgbm90IGxpYi9yd3NlbS1z
cGlubG9jay5jCgpUaGFua3MsCi1FcmljCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
