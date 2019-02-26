Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35909 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfBZVKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 16:10:15 -0500
MIME-Version: 1.0
References: <20190226181407.44612-1-bfoster@redhat.com>
In-Reply-To: <20190226181407.44612-1-bfoster@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Feb 2019 23:10:02 +0200
Message-ID: <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>

On Tue, Feb 26, 2019 at 8:14 PM Brian Foster <bfoster@redhat.com> wrote:
>
> The dm-log-writes mechanism runs a workload against a filesystem,
> tracks underlying FUAs and restores the filesystem to various points
> in time based on FUA marks. This allows fstests to check fs
> consistency at various points and verify log recovery works as
> expected.
>

Inaccurate. generic/482 restores to FUA points.
generic/45[57] restore to user defined points in time (marks).
dm-log-writes mechanism is capable of restoring either.

> This mechanism does not play well with LSN based log recovery
> ordering behavior on XFS v5 superblocks, however. For example,
> generic/482 can reproduce false positive corruptions based on extent
> to btree conversion of an inode if the inode and associated btree
> block are written back after different checkpoints. Even though both
> items are logged correctly in the extent-to-btree transaction, the
> btree block can be relogged (multiple times) and only written back
> once when the filesystem unmounts. If the inode was written back
> after the initial conversion, recovery points between that mark and
> when the btree block is ultimately written back will show corruption
> because log recovery sees that the destination buffer is newer than
> the recovered buffer and intentionally skips the buffer. This is a
> false positive because the destination buffer was resiliently
> written back after being physically relogged one or more times.
>

This story doesn't add up.
Either dm-log-writes emulated power failure correctly or it doesn't.
My understanding is that the issue you are seeing is a result of
XFS seeing "data from the future" after a restore of a power failure
snapshot, because the scratch device is not a clean slate.
If I am right, then the correct solution is to wipe the journal before
starting to replay restore points.

Am I misunderstanding whats going on?

IIRC, some of Josef's earlier versions used dm snapshots to restore
the blockdev to a clean state before replying log-writes.
I think that one of the earlier versions of generic/482 also took
that approach, but that resulted in longer test runtime (not sure).

> Update the dm-log-writes require checks to enforce v4 superblocks
> when running against XFS and skip the test otherwise.

You might as well disable dm-log-writes test for XFS completely.
Who cares about v4 superblocks these days?
We need a tool to make sure the NEW features are crash resilient.

dm-log-writes proved itself to be a powerful generic test tool that found
some serious crash consistency bugs in every one of the major filesystems
and it found bugs with XFS reflink log recovery as well, so IMO
disabling dm-log-writes for v5 would be "very unwise!".

Thanks,
Amir.
