Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALFSPPU006559
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 09:28:25 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EF2657098A
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:28:24 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	WpGU89n9qHiG3tf1 for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 07:28:24 -0800 (PST)
Received: by iaen33 with SMTP id n33so8722095iae.26
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:28:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111121162155.0bfa0342@harpe.intellique.com>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121150158.5f8b2512@harpe.intellique.com>
	<CAJNJY8SoNvqQB0WNJq5SVUhkLSJROoMkVEkOHrESVR0iMB4JDA@mail.gmail.com>
	<20111121162155.0bfa0342@harpe.intellique.com>
Date: Mon, 21 Nov 2011 23:28:23 +0800
Message-ID: <CAJNJY8QciPX_MPsgPo3SfSuheFHGSZVsiL=ibNf1S3spyKFAig@mail.gmail.com>
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

MjAxMS8xMS8yMSBFbW1hbnVlbCBGbG9yYWMgPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+Ogo+IExl
IE1vbiwgMjEgTm92IDIwMTEgMjM6MDI6MzIgKzA4MDAKPiBoYW5rIHBlbmcgPHBlbmd4aWhhbkBn
bWFpbC5jb20+IMOpY3JpdmFpdDoKPgo+PiBubywgY2xpZW50IGFuZCBzZXJ2ZXIgYXJlIGJvdGgg
MzIgYml0cyBrZXJuZWwuCj4+Cj4KPiBJJ20gYWZyYWlkIHRoZSAzMiBiaXRzIG5mcyBjbGllbnQg
Y2FuJ3QgbWFuYWdlIDY0IGJpdHMgaW5vZGVzIGF0IGFsbC4KPiBNYXliZSB3aXRoIGEgbXVjaCBt
b3JlIHJlY2VudCBrZXJuZWwsIHNvbWV0aGluZyBsaWtlIDIuNi4yOSBvciBiZXR0ZXI/Cj4KCkkg
bm90aWNlZCB0aGF0IHRoZXJlIGlzIGEga2VybmVsIHBhcmFtZXRlciA6Cm5mcy5lbmFibGVfaW5v
NjQ9CgkJCVtORlNdIGVuYWJsZSA2NC1iaXQgaW5vZGUgbnVtYmVycy4KCQkJSWYgemVybywgdGhl
IE5GUyBjbGllbnQgd2lsbCBmYWtlIHVwIGEgMzItYml0IGlub2RlCgkJCW51bWJlciBmb3IgdGhl
IHJlYWRkaXIoKSBhbmQgc3RhdCgpIHN5c2NhbGxzIGluc3RlYWQKCQkJb2YgcmV0dXJuaW5nIHRo
ZSBmdWxsIDY0LWJpdCBudW1iZXIuCgkJCVRoZSBkZWZhdWx0IGlzIHRvIHJldHVybiA2NC1iaXQg
aW5vZGUgbnVtYmVycy4KCmNhbiBJIHNldCBpdCB0byB6ZXJvLCBzbyBORlMgY2xpZW50IGNhbiBn
ZXQgY29udmVydGVkIDMyYml0IGlub2RlID8KCj4gU2VlIGZvciBpbnN0YW5jZQo+IGh0dHA6Ly9v
c3Muc2dpLmNvbS9hcmNoaXZlcy94ZnMvMjAwOS0xMS9tc2cwMDE3NC5odG1sCj4KPiBZb3VyIGJl
c3QgY2hvaWNlIGlzIHRvIHJldmVydCB0byBub3QgdXNpbmcgdGhlICJpbm9kZTY0IiBvcHRpb24u
Cj4gVW5mb3J0dW5hdGVseSB0aGUgZWFzaWVzdCB3YXkgaXMgdG8gYmFja3VwIGFuZCByZXN0b3Jl
IHRoZSB3aG9sZQo+IGZpbGVzeXN0ZW0uCj4KPiBBbHRlcm5hdGl2ZWx5LCBzd2l0Y2ggdG8gc2Ft
YmEuLi4KPgo+IC0tCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gRW1tYW51ZWwgRmxvcmFjIMKgIMKgIHwg
wqAgRGlyZWN0aW9uIHRlY2huaXF1ZQo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfCDC
oCBJbnRlbGxpcXVlCj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8IMKgIDxlZmxvcmFj
QGludGVsbGlxdWUuY29tPgo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfCDCoCArMzMg
MSA3OCA5NCA4NCAwMgo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+CgoKCi0tIApUaGUgc2ltcGxlc3QgaXMg
bm90IGFsbCBiZXN0IGJ1dCB0aGUgYmVzdCBpcyBzdXJlbHkgdGhlIHNpbXBsZXN0IQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
