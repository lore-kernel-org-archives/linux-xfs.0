Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50296 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932350AbdHVLKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 07:10:55 -0400
Date: Tue, 22 Aug 2017 13:10:53 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Support for data CRC
Message-ID: <20170822111053.7jypthbydpkn2tj4@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On 2017-08-21 13:52:48 [-0600], Chris Murphy wrote:
> On Mon, Aug 21, 2017 at 1:04 PM, Sebastian Andrzej Siewior
> <sebastian@breakpoint.cc> wrote:
> > Hi,
> >
> > my understanding is that only metadata is protected by CRC in the new
> > on-disk format. Are there any plans to also protect data?
> 
> See dm-integrity, merged as of 4.12 kernel. I haven't seen any
> performance benchmarking so far.

So this ensures integrity with the help of crypto algorithms. This is a
bit much as something like crc32c/crc64 would be sufficient. However
dm-integrity does not provide a way to recover (as far as I can tell).
My idea was that if the "normal" path is faulty (and noticed by the crc
check) it (xfs or the dm layer) would try to read the data via an
alternative path if possible (say on RAID1/5/6).

Sebastian
