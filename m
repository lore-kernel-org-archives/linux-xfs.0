Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f176.google.com ([209.85.208.176]:41132 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfBHSkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 13:40:35 -0500
Received: by mail-lj1-f176.google.com with SMTP id f21-v6so2403955ljj.8
        for <linux-xfs@vger.kernel.org>; Fri, 08 Feb 2019 10:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20190207132534.GA2185@justpickone.org>
In-Reply-To: <20190207132534.GA2185@justpickone.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 8 Feb 2019 11:40:20 -0700
Message-ID: <CAJCQCtSxC55X2R--THjrBK=1U4hg1FhB0AQULT3FciAeT8Pp3w@mail.gmail.com>
Subject: Re: is it safe to xfs_repair this volume? do i have a different first step?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David T-G <davidtg@justpickone.org>
Cc: Linux-XFS list <linux-xfs@vger.kernel.org>

On Thu, Feb 7, 2019 at 6:30 AM David T-G <davidtg@justpickone.org> wrote:
>
>   diskfarm:root:4:~> parted /dev/md0 print
>   Error: end of file while reading /dev/md0
>   Retry/Ignore/Cancel? ignore
>   Error: The backup GPT table is corrupt, but the primary appears OK, so that will be used.
[snip]
> when poking, I at first thought that this was a RAID issue, but all of
> the md reports look good and apparently the GPT table issue is common, so
> I'll leave all of that out unless someone asks for it.

A corrupt backup GPT is a huge redflag that there's user confusion,
that has then led to the storage stack itself becoming confused.

Since GPT partitioning an array, in particular with just one
partition, seems unnecessarily complicated and thus pointless; I'm
suspicious that /dev/md0 is not in fact partitioned - that GPT very
well may belong to the first member device of the array. Not the
array. And the reason the backup is "corrupt" is because parted+fdisk
looking at the end of /dev/md0 rather than the end of the device this
GPT actually belongs to.

So I suspect GPT and XFS have stepped on each other possibly more than
once each which is why both have corruption; and the mdadm metadata
doesn't. Or even possible that one or more signatures in this storage
stack are stale, not having previously been properly wiped, and now
are haunting this storage stack.

I wouldn't make any writes until you've double checked what the layout
is supposed to be. First check if the individual member drives are GPT
partitioned, and whether their primary and backups are valid (not
corrupt); if there's corruption don't fix it yet. Right now you just
need to focus on what all of the on disk metadata says is true, and
then you'll be able to discover what metadata is wrong and
contributing to all this confusion.


-- 
Chris Murphy
