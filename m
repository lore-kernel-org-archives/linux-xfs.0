Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBABha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 20:37:30 -0500
Date: Wed, 31 Jan 2018 17:37:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [LSF/MM TOPIC] Online Filesystem Check, 2018 Edition
Message-ID: <20180201013726.GE4860@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>

Hi all,

Last year I ran a session about online fsck for filesystems, XFS in
particular.  We've landed the first half of that (the checking part) in
upstream as of this morning and will start the process of upstreaming
the repair bits in 2018.

One piece we didn't resolve from last year (or any of the previous LSF)
is how to kill an open file -- once we add parent pointers to XFS we'll
have the option to delete damaged files instead of spending time to
repair them.  I /think/ it suffices to replace the doomed inode's ops
with a set that won't do anything and dump the pagecache pages for the
inode like we were doing a real truncate, and once everything closes
that file the fs can simply reclaim it.  It seems to work(ish) in my
trivially stupid prototype, even with my clumsy inode weed-whacking.

Looking ahead, I see that we're not alone in having some sort of online
fs checking ability -- btrfs has its btrfs scrub command to ask the
kernel to read and validate checksums; ocfs2 has some sysfs-based
mechanism to check inode ECCs and (somehow) repair them; and ext4 is in
the process of formalizing the old 'e2croncheck' into a scanner that
triggers fsck-on-boot if it finds something weird.  I'm not sure if the
overlayfs fsck program that's being developed on fstests can run while
it's online, but that might be in the list too.

So, given that we'll have a lot of filesystem developers in one place,
this might be a convenient place to have a discussion about whether or
not it makes sense to try to create a wrapper for these things like
/sbin/fsck and/or standardize at least a few of the options?

Anyway, that's my pitch for a cross-project discussion about where I am
heading with online fsck.

--Darrick
