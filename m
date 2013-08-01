Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B49087F37
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 03:17:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9EBFA3040CB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 01:17:24 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id DyNsGzxzJTff1HOn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 01:17:23 -0700 (PDT)
Date: Thu, 1 Aug 2013 10:17:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Message-ID: <20130801081720.GA29497@lst.de>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
	<20130712004421.GE3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130712004421.GE3438@dastard>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

T24gRnJpLCBKdWwgMTIsIDIwMTMgYXQgMTA6NDQ6MjFBTSArMTAwMCwgRGF2ZSBDaGlubmVyIHdy
b3RlOgo+IE9uIFRodSwgSnVsIDExLCAyMDEzIGF0IDEyOjAyOjE4QU0gKzAyMDAsIEphbiBLYXJh
IHdyb3RlOgo+ID4gRnJvbTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBpbmZyYWRlYWQub3JnPgo+
ID4gCj4gPiBBZGQgc3VwcG9ydCB0byB0aGUgY29yZSBkaXJlY3QtaW8gY29kZSB0byBkZWZlciBB
SU8gY29tcGxldGlvbnMgdG8gdXNlcgo+ID4gY29udGV4dCB1c2luZyBhIHdvcmtxdWV1ZS4gIFRo
aXMgcmVwbGFjZXMgb3BlbmNvZGVkIGFuZCBsZXNzIGVmZmljaWVudAo+ID4gY29kZSBpbiBYRlMg
YW5kIGV4dDQgYW5kIHdpbGwgYmUgbmVlZGVkIHRvIHByb3Blcmx5IHN1cHBvcnQgT18oRClTWU5D
Cj4gPiBmb3IgQUlPLgo+IAo+IEkgZG9uJ3Qgc2VlIGhvdyB0aGlzIGlzIGFueSBtb3JlIGVmZmlj
aWVudCB0aGFuIHRoZSBkZWZlcnJhbAo+IHRoYXQgWEZTIGFscmVhZHkgZG9lcyBmb3IgZGlyZWN0
IElPIGNvbXBsZXRpb24gLSBpdCBqdXN0IGNoYW5nZXMKPiB3aGF0IHF1ZXVlcyBJTyBmb3IgY29t
cGxldGlvbnMuIEFuZCBvbiB0aGF0IHRvcGljOgoKSXQgYXZvaWRlZCBhIG1lbW9yeSBhbGxvY2F0
aW9uIGZvciBlYWNoIGTRlnJlY3QgSS9PIHdyaXRlLgoKPiBGV0lXLCBpbiBYRlMgd2UgcXVldWUg
dW53cml0dGVuIGV4dGVudCBjb252ZXJzaW9uIGNvbXBsZXRpb25zIG9uIGEKPiBkaWZmZXJlbnQg
d29ya3F1ZXVlIHRvIEVPRiBzaXplIHVwZGF0ZSBjb21wbGV0aW9ucyBiZWNhdXNlIHRoZQo+IGxh
dHRlciBhcmUgc21hbGwsIGZhc3QgYW5kIHJhcmVseSByZXF1aXJlIElPIG9yIGdldCBibG9ja2Vk
LiBUaGUKPiBkYXRhIElPIGNvbXBsZXRpb24gd29ya3F1ZXVlIGZvciBFT0YgdXBkYXRlcyBoYXMg
dGhlIHNhbWUKPiBjb25jdXJyZW5jeSBhbmQgZGVwdGggYXMgdGhlIHVud3JpdHRlbiBleHRlbnQg
d29yayBxdWV1ZSAoaS5lLiAyNTYKPiB3b3JrZXJzIHBlciBjcHUgcGVyIHN1cGVyYmxvY2spLiBT
byBwdXNoaW5nIGFsbCBvZiB0aGlzIERJTyBhbmQgRU9GCj4gY29tcGxldGlvbiB3b3JrIGludG8g
YSBzaW5nbGUgdGhyZWFkZWQgZ2xvYmFsIHdvcmtxdWV1ZSB0aGF0IGNhbgo+IGJsb2NrIGluIGV2
ZXJ5IElPIGNvbXBsZXRpb24gZG9lc24ndCBzZWVtIGxpa2UgYSB2ZXJ5IHNtYXJ0IGlkZWEgdG8K
PiBtZS4uLgoKQ3VycmVudGx5IHRoZSBkaXJlY3QgSS9PIGNvZGUgZG9lc24ndCBzdXBwb3J0IGFz
eW5jIGV4dGVuZGluZyB3cml0ZXMuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3Nz
LnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
