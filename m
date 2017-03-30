Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933192AbdC3LV3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 07:21:29 -0400
Date: Thu, 30 Mar 2017 13:21:26 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170330112126.GE1972@dhcp22.suse.cz>
References: <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz>
 <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz>
 <20170329105536.GH27994@dhcp22.suse.cz>
 <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
 <20170329111650.GI27994@dhcp22.suse.cz>
 <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
 <20170330062500.GB1972@dhcp22.suse.cz>
 <CAOi1vP8z4hngZecp6MoOOhKsLadZ5eJbQ92MvAGBbqdN03CfPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP8z4hngZecp6MoOOhKsLadZ5eJbQ92MvAGBbqdN03CfPw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Thu 30-03-17 12:02:03, Ilya Dryomov wrote:
> On Thu, Mar 30, 2017 at 8:25 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Wed 29-03-17 16:25:18, Ilya Dryomov wrote:
[...]
> >> We got rid of osdc->request_mutex in 4.7, so these workers are almost
> >> independent in newer kernels and should be able to free up memory for
> >> those blocked on GFP_NOIO retries with their respective con->mutex
> >> held.  Using GFP_KERNEL and thus allowing the recursion is just asking
> >> for an AA deadlock on con->mutex OTOH, so it does make a difference.
> >
> > You keep saying this but so far I haven't heard how the AA deadlock is
> > possible. Both GFP_KERNEL and GFP_NOIO can stall for an unbounded amount
> > of time and that would cause you problems AFAIU.
> 
> Suppose we have an I/O for OSD X, which means it's got to go through
> ceph_connection X:
> 
> ceph_con_workfn
>   mutex_lock(&con->mutex)
>     try_write
>       ceph_tcp_connect
>         sock_create_kern
>           GFP_KERNEL allocation
> 
> Suppose that generates another I/O for OSD X and blocks on it.

Yeah, I have understand that but I am asking _who_ is going to generate
that IO. We do not do writeback from the direct reclaim path. I am not
familiar with Ceph at all but does any of its (slab) shrinkers generate
IO to recurse back?

> Well,
> it's got to go through the same ceph_connection:
> 
> rbd_queue_workfn
>   ceph_osdc_start_request
>     ceph_con_send
>       mutex_lock(&con->mutex)  # deadlock, OSD X worker is knocked out
> 
> Now if that was a GFP_NOIO allocation, we would simply block in the
> allocator.  The placement algorithm distributes objects across the OSDs
> in a pseudo-random fashion, so even if we had a whole bunch of I/Os for
> that OSD, some other I/Os for other OSDs would complete in the meantime
> and free up memory.  If we are under the kind of memory pressure that
> makes GFP_NOIO allocations block for an extended period of time, we are
> bound to have a lot of pre-open sockets, as we would have done at least
> some flushing by then.

How is this any different from xfs waiting for its IO to be done?
-- 
Michal Hocko
SUSE Labs
