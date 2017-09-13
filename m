Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35047 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdIMJNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 05:13:15 -0400
Received: by mail-qk0-f176.google.com with SMTP id r141so30310852qke.2
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2017 02:13:14 -0700 (PDT)
MIME-Version: 1.0
From: peykasa Admin <peykasa.xfs@gmail.com>
Date: Wed, 13 Sep 2017 13:43:13 +0430
Message-ID: <CAF5xGhqsh9XDGS3hiQrxJ0fdH1tPTKp5B1GR4hvDDzGGLUkH4Q@mail.gmail.com>
Subject: xfs-quota reports used space incorrectly
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi

We face a problem with xfs quota

SENARIO
we have a file sharing for some users. Each user has a sharing folder.
Each user has a 1G limitation for his folder. the limitation is created via
xfs quota.

PROBLEM
For some users, the used space reported by xfs quota is not equal to the
real used space.
xfs quota reports the space is full (1024 M) and nothing can be moved there
but the real used space is less than that value.


We tested many solution and also the xfs_repair, but it didn't resolve.

Sincerely yours
Arian Rmz
