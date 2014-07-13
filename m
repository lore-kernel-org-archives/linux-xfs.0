Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C4477F50
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 18:04:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 838518F8050
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 16:04:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5zAGA4A7Hy44AViq for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 16:04:09 -0700 (PDT)
Date: Mon, 14 Jul 2014 09:04:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Init errno before strto* calls.
Message-ID: <20140713230406.GE22339@dastard>
References: <1405107244-14234-1-git-send-email-arekm@maven.pl>
	<1405273088-7956-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405273088-7956-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gU3VuLCBKdWwgMTMsIDIwMTQgYXQgMDc6Mzg6MDhQTSArMDIwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IEVyaWMgU2FuZGVlbiBub3RlZCB0aGF0IHN0cnRvbCgzKSBhbmQgZnJp
ZW5kcyByZXF1aXJlIGVycm5vCj4gaW5pdGlhbGl6YXRpb24uIEZyb20gKGZyZXNoKSBtYW4gcGFn
ZToKPiAKPiBOT1RFUwo+ICAgICAgICBTaW5jZSAgc3RydG9sKCkgIGNhbiAgbGVnaXRpbWF0ZWx5
ICByZXR1cm4gIDAsICBMT05HX01BWCwKPiAgICAgICAgb3IgTE9OR19NSU4gKExMT05HX01BWCBv
ciBMTE9OR19NSU4gZm9yIHN0cnRvbGwoKSkgb24gYm90aAo+ICAgICAgICBzdWNjZXNzIGFuZCBm
YWlsdXJlLCB0aGUgY2FsbGluZyAgcHJvZ3JhbSBzaG91bGQgc2V0IGVycm5vCj4gICAgICAgIHRv
IDAgYmVmb3JlIHRoZSBjYWxsLCBhbmQgdGhlbiBkZXRlcm1pbmUgaWYgYW4gZXJyb3IKPiAgICAg
ICAgb2NjdXJyZWQgYnkgY2hlY2tpbmcgIHdoZXRoZXIgIGVycm5vICBoYXMgIGEgbm9uLXplcm8K
PiAgICAgICAgdmFsdWUgYWZ0ZXIgdGhlIGNhbGwuCj4gCj4gU28gZG8gaXQuCj4gLS0tCj4gIGxp
YnhjbWQvaW5wdXQuYyB8IDUgKysrKysKPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KQo+IAo+IGRpZmYgLS1naXQgYS9saWJ4Y21kL2lucHV0LmMgYi9saWJ4Y21kL2lucHV0LmMKPiBp
bmRleCAzOTdhMTI0Li43MTFiNTI3IDEwMDY0NAo+IC0tLSBhL2xpYnhjbWQvaW5wdXQuYwo+ICsr
KyBiL2xpYnhjbWQvaW5wdXQuYwo+IEBAIC0xNTMsNiArMTUzLDcgQEAgY3Z0bnVtKAo+ICAJY2hh
cgkJKnNwOwo+ICAJaW50CQljOwo+ICAKPiArCWVycm5vID0gMDsKPiAgCWkgPSBzdHJ0b2xsKHMs
ICZzcCwgMCk7Cj4gIAlpZiAoKGkgPT0gTExPTkdfTUlOIHx8IGkgPT0gTExPTkdfTUFYKSAmJiBl
cnJubyA9PSBFUkFOR0UpCj4gIAkJcmV0dXJuIC0xTEw7CgpJIHRoaW5rIHRoYXQganVzdCBjaGVj
a2luZyBmb3IgKGVycm5vICE9IDApIGlzIGJldHRlciBoZXJlLCBiZWNhdXNlCnRoZW4gd2UgYWxz
byBjYXRjaCBlcnJvcnMgZnJvbSB1bnN1cHBvcnRlZCBmb3JtYXRzIG9yIGludmFsaWQKc3RyaW5n
cyAoaS5lLiBFSU5WQUwpLgoKaS5lLiBpZiB0aGUgcmVzdWx0IGlzIG91dCBvZiByYW5nZSwgdGhl
biBFUkFOR0UgaXMgYWx3YXlzIHJldHVybmVkLApzbyB3ZSBkb24ndCBuZWVkIHRvIGNoZWNrIHRo
ZSBhY3R1YWwgdmFsdWUgYXQgYWxsLi4uCgpCb3RoIHBhdGNoZXMgY291bGQgYmUgY29uZGVuc2Vk
IGRvd24gdG8gYSBzaW5nbGUgcGF0Y2ggdGhhdCBkb2VzOgoKKwllcnJubyA9IDA7CiAJaSA9IHN0
cnRvbGwocywgJnNwLCAwKTsKKwlpZiAoZXJybm8pCisJCXJldHVybiAtMUxMOwoKQ2hlZXJzLAoK
RGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
