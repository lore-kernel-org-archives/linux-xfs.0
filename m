Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbeAWQLV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 11:11:21 -0500
Date: Tue, 23 Jan 2018 11:11:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180123161120.GC32478@bfoster.bfoster>
References: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
 <20180123152852.GA32478@bfoster.bfoster>
 <509e33df-4f76-2937-0425-98c26b3a1207@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <509e33df-4f76-2937-0425-98c26b3a1207@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 05:45:39PM +0200, Avi Kivity wrote:
> 
> 
> On 01/23/2018 05:28 PM, Brian Foster wrote:
> > On Tue, Jan 23, 2018 at 04:57:03PM +0200, Avi Kivity wrote:
> > > I'm seeing the equivalent[*] of xfs_extent_busy_flush() sleeping in my
> > > beautiful io_submit() calls.
> > > 
> > > 
> > > Questions:
> > > 
> > >   - Is it correct that RWF_NOWAIT will not detect the condition that led to
> > > the log being forced?
> > > 
> > >   - If so, can it be fixed?
> > > 
> > >   - Can I do something to reduce the odds of this occurring? larger logs,
> > > more logs, flush more often, resurrect extinct species and sacrifice them to
> > > the xfs gods?
> > > 
> > >   - Can an xfs developer do something? For example, make it RWF_NOWAIT
> > > friendly (if the answer to the first question was "correct")
> > > 
> > So RWF_NOWAIT eventually works its way to IOMAP_NOWAIT, which looks like
> > it skips any write call that would require allocation in
> > xfs_file_iomap_begin(). The busy flush should only happen in the block
> > allocation path, so something is missing here. Do you have a backtrace
> > for the log force you're seeing?
> > 
> > 
> 
> Here's a trace. It's from a kernel that lacks RWF_NOWAIT.
> 

Oh, so the case below is roughly how I would have expected to hit the
flush/wait without RWF_NOWAIT. The latter flag should prevent this, to
answer your first question.

For the follow up question, I think this should only occur when the fs
is fairly low on free space. Is that the case here? I'm not sure there's
a specific metric, fwiw, but it's just a matter of attempting an (user
data) allocation that only finds busy extents in the free space btrees
and thus has to the force the log to satisfy the allocation. I suppose
running with more free space available would avoid this. I think running
with less in-core log space could indirectly reduce extent busy time,
but that may also have other performance ramifications and so is
probably not a great idea.

Brian

>  0xffffffff816ab231 : __schedule+0x531/0x9b0 [kernel]
>  0xffffffff816ab6d9 : schedule+0x29/0x70 [kernel]
>  0xffffffff816a90e9 : schedule_timeout+0x239/0x2c0 [kernel]
>  0xffffffff816aba8d : wait_for_completion+0xfd/0x140 [kernel]
>  0xffffffff810ab41d : flush_work+0xfd/0x190 [kernel]
>  0xffffffffc00ddb3a : xlog_cil_force_lsn+0x8a/0x210 [xfs]
>  0xffffffffc00dbbf5 : _xfs_log_force+0x85/0x2c0 [xfs]
>  0xffffffffc00dbe5c : xfs_log_force+0x2c/0x70 [xfs]
>  0xffffffffc0078f60 : xfs_alloc_ag_vextent_size+0x250/0x630 [xfs]
>  0xffffffffc0079ed5 : xfs_alloc_ag_vextent+0xe5/0x150 [xfs]
>  0xffffffffc007abc6 : xfs_alloc_vextent+0x446/0x5f0 [xfs]
>  0xffffffffc008b123 : xfs_bmap_btalloc+0x3f3/0x780 [xfs]
>  0xffffffffc008b4be : xfs_bmap_alloc+0xe/0x10 [xfs]
>  0xffffffffc008bef9 : xfs_bmapi_write+0x499/0xab0 [xfs]
>  0xffffffffc00c6ec8 : xfs_iomap_write_direct+0x1b8/0x390 [xfs]
> 
