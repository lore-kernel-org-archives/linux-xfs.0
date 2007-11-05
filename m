Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Nov 2007 10:56:17 -0800 (PST)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.178])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA5Iu8EY013384
	for <xfs@oss.sgi.com>; Mon, 5 Nov 2007 10:56:10 -0800
Received: by el-out-1112.google.com with SMTP id v27so338910ele
        for <xfs@oss.sgi.com>; Mon, 05 Nov 2007 10:56:13 -0800 (PST)
Message-ID: <64bb37e0711051027v49869699s9593ea54713b15ff@mail.gmail.com>
Date: Mon, 5 Nov 2007 19:27:16 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: writeout stalls in current -git
In-Reply-To: <20071105014510.GU66820511@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <393060478.03650@ustc.edu.cn> <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 11/5/07, David Chinner <dgc@sgi.com> wrote:
> Ok, so it's probably a side effect of the writeback changes.
>
> Attached are two patches (two because one was in a separate patchset as
> a standalone change) that should prevent async writeback from blocking
> on locked inode cluster buffers. Apply the xfs-factor-inotobp patch first.
> Can you see if this fixes the problem?

Now testing v2.6.24-rc1-650-gb55d1b1+ the fix for the missapplied raid5-patch
Applying your two patches ontop of that does not fix the stalls.

vmstat 10 output from unmerging (uninstalling) a kernel:
 1  0      0 3512188    332 192644    0    0   185    12  368  735 10  3 85  1
-> emerge starts to remove the kernel source files
 3  0      0 3506624    332 192836    0    0    15  9825 2458 8307  7 12 81  0
 0  0      0 3507212    332 192836    0    0     0   554  630 1233  0  1 99  0
 0  0      0 3507292    332 192836    0    0     0   537  580 1328  0  1 99  0
 0  0      0 3507168    332 192836    0    0     0   633  626 1380  0  1 99  0
 0  0      0 3507116    332 192836    0    0     0  1510  768 2030  1  2 97  0
 0  0      0 3507596    332 192836    0    0     0   524  540 1544  0  0 99  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3507540    332 192836    0    0     0   489  551 1293  0  0 99  0
 0  0      0 3507528    332 192836    0    0     0   527  510 1432  1  1 99  0
 0  0      0 3508052    332 192840    0    0     0  2088  910 2964  2  3 95  0
 0  0      0 3507888    332 192840    0    0     0   442  565 1383  1  1 99  0
 0  0      0 3508704    332 192840    0    0     0   497  529 1479  0  0 99  0
 0  0      0 3508704    332 192840    0    0     0   594  595 1458  0  0 99  0
 0  0      0 3511492    332 192840    0    0     0  2381 1028 2941  2  3 95  0
 0  0      0 3510684    332 192840    0    0     0   699  600 1390  0  0 99  0
 0  0      0 3511636    332 192840    0    0     0   741  661 1641  0  0 100  0
 0  0      0 3524020    332 192840    0    0     0  2452 1080 3910  2  3 95  0
 0  0      0 3524040    332 192844    0    0     0   530  617 1297  0  0 99  0
 0  0      0 3524128    332 192844    0    0     0   812  674 1667  0  1 99  0
 0  0      0 3527000    332 193672    0    0   339   721  754 1681  3  2 93  1
-> emerge is finished, no dirty or writeback data in /proc/meminfo
 0  0      0 3571056    332 194768    0    0   111   639  632 1344  0  1 99  0
 0  0      0 3571260    332 194768    0    0     0   757  688 1405  1  0 99  0
 0  0      0 3571156    332 194768    0    0     0   753  641 1361  0  0 99  0
 0  0      0 3571404    332 194768    0    0     0   766  653 1389  0  0 99  0
 1  0      0 3571136    332 194768    0    0     6   764  669 1488  0  0 99  0
 0  0      0 3571668    332 194824    0    0     0   764  657 1482  0  0 99  0
 0  0      0 3571848    332 194824    0    0     0   673  659 1406  0  0 99  0
 0  0      0 3571908    332 195052    0    0    22   753  638 1500  0  1 99  0
 0  0      0 3573052    332 195052    0    0     0   765  631 1482  0  1 99  0
 0  0      0 3574144    332 195052    0    0     0   771  640 1497  0  0 99  0
 0  0      0 3573468    332 195052    0    0     0   458  485 1251  0  0 99  0
 0  0      0 3574184    332 195052    0    0     0   427  474 1192  0  0 100  0
 0  0      0 3575092    332 195052    0    0     0   461  482 1235  0  0 99  0
 0  0      0 3576368    332 195056    0    0     0   582  556 1310  0  0 99  0
 0  0      0 3579300    332 195056    0    0     0   695  571 1402  0  0 99  0
 0  0      0 3580376    332 195056    0    0     0   417  568  906  0  0 99  0
 0  0      0 3581212    332 195056    0    0     0   421  559  977  0  1 99  0
 0  0      0 3583780    332 195060    0    0     0   494  555 1080  0  1 99  0
 0  0      0 3584352    332 195060    0    0     0    99  347  559  0  0 99  0
 0  0      0 3585232    332 195060    0    0     0    11  301  621  0  0 99  0
-> disks go idle.

So these patches do not seem to be the source of these excessive disk writes...

Torsten
