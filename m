Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33246 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbdC2LOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 07:14:45 -0400
MIME-Version: 1.0
In-Reply-To: <20170329110515.GA24681@bfoster.bfoster>
References: <20170328122559.966310440@linuxfoundation.org> <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz> <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz> <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz> <20170329110515.GA24681@bfoster.bfoster>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 29 Mar 2017 13:14:42 +0200
Message-ID: <CAOi1vP-oxuiZZVGZX6Jm9u00nMcSqiMRiSeyaX+R=k4S0Yjutw@mail.gmail.com>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Mar 29, 2017 at 1:05 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Wed, Mar 29, 2017 at 12:41:26PM +0200, Michal Hocko wrote:
>> [CC xfs guys]
>>
>> On Wed 29-03-17 11:21:44, Ilya Dryomov wrote:
>> [...]
>> > This is a set of stack traces from http://tracker.ceph.com/issues/19309
>> > (linked in the changelog):
>> >
>> > Workqueue: ceph-msgr con_work [libceph]
>> > ffff8810871cb018 0000000000000046 0000000000000000 ffff881085d40000
>> > 0000000000012b00 ffff881025cad428 ffff8810871cbfd8 0000000000012b00
>> > ffff880102fc1000 ffff881085d40000 ffff8810871cb038 ffff8810871cb148
>> > Call Trace:
>> > [<ffffffff816dd629>] schedule+0x29/0x70
>> > [<ffffffff816e066d>] schedule_timeout+0x1bd/0x200
>> > [<ffffffff81093ffc>] ? ttwu_do_wakeup+0x2c/0x120
>> > [<ffffffff81094266>] ? ttwu_do_activate.constprop.135+0x66/0x70
>> > [<ffffffff816deb5f>] wait_for_completion+0xbf/0x180
>> > [<ffffffff81097cd0>] ? try_to_wake_up+0x390/0x390
>> > [<ffffffff81086335>] flush_work+0x165/0x250
>>
>> I suspect this is xlog_cil_push_now -> flush_work(&cil->xc_push_work)
>> right? I kind of got lost where this waits on an IO.
>>
>
> Yep. That means a CIL push is already in progress. We wait on that to
> complete here. After that, the resulting task queues execution of
> xlog_cil_push_work()->xlog_cil_push() on m_cil_workqueue. That task may
> submit I/O to the log.
>
> I don't see any reference to xlog_cil_push() anywhere in the traces here
> or in the bug referenced above, however..?

Well, it's prefaced with "Interesting is:"...  Sergey (the original
reporter, CCed here) might still have the rest of them.

Thanks,

                Ilya
