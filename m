Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27768 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdGFAYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2017 20:24:44 -0400
Date: Wed, 5 Jul 2017 17:24:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS hang - 4.4.73 longterm
Message-ID: <20170706002436.GA5068@magnolia>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E02746C@EXCHANGE.collogia.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173010E02746C@EXCHANGE.collogia.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Wed, Jul 05, 2017 at 07:19:28PM +0000, Markus Stockhausen wrote:
> Hi,
> 
> we are using a NFS/XFS fileserver and installed the current 4.4.73 longterm kernel.
> From time to time (reason currently unidentified) it spits blocked for 120s messages
> Like the attached ones. Any ideas what might be the reason? I can reproduce it
> With some effort. So in case you want some more logging don't hesitate to ask.
> 
> For more details see https://bugzilla.kernel.org/show_bug.cgi?id=196259
> 
> [1248134.772889] INFO: task nfsd:1623 blocked for more than 120 seconds.
> [1248134.772895]       Tainted: G          I     4.4.73-2.el7.centos.x86_64 #1
> [1248134.772897] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [1248134.772899] nfsd            D ffff880bbf08b9c8     0  1623      2 0x00000080
> [1248134.772905]  ffff880bbf08b9c8 ffff880be0875400 ffff880bbf080000 ffff880bbf08c000
> [1248134.772908]  0000000000000000 7fffffffffffffff ffff880bbf08bb38 ffffffff816fbb40
> [1248134.772911]  ffff880bbf08b9e0 ffffffff816fb2d5 ffff880c176d6d00 ffff880bbf08ba88
> [1248134.772915] Call Trace:
> [1248134.772923]  [<ffffffff816fbb40>] ? bit_wait+0x50/0x50
> [1248134.772926]  [<ffffffff816fb2d5>] schedule+0x35/0x80
> [1248134.772929]  [<ffffffff816fdfe7>] schedule_timeout+0x237/0x2d0
> [1248134.772935]  [<ffffffff8161ee0e>] ? ip_output+0x6e/0xe0
> [1248134.772938]  [<ffffffff8161e502>] ? __ip_local_out+0x92/0x110
> [1248134.772941]  [<ffffffff810f303a>] ? ktime_get+0x3a/0x90
> [1248134.772944]  [<ffffffff816fbb40>] ? bit_wait+0x50/0x50
> [1248134.772947]  [<ffffffff816faa46>] io_schedule_timeout+0xa6/0x110
> [1248134.772950]  [<ffffffff816fbb5b>] bit_wait_io+0x1b/0x60
> [1248134.772952]  [<ffffffff816fb8ee>] __wait_on_bit_lock+0x4e/0xb0
> [1248134.772958]  [<ffffffff81189759>] __lock_page+0xb9/0xe0

Waiting for a page lock with ILOCK held...

> [1248134.772962]  [<ffffffff810c2910>] ? autoremove_wake_function+0x40/0x40
> [1248134.773007]  [<ffffffffa08d7c70>] xfs_find_get_desired_pgoff.isra.10+0x1e0/0x2d0 [xfs]
> [1248134.773039]  [<ffffffffa08d7f9d>] xfs_seek_hole_data+0x23d/0x2c0 [xfs]
> [1248134.773054]  [<ffffffffa05d942c>] ? nfs4_preprocess_stateid_op+0x11c/0x430 [nfsd]
> [1248134.773086]  [<ffffffffa08d803c>] xfs_file_llseek+0x1c/0x40 [xfs]
> [1248134.773090]  [<ffffffff8120633e>] vfs_llseek+0x2e/0x30
> [1248134.773101]  [<ffffffffa05c6080>] nfsd4_seek+0x80/0xe0 [nfsd]
> [1248134.773112]  [<ffffffffa05c8416>] nfsd4_proc_compound+0x3b6/0x710 [nfsd]
> [1248134.773121]  [<ffffffffa05b4f2e>] nfsd_dispatch+0xce/0x270 [nfsd]
> [1248134.773142]  [<ffffffffa01a5134>] svc_process_common+0x454/0x720 [sunrpc]
> [1248134.773151]  [<ffffffffa05b4880>] ? nfsd_destroy+0x60/0x60 [nfsd]
> [1248134.773168]  [<ffffffffa01a5505>] svc_process+0x105/0x1c0 [sunrpc]
> [1248134.773177]  [<ffffffffa05b4970>] nfsd+0xf0/0x160 [nfsd]
> [1248134.773180]  [<ffffffff8109d755>] kthread+0xe5/0x100
> [1248134.773183]  [<ffffffff8109d670>] ? kthread_park+0x60/0x60
> [1248134.773187]  [<ffffffff816ff1cf>] ret_from_fork+0x3f/0x70
> [1248134.773190]  [<ffffffff8109d670>] ? kthread_park+0x60/0x60
> [1248134.773193] INFO: task nfsd:1624 blocked for more than 120 seconds.
> [1248134.773195]       Tainted: G          I     4.4.73-2.el7.centos.x86_64 #1
> [1248134.773197] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [1248134.773198] nfsd            D ffff880bbf1a7738     0  1624      2 0x00000080
> [1248134.773202]  ffff880bbf1a7738 ffffffff81a79500 ffff880bbf081500 ffff880bbf1a8000
> [1248134.773205]  ffff8802334477a8 ffff880233447790 ffffffff00000000 ffffffff00000001
> [1248134.773208]  ffff880bbf1a7750 ffffffff816fb2d5 ffff880bbf081500 ffff880bbf1a77e0
> [1248134.773211] Call Trace:
> [1248134.773214]  [<ffffffff816fb2d5>] schedule+0x35/0x80
> [1248134.773217]  [<ffffffff816fdab5>] rwsem_down_write_failed+0x1f5/0x320
> [1248134.773243]  [<ffffffffa089e722>] ? xfs_bmap_search_extents+0x72/0xe0 [xfs]
> [1248134.773273]  [<ffffffffa08cd212>] ? __xfs_get_blocks+0x162/0x800 [xfs]
> [1248134.773276]  [<ffffffff81346433>] call_rwsem_down_write_failed+0x13/0x20
> [1248134.773279]  [<ffffffff816fd35d>] ? down_write+0x2d/0x40
> [1248134.773311]  [<ffffffffa08e459a>] xfs_ilock+0xea/0x130 [xfs]

