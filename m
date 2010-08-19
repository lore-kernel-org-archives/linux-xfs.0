Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7J1Y8bx141278 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 20:34:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB02A789C
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 18:34:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	6QwZZqxQFhRK8pDN for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 18:34:37 -0700 (PDT)
Date: Thu, 19 Aug 2010 11:34:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
Message-ID: <20100819013433.GP7362@dastard>
References: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
	<20100818114305.GR10429@dastard>
	<341C002D-C57C-4F73-8B36-5D12B0B91CD5@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <341C002D-C57C-4F73-8B36-5D12B0B91CD5@sandeen.net>
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
Cc: Nohez <nohez@cmie.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gV2VkLCBBdWcgMTgsIDIwMTAgYXQgMDc6NDc6MDlQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIEF1ZyAxOCwgMjAxMCwgYXQgNjo0MyBBTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBm
cm9tb3JiaXQuY29tPiB3cm90ZToKPiAKPiA+IE9uIFR1ZSwgQXVnIDE3LCAyMDEwIGF0IDA3OjEy
OjEyUE0gKzA1MzAsIE5vaGV6IHdyb3RlOgo+ID4+IAo+ID4+IEhpLAo+ID4+IAo+ID4+IEkgaGFk
IGEga2VybmVsIGJ1ZyB0b2RheSB3aGVuIHJ1bm5pbmcgeGZzIG9uIENlbnRPUyB2NS41LiBJIG1v
dmVkIHRvCj4gPj4geGZzIGZyb20gZXh0MyB0b2RheS4KPiA+PiAKPiA+PiBUaGUgb25seSBhcHBs
aWNhdGlvbiBhY2Nlc3NpbmcgdGhlIHhmcyBmaWxlc3lzdGVtIGlzIFN5YmFzZSBBU0UgdjE1Lngu
Cj4gPj4gRGF0YWJhc2UgaGFzIGJlZW4gY29uZmlndXJlZCB0byB1c2UgZGlyZWN0aW8gd2l0aCBu
YXRpdmUga2VybmVsCj4gPj4gYXN5bmNocm9ub3VzIGRpc2sgaS9vIGVuYWJsZWQuCj4gPiAKPiA+
IFRoZSB3YXJuaW5nIGlzIGJlaW5nIGlzc3VlZCBiZWNhdXNlIHRoZSBhcHBsaWNhdGlvbiBpcyBt
aXhpbmcKPiA+IGJ1ZmZlcmVkIElPIHdpdGggZGlyZWN0IElPIG9uIHRoZSBzYW1lIGZpbGUuIGku
ZS4gZGF0YSBjb3JydXB0aW9uCj4gPiB3YWl0aW5nIHRvIGhhcHBlbi4gVGhpcyBpcyBhbiBhcHBs
aWNhdGlvbiBidWcgLSB0aGUgcmVzcG9uc2liaWxpdHkKPiA+IGZvciBlbnN1cmluZyBkYXRhIGNv
aGVyZW5jeSBhbmQgaW50ZWdyaXR5IGlzIGFzc3VtZWQgYnkgdGhlCj4gPiBhcHBsaWNhdGlvbiBp
c3N1aW5nIHRoZSBkaXJlY3QgSU8uCj4gPiAKPiBZb3Uga25vdy4uLiBBIGNsZWFyZXIga2VybmVs
IG1lc3NhZ2UgbWlnaHQgaGVscCBhIGxvdCBoZXJlLi4uCgpZZWFoLCBwcm9iYWJseSB3b3VsZCBn
aXZlbiB3ZSd2ZSBoYWQgbW9yZSByZXBvcnRzIG9mIHRoaXMgaW4gdGhlCmxhc3QgbW9udGggb3Ig
dHdvIHRoYW4gd2UndmUgaGFkIGluIHRoZSBsYXN0IGZpdmUgeWVhcnMuIFdoYXQgc29ydApvZiB0
ZXh0IGRvIHlvdSB0aGluayB3ZSBzaG91bGQgYWRkPyBJJ2QgYXJndWUgb24gdGhlIHNjYXJ5IHNp
ZGUsCnNheToKCiJYRlM6IGZpbGVzeXN0ZW0g4oypYmxhaD46IGRldGVjdGVkIHBvdGVudGlhbCBk
YXRhIGNvcnJ1cHRpb24gaXNzdWUKY2F1c2VkIGJ5IGFwcGxpY2F0aW9uKHMpIG1peGluZyBjb25j
dXJyZW50IGJ1ZmZlcmVkIGFuZCBkaXJlY3QgSU8gdG8KdGhlIHNhbWUgaW5vZGUuIElub2RlICMx
MjM0NSwgcGlkIDY3ODkuIFBsZWFzZSByZXBvcnQgdGhpcyBpc3N1ZQp0byB5b3VyIGFwcGxpY2F0
aW9uIHZlbmRvci4iCgpXaGF0IGRvIHlvdSB0aGluaz8KCkFzIGl0IGlzLCBJIHN1c3BlY3QgdGhh
dCB0aGUgdGVzdCBmb3IgdGhpcyByYWNlIGNvbmRpdGlvbiB3aWxsCm5lZWQgdG8gY2hhbmdlIHNv
bWV3aGF0IHdpdGggcmFuZ2UtYmFzZWQgZmx1c2hpbmcgbm93IHdvcmtpbmcuCkp1c3QgY2hlY2tp
bmcgbWFwcGluZy0+bnJfcGFnZXMgaXMgbm90IHN1ZmZpY2llbnQgYW55bW9yZSwgSSB0aGluay4K
CkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
