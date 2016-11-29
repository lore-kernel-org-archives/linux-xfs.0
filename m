Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35127 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757294AbcK2NTI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 08:19:08 -0500
MIME-Version: 1.0
In-Reply-To: <20161129120405.GA11089@infradead.org>
References: <1480418228.2258.28.camel@pengutronix.de> <20161129120405.GA11089@infradead.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 29 Nov 2016 14:19:07 +0100
Message-ID: <CAOi1vP8Od6RgNchXGsXP3gs-6P0x9ZTS7dVfpsmfuDMZm2ZyHg@mail.gmail.com>
Subject: Re: XFS on RBD deadlock
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lucas Stach <l.stach@pengutronix.de>, Ceph Development <ceph-devel@vger.kernel.org>, linux-xfs@vger.kernel.org, Michael Olbrich <m.olbrich@pengutronix.de>, =?UTF-8?B?QmrDtnJuIEzDpHNzaWc=?= <b.laessig@pengutronix.de>

On Tue, Nov 29, 2016 at 1:04 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Nov 29, 2016 at 12:17:08PM +0100, Lucas Stach wrote:
>> 2. RBD worker is trying to handle the XFS block request, but the
>> involved crypto code recurses into the XFS superblock shrinker, as it's
>> trying to allocate memory with GFP_KERNEL in __crypto_alloc_tfm.
>
> And that's where the issues start - crypto_alloc_skcipher and friends
> are not intended to be called from the writeback path.

Yeah, and to worsen things it's allocated and then destroyed on *every*
write.  I'm in the process of re-writing that code for CONFIG_VMAP_STACK
and will look into fixing this as well.

In the meantime, disabling cephx message signing should take that
allocation out of the way.

Thanks,

                Ilya
