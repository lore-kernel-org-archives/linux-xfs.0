Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51728 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751224AbdFVP16 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 11:27:58 -0400
Subject: Re: [4.9.30] Unable to handle kernel NULL pointer dereference
 (`nfs4_put_state_owner`, `_raw_spin_lock_irqsave`, `xfs_buf_unlock`)
References: <1498115030.1869.6.camel@molgen.mpg.de>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <85a2bfac-4f8a-2332-ce34-69553f739477@molgen.mpg.de>
Date: Thu, 22 Jun 2017 17:27:56 +0200
MIME-Version: 1.0
In-Reply-To: <1498115030.1869.6.camel@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: it+nfs@molgen.mpg.de

On 06/22/17 09:03, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> A system running Linux 4.9.30 showed the errors below.
> 
> ```
> [    0.000000] Linux version 4.9.30.mx64.155 (root@orpheus.molgen.mpg.de) (gcc version 5.3.0 (GCC) ) #1 SMP Wed May 31 13:55:48 CEST 2017
> […]
> [1707396.797083] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [1707396.797118] IP: [<ffffffffa015da31>] nfs4_put_state_owner+0x11/0x80 [nfsv4]
> [1707396.797152] PGD 0
> [1707396.797163]
> [1707396.797178] Oops: 0000 [#1] SMP
> [1707396.797187] Modules linked in: nfsv3 nfsv4 nfs 8021q garp mrp stp llc nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc ixgbe ipv6 autofs4 unix
> [1707396.797313] CPU: 52 PID: 8193 Comm: kworker/52:2 Not tainted 4.9.30.mx64.155 #1
> [1707396.797332] Hardware name: Dell Inc. PowerEdge T630/0W9WXC, BIOS 1.3.6 06/08/2015
> [1707396.797362] Workqueue: nfsiod rpc_async_release [sunrpc]
> [1707396.797385] task: ffff882736cb5000 task.stack: ffffc9005816c000
> [1707396.797400] RIP: 0010:[<ffffffffa015da31>]  [<ffffffffa015da31>] nfs4_put_state_owner+0x11/0x80 [nfsv4]
> [1707396.797432] RSP: 0018:ffffc9005816fda8  EFLAGS: 00010292
> [1707396.797448] RAX: 000000000000000b RBX: ffff882fa4128600 RCX: ffffea00be8db95f
> [1707396.797470] RDX: 000000000000000c RSI: ffff882fa359b3c0 RDI: 0000000000000000
> [1707396.797491] RBP: ffffc9005816fdc0 R08: 0000000000000000 R09: ffff8825c4c882f0
> [1707396.797958] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000015fc30
> [1707396.798420] R13: 0000000000000000 R14: 0000000000000000 R15: ffff882fa4136940
> [1707396.798885] FS:  0000000000000000(0000) GS:ffff882fbfa80000(0000) knlGS:0000000000000000
> [1707396.799352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1707396.799592] CR2: 0000000000000000 CR3: 0000000002207000 CR4: 00000000001406e0
> [1707396.800056] Stack:
> [1707396.800287]  ffffc9005816fdc0 000000000015fc30 ffff882fa4128600 ffffc9005816fde8
> [1707396.800769]  ffffffffa0146f87 ffff882fa4136900 0000000000004881 ffffe8d00029cc00
> [1707396.801249]  ffffc9005816fe08 ffffffffa0117569 ffff882eaa8aac00 ffff882fbfa95c40
> [1707396.801729] Call Trace:
> [1707396.801967]  [<ffffffffa0146f87>] nfs4_free_closedata+0x57/0x80 [nfsv4]
> [1707396.802215]  [<ffffffffa0117569>] rpc_free_task+0x39/0x60 [sunrpc]
> [1707396.802461]  [<ffffffffa0117932>] rpc_async_release+0x12/0x20 [sunrpc]
> [1707396.802706]  [<ffffffff8107707a>] process_one_work+0x13a/0x460
> [1707396.802947]  [<ffffffff810773e8>] worker_thread+0x48/0x4d0
> [1707396.803189]  [<ffffffff81a956b1>] ? __schedule+0x1a1/0x650
> [1707396.803429]  [<ffffffff810773a0>] ? process_one_work+0x460/0x460
> [1707396.803674]  [<ffffffff8107d0f7>] kthread+0xd7/0xf0
> [1707396.803915]  [<ffffffff81063001>] ? do_exit+0x751/0xae0
> [1707396.804160]  [<ffffffff8107d020>] ? kthread_park+0x70/0x70
> [1707396.804402]  [<ffffffff81a998d2>] ret_from_fork+0x22/0x30
> [1707396.804646] Code: 49 89 c6 e9 29 fe ff ff 48 c7 45 c0 00 00 00 00 e9 96 fc ff ff 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 48 83 ec 18 4c 89 65 f0 <4c> 8b 27 48 89 5d e8 4c 89 6d f8 48 89 fb 48 83 c7 44 4d 8b 2c
> [1707396.805649] RIP  [<ffffffffa015da31>] nfs4_put_state_owner+0x11/0x80 [nfsv4]
> [1707396.806121]  RSP <ffffc9005816fda8>
> [1707396.806357] CR2: 0000000000000000
> [1707396.807126] ---[ end trace 81f299b9d0e21504 ]---




I've tracked this down to the instruction:


     0000000000018a20 <nfs4_put_state_owner>:
        18a20:       e8 00 00 00 00          callq  18a25 
<nfs4_put_state_owner+0x5>
                             18a21: R_X86_64_PC32    __fentry__-0x4
        18a25:       55                      push   %rbp 

        18a26:       48 89 e5                mov    %rsp,%rbp 

        18a29:       48 83 ec 18             sub    $0x18,%rsp 

        18a2d:       4c 89 65 f0             mov    %r12,-0x10(%rbp) 

        18a31:       4c 8b 27                mov    (%rdi),%r12 
          # r12: server

The failing instruction 4c 8b 27 at nfs4_put_state_owner+11 is the 
dereferencing of the first call argument (%rdi).
This is *server = sp->so_server in

     nfs/nfs4state.c

     void nfs4_put_state_owner(struct nfs4_state_owner *sp)
     {
             struct nfs_server *server = sp->so_server;
             struct nfs_client *clp = server->nfs_client;

             if (!atomic_dec_and_lock(&sp->so_count, &clp->cl_lock))
                     return;
     [...]

because so_server is first in struct nfs4_state_owner. We are called 
with sp=NULL.

Caller:

     nfs/nfsd4proc.c

     static void nfs4_free_closedata(void *data)
     {
         struct nfs4_closedata *calldata = data;
         struct nfs4_state_owner *sp = calldata->state->owner;
         struct super_block *sb = calldata->state->inode->i_sb;

         if (calldata->roc)
             pnfs_roc_release(calldata->state->inode);
         nfs4_put_open_state(calldata->state);
         nfs_free_seqid(calldata->arg.seqid);
         nfs4_put_state_owner(sp);
         nfs_sb_deactive(sb);
         kfree(calldata);
     }


Can calldata->state->owner be zero?


Donald


> [1707396.807407] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
> [1707396.807411] IP: [<ffffffff81a99344>] _raw_spin_lock_irqsave+0x14/0x30
> [1707396.807412] PGD 2fa4184067
> [1707396.807412] PUD 1c20d7d067
> [1707396.807413] PMD 0
> [1707396.807413]
> [1707396.807414] Oops: 0002 [#2] SMP
> [1707396.807422] Modules linked in: nfsv3 nfsv4 nfs 8021q garp mrp stp llc nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc ixgbe ipv6 autofs4 unix
> [1707396.807424] CPU: 38 PID: 13139 Comm: annotate_variat Tainted: G      D         4.9.30.mx64.155 #1
> [1707396.807425] Hardware name: Dell Inc. PowerEdge T630/0W9WXC, BIOS 1.3.6 06/08/2015
> [1707396.807426] task: ffff882fa1a4e500 task.stack: ffffc9003cc44000
> [1707396.807429] RIP: 0010:[<ffffffff81a99344>]  [<ffffffff81a99344>] _raw_spin_lock_irqsave+0x14/0x30
> [1707396.807430] RSP: 0018:ffffc9003cc47a18  EFLAGS: 00010046
> [1707396.807431] RAX: 0000000000000000 RBX: 0000000000000286 RCX: ffff882f92bb4488
> [1707396.807431] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000030
> [1707396.807433] RBP: ffffc9003cc47a20 R08: 0000000000000001 R09: 000000000000006c
> [1707396.807434] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [1707396.807435] R13: 0000000000000000 R14: ffff882736c49300 R15: ffff88265de2f1b8
> [1707396.807436] FS:  00007fad4318f700(0000) GS:ffff882fbf8c0000(0000) knlGS:0000000000000000
> [1707396.807437] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1707396.807438] CR2: 0000000000000030 CR3: 0000002bceada000 CR4: 00000000001406e0
> [1707396.807438] Stack:
> [1707396.807441]  0000000000000030 ffffc9003cc47a40 ffffffff810a2666 ffff885f00000008
> [1707396.807442]  0000000000000035 ffffc9003cc47a68 ffffffff8133734a 0000000000000035
> [1707396.807444]  0000000000000001 0000000000000000 ffffc9003cc47a90 ffffffff8136b00d
> [1707396.807445] Call Trace:
> [1707396.807449]  [<ffffffff810a2666>] up+0x16/0x50
> [1707396.807454]  [<ffffffff8133734a>] xfs_buf_unlock+0x1a/0x80
> [1707396.807458]  [<ffffffff8136b00d>] xfs_trans_brelse+0x10d/0x130
> [1707396.807461]  [<ffffffff81314f0e>] xfs_dir2_leafn_lookup_for_entry+0x15e/0x360
> [1707396.807463]  [<ffffffff81315d67>] xfs_dir2_leafn_lookup_int+0x17/0x30
> [1707396.807466]  [<ffffffff8130c11b>] xfs_da3_node_lookup_int+0x29b/0x2b0
> [1707396.807468]  [<ffffffff813170d7>] xfs_dir2_node_lookup+0x47/0x150
> [1707396.807470]  [<ffffffff8130ee2b>] xfs_dir_lookup+0x18b/0x1a0
> [1707396.807473]  [<ffffffff8134a7ee>] xfs_lookup+0x6e/0x130
> [1707396.807475]  [<ffffffff81346f7c>] xfs_vn_lookup+0x4c/0x90
> [1707396.807478]  [<ffffffff811a91f0>] path_openat+0x1090/0x12b0
> [1707396.807482]  [<ffffffff811950a3>] ? mem_cgroup_commit_charge+0x63/0x450
> [1707396.807484]  [<ffffffff811aa5c1>] do_filp_open+0x81/0xe0
> [1707396.807487]  [<ffffffff8107f3c4>] ? prepare_creds+0x24/0xa0
> [1707396.807490]  [<ffffffff8119f45d>] do_open_execat+0x6d/0x160
> [1707396.807492]  [<ffffffff811a14d5>] do_execveat_common.isra.14+0x195/0x750
> [1707396.807494]  [<ffffffff811a1cdf>] SyS_execve+0x3f/0x50
> [1707396.807496]  [<ffffffff81002acd>] do_syscall_64+0x4d/0xb0
> [1707396.807499]  [<ffffffff81a99746>] entry_SYSCALL64_slow_path+0x25/0x25
> [1707396.807522] Code: c0 74 04 31 c0 5d c3 b8 01 00 00 00 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 53 9c 5b fa 31 c0 ba 01 00 00 00 <f0> 0f b1 17 85 c0 75 06 48 89 d8 5b 5d c3 89 c6 e8 e7 98 60 ff
> [1707396.807524] RIP  [<ffffffff81a99344>] _raw_spin_lock_irqsave+0x14/0x30
> [1707396.807525]  RSP <ffffc9003cc47a18>
> [1707396.807526] CR2: 0000000000000030
> [1707396.807527] ---[ end trace 81f299b9d0e21505 ]---
> ```
> 
> The `(null)` in there looks strange. So I wonder if the trace is usable
> at all. Have you seen this before? Do you have any suggestions or hints
> before we look further into it?
> 
> A little later, there are CPU stalls detected again.
> 
> ```
> [1707636.813069] INFO: rcu_sched detected stalls on CPUs/tasks:
> [1707636.813454]        52-...: (0 ticks this GP) idle=ab9/140000000000000/0 softirq=308252552/308252552 fqs=54844
> [1707636.813992]        (detected by 33, t=240008 jiffies, g=26186310, c=26186309, q=38173)
> [1707636.814604] Task dump for CPU 52:
> [1707636.814907] kworker/52:2    D    0  8193      0 0x00000000
> [1707636.815294]  0000000f000124b6 0000000000000001 000000000000002c 0000000000000000
> [1707636.816114]  ffffffff824cc0c2 0000000000000006 ffffc9005816fe70 ffffffff810a90f5
> [1707636.816932]  ffffffff824cc0c2 000000000000002c 0000000000000000 ffffffff81f25158
> [1707636.817746] Call Trace:
> [1707636.818050]  [<ffffffff810a90f5>] ? vprintk_emit+0x255/0x430
> [1707636.818359]  [<ffffffff81a993b0>] ? _raw_spin_lock+0x20/0x30
> [1707636.818664]  [<ffffffff81a9557b>] ? __schedule+0x6b/0x650
> [1707636.819056]  [<ffffffff81a95b96>] ? schedule+0x36/0x80
> [1707636.819360]  [<ffffffff810631ad>] ? do_exit+0x8fd/0xae0
> [1707636.819663]  [<ffffffff81a9aa37>] ? rewind_stack_do_exit+0x17/0x20
> ```
> 
> Please find the messages until forceful reboot attached.
> 
> 
> Kind regards,
> 
> Paul
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
