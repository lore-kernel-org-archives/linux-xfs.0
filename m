Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 03:07:44 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SA7atL006435
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 03:07:37 -0700
Date: Thu, 28 Jun 2007 02:55:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-Id: <20070628025543.9467216f.akpm@linux-foundation.org>
In-Reply-To: <20070625132810.GA1951@amitarora.in.ibm.com>
References: <20070510005926.GT85884050@sgi.com>
	<20070510115620.GB21400@amitarora.in.ibm.com>
	<20070510223950.GD86004887@sgi.com>
	<20070511110301.GB28425@in.ibm.com>
	<20070512080157.GF85884050@sgi.com>
	<20070612061652.GA6320@amitarora.in.ibm.com>
	<20070613235217.GS86004887@sgi.com>
	<20070614091458.GH5181@schatzie.adilger.int>
	<20070614120413.GD86004887@sgi.com>
	<20070614193347.GN5181@schatzie.adilger.int>
	<20070625132810.GA1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, 25 Jun 2007 18:58:10 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> N O T E: 
> -------
> 1) Only Patches 4/7 and 7/7 are NEW. Rest of them are _already_ part
>    of ext4 patch queue git tree hosted by Ted.

Why the heck are replacements for these things being sent out again when
they're already in -mm and they're already in Ted's queue (from which I
need to diligently drop them each time I remerge)?

Are we all supposed to re-review the entire patchset (or at least #4 and
#7) again?

The core kernel changes are not appropriate to the ext4 tree.

For a start, the syscall numbers in Ted's queue are wrong (other new
syscalls are pending).

Patches which add syscalls are an utter PITA to carry due to all the patch
conflicts and to the relatively frequent syscall renumbering (they don't
get numbered in time-of-arrival order due to differing rates at which patches
mature).

Please drop the non-ext4 patches from the ext4 tree and send incremental
patches against the (non-ext4) fallocate patches in -mm.

And try to get the code finished?  Time is pressing.

Thanks.
