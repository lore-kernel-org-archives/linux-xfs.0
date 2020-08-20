Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5DCC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 04:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67142076E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 04:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SCRZVnPS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgHTEBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 00:01:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725290AbgHTEBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 00:01:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597896075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D00qawC76dF4vxFcwHMZt68BKvjy2xaRp3VDkCwqU18=;
        b=SCRZVnPS5ZFxmSSduz+P+8PZDmXjfceHMCF8+2uN8MTQ3Fj+kGAkbihjCKljKstNw44+bX
        a/4wHk8czgKJcNlSMFUVWZ5VhrQW7dpcByuFJbqSa3O47C1YSQSelnOwC/V2IWFLGk5gET
        BlpdgVsxBcAxZDdWx5wMyaGElNujsQs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-h9I8wQk2MCWLNlBwQhsJTw-1; Thu, 20 Aug 2020 00:01:12 -0400
X-MC-Unique: h9I8wQk2MCWLNlBwQhsJTw-1
Received: by mail-pl1-f198.google.com with SMTP id w23so716680pll.21
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 21:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D00qawC76dF4vxFcwHMZt68BKvjy2xaRp3VDkCwqU18=;
        b=sHQAhu40ch+SrPIlXsz8PoH+Lomn+8o5C/Ah54Z4618RGzhwUx3n7wN9xRJvX2QHwc
         uLjb2wome4dp40U6SqPdWL/V7ggJqhLJBDPaJRwr9EJFbLLFjQKn5QvB5gCR/Ak4/Xdq
         oTA1fh2SNzXw/0iAjyqMWQ+ho/c5bVsANZ6ZacCSiFHuU00NxQbAzADLkyQMfs+CfhnT
         IgHCB8P7n1XAMc3tc5g3CxvSDVpqMXUuu+sXYSrm9Vu2ISOxNvofDxADYw8XRuzsLvLi
         d93lNJlu1JvEDxBwV77xl9heWUiITCY1gkyZAb9piez2B/OpuY5ACZT1YbusezmAyi9B
         uR0w==
X-Gm-Message-State: AOAM531RqbvKOzD8LB48HzOB3JSZdv3xHsKEPBjJRx3j7+UWBme5+ViY
        RBQ0RFjm+NvTsehFe/37Amz1ilJwdI6LQoQQfo5sOEmEaMeQZdi/OWb7bRYB7maptoNm55iq+ri
        oPUg+4rImwj1wSSM0/pfO
X-Received: by 2002:a17:90a:f286:: with SMTP id fs6mr871438pjb.221.1597896070995;
        Wed, 19 Aug 2020 21:01:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzCCjJTQ8nB52+uyibpPGMKxIRWrSdI6+YWRwYgq7PAA72cc/oacVFzyh/FlMgDmuDfjBBYw==
X-Received: by 2002:a17:90a:f286:: with SMTP id fs6mr871413pjb.221.1597896070687;
        Wed, 19 Aug 2020 21:01:10 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d1sm488543pjs.17.2020.08.19.21.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 21:01:10 -0700 (PDT)
Date:   Thu, 20 Aug 2020 12:01:00 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH v4 0/3] xfs: more unlinked inode list optimization v4
Message-ID: <20200820040100.GA30469@xiangao.remote.csb>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
 <20200820024618.GG6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820024618.GG6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Aug 19, 2020 at 07:46:18PM -0700, Darrick J. Wong wrote:
> Hm.  I saw the following warning from lockdep when running generic/078 with:
> 
> MKFS_OPTIONS --  -m reflink=1,rmapbt=1 -i sparse=1
> MOUNT_OPTIONS --  -o usrquota,grpquota,prjquota,
> CHECK_OPTIONS -- -g auto
> XFS_MKFS_OPTIONS -- -bsize=4096
> 
> The test kernel is 5.9-rc1 + inobtcount + y2038 + dave's iunlink series + yours

Thanks for the report. I didn't enable lockdep before, will confirm it soon.

Thanks!
Gao Xiang

