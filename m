Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:47064 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbeIAVeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Sep 2018 17:34:46 -0400
Date: Sun, 2 Sep 2018 01:21:58 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 00/16] Fix tests to work on non-4k block sized fs
 instances
Message-ID: <20180901172158.GH3651@desktop>
References: <20180816072646.14490-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180816072646.14490-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Thu, Aug 16, 2018 at 12:56:30PM +0530, Chandan Rajendra wrote:
> This patchset fixes tests (mostly XFS specific ones) to work on
> variable block size. These patches now use the output of "od" utility
> to verify the contents of the test files instead of the md5sum
> utility.
> 
> The patchset modifies _filter_fiemap() filter function to optionally
> print the file offset range in block size units.
> 
> Chandan Rajendra (16):
>   Fix xfs/009 to work with 64k block size
>   xfs/050: Fix "Push past soft inode limit" case
>   Fix xfs/050 to work with 64k block size
>   Fix xfs/074 to work with 64k block size
>   Fix xfs/127 to work with 64k block size
>   Fix xfs/139 to work with 64k block size
>   Fix xfs/140 to work with 64k block size
>   Fix xfs/190 to work with 64k block size
>   Fix xfs/299 to work with 64k block size
>   xfs/325: Inject free_extent error after CoW operation

I may need helps from XFS folks to review these changes.

But I noticed that you are getting fs block size all from TEST_DIR, even
if the test is testing against $SCRATCH_MNT, e.g. xfs/139 xfs/140 (and
other tests too). But the fs block size could be different on TEST_DEV
and SCRATCH_DEV.

Also, I'd be very helpful if someone could help test this patchset on
real hardware that supports mounting 64k blocksize XFS.

Thanks a lot!

Eryu

>   Fix generic/102 to work with 64k block size
>   Fix generic/172 to work with 64k block size
>   Filter fiemap output by FS block size
>   Fix generic/177 to work with 64k block size
>   Fix generic/230 to work with 64k block size
>   Fix generic/235 to work with 64k block size
> 
>  common/punch          | 19 ++++++++---
>  tests/generic/102     |  4 +--
>  tests/generic/102.out | 20 +++++------
>  tests/generic/172     |  4 +--
>  tests/generic/177     | 20 ++++++-----
>  tests/generic/177.out | 23 ++++++++-----
>  tests/generic/230     | 24 ++++++++------
>  tests/generic/230.out | 16 ++++-----
>  tests/generic/235     |  2 +-
>  tests/generic/235.out |  4 +--
>  tests/xfs/009         | 92 ++++++++++++++++++++++++++++++++++++++++++---------
>  tests/xfs/009.out     | 66 ++++++++++++++++++------------------
>  tests/xfs/050         | 23 ++++++++-----
>  tests/xfs/050.out     | 60 ++++++++++++++++-----------------
>  tests/xfs/074         | 23 ++++++++++---
>  tests/xfs/127         |  2 +-
>  tests/xfs/139         | 12 +++----
>  tests/xfs/139.out     |  8 +++--
>  tests/xfs/140         |  9 ++---
>  tests/xfs/190         | 44 +++++++++++++++++++-----
>  tests/xfs/299         | 23 ++++++++-----
>  tests/xfs/299.out     | 60 ++++++++++++++++-----------------
>  tests/xfs/325         |  5 +--
>  tests/xfs/325.out     |  2 +-
>  24 files changed, 355 insertions(+), 210 deletions(-)
> 
> -- 
> 2.9.5
> 
