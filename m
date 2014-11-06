Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D9E47F4E
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 07:03:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0DA8AC006
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 05:03:47 -0800 (PST)
Received: from BLU004-OMC4S18.hotmail.com (blu004-omc4s18.hotmail.com
	[65.55.111.157]) by cuda.sgi.com with ESMTP id 7MKEHEJbZtatV0cy
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Nov 2014 05:03:45 -0800 (PST)
Message-ID: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
From: GuangYang <yguang11@outlook.com>
Subject: EIO and data corruption on XFS file system
Date: Thu, 6 Nov 2014 13:03:45 +0000
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6180164893819069348=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6180164893819069348==
Content-Type: multipart/alternative;
	boundary="_defba118-9c79-4dd2-8eca-ac980294f36b_"

--_defba118-9c79-4dd2-8eca-ac980294f36b_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sV2hpbGUgd29ya2luZyBvbiB0aGUgc3RvcmFnZSBzeXN0ZW0sIEkgZ290IG9uZSBxdWVz
dGlvbiBpbiB0ZXJtcyBvZiB0aGUgWEZTIHV0aWxpdGllcyB0byBmaXggZmlsZSBzeXN0ZW0gY29y
cnVwdGlvbi4gQmFzaWNhbGx5LCBvdXIgc3RvcmFnZSBzeXN0ZW0gcHV0IDMgY29waWVzIG9mIGRh
dGEgYW5kIHRoZSBzeXN0ZW0gd291bGQgZGV0ZWN0IGRhdGEgaW5jb25zaXN0ZW5jeSBvbiByZWd1
bGFyIGJhc2lzLCB0aGVyZSBhcmUgdHdvIHBhdHRlcm5zIHdlIG9ic2VydmVkIHNvIGZhcjogMSkg
dGhlIGRhdGEgaXMgY29ycnVwdGVkIHdoaWNoIHJlc3VsdCBpbiBhbiBFSU8sIDIpIGRhdGEgaXMg
c3RpbGwgYWNjZXNzaWJsZSBidXQgdGhlIGNvbnRlbnQgaXMgY2hhbmdlZC4NCkkgYW0gd29uZGVy
aW5nIHRoZSB3YXkgdG8gZml4IHN1Y2ggaXNzdWVzIGZyb20gZmlsZSBzeXN0ZW0ncyBwZXJzcGVj
dGl2ZSwgZG8gd2UgZXhwZWN0IGhhcmR3YXJlIGZhaWx1cmUgZm9yIGJvdGggY2FzZXMgb3Igc29t
ZSB4ZnMgcmVwYWlyaW5nIHRvb2xzIGNvdWxkIGhlbHAgZm9yIHN1Y2ggY2FzZT8NClRoYW5rcyxH
dWFuZyAJCSAJICAgCQkgIA==

--_defba118-9c79-4dd2-8eca-ac980294f36b_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: base64

PGh0bWw+DQo8aGVhZD4NCjxzdHlsZT48IS0tDQouaG1tZXNzYWdlIFANCnsNCm1hcmdpbjowcHg7
DQpwYWRkaW5nOjBweA0KfQ0KYm9keS5obW1lc3NhZ2UNCnsNCmZvbnQtc2l6ZTogMTJwdDsNCmZv
bnQtZmFtaWx5Os6iyO3RxbraDQp9DQotLT48L3N0eWxlPjwvaGVhZD4NCjxib2R5IGNsYXNzPSdo
bW1lc3NhZ2UnPjxkaXYgZGlyPSdsdHInPkhlbGxvLDxkaXY+V2hpbGUgd29ya2luZyBvbiB0aGUg
c3RvcmFnZSBzeXN0ZW0sIEkgZ290IG9uZSBxdWVzdGlvbiBpbiB0ZXJtcyBvZiB0aGUgWEZTIHV0
aWxpdGllcyB0byBmaXggZmlsZSBzeXN0ZW0gY29ycnVwdGlvbi4gQmFzaWNhbGx5LCBvdXIgc3Rv
cmFnZSBzeXN0ZW0gcHV0IDMgY29waWVzIG9mIGRhdGEgYW5kIHRoZSBzeXN0ZW0gd291bGQgZGV0
ZWN0IGRhdGEgaW5jb25zaXN0ZW5jeSBvbiByZWd1bGFyIGJhc2lzLCB0aGVyZSBhcmUgdHdvIHBh
dHRlcm5zIHdlIG9ic2VydmVkIHNvIGZhcjogMSkgdGhlIGRhdGEgaXMgY29ycnVwdGVkIHdoaWNo
IHJlc3VsdCBpbiBhbiBFSU8sIDIpIGRhdGEgaXMgc3RpbGwgYWNjZXNzaWJsZSBidXQgdGhlIGNv
bnRlbnQgaXMgY2hhbmdlZC48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkkgYW0gd29uZGVyaW5n
IHRoZSB3YXkgdG8gZml4IHN1Y2ggaXNzdWVzIGZyb20gZmlsZSBzeXN0ZW0ncyBwZXJzcGVjdGl2
ZSwgZG8gd2UgZXhwZWN0IGhhcmR3YXJlIGZhaWx1cmUgZm9yIGJvdGggY2FzZXMgb3Igc29tZSB4
ZnMgcmVwYWlyaW5nIHRvb2xzIGNvdWxkIGhlbHAgZm9yIHN1Y2ggY2FzZT88L2Rpdj48ZGl2Pjxi
cj48L2Rpdj48ZGl2PlRoYW5rcyw8L2Rpdj48ZGl2Pkd1YW5nPC9kaXY+IAkJIAkgICAJCSAgPC9k
aXY+PC9ib2R5Pg0KPC9odG1sPg==

--_defba118-9c79-4dd2-8eca-ac980294f36b_--


--===============6180164893819069348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6180164893819069348==--
