Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6EEC829DF8
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 16:43:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 569F5304067
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 14:43:54 -0800 (PST)
Received: from mail-ee0-f44.google.com (mail-ee0-f44.google.com
	[74.125.83.44]) by cuda.sgi.com with ESMTP id TiupPFJMg5pglfyF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Dec 2013 14:43:52 -0800 (PST)
Received: by mail-ee0-f44.google.com with SMTP id b57so1313446eek.17
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 14:43:51 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: XFS blocked task in xlog_cil_force_lsn
Date: Fri, 20 Dec 2013 23:43:47 +0100
References: <52B102FF.8040404@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>
	<52B41B67.9030308@pzystorm.de>
In-Reply-To: <52B41B67.9030308@pzystorm.de>
MIME-Version: 1.0
Message-Id: <201312202343.47895.arekm@maven.pl>
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
To: xfs@oss.sgi.com, xfs@pzystorm.de
Cc: linux-raid@vger.kernel.org, stan@hardwarefreak.com

T24gRnJpZGF5IDIwIG9mIERlY2VtYmVyIDIwMTMsIEtldmluIFJpY2h0ZXIgd3JvdGU6Cgo+ID4+
ICQgY2F0IC9zeXMvYmxvY2svbWQyL21kL3N0cmlwZV9jYWNoZV9zaXplCj4gPj4gMjU2Cj4gPiAK
PiA+IDI1NiBpcyB0aGUgZGVmYXVsdCBhbmQgaXQgaXMgd2F5IHRvbyBsb3cuICBUaGlzIGlzIGxp
bWl0aW5nIHlvdXIgd3JpdGUKPiA+IHRocm91Z3B1dC4gIEluY3JlYXNlIHRoaXMgdG8gYSBtaW5p
bXVtIG9mIDEwMjQgd2hpY2ggd2lsbCBnaXZlIHlvdSBhCj4gPiAyME1CIHN0cmlwZSBjYWNoZSBi
dWZmZXIuICBUaGlzIHNob3VsZCBiZWNvbWUgYWN0aXZlIGltbWVkaWF0ZWx5LiAgQWRkCj4gPiBp
dCB0byBhIHN0YXJ0dXAgc2NyaXB0IHRvIG1ha2UgaXQgcGVybWFuZW50LgoKPiA+ICQgZWNobyAy
NTYgPiAvc3lzL2Jsb2NrL21kMi9tZC9zdHJpcGVfY2FjaGVfc2l6ZQo+ID4gJCB0aW1lIGNwIC1h
IC9vbGRkaXNrL3Rlc3Rmb2xkZXIgLzZ0Yi9mb28xLwo+ID4gcmVhbCAgICAyNW0zOC45MjVzCj4g
PiB1c2VyICAgIDBtMC41OTVzCj4gPiBzeXMgICAgIDFtMjMuMTgycwo+ID4gCj4gPiAkIGVjaG8g
MTAyNCA+IC9zeXMvYmxvY2svbWQyL21kL3N0cmlwZV9jYWNoZV9zaXplCj4gPiAkIHRpbWUgY3Ag
LWEgL29sZGRpc2svdGVzdGZvbGRlciAvcmFpZC9mb28yLwo+ID4gcmVhbCAgICA3bTMyLjgyNHMK
PiA+IHVzZXIgICAgMG0wLjQzOHMKPiA+IHN5cyAgICAgMW02Ljc1OXMKPiA+IAo+ID4gJCBlY2hv
IDIwNDggPiAvc3lzL2Jsb2NrL21kMi9tZC9zdHJpcGVfY2FjaGVfc2l6ZQo+ID4gJCB0aW1lIGNw
IC1hIC9vbGRkaXNrL3Rlc3Rmb2xkZXIgL3JhaWQvZm9vMy8KPiA+IHJlYWwgICAgNW0zMi44NDdz
Cj4gPiB1c2VyICAgIDBtMC40MThzCj4gPiBzeXMgICAgIDFtNS42NzFzCj4gPiAKPiA+ICQgZWNo
byA0MDk2ID4gL3N5cy9ibG9jay9tZDIvbWQvc3RyaXBlX2NhY2hlX3NpemUKPiA+ICQgdGltZSBj
cCAtYSAvb2xkZGlzay90ZXN0Zm9sZGVyIC9yYWlkL2ZvbzQvCj4gPiByZWFsICAgIDVtNTQuNTU0
cwo+ID4gdXNlciAgICAwbTAuNDM3cwo+ID4gc3lzICAgICAxbTYuMjY4cwo+IAo+IFRoZSBkaWZm
ZXJlbmNlIGlzIHJlYWxseSBhbWF6aW5nISBTbyAyMDQ4IHNlZW1zIHRvIGJlIHRoZSBiZXN0IGNo
b2ljZS4KPiA2MEdCIGluIDUsNW1pbnV0ZXMgYXJlIDE4ME1CL3Nlay4gVGhhdCBzb3VuZHMgYSBi
aXQgaGlnaCwgZG9lc250IGl0Pwo+IFRoZSBSQUlEIG9ubHkgY29uc2lzdCBvZiA1IFNBVEEgZGlz
a3Mgd2l0aCA3MjAwcnBtLgoKSSB3b25kZXIgd2h5IGtlcm5lbCBpcyBnaXZpbmcgZGVmYXVsdHMg
dGhhdCBldmVyeW9uZSByZXBlYXRseSByZWNvbW1lbmRzIHRvIApjaGFuZ2UvaW5jcmVhc2U/IEhh
cyBhbnlvbmUgdHJpZWQgdG8gYnVncmVwb3J0IHRoYXQgZm9yIHN0cmlwZV9jYWNoZV9zaXplIApj
YXNlPwoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJla20gLyBtYXZlbi5wbAoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