...and waiting for the ILOCK with page lock held.

This is the known deadlock in SEEK_HOLE/SEEK_DATA; I have patches queued
to fix it in 4.13, as soon as the dust settles and I send the pull req.

--D

> [1248134.773341]  [<ffffffffa08cd212>] __xfs_get_blocks+0x162/0x800 [xfs]
> [1248134.773371]  [<ffffffffa08cd8c4>] xfs_get_blocks+0x14/0x20 [xfs]
> [1248134.773375]  [<ffffffff8123f349>] __block_write_begin+0x1a9/0x4c0
> [1248134.773405]  [<ffffffffa08cd8b0>] ? __xfs_get_blocks+0x800/0x800 [xfs]
> [1248134.773435]  [<ffffffffa08cbae1>] xfs_vm_write_begin+0x51/0xe0 [xfs]
> [1248134.773464]  [<ffffffffa08cb8f9>] ? xfs_vm_write_end+0x29/0x80 [xfs]
> [1248134.773468]  [<ffffffff81189aef>] generic_perform_write+0xcf/0x1c0
> [1248134.773499]  [<ffffffffa08d9615>] xfs_file_buffered_aio_write+0x135/0x290 [xfs]
> [1248134.773503]  [<ffffffff812bae93>] ? selinux_file_permission+0xc3/0x110
> [1248134.773534]  [<ffffffffa08d9801>] xfs_file_write_iter+0x91/0x150 [xfs]
> [1248134.773566]  [<ffffffffa08d9770>] ? xfs_file_buffered_aio_write+0x290/0x290 [xfs]
> [1248134.773569]  [<ffffffff812072dc>] do_readv_writev+0x1ec/0x2a0
> [1248134.773573]  [<ffffffff816fe8a5>] ? _raw_spin_unlock_irqrestore+0x15/0x20
> [1248134.773576]  [<ffffffff810c22f4>] ? __wake_up+0x44/0x50
> [1248134.773579]  [<ffffffff81207419>] vfs_writev+0x39/0x50
> [1248134.773589]  [<ffffffffa05b9d40>] nfsd_vfs_write+0xc0/0x370 [nfsd]
> [1248134.773600]  [<ffffffffa05c64a3>] nfsd4_write+0x1a3/0x200 [nfsd]
> [1248134.773611]  [<ffffffffa05c8416>] nfsd4_proc_compound+0x3b6/0x710 [nfsd]
> [1248134.773620]  [<ffffffffa05b4f2e>] nfsd_dispatch+0xce/0x270 [nfsd]
> [1248134.773638]  [<ffffffffa01a5134>] svc_process_common+0x454/0x720 [sunrpc]
> [1248134.773647]  [<ffffffffa05b4880>] ? nfsd_destroy+0x60/0x60 [nfsd]
> [1248134.773664]  [<ffffffffa01a5505>] svc_process+0x105/0x1c0 [sunrpc]
> [1248134.773672]  [<ffffffffa05b4970>] nfsd+0xf0/0x160 [nfsd]
> [1248134.773675]  [<ffffffff8109d755>] kthread+0xe5/0x100
> [1248134.773678]  [<ffffffff8109d670>] ? kthread_park+0x60/0x60
> [1248134.773682]  [<ffffffff816ff1cf>] ret_from_fork+0x3f/0x70
> [1248134.773684]  [<ffffffff8109d670>] ? kthread_park+0x60/0x60
> 
> Thanks in advance.
> 
> Markus

> ****************************************************************************
> Diese E-Mail enth??lt vertrauliche und/oder rechtlich gesch??tzte
> Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
> irrt??mlich erhalten haben, informieren Sie bitte sofort den Absender und
> vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
> Weitergabe dieser Mail ist nicht gestattet.
> 
> ??ber das Internet versandte E-Mails k??nnen unter fremden Namen erstellt oder
> manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
> rechtsverbindliche Willenserkl??rung.
> 
> Collogia
> Unternehmensberatung AG
> Ubierring 11
> D-50678 K??ln
> 
> Vorstand:
> Kadir Akin
> Dr. Michael H??hnerbach
> 
> Vorsitzender des Aufsichtsrates:
> Hans Kristian Langva
> 
> Registergericht: Amtsgericht K??ln
> Registernummer: HRB 52 497
> 
> This e-mail may contain confidential and/or privileged information. If you
> are not the intended recipient (or have received this e-mail in error)
> please notify the sender immediately and destroy this e-mail. Any
> unauthorized copying, disclosure or distribution of the material in this
> e-mail is strictly forbidden.
> 
> e-mails sent over the internet may have been written under a wrong name or
> been manipulated. That is why this message sent as an e-mail is not a
> legally binding declaration of intention.
> 
> Collogia
> Unternehmensberatung AG
> Ubierring 11
> D-50678 K??ln
> 
> executive board:
> Kadir Akin
> Dr. Michael H??hnerbach
> 
> President of the supervisory board:
> Hans Kristian Langva
> 
> Registry office: district court Cologne
> Register number: HRB 52 497
> 
> ****************************************************************************

