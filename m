Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AC9C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 14:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3D36103D
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 14:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhDPOKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 10:10:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234914AbhDPOKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 10:10:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618582224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2+CFIqeF3FG/u4GkfbPRxQY7mRtYH+NKfL4plPjT2cA=;
        b=Y28ErEUuQyIlaXz5dmkDWaiO2sWYx68YyVfOsJfkgtxKUJNsx/NX1uFt3u2NoCMMIGtLDn
        G1Qld0IPZ3BkG2W5OopLF27GRs2G7jLgrq5sAepUcrGkyRtemyci9OfQO+bx4uTAu2BFA9
        MoEzEK3ZBfF3bFUzVR8JNPoTd7D0PMA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-UVkp8nPgOMy4sbIkj23lvg-1; Fri, 16 Apr 2021 10:10:22 -0400
X-MC-Unique: UVkp8nPgOMy4sbIkj23lvg-1
Received: by mail-ed1-f71.google.com with SMTP id t11-20020aa7d4cb0000b0290382e868be07so7063035edr.20
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 07:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=2+CFIqeF3FG/u4GkfbPRxQY7mRtYH+NKfL4plPjT2cA=;
        b=mNYjcYeBeQ/FyEY6o7buFUcbSvVsGIREpvJ8W98MPkpMbi5MJoxmziEb8deoIi3Np1
         a8SwOC7jao/3unNxLC+YfdN/cXnRhby5ADN7tc+6DLFZ8aH8UDb0LNPajuojwQL0tSEs
         4NhXAiK5JwpiwQG+xWlUu7dIKSUSb2yR6AJiain95lRYQ4g5zZfBNIzIK95gXvtrEEqZ
         2AKyjCwZDrrVwq8eC2Bawoyn01xZ8JcqKtnm32DBlUHlFGimY3InCob24DFwVoYFbwRj
         oyBOw20CXUXE6sBcmGA6RwNKFC+pzQaUSJ/UI9DcKu9tZ9v/oe1LLNWQQZZazx7+Ep/z
         CvGA==
X-Gm-Message-State: AOAM531r+9vn+pKRYeokbYAB4aFoAvNFbWjxLDxGH72EeGX5Hy0ilmT9
        mVVUStXXCrWXWoy3XNNFmVSY3IEiDEOP1yCCv3HnNPDiT8K4GPP48hg/DT9SAWd/jcdziYq5C5Q
        6FfKE+mF/LHSI/qlhY49D
X-Received: by 2002:a17:907:3e1f:: with SMTP id hp31mr8390410ejc.163.1618582221462;
        Fri, 16 Apr 2021 07:10:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdF0gkbDqaVc7/4aojjALm1UghSGS4CKVEU9VKmETkgos4xbmmFJUOy+Ca9n2IskrxZd0cXQ==
X-Received: by 2002:a17:907:3e1f:: with SMTP id hp31mr8390393ejc.163.1618582221293;
        Fri, 16 Apr 2021 07:10:21 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id gu14sm2948835ejb.114.2021.04.16.07.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 07:10:20 -0700 (PDT)
Date:   Fri, 16 Apr 2021 16:10:18 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210416141018.iio743iupb6vpcip@omega.lan>
Mail-Followup-To: Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416091023.2143162-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 16, 2021 at 05:10:23PM +0800, Gao Xiang wrote:
> There are many paths which could trigger xfs_log_sb(), e.g.
>   xfs_bmap_add_attrfork()
>     -> xfs_log_sb()
> , which overrided on-disk fdblocks by in-core per-CPU fdblocks.
> 
> However, for !lazysbcount cases, on-disk fdblocks is actually updated
> by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> in-core fdblocks due to xfs_reserve_block() or whatever, see the
> comment in xfs_unmountfs().
> 
> It could be observed by the following steps reported by Zorro [1]:
> 
> 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> 2. mount $dev $mnt
> 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> 4. umount $mnt
> 5. xfs_repair -n $dev
> 
> yet due to commit f46e5a174655("xfs: fold sbcount quiesce logging
> into log covering"),

> ... xfs_sync_sb() will be triggered even !lazysbcount
> but xfs_log_need_covered() case when xfs_unmountfs(), so hard to
> reproduce on kernel 5.12+.

I think this could be rephrased, but I am not native english-speaker either, so
I can't say much. Maybe...

"xfs_sync_sb() will be triggered if no log covering is needed and !lazysbcount."

> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 60e6d255e5e2..423dada3f64c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -928,7 +928,13 @@ xfs_log_sb(
>  
>  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +		struct xfs_dsb	*dsb = bp->b_addr;
> +
> +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> +	} else {
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	}

The patch looks good to me, feel free to add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

