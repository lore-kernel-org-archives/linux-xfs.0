Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B58517CA4
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 16:38:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87BFD8F8033
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:38:06 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0HnMLAvR6j6r8VLJ for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 14:38:00 -0700 (PDT)
Date: Thu, 14 Apr 2016 07:37:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
Message-ID: <20160413213758.GR567@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
	<20160408230843.GE567@dastard>
	<CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
	<570E7129.3080900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <570E7129.3080900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

T24gV2VkLCBBcHIgMTMsIDIwMTYgYXQgMTE6MTc6NDVBTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIDQvMTMvMTYgMTA6MDggQU0sIEphbiBUdWxhayB3cm90ZToKPiAKPiAuLi4KPiAK
PiA+IEFsbCByaWdodOKAiywgSSB3aWxsIGtlZXAgdGhlIE9fVFJVTkMgdGhlcmUuIEhvd2V2ZXIs
IHNob3VsZCBpdAo+ID4gdHJ1bmNhdGUgdGhlIGZpbGUgZXZlcnkgdGltZSwgb3Igc2hvdWxkIHdl
IG9mZmVyIGEgd2F5IGhvdyB0byBhdm9pZAo+ID4gdGhlIGZpbGUgdHJ1bmNhdGluZz8gVW50aWwg
bm93LCBta2ZzIGJlaGF2ZWQgZGlmZmVyZW50bHkgYmFzZWQgb24KPiA+IHdoZXRoZXIgLWQgZmls
ZSB3YXMgZ2l2ZW4sIG9yIG5vdC4gWW91ciBleHBsYW5hdGlvbiBzdWdnZXN0cyB0aGF0IHdlCj4g
PiBzaG91bGQgdHJ1bmNhdGUgZXZlcnkgdGltZSwgcmlnaHQ/Cj4gCj4gVGhlcmUgYXJlIHByb2Jh
Ymx5IHZhbGlkIHJlYXNvbnMgdG8ga2VlcCBzaXplIGFzIHdlbGwgYXMgdG8gdHJ1bmNhdGU7Cj4g
aXQncyBub3QgaW1tZWRpYXRlbHkgY2xlYXIgdG8gbWUgaG93IHdlIHNob3VsZCBoYW5kbGUgaXQu
CgpUaGF0J3MgZWFzeTogZG9uJ3Qgc3BlY2lmeSAtZGZpbGUgb3IgLWRzaXplLCBhbmQgaW5zdGVh
ZCBsZXQgbWtmcwpkZXRlY3QgdGhhdCBpdCBpcyBmaWxlIGF1dG9tYXRpY2FsbHkuIEJlY2F1c2Ug
aXQncyBub3QgZ2l2ZW4gYSBzaXplLApvciB0aGF0IGl0J3Mgc3VwcG9zZWQgdG8gYmUgYSBmaWxl
LCBpdCBzaG91bGQgbm90IGF0dGVtcHQgdG8gY2hhbmdlCnRoZSAiZGV2aWNlIiBpbiBhbnkgd2F5
LgoKV2hlbiBibG9jayBkZXZpY2VzIGdyb3cgZmFsbG9jYXRlIHN1cHBvcnQsIHdlIGNhbiB1bmlm
eSB0aGUgZGlzY2FyZApiZWhhdmlvdXIgdG8gYmUgYSBob2xlIHB1bmNoLCBhbmQgdGhlbiBpdCB3
aWxsIHdvcmsgaWRlbnRpY2FsbHkgb24KZGV2aWNlcyBhbmQgZmlsZXMgdHJlYXRlZCB0aGlzIHdh
eS4KCj4gSG9uZXN0bHksIGF0IHRoaXMgcG9pbnQsIGluIHRoZSBpbnRlcmVzdCBvZiBnZXR0aW5n
IHRoZSBvdGhlciBmaXhlcyBpbiwKPiBJIHRoaW5rIEkgbWlnaHQgcmF0aGVyIHNlZSB0aGUgdHJ1
bmNhdGluZyBiZWhhdmlvciB1bmNoYW5nZWQgZnJvbSB3aGF0Cj4gd2UgaGF2ZSB0b2RheTsgd2Ug
Y2FuIHRhY2tsZSB0aGF0IGFzIGEgc2VwYXJhdGUgcHJvYmxlbSBhdCBhIGxhdGVyIGRhdGUuCgpZ
dXAsIGRvbid0IGNoYW5nZSBpdCBpbiB0aGlzIHBhdGNoIHNlcmllcy4KCkNoZWVycywKCkRhdmUu
Ci0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
