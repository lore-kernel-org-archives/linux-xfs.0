Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6F0D7F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 05:15:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 711F5AC004
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 03:15:37 -0800 (PST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id N6idxYkl7x52mhFd
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 03:15:32 -0800 (PST)
Received: by mail-wm0-f45.google.com with SMTP id p66so104644027wmp.1
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 03:15:32 -0800 (PST)
Received: from xps.localnet ([91.234.176.246])
	by smtp.gmail.com with ESMTPSA id
	r74sm20617344wmb.2.2015.12.15.03.15.28 for <xfs@oss.sgi.com>
	(version=TLSv1/SSLv3 cipher=OTHER);
	Tue, 15 Dec 2015 03:15:29 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH 1/2] metadump: bounds check btree block regions being
	zeroed
Date: Tue, 15 Dec 2015 12:15:27 +0100
References: <1450054866-32720-1-git-send-email-david@fromorbit.com>
	<1450054866-32720-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1450054866-32720-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Message-Id: <201512151215.27980.arekm@maven.pl>
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

T24gTW9uZGF5IDE0IG9mIERlY2VtYmVyIDIwMTUsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBGcm9t
OiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+Cj4gCj4gQXJrYWRpdXN6IE1pc2tp
ZXdpY3ogcmVwb3J0ZWQgdGhhdCBtZXRhZHVtcCB3YXMgY3Jhc2hpbmcgb24gb25lIG9mCj4gaGlz
IGNvcnJ1cHRlZCBmaWxlc3lzdGVtcywgYW5kIHRoZSB0cmFjZSBpbmRpY2F0ZWQgdGhhdCBpdCB3
YXMKPiB6ZXJvaW5nIHVudXNlZCByZWdpb25zIGluIGlub2RlIGJ0cmVlIGJsb2NrcyB3aGVuIGl0
IGZhaWxlZC4gVGhlCj4gYnRyZWUgYmxvY2sgaGFkIGEgY29ycnVwdCBucmVjcyBmaWVsZCwgd2hp
Y2ggd2FzIHJlc3VsdGluZyBpbiBhbiBvdXQKPiBvZiBib3VuZHMgbWVtc2V0KCkgb2NjdXJyaW5n
Lgo+IAo+IEVuc3VyZSB0aGF0IHRoZSByZWdpb24gYmVpbmcgZ2VuZXJhdGVkIGZvciB6ZXJvaW5n
IGlzIHdpdGhpbiBib3VuZHMKPiBiZWZvcmUgZXhlY3V0aW5nIHRoZSB6ZXJvaW5nLiBXaGlsZSB0
aGVyZSwgYWJzdHJhY3QgdGhlIHJlcGVhdGVkCj4gYm9pbGVyIHBsYXRlIGNvZGUgc28gdGhhdCBp
dCBpcyBzaW1wbGVyIHRvIG1haW50YWluIGFuZCBleHRlbmQgdGhlCj4gemVyb2luZyBjb2RlIHRv
IG5ldyB0eXBlcyBvZiBidHJlZXMgaW4gZnV0dXJlLgo+IAo+IFJlcG9ydGVkLWJ5OiBBcmthZGl1
c3ogTWlza2lld2ljeiA8YXJla21AbWF2ZW4ucGw+CgouLi4gYW5kIFRlc3RlZC1ieTogQXJrYWRp
dXN6IE1pc2tpZXdpY3ogPGFyZWttQG1hdmVuLnBsPgoKQnkgdGhhdCBJIG1lYW4gdGhhdCBpdCBk
aWQgZHVtcCBteSBicm9rZW4gZnMgd2l0aG91dCBzZWdmYXVsdGluZyAodXNpbmcgLWcgCm9wdGlv
biBvbmx5KS4KCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFyZWttIC8gKCBtYXZlbi5wbCB8
IHBsZC1saW51eC5vcmcgKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
