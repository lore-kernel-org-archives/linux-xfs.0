Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7Q8PffT020203 for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 03:25:41 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C6F91D52E84
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 01:26:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	aDLMgOUuaca5QePU for <xfs@oss.sgi.com>;
	Thu, 26 Aug 2010 01:26:14 -0700 (PDT)
Date: Thu, 26 Aug 2010 18:26:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Validate string -> number conversion.
Message-ID: <20100826082612.GE705@dastard>
References: <1282724556-19456-1-git-send-email-arekm@maven.pl>
	<1282807852-23457-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282807852-23457-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gVGh1LCBBdWcgMjYsIDIwMTAgYXQgMDk6MzA6NTJBTSArMDIwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE1ha2Ugc3VyZSB0aGF0IG51bWJlcnMgcGFzc2VkIGFzIHN0cmluZyB3
aWxsIGZpdCBpbnRvIHByb3Blcgo+IHR5cGVzIHdoZW4gZG9pbmcgc3RyaW5nLT51aWRfdC9naWRf
dC9wcmlkX3QgY29udmVyc2lvbi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBcmthZGl1c3ogTWnFm2tp
ZXdpY3ogPGFyZWttQG1hdmVuLnBsPgoKTG9va3MgZ29vZCwgYnV0IGp1c3QgYSBjb3VwbGUgb2Yg
bWlub3Igc3R5bGUgdGhpbmdzOgoKPiAtLS0KPiAKPiBGaXhlZCB2ZXJzaW9uLgo+IAo+ICBsaWJ4
Y21kL2lucHV0LmMgfCAgIDMzICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQo+ICBx
dW90YS9wcm9qZWN0LmMgfCAgICAyICstCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9u
cygrKSwgMTMgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2xpYnhjbWQvaW5wdXQuYyBi
L2xpYnhjbWQvaW5wdXQuYwo+IGluZGV4IDFiYzA3NDUuLmQwYzRlMGQgMTAwNjQ0Cj4gLS0tIGEv
bGlieGNtZC9pbnB1dC5jCj4gKysrIGIvbGlieGNtZC9pbnB1dC5jCj4gQEAgLTMzNiwxNiArMzM2
LDE5IEBAIHByaWRfZnJvbV9zdHJpbmcoCj4gIAljaGFyCQkqcHJvamVjdCkKPiAgewo+ICAJZnNf
cHJvamVjdF90CSpwcmo7Cj4gLQlwcmlkX3QJCXByaWQ7Cj4gKwl1bnNpZ25lZCBsb25nIGludAlw
cmlkX2xvbmc7Cj4gIAljaGFyCQkqc3A7Cgp1bnNpZ25lZCBsb25nIGlzIGFsbCB0aGF0IGlzIG5l
Y2Vzc2FyeSBoZXJlIC0gdGhhdCB3aWxsIGFsc28ga2VlcAp0aGUgc2FtZSBpbmRlbnQgYXMgd2Vs
bC4KPiAgCj4gIAkvKgo+ICAJICogQWxsb3cgZWl0aGVyIGEgZnVsbCBudW1lcmljIG9yIGEgdmFs
aWQgcHJvamVjdG5hbWUsIGV2ZW4KPiAgCSAqIGlmIGl0IHN0YXJ0cyB3aXRoIGEgZGlnaXQuCj4g
IAkgKi8KPiAtCXByaWQgPSAocHJpZF90KXN0cnRvdWwocHJvamVjdCwgJnNwLCAxMCk7Cj4gLQlp
ZiAoKnByb2plY3QgIT0gJ1wwJyAmJiAqc3AgPT0gJ1wwJykKPiAtCQlyZXR1cm4gcHJpZDsKPiAr
CXByaWRfbG9uZyA9IHN0cnRvdWwocHJvamVjdCwgJnNwLCAxMCk7Cj4gKwlpZiAoKnByb2plY3Qg
IT0gJ1wwJyAmJiAqc3AgPT0gJ1wwJykgewo+ICsJCWlmICgocHJpZF9sb25nID09IFVMT05HX01B
WCAmJiBlcnJubyA9PSBFUkFOR0UpIHx8IChwcmlkX2xvbmcgPiAocHJpZF90KS0xKSkKCkNhbiB5
b3Ugc3BsaXQgdGhpcyB0byBrZWVwIHdpdGhpbiA4MCBjaGFycz8KClNhbWUgZm9yIHRoZSB1aWQg
YW5kIGdpZCBjaGVja3MgYXMgd2VsbC4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIK
ZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
