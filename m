Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1527BC761A6
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 22:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjCNWPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjCNWOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 18:14:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86454AFF9
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 15:14:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p6so18172046plf.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678831989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4XnYZAxxhA6tqO/+QU5FPwVQ3ZTboYKzwGys5pyLjfs=;
        b=b7ShfFvuy7/o7jT+od5bs68UIhkWiIumdXAa4ZVHBOYlHxKgsdtGeciMG3yc+3OMwF
         J5CnaXgDiyaC+uU4oAjYtr9vhWdZc7LCGFCKf0TF/zr9LX0+GQ0/nOZiU0t+fDNkVtum
         8qPQ9kfuLzhlK7yFiriIS5hITNG9bBlET0eOYM+Z5zKC6+9Cfk76oGLXI/vxYgBaSamZ
         D0xKNV8z29qhg39hERv/HfyOy0AvRwG7Wfp17yOLGuMHDQb1Gnsc/G/XplXJp0ZbGodY
         MuXAZE/WIGr1d56EEQsK5jSQFOs2TPdYfrqy+t4G+naWryM62SSfOessvIy6PpmtLvUs
         RqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678831989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4XnYZAxxhA6tqO/+QU5FPwVQ3ZTboYKzwGys5pyLjfs=;
        b=fGmv+dNs/q4uwuGArH5vVUNajyNUrPeEHzhQqGd000pEGY+bYfKWCiQrjzZAKMOu0E
         9X5zZEeFeKCpYq3ILO6MGl/LJGQEwotyqCHt+AoXxUjg6bwDI1pbEFTahOkcGgy6A7Xg
         f5gZJvBzVOhgA3H055QheqA/Q7Ogr72Jky6HV9nnCuN0snS+yjE+3qFo1i5s8m+DNgFo
         Jv3+z3eN6rXnGKR8T4UZipcc4IHkVm6TdcsbUVPT6XFk8AI+QtQudktBdHuD/zp7IGCM
         SKxon6/MFzRV52xO3j4AcL9lHIxZ+75jQLXsd7rTriYBgw+x+s9NaBSefm+gJVZlMPzg
         /QyQ==
X-Gm-Message-State: AO0yUKVIswnOfrIy2Nno4C+HBt76BZkAQELZnY1ZAeXXBMAphv1Ddb6i
        zBSxZqvG907GNpD8R/gffRNo9w==
X-Google-Smtp-Source: AK7set+tgmW5AlsxN5YmxxUFdS6mgDkKSypzJ8ZUWx8IcwYjP6AdyXEX3kxwDueMMeBxIsXOKiTafg==
X-Received: by 2002:a17:902:e38a:b0:19f:1e3e:a84d with SMTP id g10-20020a170902e38a00b0019f1e3ea84dmr355485ple.64.1678831988927;
        Tue, 14 Mar 2023 15:13:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id ka16-20020a170903335000b0019e21d2ed2esm2240881plb.88.2023.03.14.15.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:13:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pcCtF-008oq2-ND; Wed, 15 Mar 2023 09:13:05 +1100
Date:   Wed, 15 Mar 2023 09:13:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ye Bin <yebin@huaweicloud.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Bin <yebin10@huawei.com>
Subject: Re: [PATCH] xfs: fix possible assert failed in xfs_fs_put_super()
 when do cpu offline
Message-ID: <20230314221305.GR360264@dread.disaster.area>
References: <20230314090649.326642-1-yebin@huaweicloud.com>
 <20230314163100.GC11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314163100.GC11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 09:31:00AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 14, 2023 at 05:06:49PM +0800, Ye Bin wrote:
