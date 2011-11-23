Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN1JRqQ185721
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 19:19:28 -0600
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DD5C26FE4E
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 17:19:26 -0800 (PST)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	mHsQOWG7AUbB1xm1 for <linux-xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 17:19:26 -0800 (PST)
Received: by ghrr13 with SMTP id r13so1083215ghr.26
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 17:19:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111122221515.GA29540@infradead.org>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121170459.GA1327@infradead.org>
	<CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
	<20111122221515.GA29540@infradead.org>
Date: Wed, 23 Nov 2011 09:19:26 +0800
Message-ID: <CAJNJY8Q3u6zZYHVdxnka160f+EC21JxoBe4EyKk=vDQgH4T19w@mail.gmail.com>
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

MjAxMS8xMS8yMyBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+Ogo+IE9uIFR1
ZSwgTm92IDIyLCAyMDExIGF0IDA4OjE5OjE1QU0gKzA4MDAsIGhhbmsgcGVuZyB3cm90ZToKPj4g
PiBEbyB5b3UgZXhwb3J0IHRoZSByb290IGRpcmVjdG9yeSBvZiB0aGUgWEZTIGZpbGVzeXN0ZW0s
IG9yIGEKPj4gPiBzdWJkaXJlY3RvcnkgaW4gaXQ/ID8/SWYgaXQncyB0aGUgZm9ybWVyIGl0IHNo
b3VsZCB3b3JrIGluIHRoZW9yeSwKPj4gPiBhbHRocm91Z2ggSSdtIG5vdCBzdXJlIGhvdyB3ZWxs
IDY0LWJpdCBpbm9kZSBudW1iZXJzIHdvcmsgd2l0aCBhIGNsaWVudAo+PiA+IHRoYXQgb2xkLCBp
ZiBpdCdzIHRoZSBsYXR0ZXIgaXQgbmVlZHMgYSBmZXcgdHdlYWtzIHRvIHdvcmssIHNlZQo+PiA+
Cj4+IFRoZSBmb2xsb3dpbmcgaXMgd2hhdCBJIGRpZDoKPj4gMS4gbWtmcy54ZnMgL2Rldi9zZGIg
wqAgKHdob2xlIGRpc2spCj4+IDIuIGNyZWF0ZSBhIG1vdW50IHBvaW50IGluIG15IHJvb3QgZmls
ZXN5c3RlbToKPj4gbWtkaXIgL21udC9teW1vdW50Cj4+IDMuIG1vbnV0IHhmcyB3aXRoIGlub2Rl
NjQKPj4gbW91bnQgL2Rldi9zZGIgL21udC9teW1vdW50IC1vIGlub2RlNjQKPj4gNC4gZXhwb3J0
IGl0IGluIE5GUyAvZXRjL2V4cG9ydHMKPj4gL21udC9teW1vdW50IMKgICoocncsIG5vX3Jvb3Qs
c3F1YXNoLCBzeW5jKQo+Pgo+PiBzbywgaXMgdGhlcmUgYW55IHByb2JsZW0gaGVyZT8KPgo+IFRo
YXQgc2hvdWxkIHdvcmsgZmluZSwgYW5kIEkndmUgdHJpZWQgaXQgYSBsb3Qgb2YgdGltZXMuIMKg
RG8geW91IHNlZQo+IHRoZSBzYW1lIGlzc3VlIHdoZW4gbW91bnRpbmcgdGhlIGZzIG9uIHRoZSBz
ZXJ2ZXIgKG5vdCByZWNvbW1lbmRlZCBmb3IKPiBwcm9kdWN0aW9uIHVzZSwganVzdCBmb3IgdGVz
dGluZyEpIGFuZCBhY2Nlc3NpbmcgaXQgZnJvbSB0aGUgMi42LjM1Cj4ga2VybmVsIG5mcyBjbGll
bnQ/Cj4KeWVzLCBJIGhhdmUgYWxyZWFkeSBkb25lIHRoYXQuIEkgbW91bnQgdGhlIGV4cG90ZWQg
TkZTIGRpcmVjdG9yeSBpbgpzYW1lIG1hY2hpbmUoa2VybmVsIHZlcnNpb24gaXMgMi42LjM1LjYp
LCBidXQgaXQgc3RpbGwgZGlkbid0IHdvcmsuCgpUaGVuLCBJIHVzZWQgZnNpZD0kKG15IGV4cG9y
dGVkIGZpbGVzeXN0ZW0gSUQpIG9wdGlvbiBpbiAvZXRjL2V4cG9ydHMKYW5kIHRyaWVkIGFnYWlu
LCBpdCBzdGlsbCBnYXZlIG1lIGJhY2sgInN0YWxlIE5GUyBmaWxlIGhhbmRsZSIgd2hlbgplbnRl
cmluZyBhIHNwZWNpZmljIHN1YmRpcmVjdG9yeS4KSSBub3RpY2VkIHRoYXQgZnJvbSBORlMgY2xp
ZW50KGluIHNhbWUgbWFjaGluZSB3aXRoIE5GUyBzZXJ2ZXIpIHNpZGUsCnRoZSBpbm9kZSBudW1i
ZXIgb2YgdGhpcyBzdWJkaXJlY3Rvcnkgd2FzIGNoYW5nZWQgdG8gYmUgd2l0aGluIDMyCmxpbWl0
LCBidXQgIHN0aWxsICJzdGFsZSBORlMgZmlsZSBoYW5kbGUiIGNhbWUgYmFjay4KCkluIGxvY2Fs
IGZpbGVzeXRlbSwgSSBlbnRlcmVkIHRoZSBtb3VudGVkIHBvaW50IGFuZCBzdWJkaXJlY3Rvcnks
IGFsbCBpcyBPSy4KCj4KCgoKLS0gClRoZSBzaW1wbGVzdCBpcyBub3QgYWxsIGJlc3QgYnV0IHRo
ZSBiZXN0IGlzIHN1cmVseSB0aGUgc2ltcGxlc3QhCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
