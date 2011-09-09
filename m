Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p898hgae028835 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 03:43:42 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3093013D8CE9
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 01:47:55 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id yo1xHf2nlOTvZuK8
	for <xfs@oss.sgi.com>; Fri, 09 Sep 2011 01:47:55 -0700 (PDT)
Received: by fxd23 with SMTP id 23so2365845fxd.26
	for <xfs@oss.sgi.com>; Fri, 09 Sep 2011 01:43:39 -0700 (PDT)
Message-ID: <4E69D1B9.8070201@nasza-klasa.pl>
Date: Fri, 09 Sep 2011 10:43:37 +0200
From: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>
MIME-Version: 1.0
Subject: xfs_repair segfaut in stage 6
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
To: xfs@oss.sgi.com

SGksCgpSZWNlbnRseSB3ZSBoYWQgc29tZSBwcm9ibGVtcyB3aXRoIDJUQiBwYXJ0aXRpb24gdXNp
bmcgeGZzLgoKSS9PIGVycm9yIGluIGZpbGVzeXN0ZW0gKCJjY2lzcy9jMGQ1cDEiKSBtZXRhLWRh
dGEgZGV2IGNjaXNzL2MwZDVwMQpibG9jayAweDEyMGEwICAgICAgICgieGZzX3RyYW5zX3JlYWRf
YnVmIikgZXJyb3IgNSBidWYgY291bnQgNDA5NgoKQXQgZmlyc3QgSSBzdXNwZWN0ZWQgZmFpbGVk
IGhhcmR3YXJlLCBidXQgZGlzayBhcnJheSB3YXNuJ3QgcmVwb3J0aW5nCmFueXRoaW5nLgoKRGlz
dHJvIChEZWJpYW4gNS4wKSB2ZXJzaW9uIG9mIHhmc19yZXBhaXIgZmluaXNoZWQgd2l0aCBzZWdm
YXVsdC4gU2FtZQp3aXRoIGNvbXBpbGVkIGZyb20gZ2l0LiBJIGZpbGxlZCBidWcgcmVwb3J0IFsx
XS4gQ2FuIHNvbWVvbmUgcG9zc2libHkKbG9vayBpbnRvIGl0PyBBcyBpdCdzIGhhZG9vcCBoZWF2
eSByZXBsaWNhdGVkIHBhcnRpdGlvbiBJIGtlZXAgaXQgb25seQp0byBwcm92aWRlIGFkZGl0aW9u
YWwgaW5mb3JtYXRpb24gdG8gcmVzb2x2ZSB0aGlzIHNlZ2ZhdWx0LiBJIHdvdWxkIGJlCmhhcHB5
IHRvIHByb3ZpZGUgYXMgbXVjaCBkZXRhaWxlZCBpbmZvIGFzIHJlcXVpcmVkLCBidXQgSSBuZWVk
IHRvIGtub3cKd2hhdCA6KQoKWzFdIGh0dHA6Ly9vc3Muc2dpLmNvbS9idWd6aWxsYS9zaG93X2J1
Zy5jZ2k/aWQ9OTE0CgpLaW5kIHJlZ2FyZHMsCgpCYXJ0ZWsKLS0gCkJhcnRvc3ogQ2lzZWsKQWRt
aW4KCmVtYWlsOiBiYXJ0b3N6LmNpc2VrQG5hc3phLWtsYXNhLnBsCnRlbDogKzQ4IDUxOSAzMDAg
MTIyCgpOYXN6YSBLbGFzYSBTcC4geiBvLm8uLAp1bC4gR2VuLiBKLiBCZW1hIDIsIDUwLTI2NSBX
cm9jxYJhdwoKU8SFZCBSZWpvbm93eSBkbGEgV3JvY8WCYXdpYSAtIEZhYnJ5Y3puZWogd2UgV3Jv
Y8WCYXdpdSwKVkkgV3lkemlhxYIgR29zcG9kYXJjenkgS3Jham93ZWdvIFJlamVzdHJ1IFPEhWRv
d2VnbywKbnIgS1JTOjAwMDAyODk2MjksIE5JUDo4OTgtMjEtMjItMTA0IFJFR09OOjAyMDU4NjAy
MCwKS2FwaXRhxYIgemFrxYJhZG93eTogNjcgODUwLDAwIFBMTgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
