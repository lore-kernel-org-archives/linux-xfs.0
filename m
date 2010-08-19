Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7J1cHmN141407 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 20:38:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7691B52D1
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 18:38:47 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id hz3P0DymDODbipll for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 18:38:47 -0700 (PDT)
References: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
	<20100818114305.GR10429@dastard>
	<341C002D-C57C-4F73-8B36-5D12B0B91CD5@sandeen.net>
	<20100819013433.GP7362@dastard>
In-Reply-To: <20100819013433.GP7362@dastard>
Mime-Version: 1.0 (iPhone Mail 8A293)
Message-Id: <040DE437-1D0C-45F1-8CC7-CD11D49B6E53@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
Date: Wed, 18 Aug 2010 20:38:33 -0500
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nohez <nohez@cmie.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gQXVnIDE4LCAyMDEwLCBhdCA4OjM0IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJp
dC5jb20+IHdyb3RlOgoKPiBPbiBXZWQsIEF1ZyAxOCwgMjAxMCBhdCAwNzo0NzowOVBNIC0wNTAw
LCBFcmljIFNhbmRlZW4gd3JvdGU6Cj4+IE9uIEF1ZyAxOCwgMjAxMCwgYXQgNjo0MyBBTSwgRGF2
ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToKPj4gCj4+PiBPbiBUdWUsIEF1
ZyAxNywgMjAxMCBhdCAwNzoxMjoxMlBNICswNTMwLCBOb2hleiB3cm90ZToKPj4+PiAKPj4+PiBI
aSwKPj4+PiAKPj4+PiBJIGhhZCBhIGtlcm5lbCBidWcgdG9kYXkgd2hlbiBydW5uaW5nIHhmcyBv
biBDZW50T1MgdjUuNS4gSSBtb3ZlZCB0bwo+Pj4+IHhmcyBmcm9tIGV4dDMgdG9kYXkuCj4+Pj4g
Cj4+Pj4gVGhlIG9ubHkgYXBwbGljYXRpb24gYWNjZXNzaW5nIHRoZSB4ZnMgZmlsZXN5c3RlbSBp
cyBTeWJhc2UgQVNFIHYxNS54Lgo+Pj4+IERhdGFiYXNlIGhhcyBiZWVuIGNvbmZpZ3VyZWQgdG8g
dXNlIGRpcmVjdGlvIHdpdGggbmF0aXZlIGtlcm5lbAo+Pj4+IGFzeW5jaHJvbm91cyBkaXNrIGkv
byBlbmFibGVkLgo+Pj4gCj4+PiBUaGUgd2FybmluZyBpcyBiZWluZyBpc3N1ZWQgYmVjYXVzZSB0
aGUgYXBwbGljYXRpb24gaXMgbWl4aW5nCj4+PiBidWZmZXJlZCBJTyB3aXRoIGRpcmVjdCBJTyBv
biB0aGUgc2FtZSBmaWxlLiBpLmUuIGRhdGEgY29ycnVwdGlvbgo+Pj4gd2FpdGluZyB0byBoYXBw
ZW4uIFRoaXMgaXMgYW4gYXBwbGljYXRpb24gYnVnIC0gdGhlIHJlc3BvbnNpYmlsaXR5Cj4+PiBm
b3IgZW5zdXJpbmcgZGF0YSBjb2hlcmVuY3kgYW5kIGludGVncml0eSBpcyBhc3N1bWVkIGJ5IHRo
ZQo+Pj4gYXBwbGljYXRpb24gaXNzdWluZyB0aGUgZGlyZWN0IElPLgo+Pj4gCj4+IFlvdSBrbm93
Li4uIEEgY2xlYXJlciBrZXJuZWwgbWVzc2FnZSBtaWdodCBoZWxwIGEgbG90IGhlcmUuLi4KPiAK
PiBZZWFoLCBwcm9iYWJseSB3b3VsZCBnaXZlbiB3ZSd2ZSBoYWQgbW9yZSByZXBvcnRzIG9mIHRo
aXMgaW4gdGhlCj4gbGFzdCBtb250aCBvciB0d28gdGhhbiB3ZSd2ZSBoYWQgaW4gdGhlIGxhc3Qg
Zml2ZSB5ZWFycy4gV2hhdCBzb3J0Cj4gb2YgdGV4dCBkbyB5b3UgdGhpbmsgd2Ugc2hvdWxkIGFk
ZD8gSSdkIGFyZ3VlIG9uIHRoZSBzY2FyeSBzaWRlLAo+IHNheToKPiAKPiAiWEZTOiBmaWxlc3lz
dGVtIOKMqWJsYWg+OiBkZXRlY3RlZCBwb3RlbnRpYWwgZGF0YSBjb3JydXB0aW9uIGlzc3VlCj4g
Y2F1c2VkIGJ5IGFwcGxpY2F0aW9uKHMpIG1peGluZyBjb25jdXJyZW50IGJ1ZmZlcmVkIGFuZCBk
aXJlY3QgSU8gdG8KPiB0aGUgc2FtZSBpbm9kZS4gSW5vZGUgIzEyMzQ1LCBwaWQgNjc4OS4gUGxl
YXNlIHJlcG9ydCB0aGlzIGlzc3VlCj4gdG8geW91ciBhcHBsaWNhdGlvbiB2ZW5kb3IuIgo+IAo+
IFdoYXQgZG8geW91IHRoaW5rPwo+IApQbGVudHkgdmVyYm9zZSwgbWlnaHQgd2FudCB0byBsaW1p
dC90aHJvdHRsZSBpdCwgYnV0IHN1cmUuICBNYXliZSBpbmNsdWRlIGN1cnJlbnQtPmNvbW0/Cgot
RXJpYwoKPiBBcyBpdCBpcywgSSBzdXNwZWN0IHRoYXQgdGhlIHRlc3QgZm9yIHRoaXMgcmFjZSBj
b25kaXRpb24gd2lsbAo+IG5lZWQgdG8gY2hhbmdlIHNvbWV3aGF0IHdpdGggcmFuZ2UtYmFzZWQg
Zmx1c2hpbmcgbm93IHdvcmtpbmcuCj4gSnVzdCBjaGVja2luZyBtYXBwaW5nLT5ucl9wYWdlcyBp
cyBub3Qgc3VmZmljaWVudCBhbnltb3JlLCBJIHRoaW5rLgo+IAo+IENoZWVycywKPiAKPiBEYXZl
Lgo+IC0tIAo+IERhdmUgQ2hpbm5lcgo+IGRhdmlkQGZyb21vcmJpdC5jb20KPiAKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
