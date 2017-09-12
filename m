Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:37310 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdILMAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2017 08:00:34 -0400
Received: by mail-qk0-f179.google.com with SMTP id b82so24418089qkc.4
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2017 05:00:34 -0700 (PDT)
MIME-Version: 1.0
From: peykasa Admin <peykasa.xfs@gmail.com>
Date: Tue, 12 Sep 2017 16:30:33 +0430
Message-ID: <CAF5xGhpC_k6eexQ_DQU1g5-bF5sdYmdw4EOPtKxW9UrqFJtVWA@mail.gmail.com>
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
