Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35008 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbcL2XyN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Dec 2016 18:54:13 -0500
Received: by mail-io0-f195.google.com with SMTP id f73so46961446ioe.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Dec 2016 15:54:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161228083420.GZ1859@eguan.usersys.redhat.com>
References: <1482202286-8390-1-git-send-email-deepa.kernel@gmail.com> <20161228083420.GZ1859@eguan.usersys.redhat.com>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Thu, 29 Dec 2016 15:54:12 -0800
Message-ID: <CABeXuvq4EZS=eZsyp2y8B7zMPw0FEhuNziY9-QA8k16py++urg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: implement 'utimes' command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>

>> Add the utimes command to provide a way to utilize
>> the futimens C library call. This is the
>> interface to the utimensat system call, which updates
>> the mtime and atime of a file.
>>
>> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
>> ---
>> Changes since v1:
>> * changed error return values
>> * removed redundant roff formatting directive
>> * removed unneeded argument count check
>>
>>  include/input.h   |  1 +
>>  io/Makefile       |  2 +-
>>  io/init.c         |  1 +
>>  io/io.h           |  1 +
>>  io/utimes.c       | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  libxcmd/input.c   | 22 +++++++++++++++
>>  man/man8/xfs_io.8 | 11 ++++++++
>>  7 files changed, 118 insertions(+), 1 deletion(-)
>>  create mode 100755 io/utimes.c
>>  mode change 100644 => 100755 libxcmd/input.c
>
> Just one nit, I think c files should not have "x" in file modes.

Yes, my bad.
Will post an update with this fixed.

Thanks,
Deepa
