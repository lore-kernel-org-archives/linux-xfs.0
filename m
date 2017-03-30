Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934128AbdC3Soq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 14:44:46 -0400
Date: Thu, 30 Mar 2017 20:44:41 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170330184441.GA13830@dhcp22.suse.cz>
References: <20170329111650.GI27994@dhcp22.suse.cz>
 <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
 <20170330062500.GB1972@dhcp22.suse.cz>
 <CAOi1vP8z4hngZecp6MoOOhKsLadZ5eJbQ92MvAGBbqdN03CfPw@mail.gmail.com>
 <20170330112126.GE1972@dhcp22.suse.cz>
 <CAOi1vP9Mdk+meGj39+wccBa6HN07y-pDxMLJj_xmAYBsRSoy1g@mail.gmail.com>
 <20170330143652.GA4326@dhcp22.suse.cz>
 <CAOi1vP_6zY5vZgYwBGEajz1nrjda7cDbWSLOhnBJGE=JZK1vBg@mail.gmail.com>
 <20170330161204.GD4326@dhcp22.suse.cz>
 <CAOi1vP_hF5Z3gO3jfwL-fUFFZdk5X+ESvKF5gyc9UAzyqKhdXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP_hF5Z3gO3jfwL-fUFFZdk5X+ESvKF5gyc9UAzyqKhdXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Thu 30-03-17 19:19:59, Ilya Dryomov wrote:
> On Thu, Mar 30, 2017 at 6:12 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Thu 30-03-17 17:06:51, Ilya Dryomov wrote:
> > [...]
> >> > But if the allocation is stuck then the holder of the lock cannot make
> >> > a forward progress and it is effectivelly deadlocked because other IO
> >> > depends on the lock it holds. Maybe I just ask bad questions but what
> >>
> >> Only I/O to the same OSD.  A typical ceph cluster has dozens of OSDs,
> >> so there is plenty of room for other in-flight I/Os to finish and move
> >> the allocator forward.  The lock in question is per-ceph_connection
> >> (read: per-OSD).
> >>
> >> > makes GFP_NOIO different from GFP_KERNEL here. We know that the later
> >> > might need to wait for an IO to finish in the shrinker but it itself
> >> > doesn't get the lock in question directly. The former depends on the
> >> > allocator forward progress as well and that in turn wait for somebody
> >> > else to proceed with the IO. So to me any blocking allocation while
> >> > holding a lock which blocks further IO to complete is simply broken.
> >>
> >> Right, with GFP_NOIO we simply wait -- there is nothing wrong with
> >> a blocking allocation, at least in the general case.  With GFP_KERNEL
> >> we deadlock, either in rbd/libceph (less likely) or in the filesystem
> >> above (more likely, shown in the xfs_reclaim_inodes_ag() traces you
> >> omitted in your quote).
> >
> > I am not convinced. It seems you are relying on something that is not
> > guaranteed fundamentally. AFAIU all the IO paths should _guarantee_
> > and use mempools for that purpose if they need to allocate.
> >
> > But, hey, I will not argue as my understanding of ceph is close to
> > zero. You are the maintainer so it is your call. I would just really
> > appreciate if you could document this as much as possible (ideally
> > at the place where you call memalloc_noio_save and describe the lock
> > dependency there).
> 
> It's certainly not perfect (especially this socket case -- putting
> together a pool of sockets is not easy) and I'm sure one could poke
> some holes in the entire thing,

I would recommend testing under a heavy memory pressure (involving OOM
killer invocations) with a lot of IO pressure to see what falls out.

> but I'm convinced we are much better
> off with the memalloc_noio_{save,restore}() pair in there.
> 
> I'll try to come up with a better comment, but the problem is that it
> can be an arbitrary lock in an arbitrary filesystem, not just libceph's
> con->mutex, so it's hard to be specific.

But the particular path should describe what is the deadlock scenario
regardless of the FS (xfs is likely not the only one to wait for the
IO to finish).

> Do I have your OK to poke Greg to get the backports going?

As I've said, it's your call, if you feel comfortable with this then I
will certainly not stand in the way.

-- 
Michal Hocko
SUSE Labs
