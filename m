Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3THU4AQ073708 for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 12:30:04 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96C284DB65A
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 10:32:24 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id yXlBbuvou4vDzkpX for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2011 10:32:24 -0700 (PDT)
Date: Fri, 29 Apr 2011 10:32:16 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110428233751.GR12436@dastard>
Message-ID: <alpine.DEB.2.01.1104291029500.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

T24gRnJpLCAyOSBBcHIgMjAxMSBhdCAwOTozNywgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IERpZCB5
b3UgcmVhZCB0aGUgZW1haWwgdGhhdCBwb2ludGVkIHRvIENPTkZJR19USU5ZX1JDVSBhcyB0aGUK
PiBwdG90ZW50aWFsIHNvdXJjZSBvZiB0aGUgcHJvYmxlbT8gQ2FuIHlvdSBjaGFuZ2UgdG8gQ09O
RklHX1RSRUVfUkNVCj4gYW5kIHNlZSBpZiB0aGUgcHJvYmxlbSBnb2VzIGF3YXk/CgpGb3IgdGhh
dCBJIGhhZCB0byBzZWxlY3QgU01QIG9uIHRoaXMgVVAtUG93ZXJQQyBHNCBtYWNoaW5lLiBCdXQg
Y29tcGlsaW5nIAotcmM1IChhcyB0aGUgYnVnIGlzIHN0cmlsbCBwcmVzZW50IGluIC1yYzUpIGZh
aWxzIHdpdGg6CgovdXNyL2xvY2FsL3NyYy9saW51eC0yLjYtZ2l0L2FyY2gvcG93ZXJwYy9rZXJu
ZWwvY3Jhc2guYzogSW4gZnVuY3Rpb24gCuKAmGRlZmF1bHRfbWFjaGluZV9jcmFzaF9zaHV0ZG93
buKAmToKL3Vzci9sb2NhbC9zcmMvbGludXgtMi42LWdpdC9hcmNoL3Bvd2VycGMva2VybmVsL2Ny
YXNoLmM6MzQ5OiBlcnJvcjogCmltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmGNy
YXNoX2tleGVjX3dhaXRfcmVhbG1vZGXigJkKbWFrZVsyXTogKioqIFthcmNoL3Bvd2VycGMva2Vy
bmVsL2NyYXNoLm9dIEVycm9yIDEKbWFrZVsxXTogKioqIFthcmNoL3Bvd2VycGMva2VybmVsXSBF
cnJvciAyCm1ha2U6ICoqKiBbc3ViLW1ha2VdIEVycm9yIDIKCk1heWJlIEknbGwganVzdCBkaXNh
YmxlIGtleGVjIGFuZCBzZWUgaWYgVFJFRV9SQ1UgaGVscHMuCgpNZWFud2hpbGUsIEkgZ2F2ZSB1
cCBvbiB0aGUgZ2l0IGJpc2VjdCwgYXMgSSBjYW4gaGFyZGx5IGJvb3QgaW5iZXR3ZWVuIApjb21t
aXRzOiBodHRwOi8vbmVyZGJ5bmF0dXJlLmRlL2JpdHMvMi42LjM5LXJjNC9vb20vZ2l0LWJpc2Vj
dC1sb2cudHh0CgpUaGFua3MsCkNocmlzdGlhbi4KLS0gCkJPRkggZXhjdXNlICM0NDY6CgpNYWls
ZXItZGFlbW9uIGlzIGJ1c3kgYnVybmluZyB5b3VyIG1lc3NhZ2UgaW4gaGVsbC4KCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
