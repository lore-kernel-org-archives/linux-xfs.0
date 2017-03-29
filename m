Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932634AbdC2LSh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 07:18:37 -0400
Date: Wed, 29 Mar 2017 13:18:34 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4.4 48/76] libceph: force GFP_NOIO for socket allocations
Message-ID: <20170329111833.GJ27994@dhcp22.suse.cz>
References: <20170328122559.966310440@linuxfoundation.org>
 <20170328122601.905696872@linuxfoundation.org>
 <20170328124312.GE18241@dhcp22.suse.cz>
 <CAOi1vP-TeEwNM8n=Z5b6yx1epMDVJ4f7+S1poubA7zfT7L0hQQ@mail.gmail.com>
 <20170328133040.GJ18241@dhcp22.suse.cz>
 <CAOi1vP-doHSj8epQ1zLBnEi8QM4Eb7nFb5uo-XeUquZUkhacsg@mail.gmail.com>
 <20170329104126.GF27994@dhcp22.suse.cz>
 <20170329110515.GA24681@bfoster.bfoster>
 <CAOi1vP-oxuiZZVGZX6Jm9u00nMcSqiMRiSeyaX+R=k4S0Yjutw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-oxuiZZVGZX6Jm9u00nMcSqiMRiSeyaX+R=k4S0Yjutw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Sergey Jerusalimov <wintchester@gmail.com>, Jeff Layton <jlayton@redhat.com>, linux-xfs@vger.kernel.org

On Wed 29-03-17 13:14:42, Ilya Dryomov wrote:
> On Wed, Mar 29, 2017 at 1:05 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Wed, Mar 29, 2017 at 12:41:26PM +0200, Michal Hocko wrote:
> >> [CC xfs guys]
> >>
> >> On Wed 29-03-17 11:21:44, Ilya Dryomov wrote:
> >> [...]
> >> > This is a set of stack traces from http://tracker.ceph.com/issues/19309
> >> > (linked in the changelog):
> >> >
> >> > Workqueue: ceph-msgr con_work [libceph]
> >> > ffff8810871cb018 0000000000000046 0000000000000000 ffff881085d40000
> >> > 0000000000012b00 ffff881025cad428 ffff8810871cbfd8 0000000000012b00
> >> > ffff880102fc1000 ffff881085d40000 ffff8810871cb038 ffff8810871cb148
> >> > Call Trace:
> >> > [<ffffffff816dd629>] schedule+0x29/0x70
> >> > [<ffffffff816e066d>] schedule_timeout+0x1bd/0x200
> >> > [<ffffffff81093ffc>] ? ttwu_do_wakeup+0x2c/0x120
> >> > [<ffffffff81094266>] ? ttwu_do_activate.constprop.135+0x66/0x70
> >> > [<ffffffff816deb5f>] wait_for_completion+0xbf/0x180
> >> > [<ffffffff81097cd0>] ? try_to_wake_up+0x390/0x390
> >> > [<ffffffff81086335>] flush_work+0x165/0x250
> >>
> >> I suspect this is xlog_cil_push_now -> flush_work(&cil->xc_push_work)
> >> right? I kind of got lost where this waits on an IO.
> >>
> >
> > Yep. That means a CIL push is already in progress. We wait on that to
> > complete here. After that, the resulting task queues execution of
> > xlog_cil_push_work()->xlog_cil_push() on m_cil_workqueue. That task may
> > submit I/O to the log.
> >
> > I don't see any reference to xlog_cil_push() anywhere in the traces here
> > or in the bug referenced above, however..?
> 
> Well, it's prefaced with "Interesting is:"...  Sergey (the original
> reporter, CCed here) might still have the rest of them.

JFTR
http://tracker.ceph.com/attachments/download/2769/full_kern_trace.txt
[288420.754637] Workqueue: xfs-cil/rbd1 xlog_cil_push_work [xfs]
[288420.754638]  ffff880130c1fb38 0000000000000046 ffff880130c1fac8 ffff880130d72180
[288420.754640]  0000000000012b00 ffff880130c1fad8 ffff880130c1ffd8 0000000000012b00
[288420.754641]  ffff8810297b6480 ffff880130d72180 ffffffffa03b1264 ffff8820263d6800
[288420.754643] Call Trace:
[288420.754652]  [<ffffffffa03b1264>] ? xlog_bdstrat+0x34/0x70 [xfs]
[288420.754653]  [<ffffffff816dd629>] schedule+0x29/0x70
[288420.754661]  [<ffffffffa03b3b9c>] xlog_state_get_iclog_space+0xdc/0x2e0 [xfs]
[288420.754669]  [<ffffffffa03b1264>] ? xlog_bdstrat+0x34/0x70 [xfs]
[288420.754670]  [<ffffffff81097cd0>] ? try_to_wake_up+0x390/0x390
[288420.754678]  [<ffffffffa03b4090>] xlog_write+0x190/0x730 [xfs]
[288420.754686]  [<ffffffffa03b5d9e>] xlog_cil_push+0x24e/0x3e0 [xfs]
[288420.754693]  [<ffffffffa03b5f45>] xlog_cil_push_work+0x15/0x20 [xfs]
[288420.754695]  [<ffffffff81084c19>] process_one_work+0x159/0x4f0
[288420.754697]  [<ffffffff81084fdc>] process_scheduled_works+0x2c/0x40
[288420.754698]  [<ffffffff8108579b>] worker_thread+0x29b/0x530
[288420.754699]  [<ffffffff81085500>] ? create_worker+0x1d0/0x1d0
[288420.754701]  [<ffffffff8108b6f9>] kthread+0xc9/0xe0
[288420.754703]  [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
[288420.754705]  [<ffffffff816e1b98>] ret_from_fork+0x58/0x90
[288420.754707]  [<ffffffff8108b630>] ? flush_kthread_worker+0x90/0x90
-- 
Michal Hocko
SUSE Labs
