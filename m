Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1FrRx096300 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:15:53 -0600
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 66D892F7EC3
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:18:37 -0800 (PST)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id PnHbPfh0jTzDO6pn
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:18:37 -0800 (PST)
Message-ID: <4D65B1EA.4060801@draigBrady.com>
Date: Thu, 24 Feb 2011 01:18:34 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: write 'O_DIRECT' file w/odd amount of data: desirable result?
References: <4D648D7D.7040500@tlinx.org> <4D64E2BB.7010000@draigBrady.com>
	<4D654C2E.2000703@tlinx.org>
In-Reply-To: <4D654C2E.2000703@tlinx.org>
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
To: "Linda A. Walsh" <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

T24gMjMvMDIvMTEgMTg6MDQsIExpbmRhIEEuIFdhbHNoIHdyb3RlOgo+IEkgdHJpZWQgdXNpbmcg
dGhlICdpZmxhZz1mdWxsYmxvY2snIGFzIHlvdSByZWNvbW1lbmQgYW5kIGl0IG1hZGUgdGhlCj4g
cHJvYmxlbQo+ICdjb25zaXN0ZW50JyB3aXRoIHRoZSBvdXRwdXQgb2YgJ21idWZmZXInLCBpLmUu
IGl0IHRyYW5zZmVyZWQgbGVzcyBkYXRhCj4gYW5kIHRoZSB0cnVuY2F0aW9uIHdhcyBjb25zaXN0
ZW50IHdpdGggYSA1MTJNIGRpdmlzb3IsIGluZGljYXRpbmcgaXQgd2FzCj4gJ2NhdCcgZGVmYXVs
dCByZWNvcmQgb3V0cHV0IHNpemUgdGhhdCB3YXMgY2F1c2luZyB0aGUgZGlmZmVyZW5jZS4KClJp
Z2h0LiBUaGF0J3MgZXhwZWN0ZWQgYXMgd2l0aCAnZnVsbGJsb2NrJywgYm90aCBtYnVmZmVyIGFu
ZCBkZAp3aWxsIHJlYWQvd3JpdGUgNTEyTSBhdCBhIHRpbWUuIEJvdGggd2lsbCBmYWlsIGluIHRo
ZSBzYW1lCndheSB3aGVuIHRoZXkgdHJ5IHRvIHdyaXRlIHRoZSBvZGQgc2l6ZWQgY2h1bmsgYXQg
dGhlIGVuZC4KVGhpcyB3YXMgb25seSBjaGFuZ2VkIGZvciBkZCBpbiB2ZXJzaW9uIGNvcmV1dGls
cyA3LjUKKHdoZXJlIGl0IHJldmVydHMgdG8gYSBzdGFuZGFyZCB3cml0ZSBmb3IgdGhlIGxhc3Qg
Y2h1bmspCgo+IEkndmUgdHJpZWQgc2lnbmlmaWNhbnRseSBzaG9ydGVyIGZpbGVzIGFuZCBOT1Qg
aGFkIHRoaXMgcHJvYmxlbQo+IChyZWNvcmQgc2l6ZT02NGssIGFuZCAyIGZpbGVzIG9uZWF0IDY0
KzU3aykuIEJvdGggY29waWVkCj4gZmluZS4KPiBTb21ldGhpbmcgdG8gZG8gd2l0aCBsYXJnZSBm
aWxlIGJ1ZmZlcnMuCgpTbWFsbCBibG9ja3MgY2F1c2UgYW4gaXNzdWUgb24gZXh0WzM0XSBhdCBs
ZWFzdC4KSSBtb2RpZmllZCBkZCBoZXJlIHRvIGJlaGF2ZSBsaWtlIHlvdXJzIGFuZCBnb3Q6CiQg
dHJ1bmNhdGUgLXM1MTMgc21hbGwKJCBkZCBvZmxhZz1kaXJlY3QgaWY9c21hbGwgb2Y9c21hbGwu
b3V0Ci4vZGQ6IHdyaXRpbmcgYHNtYWxsLm91dCc6IEludmFsaWQgYXJndW1lbnQKCj4gT2YgKlNJ
R05JRklDQU5UKiBub3RlLiAgSW4gdHJ5aW5nIHRvIGNyZWF0ZSBhbiBlbXB0eSBmaWxlIG9mIHRo
ZSBzaXplCj4gdXNlZCwgZnJvbSBzY3JhdGNoLCB1c2luZyAneGZzX21rZmlsZScsIEkgZ290IGFu
IGVycm9yOgo+IAo+PiAgeGZzX21rZmlsZSA1Nzc2NDE5Njk2IHRlc3RmaWxlCj4gcHdyaXRlNjQ6
IEludmFsaWQgYXJndW1lbnQKCkxvb2tzIGxpa2UgdGhhdCB1c2VzIHRoZSBzYW1lIE9fRElSRUNU
IHdyaXRlCm1ldGhvZCB3aXRoIHRoZSBzYW1lIGlzc3Vlcz8KWW91IGNvdWxkIHRyeSBmYWxsb2Nh
dGUoMSkgd2hpY2ggaXMgbmV3bHkgYXZhaWxhYmxlCmluIHV0aWwtbGludXggYW5kIG1pZ2h0IGJl
IHN1cHBvcnRlZCBieSB5b3VyIHhmcy4KCmNoZWVycywKUMOhZHJhaWcuCgpwLnMuIGRkIHdvdWxk
IGlmIHdyaXR0ZW4gdG9kYXkgZGVmYXVsdCB0byB1c2luZyBmdWxsYmxvY2suCkZvciBiYWNrd2Fy
ZHMgYW5kIFBPU0lYIGNvbXBhdCB0aG91Z2ggd2UgbXVzdCBrZWVwCnRoZSBjdXJyZW50IGRlZmF1
bHQgYmVoYXZpb3IKCnAucC5zLiBUaGVyZSBhcmUgc2l0dWF0aW9ucyB3ZXJlIGZ1bGxibG9jayBp
cyByZXF1aXJlZCwKYW5kIEknbGwgcGF0Y2ggZGQgc29vbiB0byBhdXRvIGFwcGx5IHRoYXQgb3B0
aW9uIHdoZW4gYXBwcm9wcmlhdGUuCltpb11mbGFnPWRpcmVjdCBpcyBvbmUgb2YgdGhvc2UgY2Fz
ZXMgSSB0aGluay4KCnAucC5wLnMgY29yZXV0aWxzIDguMTEgc2hvdWxkIGhhdmUgdGhlIG9mbGFn
PW5vY2FjaGUgb3B0aW9uCndoaWNoIHdpbGwgd3JpdGUgdG8gZGlzayB3aXRob3V0IHVzaW5nIHVw
IHlvdXIgcGFnZSBjYWNoZSwKYW5kIGFsc28gYXZvaWRpbmcgT19ESVJFQ1QgY29uc3RyYWludHMu
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
