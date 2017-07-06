Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33190 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753088AbdGFX2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2017 19:28:31 -0400
Date: Fri, 7 Jul 2017 09:28:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170706232803.GF17762@dastard>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170706153020.0ad6dd47@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Thu, Jul 06, 2017 at 03:30:20PM +0200, Emmanuel Florac wrote:
> 
> After a RAID controller went bananas, I encountered an XFS corruption
> on a filesystem. Weirdly, the corruption seems to be mostly located in
> lost+found.
> 
> (I'm currently working on a metadump'd image of course, not the real
> thing; there are 90TB of data to be hopefully salvaged in there).
> 
> "ls /mnt/rescue/lost+found" gave this:
> 
> XFS (loop0): metadata I/O error: block 0x22b03f490
> ("xfs_trans_read_buf_map") error 117 numblks 16 
> XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
> XFS (loop0): Corruption detected. Unmount and run xfs_repair 
> XFS (loop0): Corruption detected. Unmount and run xfs_repair
> 
> I've run xfs_repair 4.9 on the xfs_mdrestored image. It dumps an insane
> lot of errors (the output log is 65MB)  and ends with this very strange
> message:
> 
> disconnected inode 26417467, moving to lost+found
> disconnected inode 26417468, moving to lost+found
> disconnected inode 26417469, moving to lost+found
> disconnected inode 26417470, moving to lost+found
> 
> fatal error -- name create failed in lost+found (117), filesystem may
> be out of space

Error 117. That's EFSCORRUPTED, not ENOSPC.  IOWs, lost+found was
corrupted as it was being modified by xfs_repair.

> Even stranger, after mounting back the image, there is no lost+found
> anywhere to be found! However the filesystem has lots of free space and
> free inodes, how come?

Because lost+found was corrupted.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
