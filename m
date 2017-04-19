Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764004AbdDSOEu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 10:04:50 -0400
Date: Wed, 19 Apr 2017 16:04:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
Message-ID: <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mw@dermichi.com

If I am not blind, the task currently owning the cpu isn't listed there, which I
suppose to be already running.

Next time you hit it, could you please paste the stack trace of the task owning
the cpu? Which I suppose to be xfsaild according to your report.

A simple `cat /proc/<pid>/stack` is probably enough

thanks

> > * dmesg output from hung tasks
> [25012.200938] INFO: task kworker/u12:0:39771 blocked for more than 120
> seconds.
> [25012.201036]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.201125] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.201220] kworker/u12:0   D    0 39771      2 0x00000000
> [25012.201229] Workqueue: writeback wb_workfn (flush-9:127)
> [25012.201231] Call Trace:
> [25012.201241]  ? __schedule+0x2e0/0x910
> [25012.201295]  ? xfs_buf_rele+0x5b/0x390 [xfs]
> [25012.201300]  ? schedule+0x32/0x80
> [25012.201344]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
> [25012.201385]  ? xlog_grant_head_check+0x9a/0x110 [xfs]

> [25012.201777] INFO: task rm:44141 blocked for more than 120 seconds.
> [25012.201868]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.201957] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.202051] rm              D    0 44141  43912 0x00000000
> [25012.202054] Call Trace:
> [25012.202059]  ? __schedule+0x2e0/0x910
> [25012.202097]  ? xfs_dir_open+0x59/0x70 [xfs]
> [25012.202102]  ? schedule+0x32/0x80

> [25012.202392] INFO: task rm:44149 blocked for more than 120 seconds.
> [25012.202483]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.202571] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.202665] rm              D    0 44149  43923 0x00000000
> [25012.202668] Call Trace:
> [25012.202672]  ? __schedule+0x2e0/0x910
> [25012.202676]  ? schedule+0x32/0x80

> [25012.202958] INFO: task rsync:44358 blocked for more than 120 seconds.
> [25012.203050]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.203138] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.203233] rsync           D    0 44358  44355 0x00000000
> [25012.203235] Call Trace:
> [25012.203239]  ? __schedule+0x2e0/0x910
> [25012.203242]  ? walk_component+0x4b/0x630
> [25012.203245]  ? schedule+0x32/0x80
> [25012.203284]  ? xlog_grant_head_wait+0xca/0x200 [xfs]

> [25012.203530] INFO: task rsync:44370 blocked for more than 120 seconds.
> [25012.203622]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.203710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.203804] rsync           D    0 44370  44365 0x00000000
> [25012.203806] Call Trace:
> [25012.203811]  ? __schedule+0x2e0/0x910
> [25012.203814]  ? schedule+0x32/0x80
> [25012.203852]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
> [25012.203889]  ? xlog_grant_head_check+0x9a/0x110 [xfs]

> [25012.204171] INFO: task rsync:44480 blocked for more than 120 seconds.
> [25012.204283]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.204393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.204529] rsync           D    0 44480  44477 0x00000000
> [25012.204531] Call Trace:
> [25012.204536]  ? __schedule+0x2e0/0x910
> [25012.204539]  ? walk_component+0x4b/0x630
> [25012.204542]  ? schedule+0x32/0x80

> [25012.204827] INFO: task rsync:44581 blocked for more than 120 seconds.
> [25012.204951]       Tainted: G            E   4.11.0-rc5-mw #1
> [25012.205062] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25012.205200] rsync           D    0 44581  44580 0x00000000
> [25012.205202] Call Trace:
> [25012.205207]  ? __schedule+0x2e0/0x910
> [25012.205245]  ? xfs_trans_free_items+0x75/0xa0 [xfs]
> [25012.205249]  ? schedule+0x32/0x80
> [25012.205286]  ? xlog_grant_head_wait+0xca/0x200 [xfs]

> [25133.028169] INFO: task kworker/1:0:24106 blocked for more than 120
> seconds.
> [25133.028288]       Tainted: G            E   4.11.0-rc5-mw #1
> [25133.028397] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25133.028535] kworker/1:0     D    0 24106      2 0x00000000
> [25133.028595] Workqueue: xfs-eofblocks/md127 xfs_eofblocks_worker [xfs]
> [25133.028598] Call Trace:
> [25133.028606]  ? __schedule+0x2e0/0x910
> [25133.028609]  ? schedule+0x32/0x80
> [25133.028655]  ? xlog_grant_head_wait+0xca/0x200 [xfs]

> [25133.029188] INFO: task kworker/u12:0:39771 blocked for more than 120
> seconds.
> [25133.029303]       Tainted: G            E   4.11.0-rc5-mw #1
> [25133.029412] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25133.029549] kworker/u12:0   D    0 39771      2 0x00000000
> [25133.029556] Workqueue: writeback wb_workfn (flush-9:127)
> [25133.029558] Call Trace:
> [25133.029563]  ? __schedule+0x2e0/0x910
> [25133.029600]  ? xfs_buf_rele+0x5b/0x390 [xfs]
> [25133.029605]  ? schedule+0x32/0x80
> [25133.029647]  ? xlog_grant_head_wait+0xca/0x200 [xfs]

> [25133.030070] INFO: task rm:44141 blocked for more than 120 seconds.
> [25133.030182]       Tainted: G            E   4.11.0-rc5-mw #1
> [25133.030291] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [25133.030428] rm              D    0 44141  43912 0x00000000
> [25133.030430] Call Trace:
> [25133.030435]  ? __schedule+0x2e0/0x910
> [25133.030472]  ? xfs_dir_open+0x59/0x70 [xfs]
> [25133.030477]  ? schedule+0x32/0x80
> 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
