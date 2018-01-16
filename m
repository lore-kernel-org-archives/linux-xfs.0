Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:42285 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAPEtE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 23:49:04 -0500
Received: by mail-ot0-f194.google.com with SMTP id s3so12526356otc.9
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2018 20:49:03 -0800 (PST)
MIME-Version: 1.0
From: Philipp Schrader <philipp@peloton-tech.com>
Date: Mon, 15 Jan 2018 20:49:02 -0800
Message-ID: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
Subject: Reproducible XFS filesystem artifacts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>

Hi all,

We're currently trying to clean up our build processes to make sure
that all binary output is reproducible (along the lines of
https://reproducible-builds.org/).

A few of our build artifacts are filesystem images. We have VFAT and
XFS images. They represent the system updates for units in the field
and at developers' desks.

We're trying to make these images reproducible and I'm in need of some
help. As far as I can tell, one of the biggest culprits is VFAT's
"creation time" and XFS' ctime fields.

Example of VFAT's differences:
$ hexdump -C ~/swu-tests/swu1/dvt-controller-kernel.vfat >
~/swu-tests/swu1/dvt-controller-kernel.vfat.dump
$ hexdump -C ~/swu-tests/swu3/dvt-controller-kernel.vfat >
~/swu-tests/swu3/dvt-controller-kernel.vfat.dump
$ diff -u ~/swu-tests/swu1/dvt-controller-kernel.vfat.dump
~/swu-tests/swu3/dvt-controller-kernel.vfat.dump
--- /x1/home/philipp/swu-tests/swu1/dvt-controller-kernel.vfat.dump
 2017-12-28 12:19:57.349880993 -0800
+++ /x1/home/philipp/swu-tests/swu3/dvt-controller-kernel.vfat.dump
 2017-12-28 12:19:50.253881196 -0800
...
@@ -1011,13 +1011,13 @@
 *
 00006200  41 7a 00 49 00 6d 00 61  00 67 00 0f 00 7c 65 00  |Az.I.m.a.g...|e.|
 00006210  00 00 ff ff ff ff ff ff  ff ff 00 00 ff ff ff ff  |................|
-00006220  5a 49 4d 41 47 45 20 20  20 20 20 20 00 00 63 9b  |ZIMAGE      ..c.|
+00006220  5a 49 4d 41 47 45 20 20  20 20 20 20 00 64 d8 95  |ZIMAGE      .d..|
 00006230  9c 4b 9c 4b 00 00 00 00  21 00 03 00 a0 2d 4a 00  |.K.K....!....-J.|
 00006240  42 6f 00 6c 00 6c 00 65  00 72 00 0f 00 67 2d 00  |Bo.l.l.e.r...g-.|
 00006250  64 00 76 00 74 00 2e 00  64 00 00 00 74 00 62 00  |d.v.t...d...t.b.|
...

As per the structure, that's the ctime (creation time) being different.
https://www.kernel.org/doc/Documentation/filesystems/vfat.txt

I've not had much luck digging into the XFS spec to see prove that the
ctime is different, but I'm pretty certain. When I mount the images, I
can see that ctime is different:
$ stat -c %x,%y,%z,%n /mnt/{a,b}/log/syslog
2017-12-28 11:26:53.552000096 -0800,1969-12-31 16:00:00.000000000
-0800,2017-12-28 11:28:50.524000060 -0800,/mnt/a/log/syslog
2017-12-28 10:46:38.739999913 -0800,1969-12-31 16:00:00.000000000
-0800,2017-12-28 10:48:17.180000049 -0800,/mnt/b/log/syslog

As far as I can tell, there are no mount options to null out the ctime
fields. (As an aside I'm curious as to the reason for this).

Is there a tool that lets me null out ctime fields on a XFS filesystem
image? Or maybe is there a library that lets me traverse the file
system and set the fields to zero manually?

Does what I'm asking make sense? I feel like I'm not the first person
to tackle this, but I haven't been lucky with finding anything to
address this.

Thanks,
Phil
