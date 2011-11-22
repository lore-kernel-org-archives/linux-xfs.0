Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM0JItf028099
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 18:19:18 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 062681C0C60B
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:19:16 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	eBsDtkLlX5E26uuq for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 16:19:16 -0800 (PST)
Received: by ggnv2 with SMTP id v2so7026970ggn.26
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:19:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111121170459.GA1327@infradead.org>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121170459.GA1327@infradead.org>
Date: Tue, 22 Nov 2011 08:19:15 +0800
Message-ID: <CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
Subject: Re: stale NFS file handle problem on XFS inode64
From: hank peng <pengxihan@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

MjAxMS8xMS8yMiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+Ogo+IE9uIE1v
biwgTm92IDIxLCAyMDExIGF0IDA5OjAwOjU3UE0gKzA4MDAsIGhhbmsgcGVuZyB3cm90ZToKPj4g
SGk6Cj4+IEkgaGF2ZSBhIDRUQiBYRlMgZmlsZXN5c3RlbSBtb3VudGVkIHdpdGggImlub2RlNjQi
IG9wdGlvbiwgYW5kIEkKPj4gZXhwb3J0ZWQgaXQgdXNpbmcgTkZTIHYzLCBvbiBORlMgY2xpZW50
LCBJIGVudGVyZWQgYSBzdWJkaXJlY3RvcnkgYW5kCj4+IGdvdCAic3RhbGUgTkZTIGZpbGUgaGFu
ZGxlIiBlcnJvci4KPj4gbHMgLWlsIHNob3dlZCB0aGF0IGl0cyBpbm9kZSBudW1iZXIgZXhjZWVk
IDMyIGJpdCBsaW1pdC4KPj4gTkZTIHNlcnZlcjoga2VybmVsIHZlcnNpb24gaXMgMi42LjM1LjYK
Pj4gTkZTIGNsaWVudDoga2VybmVsIHZlcnNpb24gaXMgMi42LjE4Cj4KPiBEbyB5b3UgZXhwb3J0
IHRoZSByb290IGRpcmVjdG9yeSBvZiB0aGUgWEZTIGZpbGVzeXN0ZW0sIG9yIGEKPiBzdWJkaXJl
Y3RvcnkgaW4gaXQ/IMKgSWYgaXQncyB0aGUgZm9ybWVyIGl0IHNob3VsZCB3b3JrIGluIHRoZW9y
eSwKPiBhbHRocm91Z2ggSSdtIG5vdCBzdXJlIGhvdyB3ZWxsIDY0LWJpdCBpbm9kZSBudW1iZXJz
IHdvcmsgd2l0aCBhIGNsaWVudAo+IHRoYXQgb2xkLCBpZiBpdCdzIHRoZSBsYXR0ZXIgaXQgbmVl
ZHMgYSBmZXcgdHdlYWtzIHRvIHdvcmssIHNlZQo+ClRoZSBmb2xsb3dpbmcgaXMgd2hhdCBJIGRp
ZDoKMS4gbWtmcy54ZnMgL2Rldi9zZGIgICAod2hvbGUgZGlzaykKMi4gY3JlYXRlIGEgbW91bnQg
cG9pbnQgaW4gbXkgcm9vdCBmaWxlc3lzdGVtOgpta2RpciAvbW50L215bW91bnQKMy4gbW9udXQg
eGZzIHdpdGggaW5vZGU2NAptb3VudCAvZGV2L3NkYiAvbW50L215bW91bnQgLW8gaW5vZGU2NAo0
LiBleHBvcnQgaXQgaW4gTkZTIC9ldGMvZXhwb3J0cwovbW50L215bW91bnQgICAqKHJ3LCBub19y
b290LHNxdWFzaCwgc3luYykKCnNvLCBpcyB0aGVyZSBhbnkgcHJvYmxlbSBoZXJlPwoKCgo+IMKg
IMKgIMKgIMKgaHR0cDovL3hmcy5vcmcvaW5kZXgucGhwL1hGU19GQVEjUTpfV2h5X2RvZXNuLjI3
dF9ORlMtZXhwb3J0aW5nX3N1YmRpcmVjdG9yaWVzX29mX2lub2RlNjQtbW91bnRlZF9maWxlc3lz
dGVtX3dvcmsuM0YKPgo+IGZvciBkZXRhaWxzLgo+CgoKCi0tIApUaGUgc2ltcGxlc3QgaXMgbm90
IGFsbCBiZXN0IGJ1dCB0aGUgYmVzdCBpcyBzdXJlbHkgdGhlIHNpbXBsZXN0IQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
