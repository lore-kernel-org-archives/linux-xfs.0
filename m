Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F12729DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 18:40:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0EB3A304032
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 16:40:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5Sd8IfoHQssNvbEj for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 16:40:02 -0700 (PDT)
Date: Wed, 22 May 2013 09:39:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
	file: fs/xfs/xfs_mount.c, line: 272
Message-ID: <20130521233937.GX29466@dastard>
References: <519B6738.9030603@open-e.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519B6738.9030603@open-e.com>
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
To: Arkadiusz =?utf-8?Q?Buba=C5=82a?= <arkadiusz.bubala@open-e.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCBNYXkgMjEsIDIwMTMgYXQgMDI6MjM6MjBQTSArMDIwMCwgQXJrYWRpdXN6IEJ1YmHF
gmEgd3JvdGU6Cj4gSGVsbG8sCj4gSSd2ZSBnb3QgYSBjYWxsIHRyYWNlIHdoaWNoIHNob3VsZCBi
ZSBmaXhlZCBieSAiZHJvcCBidWZmZXIgaW8KPiByZWZlcmVuY2Ugd2hlbiBhIGJhZCBiaW8gaXMg
YnVpbHQiIHBhdGNoCj4gKGh0dHA6Ly9wYXRjaHdvcmsueGZzLm9yZy9wYXRjaC8zOTU2LykuIEVy
cm9yIG9jY3VyZWQgb24gYWxyZWFkeQo+IHBhdGNoZWQgTGludXgga2VybmVsIDMuMi40Mi4KClRo
YXQncyBhbiBvbGQga2VybmVsLiBDYW4geW91IHJlcHJvZHVjZSBvbiBhIGN1cnJlbnQgVE9UIGtl
cm5lbD8KSXQncyBlbnRpcmVseSBwb3NzaWJsZSB0aGF0IHRoaXMgcHJvYmxlbSBoYXMgYmVlbiBm
aXhlZCBhcyB3ZQpkZWZpbml0ZWx5IG1hZSBzb21lIGNoYW5nZXMgdG8gdGhlIG1vdW50IGVycm9y
IGhhbmRsaW5nIHBhdGggc2luY2UKMy4yLi4uLgoKPiAKPiBUZXN0IGVudmlyb25tZW50IGNvbnNp
c3QgdHdvIG1hY2hpbmVzIHRhcmdldCBhbmQgaW5pdGlhdG9yLgo+IEZpcnN0IG1hY2hpbmUgd29y
a3MgYXMgdGFyZ2V0IHdpdGggUUxvZ2ljIENvcnAuIElTUDI0MzItYmFzZWQgNEdiCj4gRmlicmUg
Q2hhbm5lbCBkZXZpY2UuIFN0b3JhZ2UgaXMgcGxhY2VkIG9uIHR3byBLSU5HU1RPTiBTTlY0MjVT
IFNTRAo+IHdvcmtpbmcgYXMgUkFJRDAgYXJyYXkuIFJBSUQgaXMgbWFuYWdlZCBieSBMU0kgTWVn
YVJBSUQgU0FTIDEwNjgKPiBjb250cm9sbGVyLgo+IFNlY29uZCBtYWNoaW5lIHdvcmtzIGFzIGlu
aXRpYXRvciB3aXRoIHRoZSBzYW1lIFFMb2dpYyBjYXJkLgo+IAo+IEFmdGVyIGZldyBkYXlzIG9m
IHJ1bm5pbmcgdGVzdCBzY3JpcHQgSSBnb3QgZm9sbG93aW5nIGNhbGwgdHJhY2UgYW5kCj4gWEZT
IHN0b3BwZWQgd29ya2luZy4KCkNhbiB5b3UgbmFycm93IHRoaXMgZG93biBmcm9tICJ0YWtlcyBz
ZXZlcmFsIGRheXMiIHRvIHRoZSBzaW1wbGVzdApwb3NzaWJsZSByZXByb2R1Y2VyPyBJdCBoYXBw
ZW5lZCBkdWUgdG8gSU8gZXJyb3JzIGR1cmluZyBtb3VudCwgc28KbWF5YmUgeW91IGNhbiBkaWQg
dGhhdCBwYXJ0IG91dCBvZiB5b3VyIHNjcmlwdCBhbmQgZ2l2ZSB1cyBhIHRlc3QKY2FzZSB0aGF0
IHJlcHJvZHVjZXMgb24gdGhlIGZpcnN0IG1vdW50PwoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUg
Q2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
