Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716A9C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 21:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F05361413
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 21:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhDTVzb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 17:55:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233769AbhDTVza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 17:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618955697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZNEJUPr0UgJXtysS8OjL+G8msqqxz3mZ44ntV4DyhIE=;
        b=J5e/5umz5e++GRWlt03+h9ZUcYz+CA6dSPMiwh0v6U0hQW8LyC25i8zIP3PuIEHc6hxVPB
        TsQtGtDU4zlZ1XXuo0YcCUxbMCt1348WR+MF5OVIHswEBGcjUVyWidN4U1n+EpVRCLKqtB
        XFLStdsxUlwH6YGI5STrckrvpptRAoo=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-0xr2iGKsOnC9jvbCEVLqCQ-1; Tue, 20 Apr 2021 17:54:55 -0400
X-MC-Unique: 0xr2iGKsOnC9jvbCEVLqCQ-1
Received: by mail-pg1-f198.google.com with SMTP id b2-20020a6567c20000b02901fda3676f83so8693183pgs.9
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 14:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZNEJUPr0UgJXtysS8OjL+G8msqqxz3mZ44ntV4DyhIE=;
        b=BJBp70Qzn2zrKVMuyHiHD4QC7i13z24QAzNSd/RxXqQjYavBhcelxnj6wGvgI/sN6X
         QHzSpYeHtQX9BZcQhzsP/SPa+6M+WcCznvMc5+5befPCB4Yz3lIPx2IZfLUA3u9jvnn6
         tP5NlhYgzmBxKSpsdo3/46pYr+6ivhOnBaZLkTYFPG6Qlxqh7XOtFZ1MLoFIRWqbq7gw
         Pj71RpDz25nNd7Y4pTicygjolGFSiH2fwXL0XJXZpUdVrhsvgRRhPSCTbbJbY3eI/js8
         /+eNhMdPNxXwCIB5J2iFY7vmfsWfpD/ByyJ3zeMVd+XOpvFiTIFJMZ3oeWUilR/FjIdU
         A8Zw==
X-Gm-Message-State: AOAM533dEw3ox06tOQ2yTzoKhgfcI+EQSLTBFsDqEAnbdMVGMXXPJk/5
        SvtKouSopZN4eMHoBMyzrXwjX5+uCQAJNBn+x/5O1DLvyFuSXcd035HhXjhyTr4NUoeDn6KfzIP
        3AUmAAGE/7G924ewooYxI
X-Received: by 2002:a17:902:d482:b029:ec:9091:d099 with SMTP id c2-20020a170902d482b02900ec9091d099mr18268864plg.34.1618955694705;
        Tue, 20 Apr 2021 14:54:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweX+woUw620svc3Zqs7+zcqJo25dgLrWxF0Rm9CIsrJkeZYzCGgMUY76W0YxJkDZRKHbbpvw==
X-Received: by 2002:a17:902:d482:b029:ec:9091:d099 with SMTP id c2-20020a170902d482b02900ec9091d099mr18268860plg.34.1618955694429;
        Tue, 20 Apr 2021 14:54:54 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u1sm82158pjj.19.2021.04.20.14.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 14:54:53 -0700 (PDT)
Date:   Wed, 21 Apr 2021 05:54:43 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210420215443.GA3047037@xiangao.remote.csb>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210420212506.GW63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, Apr 21, 2021 at 07:25:06AM +1000, Dave Chinner wrote:
> On Tue, Apr 20, 2021 at 07:08:54PM +0800, Gao Xiang wrote:
> > There are many paths which could trigger xfs_log_sb(), e.g.
> >   xfs_bmap_add_attrfork()
> >     -> xfs_log_sb()
> > , which overrides on-disk fdblocks by in-core per-CPU fdblocks.
> > 
> > However, for !lazysbcount cases, on-disk fdblocks is actually updated
> > by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> > in-core per-CPU fdblocks due to xfs_reserve_blocks() or whatever,
> > see the comment in xfs_unmountfs().
> > 
> > It could be observed by the following steps reported by Zorro:
> > 
> > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > 2. mount $dev $mnt
> > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > 4. umount $mnt
> > 5. xfs_repair -n $dev
> > 
> > yet due to commit f46e5a174655 ("xfs: fold sbcount quiesce logging
> > into log covering"), xfs_sync_sb() will also be triggered if log
> > covering is needed and !lazysbcount when xfs_unmountfs(), so hard
> > to reproduce on kernel 5.12+ for clean unmount.
> > 
> > on-disk sb_icount and sb_ifree are also updated in
> > xfs_trans_apply_sb_deltas() for !lazysbcount cases, however, which
> > are always equal to per-CPU counters, so only fdblocks matters.
> > 
> > After this patch, I've seen no strange so far on older kernels
> > for the testcase above without lazysbcount.
> > 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > changes since v1:
> >  - update commit message.
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 60e6d255e5e2..423dada3f64c 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -928,7 +928,13 @@ xfs_log_sb(
> >  
> >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > +		struct xfs_dsb	*dsb = bp->b_addr;
> > +
> > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > +	} else {
> > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	}
> 
> THis really needs a comment explaining why this is done this way.
> It's not obvious from reading the code why we pull the the fdblock
> count off disk and then, in  xfs_sb_to_disk(), we write it straight
> back to disk.
> 
> It's also not clear to me that summing the inode counters is correct
> in the case of the !lazysbcount for the similar reasons - the percpu
> counter is not guaranteed to be absolutely accurate here, yet the
> values in the disk buffer are. Perhaps we should be updating the
> m_sb values in xfs_trans_apply_sb_deltas() for the !lazycount case,
> and only summing them here for the lazycount case...

But if updating m_sb values in xfs_trans_apply_sb_deltas(), we
should also update on-disk sb counters in xfs_trans_apply_sb_deltas()
and log sb for !lazysbcount (since for such cases, sb counter update
should be considered immediately.)

That will indeed cause more modification, I'm not quite sure if it's
quite ok honestly. But if you assume that's more clear, I could submit
an alternative instead later.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

