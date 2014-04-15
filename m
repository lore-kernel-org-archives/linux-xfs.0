Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F044F7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:56:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D6ACAC004
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:56:29 -0700 (PDT)
Received: from server.loguj.cz (server.loguj.cz [83.167.232.152]) by
	cuda.sgi.com with ESMTP id yWjgfD0UnboOFpIc for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:56:25 -0700 (PDT)
Date: Tue, 15 Apr 2014 21:57:41 +0200
Message-ID: <20140415215741.Horde.d8xeUy2MbgZTTY81Gl8nkMA@mail.loguj.cz>
From: =?utf-8?b?THVrw6HFoQ==?= Czerner <lukas@loguj.cz>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
	<alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
	<20140415153643.GB4456@thunk.org>
	<alpine.LFD.2.00.1404151808440.2146@localhost.localdomain>
	<20140415194004.GG4456@thunk.org>
In-Reply-To: <20140415194004.GG4456@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"; DelSp="Yes"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, =?utf-8?b?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org

WWVzLCBwbGVhc2UgZHJvcCB0aGUgcGF0Y2ggIzQgc2luY2UgaXQgcmVxdWlyZXMgZGlmZmVyZW50
IHNvbHV0aW9uLCBJICAKZG8gbm90IHRoaW5rIGl0J3MgY3JpdGljYWwgZW5vdWdoIHRvIGhhdmUg
cGFydGlhbCBzb2x1dGlvbiBhbmQgaXQgaGFzICAKYmVlbiB0aGF0IHdheSBmb3IgYSBsb25nIHRp
bWUuIFdlIGNhbiBmaXggaXQgbGF0ZXIuCgpUaGFua3MhCi1MdWthcwoKClRoZW9kb3JlIFRzJ28g
PHR5dHNvQG1pdC5lZHU+IHdyb3RlOgoKPiBPbiBUdWUsIEFwciAxNSwgMjAxNCBhdCAwNjowOToz
NFBNICswMjAwLCBMdWvDocWhIEN6ZXJuZXIgd3JvdGU6Cj4+Cj4+IE9rLCBJJ2xsIHJ1biBzb21l
IHRlc3RzIGFuZCByZXNlbmQgaXQgcmlnaHQgYXdheSB3aXRob3V0IHRoZSBwYXRjaAo+PiAjNC4K
Pgo+IFRoYW5rcyEgIFNvIHNob3VsZCBJIGRyb3AgcGF0Y2ggIzQgZm9yIG5vdz8gIEkgZG9uJ3Qg
dGhpbmsgaXQgZG9lcyBhbnkKPiBoYXJtLCBhbmQgaXQgZG9lcyBwbHVnIHRoZSBob2xlIHNvbWV3
aGF0LCBidXQgQ3Jpc3RvcGggaXMgcmlnaHQgdGhhdAo+IHdlIHN0aWxsIGNvdWxkIGhhdmUgc3dh
cG9uIHJhY2luZyB3aXRoIHRoZSBmYWxsb2NhdGUuCj4KPiAgICAJICAgICAgIAkgICAgCSAgIAkg
ICAgICAgCSAgIC0gVGVkCj4gLS0KPiBUbyB1bnN1YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2Vu
ZCB0aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgtZXh0NCIgaW4KPiB0aGUgYm9keSBvZiBhIG1l
c3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZwo+IE1vcmUgbWFqb3Jkb21vIGluZm8g
YXQgIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbAoKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
