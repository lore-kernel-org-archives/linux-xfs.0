Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752068AbdGFNsH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jul 2017 09:48:07 -0400
Date: Thu, 6 Jul 2017 09:48:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170706134801.GA56732@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
> 
> Even stranger, after mounting back the image, there is no lost+found
> anywhere to be found! However the filesystem has lots of free space and
> free inodes, how come?
> 

Did you originally run xfs_repair using the -n option? I'd guess not if
it ultimately failed making a modification, but if so, something to be
aware of is that it skips warning about a dirty log and potentially can
report much more corruption than after a log recovery occurs. It might
be worth running after an attempted log recovery.

Otherwise, I'd be curious about the state of the fs after the above
error. Does 'xfs_repair -n' continue to report errors?

Also the above suggests that lost+found existed (in a corrupted state)
prior to the initial repair attempt, yes? If so, it might be interesting
to identify the inode # of lost+found to follow what xfs_repair does to
that inode during the initial run (e.g., if lost+found is corrupted and
is attempted to be used before it is fixed up or something of that
nature).

Brian

> df -i
> Sys. fich.                    Inodes  IUtil.     ILibre IUti% Monté sur
> rootfs                             0       0          0     - /
> /dev/root                          0       0          0     - /
> tmpfs                        2058692     990    2057702    1% /run
> tmpfs                        2058692       6    2058686    1% /run/lock
> tmpfs                        2058692    1623    2057069    1% /dev
> tmpfs                        2058692       3    2058689    1% /run/shm
> guitare:/mnt/raid/partage   33554432  305069   33249363    1% /mnt/qnap1
> /dev/loop0                4914413568 5199932 4909213636    1% /mnt/rescue
> 
> df
> /dev/loop0                122858252288 88827890868 34030361420  73% /mnt/rescue
> 
> I'll give a shot to a newer version of xfs_repair just in case...
> 
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------


