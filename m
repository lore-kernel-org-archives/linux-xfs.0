Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8DD2EF67F
	for <linux-xfs@vger.kernel.org>; Wed, 26 Nov 2025 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764163647; cv=none; b=OC/sGW+G0p8/B4Bn5UeP8UTmxcUfIqZGBP/px4X97qzwoZEUeY/ee9iq1us5XJy1+D5zHazmkjlVihtBBBm1+SbfcM5lp+brtHwjRXKfU4/fig1xrZZ4WLtqbFgbp41D5kVU3S7/a1VBy+ZKFjbCYW9xR3IX/tmHqGhIcvAvM6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764163647; c=relaxed/simple;
	bh=FH69UGe75+q3lRs69PGPrPWi4CeSdx1gXn54fYhOy08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZLMJOHqhwjFAXXho0UT//puWc9UkTa07mTM1gM9m1uNDNiiKfV3v+6trrUAH8nXWpg39CdN3WBxftVZ1bC/32Iv+J7PfkVG9WmSxVyEQHDzG5dNAbSMc1vgnFmSXpQAI4o1y3nPAELZCZyltqZlBXfqAdep+pyJbVHOX+F0PH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IdUjRtaX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdUjRtaX"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso71737315e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Nov 2025 05:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764163643; x=1764768443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CA0EqGlwpbXj1o1pLItCwfxbpgpsNufm5+BlWAPJqBU=;
        b=IdUjRtaX40HK58wUkIS6VU1jD3/SGm/qXLT2ysyFm5B4YRT0sEORU/YYRPlWM59Zb9
         3utTTgs8zpIjYAFk2tJlQwWlt4ktmIDbMERkiob2By53uj5i2dS0yLtQiRxbLi6WLjrV
         eg5pIODxsTQIj7vRHZIEqFS123XMts9X/s4TmzjYcrhDWKei5i/yZp5b3LXtRRfQr8pi
         0WqocD9m0qAsb5poebY6t4B6VfAuW1FYaqqGia8nmb0tNG5nivGjMu1N4hPkCIRNxgvq
         n1ZZN8IlJkfEJcMwZOFsa4CMQiKlvum1qQH6u2oebKZ9cPNksT9BjOEmD9ht3Tv4ckw9
         v2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764163643; x=1764768443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CA0EqGlwpbXj1o1pLItCwfxbpgpsNufm5+BlWAPJqBU=;
        b=DAS6Hon33dKAK6O064C9lqMC2ISGV8XGsDrx1cNl+xRMD3Vf7hLyAvUb2Vqw/NhR9d
         PBPU1Lrbdrg42CDEPODL3ik5ux6xTYQ/h113w366Pclv9k03ooE6VDusYR4wtgjD2iRJ
         C5KoqGPUiDZ7sIiveTfjpyldivcOuERo6aFsyPVL2ikpiXU2K9PLsk5VUakJEmUyE6fo
         X62TPYxZWREuVN267+Su6mNoNiEEv3oaIrj68UTKTx3uWUZk42+yyU67TyqplCAUuYwu
         GguT8IJ3UmiujFaTAmQ6oWm848vGpWRxEa+B4gTfr4LCs+PGIjT71vlYZQNQ+EGhor0c
         Gcog==
X-Forwarded-Encrypted: i=1; AJvYcCXwu5Inp+XvpGnwnzq6NUNZNPWNbzoaANSPdFRmO9DEkSqQo2aBiKZIiR+YrejjitqGaXljA12pReA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE7AjFMLFR0iJXHXQq6yZcVDXY2PXpWBFqsi1WyrVE5pcCJoXS
	ofJDnxcujxHeYm/gvLLy3sbpvDO0kZ+Fp3fRV1kB0qHL5afcxuTX2zeRxZYitg==
