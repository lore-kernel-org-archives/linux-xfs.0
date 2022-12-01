Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB548C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 01:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLABRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 20:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLABRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 20:17:09 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE99791F
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 17:17:05 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id a9so153450pld.7
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 17:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7HRRjPovAC1VQ+hzP6WMMBztvWT0UQlBl80SyQEov/Y=;
        b=w4MFHrAfMQ3FNeVTyuGMgk2QLSBvh8hc2QoY81L+cjPr5k1mOk7deOiCFP0eZcrzzE
         U/+TbK9Kmr7TFL/YfBtQF7m3z65hxhpuavqVhbNzE6TCUz5QXM/d0MbaaJKJ422rpP57
         VOAgoYH71DpZHPHOGROezLOD3CgRW/mxBco54ie5J7s0bAW/z0n8aqG61pt4ZOmdY/ZV
         n73vWbD9WocGm8h+Dnf3Dkn5MztuuaIPbdW+5caRPtGIqAyMohoQflMLxd18maR2P8uC
         LLH/zIjoWzB1wi5UPMdCU43m/twhLRTONpxPGbldk+2si8ECwgnExxA4UhZl9kYseiv9
         kOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HRRjPovAC1VQ+hzP6WMMBztvWT0UQlBl80SyQEov/Y=;
        b=qBmOkENXDubtgvI9Nc02RrG3oxb1PZsfqK7hc3harYA7y5gwHhhax/G8yJxjadtsuw
         ELg9G9fKcusCmEXQx1qvZG9gwU1ivZpHDXmiOlD4h5PUQdqMkG3QsYez3HbWu72UNr+/
         u0UO/OSs4o2LkqDBKu46b1mPn7NMC12WWnHP43NTIA92arJHeHYH++ah5gKdSHJmvKCX
         PxgHedOfea9fA+1RLYtRAO4N1j7RExr4m53aBMptMq2h41FSA+DqVz389VHqd0Ikie7W
         jzL65IDv35KDjaeZT1Hp7p3L97WNZNS47rMrrPBXl6GEEZPJyS4AP8bLwa5X9PoZ1Xna
         VSYg==
X-Gm-Message-State: ANoB5plHHKaKPUnWIC0H+2rWpRJOPBGBPuvuG6zEpGdeq8uU7ye3x1FB
        2XtUUOtHjZqZZVrdR0CbSCFzYA==
X-Google-Smtp-Source: AA0mqf5d9nhTzEVMo5Wvciwqj+Ys6k2oc5Q8UnKAfEb3iq/AUXoTE+LA8Bi5iDcB8QGz3GrSE/axrg==
X-Received: by 2002:a17:90a:5c85:b0:20a:92d2:226a with SMTP id r5-20020a17090a5c8500b0020a92d2226amr56740626pji.155.1669857424542;
        Wed, 30 Nov 2022 17:17:04 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id o13-20020a170902d4cd00b0017f7c4e260fsm2152022plg.150.2022.11.30.17.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 17:17:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p0YCD-0032GA-5C; Thu, 01 Dec 2022 12:17:01 +1100
Date:   Thu, 1 Dec 2022 12:17:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: invalidate xfs_bufs when allocating cow extents
Message-ID: <20221201011701.GM3600936@dread.disaster.area>
References: <Y4fzk0YCTA9qC45l@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4fzk0YCTA9qC45l@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 04:21:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While investigating test failures in xfs/17[1-3] in alwayscow mode, I
> noticed through code inspection that xfs_bmap_alloc_userdata isn't
> setting XFS_ALLOC_USERDATA when allocating extents for a file's CoW
> fork.  COW staging extents should be flagged as USERDATA, since user
> data are persisted to these blocks before being remapped into a file.
> 
> This mis-classification has a few impacts on the behavior of the system.
> First, the filestreams allocator is supposed to keep allocating from a
> chosen AG until it runs out of space in that AG.  However, it only does
> that for USERDATA allocations, which means that COW allocations aren't
> tied to the filestreams AG.  Fortunately, few people use filestreams, so
> nobody's noticed.
> 
> A more serious problem is that xfs_alloc_ag_vextent_small looks for a
> buffer to invalidate *if* the USERDATA flag is set and the AG is so full
> that the allocation had to come from the AGFL because the cntbt is
> empty.  The consequences of not invalidating the buffer are severe --
> if the AIL incorrectly checkpoints a buffer that is now being used to
> store user data, that action will clobber the user's written data.
> 
> Fix filestreams and yet another data corruption vector by flagging COW
> allocations as USERDATA.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 56b9b7db38bb..0d56a8d862e8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4058,7 +4058,7 @@ xfs_bmap_alloc_userdata(
>  	 * the busy list.
>  	 */
>  	bma->datatype = XFS_ALLOC_NOBUSY;
> -	if (whichfork == XFS_DATA_FORK) {
> +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
>  		bma->datatype |= XFS_ALLOC_USERDATA;
>  		if (bma->offset == 0)
>  			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
