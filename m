Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28E077F54
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:40:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 198E18F8052
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:40:09 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 0R3LoY77OsAq5023 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 12:40:08 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:40:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Message-ID: <20140415194004.GG4456@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
	<alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
	<20140415153643.GB4456@thunk.org>
	<alpine.LFD.2.00.1404151808440.2146@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404151808440.2146@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBBcHIgMTUsIDIwMTQgYXQgMDY6MDk6MzRQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IAo+IE9rLCBJJ2xsIHJ1biBzb21lIHRlc3RzIGFuZCByZXNlbmQgaXQgcmlnaHQg
YXdheSB3aXRob3V0IHRoZSBwYXRjaAo+ICM0LgoKVGhhbmtzISAgU28gc2hvdWxkIEkgZHJvcCBw
YXRjaCAjNCBmb3Igbm93PyAgSSBkb24ndCB0aGluayBpdCBkb2VzIGFueQpoYXJtLCBhbmQgaXQg
ZG9lcyBwbHVnIHRoZSBob2xlIHNvbWV3aGF0LCBidXQgQ3Jpc3RvcGggaXMgcmlnaHQgdGhhdAp3
ZSBzdGlsbCBjb3VsZCBoYXZlIHN3YXBvbiByYWNpbmcgd2l0aCB0aGUgZmFsbG9jYXRlLgoKICAg
CSAgICAgICAJICAgIAkgICAJICAgICAgIAkgICAtIFRlZAoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