X-Gm-Gg: ASbGncsTBapG+yVN0y4iyBjNq2JA86decPcROvcKpMEVLiLEhHJ0JKQlEdgnsiVMBVo
	W/w9bOuv/Y3+dq8J+ZRJLUQD6xHXvt5lmrEEL1J4drZdzahqO+gqtNDqI0tL3rvUdqWK9D5oYze
	4W9CMsdusMclb9m8T1yAIoBpocE5zkQmMJNl803ByH97+8gR97F5Rx+ZJtXORQcL/lKYjtU4s3Z
	iqv4ROSTbfb4K8LedYRUN4oqEBjPArgB1ihAm2/GrcBUMPgMjy+qtM9zapo2NQqZKRpByMCsIEL
	kx7L/MVbwthj5qFkFp6I6tc3yNUwBfgcVVW6fPQvpCIqrJL+RheJrX0benyHrOJeDJzsA+wr90e
	JRWpqQ2EXHwEFRqRJdyLoniMxLBY6vsLjeQ87owxnkPwkoPOzz/e58eoG6NKob2RBiQHv9gXc28
	itim4GATc16XZnZnj1V6msiyh55w2tAmCNW9n9qyP79NTZZw==
X-Google-Smtp-Source: AGHT+IFjPdGKvfxf+1gLK8Pw6lxafT05cr8Fyn6+/XfTAjtey1QQ0em1AWBPAvqqaVWfnVA8L4f5rg==
X-Received: by 2002:a05:600c:1ca5:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-477c1115ff6mr224276445e9.17.1764163642307;
        Wed, 26 Nov 2025 05:27:22 -0800 (PST)
