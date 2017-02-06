Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdBFNOg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 08:14:36 -0500
Date: Mon, 6 Feb 2017 08:14:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs wrongly report ENOSPACE
Message-ID: <20170206131435.GA57865@bfoster.bfoster>
References: <58986E06.5050500@xtaotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58986E06.5050500@xtaotech.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "peng.hse" <peng.hse@xtaotech.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Please use the XFS list, updated cc.

On Mon, Feb 06, 2017 at 08:37:26PM +0800, peng.hse wrote:
> Hi DJ and xfs developers,
> 
> i am ceph developer, build the OSD on top of the xfs mount point. the kernel
> xfs module i used was build from the 4.9.8 kernel release from
> kernel.org, that includes your recent changes in Dec, 2016.
> 
> recently, i found our cluster will get faulted due to the xfs mount wrongly
> report there is no space to create the new file as
>  " No space left on device ", but apparently the xfs mount point only be
> around 50% full.
> 
> i used the systemtap to narrow it down the the function xfs_ialloc_ag_select
> which reports no free ag selected, the problem seems
> still exist, not sure your recent patches will fix it or not.
> 
> i am very glad to provide more info if your like to assist you to identify
> the problem.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

In this case, please at least provide the output from 'df -i <mnt>,'
'xfs_info <mnt>' and 'xfs_db -c "freesp -s" <dev>.'

Chances are that this is caused by free space fragmentation. This means
that while there might be plenty of free space, there isn't a contiguous
free extent large enough to allocate an inode chunk. We've seen this
kind of thing before with Ceph and it can be exacerbated by the use of
large inodes. Potential workarounds may be to use the default inode size
and/or enable the use of sparse inodes ('mkfs.xfs -i sparse <dev>').

Another possible cause is that you've simply hit the maximum inode
allocation limit (see the xfs_growfs manpage and the '-m' option)...

Brian
