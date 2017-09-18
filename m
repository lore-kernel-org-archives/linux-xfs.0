Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbdIROW6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 10:22:58 -0400
Date: Mon, 18 Sep 2017 16:23:08 +0200
From: gregkh <gregkh@linuxfoundation.org>
Subject: Re: stable-rc build: 6 warnings 0 failures
 (stable-rc/v4.9.50-79-g8d96ea4)
Message-ID: <20170918142308.GB12458@kroah.com>
References: <59bfa6b6.4c4b650a.a3838.4576@mx.google.com>
 <CAK8P3a2xEraOhuD4mpwWsV5evij+vNiPZwO4Kr7koqzm5enztw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2xEraOhuD4mpwWsV5evij+vNiPZwO4Kr7koqzm5enztw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof's autobuilder <build@lixom.net>, Olof Johansson <olof@lixom.net>, Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, stable <stable@vger.kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Sep 18, 2017 at 04:12:35PM +0200, Arnd Bergmann wrote:
> On Mon, Sep 18, 2017 at 12:57 PM, Olof's autobuilder <build@lixom.net> wrote:
> > Here are the build results from automated periodic testing.
> >
> > Warnings:
> >
> >       2 fs/xfs/xfs_buf_item.c:573:7: warning: unused variable 'ordered' [-Wunused-variable]
> 
> This is evidently from the backport of
> 
> 351652421e41 ("xfs: remove unnecessary dirty bli format check for ordered bufs")
> 
> It was fixed upstream in
> 
> 7bf7a193a90c ("xfs: fix compiler warnings")
> 
> which contains a few other fixes as well. I have verified that all five
> trivial changes in the fixup patch should be backported into v4.9-stable
> as well.
> 
> >       4 net/ipv6/route.c:1270:6: warning: 'rt_cookie' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> Introduced in the backport of
> c5cff8561d2d ("ipv6: add rcu grace period before freeing fib6_node")
> Fixed in
> 3614364527da ("ipv6: Fix may be used uninitialized warning in rt6_check")
> 
> Please backport both fixups.

Both now backported, thanks for letting me know.

greg k-h
