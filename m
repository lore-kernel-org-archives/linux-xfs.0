Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98D957CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 10:15:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8869D8F8049
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 08:15:26 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id NpucZho2Y2ANAIUS (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 08:15:20 -0800 (PST)
Date: Mon, 16 Nov 2015 17:15:18 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: memory reclaim problems on fs usage
Message-ID: <20151116161518.GI14116@dhcp22.suse.cz>
References: <201511102313.36685.arekm@maven.pl>
	<201511151229.23312.arekm@maven.pl>
	<201511152313.IJI23764.OHVFJFMSFOtOLQ@I-love.SAKURA.ne.jp>
	<201511151549.35299.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201511151549.35299.arekm@maven.pl>
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
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org, cl@linux.com, htejun@gmail.com, xfs@oss.sgi.com

T24gU3VuIDE1LTExLTE1IDE1OjQ5OjM1LCBBcmthZGl1c3ogTWnFm2tpZXdpY3ogd3JvdGU6Cj4g
T24gU3VuZGF5IDE1IG9mIE5vdmVtYmVyIDIwMTUsIFRldHN1byBIYW5kYSB3cm90ZToKPiA+IEFy
a2FkaXVzeiBNaXNraWV3aWN6IHdyb3RlOgo+ID4gPiBPbiBTdW5kYXkgMTUgb2YgTm92ZW1iZXIg
MjAxNSwgVGV0c3VvIEhhbmRhIHdyb3RlOgo+ID4gPiA+IEkgdGhpbmsgdGhhdCB0aGUgdm1zdGF0
IHN0YXRpc3RpY3Mgbm93IGhhdmUgY29ycmVjdCB2YWx1ZXMuCj4gPiA+ID4gCj4gPiA+ID4gPiBC
dXQgYXJlIHRoZXNlIHBhdGNoZXMgc29sdmluZyB0aGUgcHJvYmxlbSBvciBqdXN0IGhpZGluZyBp
dD8KPiA+ID4gPiAKPiA+ID4gPiBFeGN1c2UgbWUgYnV0IEkgY2FuJ3QganVkZ2UuCj4gPiA+ID4g
Cj4gPiA+ID4gSWYgeW91IGFyZSBpbnRlcmVzdGVkIGluIG1vbml0b3JpbmcgaG93IHZtc3RhdCBz
dGF0aXN0aWNzIGFyZSBjaGFuZ2luZwo+ID4gPiA+IHVuZGVyIHN0YWxsZWQgY29uZGl0aW9uLCB5
b3UgY2FuIHRyeSBiZWxvdyBwYXRjaC4KPiA+ID4gCj4gPiA+IEhlcmUgaXMgbG9nIHdpdGggdGhp
cyBhbmQgYWxsIHByZXZpb3VzIHBhdGNoZXMgYXBwbGllZDoKPiA+ID4gaHR0cDovL2l4aW9uLnBs
ZC1saW51eC5vcmcvfmFyZWttL2xvZy1tbS01LnR4dC5nego+ID4gCj4gPiBSZWdhcmRpbmcgIk5v
ZGUgMCBOb3JtYWwiIChtaW46NzEwNGtCIGxvdzo4ODgwa0IgaGlnaDoxMDY1NmtCKSwKPiA+IGFs
bCBmcmVlOiB2YWx1ZXMgbG9vayBzYW5lIHRvIG1lLiBJIHRoaW5rIHRoYXQgeW91ciBwcm9ibGVt
IHdhcyBzb2x2ZWQuCj4gCj4gR3JlYXQsIHRoYW5rcyEKPiAKPiBXaWxsIGFsbCAob3IgcGFydCkg
b2YgdGhlc2UgcGF0Y2hlcwo+IAo+IGh0dHA6Ly9zcHJ1bmdlLnVzL0dZQmIKCk1pZ3JhdGUgcmVz
ZXJ2ZXMgYXJlIG5vdCBhIHN0YWJsZSBtYXRlcmlhbCBJIGFtIGFmcmFpZC4gInZtc3RhdDoKZXhw
bGljaXRseSBzY2hlZHVsZSBwZXItY3B1IHdvcmsgb24gdGhlIENQVSB3ZSBuZWVkIGl0IHRvIHJ1
biBvbiIKd2FzIG5vdCBtYXJrZWQgZm9yIHN0YWJsZSBlaXRoZXIgYnV0IEkgYW0gbm90IHN1cmUg
d2h5IGl0IHNob3VsZCBtYWtlCmFueSBkaWZmZXJlbmNlIGZvciB5b3VyIGxvYWQuIEkgdW5kZXJz
dGFuZCB0aGF0IHRlc3RpbmcgdGhpcyBpcyByZWFsbHkKdGVkaW91cyBidXQgaXQgd291bGQgYmUg
YmV0dGVyIHRvIGtub3cgd2hpY2ggb2YgdGhlIHBhdGNoZXMgYWN0dWFsbHkKbWFkZSBhIGRpZmZl
cmVuY2UuCgo+IGh0dHA6Ly9zcHJ1bmdlLnVzL1hXVVggKGFmdGVyIGl0IGdldHMgbWVyZ2VkKQoK
WWVzIEkgcGxhbiB0byBtYXJrIHRoaXMgb25lIGZvciBzdGFibGUuCiAKPiBiZSBwdXNoZWQgdG8g
c3RhYmxlQCBvciBhcmUgdG9vIHJpc2t5IGZvciBzdGFibGUgPwo+IAo+ID4gCj4gPiAkIGdyZXAg
Ik5vcm1hbCBmcmVlOiIgbG9nLW1tLTUudHh0IHwgY3V0IC1iIDQ0LSB8IGF3ayAtRicgJyAnIHsg
cHJpbnQgJDQgfQo+ID4gJyB8IGN1dCAtYiA2LSB8IHNvcnQgLWcgODYwOGtCCj4gPiA4NjM2a0IK
PiA+IDg5MjBrQgo+ID4gODkyMGtCCj4gPiA4OTUya0IKPiA+IDg5NjhrQgo+ID4gODk4MGtCCj4g
PiAoLi4uc25pcHBlZC4uLikKPiA+IDIxNTM2NGtCCj4gPiAyOTAwNjhrQgo+ID4gMjkwNDI4a0IK
PiA+IDI5MTE3NmtCCj4gPiAyOTI4MzZrQgo+ID4gMzAzOTkya0IKPiA+IDMwNjQ2OGtCCj4gPiAz
MTgwODBrQgo+ID4gMzE5NTQ4a0IKPiA+IAo+ID4gJCBncmVwICJOb3JtYWwgZnJlZToiIGxvZy1t
bS0xLnR4dCB8IGN1dCAtYiA0NC0gfCBhd2sgLUYnICcgJyB7IHByaW50ICQ0IH0KPiA+ICcgfCBj
dXQgLWIgNi0gfCBzb3J0IC1nIDBrQgo+ID4gNDBrQgo+ID4gMTI4a0IKPiA+IDEyOGtCCj4gPiAx
MjhrQgo+ID4gMTI4a0IKPiA+IDEyOGtCCj4gPiAxMjhrQgo+ID4gMTI4a0IKPiA+IDEyOGtCCj4g
PiAoLi4uc25pcHBlZC4uLikKPiA+IDQxMmtCCj4gPiA2MTZrQgo+ID4gMTI2OGtCCj4gPiAxNTQ0
a0IKPiA+IDE2OTZrQgo+ID4gMjc1NmtCCj4gPiAyNzU2a0IKPiA+IDI3NTZrQgo+ID4gMjc1NmtC
Cj4gPiAyNzU2a0IKPiA+IDI3NTZrQgo+ID4gMjc1NmtCCj4gCj4gCj4gLS0gCj4gQXJrYWRpdXN6
IE1pxZtraWV3aWN6LCBhcmVrbSAvICggbWF2ZW4ucGwgfCBwbGQtbGludXgub3JnICkKCi0tIApN
aWNoYWwgSG9ja28KU1VTRSBMYWJzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3Nz
LnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
