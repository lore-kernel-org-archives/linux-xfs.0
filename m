Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36055 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755984AbdC2LQy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 07:16:54 -0400
Date: Wed, 29 Mar 2017 13:16:51 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170329111650.GI27994@dhcp22.suse.cz>
References: <20170328122559.966310440@linuxfoundation.org>
 <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz>
 <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz>
 <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz>
 <20170329105536.GH27994@dhcp22.suse.cz>
 <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Wed 29-03-17 13:10:01, Ilya Dryomov wrote:
> On Wed, Mar 29, 2017 at 12:55 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Wed 29-03-17 12:41:26, Michal Hocko wrote:
> > [...]
> >> > ceph_con_workfn
> >> >   mutex_lock(&con->mutex)  # ceph_connection::mutex
> >> >   try_write
> >> >     ceph_tcp_connect
> >> >       sock_create_kern
> >> >         GFP_KERNEL allocation
> >> >           allocator recurses into XFS, more I/O is issued
> >
> > One more note. So what happens if this is a GFP_NOIO request which
> > cannot make any progress? Your IO thread is blocked on con->mutex
> > as you write below but the above thread cannot proceed as well. So I am
> > _really_ not sure this acutally helps.
> 
> This is not the only I/O worker.  A ceph cluster typically consists of
> at least a few OSDs and can be as large as thousands of OSDs.  This is
> the reason we are calling sock_create_kern() on the writeback path in
> the first place: pre-opening thousands of sockets isn't feasible.

Sorry for being dense here but what actually guarantees the forward
progress? My current understanding is that the deadlock is caused by
con->mutext being held while the allocation cannot make a forward
progress. I can imagine this would be possible if the other io flushers
depend on this lock. But then NOIO vs. KERNEL allocation doesn't make
much difference. What am I missing?
-- 
Michal Hocko
SUSE Labs
