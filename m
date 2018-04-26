Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:36468 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbeDZCBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Apr 2018 22:01:13 -0400
Date: Thu, 26 Apr 2018 10:01:07 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] tests/xfs: filestream allocator inode use-after-free test
Message-ID: <20180426020107.GI11384@desktop>
References: <20180406141815.6472-1-bfoster@redhat.com>
 <20180425032221.GF11384@desktop>
 <20180425115340.GA3879@bfoster.bfoster>
 <20180426015456.GH11384@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180426015456.GH11384@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Apr 26, 2018 at 09:54:56AM +0800, Eryu Guan wrote:
> On Wed, Apr 25, 2018 at 07:53:41AM -0400, Brian Foster wrote:
> > On Wed, Apr 25, 2018 at 11:22:21AM +0800, Eryu Guan wrote:
> > > On Fri, Apr 06, 2018 at 10:18:15AM -0400, Brian Foster wrote:
> > > > The XFS filestreams allocator caches dir inode -> agno mappings in
> > > > an MRU mechanism that holds elements in memory for an amount of time
> > > > and then cleans up expired elements in the background. The elements
> > > > typically held inode pointers without holding a reference to the
> > > > associated inode. This means that if the inode is reclaimed before
> > > > an expired entry is cleaned up, the MRU reaper can access freed
> > > > memory and cause a panic.
> > > > 
> > > > Test for this problem by performing continuous filestreams
> > > > allocations under short-lived parent directory inodes. This will
> > > > produce KASAN use-after-free splats if enabled during the test.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > This test reproduces the problem described in this[1] thread. It's
> > > > XFS-specific because of the filestream option and specific geometry used
> > > > to format the scratch device.
> > > > 
> > > > Brian
> > > > 
> > > > [1] https://marc.info/?l=linux-xfs&m=152293031029161&w=2
> > > 
> > > From above thread, it seems that we don't need the kernel change
> > > anymore, and the test itself would trigger dmesg check failure when
> > > testing on kernel with kasan enabled, right?
> > > 
> > 
> > Yep...
> > 
> > > But I've looped the test for 200 times and it all passed without
> > > triggering any KASAN warnings, kernel is v4.17-rc2.
> > > 
> > 
> > The kernel fix ended up being a patch from Christoph. It looks like it
> > made it into v4.17-rc1 as commit 7fcd3efa1e ("xfs: remove filestream
> > item xfs_inode reference"). Could you perhaps try an older kernel or one
> > with that patch reverted?
> 
> Sure, I'll try reverting that patch.

Yeah, I hit KASAN warning quite quickly after reverting that patch.
Thanks!

Eryu
