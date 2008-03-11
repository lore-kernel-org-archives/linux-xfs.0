Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 11:14:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BIDd6O030370
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:13:41 -0700
Received: from gw03.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51805686BC3
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:14:09 -0700 (PDT)
Received: from gw03.mail.saunalahti.fi (gw03.mail.saunalahti.fi [195.197.172.111]) by cuda.sgi.com with ESMTP id 8MOq9IKVG8T4hzs5 for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:14:09 -0700 (PDT)
Received: from uunet198.aac.fi (uunet198.aac.fi [193.64.61.198])
	by gw03.mail.saunalahti.fi (Postfix) with ESMTP id 74B682169E9
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 20:14:05 +0200 (EET)
Message-ID: <47D6CBE9.8090905@iki.fi>
Date: Tue, 11 Mar 2008 20:14:01 +0200
From: Erkki Lintunen <erkki.lintunen@iki.fi>
MIME-Version: 1.0
Subject: Re: an occational trouble with xfs file system which xfs_repair 2.7.14
 has been able to fix
References: <47D52BE5.6010706@iki.fi> <47D5383E.50201@sandeen.net>
In-Reply-To: <47D5383E.50201@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

on 10.3.2008 15:31 Eric Sandeen wrote:
> Erkki Lintunen wrote:
>> the cp -al commands haven't. Most of the time the cp -al process has D 
>> status.
> 
>> What else information I could provide in addition to those requested in FAQ?
> 
> When you get a process in the D state, do echo t > /proc/sysrq-trigger
> to get backtraces of all processes; or echo w to get all blocked processes.

Thanks for the tip. Unfortunately I couldn't get my hands onto the 
system before the message below on the console and SysRq rebooting the 
system today.

 From the log the script had stopped to cp -al again and in the same 
tree. My wild guess is that the script shouldn't have had anything to 
talk to network at the time kernel soft lockup nor there isn't any other 
services experiencing network traffic.

I upgraded kernel to 2.6.24.3, ran xfs_repair 2.9.7 on the xfs file 
system and rest the case for next run.

Best regards,
Erkki


BUG: soft lockup - CPU#0 stuck for 11s! [bond0:1207]

Pid: 1207, comm: bond0 Not tainted (2.6.24.2-i686-net #1)
EIP: 0060:[<c0376bf5>] EFLAGS: 00000286 CPU: 0
EIP is at _spin_lock+0x5/0x10
EAX: cf925134 EBX: 00000002 ECX: 00000001 EDX: cf92505c
ESI: cc023d40 EDI: cf9f1c80 EBP: cee70000 ESP: cf655d8c
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b4d2cffc CR3: 0f78b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
  [<d0a48d5c>] ad_rx_machine+0x1c/0x3c0 [bonding]
  [<c0227f04>] elv_queue_empty+0x24/0x30
  [<d0925d15>] ide_do_request+0x65/0x360 [ide_core]
  [<d0a4acbf>] bond_3ad_lacpdu_recv+0x9f/0xb0 [bonding]
  [<c02ed7eb>] netif_receive_skb+0x2cb/0x3c0
  [<d087ce80>] e100_rx_indicate+0x100/0x180 [e100]
  [<c012e022>] irq_exit+0x52/0x80
  [<c010679e>] do_IRQ+0x3e/0x80
  [<c0230aa8>] as_put_io_context+0x48/0x70
  [<d087d005>] e100_rx_clean+0x105/0x140 [e100]
  [<d087d282>] e100_poll+0x22/0x80 [e100]
  [<c02edb7d>] net_rx_action+0x18d/0x1d0
  [<d087b09d>] e100_disable_irq+0x3d/0x60 [e100]
  [<d087d22e>] e100_intr+0x8e/0xc0 [e100]
  [<c012df44>] __do_softirq+0xd4/0xf0
  [<c012df98>] do_softirq+0x38/0x40
  [<c012e045>] irq_exit+0x75/0x80
  [<c010679e>] do_IRQ+0x3e/0x80
  [<c0104bd7>] common_interrupt+0x23/0x28
  [<d0a48e16>] ad_rx_machine+0xd6/0x3c0 [bonding]
  [<c01319e7>] lock_timer_base+0x27/0x60
  [<c0131a9e>] __mod_timer+0x7e/0xa0
  [<d0a4a6b4>] bond_3ad_state_machine_handler+0xc4/0x180 [bonding]
  [<d0a44af0>] bond_mii_monitor+0x0/0xc0 [bonding]
  [<d0a4a5f0>] bond_3ad_state_machine_handler+0x0/0x180 [bonding]
  [<c013927b>] run_workqueue+0x5b/0x110
  [<c01393fd>] worker_thread+0xcd/0x100
  [<c013d340>] autoremove_wake_function+0x0/0x50
  [<c0121a4f>] finish_task_switch+0x2f/0x80
  [<c013d340>] autoremove_wake_function+0x0/0x50
  [<c0139330>] worker_thread+0x0/0x100
  [<c013ce1b>] kthread+0x6b/0x70
  [<c013cdb0>] kthread+0x0/0x70
  [<c0104e17>] kernel_thread_helper+0x7/0x10
  =======================
