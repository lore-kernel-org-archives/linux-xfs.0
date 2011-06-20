Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K0isUB094934 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 19:44:55 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22A4351EBE0
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:44:51 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id rNfPiDsSKLRWvv9B for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:44:51 -0700 (PDT)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3B60A3EE0B5
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 09:44:44 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1D0E045DE72
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 09:44:44 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0044E45DE6A
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 09:44:44 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id CC966E08001
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 09:44:43 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3CA9DE08003
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 09:44:43 +0900 (JST)
Message-ID: <4DFE97F1.2030206@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 09:44:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/12] vmscan: add shrink_slab tracepoints
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1306998067-27659-2-git-send-email-david@fromorbit.com>
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
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

KDIwMTEvMDYvMDIgMTY6MDApLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gRnJvbTogRGF2ZSBDaGlu
bmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+INCGdCBpcyBpbXBvc3NpYmxlIHRvIHVuZGVy
c3RhbmQgd2hhdCB0aGUgc2hyaW5rZXJzIGFyZSBhY3R1YWxseSBkb2luZwo+IHdpdGhvdXQgaW5z
dHJ1bWVudGluZyB0aGUgY29kZSwgc28gYWRkIGEgc29tZSB0cmFjZXBvaW50cyB0byBhbGxvdwo+
IGluc2lnaHQgdG8gYmUgZ2FpbmVkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8
ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiAtLS0KPiAgaW5jbHVkZS90cmFjZS9ldmVudHMvdm1zY2Fu
LmggfCAgIDY3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIG1t
L3Ztc2Nhbi5jICAgICAgICAgICAgICAgICAgIHwgICAgNiArKystCj4gIDIgZmlsZXMgY2hhbmdl
ZCwgNzIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKClRoaXMgbG9vayBnb29kIHRvIG1l
LiBJIGhhdmUgdHdvIG1pbm9yIHJlcXVlc3QuIDEpIHBsZWFzZSBjaGFuZ2UgcGF0Y2ggb3JkZXIs
Cm1vdmUgdGhpcyBwYXRjaCBhZnRlciBzaHJpbmtlciBjaGFuZ2VzLiBpb3csIG5vdyBib3RoIHRo
aXMgYW5kIFsyLzEyXSBoYXZlCnRyYWNlcG9pbnQgY2hhbmdlLiBJIGRvbid0IGxpa2UgaXQuIDIp
IHBsZWFzZSBhdm9pZCBjcnlwdGljIGFiYnJldmlhdGVkIHZhcmlhYmxlCm5hbWVzLiBJbnN0ZWFk
LCBwbGVhc2UganVzdCB1c2UgdGhlIHNhbWUgdmFyaWFibGUgbmFtZSB3aXRoIHZtc2Nhbi5jIHNv
dXJjZSBjb2RlLgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
