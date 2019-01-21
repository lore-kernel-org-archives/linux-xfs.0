Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:53977
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfAUUbg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 15:31:36 -0500
Date: Tue, 22 Jan 2019 07:31:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Unable to fix metadata corruption with xfs_repair
Message-ID: <20190121203133.GK6173@dastard>
References: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Julien Lutran <julien.lutran@corp.ovh.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Jan 21, 2019 at 03:36:11PM +0000, Julien Lutran wrote:
> Hello,
> 
> I’m experiencing an issue with metadata corruption while trying to fix several corrupted xfs filesystems.
> Here’s an excerpt of the kernel messages when the disk is mounted :

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> […]
> Jan 21 15:44:16 rescue kernel: XFS (sdb): Metadata corruption detected at xfs_inode_buf_verify+0x6d/0xf0, xfs_inode block 0x300160
> Jan 21 15:44:16 rescue kernel: XFS (sdb): Unmount and run xfs_repair
> Jan 21 15:44:16 rescue kernel: XFS (sdb): First 64 bytes of corrupted metadata buffer:
> Jan 21 15:44:16 rescue kernel: XFS (sdb): metadata I/O error: block 0x300160 ("xfs_trans_read_buf_map") error 117 numblks 16
> Jan 21 15:44:16 rescue kernel: XFS (sdb): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.

What's in the 64 bytes of the corrupted metadata buffer output?
i.e. you trimmed away the bit of the error message that we actually
need to see what went wrong. Can you paste the uneditted log of the
error, including the output from mount time from the filesystem?

> I tried to run a xfs_repair (see attached log) but it ends up the same way : metadata error on block 0x300160
> Is there a way to fix this corruption ?

Likely a repair bug - the inode cluster has been trashed for some
reason and it's not fixing it properly so it's refusing to write
back corrupt inode metadata.

I really need to see what was in the first 64 bytes of that buffer
and xfs_info output to determine if we have a corrupt cluster, a
corrupt filessystem block, or the hardware has returned a compeltely
zeroed sector....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
