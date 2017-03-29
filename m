Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756078AbdC2Kzx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 06:55:53 -0400
Date: Wed, 29 Mar 2017 12:55:36 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170329105536.GH27994@dhcp22.suse.cz>
References: <20170328122559.966310440@linuxfoundation.org>
 <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz>
 <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz>
 <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170329104126.GF27994@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Wed 29-03-17 12:41:26, Michal Hocko wrote:
[...]
> > ceph_con_workfn
> >   mutex_lock(&con->mutex)  # ceph_connection::mutex
> >   try_write
> >     ceph_tcp_connect
> >       sock_create_kern
> >         GFP_KERNEL allocation
> >           allocator recurses into XFS, more I/O is issued

One more note. So what happens if this is a GFP_NOIO request which
cannot make any progress? Your IO thread is blocked on con->mutex
as you write below but the above thread cannot proceed as well. So I am
_really_ not sure this acutally helps.

[...]
> > 
> > rbd_queue_workfn
> >   ceph_osdc_start_request
> >     mutex_lock(&osdc->request_mutex);
> >     ceph_con_send
> >       mutex_lock(&con->mutex)  # deadlock

-- 
Michal Hocko
SUSE Labs
