Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE6567CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 19:33:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 902FE3040CB
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 17:33:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EAObp43X319BIR8j for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2016 17:33:16 -0700 (PDT)
Date: Sat, 4 Jun 2016 10:32:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/19 v2] mkfs cleaning
Message-ID: <20160604003259.GV26977@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<20160510061054.GI26977@dastard>
	<CACj3i715X7X65=BjSW8GZLhUF-YjQVShC-_Udmxe24XB1ACb1w@mail.gmail.com>
	<20160603005324.GS12670@dastard>
	<CACj3i70LGZ7TKWRdKVTi4MyyL5DhnH5Fr-3Q6O5qhKbYfvWJbA@mail.gmail.com>
	<CACj3i734=8ZJcdJztA76ru93SpdNNUgVtF_tUv2Jy_8U0V9HzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i734=8ZJcdJztA76ru93SpdNNUgVtF_tUv2Jy_8U0V9HzQ@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

T24gRnJpLCBKdW4gMDMsIDIwMTYgYXQgMDI6MDk6MTlQTSArMDIwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IFsKPiDigItzbmlwIGFsbCwgYW5vdGhlciBpc3N1ZSwgdW5yZWxhdGVkIHRvIHRoZSBsc3Vu
aXQgb25lXeKAiwo+IAo+ID4KPiDigItJIHJlYWxpc2VkIG9uZSBzbWFsbCBnbGl0Y2ggd2l0aCBj
b25mbGljdHMgd2F0Y2hpbmcgaW4gdGhlIGNvZGUgaW4KPiBjb21iaW5hdGlvbiB3aXRoIGZsYWdz
LiBJdCBpcyBub3QgcmVncmVzc2lvbiwgSSB0aGluaywgYmVjYXVzZSBi4oCLZWZvcmUgbm93LAo+
IGl0IHdhcyBub3QgcG9zc2libGUgdG8gZG8gc29tZXRoaW5nIGxpa2UgLWwgaW50ZXJuYWw9MCxs
b2dkZXY9c29tZXRoaW5nLAo+IGJ1dCBub3cgaXQgc2hvdWxkIGJlIHBvc3NpYmxlLgoKSSB0aGlu
ayB0aGF0IG92ZXJseSBjb21wbGljYXRlcyB0aGluZ3MuIE15IG9yaWdpbmFsIGludGVudCBmb3Ig
dGhpcwp3b3JrIHdhcyB0byBzaW1wbGlmeSB0aGUgaW50ZXJmYWNlIGFuZCBjb2RlLCBub3QgbWFr
ZSBpdCBtb3JlCmVsYWJvcmF0ZSB0byBzdXBwb3J0IGNvbmZpZ3VyYXRpb25zIHRoYXQgYXJlIHRo
ZW9yZXRpY2FsbHkgcG9zc2libGUKYnV0IGNvbXBsZXRlbHkgcmVkdW5kYW50LgoKaS5lLiAnLWwg
aW50ZXJuYWw9MCxsb2dkZXY9c29tZXRoaW5nJyBpcyBpZGVudGljYWwgaW4gZnVuY3Rpb24gdG8K
Jy1sIGxvZ2Rldj1zb21ldGhpbmcnLCBzbyB0aGVyZSBpcyBubyBuZWVkIHRvIHNwZWNpZnkgaW50
ZXJuYWw9MC4KQUZBSUNULCB0aGVyeHAgZWlzIG5ldmVyIGEgbmVlZCB0byBzcGVjaWZ5ICctbCBp
bnRlcm5hbD1bMHwxXScKYmVjYXVzZSBpZiAnLWwgbG9nZGV2PTxmb28+JyBpcyBzcGVjaWZpZWQs
IGl0IGltcGxpZXMgYW4gZXh0ZXJuYWwKbG9nIGlzIGJlaW5nIGNvbmZpZ3VyZWQsIGFuZCBpbiBl
dmVyeSBvdGhlciBjYXNlIHRoZSBsb2cgaXMKaW50ZXJuYWwuCgo+IFRoZSBjb2RlIGNoZWNrcyBv
bmx5IHdoZXRoZXIgYW4gb3B0aW9uIHdhcyBzZWVuLCBub3QgaXRzIHZhbHVlLCBzbyBpdAo+IGRv
ZXMndCBrbm93IHRoYXQgd2UgYXJlIGluIGZhY3QgZGlzYWJsaW5nIHNvbWV0aGluZy4gSSBzZWUg
dHdvIHdheXMgaG93IHRvCj4gZG8gc29sdmUgaXQuIE9uZSBpcyBhIGN1c3RvbSBjb25mbGljdCBz
b2x2aW5nIGZvciB0aGVzZSBjYXNlcywgcHV0dGluZyBzb21lCj4gaWYgKGZsYWcxICYmIG9wdGlv
bjIpIHNvbWV3aGVyZSBvbmNlIGV2ZXJ5IGFyZ3VtZW50IGFuZCBvcHRpb24gaXMgcGFyc2VkLgo+
IEJ1dCB0aGlzIGdvZXMgYWdhaW5zdCB3aGF0IHRoZSBwYXRjaHNldCBkaWQgYW5kIG1vdmVzIGl0
IGFnYWluIG91dCBvZiB0aGUKPiBvcHRpb24gdGFibGUuLi4KPiAKPiBUaGUgb3RoZXIgd2F5IGlz
IHRvIG1ha2UgYSBzcGVjaWFsIGNhc2UgZm9yIGZsYWdzIGluIHRoZSBjb25mbGljdHMtaGFuZGxp
bmcKPiBjb2RlLiBCYXNpY2FsbHksIEkgd291bGQgZXh0ZW5kIHRoZSBzdHJ1Y3R1cmUgd2l0aCBz
b21ldGhpbmcgbGlrZToKPiAKPiB7IC5pbmRleCA9IExfSU5URVJOQUwsCj4gICAuY29uZmxpY3Rz
ID0geyBMX0ZJTEUsCj4gICAgICAgICBMX0RFViwKPiAgICAgICAgIExBU1RfQ09ORkxJQ1QgfSwK
PiAgIC5jb25mbGljdHNfaWdub3JlX29uX2ZhbHNlPXRydWUsIC8vIG5ldyBpdGVtLCBzaG9ydGVy
IG5hbWUgdG8gYmUgZm91bmQKCldoYXQgaGFwcGVucyB3aGVuIHlvdSBoYXZlIHR3byBjb25mbGlj
dHMsIG9uIHdoaWNoIHlvdSB3YW50IHRvCmlnbm9yZSBvbiBmYWxzZSwgdGhlIG90aGVyIHlvdSB3
YW50IHRvIGlnbm9yZSBvbiB0cnVlPyAgQW5kIHdoZXJlIGRvCnlvdSBkcmF3IHRoZSBsaW5lPyBM
X1NVIHZzIExfU1VOSVQgY29uZmxpY3QgYW5kIHRocm93IGFuIGVycm9yIG9ubHkKd2hlbiB0aGUg
dmFsdWVzIGRpZmZlcj8KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJv
bW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
