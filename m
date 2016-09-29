Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DDB857CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 03:38:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34607AC003
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 01:38:29 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id mGohBHgt9BfBHB1U (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Sep 2016 01:38:26 -0700 (PDT)
Date: Thu, 29 Sep 2016 10:38:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: aio completions vs file_accessed race, was: Re: [PATCH 7/8] xfs:
	split direct I/O and DAX path
Message-ID: <20160929083824.GA12799@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<1466609236-23801-8-git-send-email-hch@lst.de>
	<20160929025351.GB4901@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160929025351.GB4901@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

T24gV2VkLCBTZXAgMjgsIDIwMTYgYXQgMDc6NTM6NTJQTSAtMDcwMCwgRGFycmljayBKLiBXb25n
IHdyb3RlOgo+IFNvIEkgbm90aWNlZCB0aGF0IGdlbmVyaWMvMzIzIHN0YXJ0cyBjcmFzaGluZyBp
biBmaWxlX2FjY2Vzc2VkIC0+IHRvdWNoX2F0aW1lCj4gYmVjYXVzZSBpb2NiLT5raV9maWxwLT5m
X3BhdGguZGVudHJ5ID09IE5VTEwuICBGb3IgYSB3aGlsZSBJIHRob3VnaHQgaXQgd2FzCj4gc29t
ZSB3ZWlyZCByZWZsaW5rIGJ1ZywgYnV0IEkgZmluYWxseSBoYWQgdGltZSB0byBnbyBidWlsZCBh
IHZhbmlsbGEgNC44LXJjOAo+IGtlcm5lbCBhbmQgdGhhdCBibGV3IHVwIGhlcmUgdG9vLiAgSSdt
IG5vdCBzdXJlIHdoeSB0aGlzIGxpbmUgZ290IGluc2VydGVkCj4gaGVyZSwgc2luY2UgaXQgd2Fz
bid0IHRoZXJlIHByaW9yIHRvIHRoaXMgcGF0Y2gsIEFGQUlDVC4KClRoaXMgbGluZSB3YXMgdGhl
cmUgYmVmb3JlIG5lYXIgdGhlIGVuZCBvZiB4ZnNfZmlsZV9kaW9fYWlvX3JlYWQgYWxyZWFkeSwK
ZS5nLiBsaW5lIDM3NiBqdXN0IGJlZm9yZSB0aGUgYWJvdmUgY29tbWl0LCBidXQgaXQgb25seSBn
b3QgaW50cm9kdWNlZAphIGJpdCBlYXJsaWVyIGluICJ4ZnM6IHN0b3AgdXNpbmcgZ2VuZXJpY19m
aWxlX3JlYWRfaXRlciBmb3IgZGlyZWN0IEkvTyIsCndoaWNoIGNvcGllZCBpdCBvdmVyIGZyb20g
Z2VuZXJpY19maWxlX3JlYWRfaXRlci4gINCGIHRoaW5rIGFueSBuZXcKaXNzdWVzIGluIHRoZXNl
IGNvbW1pdHMgY291bGQganVzdCBiZSBhIG1pbm9yIHRpbWluZyBjaGFuZ2UsIGFzCndlJ3JlIG5v
dCBjaGFuZ2luZyBzdHJ1Y3QgZmlsZSByZWZjb3VudGluZyBpbiBhbnkgd2F5IGhlcmUuCgpnZW5l
cmljLzMyMyByZXByb2R1Y2VzIHRoZSBsYXN0IHN0cnVjdCBmaWxlIHJlZmVyZW5jZSBiZWluZyBk
cm9wcGVkCmJ5IGFpbyBjb21wbGV0aW9ucywgc28gaXQgc2VlbXMgbGlrZSB3ZSBoYXZlIGFuIGlz
c3VlIGhlcmUsIHdoaWNoCkkgc3VzcGVjdCBpcyBzb21ldGhpbmcgaW4gdGhlIGNvbW1vbiBjb2Rl
LiAgSSBjYW4ndCByZXByb2R1Y2UgaXQKbG9jYWxseSwgYnV0IGxvb2tpbmcgYXQgdGhlIGFpb19j
b21wbGV0ZSAtPiBraW9jYl9mcmVlIGNhbGxjaGFpbgphbmQgdGhlIGxhY2sgb2Ygb3RoZXIgc3Ry
dWN0IGZpbGUgcmVmY291bnRpbmcgaW4gYWlvLmMgaXQgc2VlbXMKaW5oZXJlbnRseSB1bnNhZmUg
dG8gcmVmZXJlbmNlIHN0cnVjdCBmaWxlIG9uY2UgdGhlIGNvbXBsZXRpb24KbWF5IGhhdmUgcnVu
LCB0aGF0IGlzIGFmdGVyIChfXylibGtkZXZfZGlyZWN0X0lPIHJldHVybmVkLgoKSSdsbCBzZWUg
aWYgSSBjYW4gY29tZSB1cCB3aXRoIGEgc29sdXRpb24gZm9yIHRoYXQsIG1vc3QgbGlrZWx5CnRo
YXQgd291bGQgaW52b2x2ZSBtb3ZpbmcgdGhlIGZpbGVfYWNjZXNzZWQgY2FsbCBpbnRvIF9fYmxr
ZGV2X2RpcmVjdF9JTwpiZWZvcmUgd2UgZHJvcCB0aGUgZmluYWwgcmVmZXJlbmNlIG9uIHRoZSBk
aW8gc3RydWN0dXJlLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
