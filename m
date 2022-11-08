Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBA6C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 22:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKHWqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 17:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKHWqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 17:46:10 -0500
X-Greylist: delayed 539 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 14:46:06 PST
Received: from guitar.compbio.ucsf.edu (guitar.compbio.ucsf.edu [169.230.79.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A8064A36
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 14:46:06 -0800 (PST)
X-Virus-Scanned: amavisd-new at guitar.compbio.ucsf.edu
Received: from rocky (hal2.cgl.ucsf.edu [169.230.25.10])
        by guitar.compbio.ucsf.edu (Postfix) with ESMTPSA id 0F2BDB00F204
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 14:37:06 -0800 (PST)
Authentication-Results: guitar.compbio.ucsf.edu; arc=none smtp.remote-ip=169.230.25.10
ARC-Seal: i=1; a=rsa-sha256; d=salilab.org; s=arc; t=1667947026; cv=none; b=5vKgo9WzXxxOIr6Jx//8Qj9wwR4QLCqjSg21kkBu0jXjoCO0c35KzNBGUR9tS0d2odHaVw5LX6/3L/xrNn5+1E7j3uRnhyYTyIYJom3r0EP3srTgqMwc8RgrKGVQ4aJbs/0AFB3zx330MD86GrMnwuBkNJQHsEKlmmxk/VBi/QI=
ARC-Message-Signature: i=1; a=rsa-sha256; d=salilab.org; s=arc; t=1667947026;
        c=relaxed/simple; bh=zUqrZmt9nfz/6Ux8cwk2iW5JzURVbYEtQ6xe3g+CplE=;
        h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=uyiY7Wf7S+dKzpc0yHEAaa2UNIRqZwUkj6ZlQtw339/Zq8YYvrln/xIOcIjoEGxFEnb1QabNIZMTup8crGAXaZe6732RFPjOvxdNa5EA9DkBMg5W4TtIxVfLYPFBa8YTdZ7SLfmFD/cBzi9cElv9cmiy4KKH0bKWCebqnT3Mm/8=
ARC-Authentication-Results: i=1; guitar.compbio.ucsf.edu
DKIM-Filter: OpenDKIM Filter v2.11.0 guitar.compbio.ucsf.edu 0F2BDB00F204
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salilab.org;
        s=default; t=1667947026;
        bh=vyMFaTJqsj/ziODnHZZLxb3PodzgixAyNAd4P3KleVg=;
        h=Date:From:To:Subject:From;
        b=HYoWhjGKNvJ9SnczD0yh4uRYrcLydKqMR79WxwFV8WvNmrvm8klczAIyDqnBGCzVV
         MAJIYEb6edqEr7O0kd14BgkjrpOJzDg4n/jmDVey6C1C7V7/zakAfXUzA3MW6lKN6/
         YGBBYdxUM7GaSqyf5adriB+zqAgXR7xt9uPTJ8Po=
Date:   Tue, 8 Nov 2022 14:37:05 -0800 (PST)
From:   Joshua Baker-LePain <jlb@salilab.org>
X-X-Sender: jlb@rocky
To:     linux-xfs@vger.kernel.org
Subject: CentOS 7.9, 2 XFS issues
Message-ID: <e0fb2f49-2e16-e764-f687-9ae9636ade79@rocky>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (guitar.compbio.ucsf.edu [0.0.0.0]); Tue, 08 Nov 2022 14:37:06 -0800 (PST)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

First, I know that I'm running a very old kernel.  If this isn't the right 
place to ask these questions, please let me know.  I'm running BeeGFS (a 
parallel disributed filesystem) on CentOS 7.9 systems (kernel 
3.10.0-1160.76.1.el7.x86_64).  On my metadata servers, I run XFS for the 
filesystems holding the metadata.  They run on top of software RAID1 
mirrors on SSDs, are formatted like this:

mkfs.xfs --m crc=1,finobt=1 -i maxpct=95 -l size=400m /dev/md122

and are mounted with these options:

rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota

A typical one of my metadata filesystems has ~210GB of space and 
~400M inodes used.  Last week, one of these filesystems shutdown with
these messages:

Nov  2 05:29:30 bmd3 kernel: XFS (md122): Internal error XFS_WANT_CORRUPTED_GOTO at line 3305 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_inobt_insert_rec+0x1f/0x30 [xfs]
Nov  2 05:29:30 bmd3 kernel: CPU: 28 PID: 11060 Comm: Worker9 Kdump: loaded Not tainted 3.10.0-1160.76.1.el7.x86_64 #1
Nov  2 05:29:30 bmd3 kernel: Hardware name: Supermicro Super Server/X11DDW-L, BIOS 3.1 04/30/2019
Nov  2 05:29:30 bmd3 kernel: Call Trace:
Nov  2 05:29:30 bmd3 kernel: [<ffffffffab1865c9>] dump_stack+0x19/0x1b
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06bc52b>] xfs_error_report+0x3b/0x40 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06a70bf>] ? xfs_inobt_insert_rec+0x1f/0x30 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc0694ddb>] xfs_btree_insert+0x1db/0x1f0 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06a70bf>] xfs_inobt_insert_rec+0x1f/0x30 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06a9f53>] xfs_difree_finobt+0xb3/0x200 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06aa1bb>] xfs_difree+0x11b/0x1d0 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06ce133>] xfs_ifree+0x83/0x150 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06ce2c8>] xfs_inactive_ifree+0xc8/0x230 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06ce4bb>] xfs_inactive+0x8b/0x130 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffc06d5b25>] xfs_fs_destroy_inode+0x95/0x190 [xfs]
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaac6c61b>] destroy_inode+0x3b/0x60
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaac6c755>] evict+0x115/0x180
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaac6cb2c>] iput+0xfc/0x190
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaac6097e>] do_unlinkat+0x1ae/0x2d0
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaad98858>] ? lockref_put_or_lock+0x48/0x80
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaac72454>] ? mntput+0x24/0x40
Nov  2 05:29:30 bmd3 kernel: [<ffffffffaac61a36>] SyS_unlink+0x16/0x20
Nov  2 05:29:30 bmd3 kernel: [<ffffffffab199f92>] system_call_fastpath+0x25/0x2a
Nov  2 05:29:30 bmd3 kernel: XFS (md122): xfs_inactive_ifree: xfs_ifree returned error -117
Nov  2 05:29:30 bmd3 kernel: XFS (md122): xfs_do_force_shutdown(0x1) called from line 1756 of file fs/xfs/xfs_inode.c.  Return address = ffffffffc06ce353
Nov  2 05:29:31 bmd3 kernel: XFS (md122): I/O Error Detected. Shutting down filesystem
Nov  2 05:29:31 bmd3 kernel: XFS (md122): Please umount the filesystem and rectify the problem(s)

