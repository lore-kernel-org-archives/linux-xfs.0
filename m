Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37994 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754160AbeBGATP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Feb 2018 19:19:15 -0500
Received: by mail-oi0-f65.google.com with SMTP id j15so2752631oii.5
        for <linux-xfs@vger.kernel.org>; Tue, 06 Feb 2018 16:19:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180206231915.GA26233@magnolia>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
 <20180201234413.idd27uqzqbg54ddk@destitution> <20180202004332.GZ4849@magnolia>
 <d267ed33-950e-a5c5-73ce-36da6c940513@intel.com> <20180206231915.GA26233@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Feb 2018 16:19:12 -0800
Message-ID: <CAPcyv4jQ+ATdVUdF32+uZwcnTZCQnUSMD1fLg14JrT870jaB7g@mail.gmail.com>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-nvdimm@lists.01.org

On Tue, Feb 6, 2018 at 3:19 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Tue, Feb 06, 2018 at 03:32:00PM -0700, Dave Jiang wrote:
[..]
> The last time I paid much attention to DAX was the thread "re-enable XFS
> per-inode DAX"[1] last September.  Motivating me to merge anything else
> into DAX involves convincing me that we (mm, fs, dax developers) have
> some kind of agreement about what we want the user-visible interfaces to
> DAX to look like.  Namely:
>
> 0. On what level do we allow users / administrators to control usage of
> the dax paths?  Can the hardware convey enough detail to the kernel that
> the kernel can make a reasonable decision on its own whether buffered or
> dax io make more sense?  If so, can we please just have that?  If not,
> why?
>
> 1. If we want to let users override whatever decision the kernel makes,
> how should we do this?  One mount option that applies to everything,
> like ext4?  Inheritable inode flags, like xfs?  Do we have one to force
> it on even if the kernel doesn't want to?  Do we have another to force
> it off even if the kernel wants to?  Do we even want to go down this
> path?  Can we get away with making the answer to Q0 "yes" and then see
> if anyone actually complains about not having fine-grained control?

I think we will always have folks that want to force it on, i.e. the
MAP_SYNC user crowd. However, I think we might have some people what
will complain if they can't force it off. For example, I'm in the
process of killing off support for passing filesystem-dax mappings
through to guests because VFIO has the same "pin pages / fs-blocks
forever" problem as RDMA. Passing page cache through to a guest works
fine and it would be a shame if that silently stopped working in the
future. Given the page pinning constraint I'm not sure we can ever
support dynamically enabling DAX behind the user's back, at least not
until we kill off any "pin pages / fs-blocks forever" users, or
otherwise convert them to take a lease.
