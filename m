Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0FMEjTZ032506 for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 16:14:45 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC93D1B372B0
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 14:14:43 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id Q4Y95LKFTSLDFdUc
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 14:14:43 -0800 (PST)
Date: Fri, 16 Jan 2009 09:14:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs regression in linux_2.6.28, "XFS_WANT_CORRUPTED_GOTO at
	line 3327 of file fs/xfs/xfs_btree.c"
Message-ID: <20090115221438.GF8071@disturbed>
References: <200901150402.39801.edvx1@systemanalysen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200901150402.39801.edvx1@systemanalysen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

T24gVGh1LCBKYW4gMTUsIDIwMDkgYXQgMDQ6MDI6MzlBTSArMDEwMCwgUm9sYW5kIEVnZ25lciB3
cm90ZToKPiBMYXRlc3QgKHNvIGZhcikgd29ya2luZyBsaW51eF8yLjYuMjcuOQo+IGxpbnV4XzIu
Ni4yOCBzZWVtcyB0byBpbnRyb2R1Y2UgYSB4ZnMgcmVncmVzc2lvbjoKCllvdSBtZWFuIDIuNi4y
OSwgZG9uJ3QgeW91IChpLmUuIGEgY3VycmVudCBUT1QgZGV2ZWxvcG1lbnQga2VybmVsLApub3Qg
YSBzdGFibGUga2VybmVsKT8KCj4gJCAgZWdyZXAgLWkgJyhMaW51eHxnY2MpIHZlcnNpb258Y29y
cnVwdGVkJyAvdmFyL2xvZy9tZXNzYWdlcwo+IEphbiAxMCAxNDoyNzoyOSByb2xhbmQga2VybmVs
OiBMaW51eCB2ZXJzaW9uIDIuNi4yOC5yb2xhbmQuMSAocm9sYW5kQHJvbGFuZCkgKGdjYyB2ZXJz
aW9uIDQuMi4zIChEZWJpYW4gNC4yLjMtMykpICMzIEZyaSBKYW4gOSAxNjo1MToyMSBDRVQgMjAw
OQo+IEphbiAxMSAwMjowMDoxNCByb2xhbmQga2VybmVsOiBMaW51eCB2ZXJzaW9uIDIuNi4yOC1n
aXQ3LnJvbGFuZC4wIChyb2xhbmRAcm9sYW5kKSAoZ2NjIHZlcnNpb24gNC4yLjMgKERlYmlhbiA0
LjIuMy0zKSkgIzEgU3VuIEphbiAxMSAwMToyOToxNCBDRVQgMjAwOQo+IEphbiAxMSAwMjozNjo1
NiByb2xhbmQga2VybmVsOiBYRlMgaW50ZXJuYWwgZXJyb3IgWEZTX1dBTlRfQ09SUlVQVEVEX0dP
VE8gYXQgbGluZSAzMzI3IG9mIGZpbGUgZnMveGZzL3hmc19idHJlZS5jLiAgQ2FsbGVyIDB4YzAy
NDg4YmMKCldlIGhhdmUgcmVjZWl2ZWQgYSBmZXcgcmVwb3J0cyBvZiB0aGF0IHNpbmNlIDIuNi4y
OS1naXQyIGFmdGVyIHRoZQpiaWcgWEZTIG1lcmdlIG9jY3VycmVkLiBDYW4geW91IGNvbmZpcm0g
dGhhdCB5b3UgYXJlIHJ1bm5pbmcgYSB2ZXJ5CnJlY2VudCB1bnN0YWJsZSBrZXJuZWwgYW5kIG5v
dCBhIHN0YWJsZSAyLjYuMjgga2VybmVsPwoKQlRXLCBJIG5vdGUgeW91ciBrZXJuZWwgaXMgdGFp
bnRlZCAobGlrZSBhIGNvdXBsZSBvZiBvdGhlcgpyZXBvcnRzIG9mIHRoaXMgcHJvYmxlbSkuIENh
biB5b3UgdGVsbCB1cyB3aGF0IG1vZHVsZSB5b3XugIBhcmUKcnVubmluZyB0aGF0IHRhaW50cyB0
aGUga2VybmVsIHNvIHdlIGNhbiBjb3JyZWxhdGUgdGhhdCB3aXRoCm90aGVyIHJlcG9ydHMgb2Yg
dGhlIHByb2JsZW0/CgpBcyBpdCBpcywgSSdtIHRyeWluZyB0byB0cmFjayBkb3duIHRoZSBidWcg
dGhhdCBpbnRyb2R1Y2VkIHRoZQpyZWdyZXNzaW9uLiBIb3dldmVyLCB0aGUgYnVnIGlzIG5vdCBv
YnZpb3VzIGZyb20gcmV2aWV3aW5nIHRoZQpjaGFuZ2UgaXQgaGFzIGJlZW4gYmlzZWN0ZWQgZG93
biB0bywgbm9yIGhhdmUgSSBiZWVuIGFibGUgdG8KcmVwcm9kdWNlIGl0IGxvY2FsbHkuCgpUaGlz
IG9uZSBtaWdodCB0YWtlIGEgbGl0dGxlIHdoaWxlIHRvIGZpbmQsIHNvIHBsZWFzZSBiZSBwYXRp
ZW50CmFuZCB3YXRjaCB0aGUgbGlzdCBmb3IgdXBkYXRlcy4KCkNoZWVycywKCkRhdmUuCi0tIApE
YXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20K
aHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
