Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2BLu1Ks184538 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 15:56:07 -0600
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5CC010D1B23
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 13:58:51 -0800 (PST)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id X2bCe2X1NIyv8kK4 for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 13:58:51 -0800 (PST)
Received: from 87-207-113-141.dynamic.chello.pl ([87.207.113.141]:45882
	helo=tarm.maven.pl)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.73) (envelope-from <arekm@maven.pl>) id 1PyAMD-0006v4-KK
	for xfs@oss.sgi.com; Fri, 11 Mar 2011 22:58:49 +0100
Received: from arekm by tarm.maven.pl with local (Exim 4.74)
	(envelope-from <arekm@maven.pl>) id 1PyAMC-0001tj-R4
	for xfs@oss.sgi.com; Fri, 11 Mar 2011 22:58:49 +0100
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: 2.6.37: mount with quota eats all available memory
Date: Fri, 11 Mar 2011 22:58:48 +0100
MIME-Version: 1.0
Message-Id: <201103112258.48742.arekm@maven.pl>
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
To: xfs@oss.sgi.com

CkkgaGF2ZSBhIG1hY2hpbmUgd2l0aCA0R0IsIHJ1bm5pbmcgNjRiaXQgMi42LjM3LCB4ZnMgb24g
dG9wIG9mIHNvZnQgcmFpZDUuCgpSZWNlbnRseSBhZnRlciB1c2luZyB4ZnNfZnNyIChhbmQgZ2V0
dGluZyBhIG9vcHMpIGhhZCB0byBkbyB4ZnNfcmVwYWlyIGFuZCBub3cgCkknbSBubyBsb25nZXIg
YWJsZSB0byBtb3VudCB0aGlzIGZpbGVzeXN0ZW0gd2l0aCB1c3JxdW90YSBhbmQgZ3JwcXVvdGEu
Cgp4ZnMgZWF0cyBhbGwgcmFtLCBmcm9tIHNsYWJ0b3A6CjM3NTYzODAgMzc1NjM4MCAxMDAlICAg
IDEuMDBLIDI0NDY1NSAgICAgICAxNiAgIDM5MTQ0ODBLIHhmc19pbm9kZQoyNTE3MTIgMjUxNzEx
ICA5OSUgICAgMC4wNksgICAzOTMzICAgICAgIDY0ICAgICAxNTczMksga21hbGxvYy02NAoxMTg0
ODIgMTE0Mjg3ICA5NiUgICAgMC41NUsgICA0MjMzICAgICAgIDI4ICAgICA2NzcyOEsgcmFkaXhf
dHJlZV9ub2RlCiA4ODc2OCAgODg3MTEgIDk5JSAgICAwLjEySyAgIDI3NzQgICAgICAgMzIgICAg
IDExMDk2SyBrbWFsbG9jLTEyOAogMjg3MTMgIDI4NzEzIDEwMCUgICAgMC4wOEsgICAgNTYzICAg
ICAgIDUxICAgICAgMjI1Mksgc3lzZnNfZGlyX2NhY2hlCiAyMjk3NCAgMjI5NzMgIDk5JSAgICAw
LjA5SyAgICA1NDcgICAgICAgNDIgICAgICAyMTg4SyBrbWFsbG9jLTk2CiAgOTc3NiAgIDk3NzYg
MTAwJSAgICAwLjI1SyAgICA2MTEgICAgICAgMTYgICAgICAyNDQ0SyBrbWFsbG9jLTI1NgogIDc3
OTEgICA3NzkxIDEwMCUgICAgMC4xOUsgICAgMzcxICAgICAgIDIxICAgICAgMTQ4NEsga21hbGxv
Yy0xOTIKICA3MTY4ICAgNzA5NyAgOTklICAgIDAuMDFLICAgICAxNCAgICAgIDUxMiAgICAgICAg
NTZLIGttYWxsb2MtOAoKbWFjaGluZSBpcyBub3QgcmVzcG9uc2libGUgYW55bW9yZSwgeGZzIGF0
ZSBhbGwgcmFtCgpJZiBJIGRvbid0IHVzZSB1c3IvZ3JwIHF1b3RhIHRoZW4gZmlsZXN5c3RlbSBt
b3VudHMgd2l0aG91dCBhIHByb2JsZW0uCgpXaGF0IGFyZSBteSBvcHRpb25zIG5vdz8gSSBuZWVk
IHRoaXMgc3lzdGVtIHJ1bm5pbmcgYWdhaW4gd2l0aCBxdW90YSBidXQgCmxvb3NpbmcgYWxsIHF1
b3RhIGluZm9ybWF0aW9uIGlzIG5vdCBhIHByb2JsZW0gKEkgY2FuIHNldCBpdCBhZ2FpbikuCgot
LSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1h
dmVuLnBsICAgICAgICAgICAgaHR0cDovL2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
