Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM7EG17125060
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 01:14:16 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E55AC12796D9
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 23:14:15 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	qVtTQt3f2Sum1ZCf for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 23:14:15 -0800 (PST)
Received: by ggnr1 with SMTP id r1so22184ggn.26
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 23:14:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111121164309.4b18a6ca@harpe.intellique.com>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121150158.5f8b2512@harpe.intellique.com>
	<CAJNJY8SoNvqQB0WNJq5SVUhkLSJROoMkVEkOHrESVR0iMB4JDA@mail.gmail.com>
	<20111121162155.0bfa0342@harpe.intellique.com>
	<CAJNJY8QciPX_MPsgPo3SfSuheFHGSZVsiL=ibNf1S3spyKFAig@mail.gmail.com>
	<20111121164309.4b18a6ca@harpe.intellique.com>
Date: Tue, 22 Nov 2011 15:14:14 +0800
Message-ID: <CAJNJY8R7yScE0-uCsidfRxV6g5V4E9h_6P4Qp=Q3AA4YtA40=A@mail.gmail.com>
Subject: Re: stale NFS file handle problem on XFS inode64
From: hank peng <pengxihan@gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@oss.sgi.com

dW5mb3J0dW5hdGVseSwgc2V0aW5nIG5mcy5lbmFibGVfaW5vNjQgZGlkbid0IHdvcmsgYWx0aG91
Z2ggaXQgZ2F2ZSBtZQozMiBiaXQgaW5vZGUgbnVtYmVyIGluZGVlZCwgSSB0aGluayB0aGVyZSBt
dXN0IGJlIHNvbWV0aGluZyBlbHNlCndyb25nLgoKCjIwMTEvMTEvMjEgRW1tYW51ZWwgRmxvcmFj
IDxlZmxvcmFjQGludGVsbGlxdWUuY29tPjoKPiBMZSBNb24sIDIxIE5vdiAyMDExIDIzOjI4OjIz
ICswODAwCj4gaGFuayBwZW5nIDxwZW5neGloYW5AZ21haWwuY29tPiDDqWNyaXZhaXQ6Cj4KPj4g
SSBub3RpY2VkIHRoYXQgdGhlcmUgaXMgYSBrZXJuZWwgcGFyYW1ldGVyIDoKPj4gbmZzLmVuYWJs
ZV9pbm82ND0KPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgW05GU10gZW5hYmxl
IDY0LWJpdCBpbm9kZSBudW1iZXJzLgo+PiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBJZiB6ZXJvLCB0aGUgTkZTIGNsaWVudCB3aWxsIGZha2UgdXAgYSAzMi1iaXQKPj4gaW5vZGUg
bnVtYmVyIGZvciB0aGUgcmVhZGRpcigpIGFuZCBzdGF0KCkgc3lzY2FsbHMgaW5zdGVhZAo+PiDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBvZiByZXR1cm5pbmcgdGhlIGZ1bGwgNjQt
Yml0IG51bWJlci4KPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgVGhlIGRlZmF1
bHQgaXMgdG8gcmV0dXJuIDY0LWJpdCBpbm9kZSBudW1iZXJzLgo+Pgo+PiBjYW4gSSBzZXQgaXQg
dG8gemVybywgc28gTkZTIGNsaWVudCBjYW4gZ2V0IGNvbnZlcnRlZCAzMmJpdCBpbm9kZSA/Cj4K
PiBXZWxsIHlvdSBtdXN0IHRyeSBpdCBhbmQgaG9wZSBmb3IgdGhlIGJlc3QhCj4KPiAtLQo+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQo+IEVtbWFudWVsIEZsb3JhYyDCoCDCoCB8IMKgIERpcmVjdGlvbiB0ZWNo
bmlxdWUKPiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHwgwqAgSW50ZWxsaXF1ZQo+IMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfCDCoCA8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4K
PiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHwgwqAgKzMzIDEgNzggOTQgODQgMDIKPiAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KPgoKCgotLSAKVGhlIHNpbXBsZXN0IGlzIG5vdCBhbGwgYmVzdCBidXQg
dGhlIGJlc3QgaXMgc3VyZWx5IHRoZSBzaW1wbGVzdCEKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