> 
> +[  516.166575] run fstests generic/078 at 2020-08-19 15:35:28
> +[  516.659584] XFS (sda): Mounting V5 Filesystem
> +[  516.846982] XFS (sda): Ending clean mount
> +[  516.849669] xfs filesystem being mounted at /mnt supports timestamps until 2038 (0x7fffffff)
> +
> +[  517.341920] ============================================
> +[  517.342849] WARNING: possible recursive locking detected
> +[  517.343832] 5.9.0-rc1-djw #rc1 Tainted: G        W        
> +[  517.344862] --------------------------------------------
> +[  517.345886] renameat2/107505 is trying to acquire lock:
> +[  517.346830] ffff88803ca48468 (&pag->pag_iunlink_mutex){+.+.}-{3:3}, at: xfs_iunlink+0xb8/0x3f0 [xfs]
> +[  517.348460] 
> +               but task is already holding lock:
> +[  517.349107] ffff88803ca4bc68 (&pag->pag_iunlink_mutex){+.+.}-{3:3}, at: xfs_iunlink_remove+0x239/0x3f0 [xfs]
> +[  517.350240] 
> +               other info that might help us debug this:
> +[  517.351166]  Possible unsafe locking scenario:
> +
> +[  517.351902]        CPU0
> +[  517.352399]        ----
> +[  517.352895]   lock(&pag->pag_iunlink_mutex);
> +[  517.353572]   lock(&pag->pag_iunlink_mutex);
> +[  517.354387] 
> +                *** DEADLOCK ***
> +
> +[  517.355394]  May be due to missing lock nesting notation
> +
> +[  517.356132] 9 locks held by renameat2/107505:
> +[  517.356615]  #0: ffff888032b78468 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x24/0x60
> +[  517.357561]  #1: ffff88803d00bfe8 (&inode->i_sb->s_type->i_mutex_dir_key/1){+.+.}-{3:3}, at: lock_rename+0xf5/0x100
> +[  517.358912]  #2: ffff88803d00fbe8 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: vfs_rename+0x17d/0x950
> +[  517.360011]  #3: ffff888032b78688 (sb_internal){.+.+}-{0:0}, at: xfs_trans_alloc+0x18b/0x250 [xfs]
> +[  517.361018]  #4: ffff88803d00f8f0 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xcf/0x2a0 [xfs]
> +[  517.362063]  #5: ffff88803d00bcf0 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_nowait+0xcf/0x340 [xfs]
> +[  517.363173]  #6: ffff88803bf82df0 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock_nowait+0xcf/0x340 [xfs]
> +[  517.364685]  #7: ffff88803d00cbf0 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_nowait+0xcf/0x340 [xfs]
> +[  517.366414]  #8: ffff88803ca4bc68 (&pag->pag_iunlink_mutex){+.+.}-{3:3}, at: xfs_iunlink_remove+0x239/0x3f0 [xfs]
> +[  517.367787] 
> +               stack backtrace:
> +[  517.368285] CPU: 1 PID: 107505 Comm: renameat2 Tainted: G        W         5.9.0-rc1-djw #rc1
> +[  517.369196] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
> +[  517.370401] Call Trace:
> +[  517.370703]  dump_stack+0x7c/0xac
> +[  517.371091]  __lock_acquire.cold+0x168/0x2ab
> +[  517.371571]  lock_acquire+0xa2/0x370
> +[  517.372025]  ? xfs_iunlink+0xb8/0x3f0 [xfs]
> +[  517.372505]  __mutex_lock+0xa1/0xa00
> +[  517.372955]  ? xfs_iunlink+0xb8/0x3f0 [xfs]
> +[  517.373455]  ? kvm_clock_read+0x14/0x30
> +[  517.373898]  ? kvm_sched_clock_read+0x9/0x20
> +[  517.374379]  ? sched_clock_cpu+0x14/0xe0
> +[  517.374897]  ? xfs_iunlink+0xb8/0x3f0 [xfs]
> +[  517.375405]  ? xfs_iunlink+0x94/0x3f0 [xfs]
> +[  517.376185]  ? rcu_read_lock_sched_held+0x56/0x80
> +[  517.377055]  ? xfs_iunlink+0xb8/0x3f0 [xfs]
> +[  517.377896]  xfs_iunlink+0xb8/0x3f0 [xfs]
> +[  517.378703]  xfs_rename+0xdb8/0x1030 [xfs]
> +[  517.379261]  xfs_vn_rename+0xd5/0x140 [xfs]
> +[  517.379740]  vfs_rename+0x1bc/0x950
> +[  517.380146]  ? lookup_dcache+0x18/0x60
> +[  517.380572]  ? do_renameat2+0x343/0x4d0
> +[  517.381013]  do_renameat2+0x343/0x4d0
> +[  517.381672]  __x64_sys_renameat2+0x25/0x30
> +[  517.382145]  do_syscall_64+0x31/0x40
> +[  517.382554]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> +[  517.383330] RIP: 0033:0x7fb9be244083
> +[  517.384005] Code: 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca 45 85 c0 74 44 b8 3c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 3d 41 89 c0 83 f8 ff 74 0d 44 89 c0 c3 66 0f
> +[  517.387257] RSP: 002b:00007ffc56416ed8 EFLAGS: 00000202 ORIG_RAX: 000000000000013c
> +[  517.388148] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fb9be244083
> +[  517.389183] RDX: 00000000ffffff9c RSI: 00007ffc5641968c RDI: 00000000ffffff9c
> +[  517.390190] RBP: 0000000000000000 R08: 0000000000000004 R09: 00007ffc56416fd8
> +[  517.391440] R10: 00007ffc5641969c R11: 0000000000000202 R12: 000056494b1d6220
> +[  517.392747] R13: 00007ffc56416fd0 R14: 0000000000000000 R15: 0000000000000000
> +[  517.831548] XFS (sda): Unmounting Filesystem
> +[  518.026539] XFS (sda): Mounting V5 Filesystem
> +[  518.158574] XFS (sda): Ending clean mount
> +[  518.160484] xfs filesystem being mounted at /mnt supports timestamps until 2038 (0x7fffffff)
> 
> Dunno what this is about, but I'll have a look in the morning...
> 
> --D
> 

