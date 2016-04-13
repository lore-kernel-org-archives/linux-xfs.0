Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82DE17CA7
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:25:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 544668F8033
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:25:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id N7E7pnTMyqmbIsqX for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 09:25:53 -0700 (PDT)
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
	<20160408230843.GE567@dastard>
	<CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
	<570E7129.3080900@sandeen.net>
	<CACj3i722SbMYzPG9KR6QJJsTVs2Nju6csGKF=+f+PYjbHPYYQA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <570E7310.1090806@sandeen.net>
Date: Wed, 13 Apr 2016 11:25:52 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i722SbMYzPG9KR6QJJsTVs2Nju6csGKF=+f+PYjbHPYYQA@mail.gmail.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

CgpPbiA0LzEzLzE2IDExOjIzIEFNLCBKYW4gVHVsYWsgd3JvdGU6Cj4gCj4gCj4gT24gV2VkLCBB
cHIgMTMsIDIwMTYgYXQgNjoxNyBQTSwgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0
IDxtYWlsdG86c2FuZGVlbkBzYW5kZWVuLm5ldD4+IHdyb3RlOgo+IAo+ICAgICBPbiA0LzEzLzE2
IDEwOjA4IEFNLCBKYW4gVHVsYWsgd3JvdGU6Cj4gCj4gICAgIC4uLgo+IAo+ICAgICA+IEFsbCBy
aWdodOKAiywgSSB3aWxsIGtlZXAgdGhlIE9fVFJVTkMgdGhlcmUuIEhvd2V2ZXIsIHNob3VsZCBp
dAo+ICAgICA+IHRydW5jYXRlIHRoZSBmaWxlIGV2ZXJ5IHRpbWUsIG9yIHNob3VsZCB3ZSBvZmZl
ciBhIHdheSBob3cgdG8gYXZvaWQKPiAgICAgPiB0aGUgZmlsZSB0cnVuY2F0aW5nPyBVbnRpbCBu
b3csIG1rZnMgYmVoYXZlZCBkaWZmZXJlbnRseSBiYXNlZCBvbgo+ICAgICA+IHdoZXRoZXIgLWQg
ZmlsZSB3YXMgZ2l2ZW4sIG9yIG5vdC4gWW91ciBleHBsYW5hdGlvbiBzdWdnZXN0cyB0aGF0IHdl
Cj4gICAgID4gc2hvdWxkIHRydW5jYXRlIGV2ZXJ5IHRpbWUsIHJpZ2h0Pwo+IAo+ICAgICBUaGVy
ZSBhcmUgcHJvYmFibHkgdmFsaWQgcmVhc29ucyB0byBrZWVwIHNpemUgYXMgd2VsbCBhcyB0byB0
cnVuY2F0ZTsKPiAgICAgaXQncyBub3QgaW1tZWRpYXRlbHkgY2xlYXIgdG8gbWUgaG93IHdlIHNo
b3VsZCBoYW5kbGUgaXQuCj4gCj4gICAgIEhvbmVzdGx5LCBhdCB0aGlzIHBvaW50LCBpbiB0aGUg
aW50ZXJlc3Qgb2YgZ2V0dGluZyB0aGUgb3RoZXIgZml4ZXMgaW4sCj4gICAgIEkgdGhpbmsgSSBt
aWdodCByYXRoZXIgc2VlIHRoZSB0cnVuY2F0aW5nIGJlaGF2aW9yIHVuY2hhbmdlZCBmcm9tIHdo
YXQKPiAgICAgd2UgaGF2ZSB0b2RheTsgd2UgY2FuIHRhY2tsZSB0aGF0IGFzIGEgc2VwYXJhdGUg
cHJvYmxlbSBhdCBhIGxhdGVyIGRhdGUuCj4gCj4gICAgIFdoYXQgZG8geW91IHRoaW5rPwo+IAo+
IOKAi0ZvciBrZWVwaW5nIHRoZSBzaXplLCB0aGUgZWFzaWVzdCB3YXkgbWlnaHQgYmUgdG8gaW1w
bGljaXRseSBzZXQKPiB4aS5kc2l6ZSAob3Igd2hhdGV2ZXIpIHRvIHRoZSBjdXJyZW50IHNpemUu
IE9mIGNvdXJzZSwgYWZ0ZXIgYSBjaGVjawo+IGZvciAtZCBmaWxlLG5hbWUsc2l6ZSBjb21iby4g
QUZBSUsgKHdpdGhvdXQgbG9va2luZyB0byB0aGUgY29kZSwgSSdtCj4ganVzdCBlbmRpbmcgZm9y
IHRvZGF5IGFuZCBpbiB0aGUgbWlkZGxlIG9mIHNodXR0aW5nIGV2ZXJ5dGhpbmcgZG93bgo+IDot
KSApLCB3ZSDigItkbyB0aGUgdHJ1bmNhdGlvbiBhZnRlciB0aGUgY29tYm8gY2hlY2suIFNvIHRo
aXMgc2hvdWxkIGJlCj4gbm8gYmlnIGlzc3VlLi4uIEkgd2lsbCBsb29rIG9uIHRoaXMgdG9tb3Jy
b3csIHRvIGtub3cgYmV0dGVyLgoKSSdtIGp1c3Qgc2F5aW5nOyBsZXQncyBub3QgY2hhbmdlIGN1
cnJlbnQgYmVoYXZpb3Igd2l0aG91dCBnb29kIHJlYXNvbi4KSWYgaXQgcmVxdWlyZXMgYSBsb3Qg
b2YgZGlzY3Vzc2lvbiwgbGV0J3Mga2VlcCBjdXJyZW50IGJlaGF2aW9yIGluIGFsbApjYXNlcyBm
b3Igbm93LCBzbyB0aGF0IHdlIGNhbiBtb3ZlIHRoZSBsYXJnZXIgcGF0Y2hzZXQgZm9yd2FyZC4K
ClRoYW5rcywKLUVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
