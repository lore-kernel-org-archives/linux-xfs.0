Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:38568 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751701AbdFHPcK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 11:32:10 -0400
Date: Thu, 8 Jun 2017 11:32:08 -0400
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170608153207.GA8625@fieldses.org>
References: <20170602060457.GG23805@eguan.usersys.redhat.com>
 <20170607192338.GG4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607192338.GG4530@birch.djwong.org>
From: bfields@fieldses.org (J. Bruce Fields)
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 07, 2017 at 12:23:38PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 02, 2017 at 02:04:57PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > Starting from 4.12-rc1 kernel, I saw Linux nfs server crashes all the
> > time in my fstests (xfstests) runs, I appended the console log of an
> > NFSv3 crash to the end of this mail.
> > 
> > I was exporting a directory resided on XFS, and loopback mounted the NFS
> > export on localhost. Both NFSv3 and NFSv4 could hit this crash. The
> > crash usually happens when running test case generic/029 or generic/095.
> > 
> > But the problem is, there's no easy and efficient way to reproduce it, I
> > tried run only generic/029 and generic/095 in a loop for 1000 times but
> > failed, I also tried run the 'quick' group tests only for 50 iterations
> > but failed again. It seems that the only reliable way to reproduce it is
> > run the 'auto' group tests for 20 iterations.
> > 
> > 	i=0
> > 	while [ $i -lt 20 ]; do
> > 		./check -nfs -g auto
> > 		((i++))
> > 	done
> > 
> > And usually server crashed within 5 iterations, but at times it could
> > survive 10 iterations and only crashed if you left it running for more
> > iterations. This makes it hard to bisect and bisecting is very
> > time-consuming.
> > 
> > (The bisecting is running now, it needs a few days to finish. My first
> > two attempts pointed first bad commit to some mm patches, but reverting
> > that patch didn't prevent server from crashing, so I enlarged the loop
> > count and started bisecting for the third time).
> > 
> > If more info is needed please let me know.
> > 
> > Thanks,
> > Eryu
> > 
> > 
> > [88895.796834] run fstests generic/028 at 2017-06-01 00:43:18
> > [88900.945420] run fstests generic/029 at 2017-06-01 00:43:23
> > [88901.127315] BUG: unable to handle kernel paging request at ffffffffc0360e12
> > [88901.135095] IP: report_bug+0x64/0x100
> > [88901.139177] PGD 3b7c0c067
> > [88901.139177] P4D 3b7c0c067
> > [88901.142194] PUD 3b7c0e067
> > [88901.145209] PMD 469e33067
> > [88901.148225] PTE 80000004675f4161
> > [88901.151240]
> > [88901.156497] Oops: 0003 [#1] SMP
> > [88901.159997] Modules linked in: loop dm_mod nfsv3 nfs fscache ext4 jbd2 mbcache intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm nfsd irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ipmi_ssif cdc_ether aesni_intel iTCO_wdt usbnet crypto_simd ipmi_si glue_helper sg iTCO_vendor_support wmi mii cryptd ipmi_devintf ipmi_msghandler auth_rpcgss shpchp i2c_i801 pcspkr ioatdma lpc_ich nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops igb ttm drm ptp pps_core dca megaraid_sas crc32c_intel i2c_algo_bit i2c_core
> > [88901.221606] CPU: 9 PID: 3278 Comm: nfsd Not tainted 4.12.0-rc3 #42
> > [88901.228500] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012
> > [88901.238885] task: ffffa10062d12d00 task.stack: ffffc2820478c000
> > [88901.245488] RIP: 0010:report_bug+0x64/0x100
> > [88901.250153] RSP: 0018:ffffc2820478f598 EFLAGS: 00010202
> > [88901.255980] RAX: ffffffffc0360e08 RBX: ffffffffc0301cdc RCX: 0000000000000001
> > [88901.263940] RDX: 0000000000000907 RSI: ffffffffc038bc80 RDI: ffffffffffff0d22
> > [88901.271901] RBP: ffffc2820478f5b8 R08: 0000000000000001 R09: 00000000000001cc
> > [88901.279861] R10: ffffffffb6a36f67 R11: 0000000000000000 R12: ffffc2820478f6e8
> > [88901.287821] R13: ffffffffc0351b2a R14: 00000000000003fb R15: 0000000000000004
> > [88901.295783] FS:  0000000000000000(0000) GS:ffffa1007f6c0000(0000) knlGS:0000000000000000
> > [88901.304818] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [88901.311227] CR2: ffffffffc0360e12 CR3: 00000003b7c09000 CR4: 00000000000406e0
> > [88901.319188] Call Trace:
> > [88901.321920]  do_trap+0x16a/0x190
> > [88901.325519]  do_error_trap+0x89/0x110
> > [88901.329652]  ? xfs_do_writepage+0x65c/0x680 [xfs]
> 
> Hmm, does gdb think this address is at:
> 
> (gdb) l *(xfs_do_writepage+0x65c)
> 0x7c17c is in xfs_do_writepage (/storage/home/djwong/cdev/work/linux-xfs/include/linux/highmem.h:77).
> 
> like my system?  That location is preempt_disable() in kunmap_atomic(),
> which is ... odd.  I tried to run your reproducer script but smashed
> into this instead:
> 
> [  826.735882] ============================================
> [  826.736952] WARNING: possible recursive locking detected
> [  826.737992] 4.12.0-rc4-xfsx #7 Not tainted
> [  826.738636] --------------------------------------------
> [  826.739700] nfsd/1416 is trying to acquire lock:
> [  826.740423]  (&stp->st_mutex){+.+.+.}, at: [<ffffffffa004cda6>] nfsd4_process_open2+0x4f6/0x1360 [nfsd]
> [  826.741749] 
> [  826.741749] but task is already holding lock:
> [  826.742897]  (&stp->st_mutex){+.+.+.}, at: [<ffffffffa004cd3f>] nfsd4_process_open2+0x48f/0x1360 [nfsd]

I guess the most likely culprit's the weird locking at the end of
init_open_stateid().

I believe one of those locks (stp->st_mutex) is on an object that's not
visible outside this thread yet.  But maybe there's something else wrong
there, I'll look....  I wonder why I'm not hitting it?

Anyway, this looks likely to be a different bug from the one Eryu Guan's
hitting.

--b.
