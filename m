Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:32788 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdFHPmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2017 11:42:12 -0400
Received: by mail-vk0-f54.google.com with SMTP id p62so18542456vkp.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jun 2017 08:42:12 -0700 (PDT)
MIME-Version: 1.0
From: Sweet Tea Dorminy <sweettea@permabit.com>
Date: Thu, 8 Jun 2017 11:42:11 -0400
Message-ID: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
Subject: XFS journal write ordering constraints?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Greetings;

When using XFS with a 1k block size atop our device, we regularly get
"log record CRC mismatch"es when mounting XFS after a crash, and we
are attempting to understand why. We are using RHEL7.3 with its kernel
3.10.0-514.10.2.el7.x86_64, xfsprogs version 4.5.0.

Tracing indicates the following situation occurs:
       Some pair of consecutive locations contains data A1 and B1, respectively.
       The XFS journal issues new writes to those locations,
containing data A2 and B2.
       The write of B' finishes, but A' is still outstanding at the
time of the crash.
       Crash occurs. The data on disk is A1 and B2, respectively.
       XFS fails to mount, complaining that the checksum mismatches.

Does XFS expect sequentially issued journal IO to be committed to disk
in the order of issuance due to the use of FUA?

Thanks!

Sweet Tea Dorminy
Permabit Technology Corporation
Cambridge, MA
