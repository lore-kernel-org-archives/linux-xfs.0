Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from boksu.net-space.pl ([185.15.1.105]:56361 "EHLO
        boksu.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbeEPJQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 05:16:25 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@boksu.net-space.pl)) by router-fw-old.local.net-space.pl
        id S1839706AbeEPJAL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 May 2018 11:00:11 +0200
Date: Wed, 16 May 2018 11:00:11 +0200
From: Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [GRUB PATCH] xfs: accept filesystem with sparse inodes
Message-ID: <20180516090011.GA24959@router-fw-old.local.net-space.pl>
References: <ce584ae1-ee62-2dcb-9366-eb0a6df6e98e@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce584ae1-ee62-2dcb-9366-eb0a6df6e98e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: grub-devel@gnu.org, dkiper@net-space.pl, Peter Jones <pjones@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Chris Murphy <lists@colorremedies.com>

On Tue, May 15, 2018 at 02:55:55PM -0500, Eric Sandeen wrote:
> The sparse inode metadata format became a mkfs.xfs default in
> xfsprogs-4.16.0, and such filesystems are now rejected by grub as
> containing an incompatible feature.
>
> In essence, this feature allows xfs to allocate inodes into fragmented
> freespace.  (Without this feature, if xfs could not allocate contiguous
> space for 64 new inodes, inode creation would fail.)
>
> In practice, the disk format change is restricted to the inode btree,
> which as far as I can tell is not used by grub.  If all you're doing
> today is parsing a directory, reading an inode number, and converting
> that inode number to a disk location, then ignoring this feature
> should be fine, so I've added it to XFS_SB_FEAT_INCOMPAT_SUPPORTED
>
> I did some brief testing of this patch by hacking up the regression
> tests to completely fragment freespace on the test xfs filesystem, and
> then write a large-ish number of inodes to consume any existing
> contiguous 64-inode chunk.  This way any files the grub tests add and
> traverse would be in such a fragmented inode allocation.  Tests passed,
> but I'm not sure how to cleanly integrate that into the test harness.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Eric, thank you for posting the patch. LGTM.

Chris, may I ask you to test it and add your "Tested-by:" if it works?

Daniel
