Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 003FD7FD1
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 10:56:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2B27304053
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 08:56:52 -0700 (PDT)
Received: from mail-qa0-f47.google.com (mail-qa0-f47.google.com
	[209.85.216.47]) by cuda.sgi.com with ESMTP id Rqz0O6DSWrtKnnhe
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Mar 2013 08:56:48 -0700 (PDT)
Received: by mail-qa0-f47.google.com with SMTP id j8so890195qah.6
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 08:56:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 Mar 2013 21:26:47 +0530
Message-ID: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
Subject: Xfs_repair and journalling
From: Subranshu Patel <spatel.ml@gmail.com>
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
To: xfs@oss.sgi.com

VGhpcyBxdWVzdGlvbiBpcyByZWxhdGVkIHRvIHhmc19yZXBhaXIgKHJlY292ZXJ5KSBhbmQgam91
cm5hbGxpbmcuCgpJIHBvd2VyZWQgb2ZmIChpbXByb3BlciBzaHV0IGRvd24pIHRoZSBzeXN0ZW0g
d2hlbiB0aGUgSU8gd2FzCnVuZGVyZ29pbmcgb24gbW91bnRlZCBYRlMgZmlsZXN5c3RlbS4KClRo
ZW4gSSB0cmllZCB0byByZWNvdmVyIHRoZSBpbmNvbnNpc3RlbnQgZmlsZXN5c3RlbSB1c2luZyB4
ZnNfcmVwYWlyLAphZnRlciBwb3dlcmluZyBvbiB0aGUgc2FtZSBtYWNoaW5lLgoKVGhlIFhGUyBm
aWxlc3lzdGVtIGRpZG7igJl0IGdldCByZWNvdmVyZWQgd2hpY2ggd2FzIG5vdCBleHBlY3RlZC4g
VGhlCm91dHB1dCBkaXNwbGF5ZWQgYnkgeGZzX3JlcGFpciBpcyBhcyBmb2xsb3dzOgoKUGhhc2Ug
MSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uClBoYXNlIDIgLSB1c2luZyBpbnRlcm5h
bCBsb2cKICAgICAgICAtIHplcm8gbG9nLi4uCkVSUk9SOiBUaGUgZmlsZXN5c3RlbSBoYXMgdmFs
dWFibGUgbWV0YWRhdGEgY2hhbmdlcyBpbiBhIGxvZyB3aGljaCBuZWVkcyB0bwpiZSByZXBsYXll
ZC4gIE1vdW50IHRoZSBmaWxlc3lzdGVtIHRvIHJlcGxheSB0aGUgbG9nLCBhbmQgdW5tb3VudCBp
dCBiZWZvcmUKcmUtcnVubmluZyB4ZnNfcmVwYWlyLiAgSWYgeW91IGFyZSB1bmFibGUgdG8gbW91
bnQgdGhlIGZpbGVzeXN0ZW0sIHRoZW4gdXNlCnRoZSAtTCBvcHRpb24gdG8gZGVzdHJveSB0aGUg
bG9nIGFuZCBhdHRlbXB0IGEgcmVwYWlyLgpOb3RlIHRoYXQgZGVzdHJveWluZyB0aGUgbG9nIG1h
eSBjYXVzZSBjb3JydXB0aW9uIC0tIHBsZWFzZSBhdHRlbXB0IGEgbW91bnQKb2YgdGhlIGZpbGVz
eXN0ZW0gYmVmb3JlIGRvaW5nIHRoaXMuCgpUaGUgcXVlc3Rpb24gdGhhdCBhcmlzZXMgaGVyZSBp
cyB0aGF0IHdoeSB4ZnNfcmVwYWlyIHNob3VsZCBiZSByZS1ydW4KYWZ0ZXIgbW91bnRpbmcgYW5k
IHVubW91bnRpbmcgdGhlIFhGUyBmaWxlc3lzdGVtLiBBY2NvcmRpbmcgdG8gbXkKdW5kZXJzdGFu
ZGluZywgd2hlbiB3ZSBwZXJmb3JtIG1vdW50IG9wZXJhdGlvbiwgcmVjb3ZlcnkgaXMKYXV0b21h
dGljYWxseSBkb25lIGlmIHRoZSBmaWxlc3lzdGVtIGlzIGluIGluY29uc2lzdGVudCBzdGF0ZS4g
VGhlbgp3aGF0IGlzIHRoZSBuZWVkIG9mIHJlLXJ1bm5pbmcgeGZzX3JlcGFpciBhZnRlciBtb3Vu
dCBpcyBiZWluZwpwZXJmb3JtZWQ/IERvZXMgeGZzX3JlcGFpciByZWNvdmVycyBzb21ldGhpbmcg
aW5kaWZmZXJlbnQgZnJvbSB0aGUgb25lCnJlY292ZXJlZCBvbiBtb3VudD8gV2hhdCBleGFjdGx5
IGhhcHBlbnMgd2hlbiB3ZSBtb3VudCBhbmQgdW5tb3VudCBYRlMKZmlsZXN5c3RlbT8KClRoaXMg
aXMgbm90IG9ic2VydmVkIGluIEVYVDQsIGZzY2sgc3VjY2Vzc2Z1bGx5IHJlY292ZXJzIHdpdGhv
dXQKbW91bnRpbmcgdGhlIGZpbGVzeXN0ZW0uCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
