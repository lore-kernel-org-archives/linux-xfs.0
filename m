Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21824 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751824AbcKCBd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2016 21:33:57 -0400
Date: Thu, 3 Nov 2016 12:31:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quota-enabled XFS hangs during mount
Message-ID: <20161103013153.GH9920@dastard>
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
 <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Svec <martin.svec@zoner.cz>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2016 at 05:31:00PM +0100, Martin Svec wrote:
> Hello,
> 
> Dne 1.11.2016 v 22:58 Dave Chinner napsal(a):
> > On Tue, Nov 01, 2016 at 05:45:04PM +0100, Martin Svec wrote:
> >> Hello,
> >>
> >> with user and group quotas enabled, XFS freezes during mount and the following error is reported to
> >> dmesg (Debian 8 kernel 3.16.0-4):
> <SNIP>
> >> Ugh. Please turn on CONFIG_FRAME_POINTER=y. However, it still looks
> >> like it's waiting on IO completion.
> 
> Below is a vanilla 4.6.7 calltrace compiled with frame pointers:
> 
> [  360.235106] INFO: task mount:785 blocked for more than 120 seconds.
> [  360.235143]       Tainted: G            E   4.6.7-xfs1 #20
> [  360.235167] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  360.235200] mount           D ffff88007a1df978     0   785    737 0x00000000
> [  360.235238]  ffff88007a1df978 00000001c01d7770 ffffffff81c0d540 ffff880036d44240
> [  360.235276]  ffff88007a1e0000 7fffffffffffffff ffff880079e5fe80 ffff880036d44240
> [  360.235313]  ffff88007a1dfb08 ffff88007a1df990 ffffffff815fd4e5 ffff880079e5fe88
> [  360.236367] Call Trace:
> [  360.237057]  [<ffffffff815fd4e5>] schedule+0x35/0x80
> [  360.237753]  [<ffffffff8160065f>] schedule_timeout+0x22f/0x2c0
> [  360.238448]  [<ffffffff8133607d>] ? radix_tree_lookup+0xd/0x10
> [  360.239238]  [<ffffffffc019c8da>] ? xfs_perag_get+0x2a/0xb0 [xfs]
> [  360.239979]  [<ffffffff815fdfaa>] wait_for_completion+0xfa/0x130
> [  360.240672]  [<ffffffff810aa250>] ? wake_up_q+0x70/0x70
> [  360.241395]  [<ffffffffc01dce42>] xfs_qm_flush_one+0x82/0xc0 [xfs]
> [  360.242094]  [<ffffffffc01dcdc0>] ? xfs_qm_dqattach_one+0x120/0x120 [xfs]
> [  360.242795]  [<ffffffffc01dd23c>] xfs_qm_dquot_walk.isra.10+0xec/0x170 [xfs]
> [  360.243513]  [<ffffffffc01df295>] xfs_qm_quotacheck+0x255/0x310 [xfs]
> [  360.244202]  [<ffffffffc01df434>] xfs_qm_mount_quotas+0xe4/0x170 [xfs]

So this is waiting for the flush lock to be released before writing
the dquot to disk. Something else is holding on to it...

> >>          =                       crc=0        finobt=0
> >> data     =                       bsize=4096   blocks=66846464, imaxpct=25
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> >> log      =internal               bsize=4096   blocks=2560, version=2
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>
> >> Disk usage:
> >>
> >> orthosie:~# df
> >> Filesystem     1K-blocks      Used Available Use% Mounted on
> >> /dev/sdd1      267375616 225270324  42105292  85% /www
> > How many inodes? How much RAM?
> 
> orthosie:~# df -i
> Filesystem        Inodes   IUsed     IFree IUse% Mounted on
> /dev/sdd1      173746096 5214637 168531459    4% /www
> 
> The virtual machine has 2 virtual cores and 2 GB RAM. None of it is a bottleneck, I think.

Even though you think this is irrelevant and not important, it
actually points me directly at a potential vector and a reason as to
why this is not a comonly seen problem.

i.e. 5.2 million inodes with only 2GB RAM is enough to cause memory
pressure during a quotacheck. inode buffers alone will require
a minimum of 1.5GB RAM over the course of the quotacheck, and memory
reclaim will iterate cached dquots and try to flush them, thereby
exercising the flush lock /before/ the quotacheck scan completion
dquot writeback tries to take it.

Now I need to go read code....

> >> Any ideas what's wrong? How can I help to fix the problem? Note
> >> that the server is a non-production clone of a virtual machine
> >> where the problem originally occurred. So I'm free to any tests
> >> and experiments.
> > What else is stuck when the hung task trigger fires (sysrq-w
> > output)? Is there still IO going on when the hung task warning comes
> > up, or it the system completely idle at this point?
> 
> The system is fully responsive, no other hung tasks or system stalls. Only load average is increased
> to 1.0 due to the hung kernel task. There's no I/O on the affected block device and the system is idle.

So there's no /visible/ issues. But, there's still other things that
can be hidden (e.g. IO submission/completion stall resulting in the
flush lock not being released) which is why I asked for the output
of sysrq-w as it may fill in a missing piece of the puzzle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
