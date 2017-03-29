Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33175 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdC2OZU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 10:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <20170329111650.GI27994@dhcp22.suse.cz>
References: <20170328122559.966310440@linuxfoundation.org> <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz> <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz> <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz> <20170329105536.GH27994@dhcp22.suse.cz>
 <CAOi1vP93+MAQsSKpEGcrK0h3WpUH2rFnaFR4nUhhAQAXk0mrNA@mail.gmail.com> <20170329111650.GI27994@dhcp22.suse.cz>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 29 Mar 2017 16:25:18 +0200
Message-ID: <CAOi1vP_6HvHAGo4Neu=q_LY_m_NRmSRkkGsW=95xYctLUdag6A@mail.gmail.com>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Mar 29, 2017 at 1:16 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 29-03-17 13:10:01, Ilya Dryomov wrote:
>> On Wed, Mar 29, 2017 at 12:55 PM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Wed 29-03-17 12:41:26, Michal Hocko wrote:
>> > [...]
>> >> > ceph_con_workfn
>> >> >   mutex_lock(&con->mutex)  # ceph_connection::mutex
>> >> >   try_write
>> >> >     ceph_tcp_connect
>> >> >       sock_create_kern
>> >> >         GFP_KERNEL allocation
>> >> >           allocator recurses into XFS, more I/O is issued
>> >
>> > One more note. So what happens if this is a GFP_NOIO request which
>> > cannot make any progress? Your IO thread is blocked on con->mutex
>> > as you write below but the above thread cannot proceed as well. So I am
>> > _really_ not sure this acutally helps.
>>
>> This is not the only I/O worker.  A ceph cluster typically consists of
>> at least a few OSDs and can be as large as thousands of OSDs.  This is
>> the reason we are calling sock_create_kern() on the writeback path in
>> the first place: pre-opening thousands of sockets isn't feasible.
>
> Sorry for being dense here but what actually guarantees the forward
> progress? My current understanding is that the deadlock is caused by
> con->mutext being held while the allocation cannot make a forward
> progress. I can imagine this would be possible if the other io flushers
> depend on this lock. But then NOIO vs. KERNEL allocation doesn't make
> much difference. What am I missing?

con->mutex is per-ceph_connection, osdc->request_mutex is global and is
the real problem here because we need both on the submit side, at least
in 3.18.  You are correct that even with GFP_NOIO this code may lock up
in theory, however I think it's very unlikely in practice.

We got rid of osdc->request_mutex in 4.7, so these workers are almost
independent in newer kernels and should be able to free up memory for
those blocked on GFP_NOIO retries with their respective con->mutex
held.  Using GFP_KERNEL and thus allowing the recursion is just asking
for an AA deadlock on con->mutex OTOH, so it does make a difference.

I'm a little confused by this discussion because for me this patch was
a no-brainer...  Locking aside, you said it was the stack trace in the
changelog that got your attention -- are you saying it's OK for a block
device to recurse back into the filesystem when doing I/O, potentially
generating more I/O?

Thanks,

                Ilya
