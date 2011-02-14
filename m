Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1E2onXZ094259
	for <linux-xfs@oss.sgi.com>; Sun, 13 Feb 2011 20:50:49 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEE3815612CA
	for <linux-xfs@oss.sgi.com>; Sun, 13 Feb 2011 18:53:25 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.195]) by
	cuda.sgi.com with ESMTP id fSWIgEwIUQvWTfh1 for
	<linux-xfs@oss.sgi.com>; Sun, 13 Feb 2011 18:53:25 -0800 (PST)
Message-ID: <4D58990A.10506@lueckdatasystems.com>
Date: Sun, 13 Feb 2011 21:52:58 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
	<4D517FD2.5040509@lueckdatasystems.com>
	<20110208195256.GA25601@dastard>
	<4D51A0BC.6070201@lueckdatasystems.com>
	<4D51A695.6060700@lueckdatasystems.com>
	<20110208224707.GF2559@dastard>
In-Reply-To: <20110208224707.GF2559@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

R3JlZXRpbmdzIERhdmUsCgpEYXZlIENoaW5uZXIgd3JvdGU6Cj4gQW5kIG5vIGVycm9ycyBkZXRl
Y3RlZCBpbiB0aGUgZmlsZXN5c3RlbS4gQ2FuIHlvdSBydW4gdGhlIHhmc2R1bXAKPiBhZ2FpbiB0
byBjb25maXJtIHRoYXQgaXQgZmFpbHMgb24gdGhlIHNhbWUgaW5vZGU/IElmIGl0IGRvZXPFhiB0
aGVuCj4gaXQgZGVmaW5pdGVseSBzZWVtcyBsaWtlIGFuIGFsaWdubWVudCBwcm9ibGVtIGluIHRo
ZSB1bnRydXN0ZWQgaW5vZGUKPiBsb29rdXAgcGF0Y2hlcy4uLi4KCkkgZ290IGFyb3VuZCB0byBk
b2luZyB0aGUgcmVjcmVhdGUgdGVzdCBqdXN0IG5vdy4gQSBsYXJnZXIgdHJhY2UgZmlsZSB0aGlz
IHRpbWUsIGJ1dCBzdGlsbCBjcmFzaGVkLiBSZWJvb3RlZCBvZmYgb2YgdGhlIC0yNiBrZXJuZWwg
YW5kIHB1bGxpbmcgYSBiYWNrdXAgd2l0aCAib2xkIGZhaXRoZnVsIiBrZXJuZWwuCgpQbGVhc2Ug
ZmluZCB0aGUgdHJhY2Ugb3V0cHV0IGhlcmUgaW4gemlwcGVkIGZvcm1hdDoKCmh0dHA6Ly93d3cu
bHVlY2tkYXRhc3lzdGVtcy5jb20vcHViL2xkc2JhY2t1cC50cmFjZTIubG9nLnppcAoKSSBzdXBw
b3NlIHRoaXMgbWVhbnMgdGhhdCB0aGUgInVudHJ1c3RlZCBpbm9kZSBsb29rdXAgcGF0Y2hlcyIg
YXJlIGZ1cnRoZXIgY29uZmlybWVkIGFzIG1pc3Npbmc/IElmIHNvLCBhbnkgaWRlYSBvbiBob3cg
bG9uZyBpdCB3aWxsIHRha2UgdG8gcmVjZWl2ZSBhbiB1cGRhdGVkIGtlcm5lbCB3aXRoIHRoZSB4
ZnMgY29kZSBjb3JyZWN0aW9ucz8KClNpbmNlcmVseSwKCi0tIApNaWNoYWVsIEx1ZWNrCkx1ZWNr
IERhdGEgU3lzdGVtcwpodHRwOi8vd3d3Lmx1ZWNrZGF0YXN5c3RlbXMuY29tLwoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