There were no other messages in the logs to indicate any sort of hardware 
issue.  After unmounting, I tried to run "xfs_repair" and it told me I 
needed to mount to replay the log, unmount, then run "xfs_repair".  Every 
time I mounted, though, the filesystem shutdown with the same error.  To 
get the filesystem back online (and because the metadata is mirrored), I 
ended up reformatting the drive.

In an only tangentially related effort, I'm working on a new backup 
strategy for these filesystems using xfsdump rather than tar.  I went to 
run a level 0 dump of a similar filesystem on another server, and I saw 
this:

# xfsdump -f /scratch/meta22.0.xfsd -l 0 -L meta22-0 -M meta22-0 /data/meta22
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0) - type ^C for status and control
xfsdump: level 0 dump of bmd1.wynton.ucsf.edu:/data/meta22
xfsdump: dump date: Tue Nov  8 09:13:26 2022
xfsdump: session id: 022a0862-d5cb-41b9-88f2-9183f7821c86
xfsdump: session label: "meta22-0"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 129459315456 bytes
xfsdump: /var/lib/xfsdump/inventory created
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: WARNING: inomap inconsistency ino 472259: map says changed dir but is now non-dir: NOT dumping
xfsdump: WARNING: inomap inconsistency ino 1145788: map says changed dir but is now non-dir: NOT dumping

This is followed by many more lines like those last 2.  Given these 2 
issues so close together on such important systems, I'm a bit concerned. 
Is there any hint as to what caused the filesystem crash?  Are the "inomap 
inconsistency" messages something to be concerned about?  Are these issues 
related in any way?  Please let me know what other info I can provide, and 
thanks for any help.

-- 
Joshua Baker-LePain
Wynton Cluster Sysadmin
UCSF
