Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F38C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 01:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiLUBtc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 20:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLUBtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 20:49:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE91A1A3A4
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 17:49:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o12so14230445pjo.4
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 17:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oOuUGecf9quk2xFjbqlWy4e0Pq3XRbd4VNOYz9fE4O0=;
        b=AsbswfQcsx5KYzHObMhgSzKsGPxk4SeCbxOpdNRVo1n/G22aiQ15+7+hrunf/oh01w
         ftoKjSZHTcUwnUG3+RtnlxdEuSQzl6AQoo6tI8wGCSTiegvxCUdCVpr2JlZnGBU7obqk
         dKJkXL9wh/KqwZBHbGeLhU8f4JgoPjqrC3q6nORU+3q0SzG952JUYIOS507rGZpZYSbl
         8bpNGidTyCznynP5/GGVlK2W1XZC5esvi9dne/4rAJDEMvrvkDus6CM3vGKVPAGGV5p2
         JYk+I0F8pN607hjI7cMugZJLrgtk/QtWICX33D5vfu+L++wLkWTcLbPjF+G1LFRveZQ1
         hkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOuUGecf9quk2xFjbqlWy4e0Pq3XRbd4VNOYz9fE4O0=;
        b=SmMRzw6Nv7XY1lqCz66lsgcBbkwX1fLLcfzq3mNkYiFsRfnep9L/4jbVcMEvXBxn1B
         kEDWuEpU9yN1UeYusG3PWahNegAF0XUaS39VH+Yh/Sfs52HwnZlf/EJHEphWZyc9oyVH
         0baGBAoZbp9fWeD1GYSZlF4Mg6tRpk/Of2+uAibsDesUBJsWOQIRFRm2FBNXo/ucxaxB
         kxA1pmy8ZqBx5LPyOyIdwu7lpEVMsker+BF1lTGXNkT9Kal2tYXt66otAym2qO009GxJ
         0sG9eMwrOigCoMU+tElfhm5iD17hWUIhlpNyKo7S0JaCUEK8y/NRpgYVAXRW5UOCrUDF
         WDeg==
X-Gm-Message-State: AFqh2kroMejKqKscgxGtrZRqZXfdVS+g93FBoLgRTcAuk+rt7klqDBeM
        TuN2m+jzaLCIk4TJM76BWuJiNQ==
X-Google-Smtp-Source: AMrXdXsop01wTk/fT6z/25SEIMtjNUq02+YY6RcYhqhkoMJqKEbVklVZSkIQYuy0yiZWAsJzM/CeGA==
X-Received: by 2002:a17:902:e9ca:b0:188:fc0c:cdb1 with SMTP id 10-20020a170902e9ca00b00188fc0ccdb1mr229462plk.16.1671587370400;
        Tue, 20 Dec 2022 17:49:30 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id u10-20020a170903124a00b0017f59ebafe7sm5711642plh.212.2022.12.20.17.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 17:49:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7oEZ-00AvPJ-4k; Wed, 21 Dec 2022 12:49:27 +1100
Date:   Wed, 21 Dec 2022 12:49:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_db: fix dir3 block magic check
Message-ID: <20221221014927.GM1971568@dread.disaster.area>
References: <167158400859.315997.2365290256986240896.stgit@magnolia>
 <167158401424.315997.9124675033467112155.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167158401424.315997.9124675033467112155.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 04:53:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this broken check, which (amazingly) went unnoticed until I cranked
> up the warning level /and/ built the system for s390x.
> 
> Fixes: e96864ff4d4 ("xfs_db: enable blockget for v5 filesystems")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index bb27ce58053..964756d0ae5 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2578,7 +2578,7 @@ process_data_dir_v2(
>  		error++;
>  	}
>  	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
> -	     be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) &&
> +	     be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) &&
>  					stale != be32_to_cpu(btp->stale)) {
>  		if (!sflag || v)
>  			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),

Yeah, we probably should have caught that sooner....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
