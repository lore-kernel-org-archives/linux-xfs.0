Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outprodmail01.cc.columbia.edu ([128.59.72.39]:56196 "EHLO
        outprodmail01.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751290AbdHVVKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 17:10:23 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v7ML88Fq039149
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 17:10:22 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id 3F12F80
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 17:10:22 -0400 (EDT)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu [128.59.72.16])
        by hazelnut (Postfix) with ESMTP id 1D9A47E
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 17:10:22 -0400 (EDT)
Received: from mail-wm0-f70.google.com (mail-wm0-f70.google.com [74.125.82.70])
        by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v7MLALtq007579
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 17:10:21 -0400
Received: by mail-wm0-f70.google.com with SMTP id x6so307061wme.4
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 14:10:21 -0700 (PDT)
MIME-Version: 1.0
From: Ruoxin Jiang <rj2394@columbia.edu>
Date: Tue, 22 Aug 2017 17:10:19 -0400
Message-ID: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
Subject: XFS Bug Report
Content-Type: multipart/mixed; boundary="089e0829e1fcda06aa05575e0599"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Suman Jana <sumanj@gmail.com>

--089e0829e1fcda06aa05575e0599
Content-Type: text/plain; charset="UTF-8"

Hello,

We are researchers from Columbia University, New York. As part of our
current research we have run into some issues using xfs filesystem.
For example, we encountered a case where the setuid bit of a modified
executable was not removed as desired.

We have attached three cases, one involving the setuid bit in
directory 1, and a data corruption issue in directory 2. In directory
3 is a semantic discrepancy we discovered between xfs and other
popular filesystems (ext4/btrfs) regarding the setgid bit.

In each directory, you will find a Readme describing the issue and
pointing to the code that may lead to the issue. For your convenience,
we also included test programs (min.cpp) and instructions in Readme to
help reproduce the issues.

We tried to report them on bugzilla@oss.sig.com but the website seems
to be down. We would appreciate very much if you could confirm the
three cases at your conveniences.


Thanks,
Amy

--089e0829e1fcda06aa05575e0599
Content-Type: application/x-gzip; name="xfs_issues.tar.gz"
Content-Disposition: attachment; filename="xfs_issues.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j6o2y3b40

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
--089e0829e1fcda06aa05575e0599--

