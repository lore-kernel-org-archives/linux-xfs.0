Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933862AbdC3OhB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 10:37:01 -0400
Date: Thu, 30 Mar 2017 16:36:52 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170330143652.GA4326@dhcp22.suse.cz>
References: <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz>
 <20170329105536.GH27994@dhcp22.suse.cz>
 <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
 <20170329111650.GI27994@dhcp22.suse.cz>
 <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
 <20170330062500.GB1972@dhcp22.suse.cz>
 <CAOi1vP8z4hngZecp6MoOOhKsLadZ5eJbQ92MvAGBbqdN03CfPw@mail.gmail.com>
 <20170330112126.GE1972@dhcp22.suse.cz>
 <CAOi1vP9Mdk+meGj39+wccBa6HN07y-pDxMLJj_xmAYBsRSoy1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP9Mdk+meGj39+wccBa6HN07y-pDxMLJj_xmAYBsRSoy1g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Thu 30-03-17 15:48:42, Ilya Dryomov wrote:
> On Thu, Mar 30, 2017 at 1:21 PM, Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > familiar with Ceph at all but does any of its (slab) shrinkers generate
> > IO to recurse back?
> 
> We don't register any custom shrinkers.  This is XFS on top of rbd,
> a ceph-backed block device.

OK, that was the part I was missing. So you depend on the XFS to make a
forward progress here.

> >> Well,
> >> it's got to go through the same ceph_connection:
> >>
> >> rbd_queue_workfn
> >>   ceph_osdc_start_request
> >>     ceph_con_send
> >>       mutex_lock(&con->mutex)  # deadlock, OSD X worker is knocked out
> >>
> >> Now if that was a GFP_NOIO allocation, we would simply block in the
> >> allocator.  The placement algorithm distributes objects across the OSDs
> >> in a pseudo-random fashion, so even if we had a whole bunch of I/Os for
> >> that OSD, some other I/Os for other OSDs would complete in the meantime
> >> and free up memory.  If we are under the kind of memory pressure that
> >> makes GFP_NOIO allocations block for an extended period of time, we are
> >> bound to have a lot of pre-open sockets, as we would have done at least
> >> some flushing by then.
> >
> > How is this any different from xfs waiting for its IO to be done?
> 
> I feel like we are talking past each other here.  If the worker in
> question isn't deadlocked, it will eventually get its socket and start
> flushing I/O.  If it has deadlocked, it won't...

But if the allocation is stuck then the holder of the lock cannot make
a forward progress and it is effectivelly deadlocked because other IO
depends on the lock it holds. Maybe I just ask bad questions but what
makes GFP_NOIO different from GFP_KERNEL here. We know that the later
might need to wait for an IO to finish in the shrinker but it itself
doesn't get the lock in question directly. The former depends on the
allocator forward progress as well and that in turn wait for somebody
else to proceed with the IO. So to me any blocking allocation while
holding a lock which blocks further IO to complete is simply broken.
-- 
Michal Hocko
SUSE Labs
