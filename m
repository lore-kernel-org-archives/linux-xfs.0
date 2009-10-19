Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J0r4IE014634 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 19:53:04 -0500
Received: from mail-px0-f195.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10D3F1515C
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 17:54:36 -0700 (PDT)
Received: from mail-px0-f195.google.com (mail-px0-f195.google.com
	[209.85.216.195]) by cuda.sgi.com with ESMTP id
	j6kmn9G01V4jNRkB for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2009 17:54:36 -0700 (PDT)
Received: by pxi33 with SMTP id 33so3047362pxi.20
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 17:54:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD89128.2010206@sandeen.net>
References: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
	<4AD89128.2010206@sandeen.net>
Date: Mon, 19 Oct 2009 08:54:35 +0800
Message-ID: <389deec70910181754xf671441vbb481ea48b63316@mail.gmail.com>
Subject: Re: XFS mount failuer on RAID5
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

MjAwOS8xMC8xNiBFcmljIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+Ogo+IGhhbmsgcGVu
ZyB3cm90ZToKPj4KPj4gSGksIGFsbDoKPj4gSSBoYXZlIGEgc2VsZi1idWlsdCBib2FyZCwgY3B1
IGlzIE1QQzg1NDgoUFBDIGFyY2gpLCBrZXJuZWwgaXMgYmFzZWQKPj4gb24gTVBDODU0OENEUyBk
ZW1vIGJvYXJkLCB2ZXJzaW9uIGlzIDIuNi4yMy4KPj4gQSBTQVRBIGNvbnRyb2xsZXIgaXMgY29u
ZWN0ZWQgdG8gQ1BVIHZpYSBQQ0lYLCBhbmQgSSBoYXZlIDMgZGlza3MKPj4gYXR0YWNoZWQgdG8g
aXQuCj4+Cj4gLi4uCj4KPj4gcm9vdEBTdG9yYWdlOn4jIG1rZnMueGZzIC1mIC1zc2l6ZT00ayAv
ZGV2L3ZnL2x2dGVzdAo+PiBXYXJuaW5nIC0gZGV2aWNlIG1hcHBlciBkZXZpY2UsIGJ1dCBubyBk
bXNldHVwKDgpIGZvdW5kCj4+IFdhcm5pbmcgLSBkZXZpY2UgbWFwcGVyIGRldmljZSwgYnV0IG5v
IGRtc2V0dXAoOCkgZm91bmQKPj4gbWV0YS1kYXRhPS9kZXYvdmcvbHZ0ZXN0IMKgIMKgIMKgIMKg
IGlzaXplPTI1NiDCoCDCoGFnY291bnQ9NCwgYWdzaXplPTY1NTM2MDAKPj4gYmxrcwo+PiDCoCDC
oCDCoCDCoCA9IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNlY3Rzej00MDk2IMKg
YXR0cj0yCj4+IGRhdGEgwqAgwqAgPSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBi
c2l6ZT00MDk2IMKgIGJsb2Nrcz0yNjIxNDQwMCwgaW1heHBjdD0yNQo+PiDCoCDCoCDCoCDCoCA9
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN1bml0PTAgwqAgwqAgwqBzd2lkdGg9
MCBibGtzCj4+IG5hbWluZyDCoCA9dmVyc2lvbiAyIMKgIMKgIMKgIMKgIMKgIMKgIMKgYnNpemU9
NDA5Ngo+PiBsb2cgwqAgwqAgwqA9aW50ZXJuYWwgbG9nIMKgIMKgIMKgIMKgIMKgIGJzaXplPTQw
OTYgwqAgYmxvY2tzPTEyODAwLCB2ZXJzaW9uPTIKPj4gwqAgwqAgwqAgwqAgPSDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzZWN0c3o9NDA5NiDCoHN1bml0PTEgYmxrcywgbGF6eS1j
b3VudD0wCj4+IHJlYWx0aW1lID1ub25lIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGV4dHN6
PTQwOTYgwqAgYmxvY2tzPTAsIHJ0ZXh0ZW50cz0wCj4+IHJvb3RAU3RvcmFnZTp+IyBta2RpciB0
bXAKPj4gcm9vdEBTdG9yYWdlOn4jIG1vdW50IC10IHhmcyAvZGV2L3ZnL2x2dGVzdCAuL3RtcC8K
Pj4gRmlsZXN5c3RlbSAiZG0tMCI6IERpc2FibGluZyBiYXJyaWVycywgbm90IHN1cHBvcnRlZCBi
eSB0aGUgdW5kZXJseWluZwo+PiBkZXZpY2UKPj4gWEZTIG1vdW50aW5nIGZpbGVzeXN0ZW0gZG0t
MAo+PiBYRlM6IHRvdGFsbHkgemVyb2VkIGxvZwo+PiBGaWxlc3lzdGVtICJkbS0wIjogWEZTIGlu
dGVybmFsIGVycm9yIHhsb2dfY2xlYXJfc3RhbGVfYmxvY2tzKDIpIGF0Cj4+IGxpbmUgMTI1MiBv
ZiBmaWxlIGZzL3hmcy94ZnNfbG9nX3JlY292ZXIuYy4gwqBDYWxsZXIgMHhjMDE4ZWM4OAo+Cj4K
PiBDYW4geW91IHRyeSB0aGUgcGF0Y2ggdGhhdCBBbmR5IFBvbGluZyBwb3N0ZWQgdG8gdGhlIGxp
c3QganVzdCB5ZXN0ZXJkYXk/Cj4gwqBTbGlnaHQgbG9uZ3Nob3QgYnV0IGl0IG1heSBiZSBpdC4K
Pgo+IE90aGVyd2lzZSBJIHdpbGwgbG9vayBhdCB0aGlzIGluIGEgYml0OyBvbiB0aGUgcm9hZCB0
b2RheSB0aG91Z2guCj4KUmVhc29uIGlzIGZvdW5kLCBpdCBpcyBiZWNhdXNlIHRoZXJlIGFyZSBz
b21lIHByb2JsZW0gaW4gb3VyIGhhcmR3YXJlClhPUiBkcml2ZXIgZmlybXdhcmUuIEkgYW0gc3Vy
ZSBub3cgaXQgaXMgbm90IHJlbGF0ZWQgd2l0aCBYRlMuClRoeCB0byBhbGwgeW91IGd1eXMsIHdl
IHdpbGwgdHJ5IHRvIGZpeCBpdC4KCj4gLUVyaWMKPgoKCgotLSAKVGhlIHNpbXBsZXN0IGlzIG5v
dCBhbGwgYmVzdCBidXQgdGhlIGJlc3QgaXMgc3VyZWx5IHRoZSBzaW1wbGVzdCEKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
