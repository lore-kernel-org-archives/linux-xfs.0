Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM3MIMc114803
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 21:22:18 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9327926AF95
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 19:22:16 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	ViFwfx3YjVxrwtVw for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 19:22:16 -0800 (PST)
Received: by iaen33 with SMTP id n33so9478930iae.26
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 19:22:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111122014609.GK2386@dastard>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121170459.GA1327@infradead.org>
	<CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
	<20111122014609.GK2386@dastard>
Date: Tue, 22 Nov 2011 11:22:15 +0800
Message-ID: <CAJNJY8S2FOJisp8-wm5FCMSaBYoMO-ePT1sSXfZ+K1LAyxW=og@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

MjAxMS8xMS8yMiBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+Ogo+IE9uIFR1ZSwg
Tm92IDIyLCAyMDExIGF0IDA4OjE5OjE1QU0gKzA4MDAsIGhhbmsgcGVuZyB3cm90ZToKPj4gMjAx
MS8xMS8yMiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+Ogo+PiA+IE9uIE1v
biwgTm92IDIxLCAyMDExIGF0IDA5OjAwOjU3UE0gKzA4MDAsIGhhbmsgcGVuZyB3cm90ZToKPj4g
Pj4gSGk6Cj4+ID4+IEkgaGF2ZSBhIDRUQiBYRlMgZmlsZXN5c3RlbSBtb3VudGVkIHdpdGggImlu
b2RlNjQiIG9wdGlvbiwgYW5kIEkKPj4gPj4gZXhwb3J0ZWQgaXQgdXNpbmcgTkZTIHYzLCBvbiBO
RlMgY2xpZW50LCBJIGVudGVyZWQgYSBzdWJkaXJlY3RvcnkgYW5kCj4+ID4+IGdvdCAic3RhbGUg
TkZTIGZpbGUgaGFuZGxlIiBlcnJvci4KPj4gPj4gbHMgLWlsIHNob3dlZCB0aGF0IGl0cyBpbm9k
ZSBudW1iZXIgZXhjZWVkIDMyIGJpdCBsaW1pdC4KPj4gPj4gTkZTIHNlcnZlcjoga2VybmVsIHZl
cnNpb24gaXMgMi42LjM1LjYKPj4gPj4gTkZTIGNsaWVudDoga2VybmVsIHZlcnNpb24gaXMgMi42
LjE4Cj4+ID4KPj4gPiBEbyB5b3UgZXhwb3J0IHRoZSByb290IGRpcmVjdG9yeSBvZiB0aGUgWEZT
IGZpbGVzeXN0ZW0sIG9yIGEKPj4gPiBzdWJkaXJlY3RvcnkgaW4gaXQ/IMKgSWYgaXQncyB0aGUg
Zm9ybWVyIGl0IHNob3VsZCB3b3JrIGluIHRoZW9yeSwKPj4gPiBhbHRocm91Z2ggSSdtIG5vdCBz
dXJlIGhvdyB3ZWxsIDY0LWJpdCBpbm9kZSBudW1iZXJzIHdvcmsgd2l0aCBhIGNsaWVudAo+PiA+
IHRoYXQgb2xkLCBpZiBpdCdzIHRoZSBsYXR0ZXIgaXQgbmVlZHMgYSBmZXcgdHdlYWtzIHRvIHdv
cmssIHNlZQo+PiA+Cj4+IFRoZSBmb2xsb3dpbmcgaXMgd2hhdCBJIGRpZDoKPj4gMS4gbWtmcy54
ZnMgL2Rldi9zZGIgwqAgKHdob2xlIGRpc2spCj4+IDIuIGNyZWF0ZSBhIG1vdW50IHBvaW50IGlu
IG15IHJvb3QgZmlsZXN5c3RlbToKPj4gbWtkaXIgL21udC9teW1vdW50Cj4+IDMuIG1vbnV0IHhm
cyB3aXRoIGlub2RlNjQKPj4gbW91bnQgL2Rldi9zZGIgL21udC9teW1vdW50IC1vIGlub2RlNjQK
Pj4gNC4gZXhwb3J0IGl0IGluIE5GUyAvZXRjL2V4cG9ydHMKPj4gL21udC9teW1vdW50IMKgICoo
cncsIG5vX3Jvb3Qsc3F1YXNoLCBzeW5jKQo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIF5eXl5eXl5eXl5eXl5eIG5vX3Jvb3Rfc3F1YXNoCj4+CnNvcnJ5LCBpdCBpcyBteSB0eXBl
IG1pc3Rha2UsIGl0IGlzIG5vX3Jvb3Rfc3F1YXNoLgoKSSB0aGluayBJIGhhdmUgYWxyZWFkeSBl
eHBvcnRlZCB0aGUgcm9vdCBvZiBteSBYRlMgZmlsZXN5c3RlbSwgYW0gSSByaWdodD8KCgo+PiBz
bywgaXMgdGhlcmUgYW55IHByb2JsZW0gaGVyZT8KPj4KPj4gPiDCoCDCoCDCoCDCoGh0dHA6Ly94
ZnMub3JnL2luZGV4LnBocC9YRlNfRkFRI1E6X1doeV9kb2Vzbi4yN3RfTkZTLWV4cG9ydGluZ19z
dWJkaXJlY3Rvcmllc19vZl9pbm9kZTY0LW1vdW50ZWRfZmlsZXN5c3RlbV93b3JrLjNGCj4KPiBJ
dCdzIGluIHRoZSBGQVEgZW50cnkgY2hyaXN0b3BoIHBvaW50ZWQgeW91IHRvOgo+Cj4gIkhvd2V2
ZXIsIGV4cG9ydGluZyB0aGUgcm9vdCBvZiB0aGUgZmlsZXN5c3RlbSB3b3JrcyIKPgo+IENoZWVy
cywKPgo+IERhdmUuCj4gLS0KPiBEYXZlIENoaW5uZXIKPiBkYXZpZEBmcm9tb3JiaXQuY29tCj4K
CgoKLS0gClRoZSBzaW1wbGVzdCBpcyBub3QgYWxsIGJlc3QgYnV0IHRoZSBiZXN0IGlzIHN1cmVs
eSB0aGUgc2ltcGxlc3QhCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
