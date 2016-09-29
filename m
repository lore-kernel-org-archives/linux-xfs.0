Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 22D8D7CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 00:56:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA0A3304032
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 22:56:10 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 0GuuKmdBpiaFJVff (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2016 22:56:06 -0700 (PDT)
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
	BLKZEROOUT.
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <95e7b8a5-49dd-ea06-5fba-8831ef08ca5a@suse.de>
Date: Thu, 29 Sep 2016 07:56:03 +0200
MIME-Version: 1.0
In-Reply-To: <147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
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

T24gMDkvMjkvMjAxNiAwMjozOSBBTSwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+IEludmFsaWRh
dGUgdGhlIHBhZ2UgY2FjaGUgKGFzIGEgcmVndWxhciBPX0RJUkVDVCB3cml0ZSB3b3VsZCBkbykg
dG8gYXZvaWQKPiByZXR1cm5pbmcgc3RhbGUgY2FjaGUgY29udGVudHMgYXQgYSBsYXRlciB0aW1l
Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGFycmljay53b25nQG9yYWNs
ZS5jb20+Cj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFJl
dmlld2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29t
Pgo+IC0tLQo+ICBibG9jay9pb2N0bC5jIHwgICAxOCArKysrKysrKysrKystLS0tLS0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4gClJldmlld2Vk
LWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+CgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgIHpTZXJpZXMgJiBTdG9yYWdlCmhhcmVAc3VzZS5k
ZQkJCSAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggUHJvZHVjdHMgR21iSCwgTWF4
ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBKLiBIYXduLCBKLiBHdWlsZCwgRi4gSW1l
bmTDtnJmZmVyLCBIUkIgMTY3NDYgKEFHIE7DvHJuYmVyZykKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
