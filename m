Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A1D27F96
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 08:44:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F25C230407A
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 06:43:58 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	Eet8AHqTr7djaMHF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 06:43:57 -0700 (PDT)
Received: by mail-wi0-f172.google.com with SMTP id hi2so7874469wib.5
	for <xfs@oss.sgi.com>; Tue, 01 Jul 2014 06:43:51 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH 4/4] repair: get rid of BADFSINO
Date: Tue, 1 Jul 2014 15:43:49 +0200
References: <1404219296-29302-1-git-send-email-david@fromorbit.com>
	<1404219296-29302-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1404219296-29302-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Message-Id: <201407011543.49828.arekm@maven.pl>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

T24gVHVlc2RheSAwMSBvZiBKdWx5IDIwMTQsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBGcm9tOiBE
YXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+Cgo+IHNvIGdldCByaWQgb2YgQkFERlNJ
Tk8gYW5kIG9ubHkgdXNlIHRoZSBuYW1lIGp1bmtpbmcgdG8gbWFyawo+IGRpcmVudHMgYXMgYmFk
LiBUaGlzIHByZXZlbnRzIHRoZSBkaXJlY3RvcnkgZGF0YSBibG9jayB2ZXJpZmllciBmcm9tCj4g
dHJpZ2dlcmluZyBvbiBiYWQgaW5vZGUgbnVtYmVycywgYW5kIHNvIHRoZSBsYXRlciByZXJlYWQg
b2YgdGhlCj4gYmxvY2sgd2lsbCBmaW5kIHRoZSBqdW5rZWQgZW50cmllcyBjb3JyZWN0bHkuCj4g
Cj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IC0t
LQo+ICByZXBhaXIvZGlyMi5jIHwgMTggKysrKystLS0tLS0tLS0tLS0tCj4gIDEgZmlsZSBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQoKCj4gQEAgLTE0MjcsMTEgKzE0
MTksMTEgQEAgXygiZW50cnkgYXQgYmxvY2sgJXUgb2Zmc2V0ICUiIFBSSWRQVFIgIiBpbgo+IGRp
cmVjdG9yeSBpbm9kZSAlIiBQUkl1NjQgIiBoYXMgaWxsZSAvKgo+ICAJCSAqIE5vdyB3ZSBjYW4g
bWFyayBlbnRyaWVzIHdpdGggQkFERlNJTk8ncyBiYWQuCj4gIAkJICovCgpDb21tZW50IGFib3Zl
IG5lZWRzIHVwZGF0ZS4KCj4gLQkJaWYgKCFub19tb2RpZnkgJiYgZW50X2lubyA9PSBCQURGU0lO
Tykgewo+IC0JCQlkZXAtPm5hbWVbMF0gPSAnLyc7Cj4gKwkJaWYgKCFub19tb2RpZnkgJiYgZGVw
LT5uYW1lWzBdID09ICcvJykgewo+ICAJCQkqZGlydHkgPSAxOwo+ICAJCQlqdW5raXQgPSAwOwo+
ICAJCX0KPiArCj4gIAkJLyoKPiAgCQkgKiBTcGVjaWFsIC4uIGVudHJ5IHByb2Nlc3NpbmcuCj4g
IAkJICovCgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJla20gLyBtYXZlbi5wbAoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
