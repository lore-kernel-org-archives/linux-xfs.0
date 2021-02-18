Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A11C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3869F64ECC
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhBRSsb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25911 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231338AbhBRSQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 13:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613672104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ELtCvI/pB+TlSJsLMQGTXYGscLxnUfeBnaPBk0xwDp8=;
        b=GwCyyGPdQ1X2RW7xphbskLKFENWsRy9mDeh9nS/+LMtLjKNbw1bpIwcgh8f2joD7x9603K
        OTHrB5YmM7z+DhyZ3GqeEqbq1dE6ImM04vHgtuKPQiYLy+fcayI01tZD16cD07g/NkwkAl
        6NlAmtLl6AVNq7JKYqglbzp3BuPlX8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-AQeH2TctP3eoUXgNfIZlxw-1; Thu, 18 Feb 2021 13:15:02 -0500
X-MC-Unique: AQeH2TctP3eoUXgNfIZlxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7173185B68F;
        Thu, 18 Feb 2021 18:14:52 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 209205D9C2;
        Thu, 18 Feb 2021 18:14:52 +0000 (UTC)
Date:   Thu, 18 Feb 2021 13:14:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: lockdep recursive locking warning on for-next
Message-ID: <20210218181450.GA705507@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

I'm seeing the warning below via xfs/167 on a test machine. It looks
like it's just complaining about nested freeze protection between the
scan invocation and an underlying transaction allocation for an inode
eofblocks trim. I suppose we could either refactor xfs_trans_alloc() to
drop and reacquire freeze protection around the scan, or alternatively
call __sb_writers_release() and __sb_writers_acquire() around the scan
to retain freeze protection and quiet lockdep. Hm?

BTW, the stack report also had me wondering whether we had or need any
nesting protection in these new scan invocations. For example, if we
have an fs with a bunch of tagged inodes and concurrent allocation
activity, would anything prevent an in-scan transaction allocation from
jumping back into the scan code to complete outstanding work? It looks
like that might not be possible right now because neither scan reserves
blocks, but they do both use transactions and that's quite a subtle
balance..

Brian

[  316.631387] ============================================
[  316.636697] WARNING: possible recursive locking detected
[  316.642010] 5.11.0-rc4 #35 Tainted: G        W I      
[  316.647148] --------------------------------------------
[  316.652462] fsstress/17733 is trying to acquire lock:
[  316.657515] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
[  316.666405] 
               but task is already holding lock:
[  316.672239] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[  316.681269] 
...
               stack backtrace:
[  316.774735] CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
[  316.782819] Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
[  316.790386] Call Trace:
[  316.792844]  dump_stack+0x8b/0xb0
[  316.796168]  __lock_acquire.cold+0x159/0x2ab
[  316.800441]  lock_acquire+0x116/0x370
[  316.804106]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
[  316.809045]  ? rcu_read_lock_sched_held+0x3f/0x80
[  316.813750]  ? kmem_cache_alloc+0x287/0x2b0
[  316.817937]  xfs_trans_alloc+0x1ad/0x310 [xfs]
[  316.822445]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
[  316.827376]  xfs_free_eofblocks+0x104/0x1d0 [xfs]
[  316.832134]  xfs_blockgc_scan_inode+0x24/0x60 [xfs]
[  316.837074]  xfs_inode_walk_ag+0x202/0x4b0 [xfs]
[  316.841754]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
[  316.847040]  ? __lock_acquire+0x382/0x1e10
[  316.851142]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
[  316.856425]  xfs_inode_walk+0x66/0xc0 [xfs]
[  316.860670]  xfs_trans_alloc+0x160/0x310 [xfs]
[  316.865179]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[  316.870119]  xfs_alloc_file_space+0x105/0x300 [xfs]
[  316.875048]  ? down_write_nested+0x30/0x70
[  316.879148]  xfs_file_fallocate+0x270/0x460 [xfs]
[  316.883913]  ? lock_acquire+0x116/0x370
[  316.887752]  ? __x64_sys_fallocate+0x3e/0x70
[  316.892026]  ? selinux_file_permission+0x105/0x140
[  316.896820]  vfs_fallocate+0x14d/0x3d0
[  316.900572]  __x64_sys_fallocate+0x3e/0x70
[  316.904669]  do_syscall_64+0x33/0x40
[  316.908250]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
...

