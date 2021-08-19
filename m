Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36630C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 08:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2C46112E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 08:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhHSI2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:28:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237378AbhHSI23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 04:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629361673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=trK9Mt5x+FV61izbEg28C1l0G77kgGqnVtr4u3v5ff4=;
        b=UK98mw5Q/46OS+7JZEqc/PYYWgxTq6FCKy74Cz5cmfTY27d68xH0F7R+9PL2n737Gxwr0F
        zcUBp1r2OeaDGkCvIKxT+l8dtDFzcMx5TDTIKYB1vH13ts+XYjyzHvYP5k+ngcjgqCJvbt
        tbBfF9t1Z2QiWbEZuj/IMWw3f95582U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-sDaAjw7vPPCkcqbRYA27YA-1; Thu, 19 Aug 2021 04:27:52 -0400
X-MC-Unique: sDaAjw7vPPCkcqbRYA27YA-1
Received: by mail-ed1-f70.google.com with SMTP id z4-20020a05640240c4b02903be90a10a52so2433294edb.19
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 01:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=trK9Mt5x+FV61izbEg28C1l0G77kgGqnVtr4u3v5ff4=;
        b=BCwzJP8iHrM+tJRNIF8wzQNkXyUVZGCSFOl1AnDkjg4EAzyzFg80qR1GqMO0U9naWJ
         +3wTNZMREB/xv9GJy3TTtPKJDvFSMVBM/WeK5GPkxjYex988zf/0zpDjSYX/AlxI625a
         WYLRXzaemeb4DAwfYzfYg8rCuGf2eyJjHYwpOiIfqFJkK3F/+6T1UpInvj2Y/BU0HHjh
         XhNd5ZtRJ9BYonzUI8u0QPxH2M+xlAdlHXwbofwBei2QjzcJTKswZ864+05v7j7jPVL8
         S2IXBvhvYjt9sz12HghM3aKq2b6pnvjPMw/g0pW9L3bk/Wh22/U6/x3JnvrxHGcf4OD+
         OI3g==
X-Gm-Message-State: AOAM533tAe9xFFPGbisOvQeQ3lrkysnjNg4RmLZmtm6TeSi5y6+TuRMF
        rYjp9YLJXAqD0QT3mL313VMseJDQ0/lJLGPcYpBFz3oT51XhAv/GxyjSYx1DE7r0Bl0WbkMnYht
        w4lPQZqad0ED3VtFcjl/f
X-Received: by 2002:a17:906:140e:: with SMTP id p14mr15100961ejc.235.1629361670978;
        Thu, 19 Aug 2021 01:27:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO4odqj8sE05/1820g7lUScBwTcgsoftqVwapdv562HcOQ1Y9o7cQpIgLumUB8Vh0LNngvqw==
X-Received: by 2002:a17:906:140e:: with SMTP id p14mr15100951ejc.235.1629361670775;
        Thu, 19 Aug 2021 01:27:50 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id cq12sm1350642edb.43.2021.08.19.01.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 01:27:50 -0700 (PDT)
Date:   Thu, 19 Aug 2021 10:27:48 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: standardize inode number formatting in ftrace
 output
Message-ID: <20210819082748.5r56xpyrmjr6ccyi@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924374307.761813.7272815473497235066.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924374307.761813.7272815473497235066.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print inode numbers in hexadecimal and preceded with the unit
> "ino" or "agino", as apropriate.  Fix one tracepoint that used "ino %u"
> for an inode btree block count to reduce confusion.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/trace.h |    8 ++++----
>  fs/xfs/xfs_trace.h   |   12 ++++++------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 29f1d0ac7ec5..e6e70d5870a2 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -103,7 +103,7 @@ DECLARE_EVENT_CLASS(xchk_class,
>  		__entry->flags = sm->sm_flags;
>  		__entry->error = error;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx type %s agno %u inum %llu gen %u flags 0x%x error %d",
> +	TP_printk("dev %d:%d ino 0x%llx type %s agno %u inum 0x%llx gen %u flags 0x%x error %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
> @@ -572,7 +572,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
>  		__entry->holemask = holemask;
>  		__entry->cluster_ino = cluster_ino;
>  	),
> -	TP_printk("dev %d:%d agno %d startino %u daddr 0x%llx len %d chunkino %u nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino %u",
> +	TP_printk("dev %d:%d agno %d startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startino,
> @@ -842,7 +842,7 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
>  		__entry->rmapbt_sz = rmapbt_sz;
>  		__entry->refcbt_sz = refcbt_sz;
>  	),
> -	TP_printk("dev %d:%d agno %d bno %u ino %u rmap %u refcount %u",
> +	TP_printk("dev %d:%d agno %d bnobt %u inobt %u rmapbt %u refcountbt %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->bnobt_sz,
> @@ -886,7 +886,7 @@ TRACE_EVENT(xrep_ialloc_insert,
>  		__entry->freecount = freecount;
>  		__entry->freemask = freemask;
>  	),
> -	TP_printk("dev %d:%d agno %d startino %u holemask 0x%x count %u freecount %u freemask 0x%llx",
> +	TP_printk("dev %d:%d agno %d startino 0x%x holemask 0x%x count %u freecount %u freemask 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startino,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 7e04a6adb349..6b2d4c5205d8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3191,7 +3191,7 @@ DECLARE_EVENT_CLASS(xfs_inode_error_class,
>  		__entry->error = error;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d ino %llx error %d caller %pS",
> +	TP_printk("dev %d:%d ino 0x%llx error %d caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->error,
> @@ -3603,7 +3603,7 @@ DECLARE_EVENT_CLASS(xfs_ag_inode_class,
>  		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
>  		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
>  	),
> -	TP_printk("dev %d:%d agno %u agino %u",
> +	TP_printk("dev %d:%d agno %u agino 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno, __entry->agino)
>  )
> @@ -3706,7 +3706,7 @@ TRACE_EVENT(xfs_iwalk_ag,
>  		__entry->agno = agno;
>  		__entry->startino = startino;
>  	),
> -	TP_printk("dev %d:%d agno %d startino %u",
> +	TP_printk("dev %d:%d agno %d startino 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
>  		  __entry->startino)
>  )
> @@ -3727,7 +3727,7 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
>  		__entry->startino = irec->ir_startino;
>  		__entry->freemask = irec->ir_free;
>  	),
> -	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
> +	TP_printk("dev %d:%d agno %d startino 0x%x freemask 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
>  		  __entry->startino, __entry->freemask)
>  )
> @@ -3790,7 +3790,7 @@ TRACE_EVENT(xfs_check_new_dalign,
>  		__entry->sb_rootino = mp->m_sb.sb_rootino;
>  		__entry->calc_rootino = calc_rootino;
>  	),
> -	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
> +	TP_printk("dev %d:%d new_dalign %d sb_rootino 0x%llx calc_rootino 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->new_dalign, __entry->sb_rootino,
>  		  __entry->calc_rootino)
> @@ -3847,7 +3847,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
>  		__entry->blocks = cur->bc_ino.ifake->if_blocks;
>  		__entry->whichfork = cur->bc_ino.whichfork;
>  	),
> -	TP_printk("dev %d:%d btree %s ag %u agino %u whichfork %s levels %u blocks %u",
> +	TP_printk("dev %d:%d btree %s ag %u agino 0x%x whichfork %s levels %u blocks %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->agno,
> 

-- 
Carlos

