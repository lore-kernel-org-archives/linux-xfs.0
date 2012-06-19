Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JE83cV101160 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:08:04 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id z366ACb5V8YcBteG for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:08:03 -0700 (PDT)
Date: Tue, 19 Jun 2012 09:34:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619133441.GA7001@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<4FE062B3.7080702@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE062B3.7080702@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBKdW4gMTkgMjAxMiBhdCAgNzoyOWFtIC0wNDAwLApTcGVsaWMgPHNwZWxpY0BzaGlm
dG1haWwub3JnPiB3cm90ZToKCj4gT24gMDYvMTkvMTIgMDg6MzIsIEx1a8OhxaEgQ3plcm5lciB3
cm90ZToKPiA+Cj4gPlNvIGRvIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgdGhhdCBldmVuIHRob3Vn
aCB0aGUgZGlzY2FyZCBjYW1lCj4gPnRocm91Z2ggYW5kIHRoaW5wIHRvb2sgYWR2YW50YWdlIG9m
IGl0IGl0IHN0aWxsIHJldHVybnMgRU9QTk9UU1VQUCA/Cj4gPlRoaXMgc2VlbXMgcmF0aGVyIHN1
Ym9wdGltYWwuIElJUkMgdGhlcmUgd2FzIGEgZGlzY3Vzc2lvbiB0byBhZGQgYW4KPiA+b3B0aW9u
IHRvIGVuYWJsZS9kaXNhYmxlIHNlbmRpbmcgZGlzY2FyZCBpbiB0aGlucCB0YXJnZXQgZG93bgo+
ID50byB0aGUgZGV2aWNlLgo+IAo+IEknbGwgYXNrIHRoaXMgdG9vLi4uCj4gZG8gSSB1bmRlcnN0
YW5kIGNvcnJlY3RseSB0aGF0IGRtLXRoaW4gcmV0dXJucyBFT1BOT1RTVVBQIHRvIHRoZQo+IGZp
bGVzeXN0ZW0gbGF5ZXIgZXZlbiB0aG91Z2ggaXQgaXMgdXNpbmcgdGhlIGRpc2NhcmQgdG8gdW5t
YXAKPiBibG9ja3MsIGFuZCBhdCB0aGF0IHBvaW50IFhGUyBzdG9wcyBzZW5kaW5nIGRpc2NhcmRz
IGRvd24gdGhlcmUKPiAod2hpbGUgZXh0NCBrZWVwcyBzZW5kaW5nIHRoZW0pPwoKQXJlIHlvdSBh
Y3R1YWxseSBzZWVpbmcgdGhhdD8gIE9yIGFyZSB5b3UganVzdCBzZWl6aW5nIG9uIEx1a2FzJwpt
aXN1bmRlcnN0YW5kaW5nPwoKPiBUaGlzIGxvb2tzIGxpa2UgYSBidWcgb2YgZG0tdGhpbiB0byBt
ZS4gRGlzY2FyZHMgYXJlICJzdXBwb3J0ZWQiIGluCj4gc3VjaCBhIHNjZW5hcmlvLgo+IAo+IERv
IHlvdSBoYXZlIGEgcGF0Y2ggZm9yIGRtLXRoaW4gc28gdG8gcHJldmVudCBpdCBzZW5kaW5nIEVP
UFROT1RTVVBQID8KCnRoaW5wIHNob3VsZCBfbm90XyBiZSBzZW5kaW5nIC1FT1BOT1RTVVBQIHVu
bGVzcyAnaWdub3JlX2Rpc2NhcmQnIGlzCnByb3ZpZGVkIGFzIGEgZmVhdHVyZSB3aGVuIGxvYWRp
bmcgdGhpbi1wb29sJ3MgRE0gIHRhYmxlLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
