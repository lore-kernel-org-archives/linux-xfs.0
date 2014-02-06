Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DBF37F54
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 07:12:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E62C8F8050
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 05:12:56 -0800 (PST)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
	[209.85.192.173]) by cuda.sgi.com with ESMTP id
	LEQVTFFLRX1JEKEu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 05:12:56 -0800 (PST)
Received: by mail-pd0-f173.google.com with SMTP id y10so1675924pdj.4
	for <xfs@oss.sgi.com>; Thu, 06 Feb 2014 05:12:55 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: add regression test for running snapshot and send
	concurrently
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20140203234212.GW13997@dastard>
Date: Thu, 6 Feb 2014 21:12:51 +0800
Message-Id: <9BC2AB41-F187-4A1A-89D6-743C72446293@gmail.com>
References: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
	<20140203234212.GW13997@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

SGkgRGF2ZSwKCj4gT24gTW9uLCBGZWIgMDMsIDIwMTQgYXQgMTE6MjI6MzZQTSArMDgwMCwgV2Fu
ZyBTaGlsb25nIHdyb3RlOgo+PiBGcm9tOiBXYW5nIFNoaWxvbmcgPHdhbmdzbC5mbnN0QGNuLmZ1
aml0c3UuY29tPgo+PiAKPj4gQnRyZnMgd291bGQgZmFpbCB0byBzZW5kIGlmIHNuYXBzaG90IHJ1
biBjb25jdXJyZW50bHksIHRoaXMgdGVzdCBpcyB0byBtYWtlCj4+IHN1cmUgd2UgaGF2ZSBmaXhl
ZCB0aGUgYnVnLgo+PiAKPiBDb3VwbGUgb2YgY29tbWVudHMgYmVsb3cuCj4gCj4+ICtfc2NyYXRj
aF9ta2ZzID4gL2Rldi9udWxsIDI+JjEKPj4gK19zY3JhdGNoX21vdW50Cj4+ICsKPj4gKwo+PiAr
dG91Y2ggJFNDUkFUQ0hfTU5UL2Zvbwo+PiArCj4+ICsjIGdldCBmaWxlIHdpdGggZnJhZ21lbnRz
IGJ5IHVzaW5nIGJhY2t3YXJkcyB3cml0ZXMuCj4+ICtmb3IgaSBpbiBgc2VxIDEwMjQwIC0xIDFg
OyBkbwo+PiArCSRYRlNfSU9fUFJPRyAtZiAtZCAtYyAicHdyaXRlICQoKCRpICogNDA5NikpIDQw
OTYiIFwKPj4gKwkkU0NSQVRDSF9NTlQvZm9vID4gL2Rldi9udWxsIHwgX2ZpbHRlcl94ZnNfaW8K
PiAKPiBJbmRlbnRhdGlvbi4KPiAKPj4gK2RvbmUKPj4gKwo+PiArJEJUUkZTX1VUSUxfUFJPRyBz
dWJ2b2x1bWUgc25hcHNob3QgLXIgJFNDUkFUQ0hfTU5UIFwKPj4gKwkkU0NSQVRDSF9NTlQvc25h
cF8xID4+ICRzZXFyZXMuZnVsbCAyPiYxCj4+ICsKPj4gKyRCVFJGU19VVElMX1BST0cgc2VuZCAt
ZiAkU0NSQVRDSF9NTlQvc2VuZF9maWxlIFwKPj4gKwkkU0NSQVRDSF9NTlQvc25hcF8xID4+ICRz
ZXFyZXMuZnVsbCAyPiYxICYKPj4gKwo+PiArcGlkPSQhCj4+ICsKPj4gKyRCVFJGU19VVElMX1BS
T0cgc3Vidm9sdW1lIHNuYXBzaG90IC1yICRTQ1JBVENIX01OVC9zbmFwXzEgXAo+PiArCSRTQ1JB
VENIX01OVC9zbmFwXzIgPj4gJHNlcXJlcy5mdWxsIDI+JjEKPj4gKwo+PiArd2FpdCAkcGlkIHx8
IGVjaG8gIkZhaWxlZCB0byBzZW5kLCBzZWUgZG1lc2ciCj4gCj4gVGhpcyBzZWVtcyBraW5kIG9m
IHJhY3kuIEl0IGFzc3VtZXMgdGhhdCB0aGUgc2VuZCBjb21tYW5kCj4gZG9lc24ndCBjb21wbGV0
ZSBiZWZvcmUgdGhlIHdhaXQgJHBpZCBjYWxsIGlzIG1hZGUuIElmICRwaWQgZG9lc24ndAo+IGV4
aXN0IGF0IHRoaXMgdGltZSBiZWNhdXNlIGl0IGhhcyBjb21wbGV0ZWQsIHdhaXQgd2lsbCByZXR1
cm4gMTI3Cj4gYW5kIHRoZSB0ZXN0IHdpbGwgZmFpbKGtLgoKU29ycnkgZm9yIGRlbGF5IHJlcGx5
IQoKTWF5YmUgYSBiZXR0ZXIgaWRlYSBmb3IgdGhpcyB3aWxsIGJlOgoKT3Bwb3NpdGUgdG8gcHJl
dmlvdXMgd2F5LCB3ZSBkbyBzbmFwc2hvdHMgYmFja2dyb3VuZCB3aGlsZSBhdCB0aGUKc2FtZSB0
aW1lIHdlIGRvIHNlbmRpbmcuCgpBbmQgYnRyZnMtcHJvZ3Mgc2hvdWxkIG91dHB1dCBtZWFuaW5n
ZnVsIGluZm9ybWF0aW9uIG9uIHNlbmQgZmFpbHVyZSwgaSB3aWxsCm1ha2UgYSB0aW55IHBhdGNo
IHRvIGFkZHJlc3MgdGhpcyBpc3N1ZS4gYnV0IHRvIG1ha2UgdGhpcyB0ZXN0IG1vcmUgZnJpZW5k
bHksIGkKdGhpbmsgd2UgY2FuIHN0aWxsIGRvIHNvbWV0aGluZyBsaWtlOgoKYnRyZnMgc2VuZCA8
Li4+ICB8fCBlY2hvICJGYWlsZWQgdG8gc2VuZCIKCldoYXQgZG8geW91IHRoaW5rIG9mIHRoaXMg
d2F5PyAgRmVlbCBmcmVlIHRvIHRlbGwgbWUgaWYgdGhlcmUgYXJlIGJldHRlciBpZGVhc15fXi4K
ClRoYW5rcywKV2FuZwo+IEFsc28sIHdoeSB3b3VsZCBhIGZhaWx1cmUgdG8gc2VuZCByZXN1bHQg
aW4gbWVhaW5nZnVsIGluZm9ybWF0aW9uIGluCj4gZG1lc2c/IFNob3VsZG4ndCB0aGUgdXNlcnNw
YWNlIGNvbW1hbmQgb3V0cHV0IGluZm9ybWF0aW9uIHRvIHRlbGwKPiB5b3Ugd2h5IHRoZXJlIHdh
cyBhIGZhaWx1cmUgaW50byAkc2VxcmVzLmZ1bGw/Cj4gCj4gQ2hlZXJzLAo+IAo+IERhdmUuCj4g
LS0gCj4gRGF2ZSBDaGlubmVyCj4gZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
