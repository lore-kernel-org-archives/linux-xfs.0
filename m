Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34859 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdKVMwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 07:52:41 -0500
Received: by mail-ua0-f171.google.com with SMTP id 108so10529490uaf.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 04:52:41 -0800 (PST)
MIME-Version: 1.0
From: Romeo Theriault <romeotheriault@gmail.com>
Date: Wed, 22 Nov 2017 02:52:40 -1000
Message-ID: <CAL4D3QFpES1U1pCQ3md2Jiiqm0E5L5KhG4T77gnyEiom-EZBgw@mail.gmail.com>
Subject: Display project quotas without
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello, Is it possible to display project quotas without the
/etc/projid file? I have a need to display the quotas without this (or
the /etc/project file) and just display the quotas with the id's.

For example,

xfs_quota -x -c 'report -p'

displays nothing until I add a /etc/projid file.

Anyway around this? Using xfs_db or xfs_io somehow?

Thanks,

-- 
Romeo Theriault
