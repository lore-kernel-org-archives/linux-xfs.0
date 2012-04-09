Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39BqmFc111233 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 06:52:48 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id h5z4VYaEoyxOH7L7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Apr 2012 04:52:47 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so2572333yhj.26
	for <xfs@oss.sgi.com>; Mon, 09 Apr 2012 04:52:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F826FFA.4050207@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com> <4F82063F.4070609@hardwarefreak.com>
	<4F826FFA.4050207@hardwarefreak.com>
Date: Mon, 9 Apr 2012 13:52:46 +0200
Message-ID: <CAAxjCExcd6T9gUM5AHzZM535e1kyb9WJd_ib2MFkeC_DbU7TXA@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

PiBJdCBzZWVtcyB0aGUgMTA3OCBpcyBzaW1wbHkgbm90IHRoYXQgcXVpY2sgd2l0aCBhbnl0aGlu
ZyBidXQgcHVyZQo+IHN0cmlwaW5nLiDCoEhhcmR3YXJlIFJBSUQxMCB3cml0ZSBwZXJmb3JtYW5j
ZSBhcHBlYXJzIG9ubHkgYWJvdXQgNTAlCj4gZmFzdGVyIHRoYW4gUkFJRDYuIMKgVGhlIFJBSUQ2
IHNwZWVkIGlzIHJvdWdobHkgMS8zcmQgb2YgdGhlIFJBSUQwIHNwZWVkLgo+IMKgU28gZXhwb3J0
aW5nIHRoZSBpbmRpdmlkdWFsIGRyaXZlcyBhcyBJIHByZXZpb3VzbHkgbWVudGlvbmVkIGFuZCB1
c2luZwo+IG1kcmFpZDYgc2hvdWxkIHlpZWxkIGF0IGxlYXN0IMKgYSAzeCBpbXByb3ZlbWVudCwg
YXNzdW1pbmcgeW91ciBDUFVzCj4gYXJlbid0IGFscmVhZHkgbG9hZGVkIGRvd24uCgpXaGF0ZXZl
ciB0aGUgcHJvYmxlbSB3aXRoIHRoZSBjb250cm9sbGVyIG1heSBiZSwgaXQgYmVoYXZlcyBxdWl0
ZQpuaWNlbHkgdXN1YWxseS4gSXQgc2VlbXMgY2xlYXIgdGhvdWdoLCB0aGF0LCByZWdhcmRsZXNz
IG9mIHRoZSBzdG9yYWdlCnRlY2hub2xvZ3ksIGl0IGNhbm5vdCBiZSBhIGdvb2QgaWRlYSB0byBz
Y2hlZHVsZSB0aW55IGJsb2NrcyBpbiB0aGUKb3JkZXIgdGhhdCBYRlMgc2NoZWR1bGVzIHRoZW0g
aW4gbXkgY2FzZS4KClRoaXM6CkFHMCAqICAgKiAgICoKQUcxICAqICAgKiAgICoKQUcyICAgKiAg
ICogICAqCkFHMyAgICAqICAgKiAgICoKCmNhbm5vdCBiZSBiZXR0ZXIgdGhhbiB0aGlzOgoKQUcw
ICoqKgpBRzEgICAgKioqCkFHMiAgICAgICAqKioKQUczICAgICAgICAgICoqKgoKWWVzLCBpbiB0
aGVvcnksIGEgZ29vZCBjYWNoZSBjb250cm9sbGVyIHNob3VsZCBiZSBhYmxlIHRvIHNvcnQgdGhp
cwpvdXQuIEJ1dCBhdCBsZWFzdCB0aGlzIHBhcnRpY3VsYXIgY29udHJvbGxlciBpcyBub3QgYWJs
ZSB0byBkbyBzbyBhbmQKY291bGQgdXNlIGEgbGl0dGxlIGhlbHAuIEFsc28sIGEgc2luZ2xlIGNv
bnN1bWVyLWdyYWRlIGRyaXZlIGlzCmNlcnRhaW5seSBub3QgaGVscGVkIGJ5IHRoaXMgd3JpdGUg
b3JkZXJpbmcuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMK
