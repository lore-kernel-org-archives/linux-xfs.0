Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B37B7CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 16:05:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D6B7304039
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 14:05:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5g4Kxf0EMOotDjr7 for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 14:05:40 -0800 (PST)
Date: Tue, 2 Feb 2016 09:05:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: lock bitmap/summary inodes in xfs_rtbuf_get()
Message-ID: <20160201220500.GW6033@dastard>
References: <56AC2D64.2080907@redhat.com> <20160130210650.GL20456@dastard>
	<015F4CF0-425A-4EB0-ACE2-4EBBE0B78173@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <015F4CF0-425A-4EB0-ACE2-4EBBE0B78173@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

T24gU2F0LCBKYW4gMzAsIDIwMTYgYXQgMDM6NTM6NDhQTSAtMDYwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9LLCB0aGFua3MgRGF2ZS4gSXQgc2VlbWVkIGxpa2UgaXQgd2FzIHByb2JhYmx5IHRv
byBzaW1wbGXigKYKClllYWgsIGFuZCB0aGUgc2ltcGxlIGZpeCAobG9jayBpbiB4ZnNfYm1hcF9y
dGFsbG9jKCkpIHVuY292ZXJzCmZ1cnRoZXIgaXNzdWVzIHcuci50LiBsb2dnaW5nIC0gdGhlIGJ1
ZmZlcnMgYXJlIG5vdCBzdGFtcGVkIHdpdGggYQp0eXBlLCBzbyBsb2cgcmVjb3Zlcnkgd2lsbCBu
b3QgY2F0ZWdvcmlzZSB0aGVtIGNvcnJlY3RseS4KCkFuZCwgSSBzdXNwZWN0LCBsb2cgcmVjb3Zl
cnkgbWlnaHQgaGF2ZSBwcm9ibGVtcyB3aXRoIHRoZQpiaXRtYXAvc21tYXJ5IGJ1ZmZlcnMgYXMg
dGhleSBkb24ndCBoYXZlIG1hZ2ljIG51bWJlcnMgaW4gdGhlbS4gTW9yZQp3b3JrIHRvIGJlIGRv
bmUgaGVyZS4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3Ji
aXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
