Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH1P56U145669 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 19:25:05 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A91D13C6E97
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 17:26:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	fEk0AGSF4iYj1iW9 for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 17:26:36 -0800 (PST)
Date: Wed, 17 Nov 2010 12:26:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: allocsize mount option behavior
Message-ID: <20101117012629.GK22876@dastard>
References: <C9083DF0.FCE%ivan.novick@emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C9083DF0.FCE%ivan.novick@emc.com>
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
To: Ivan.Novick@emc.com
Cc: Timothy.Heath@emc.com, xfs@oss.sgi.com

T24gVHVlLCBOb3YgMTYsIDIwMTAgYXQgMDQ6NTY6MDBQTSAtMDUwMCwgSXZhbi5Ob3ZpY2tAZW1j
LmNvbSB3cm90ZToKPiBIZWxsbywKPiAKPiBJIGFtIHVzaW5nIHRoZSBhbGxvY3NpemUgbW91bnQg
b3B0aW9uIHRvIHJlZHVjZSBmcmFnbWVudGF0aW9uLCBieQo+IGVuc3VyaW5nIGV4dGVudHMgYXJl
IG9mIGEgbWluaW11bSBzaXplLgo+IAo+IFVuZGVyIGEgd29ya2xvYWQgd2l0aCBoZWF2eSBjb25j
dXJyZW5jeSB3ZSBub3RpY2VkIHRoYXQgZGlzayBzcGFjZQo+IHVzYWdlIHdlbnQgdXAgbm90aWNl
YWJseS4KCkV4cGVjdGVkIGJlaGF2aW91ci4KCj4gQ2FuIHNvbWVvbmUgY2xhcmlmeSB0aGUgZXhw
ZWN0ZWQgYmVoYXZpb3Igb2YgYWxsb2NzaXplLiAgRG9lcyBpdAo+IGZvcmNlIGZpbGVzIHRvIGJl
IGF0IGxlYXN0IHRoZSBhbGxvY3NpemUgc2l6ZSBvbiBkaXNrLCBvciBpcyB0aGUKPiBhbGxvY3Np
emUgc2l6ZSByZXNlcnZlZCBmb3IgZWFjaCBvcGVuIGZpbGUgYW5kIHRoZW4gZnJlZWQgdXAgaWYg
aXQKPiBpcyBub3QgdXNlZCBhbmQgdGhlIGZpbGUgaXMgY2xvc2VkLCBvciBkb2VzIGl0IHdvcmsg
c29tZSBvdGhlcgo+IHdheS4KClRoZSBsYXR0ZXIgLSBpdCdzIGFuIGluLW1lbW9yeSwgcGVyLWlu
b2RlIHNwZWN1bGF0aXZlIGFsbG9jYXRpb24KdGhhdCBpcyByZW1vdmVkIHdoZW4gdGhlIGZpbGUg
aXMgY2xvc2VkLgoKPiBGb3IgZXhhbXBsZSBpZiBhbGxvY3NpemU9MWcgYW5kIEkgb3BlbiAxMDAw
IGZpbGVzIGFuZCBzdGFydAo+IHdyaXRpbmcgYSBzbWFsbCBhbW91bnQgb2YgZGF0YSB0byBlYWNo
IGZpbGUg4oCmLiBXb3VsZCB0aGUgZGV2aWNlCj4gc2hvdyBhcyB1c2luZyAxMDAwKiAxZyBvZiBk
aXNrIHNwYWNlIHdoaWxlIHRoZSBmaWxlcyBhcmUgb3BlbmVkCj4gYW5kIGFmdGVyIHRoZXkgYXJl
IGNsb3NlZCB0aGVuIG9ubHkgdGhlIGFtb3VudCBvZiBzcGFjZSBhY3R1YWxseQo+IHdyaXR0ZW4g
YnkgdGhlIHVzZXIgd291bGQgYmUgc2hvd24gYXMgdXNlZCBvbiBkaXNrPwoKWWVzLCBleGFjdGx5
LgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
