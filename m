Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E50C07F3F
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 19:51:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5FC78F804B
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 17:51:53 -0700 (PDT)
Received: from smtpbg302.qq.com (smtpbg302.qq.com [184.105.206.27]) by
	cuda.sgi.com with ESMTP id 7UHloprQYZ6z2Sm5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 17:51:51 -0700 (PDT)
Message-ID: <55554311.2070904@foxmail.com>
Date: Fri, 15 May 2015 08:51:29 +0800
From: Wang Sheng-Hui <shhuiw@foxmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests/common/renameat2: pass the renameat2 flags from
	_rename_tests to _rename_tests_source_dest
References: <1430467867-5565-1-git-send-email-shhuiw@foxmail.com>
In-Reply-To: <1430467867-5565-1-git-send-email-shhuiw@foxmail.com>
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
To: mszeredi@suse.cz, david@fromorbit.com, xfs@oss.sgi.com, Eryu Guan <eguan@redhat.com>, Dave Chinner <dchinner@redhat.com>

CgpPbiAyMDE15bm0MDXmnIgwMeaXpSAxNjoxMSwgV2FuZyBTaGVuZy1IdWkgd3JvdGU6Cj4gX3Jl
bmFtZV90ZXN0cygpIHJlY29yZHMgdGhlICdmbGFncycgYXJnIGJ1dCBkb2Vzbid0IHBhc3MgaXQg
dG8KPiBfcmVuYW1lX3Rlc3RzX3NvdXJjZV9kZXN0KCkgaW4gb2xkIGNvZGUsIHRodXMgYW55ICdm
bGFncycgdG8KPiByZW5hbWVhdDIgaXMgbWlzc2VkLiBGaXggdGhlIG1pc3NpbmcuCj4gCj4gU2ln
bmVkLW9mZi1ieTogV2FuZyBTaGVuZy1IdWkgPHNoaHVpd0Bmb3htYWlsLmNvbT4KPiAtLS0KPiAg
Y29tbW9uL3JlbmFtZWF0MiB8IDUgKysrLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvY29tbW9uL3JlbmFtZWF0MiBi
L2NvbW1vbi9yZW5hbWVhdDIKPiBpbmRleCBhMzM1MTY5Li5kZjJkZjJlIDEwMDY0NAo+IC0tLSBh
L2NvbW1vbi9yZW5hbWVhdDIKPiArKysgYi9jb21tb24vcmVuYW1lYXQyCj4gQEAgLTc4LDYgKzc4
LDcgQEAgX3JlbmFtZV90ZXN0c19zb3VyY2VfZGVzdCgpCj4gIAlsb2NhbCBzb3VyY2U9JDEKPiAg
CWxvY2FsIGRlc3Q9JDIKPiAgCWxvY2FsIG9wdGlvbnM9JDMKPiArCWxvY2FsIGZsYWdzPSQ0Cj4g
IAo+ICAJZm9yIHN0eXBlIGluIG5vbmUgcmVndSBzeW1iIGRpcmUgdHJlZTsgZG8KPiAgCQlmb3Ig
ZHR5cGUgaW4gbm9uZSByZWd1IHN5bWIgZGlyZSB0cmVlOyBkbwo+IEBAIC0xMDcsMTEgKzEwOCwx
MSBAQCBfcmVuYW1lX3Rlc3RzKCkKPiAgCWxvY2FsIGZsYWdzPSQyCj4gIAo+ICAJI3NhbWUgZGly
ZWN0b3J5IHJlbmFtZXMKPiAtCV9yZW5hbWVfdGVzdHNfc291cmNlX2Rlc3QgJHRlc3RkaXIvc3Jj
ICR0ZXN0ZGlyL2RzdCAgICAgInNhbWVkaXIgIgo+ICsJX3JlbmFtZV90ZXN0c19zb3VyY2VfZGVz
dCAkdGVzdGRpci9zcmMgJHRlc3RkaXIvZHN0ICAgICAic2FtZWRpciAiICRmbGFncwo+ICAKPiAg
CSNjcm9zcyBkaXJlY3RvcnkgcmVuYW1lcwo+ICAJbWtkaXIgJHRlc3RkaXIveCAkdGVzdGRpci95
Cj4gLQlfcmVuYW1lX3Rlc3RzX3NvdXJjZV9kZXN0ICR0ZXN0ZGlyL3gvc3JjICR0ZXN0ZGlyL3kv
ZHN0ICJjcm9zc2RpciIKPiArCV9yZW5hbWVfdGVzdHNfc291cmNlX2Rlc3QgJHRlc3RkaXIveC9z
cmMgJHRlc3RkaXIveS9kc3QgImNyb3NzZGlyIiAkZmxhZ3MKPiAgCXJtZGlyICR0ZXN0ZGlyL3gg
JHRlc3RkaXIveQo+ICB9Cj4gIAo+IAoKQW55IGNvbW1lbnRzPwoKClJlZ2FyZHMsClNoZW5nLUh1
aQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
