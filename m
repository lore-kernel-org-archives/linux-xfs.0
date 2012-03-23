Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NMmCjL040456 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 17:48:12 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id LHBUcfMTdDqh6ulP for
	<xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:48:11 -0700 (PDT)
Received: from merkaba.localnet (ppp-88-217-109-233.dynamic.mnet-online.de
	[88.217.109.233])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 29EB6A8
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 23:48:10 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 23 Mar 2012 23:48:08 +0100
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F6624A3.5010206@hardwarefreak.com>
	<20331.39194.377610.888636@tree.ty.sabi.co.UK>
	(sfid-20120322_230623_659246_32AB6D3E)
In-Reply-To: <20331.39194.377610.888636@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201203232348.09158.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

QW0gRG9ubmVyc3RhZywgMjIuIE3DpHJ6IDIwMTIgc2NocmllYiBQZXRlciBHcmFuZGk6Cj4gT3Zl
cnNlbGxpbmcgJ2RlbGF5bG9nJyB3aXRoIGNoZWVreSBwcm9wYWdhbmRhIGdsb3NzaW5nIG92ZXIg
dGhlCj4gaGVhdnkgdHJhZGVvZmZzIGludm9sdmVkIGlzIHVuZGVyc3RhbmRhYmxlLCBidXQgcXVp
dGUgd3JvbmcuCgpUaGluZyBpcywgYXMgZmFyIGFzIEkgdW5kZXJzdGFuZCBEYXZlwrRzIHNsaWRl
cyBhbmQgcmVjZW50IGVudHJpZXMgaW4gCktlcm5lbG5ld2JpZXMgTGludXggQ2hhbmdlcyBhcyB3
ZWxsIGFzIEhlaXNlIE9wZW4gS2VybmVsIGxvZyBpcyB0aGF0IC0gCmJlc2lkZSBkZWxheWxvZyAt
IHRoZXJlIGhhcyBiZWVuIHF1aXRlIHNvbWUgb3RoZXIgbWV0YWRhdGEgcmVsYXRlZCAKcGVyZm9y
bWFuY2UgaW1wcm92ZW1lbnRzLgoKVGh1cyBJTUhPIHJlZHVjaW5nIHRoZSByZWNlbnQgaW1wcm92
ZW1lbnRzIGluIG1ldGFkYXRhIHBlcmZvcm1hbmNlIGlzIAp1bmRlcnNlbGxpbmcgWEZTIGFuZCBv
dmVyc2VsbGluZyBkZWxheWxvZy4gVW5sZXNzIG9mIGNvdXJzZSBhbGwgdGhvc2UgCnJlY2VudCBw
ZXJmb3JtYW5jZSBpbXByb3ZlbWVudHMgY291bGQgbm90IGhhdmUgYmVlbiBkb25lIHdpdGhvdXQg
dGhlIApkZWxheWxvZyBtb2RlLgoKVGhhdCBzYWlkLCB0aGlzIGlzIGp1c3QgbXkgaW50ZXJwcmV0
YXRpb24uIElmIGFsbCByZWNlbnQgaW1wcm92ZW1lbnRzIGFyZSAKb25seSBkdWUgdG8gZGVsYXls
b2csIHRoZW4gSSBhbSBvYnZpb3VzbHkgb2ZmIHRyYWNrLgoKLS0gCk1hcnRpbiAnSGVsaW9zJyBT
dGVpZ2Vyd2FsZCAtIGh0dHA6Ly93d3cuTGljaHR2b2xsLmRlCkdQRzogMDNCMCAwRDZDIDAwNDAg
MDcxMCA0QUZBICBCODJGIDk5MUIgRUFBQyBBNTk5IDg0QzcKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
