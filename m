Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33776 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeCNPuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 11:50:04 -0400
Received: by mail-oi0-f43.google.com with SMTP id e9so3107817oii.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 08:50:04 -0700 (PDT)
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Mar 2018 16:50:02 +0100
Message-ID: <CAJfpegs=RenwFojwAze_y7WF3hwiNu-+5qDw_wyT=o0M063HkQ@mail.gmail.com>
Subject: generic/127 failure on xfs with hacked fsx
Content-Type: multipart/mixed; boundary="001a113df09011f45e0567615496"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, fstests <fstests@vger.kernel.org>

--001a113df09011f45e0567615496
Content-Type: text/plain; charset="UTF-8"

While testing overlayfs I found something which appears to be an
unwanted side effect of xfs_release().

Apply the attached patch to xfstests and run generic/127.

Result is:

    +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 fsx_std_mmap
    +Mapped Read: non-zero data past EOF (0x8aa1) page offset 0xaa2 is 0xa091
    +LOG DUMP (70315 total operations):

Thanks,
Miklos

--001a113df09011f45e0567615496
Content-Type: text/x-patch; charset="US-ASCII"; name="fsx-trigger-xfs-bug.patch"
Content-Disposition: attachment; filename="fsx-trigger-xfs-bug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jer9gzjz0

LS0tCiBsdHAvZnN4LmMgfCAgICA5ICsrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0
aW9ucygrKQoKLS0tIGEvbHRwL2ZzeC5jCisrKyBiL2x0cC9mc3guYwpAQCAtNjQ3LDYgKzY0Nywx
NCBAQCBjaGVja190cnVuY19oYWNrKHZvaWQpCiAJfQogfQogCitzdGF0aWMgdm9pZCBvcGVuY2xv
c2UoaW50IGZkKQoreworCWNoYXIgcGF0aFszMl07CisKKwlzcHJpbnRmKHBhdGgsICIvcHJvYy9z
ZWxmL2ZkLyVpIiwgZmQpOworCWNsb3NlKG9wZW4ocGF0aCwgT19SRE9OTFkpKTsKK30KKwogdm9p
ZAogZG9mbHVzaCh1bnNpZ25lZCBvZmZzZXQsIHVuc2lnbmVkIHNpemUpCiB7CkBAIC03OTksNiAr
ODA3LDcgQEAgZG9tYXByZWFkKHVuc2lnbmVkIG9mZnNldCwgdW5zaWduZWQgc2l6ZQogCSAgICAg
ICAgcHJ0ZXJyKCJkb21hcHJlYWQ6IG1tYXAiKTsKIAkJcmVwb3J0X2ZhaWx1cmUoMTkwKTsKIAl9
CisJb3BlbmNsb3NlKGZkKTsKIAltZW1jcHkodGVtcF9idWYsIHAgKyBwZ19vZmZzZXQsIHNpemUp
OwogCiAJY2hlY2tfZW9mcGFnZSgiUmVhZCIsIG9mZnNldCwgcCwgc2l6ZSk7Cg==
--001a113df09011f45e0567615496--
