Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A93FB7CCC
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 12:41:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EB988F8033
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 10:41:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RjV6Fv0jWZWr9RqX for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 10:41:44 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 939AC16C16D
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 12:41:44 -0500 (CDT)
Subject: Re: [PATCH 08/19] mkfs: getbool is redundant
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-9-git-send-email-jtulak@redhat.com>
	<5706981A.9090904@sandeen.net>
	<CACj3i71TB=VkjCGpNCjOXs7Tuc6ayZEQbfuaFqZ85jPkTBx1=Q@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5707ED58.3060404@sandeen.net>
Date: Fri, 8 Apr 2016 12:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i71TB=VkjCGpNCjOXs7Tuc6ayZEQbfuaFqZ85jPkTBx1=Q@mail.gmail.com>
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

CgpPbiA0LzgvMTYgNTozMCBBTSwgSmFuIFR1bGFrIHdyb3RlOgo+IE9uIFRodSwgQXByIDcsIDIw
MTYgYXQgNzoyNSBQTSwgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0IDxtYWlsdG86
c2FuZGVlbkBzYW5kZWVuLm5ldD4+d3JvdGU6Cj4gCj4gCj4gCj4gICAgICJNYW55IG9wdGlvbnMg
YWxsb3cgZm9yIGFuIG9wdGlvbmFsIGFyZ3VtZW50IG9mIDAgb3IgMSwgLi4uIgo+IAo+ICAgICA+
ICtkaXNhYmxlIG9yIGVuYWJsZSB0aGUgZnVuY3Rpb25hbGl0eSwgaW4gYSBmb3J3YXJkLWNvbXBh
dGlibGUgc3ludGF4Lgo+IAo+ICAgICBXaGF0IGRvZXMgImZvcndhcmQtY29tcGF0aWJsZSBzeW50
YXgiIG1lYW4/ICBJJ20gbm90IHN1cmUgdGhhdCBjbGFyaWZpZXMKPiAgICAgYW55dGhpbmcgZm9y
IHRoZSByZWFkZXIuCj4gCj4g4oCLWWVhaCwgSSBzaG91bGQgcmVmb3JtdWxhdGUgaXQsIEkgdGhp
bmsuIFRoZSBtZWFuaW5nIGlzIHRoYXQgaXQgd29uJ3QKPiBtYXR0ZXIgd2hhdCB0aGUgZGVmYXVs
dHMgYXJlIG5vdywgb3Igd2lsbCBiZSBpbiB0aGUgZnV0dXJlLiBFLmcuLCBpZgo+IHlvdSBoYWQg
YSBzY3JpcHQgY3JlYXRpbmcgYSBmcyB3aXRob3V0IGNyYyBiZWZvcmUsIHdoZW4gaXQgd2FzCj4g
ZGlzYWJsZWQgYnkgZGVmYXVsdCwgYW5kIHdlIGNoYW5nZWQgdGhlIGRlZmF1bHQsIHlvdSBhcmUg
bm93IGNyZWF0aW5nCj4gd2l0aCB0aGUgY3JjLiBCdXQgaWYgeW91IGdpdmUgaXQgLW0gY3JjPTAs
IHRoZW4gbm8gbWF0dGVyIHdoYXQgdGhlCj4gZGVmYXVsdCBpcywgeW91IGhhdmUgaXQgYWx3YXlz
IGRpc2FibGVkLgoKT2ssIEkgc2VlLgoKPiBIb3cgYWJvdXQgY2hhbmdpbmcgdGhlIGxpbmUgdG8g
IkJvb2xlYW4gb3B0aW9ucyBhbGxvd3MgZm9yIG9wdGlvbmFsCj4gYXJndW1lbnQgb2YgdmFsdWUg
MCBvciAxLCB0byBleHBsaWNpdGx5IGRpc2FibGUgb3IgZW5hYmxlIHRoZQo+IGZ1bmN0aW9uYWxp
dHksIiBhbmQgZHJvcHBpbmcgdGhlIGZvcndhcmQtY29tcGF0aWJsZSBwYXJ0PwoKSSB0aGluayBq
dXN0OgoKTWFueSBvcHRpb25zIGFjY2VwdCBhbiBvcHRpb25hbCBhcmd1bWVudCBvZiB2YWx1ZSAw
IG9yIDEsIHRvIGV4cGxpY2l0bHkKZGlzYWJsZSBvciBlbmFibGUgdGhlIGZ1bmN0aW9uYWxpdHku
Cgp3b3VsZCBzdWZmaWNlLgoKPiAgCj4gCj4gICAgIE90aGVyd2lzZSB0aGlzIGxvb2tzIG9rIHRv
IG1lOyBEYXZlIGV4cGxhaW5lZCB0aGF0IGl0IGlzIGludGVudGlvbmFsIHRvCj4gICAgIG1ha2Ug
ZXZlcnkgc2luZ2xlIG9wdGlvbiBhY2NlcHQgYSB2YWx1ZSwgd2hldGhlciBpdCBpcyBub3cKPiAg
ICAgYm9vbGVhbiBvciBhIG51bWVyaWMgdmFsdWUsIHNvIHRoZXJlIGlzIG5vIHN1Y2ggdGhpbmcg
YXMgYSBiYXJlICItLWZsYWciCj4gICAgIGFueW1vcmU7IHN1Y2ggZmxhZ3MgYXJlIGFsd2F5cyAi
LS1mbGFnIFswfDFdIiBub3csIHJpZ2h0Pwo+IAo+IAo+IOKAi0ZvciBvcHRpb25zIGluc2lkZSBv
ZiAtbSwgLWQgYW5kIHN1Y2gsIHllcy4gVG9wLWxldmVsIGZsYWdzLCB0aGF0IGlzCj4gLWYsIC1x
LCAtTiwgLUsgYW5kIC1WLCBhcmUgc3RpbGwgb25seSBmbGFncywgYnV0IHRoZXNlIGRvbid0IGNo
YW5nZQo+IHRoZSBGUyBhdHRyaWJ1dGVzLiBUaGV5IGFyZSBzb21ldGhpbmcgZGlmZmVyZW50IGZy
b20gdGhlIG90aGVyLgo+IFN0aWxsLCBJIHdvbmRlciB3aGV0aGVyIHRoZXkgc2hvdWxkIGFjY2Vw
dCBbMHwxXSB0b28uLi4KCkVoLCBub3QgcmlnaHQgbm93IDspCgpUaGFua3MsCi1FcmljCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
