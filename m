Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B094B7F50
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 07:08:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F309304032
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 05:08:21 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id ylMFD4LQE8sLohFD
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2015 05:08:15 -0800 (PST)
Received: by wmww144 with SMTP id w144so85885721wmw.0
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2015 05:08:15 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: AIO read returns negative number for bytes read
Message-ID: <564883BD.8070607@scylladb.com>
Date: Sun, 15 Nov 2015 15:08:13 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000802080702020200030301"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-aio@kvack.org

This is a multi-part message in MIME format.
--------------000802080702020200030301
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Due to a bug in my program, I initiated a read beyond eof. Specifically, 
the file size is 13002 bytes and the read offset is 13312 (0x3400).

I would expect such a read to return 0 bytes read, but io_getevents 
returns -310, which is suspiciously equal to (13002 - 13312).

I attach a reproducer.

4.2.5-201.fc22.x86_64

Are my expectations incorrect, or is this a bug in aio or xfs?

--------------000802080702020200030301
Content-Type: text/plain; charset=UTF-8;
 name="aio_read_fails.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="aio_read_fails.c"

I2RlZmluZSBfR05VX1NPVVJDRQoKI2luY2x1ZGUgPGxpYmFpby5oPgojaW5jbHVkZSA8YXNz
ZXJ0Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5j
bHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3lzL3N0YXQu
aD4KI2luY2x1ZGUgPGZjbnRsLmg+CgppbnQgbWFpbihpbnQgYWMsIGNoYXIqKiBhdikgewog
IGludCBmZDsKICBjaGFyKiBidWY7CiAgaW9fY29udGV4dF90IGlvYyA9IE5VTEw7CiAgaW50
IHI7CiAgc3RydWN0IGlvY2IgaW9jYjsKICBzdHJ1Y3QgaW9jYiAqaW9jYnBbMV07CiAgc3Ry
dWN0IGlvX2V2ZW50IGlvZXY7CgogIGJ1ZiA9IGFsaWduZWRfYWxsb2MoNDA5NiwgNDA5Nio0
KTsKICBhc3NlcnQoYnVmKTsKICByID0gaW9fc2V0dXAoMSwgJmlvYyk7CiAgYXNzZXJ0KHIg
PT0gMCk7CiAgZmQgPSBvcGVuKCJ0bXAudG1wIiwgT19SRFdSIHwgT19DUkVBVCB8IE9fRElS
RUNULCAwNjAwKTsKICBhc3NlcnQoZmQgPj0gMCk7CiAgaW9fcHJlcF9wd3JpdGUoJmlvY2Is
IGZkLCBidWYsIDQwOTYqNCwgMCk7CiAgaW9jYnBbMF0gPSAmaW9jYjsKICByID0gaW9fc3Vi
bWl0KGlvYywgMSwgaW9jYnApOwogIGFzc2VydChyID09IDEpOwogIHIgPSBpb19nZXRldmVu
dHMoaW9jLCAxLCAxLCAmaW9ldiwgTlVMTCk7CiAgYXNzZXJ0KHIgPT0gMSk7CiAgYXNzZXJ0
KGlvZXYucmVzID09IDQqNDA5Nik7CiAgZnRydW5jYXRlKGZkLCAxMzAwMik7CiAgaW9fcHJl
cF9wcmVhZCgmaW9jYiwgZmQsIGJ1ZiwgODE5MiwgMTMzMTIpOwogIHIgPSBpb19zdWJtaXQo
aW9jLCAxLCBpb2NicCk7CiAgYXNzZXJ0KHIgPT0gMSk7CiAgciA9IGlvX2dldGV2ZW50cyhp
b2MsIDEsIDEsICZpb2V2LCBOVUxMKTsKICBhc3NlcnQociA9PSAxKTsKICBwcmludGYoInJl
YWQgcmVzdWx0OiAlZFxuIiwgKGludClpb2V2LnJlcyk7CiAgcmV0dXJuIDA7Cn0K
--------------000802080702020200030301
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000802080702020200030301--
