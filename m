Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33375 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbdIROMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 10:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <59bfa6b6.4c4b650a.a3838.4576@mx.google.com>
References: <59bfa6b6.4c4b650a.a3838.4576@mx.google.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 18 Sep 2017 16:12:35 +0200
Message-ID: <CAK8P3a2xEraOhuD4mpwWsV5evij+vNiPZwO4Kr7koqzm5enztw@mail.gmail.com>
Subject: Re: stable-rc build: 6 warnings 0 failures (stable-rc/v4.9.50-79-g8d96ea4)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Olof's autobuilder <build@lixom.net>
Cc: Olof Johansson <olof@lixom.net>, Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, gregkh <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Sep 18, 2017 at 12:57 PM, Olof's autobuilder <build@lixom.net> wrote:
> Here are the build results from automated periodic testing.
>
> Warnings:
>
>       2 fs/xfs/xfs_buf_item.c:573:7: warning: unused variable 'ordered' [-Wunused-variable]

This is evidently from the backport of

351652421e41 ("xfs: remove unnecessary dirty bli format check for ordered bufs")

It was fixed upstream in

7bf7a193a90c ("xfs: fix compiler warnings")

which contains a few other fixes as well. I have verified that all five
trivial changes in the fixup patch should be backported into v4.9-stable
as well.

>       4 net/ipv6/route.c:1270:6: warning: 'rt_cookie' may be used uninitialized in this function [-Wmaybe-uninitialized]

Introduced in the backport of
c5cff8561d2d ("ipv6: add rcu grace period before freeing fib6_node")
Fixed in
3614364527da ("ipv6: Fix may be used uninitialized warning in rt6_check")

Please backport both fixups.

      Arnd
