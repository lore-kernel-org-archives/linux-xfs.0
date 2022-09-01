Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD46ECAAD3
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Sep 2022 16:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiIAQKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 12:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiIAQJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 12:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A020C260D;
        Thu,  1 Sep 2022 09:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15D7861E47;
        Thu,  1 Sep 2022 16:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C24C433D6;
        Thu,  1 Sep 2022 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662048595;
        bh=YtnT3VTcDeGAA5aBrOmdZBzpsMAIlYi/pgEH5xxN2yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KR9g7vhQJ1/vA61vPcKhx0VCe7lOhzWsKOh0fxel2ye4HNYX/k6jToyhnRwqeXli0
         3PSAfn4FDMCUeM7RijiMPL1yREuXdiFrsl5P2cB0JLWzHMVT7tQb4aV3yxLqLULzgD
         51WcItvy+ntvzMJRCJ3iXu+bhxPEx/gO7tVlYiUHoLIUbTzY5tabNxZPtQxKH8/NQG
         phiV4F2Y6w3orZ3uJsvHTzmxnWM0buwePKD6Y1zL3GvdsrBOhX/dERZlSMQ8vxEHy5
         Y7VwnsyUEr1kQCrdUyvAdV0mFQgl0YSaKZfISQmEdW6dZrNpKzYmAEWa7QszCBHDA6
         gyPCDf2VI5fDg==
Date:   Thu, 1 Sep 2022 09:09:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zeng Heng <zengheng4@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] xfs: missing space in xfs trace log
Message-ID: <YxDZUyN1XgawXvqD@magnolia>
References: <20220901110205.565167-1-zengheng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901110205.565167-1-zengheng4@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 01, 2022 at 07:02:05PM +0800, Zeng Heng wrote:
> Add space between arguments would help someone
> to locate the key words they want, so break
> quoted strings at a space character.
> 
> Such as below:
> [Before]
> kworker/1:0-280     [001] .....   600.782135: xfs_bunmap:
> dev 7:0 ino 0x85 disize 0x0 fileoff 0x0 fsbcount 0x400000001fffffflags ATTRFORK ...
> 
> [After]
> kworker/1:2-564     [001] ..... 23817.906160: xfs_bunmap:
> dev 7:0 ino 0x85 disize 0x0 fileoff 0x0 fsbcount 0x400000001fffff flags ATTRFORK ...
> 
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>

Whoops, thanks for cleaning this up.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trace.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9057af6e0c8..cb7c81ba7fa3 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1170,7 +1170,7 @@ DECLARE_EVENT_CLASS(xfs_dqtrx_class,
>  		__entry->ino_res_used = qtrx->qt_ino_res_used;
>  		__entry->icount_delta = qtrx->qt_icount_delta;
>  	),
> -	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s"
> +	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s "
>  		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
>  		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
>  		  "ino_res %llu ino_res_used %llu icount_delta %lld",
> @@ -1602,7 +1602,7 @@ TRACE_EVENT(xfs_bunmap,
>  		__entry->caller_ip = caller_ip;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx fsbcount 0x%llx"
> +	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx fsbcount 0x%llx "
>  		  "flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -- 
> 2.25.1
> 
