Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11F557FAB
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 18:05:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89B7BAC001
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 16:05:45 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id umWk2yawhNX4z6Mz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 16:05:44 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	rBA05elY078038 for <xfs@oss.sgi.com>; Mon, 9 Dec 2013 16:05:42 -0800
Message-ID: <52A65AD5.9070705@tlinx.org>
Date: Mon, 09 Dec 2013 16:05:41 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: where/how is 'xattr' type=security enforced? (security attr stripped?)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

SSBnb3QgYSB3ZWlyZCBtZXNzYWdlIHRoYXQgSSd2ZSBuZXZlciBzZWVuIGJlZm9yZSAtLSBub3Ro
aW5nCmxpZmUgc2hhdHRlcmluZywganVzdCBhIGN1cmlvc2l0eSB0aGF0IEkgdGhvdWdodCBzaG91
bGRuJ3QgaGFwcGVuLgoKCkkgc3RvcmVkIGEgZmlsZSBpbiBteSAvaG9tZSBwYXJ0aXRpb24gRlJP
TSBhIFdpbjcgY2xpZW50CnZpYSBzYW1iYSAzLjYuMTYuCgpXaXRoIHRoYXQgZmlsZSB3ZXJlIGFs
c28gc3RvcmVkIHhhdHRyczoKCkRPU0FUVFJJQiwgU0FNQkFfUEFJIGFuZCBOVEFDTC4gIFNpbmNl
IGxpbnV4IGlzIHRoZSAnc2VydmVyJywKVGhlc2UgYXJlIGFsbCBsaWtlbHkgc2V0IHZpYSBzYW1i
YS4KClRvIHdvcmsgb24gdGhlIGZpbGUgbW9yZSwgSSB3YW50ZWQgdG8gbW92ZSBpdAp0byAvdG1w
LgoKSSB1c2UgbXY6Cj4gbXYgIC9ob21lL2xhdy90bXAvb1ZhcnMucG0gL3RtcAptdjogc2V0dGlu
ZyBhdHRyaWJ1dGUg4oCYc2VjdXJpdHkuTlRBQ0zigJkgZm9yIOKAmHNlY3VyaXR5Lk5UQUNM4oCZ
OiBPcGVyYXRpb24gbm90IHBlcm1pdHRlZAoKIkkiIHdhcyB0aGUgb3duZXIgb2YgdGhlIGZpbGUg
KHNhbWUgVUlEIGlzIHJlc29sdmVkIGZvciBOVC11c2VyICYgbG9jYWwgdXNlcikgYW5kCmxvY2Fs
IHVzZXIgaXMgaW4gZ3JvdXAgdGhhdCBmaWxlIHdhcyBzdG9yZWQgdW5kZXIuCgpJIGFtIHRyeWlu
ZyB0byBmaWd1cmUgb3V0IHdoZXJlIHRoaXMgbWVzc2FnZSBjYW1lIGZyb20sIGFzICdtdicgZG9l
c24ndApkbyBhbnkgYWNjZXNzIGVuZm9yY2VtZW50IGJhc2VkIG9uIHRoZSAneGF0dHInIG5hbWUg
ZmllbGQuCgpUaGUgaW1wYWN0IG9mIHRoaXMgaXMgSSBjYW4ndCBtb3ZlIHRoZSBmaWxlIHdpdGhv
dXQgbG9zaW5nIHNlY3VyaXR5CndoaWNoIGlzIGF1dG9tYXRpY2FsbHkgc3RyaXBwZWQuCgpUcnlp
bmcgdG8gKmNvcHkqIHRoZSBmaWxlIHdpdGhpbiB0aGUgc2FtZSBkaXJlY3RvcnkgYWxzbyByZXN1
bHRzCmluIHRoZSBzZWN1cml0eSB4YXR0ciBiZWluZyBzdHJpcHBlZCAtLSBidXQgKioqc2lsZW50
bHkqKiouCgpTbyB3aGF0IHdhcyByZXNwb25zaWJsZSBmb3IgcHJvaGliaXRpbmcgdGhlIG1vdmlu
ZyB0aGUgdGhlIHhmcyAneGF0dHInPwoKTXkgdGhvdWdodHMgb24gdGhpcyBhcmUgdGhhdCBpZiBJ
LCBhcyBhIHVzZXIgY2FuIHdyaXRlIHN1Y2ggYSBmaWxlCih0byBteSBob21lIGRpciBpbiB0aGlz
IGNhc2UpIGFuZCB0aGUgYXR0cmlidXRlcyBhcmUgY3JlYXRlZCAoaW5kaXJlY3RseSkKYnkgIm1l
IiB3aGVuIEkgY3JlYXRlIHRoZSBmaWxlLCBJIHNob3VsZCBhbHNvIGJlIGFibGUgdG8gbW92ZSB0
aGUgZmlsZQoqKmludGFjdCoqIHdpdGggdGhlIE5UQUNMIG1haW50YWluZWQuCgpJbiBib3RoIGNh
c2VzLCB0aGUgZmlsZSBzeXN0ZW0gdHlwZXMgYXJlIHRoZSBzYW1lICh4ZnMpLiAgVGhlIGNyZWF0
b3IKYW5kIHRoZSBtb3ZlciBhcmUgdGhlIHNhbWUgVUlELiAgQm90aCBmaWxlIHN5c3RlbXMgY2Fu
IGJlIGFjY2Vzc2VkCnZpYSBteSBXaW43IENsaWVudC4KClNvIGFueW9uZSBrbm93IHdoeSB0aGlz
IGZhaWxzIG9yIHdoeSBpdCBpcyBzaWxlbnRseSBzdHJpcHBlZCBvbiBhCiJjcCI/CgpUaGFua3Mu
Li4obWF5YmUgYSBrZXJuZWwgYnVnPykKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
