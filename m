Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 420A97CBF
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 08:49:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 022B6304039
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 06:49:42 -0800 (PST)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
	[209.85.215.47]) by cuda.sgi.com with ESMTP id 8nf6qtjI3ZjnCMEE
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2015 06:49:39 -0800 (PST)
Received: by lfaz4 with SMTP id z4so10822254lfa.0
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 06:49:37 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: memory reclaim problems on fs usage
Date: Sun, 15 Nov 2015 15:49:35 +0100
References: <201511102313.36685.arekm@maven.pl>
	<201511151229.23312.arekm@maven.pl>
	<201511152313.IJI23764.OHVFJFMSFOtOLQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201511152313.IJI23764.OHVFJFMSFOtOLQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Message-Id: <201511151549.35299.arekm@maven.pl>
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
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-mm@kvack.org, cl@linux.com, htejun@gmail.com, mhocko@suse.com, xfs@oss.sgi.com

T24gU3VuZGF5IDE1IG9mIE5vdmVtYmVyIDIwMTUsIFRldHN1byBIYW5kYSB3cm90ZToKPiBBcmth
ZGl1c3ogTWlza2lld2ljeiB3cm90ZToKPiA+IE9uIFN1bmRheSAxNSBvZiBOb3ZlbWJlciAyMDE1
LCBUZXRzdW8gSGFuZGEgd3JvdGU6Cj4gPiA+IEkgdGhpbmsgdGhhdCB0aGUgdm1zdGF0IHN0YXRp
c3RpY3Mgbm93IGhhdmUgY29ycmVjdCB2YWx1ZXMuCj4gPiA+IAo+ID4gPiA+IEJ1dCBhcmUgdGhl
c2UgcGF0Y2hlcyBzb2x2aW5nIHRoZSBwcm9ibGVtIG9yIGp1c3QgaGlkaW5nIGl0Pwo+ID4gPiAK
PiA+ID4gRXhjdXNlIG1lIGJ1dCBJIGNhbid0IGp1ZGdlLgo+ID4gPiAKPiA+ID4gSWYgeW91IGFy
ZSBpbnRlcmVzdGVkIGluIG1vbml0b3JpbmcgaG93IHZtc3RhdCBzdGF0aXN0aWNzIGFyZSBjaGFu
Z2luZwo+ID4gPiB1bmRlciBzdGFsbGVkIGNvbmRpdGlvbiwgeW91IGNhbiB0cnkgYmVsb3cgcGF0
Y2guCj4gPiAKPiA+IEhlcmUgaXMgbG9nIHdpdGggdGhpcyBhbmQgYWxsIHByZXZpb3VzIHBhdGNo
ZXMgYXBwbGllZDoKPiA+IGh0dHA6Ly9peGlvbi5wbGQtbGludXgub3JnL35hcmVrbS9sb2ctbW0t
NS50eHQuZ3oKPiAKPiBSZWdhcmRpbmcgIk5vZGUgMCBOb3JtYWwiIChtaW46NzEwNGtCIGxvdzo4
ODgwa0IgaGlnaDoxMDY1NmtCKSwKPiBhbGwgZnJlZTogdmFsdWVzIGxvb2sgc2FuZSB0byBtZS4g
SSB0aGluayB0aGF0IHlvdXIgcHJvYmxlbSB3YXMgc29sdmVkLgoKR3JlYXQsIHRoYW5rcyEKCldp
bGwgYWxsIChvciBwYXJ0KSBvZiB0aGVzZSBwYXRjaGVzCgpodHRwOi8vc3BydW5nZS51cy9HWUJi
Cmh0dHA6Ly9zcHJ1bmdlLnVzL1hXVVggKGFmdGVyIGl0IGdldHMgbWVyZ2VkKQoKYmUgcHVzaGVk
IHRvIHN0YWJsZUAgb3IgYXJlIHRvbyByaXNreSBmb3Igc3RhYmxlID8KCj4gCj4gJCBncmVwICJO
b3JtYWwgZnJlZToiIGxvZy1tbS01LnR4dCB8IGN1dCAtYiA0NC0gfCBhd2sgLUYnICcgJyB7IHBy
aW50ICQ0IH0KPiAnIHwgY3V0IC1iIDYtIHwgc29ydCAtZyA4NjA4a0IKPiA4NjM2a0IKPiA4OTIw
a0IKPiA4OTIwa0IKPiA4OTUya0IKPiA4OTY4a0IKPiA4OTgwa0IKPiAoLi4uc25pcHBlZC4uLikK
PiAyMTUzNjRrQgo+IDI5MDA2OGtCCj4gMjkwNDI4a0IKPiAyOTExNzZrQgo+IDI5MjgzNmtCCj4g
MzAzOTkya0IKPiAzMDY0NjhrQgo+IDMxODA4MGtCCj4gMzE5NTQ4a0IKPiAKPiAkIGdyZXAgIk5v
cm1hbCBmcmVlOiIgbG9nLW1tLTEudHh0IHwgY3V0IC1iIDQ0LSB8IGF3ayAtRicgJyAnIHsgcHJp
bnQgJDQgfQo+ICcgfCBjdXQgLWIgNi0gfCBzb3J0IC1nIDBrQgo+IDQwa0IKPiAxMjhrQgo+IDEy
OGtCCj4gMTI4a0IKPiAxMjhrQgo+IDEyOGtCCj4gMTI4a0IKPiAxMjhrQgo+IDEyOGtCCj4gKC4u
LnNuaXBwZWQuLi4pCj4gNDEya0IKPiA2MTZrQgo+IDEyNjhrQgo+IDE1NDRrQgo+IDE2OTZrQgo+
IDI3NTZrQgo+IDI3NTZrQgo+IDI3NTZrQgo+IDI3NTZrQgo+IDI3NTZrQgo+IDI3NTZrQgo+IDI3
NTZrQgoKCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFyZWttIC8gKCBtYXZlbi5wbCB8IHBs
ZC1saW51eC5vcmcgKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
