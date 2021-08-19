Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED333C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CACEA61153
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhHSLMu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 07:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233978AbhHSLMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 07:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629371534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bnS/pqYN320HVPWCmeJ+NPbYHQuIn5ssJXvCTDcpRFM=;
        b=GSVBfRyXdcpmEmnmCPNDjUmbh+whseMsqFvW9TqsAjwIs92DPbS3vd/Ggu1H7VTUixMJ00
        /4wYqmiRcGH2a+FPMobPOGzfzL7RnRY68OPD+uqd5aRWUDr8xZaMLcbR+8VBAYjepiQ03X
        tdtIujA5ItgFL0IRyKkpx2tIHSSxagk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-SZIYBXxVMAS8ZiDqWZcxhg-1; Thu, 19 Aug 2021 07:12:12 -0400
X-MC-Unique: SZIYBXxVMAS8ZiDqWZcxhg-1
Received: by mail-ed1-f72.google.com with SMTP id d12-20020a50fe8c0000b02903a4b519b413so2640402edt.9
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 04:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=bnS/pqYN320HVPWCmeJ+NPbYHQuIn5ssJXvCTDcpRFM=;
        b=Ms5ItDsiTAIC8k6B8vchKflzyxeIwfMbXHMxDmZNg03cslRzjw+3ud4IT2ZmPq6V6n
         MJMoB0GYqMJLjneZR4igGXz8Z8cpi1b7aRdlzfyUwC7yOEwO/2FK7kMob4QYLKu2g87I
         jjUcDR9VbZ9rKuLD1FeaBf8vGZGxygg1TKJmGfRAnZnmCivmKg0F6WDjXXz6cWXtJB3r
         RuJJDPzVHZYsNtlHVCw4UhEnqwXTm23BgwTbUA1J1rfz2pOzh+Eb/+fCykBRLCNbQW3i
         5ptxXITe3V9O1rD+JKsNrNpNAEEZOuYQmp7dsdkHwYHLq90npp79OZXniwp2Bg64bFif
         /JFQ==
X-Gm-Message-State: AOAM5330y/mAtkcNPqIINaRrXg3impnFSYgJRpVH20Z/+1mayL+a1XFr
        +lKl5IDJSH6465MWo7yv4Zk+51lmopMT4wpqzAt2obnOo7UsS7I7KZwyN7ZKdU+3zMdhdP8lwm2
        1m/LkdYJd/ChN210IIn1h
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr15718993edd.151.1629371531371;
        Thu, 19 Aug 2021 04:12:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi/bfFTSchVpafinJ6nRkwgBIa5w+4HblJTfD6LAftvNOgXFIeirbQx0rw8aU/yoepGMCDFw==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr15718978edd.151.1629371531190;
        Thu, 19 Aug 2021 04:12:11 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id i16sm1128719ejx.78.2021.08.19.04.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:12:10 -0700 (PDT)
Date:   Thu, 19 Aug 2021 13:12:09 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] xfs: disambiguate units for ftrace fields tagged
 "blkno", "block", or "bno"
Message-ID: <20210819111209.5r63tsgwy4e7ntmg@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924377054.761813.15725895998141087832.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924377054.761813.15725895998141087832.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints describe fields as "blkno", "block", or "bno".
> That name doesn't describe any units, which makes the fields not very
> useful.  Rename the fields to capture units and ensure the format is
> hexadecimal.
> 
> "startblock" is the startblock field from the bmap structure, which is a
> segmented fsblock on the data device, or an rfsblock on the realtime
> device.
> "fileoff" is a file offset, in units of filesystem blocks
> "daddr" is a raw device offset, in 512b blocks
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_trace.h |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3944373ad2f6..d725bc4bd1e7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  		__entry->caller_ip = caller_ip;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
> -		  "offset %lld block %lld count %lld flag %d caller %pS",
> +		  "offset %lld startblock 0x%llx count %lld flag %d caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
> @@ -1434,7 +1434,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
> -		  "fork %s startoff 0x%llx startblock %lld blockcount 0x%llx",
> +		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -1552,14 +1552,14 @@ TRACE_EVENT(xfs_pagecache_inval,
>  );
>  
>  TRACE_EVENT(xfs_bunmap,
> -	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
> +	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t fileoff, xfs_filblks_t len,
>  		 int flags, unsigned long caller_ip),
> -	TP_ARGS(ip, bno, len, flags, caller_ip),
> +	TP_ARGS(ip, fileoff, len, flags, caller_ip),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
>  		__field(xfs_fsize_t, size)
> -		__field(xfs_fileoff_t, bno)
> +		__field(xfs_fileoff_t, fileoff)
>  		__field(xfs_filblks_t, len)
>  		__field(unsigned long, caller_ip)
>  		__field(int, flags)
> @@ -1568,17 +1568,17 @@ TRACE_EVENT(xfs_bunmap,
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->size = ip->i_disk_size;
> -		__entry->bno = bno;
> +		__entry->fileoff = fileoff;
>  		__entry->len = len;
>  		__entry->caller_ip = caller_ip;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
> +	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx len 0x%llx"
>  		  "flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> -		  __entry->bno,
> +		  __entry->fileoff,
>  		  __entry->len,
>  		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
>  		  (void *)__entry->caller_ip)
> @@ -2271,7 +2271,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
>  		__entry->size = buf_f->blf_size;
>  		__entry->map_size = buf_f->blf_map_size;
>  	),
> -	TP_printk("dev %d:%d blkno 0x%llx, len %u, flags 0x%x, size %d, "
> +	TP_printk("dev %d:%d daddr 0x%llx, len %u, flags 0x%x, size %d, "
>  			"map_size %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->blkno,
> @@ -2322,7 +2322,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
>  		__entry->boffset = in_f->ilf_boffset;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
> -			"dsize %d, blkno 0x%llx, len %d, boffset %d",
> +			"dsize %d, daddr 0x%llx, len %d, boffset %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -3276,7 +3276,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
>  		__entry->pblk = irec->br_startblock;
>  		__entry->state = irec->br_state;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x pblk %llu st %d",
> +	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x startblock 0x%llx st %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->lblk,
> @@ -3417,7 +3417,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
>  		__entry->offset = rmap->rm_offset;
>  		__entry->flags = rmap->rm_flags;
>  	),
> -	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner 0x%llx offset %llu flags 0x%x",
> +	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx offset %llu flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
>  		  __entry->agno,
> @@ -3457,7 +3457,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
>  		__entry->offset = fsmap->fmr_offset;
>  		__entry->flags = fsmap->fmr_flags;
>  	),
> -	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner 0x%llx offset %llu flags 0x%llx",
> +	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx offset %llu flags 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
>  		  __entry->block,
> 

-- 
Carlos

