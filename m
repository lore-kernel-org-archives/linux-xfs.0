Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CD247CA0
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 10:49:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3CF8AC001
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 08:49:54 -0700 (PDT)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	pVHIBKuy6ZKgo80U (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2016 08:49:52 -0700 (PDT)
Received: by mail-io0-f176.google.com with SMTP id m79so57145706ioo.3
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 08:49:52 -0700 (PDT)
MIME-Version: 1.0
From: sudip midya <midya.sudip@gmail.com>
Date: Wed, 21 Sep 2016 21:19:51 +0530
Message-ID: <CADccLx9oHDQLDifPAu+tB7pD6OmHu6Mgt7qtMSNtqrgPRNCVGQ@mail.gmail.com>
Subject: [PATCH]remove rcu_lock/unlock around lockless radix_tree_tagged()
Content-Type: multipart/mixed; boundary=001a1140fa66e755c6053d067e25
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
To: xfs@oss.sgi.com, david@fromorbit.com

--001a1140fa66e755c6053d067e25
Content-Type: multipart/alternative; boundary=001a1140fa66e755c1053d067e23

--001a1140fa66e755c1053d067e23
Content-Type: text/plain; charset=UTF-8

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.

	Signed-off-by: Sudip Midya <midya.sudip@gmail.com>

--001a1140fa66e755c1053d067e23
Content-Type: text/html; charset=UTF-8

<div dir="ltr"><pre>        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.

	Signed-off-by: Sudip Midya &lt;<a href="mailto:midya.sudip@gmail.com">midya.sudip@gmail.com</a>&gt;</pre></div>

--001a1140fa66e755c1053d067e23--

--001a1140fa66e755c6053d067e25
Content-Type: text/x-patch; charset=US-ASCII; name="radix_tree_tagged.patch"
Content-Disposition: attachment; filename="radix_tree_tagged.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_itd39ydb0

Y29tbWl0IDBlMGFjOWQ5ODExYWRkOWQzYTQ4OTI4ODhjNTBmOTlmM2ZmODBkZDYKQXV0aG9yOiBT
dWRpcCBNaWR5YSA8U3VkaXAuTWlkeWFAYXAuc29ueS5jb20+CkRhdGU6ICAgV2VkIFNlcCAyMSAy
MTowNTo0MiAyMDE2ICswNTMwCgogICAgbW06IHJlbW92ZSB1bm5lY2Vzc2FyeSByY3VfbG9jay91
bmxvY2sgYXJvdW5kIHJhZGl4X3RyZWVfdGFnZ2VkLgogICAgVGhlIGZ1bmN0aW9uIHF1ZXVlX2Rl
bGF5ZWRfd29yayBpcyBhbHJlYWR5IHByb3RlY3RlZCB3aXRoCiAgICBpbnRlcnJ1cHRzIGRpc2Fi
bGVkLCBubyBuZWVkIHRvIGFkZCB0aGUgcmN1X2xvY2sKCmRpZmYgLS1naXQgYS9mcy94ZnMveGZz
X2ljYWNoZS5jIGIvZnMveGZzL3hmc19pY2FjaGUuYwppbmRleCBmYjM5YTY2Li44ODdjODY4IDEw
MDY0NAotLS0gYS9mcy94ZnMveGZzX2ljYWNoZS5jCisrKyBiL2ZzL3hmcy94ZnNfaWNhY2hlLmMK
QEAgLTE1MywxMiArMTUzLDEwIEBAIHhmc19yZWNsYWltX3dvcmtfcXVldWUoCiAJc3RydWN0IHhm
c19tb3VudCAgICAgICAgKm1wKQogewogCi0JcmN1X3JlYWRfbG9jaygpOwogCWlmIChyYWRpeF90
cmVlX3RhZ2dlZCgmbXAtPm1fcGVyYWdfdHJlZSwgWEZTX0lDSV9SRUNMQUlNX1RBRykpIHsKIAkJ
cXVldWVfZGVsYXllZF93b3JrKG1wLT5tX3JlY2xhaW1fd29ya3F1ZXVlLCAmbXAtPm1fcmVjbGFp
bV93b3JrLAogCQkJbXNlY3NfdG9famlmZmllcyh4ZnNfc3luY2RfY2VudGlzZWNzIC8gNiAqIDEw
KSk7CiAJfQotCXJjdV9yZWFkX3VubG9jaygpOwogfQogCiAvKgo=
--001a1140fa66e755c6053d067e25
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--001a1140fa66e755c6053d067e25--
