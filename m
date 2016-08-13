Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A75C07CAE
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DED68F8066
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wpdIXDbjpesuU9cp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:06 -0700 (PDT)
Received: from [107.17.164.165] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bYia1-0006L9-Mt
	for xfs@oss.sgi.com; Sat, 13 Aug 2016 23:43:05 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] iomap: remove superflous pagefault_disable from
	iomap_write_actor
Date: Sat, 13 Aug 2016 16:42:56 -0700
Message-Id: <1471131781-14107-3-git-send-email-hch@lst.de>
In-Reply-To: <1471131781-14107-1-git-send-email-hch@lst.de>
References: <1471131781-14107-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
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

aW92X2l0ZXJfY29weV9mcm9tX3VzZXJfYXRvbWljIGRpc2FibGXRlSBwYWdlIGZhdWxzIGludGVy
bmFsLCBubyBuZWVkIHRvCmRvIGl0IGFyb3VuZCB0aGUgY2FsbC4gIFRoaXMgYWxzbyBicmluZ3Mg
dGhlIGlvbWFwIGNvZGUgaW4gbGluZSB3aXRoCnRoZSBvcmlnaW5hbCBmaWxlbWFwIHZlcnNpb24u
CgpTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KLS0tCiBmcy9p
b21hcC5jIHwgMiAtLQogMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvaW9tYXAuYyBiL2ZzL2lvbWFwLmMKaW5kZXggZjM5YzMxOC4uNzQ3MTJlMiAxMDA2NDQK
LS0tIGEvZnMvaW9tYXAuYworKysgYi9mcy9pb21hcC5jCkBAIC0xOTQsOSArMTk0LDcgQEAgYWdh
aW46CiAJCWlmIChtYXBwaW5nX3dyaXRhYmx5X21hcHBlZChpbm9kZS0+aV9tYXBwaW5nKSkKIAkJ
CWZsdXNoX2RjYWNoZV9wYWdlKHBhZ2UpOwogCi0JCXBhZ2VmYXVsdF9kaXNhYmxlKCk7CiAJCWNv
cGllZCA9IGlvdl9pdGVyX2NvcHlfZnJvbV91c2VyX2F0b21pYyhwYWdlLCBpLCBvZmZzZXQsIGJ5
dGVzKTsKLQkJcGFnZWZhdWx0X2VuYWJsZSgpOwogCiAJCWZsdXNoX2RjYWNoZV9wYWdlKHBhZ2Up
OwogCi0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