Received: from localhost (dhcp-91-156.inf.ed.ac.uk. [129.215.91.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e574sm40235498f8f.3.2025.11.26.05.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 05:27:21 -0800 (PST)
Date: Wed, 26 Nov 2025 13:27:21 +0000
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Too many xfs-conv kworker threads
Message-ID: <20251126132721.tagdhjs2mcbbkdjr@wrangler>
References: <20251125194942.iphwjfx2a4bw6i7g@wrangler>
 <aSYuX47uH4zT-FKi@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSYuX47uH4zT-FKi@dread.disaster.area>


Hi Dave,

Thanks for looking at this.

On Wed, Nov 26, 2025 at 09:31:59AM +1100, Dave Chinner wrote:
> On Tue, Nov 25, 2025 at 07:49:42PM +0000, Karim Manaouil wrote:
> > Hi folks,
> > 
> > I have four NVMe SSDs on RAID0 with XFS and upstream Linux kernel 6.15
> > with commit id e5f0a698b34ed76002dc5cff3804a61c80233a7a. The setup can
> > achieve 25GB/s and more than 2M IOPS. The CPU is a dual socket 24-cores
> > AMD EPYC 9224.
> 
> The mkfs.xfs (or xfs_info) output for the filesystem is on this
> device is?

Here is xfs_info

meta-data=/dev/md127             isize=512    agcount=48, agsize=20346496 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=976630272, imaxpct=5
         =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=476872, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents

and mdadm --detail

/dev/md127:
           Version : 1.2
     Creation Time : Tue Sep 30 13:47:14 2025
        Raid Level : raid0
        Array Size : 3906521088 (3.64 TiB 4.00 TB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Tue Sep 30 13:47:14 2025
             State : clean 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : original
        Chunk Size : 512K

Consistency Policy : none

              UUID : 11099fa7:7500e645:a3e71ba6:a23dda90
            Events : 0

    Number   Major   Minor   RaidDevice State
       0     259        3        0      active sync   /dev/nvme2n1
       1     259        6        1      active sync   /dev/nvme3n1
       2     259        5        2      active sync   /dev/nvme4n1
       3     259        4        3      active sync   /dev/nvme5n1

> > I am running thpchallenge-fio from mmtests (its purpose is described
> > here [1]). It's a fio job that inefficiently writes a large number of 64K
> > files. On a system with 128GiB of RAM, it could create up to 100K files.
> > A typical fio config looks like this:
> > 
> > [global]
> > direct=0
> > ioengine=sync
> > blocksize=4096
> > invalidate=0
> > fallocate=none
> > create_on_open=1
> > 
> > [writer]
> > nrfiles=785988
> 
> That's ~800k files, not 100k.

My bad, you're write. This was run with much more memory than 128GiB.
(The test scales the number of files with memory size).

> > filesize=65536
> > readwrite=write
> > numjobs=4
> > filename_format=$jobnum/workfile.$filenum
> > 
> > I noticed that, at some point, top reports around 42650 sleeping tasks,
> > example:
> > 
> > Tasks: 42651 total,   1 running, 42650 sleeping,   0 stopped,   0 zombie
> > 
> > This is a test machine from a fresh boot running vanilla Debian.
> > 
> > After checking, it turned out, it was a massive list of xfs-conv
> > kworkers. Something like this (truncated):
> > 
> >   58214 ?        I      0:00 [kworker/47:203-xfs-conv/md127]
> >   58215 ?        I      0:00 [kworker/47:204-xfs-conv/md127]
> >   58216 ?        I      0:00 [kworker/47:205-xfs-conv/md127]
> >   58217 ?        I      0:00 [kworker/47:206-xfs-conv/md127]
> >   58219 ?        I      0:00 [kworker/12:539-xfs-conv/md127]
> >   58220 ?        I      0:00 [kworker/12:540-xfs-conv/md127]
> >   58221 ?        I      0:00 [kworker/12:541-xfs-conv/md127]
> >   58222 ?        I      0:00 [kworker/12:542-xfs-conv/md127]
> >   58223 ?        I      0:00 [kworker/12:543-xfs-conv/md127]
> >   58224 ?        I      0:00 [kworker/12:544-xfs-conv/md127]
> >   58225 ?        I      0:00 [kworker/12:545-xfs-conv/md127]
> >   58227 ?        I      0:00 [kworker/38:155-xfs-conv/md127]
> >   58228 ?        I      0:00 [kworker/38:156-xfs-conv/md127]
> >   58230 ?        I      0:00 [kworker/38:158-xfs-conv/md127]
> >   58233 ?        I      0:00 [kworker/38:161-xfs-conv/md127]
> >   58235 ?        I      0:00 [kworker/8:537-xfs-conv/md127]
> >   58237 ?        I      0:00 [kworker/8:539-xfs-conv/md127]
> >   58238 ?        I      0:00 [kworker/8:540-xfs-conv/md127]
> >   58239 ?        I      0:00 [kworker/8:541-xfs-conv/md127]
> >   58240 ?        I      0:00 [kworker/8:542-xfs-conv/md127]
> >   58241 ?        I      0:00 [kworker/8:543-xfs-conv/md127]
> > 
> > It seems like the kernel is creating too many kworkers on each CPU.
> 
> Or there are tens of thousands of small random write IOs 
> in flight at any given time and this process is serialising on
> unwritten extent conversion during IO completion processing. i.e.
> so many kworker threads indicates work processing is blocking, so
> each new work queued gets a new kworker thread created to process
> it.
> 
> I suspect that the filesystem is running out of journal space, and
> then unwritten extent conversion transactions start lock-stepping
> waiting for journal space. Hence the question about mkfs.xfs output.
> 
> Also info about IO load (e.g. `iostat -dxm 5` output) whilst the test
> is running would be useful, because even fast devices can end up
> being really slow when something stupid is being done...
> 
> Kernel profiles across all CPUs whilst the workload is running and
> in this state would be useful.

This is the last 20/30s from iostat -dxm5 during the test. It's been the
same consistently throughput the test at ~80/89% utilization.

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            0.00      0.00     0.00   0.00    0.00     0.00 68713.80   1051.87     0.00   0.00    1.05    15.68    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   72.14  89.52

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            0.00      0.00     0.00   0.00    0.00     0.00 66888.40    943.12     0.00   0.00    0.92    14.44    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   61.68  88.08

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            0.00      0.00     0.00   0.00    0.00     0.00 68453.80    653.24     0.00   0.00    1.23     9.77    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   84.37  87.12

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            0.00      0.00     0.00   0.00    0.00     0.00 82154.80    604.90     0.00   0.00    1.64     7.54    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00  134.87  86.88

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            1.20      0.00     0.00   0.00    2.00     4.00 70320.60    295.50     0.00   0.00    1.97     4.30    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00  138.60  87.12

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md127            8.20      0.07     0.00   0.00    0.00     9.17 19574.60     84.99     0.00   0.00    2.27     4.45    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   44.48  24.96

In addition, I got the kernel profile with perf record -a -g.

Please find at the end of this email the output of (~500 lines of) perf report.

I have also generated the flamegraph here to make life easy.

https://limewire.com/d/b5lJ1#ZigjlrS9mg

> > I am not sure if this has any effect on performance, but potentially,
> > there is some scheduling overhead?!
> 
> It probably does, but a trainsmash of stalled in-progress work like
> this is typically a symptom of some other misbehaviour occuring.
> 
> FWIW, for a workload intended to produce "inefficient write IO",
> this is sort of behaviour is definitely indicating something
> "inefficient" is occurring during write IO. So, in the end, there is
> a definite possiblity that there may not actually be anything that
> can be "fixed" here....

You're right, but having 45k kworker threads still looks questionable to me
even with the inefficiency in mind. Maybe it shouldn't be done that way. I'm
not sure, but just keeping the questions open...

========== Perf report output ================

    47.99%     0.00%  fio              fio                                             [.] main
           5.49%
                main
                fio_backend
                run_threads
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                main
                fio_backend
                run_threads
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    45.82%     0.00%  fio              fio                                             [.] fio_backend
           5.49%
                fio_backend
                run_threads
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                fio_backend
                run_threads
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    45.66%     0.01%  fio              fio                                             [.] run_threads
           5.49%
                run_threads
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                run_threads
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    43.21%     0.39%  fio              fio                                             [.] thread_main
           5.49%
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                thread_main
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    39.26%     0.28%  fio              [kernel.kallsyms]                               [k] do_syscall_64
           5.49%
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.17%
                do_syscall_64
                ksys_write
                fdget_pos

    39.11%     0.07%  fio              [kernel.kallsyms]                               [k] entry_SYSCALL_64_after_hwframe
           5.49%
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.17%
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    32.75%     0.00%  fio              libc.so.6                                       [.] 0x00007fa8884a49ee
           5.49%
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    31.46%     0.25%  fio              fio                                             [.] td_io_queue
           5.49%
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                td_io_queue
                0x7fa8884a49ee
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                ksys_write
                fdget_pos

    26.47%     0.04%  fio              [kernel.kallsyms]                               [k] ksys_write
           5.49%
                ksys_write
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

           1.19%
                ksys_write
                fdget_pos

    25.27%     0.96%  fio              [kernel.kallsyms]                               [k] vfs_write
           5.49%
                vfs_write
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

    24.62%     0.11%  fio              [kernel.kallsyms]                               [k] xfs_file_buffered_write
           5.49%
                xfs_file_buffered_write
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

    20.00%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] ret_from_fork_asm
    20.00%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] ret_from_fork
    20.00%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] kthread
    20.00%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] worker_thread
    20.00%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] process_one_work
    19.98%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] wb_workfn
    19.98%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] wb_writeback
    19.74%     0.04%  kworker/u196:0-  [kernel.kallsyms]                               [k] writeback_sb_inodes
    19.50%     0.03%  kworker/u196:0-  [kernel.kallsyms]                               [k] __writeback_single_inode
    19.46%     0.12%  kworker/u196:0-  [kernel.kallsyms]                               [k] do_writepages
    19.40%     0.10%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_vm_writepages
    19.25%     0.03%  kworker/u196:0-  [kernel.kallsyms]                               [k] iomap_writepages
    16.24%     0.20%  kworker/u196:0-  [kernel.kallsyms]                               [k] iomap_writeback_folio
    15.81%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] __writeback_inodes_wb
    15.50%     0.06%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_writeback_range
    14.49%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_bmapi_convert_delalloc
    14.48%     0.19%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_bmapi_convert_one_delalloc
    12.07%     0.40%  fio              [kernel.kallsyms]                               [k] iomap_file_buffered_write
    11.82%     0.00%  kthreadd         [kernel.kallsyms]                               [k] ret_from_fork_asm
    11.81%     0.00%  kthreadd         [kernel.kallsyms]                               [k] ret_from_fork
    11.76%     0.00%  kthreadd         [kernel.kallsyms]                               [k] kthread
    11.74%     0.05%  kthreadd         [kernel.kallsyms]                               [k] worker_thread
    11.52%     0.69%  fio              [kernel.kallsyms]                               [k] xfs_file_write_checks
           5.49%
                xfs_file_write_checks
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

    11.45%     0.05%  kthreadd         [kernel.kallsyms]                               [k] process_one_work
    11.22%     0.15%  fio              [kernel.kallsyms]                               [k] kiocb_modified
           5.49%
                kiocb_modified
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

    11.03%     0.01%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_trans_commit
    10.63%     0.03%  kthreadd         [kernel.kallsyms]                               [k] xfs_end_io
    10.54%     0.03%  kthreadd         [kernel.kallsyms]                               [k] xfs_end_ioend
    10.21%     0.05%  fio              [kernel.kallsyms]                               [k] xfs_vn_update_time
           5.53%
                xfs_vn_update_time
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

     9.66%     0.05%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_defer_finish_noroll
     8.88%     0.03%  kthreadd         [kernel.kallsyms]                               [k] xfs_iomap_write_unwritten
     8.84%     0.34%  fio              fio                                             [.] get_io_u
     8.79%     0.19%  fio              [kernel.kallsyms]                               [k] __xfs_trans_commit
           6.56%
                __xfs_trans_commit
                xlog_cil_commit

     8.69%     0.03%  fio              [kernel.kallsyms]                               [k] xfs_trans_commit
           6.55%
                xfs_trans_commit
                __xfs_trans_commit
                xlog_cil_commit

     7.97%     0.01%  kthreadd         [kernel.kallsyms]                               [k] xfs_trans_commit
     7.28%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_defer_finish_one
     7.05%     0.01%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_rmap_update_finish_item
     6.99%     2.00%  fio              [kernel.kallsyms]                               [k] xlog_cil_commit
           4.99%
                xlog_cil_commit

     6.98%     0.01%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_rmap_finish_one
     6.75%     0.04%  kthreadd         [kernel.kallsyms]                               [k] xfs_defer_finish_noroll
     6.67%     0.14%  fio              [kernel.kallsyms]                               [k] iomap_write_begin
     6.53%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_rmap_map
     6.36%     0.02%  fio              fio                                             [.] td_io_open_file
     6.13%     0.08%  fio              [kernel.kallsyms]                               [k] __filemap_get_folio
     5.68%     0.04%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_insert
     5.64%     0.07%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_insrec
     5.13%     0.02%  kthreadd         [kernel.kallsyms]                               [k] xfs_defer_finish_one
     4.89%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_update_keys.isra.0
           4.14%
                xfs_btree_update_keys.isra.0
                __xfs_btree_updkeys.isra.0
                xfs_btree_get_leaf_keys

           1.09%
                xfs_btree_update_keys.isra.0
                __xfs_btree_updkeys.isra.0
                xfs_btree_get_leaf_keys
                xfs_rmapbt_init_high_key_from_rec

     4.86%     0.04%  kworker/u196:0-  [kernel.kallsyms]                               [k] __xfs_btree_updkeys.isra.0
           4.14%
                __xfs_btree_updkeys.isra.0
                xfs_btree_get_leaf_keys

           1.09%
                __xfs_btree_updkeys.isra.0
                xfs_btree_get_leaf_keys
                xfs_rmapbt_init_high_key_from_rec

     4.85%     0.01%  kthreadd         [kernel.kallsyms]                               [k] xfs_rmap_update_finish_item
     4.77%     0.02%  kthreadd         [kernel.kallsyms]                               [k] xfs_rmap_finish_one
     4.56%     0.01%  fio              [kernel.kallsyms]                               [k] __x64_sys_openat
     4.56%     0.01%  fio              [kernel.kallsyms]                               [k] do_sys_openat2
     4.38%     0.02%  fio              [kernel.kallsyms]                               [k] do_filp_open
     4.37%     0.12%  fio              [kernel.kallsyms]                               [k] path_openat
     4.22%     1.20%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_get_leaf_keys
           3.01%
                xfs_btree_get_leaf_keys

     3.69%     0.06%  kthreadd         [kernel.kallsyms]                               [k] xfs_rmap_convert
     3.42%     0.00%  fio              libc.so.6                                       [.] 0x00007efc15ea49ee
     3.41%     0.05%  kworker/u196:0-  [kernel.kallsyms]                               [k] __xfs_trans_commit
     3.28%     0.07%  fio              libc.so.6                                       [.] fstatat64
     3.26%     0.01%  fio              [kernel.kallsyms]                               [k] xfs_generic_create
     3.17%     0.01%  fio              [kernel.kallsyms]                               [k] xfs_create
     3.12%     0.01%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_make_block_unfull
     3.06%     0.03%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_bmapi_allocate
     3.04%     0.44%  kworker/u196:0-  [kernel.kallsyms]                               [k] xlog_cil_commit
     3.03%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_lshift
     2.98%     0.82%  fio              [kernel.kallsyms]                               [k] filemap_add_folio
     2.97%     0.77%  fio              [kernel.kallsyms]                               [k] iomap_iter
     2.96%     0.01%  fio              [kernel.kallsyms]                               [k] ksys_read
     2.95%     0.05%  fio              [kernel.kallsyms]                               [k] __do_sys_newfstatat
     2.94%     0.04%  fio              [kernel.kallsyms]                               [k] vfs_read
     2.87%     0.01%  fio              [kernel.kallsyms]                               [k] xfs_file_read_iter
     2.86%     0.11%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_bmap_btalloc
     2.84%     0.01%  fio              [kernel.kallsyms]                               [k] xfs_file_buffered_read
     2.73%     0.11%  fio              [kernel.kallsyms]                               [k] alloc_pages_mpol
     2.72%     0.04%  fio              [kernel.kallsyms]                               [k] vfs_fstatat
     2.70%     0.56%  fio              [kernel.kallsyms]                               [k] __alloc_frozen_pages_noprof
     2.69%     0.04%  fio              [kernel.kallsyms]                               [k] filemap_read
     2.65%     1.92%  fio              [vdso]                                          [.] __vdso_clock_gettime
     2.58%     0.65%  fio              [kernel.kallsyms]                               [k] get_page_from_freelist
     2.58%     0.00%  swapper          [kernel.kallsyms]                               [k] common_startup_64
     2.58%     0.01%  swapper          [kernel.kallsyms]                               [k] cpu_startup_entry
     2.58%     0.03%  swapper          [kernel.kallsyms]                               [k] do_idle
     2.50%     0.03%  kthreadd         [kernel.kallsyms]                               [k] __xfs_trans_commit
     2.49%     0.05%  fio              [kernel.kallsyms]                               [k] folio_alloc_noprof
     2.47%     0.05%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_alloc_vextent_start_ag
     2.42%     1.80%  fio              [kernel.kallsyms]                               [k] xfs_inode_item_format
     2.40%     0.12%  fio              [kernel.kallsyms]                               [k] xfs_trans_alloc
     2.39%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_alloc_vextent_iterate_ags.constprop.0
     2.38%     0.28%  fio              [kernel.kallsyms]                               [k] _raw_spin_lock
           2.09%
                _raw_spin_lock

     2.31%     0.05%  fio              [kernel.kallsyms]                               [k] vfs_statx
     2.20%     0.00%  swapper          [kernel.kallsyms]                               [k] start_secondary
     2.19%     0.32%  kthreadd         [kernel.kallsyms]                               [k] xlog_cil_commit
     2.16%     0.01%  kthreadd         [kernel.kallsyms]                               [k] xfs_rmap_update
     2.16%     0.01%  kthreadd         [kernel.kallsyms]                               [k] xfs_btree_update
     2.14%     0.02%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_defer_trans_roll
     2.12%     0.01%  kthreadd         [kernel.kallsyms]                               [k] __xfs_btree_updkeys.isra.0
     2.12%     0.01%  kthreadd         [kernel.kallsyms]                               [k] xfs_btree_update_keys.isra.0
     2.10%     0.59%  kthreadd         [kernel.kallsyms]                               [k] xfs_btree_get_leaf_keys
     2.08%     0.01%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_trans_roll
     2.08%     0.00%  fio              fio                                             [.] parse_options
     2.08%     0.00%  fio              fio                                             [.] __parse_jobs_ini
     2.05%     0.02%  fio              fio                                             [.] add_job
     2.02%     0.04%  fio              libc.so.6                                       [.] clock_gettime
           1.76%
                clock_gettime
                __vdso_clock_gettime

     1.96%     0.21%  fio              [kernel.kallsyms]                               [k] xfs_buffered_write_iomap_begin
     1.92%     0.01%  swapper          [kernel.kallsyms]                               [k] cpuidle_enter
     1.92%     0.03%  swapper          [kernel.kallsyms]                               [k] cpuidle_enter_state
     1.84%     1.52%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_rec_offset
     1.79%     1.23%  fio              [kernel.kallsyms]                               [k] memset
     1.79%     0.33%  fio              [kernel.kallsyms]                               [k] filename_lookup
     1.76%     1.07%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_rmapbt_init_high_key_from_rec
     1.74%     0.00%  xfsaild/md127    [kernel.kallsyms]                               [k] ret_from_fork_asm
     1.74%     0.00%  xfsaild/md127    [kernel.kallsyms]                               [k] ret_from_fork
     1.74%     0.00%  xfsaild/md127    [kernel.kallsyms]                               [k] kthread
     1.74%     0.11%  xfsaild/md127    [kernel.kallsyms]                               [k] xfsaild
     1.74%     0.32%  fio              [kernel.kallsyms]                               [k] xfs_log_reserve
     1.70%     0.02%  fio              [kernel.kallsyms]                               [k] filemap_get_pages
     1.66%     0.34%  fio              [kernel.kallsyms]                               [k] kmem_cache_alloc_noprof
     1.64%     0.02%  kthreadd         [kernel.kallsyms]                               [k] iomap_finish_ioends
     1.63%     0.03%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_alloc_ag_vextent_near
     1.63%     0.00%  kswapd1          [kernel.kallsyms]                               [k] ret_from_fork_asm
     1.63%     0.00%  kswapd1          [kernel.kallsyms]                               [k] ret_from_fork
     1.63%     0.00%  kswapd1          [kernel.kallsyms]                               [k] kthread
     1.63%     0.00%  kswapd1          [kernel.kallsyms]                               [k] kswapd
     1.63%     0.00%  kswapd1          [kernel.kallsyms]                               [k] balance_pgdat
     1.63%     0.08%  kworker/u196:0-  [kernel.kallsyms]                               [k] writeback_iter
     1.62%     0.00%  kswapd1          [kernel.kallsyms]                               [k] shrink_node
     1.62%     0.00%  kswapd1          [kernel.kallsyms]                               [k] shrink_one
     1.60%     0.64%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_rmapbt_cmp_two_keys
     1.59%     0.04%  kthreadd         [kernel.kallsyms]                               [k] iomap_finish_ioend_buffered
     1.55%     0.02%  fio              fio                                             [.] generic_open_file
     1.52%     0.01%  fio              fio                                             [.] close_and_free_files
     1.52%     0.00%  kswapd1          [kernel.kallsyms]                               [k] try_to_shrink_lruvec
     1.52%     0.00%  kswapd1          [kernel.kallsyms]                               [k] evict_folios
     1.46%     0.17%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_trans_read_buf_map
     1.46%     0.04%  fio              fio                                             [.] put_file
     1.46%     0.00%  kworker/u196:0-  [kernel.kallsyms]                               [k] iomap_ioend_writeback_submit
     1.45%     0.06%  kworker/u196:0-  [kernel.kallsyms]                               [k] submit_bio_noacct_nocheck
     1.44%     0.92%  fio              [kernel.kallsyms]                               [k] kmem_cache_free
     1.44%     0.32%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_btree_lookup
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] ret_from_fork_asm
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] ret_from_fork
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] kthread
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] kswapd
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] balance_pgdat
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] shrink_node
     1.44%     0.00%  kswapd0          [kernel.kallsyms]                               [k] shrink_one
     1.43%     0.02%  fio              [kernel.kallsyms]                               [k] path_lookupat
     1.42%     0.00%  kswapd0          [kernel.kallsyms]                               [k] try_to_shrink_lruvec
     1.42%     0.00%  kswapd0          [kernel.kallsyms]                               [k] evict_folios
     1.41%     0.03%  kworker/u196:0-  [kernel.kallsyms]                               [k] __submit_bio
     1.40%     0.02%  kthreadd         [kernel.kallsyms]                               [k] xfs_defer_trans_roll
     1.38%     0.24%  kthreadd         [kernel.kallsyms]                               [k] xfs_buf_get_map
     1.36%     1.27%  fio              [kernel.kallsyms]                               [k] fault_in_readable
     1.35%     0.38%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_buf_get_map
     1.35%     0.06%  fio              [kernel.kallsyms]                               [k] xfs_inode_item_precommit
     1.34%     0.01%  kthreadd         [kernel.kallsyms]                               [k] xfs_trans_roll
     1.33%     0.01%  xfsaild/md127    [kernel.kallsyms]                               [k] xfs_inode_item_push
     1.33%     0.08%  kthreadd         [kernel.kallsyms]                               [k] xfs_trans_read_buf_map
     1.32%     1.00%  fio              [kernel.kallsyms]                               [k] fdget_pos
     1.31%     0.06%  xfsaild/md127    [kernel.kallsyms]                               [k] xfs_iflush_cluster
     1.29%     0.06%  fio              [kernel.kallsyms]                               [k] walk_component
     1.29%     0.24%  fio              [kernel.kallsyms]                               [k] xfs_iunlock
     1.29%     0.00%  fio              fio                                             [.] init_disk_util
     1.26%     0.25%  fio              [kernel.kallsyms]                               [k] __mem_cgroup_charge
     1.21%     0.17%  fio              [kernel.kallsyms]                               [k] __filemap_add_folio
     1.19%     0.28%  kworker/u196:0-  [kernel.kallsyms]                               [k] kmem_cache_alloc_noprof
     1.19%     0.10%  kworker/u196:0-  [kernel.kallsyms]                               [k] xfs_buf_read_map
     1.18%     0.28%  kthreadd         [kernel.kallsyms]                               [k] xfs_btree_lookup
     1.18%     0.83%  fio              [kernel.kallsyms]                               [k] clear_page_erms
     1.17%     0.05%  kthreadd         [kernel.kallsyms]                               [k] xfs_buf_read_map
     1.13%     0.21%  kswapd1          [kernel.kallsyms]                               [k] shrink_folio_list
     1.13%     0.14%  fio              [kernel.kallsyms]                               [k] balance_dirty_pages_ratelimited_flags
     1.13%     0.20%  fio              fio                                             [.] lookup_file_hash
     1.12%     0.10%  fio              fio                                             [.] io_queue_event
     1.12%     0.37%  fio              [kernel.kallsyms]                               [k] link_path_walk
     1.12%     0.03%  kthreadd         [kernel.kallsyms]                               [k] folio_end_writeback
     1.11%     0.00%  fio              [kernel.kallsyms]                               [k] __x64_sys_close
     1.10%     0.14%  fio              [kernel.kallsyms]                               [k] xfs_trans_read_buf_map
     1.07%     0.01%  fio              [kernel.kallsyms]                               [k] __fput
     1.04%     0.17%  kswapd0          [kernel.kallsyms]                               [k] shrink_folio_list
     1.03%     0.62%  kworker/u196:0-  [kernel.kallsyms]                               [k] memcpy
     1.03%     0.00%  fio              [kernel.kallsyms]                               [k] force_page_cache_ra
     1.02%     0.01%  fio              [kernel.kallsyms]                               [k] page_cache_ra_unbounded
     1.02%     0.03%  kthreadd         [kernel.kallsyms]                               [k] xfs_free_extent_fix_freelist
     1.02%     0.03%  fio              [kernel.kallsyms]                               [k] xlog_ticket_alloc
     1.01%     0.00%  fio              [kernel.kallsyms]                               [k] xfs_dir_create_child
     1.00%     0.03%  kworker/u196:0-  [kernel.kallsyms]                               [k] blk_mq_submit_bio
     1.00%     0.02%  fio              [kernel.kallsyms]                               [k] iomap_write_end

-- 
~karim
