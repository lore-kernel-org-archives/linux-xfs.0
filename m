Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E0DF7CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 00:56:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4824304032
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 22:56:34 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id qJ9aTYZt4RFkdLRF (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2016 22:56:33 -0700 (PDT)
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
	to logical block size
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510958448.8940.14280630935441533825.stgit@birch.djwong.org>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <01403e58-6638-7c60-c195-5ab413f4ceb4@suse.de>
Date: Thu, 29 Sep 2016 07:56:31 +0200
MIME-Version: 1.0
In-Reply-To: <147510958448.8940.14280630935441533825.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk, akpm@linux-foundation.org
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com, Christoph Hellwig <hch@lst.de>

T24gMDkvMjkvMjAxNiAwMjozOSBBTSwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+IE1ha2Ugc3Vy
ZSB0aGF0IHRoZSBvZmZzZXQgYW5kIGxlbmd0aCBhcmd1bWVudHMgdGhhdCB3ZSdyZSB1c2luZyB0
bwo+IGNvbnN0cnVjdCBXUklURSBTQU1FIGFuZCBESVNDQVJEIHJlcXVlc3RzIGFyZSBhY3R1YWxs
eSBhbGlnbmVkIHRvIHRoZQo+IGxvZ2ljYWwgYmxvY2sgc2l6ZS4gIEZhaWx1cmUgdG8gZG8gdGhp
cyBjYXVzZXMgb3RoZXIgZXJyb3JzIGluIG90aGVyCj4gcGFydHMgb2YgdGhlIGJsb2NrIGxheWVy
IG9yIHRoZSBTQ1NJIGxheWVyIGJlY2F1c2UgZGlza3MgZG9uJ3Qgc3VwcG9ydAo+IHBhcnRpYWwg
bG9naWNhbCBibG9jayB3cml0ZXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFycmljayBKLiBXb25n
IDxkYXJyaWNrLndvbmdAb3JhY2xlLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3
aWcgPGhjaEBsc3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5h
c3NjaGVAc2FuZGlzay5jb20+Cj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFy
dGluLnBldGVyc2VuQG9yYWNsZS5jb20+Cj4gLS0tCj4gIGJsb2NrL2Jsay1saWIuYyB8ICAgMTUg
KysrKysrKysrKysrKysrCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspCj4gClJl
dmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+CgpDaGVlcnMsCgpIYW5u
ZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgIHpTZXJpZXMgJiBTdG9yYWdlCmhhcmVA
c3VzZS5kZQkJCSAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggUHJvZHVjdHMgR21i
SCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBKLiBIYXduLCBKLiBHdWlsZCwg
Ri4gSW1lbmTDtnJmZmVyLCBIUkIgMTY3NDYgKEFHIE7DvHJuYmVyZykKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
