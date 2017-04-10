Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35932 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdDJJYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 05:24:14 -0400
Received: by mail-lf0-f43.google.com with SMTP id s141so31734369lfe.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2017 02:24:13 -0700 (PDT)
MIME-Version: 1.0
From: Avi Kivity <avi@scylladb.com>
Date: Mon, 10 Apr 2017 12:23:51 +0300
Message-ID: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
Subject: filesystem dead, xfs_repair won't help
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Today my kernel complained that in memory metadata is corrupt and
asked that I run xfs_repair.  But xfs_repair doesn't like the
superblock and isn't able to find a secondary superblock.

Latest Fedora 25 kernel, new Intel NVMe drive (worked for a few weeks
without issue).

Anything I can do to recover the data?
