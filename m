Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A50FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiJ0VGw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237275AbiJ0VGS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:06:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAC12716C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:03:11 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ez6so2815813pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HM8zmWCVse3lRVR7OnRfMHgC1fL3Mt3znedC6q1lh9M=;
        b=Qn9hrnGarHi+xlI91G8sL/1GeaInctk9K1sVIhc68To5CTJYYNAH29aFOHH9/vqVNL
         enHmYqOrWXUBYflL/s9sArDbSmYmKJLEcvX5FyS2Ya5s8lwbQcxMlCmj9sKAR+ReXkI0
         O/76ViKmliq1UqI42yO68TF8LKVKPnM0D86DKv90LHuIllkG+jSZwpetSfigKJhke4RK
         bEJsgO5gUaR/KifFwT7CbS5OV9h1XCFnbzmBNoNfBSaySXO1dm/Kb7ty5UgsvAeByBI7
         5mRE+KEgonBKYcuLSvNEIUagn+dvrh1aLwVoPUGsJS5V71cKXabu6rltBKZuP8rwZ6tx
         Ne2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HM8zmWCVse3lRVR7OnRfMHgC1fL3Mt3znedC6q1lh9M=;
        b=iJKibL46+awAOI/ssZYnRJBgkzh7FjDgR26N+aMyXs+ealqWrhL/jTdMXmPqX+2M79
         V2m3hXvdWsKE96pMUUUG75tsoDRfd76hurBiHHkApl2Qn4OreuVi8itQ30KLJ6rRYDBr
         1ce6M2n5X26pjY1ykM8Pd03Slq7tt3IEGeohkGU3Wbwws0uCxXjXhdCLu8ptrgOeHeRJ
         T1Wdrl9sA8JkcVD0kTCPKvuJ+emwnXtVupJATvj+V6JATTUzyM69eJlshN05cJbWpOrs
         ypQI3zKpgDOqCx+mBeSWZizX06XDi5SF8PNTUrEPQ87JSPbgoB1OgSbq6YBRjaGrehCk
         ZDtw==
X-Gm-Message-State: ACrzQf3p/ZPJIRvJoXu9DfUleYrHfFZnALspP01ShGPmAEijaHLSxIBq
        hSFYqx9767QgMbcjg+QkDStXFQ==
X-Google-Smtp-Source: AMsMyM4KbMvBqOyiBrByWB4f0YL7Iw43TBKv0RAcYS1Jqn+5eiUwDhdFMDYfPrOfU9hJ32+OoPhF6Q==
X-Received: by 2002:a17:90a:1a43:b0:20a:db02:6841 with SMTP id 3-20020a17090a1a4300b0020adb026841mr11912935pjl.104.1666904591114;
        Thu, 27 Oct 2022 14:03:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902d50600b00186c5e8a8d7sm1626749plg.171.2022.10.27.14.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:03:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooA1r-0079b1-Os; Fri, 28 Oct 2022 08:03:07 +1100
Date:   Fri, 28 Oct 2022 08:03:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
Message-ID: <20221027210307.GS3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689087143.3788582.13267485725187767138.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689087143.3788582.13267485725187767138.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:31AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Just prior to committing the reflink code into upstream, the xfs
> maintainer at the time requested that I find a way to shard the refcount
> records into two domains -- one for records tracking shared extents, and
> a second for tracking CoW staging extents.  The idea here was to
> minimize mount time CoW reclamation by pushing all the CoW records to
> the right edge of the keyspace, and it was accomplished by setting the
> upper bit in rc_startblock.  We don't allow AGs to have more than 2^31
> blocks, so the bit was free.
> 
> Unfortunately, this was a very late addition to the codebase, so most of
> the refcount record processing code still treats rc_startblock as a u32
> and pays no attention to whether or not the upper bit (the cow flag) is
> set.  This is a weakness is theoretically exploitable, since we're not
> fully validating the incoming metadata records.
> 
> Fuzzing demonstrates practical exploits of this weakness.  If the cow
> flag of a node block key record is corrupted, a lookup operation can go
> to the wrong record block and start returning records from the wrong
> cow/shared domain.  This causes the math to go all wrong (since cow
> domain is still implicit in the upper bit of rc_startblock) and we can
> crash the kernel by tricking xfs into jumping into a nonexistent AG and
> tripping over xfs_perag_get(mp, <nonexistent AG>) returning NULL.
> 
> To fix this, start tracking the domain as an explicit part of struct
> xfs_refcount_irec, adjust all refcount functions to check the domain
> of a returned record, and alter the function definitions to accept them
> where necessary.
> 
> Found by fuzzing keys[2].cowflag = add in xfs/464.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Couple of minor things.

> @@ -169,12 +183,17 @@ xfs_refcount_update(
>  	struct xfs_refcount_irec	*irec)
>  {
>  	union xfs_btree_rec	rec;
> +	__u32			start;
>  	int			error;

Why __u32 and not, say, u32 or uint32_t? u32 is used 10x more often
than __u32 in the kernel code, and in XFS only seem to use the __
variants in UAPI structures.

> @@ -364,6 +388,7 @@ xfs_refcount_split_extent(
>  		error = -EFSCORRUPTED;
>  		goto out_error;
>  	}
> +
>  	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
>  		return 0;
>  

Random new whitespace?

Other than that it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
