Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:38112 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753501AbeBVLb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 06:31:29 -0500
Received: by mail-ua0-f171.google.com with SMTP id e25so3073637uan.5
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 03:31:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180222102249.kpaqec37ejrrmown@odin.usersys.redhat.com>
References: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
 <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com> <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
 <20180221175540.618eda28@harpe.intellique.com> <20180222102249.kpaqec37ejrrmown@odin.usersys.redhat.com>
From: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>
Date: Thu, 22 Feb 2018 12:31:28 +0100
Message-ID: <CAJbUkCTeO6_0Xu5-UbuF_tj1GP2PZF6YP91BsKJuQ=T65cdj9w@mail.gmail.com>
Subject: Re: XFS corruption of in-memory data detected with KVM
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>, Andrea Mazzocchi <mazzocchiandrea24@gmail.com>, linux-xfs@vger.kernel.org

3.10.0-693.17.1.el7 means Enterprise Linux 7, right?
Enterprise Linux 7 uses Linux kernel 3.10.0-123
(https://en.wikipedia.org/wiki/Red_Hat_Enterprise_Linux#RHEL_7)
and even if it backports important things, I saw that kernel 4.9 and
4.14 introduces
various bug fixes and improvements about XFS file system that may
greatly help us .

In 3.10.0-693.17.1.el7 changelog there are at least 1400 entries for "XFS"
(http://rpmfind.net/linux/RPM/centos/updates/7.4.1708/x86_64/Packages/kernel-devel-3.10.0-693.17.1.el7.x86_64.html):
how could I see what kernel would be the best?
Do I have to manually check the XFS bug fixes between 3.10.0-693.17.1.el7
and 4.14.20 (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5791577963426c5a2db51fff57e9fcd72061e2c3)
to see what best suits us?
We do not know what caused the crash, so we do not know what bug had
to be fixed and which kernel actually fixed it...
