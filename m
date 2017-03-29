Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34894 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755709AbdC2LKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 07:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <20170329105536.GH27994@dhcp22.suse.cz>
References: <20170328122559.966310440@linuxfoundation.org> <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz> <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz> <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz> <20170329105536.GH27994@dhcp22.suse.cz>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 29 Mar 2017 13:10:01 +0200
Message-ID: <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Mar 29, 2017 at 12:55 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 29-03-17 12:41:26, Michal Hocko wrote:
> [...]
>> > ceph_con_workfn
>> >   mutex_lock(&con->mutex)  # ceph_connection::mutex
>> >   try_write
>> >     ceph_tcp_connect
>> >       sock_create_kern
>> >         GFP_KERNEL allocation
>> >           allocator recurses into XFS, more I/O is issued
>
> One more note. So what happens if this is a GFP_NOIO request which
> cannot make any progress? Your IO thread is blocked on con->mutex
> as you write below but the above thread cannot proceed as well. So I am
> _really_ not sure this acutally helps.

This is not the only I/O worker.  A ceph cluster typically consists of
at least a few OSDs and can be as large as thousands of OSDs.  This is
the reason we are calling sock_create_kern() on the writeback path in
the first place: pre-opening thousands of sockets isn't feasible.

Thanks,

                Ilya
