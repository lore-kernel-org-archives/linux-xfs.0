Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39999 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfAaUCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 15:02:48 -0500
Received: by mail-lf1-f68.google.com with SMTP id v5so3295886lfe.7
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 12:02:47 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 31 Jan 2019 13:02:34 -0700
Message-ID: <CAJCQCtRGrt-K7WUe76D1g_HhU8NCi7ZuGExstVOQujtRS2Rf_w@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>

On Fri, Jan 25, 2019 at 7:28 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi,
>
> I would like to discuss the concept of lazy file reflink.
> The use case is backup of a very large read-mostly file.
> Backup application would like to read consistent content from the
> file, "atomic read" sort of speak.

If it's even a few thousand such files let alone millions, whether XFS
or Btrfs,  you're talking about a lot of metadata writes (hence I
sorta understand the request for lazy+volatile reflink). But this
quickly is a metric f ton of data, it's in effect a duplicate of each
file's metadata which includes a list of its extents. So in simple
cases it can be unwritten, but not in every case can you be sure the
operation fits in memory.

example from my sysroot:
36.87GiB data extents
1.12GiB filesystem metadata

If I reflink copy that whole file system, it translates into 1.12GiB
metadata read and then 1.12GiB written. If it's a Btrfs snapshot of
the containing subvolumes, it's maybe 128KiB written per snapshot. The
reflink copy is only cheap compared to full data copy. It's not that
cheap compared to snapshots. It sounds to me like a lazy reflink copy
is no longer lazy if it has to write out to disk because it can't all
fit in memory, or ends up evicting something in memory that otherwise
slows things down.

A Btrfs snapshot is cheaper than an LVM thinp snapshot which comes
with a need to then mount that snapshot's filesystem in order to do
the backup. But if the file system is big enough that there are long
mount times, chances are you're talking about a lot of data to backup
also, which means a alot of metadata to read and then write out unless
you're lucky enough to have gobs of RAM.

So *shrug* I'm not seeing a consistent optimization with lazy reflink.
It'll be faster if we're not talking about a lot of data in the first
place.

> I have based my assumption that reflink of a large file may incur
> lots of metadata updates on my limited knowledge of xfs reflink
> implementation, but perhaps it is not the case for other filesystems?
> (btrfs?) and perhaps the current metadata overhead on reflink of a large
> file is an implementation detail that could be optimized in the future?

The optimum use case is maybe a few hundred big files. Tens of
thousands to millions - I think you start creating a lot of
competition for memory, and the ensuing consequences. Something has to
be evicted. Either the lazy reflink is a lower priority and it
functionally becomes a partial or full reflink by writing out to block
devices; or it's a higher priority and kicks something else out. No
free lunch.


-- 
Chris Murphy
