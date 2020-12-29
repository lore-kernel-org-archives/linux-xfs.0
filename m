Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,STOX_BOUND_090909_B,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC90C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Dec 2020 12:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EAE220825
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Dec 2020 12:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgL2M4p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Dec 2020 07:56:45 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:42518 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgL2M4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Dec 2020 07:56:22 -0500
X-Greylist: delayed 1792 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2020 07:56:22 EST
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 0BTCPmwP075071
        for <linux-xfs@vger.kernel.org>; Tue, 29 Dec 2020 04:25:50 -0800
Message-ID: <5FEB204B.9090109@tlinx.org>
Date:   Tue, 29 Dec 2020 04:25:47 -0800
From:   "L.A. Walsh" <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     xfs-oss <linux-xfs@vger.kernel.org>
Subject: suggested patch to allow user to access their own file...
Content-Type: multipart/mixed;
 boundary="------------040604090003060508050301"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------040604090003060508050301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

xfs_io checks for CAP_SYS_ADMIN in order to open a
file_by_inode -- however, if the file one is opening
is owned by the user performing the call, the call should
not fail.

(i.e. it opens the user's own file).

patch against 5.10.2 is attached.

It gets rid of some unnecessary error messages if you
run xfs_restore to restore one of your own files.


--------------040604090003060508050301
Content-Type: text/x-diff;
 name="xfs_ioctl-perm.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="xfs_ioctl-perm.diff"

LS0tIGZzL3hmcy94ZnNfaW9jdGwuYwkyMDIwLTEyLTIyIDIxOjExOjAyLjAwMDAwMDAwMCAt
MDgwMAorKysgZnMveGZzL3hmc19pb2N0bC5jCTIwMjAtMTItMjkgMDQ6MTQ6NDguNjgxMTAy
ODA0IC0wODAwCkBAIC0xOTQsMTUgKzE5NCwyMSBAQAogCXN0cnVjdCBkZW50cnkJCSpkZW50
cnk7CiAJZm1vZGVfdAkJCWZtb2RlOwogCXN0cnVjdCBwYXRoCQlwYXRoOworCWJvb2wgY29u
ZGl0aW9uYWxfcGVybSA9IDA7CiAKLQlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCi0J
CXJldHVybiAtRVBFUk07CisJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pKSBjb25kaXRp
b25hbF9wZXJtPTE7CiAKIAlkZW50cnkgPSB4ZnNfaGFuZGxlcmVxX3RvX2RlbnRyeShwYXJm
aWxwLCBocmVxKTsKIAlpZiAoSVNfRVJSKGRlbnRyeSkpCiAJCXJldHVybiBQVFJfRVJSKGRl
bnRyeSk7CiAJaW5vZGUgPSBkX2lub2RlKGRlbnRyeSk7CiAKKwkvKiBvbmx5IGFsbG93IHVz
ZXIgYWNjZXNzIHRvIHRoZWlyIG93biBmaWxlICovCisJaWYgKGNvbmRpdGlvbmFsX3Blcm0g
JiYgIWlub2RlX293bmVyX29yX2NhcGFibGUoaW5vZGUpKSB7CisJCWVycm9yID0gLUVQRVJN
OworCQlnb3RvIG91dF9kcHV0OworCX0KKwogCS8qIFJlc3RyaWN0IHhmc19vcGVuX2J5X2hh
bmRsZSB0byBkaXJlY3RvcmllcyAmIHJlZ3VsYXIgZmlsZXMuICovCiAJaWYgKCEoU19JU1JF
Ryhpbm9kZS0+aV9tb2RlKSB8fCBTX0lTRElSKGlub2RlLT5pX21vZGUpKSkgewogCQllcnJv
ciA9IC1FUEVSTTsK
--------------040604090003060508050301--
