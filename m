Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22430 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754475AbcK1IVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 03:21:30 -0500
Date: Mon, 28 Nov 2016 19:21:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Silent skipping of file during xfsrestore
Message-ID: <20161128082116.GA28177@dastard>
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Will Dormann <wdormann@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2016 at 12:00:06AM -0500, Will Dormann wrote:
> Hi Dave,
> 
> On 11/27/16 8:59 PM, Dave Chinner wrote:
> >> So what can cause a file to silently be skipped during restore?
> > 
> > Usually nothing. This is typical of xfsdump skipping a file due to
> > some unexpected occurrence during backup. It's in the dump
> > inventory as the directory was processed, but if somthing changed
> > during the dump process (e.g. file gets replaced due to atomic
> > overwrite via rename) then it may not end up being in the dump.
> 
> This file pretty much never gets written to after the first install of
> the system, so I wouldn't suspect anything like that would have happened.
> 
> 
> >> I'm
> >> running the latest xfsdump/xfsrestore provided by Ubuntu 14.04, which is
> >> 3.1.1.   I notice the same symptoms from my recovery environment, which
> >> is SystemRescueCD 4.2.0
> > 
> > That's /old/. Try running the latest (3.1.6 IIRC) and see if that
> > fixes the issue.
> 
> 
> I tried running xfsrestore 3.1.6 on the existing 3.1.1 dump, and I got
> the same symptoms:

Yes, that's expected - the file is missing from the dump, indicating
a problem exncountered by xfsdump, not xfsrestore.

> If the latest xfsrestore indicates that a file is in a backup, but then
> doesn't actually restore it when asked, isn't that still indicative of a
> problem?  That is, if xfsrestore indicates that a file is in a backup,
> shouldn't it be restoring something?

I think you misunderstand how the inventory and dump process
works. The dump process first builds the inventory inode map that it
needs to back up, then goes and backs up what it mapped in the
inventory.  The filesystem can change between the inventory build
an dump trying to backup the file, and if the file does not match
the inventory for some reason (e.g. different inode generation
number) it will skip it. The file does not get removed from the
inventory, though, because that's already been written to the dump
file.

There have also been situations where kernel bugs have meant xfsdump
missed files. e.g. off-by-ones in bulkstat continuation code. These
bugs had identical symptoms to what you are reporting, but given a
new dump worked this is probably not the issue....

> I tried creating a new dump with 3.1.6, and subsequently restoring with
> 3.1.6, and it did succeed in restoring config.xml.

Yup, no surprise there, either.

> However, that may possibly have nothing to do with any sort of fix.
> Because I couldn't restore config.xml when I did my system restore, I
> had to create a new copy of it from a file-level backup.  Therefore, the
> original problematic file isn't present anywhere other than my existing
> xfsdump backups.

Yup, in general, problems with dump contents seen with xfs_restore
are most likely going to be a dump issue and can only be rectified
by running new backups.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