> > From: Ye Bin <yebin10@huawei.com>
> > 
> > There's a issue when do cpu offline test:
> > CPU: 48 PID: 1168152 Comm: umount Kdump: loaded Tainted: G L
> > pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> > pc : assfail+0x8c/0xb4
> > lr : assfail+0x38/0xb4
> > sp : ffffa00033ce7c40
> > x29: ffffa00033ce7c40 x28: ffffa00014794f30
> > x27: ffffa00014f6ca20 x26: 1fffe0120b2e2030
> > x25: ffff009059710188 x24: ffff00886c0a4650
> > x23: 1fffe0110d8148ca x22: ffff009059710180
> > x21: ffffa00015155680 x20: ffff00886c0a4000
> > x19: 0000000000000001 x18: 0000000000000000
> > x17: 0000000000000000 x16: 0000000000000000
> > x15: 0000000000000007 x14: 1fffe00304cef265
> > x13: ffff00182642b200 x12: ffff8012d37757bf
> > x11: 1fffe012d37757be x10: ffff8012d37757be
> > x9 : ffffa00010603a0c x8 : 0000000041b58ab3
> > x7 : ffff94000679cf44 x6 : 00000000ffffffc0
> > x5 : 0000000000000021 x4 : 00000000ffffffca
> > x3 : 1ffff40002a27ee1 x2 : 0000000000000004
> > x1 : 0000000000000000 x0 : ffffa0001513f000
> > Call trace:
> >  assfail+0x8c/0xb4
> >  xfs_destroy_percpu_counters+0x98/0xa4
> >  xfs_fs_put_super+0x1a0/0x2a4
> >  generic_shutdown_super+0x104/0x2c0
> >  kill_block_super+0x8c/0xf4
> >  deactivate_locked_super+0xa4/0x164
> >  deactivate_super+0xb0/0xdc
> >  cleanup_mnt+0x29c/0x3ec
> >  __cleanup_mnt+0x1c/0x30
> >  task_work_run+0xe0/0x200
> >  do_notify_resume+0x244/0x320
> >  work_pending+0xc/0xa0
> > 
> > We analyzed the data in vmcore is correct. But triggered above issue.
> > As f689054aace2 ("percpu_counter: add percpu_counter_sum_all interface")
> > commit describes there is a small race window between the online CPUs traversal
> > of percpu_counter_sum and the CPU offline callback. This means percpu_counter_sum()
> > may return incorrect result during cpu offline.
> > To solve above issue use percpu_counter_sum_all() interface to make sure
> > result is correct to prevent false triggering of assertions.
> 
> How about the other percpu_counter_sum callsites inside XFS?  Some of
> them are involved in writing ondisk metadata (xfs_log_sb) or doing
> correctness checks (fs/xfs/scrub/*); shouldn't those also be using the
> _all variant?

Ugh. I kinda wish that the percpu_counter_sum_all() patch had been
cc'd to lists for subsystems that use percpu_counter_sum()
extensively, or just to people who have modified that code in the
past.

The problem is that it uses cpu_possible_mask, which means it
walks all possible CPUs that can be added to the system even if the
CPUs aren't physically present. That can be a lot in the case of
systems that can have cpu-capable nodes hotplugged into them, and
that makes percpu_counter_sum_all() excitingly expensive for no good
reason.

AFAICT, if we are trying to close a race condition between iterating
online CPUs not summing dying CPUs and the cpu dead notification
updating the sum, then shouldn't we be using
cpu_mask_or(cpu_online_mask, cpu_dying_mask) for summing iteration
rather than just cpu_online_mask?

i.e. when a CPU is being taken down, it gets added to the
cpu_dying_mask, then removed from the cpu_online_mask, then the
offline notifications are run (i.e. the percpu counter dead
callback), and when the CPU reaches the CPUHP_TEARDOWN_CPU state,
it is removed from the cpu_dying_mask because it is now dead and all
the "cpu dying" callbacks have been run.

Except when a hotplug event is being processed, cpu_dying_mask will
be empty, hence there is little change in summing overhead. But it
will close the summing race condition when a CPU is being
offlined...

That, I think, is the solution we want for XFS. Having the percpu
counters just do the right thing is far better than always having to
wonder if summation interface we are using is correct in the face of
CPU hotplug. I'll put a patchset together to do:

1. fix percpu_counter_sum() to include the dying mask in it's
iteration. This should fix the XFS issue.
2. change the only user of percpu_counter_sum_all() to only use
percpu_counter_sum() because percpu_counter_sum_all() is now
redundant.
3. remove percpu_counter_sum_all() because it is unused.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
