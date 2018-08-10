Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38971 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbeHJTFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 15:05:37 -0400
Received: by mail-it0-f44.google.com with SMTP id g141-v6so3441826ita.4
        for <linux-xfs@vger.kernel.org>; Fri, 10 Aug 2018 09:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <41DC519D-83A7-4964-A6C8-B16CFEEDB65F@vt.edu> <20180810092229.rq7m4zdq75tsggqv@mwanda>
 <20180810160931.GF12194@magnolia>
In-Reply-To: <20180810160931.GF12194@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Aug 2018 09:34:51 -0700
Message-ID: <CA+55aFy-zJbZQF6JVfpdy9GJ52wPPMwKK5_M1Zrf_Yg78_o0kg@mail.gmail.com>
Subject: Re: Missing security_inode_readlink() in xfs_file_ioctl()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Tong Zhang <ztong@vt.edu>, linux-xfs <linux-xfs@vger.kernel.org>, security@kernel.org, wenbo.s@samsung.com, ahmedmoneeb@gmail.com

On Fri, Aug 10, 2018 at 9:09 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> IOWs, are there security policies where CAP_SYS_ADMIN isn't a "get
> access to everything" wildcard?  I imagine the answer is "yes" and
> therefore xfs needs the call, but I thought I'd ask first.

I think the answer is "no", at least for filesystems where it allows
you to just remount the filesystem entirely.

These reports are from some automated logic that doesn't take "some
capabilities are more equal than others" into account.

                 Linus
