Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4473F7CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:17:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1421A304062
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:17:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id olGo2ShGLYCOr3AM for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 09:17:47 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9FC5F14A15
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:17:46 -0500 (CDT)
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
	<20160408230843.GE567@dastard>
	<CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <570E7129.3080900@sandeen.net>
Date: Wed, 13 Apr 2016 11:17:45 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
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

T24gNC8xMy8xNiAxMDowOCBBTSwgSmFuIFR1bGFrIHdyb3RlOgoKLi4uCgo+IEFsbCByaWdodOKA
iywgSSB3aWxsIGtlZXAgdGhlIE9fVFJVTkMgdGhlcmUuIEhvd2V2ZXIsIHNob3VsZCBpdAo+IHRy
dW5jYXRlIHRoZSBmaWxlIGV2ZXJ5IHRpbWUsIG9yIHNob3VsZCB3ZSBvZmZlciBhIHdheSBob3cg
dG8gYXZvaWQKPiB0aGUgZmlsZSB0cnVuY2F0aW5nPyBVbnRpbCBub3csIG1rZnMgYmVoYXZlZCBk
aWZmZXJlbnRseSBiYXNlZCBvbgo+IHdoZXRoZXIgLWQgZmlsZSB3YXMgZ2l2ZW4sIG9yIG5vdC4g
WW91ciBleHBsYW5hdGlvbiBzdWdnZXN0cyB0aGF0IHdlCj4gc2hvdWxkIHRydW5jYXRlIGV2ZXJ5
IHRpbWUsIHJpZ2h0PwoKVGhlcmUgYXJlIHByb2JhYmx5IHZhbGlkIHJlYXNvbnMgdG8ga2VlcCBz
aXplIGFzIHdlbGwgYXMgdG8gdHJ1bmNhdGU7Cml0J3Mgbm90IGltbWVkaWF0ZWx5IGNsZWFyIHRv
IG1lIGhvdyB3ZSBzaG91bGQgaGFuZGxlIGl0LgoKSG9uZXN0bHksIGF0IHRoaXMgcG9pbnQsIGlu
IHRoZSBpbnRlcmVzdCBvZiBnZXR0aW5nIHRoZSBvdGhlciBmaXhlcyBpbiwKSSB0aGluayBJIG1p
Z2h0IHJhdGhlciBzZWUgdGhlIHRydW5jYXRpbmcgYmVoYXZpb3IgdW5jaGFuZ2VkIGZyb20gd2hh
dAp3ZSBoYXZlIHRvZGF5OyB3ZSBjYW4gdGFja2xlIHRoYXQgYXMgYSBzZXBhcmF0ZSBwcm9ibGVt
IGF0IGEgbGF0ZXIgZGF0ZS4KCldoYXQgZG8geW91IHRoaW5rPwoKLUVyaWMKCj4gCj4g4oCLQ2hl
ZXJzLAo+IEphbuKAiwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
