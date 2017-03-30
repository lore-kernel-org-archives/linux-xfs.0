Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34598 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933424AbdC3RUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 13:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <20170330161204.GD4326@dhcp22.suse.cz>
References: <20170329105536.GH27994@dhcp22.suse.cz> <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
 <20170329111650.GI27994@dhcp22.suse.cz> <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
 <20170330062500.GB1972@dhcp22.suse.cz> <CAOi1vP8z4hngZecp6MoOOhKsLadZ5eJbQ92MvAGBbqdN03CfPw@mail.gmail.com>
 <20170330112126.GE1972@dhcp22.suse.cz> <CAOi1vP9Mdk+meGj39+wccBa6HN07y-pDxMLJj_xmAYBsRSoy1g@mail.gmail.com>
 <20170330143652.GA4326@dhcp22.suse.cz> <CAOi1vP_6zY5vZgYwBGEajz1nrjda7cDbWSLOhnBJGE=JZK1vBg@mail.gmail.com>
 <20170330161204.GD4326@dhcp22.suse.cz>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 Mar 2017 19:19:59 +0200
Message-ID: <CAOi1vP_hF5Z3gO3jfwL-fUFFZdk5X+ESvKF5gyc9UAzyqKhdXA@mail.gmail.com>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 30, 2017 at 6:12 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Thu 30-03-17 17:06:51, Ilya Dryomov wrote:
> [...]
>> > But if the allocation is stuck then the holder of the lock cannot make
>> > a forward progress and it is effectivelly deadlocked because other IO
>> > depends on the lock it holds. Maybe I just ask bad questions but what
>>
>> Only I/O to the same OSD.  A typical ceph cluster has dozens of OSDs,
>> so there is plenty of room for other in-flight I/Os to finish and move
>> the allocator forward.  The lock in question is per-ceph_connection
>> (read: per-OSD).
>>
>> > makes GFP_NOIO different from GFP_KERNEL here. We know that the later
>> > might need to wait for an IO to finish in the shrinker but it itself
>> > doesn't get the lock in question directly. The former depends on the
>> > allocator forward progress as well and that in turn wait for somebody
>> > else to proceed with the IO. So to me any blocking allocation while
>> > holding a lock which blocks further IO to complete is simply broken.
>>
>> Right, with GFP_NOIO we simply wait -- there is nothing wrong with
>> a blocking allocation, at least in the general case.  With GFP_KERNEL
>> we deadlock, either in rbd/libceph (less likely) or in the filesystem
>> above (more likely, shown in the xfs_reclaim_inodes_ag() traces you
>> omitted in your quote).
>
> I am not convinced. It seems you are relying on something that is not
> guaranteed fundamentally. AFAIU all the IO paths should _guarantee_
> and use mempools for that purpose if they need to allocate.
>
> But, hey, I will not argue as my understanding of ceph is close to
> zero. You are the maintainer so it is your call. I would just really
> appreciate if you could document this as much as possible (ideally
> at the place where you call memalloc_noio_save and describe the lock
> dependency there).

It's certainly not perfect (especially this socket case -- putting
together a pool of sockets is not easy) and I'm sure one could poke
some holes in the entire thing, but I'm convinced we are much better
off with the memalloc_noio_{save,restore}() pair in there.

I'll try to come up with a better comment, but the problem is that it
can be an arbitrary lock in an arbitrary filesystem, not just libceph's
con->mutex, so it's hard to be specific.

Do I have your OK to poke Greg to get the backports going?

Thanks,

                Ilya
