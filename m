Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39771 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731056AbfCaCRO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Mar 2019 22:17:14 -0400
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low! (2)
References: <00000000000089a718058556e1d8@google.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <f71aaffa-ecf4-1def-fe50-91f37c677537@acm.org>
Date: Sat, 30 Mar 2019 19:17:09 -0700
MIME-Version: 1.0
In-Reply-To: <00000000000089a718058556e1d8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: syzbot <syzbot+6f39a9deb697359fe520@syzkaller.appspotmail.com>, akpm@linux-foundation.org, danitg@mellanox.com, darrick.wong@oracle.com, dledford@redhat.com, gustavo@embeddedor.com, jannh@google.com, jgg@ziepe.ca, johannes.berg@intel.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, longman@redhat.com, mingo@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, roland@purestorage.com, shamir.rabinovitch@oracle.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, will.deacon@arm.com, xiyou.wangcong@gmail.com, Dmitry Vyukov <dvyukov@google.com>

On 3/30/19 2:58 PM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 669de8bda87b92ab9a2fc663b3f5743c2ad1ae9f
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Thu Feb 14 23:00:54 2019 +0000
> 
>      kernel/workqueue: Use dynamic lockdep keys for workqueues
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f1bacd200000
> start commit:   0e40da3e Merge tag 'kbuild-fixes-v5.1' of 
> git://git.kernel..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1409bacd200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1009bacd200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8dcdce25ea72bedf
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=6f39a9deb697359fe520
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e1bacd200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1120fe0f200000
> 
> Reported-by: syzbot+6f39a9deb697359fe520@syzkaller.appspotmail.com
> Fixes: 669de8bda87b ("kernel/workqueue: Use dynamic lockdep keys for 
> workqueues")
> 
> For information about bisection process see: 
> https://goo.gl/tpsmEJ#bisection

Hi Dmitry,

This bisection result doesn't make sense to me. As one can see, the 
message "BUG: MAX_STACK_TRACE_ENTRIES too low!" does not occur in the 
console output the above console output URL points at.

Bart.
