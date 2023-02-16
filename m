Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E212C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPUGf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjBPUGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:06:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15E052CED
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42E7E60B02
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECDFC433EF;
        Thu, 16 Feb 2023 20:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676577988;
        bh=SxaVKBE9XeQ5vFWb6MGdCU3jRlzfUjmYUtq33hoSI5A=;
        h=Date:From:To:Cc:Subject:From;
        b=DR80CP3RCV+hbrugW2kYExqrHX6RfMDrOuf9JTPL7uEwMLPKiNdmSWNhGs6kyBa3O
         pUcTFUGf0prYxkEggbln0/XT2JCxEwiFeIktj9KdRTeUoQeZoD0kOQCZ7nK7Sp7ZD1
         6FR4gk4sCbTq6XIzzNrePbX8G6pb+tARV1KHf0v29le8Mn+v6+E7mmk61kEFLmNeSb
         yfvFpbfGeFiGKWicVOkszTFUGlvp8cbw4uUiROKBjirR9gNFvor7GBuk8vJIHlve87
         MhM91hwwaqYydAayjk4YjPjf7INL0vg9MiVk/stOIbSAvN6xwHCsFv6tj4FxypaYuW
         pAEK08q9x/Zhg==
Date:   Thu, 16 Feb 2023 12:06:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC DELUGE v9r2d1] xfs: Parent Pointers
Message-ID: <Y+6MxEgswrJMUNOI@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

This deluge contains all of the additions to the parent pointers
patchset that I've been working on for the past month.  The kernel and
xfsprogs patchsets are based on Allison's v9r2 tag from last week;
the fstests patches are merely a part of my development tree.  To recap
Allison's cover letter:

"The goal of this patch set is to add a parent pointer attribute to each
inode.  The attribute name containing the parent inode, generation, and
directory offset, while the  attribute value contains the file name.
This feature will enable future optimizations for online scrub, shrink,
nfs handles, verity, or any other feature that could make use of quickly
deriving an inodes path from the mount point."

The kernel branches start with a number of buf fixes that I need to get
fstests to pass.  I also restructured the kernel implementation of
GETPARENTS to cut the memory usage considerably.

For userspace, I cleaned up the xfsprogs patches so that libxfs-diff
shows no discrepancies with the kernel and cleaned up the parent pointer
usage code that I prototyped in 2017 so that it's less buggy and moldy.
I also rewired xfs_scrub to use GETPARENTS to report file paths of
corrupt files instead of inode numbers, since that part had bitrotted
badly.

With that out of the way, I implemented a prototype of online repairs
for directories and parent pointers.  This is only a proof of concept,
because I had already backported many many patches from part 1 of online
repair, and didn't feel like porting the parts needed to commit new
structures atomically and reap the old dir/xattr blocks.  IOWs, the
prototype scans the filesystem to build a parallel directory or xattr
structure, and then reports on any discrepancies between the two
versions.  Obviously this won't fix a corrupt directory tree, but it
enables us to test the repair code on a consistent filesystem to
demonstrate that it works.

Next, I implemented fully functional parent pointer checking and repair
for xfs_repair.  This was less hard than I guessed it would be because
the current design of phase 6 includes a walk of all directories.  From
the dirent data, we can build a per-AG index of all the parent pointers
for all the inodes in that AG, then walk all the inodes in that AG to
compare the lists.  As you might guess, this eats a fair amount of
memory, even with a rudimentary dirent name deduplication table to cut
down on memory usage.

After that, I moved on to solving the major problem that I've been
having with the directory repair code, and that is the problem of
reconstructing dirents at the offsets specified by the parent pointers.
The details of the problem and how I dealt with it are captured in the
cover letter for those patches.  Suffice to say, we now encode the
dirent name in the parent pointer attrname (or a collision resistant
hash if it doesn't fit), which makes it possible to commit new
directories atomically.

The last part of this patchset reorganizes the XFS_IOC_GETPARENTS ioctl
to encode variable length parent pointer records in the caller's buffer.
The denser encodings mean that we can extract the parent list with fewer
kernel calls.

--D
