Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35732 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754642AbdCBR0f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 12:26:35 -0500
Subject: Re: XFS kernel BUG during generic/270 with v4.10
References: <20170222191300.GA29474@linux.intel.com>
 <20170302162934.GM3213@bfoster.bfoster>
 <20170302164701.GJ26319@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7be68c7c-bfea-3222-812e-d8042535bfef@sandeen.net>
Date: Thu, 2 Mar 2017 11:25:58 -0600
MIME-Version: 1.0
In-Reply-To: <20170302164701.GJ26319@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs@vger.kernel.org



On 3/2/17 10:47 AM, Darrick J. Wong wrote:
> On Thu, Mar 02, 2017 at 11:29:34AM -0500, Brian Foster wrote:
>> On Wed, Feb 22, 2017 at 12:13:00PM -0700, Ross Zwisler wrote:
>>> By running generic/270 in a loop on an XFS filesystem mounted with DAX I'm
>>> able to reliably generate the following kernel bug after a few (~10)
>>> iterations (output passed through kasan_symbolize.py):
>>>
>>> run fstests generic/270 at 2017-02-22 12:01:05
>>> XFS (pmem0p2): Unmounting Filesystem
>>> XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
>>> XFS (pmem0p2): Mounting V5 Filesystem
>>> XFS (pmem0p2): Ending clean mount
>>> XFS (pmem0p2): Quotacheck needed: Please wait.
>>> XFS (pmem0p2): Quotacheck: Done.
>>> XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
>>> XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 965

...

>>> This was done in my normal test setup, which is a pair of PMEM disks that
>>> enable DAX.
>>>
>>
>> What I'm a little confused about though is that I thought DAX meant we
>> bypassed buffered I/O and always used direct I/O (which means you should
>> never perform delayed allocation). :/
> 
> The block devices are pmem, but I don't think g/270 does anything
> special to turn on DAX (the inode flag) for the files it's writing.

Ross's dmesg says:

DAX enabled. Warning: EXPERIMENTAL, use at your own risk

which means he has "-o dax" in his mount options for xfstests.

-Eric
