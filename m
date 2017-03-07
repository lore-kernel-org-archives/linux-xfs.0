Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755580AbdCGP3p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 10:29:45 -0500
Date: Tue, 7 Mar 2017 16:09:56 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4/7] mm: introduce memalloc_nofs_{save,restore} API
Message-ID: <20170307150956.GM28642@dhcp22.suse.cz>
References: <20170306131408.9828-1-mhocko@kernel.org>
 <20170306131408.9828-5-mhocko@kernel.org>
 <20170306132214.1769368301d9e671e1bc68be@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306132214.1769368301d9e671e1bc68be@linux-foundation.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>

On Mon 06-03-17 13:22:14, Andrew Morton wrote:
> On Mon,  6 Mar 2017 14:14:05 +0100 Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -210,8 +210,16 @@ struct vm_area_struct;
> >   *
> >   * GFP_NOIO will use direct reclaim to discard clean pages or slab pages
> >   *   that do not require the starting of any physical IO.
> > + *   Please try to avoid using this flag directly and instead use
> > + *   memalloc_noio_{save,restore} to mark the whole scope which cannot
> > + *   perform any IO with a short explanation why. All allocation requests
> > + *   will inherit GFP_NOIO implicitly.
> >   *
> >   * GFP_NOFS will use direct reclaim but will not use any filesystem interfaces.
> > + *   Please try to avoid using this flag directly and instead use
> > + *   memalloc_nofs_{save,restore} to mark the whole scope which cannot/shouldn't
> > + *   recurse into the FS layer with a short explanation why. All allocation
> > + *   requests will inherit GFP_NOFS implicitly.
> 
> I wonder if these are worth a checkpatch rule.

I am not really sure, to be honest. This may easilly end up people
replacing

do_alloc(GFP_NOFS)

with

memalloc_nofs_save()
do_alloc(GFP_KERNEL)
memalloc_nofs_restore()

which doesn't make any sense of course. From my experience, people tend
to do stupid things just to silent checkpatch warnings very often.
Moreover I believe we need to do the transition to the new api first
before we can push back on the explicit GFP_NOFS usage. Maybe then we
can think about the a checkpatch warning.

-- 
Michal Hocko
SUSE Labs
