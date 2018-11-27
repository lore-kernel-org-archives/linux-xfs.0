Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:48545 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbeK0LXa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Nov 2018 06:23:30 -0500
Date: Tue, 27 Nov 2018 08:27:10 +0800
From: PanBian <bianpan2016@163.com>
Subject: Re: [PATCH] xfs: libxfs: move xfs_perag_put late
Message-ID: <20181127002710.GB109273@bp>
Reply-To: PanBian <bianpan2016@163.com>
References: <1543052660-58625-1-git-send-email-bianpan2016@163.com>
 <20181126093139.cgojlmtubzuzdb23@hades.usersys.redhat.com>
 <20181126103619.GA95394@bp>
 <20181126141750.GA14585@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126141750.GA14585@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 09:17:50AM -0500, Brian Foster wrote:
> On Mon, Nov 26, 2018 at 06:36:19PM +0800, PanBian wrote:
> > On Mon, Nov 26, 2018 at 10:31:39AM +0100, Carlos Maiolino wrote:
> > > On Sat, Nov 24, 2018 at 05:44:20PM +0800, Pan Bian wrote:
> > > > The function xfs_alloc_get_freelist calls xfs_perag_put to drop the
> > > > reference. In this case, pag may be released. However,
> > > > pag->pagf_btreeblks is read and write after the put operation. This may
> > > > result in a use-after-free bug. This patch moves the put operation late.
> > > > 
> > > 
> > > The patch looks reasonable, can you detail more how did you find it? Via code
> > > inspection of you hit this user-after-free in some way?
> > 
> > I wrote a tool to check such bugs statically. It first scans the source code 
> > to extract paired alloc/free functions. Equipped with such functions, it
> > performs an intra-procedural data flow analysis to detect mismatched
> > alloc/free bugs and use-after-free bugs.
> > 
> 
> You should probably drop the "use after free" text from your commit log
> because that's not how the perag reference counting works. If you look
> at xfs_perag_put(), you'll see it only drops a reference count and
> returns. We only ever free the perag structs on unmount (or mount
> failure), where we assert the refcount is zero. It looks like some other
> serialization mechanism would have to break down for that assert to fail
> due to this error in the allocation code because the fs is mostly shut
> down at this point in time.

I will follow your guidance to correct the commit log and resubmit the
patch.

Thanks,
Pan

> 
> Misleading commit log aside, the change seems fine to me. I think it's
> appropriate to follow the traditional/implied _get()/_put() pattern.
> 
> Brian
> 
> > Best regards,
> > Pan Bian
> > 
