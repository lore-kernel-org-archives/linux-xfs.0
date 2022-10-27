Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0EAFA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiJ0VWg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiJ0VWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:22:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1995B53C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:22:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id g24so2960811plq.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSjrR4Hp5FrCn77+AT2HkrDSi4aPuLIMy9c/Cfxwf6s=;
        b=msyZuAYylDeDoDL2c64AABYGhQxpz5dFi6mxw2ZxYueQ4K38zi9ynhQ5T+E5ntDnTI
         FZYW9yVnv4GXZ9FNfXaR9T4yGy0ZOXEfFdFL6YuDJHsMTUr3BNmgeTM/qSaJDDCsd++e
         7ypauRASxruy7oT/MH2IytqfsPZ4npUyS1uKNnRcGIHkOz5wj9Oc+DLvBWdu2X40fUtl
         UUG0/ULGJnCOcMCk1+XRFrGr7VQ3kH1txYyoiPtd6Fl2v3oR+xM25aveR6rHJT2l+Ep3
         pvS+s5r8s4tj503xSATbX73AyL3zjewE/KQBWAirowJIkpkE+5QwaZyTL+HEEXmOHaKl
         0aOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSjrR4Hp5FrCn77+AT2HkrDSi4aPuLIMy9c/Cfxwf6s=;
        b=r8S3SgyAzoCu0vTQqFzNigtsdknlFUOSuxO5Ul6l4ian4nm3spQ/akTfz8yNmPJliA
         93qM99HMc4iuTT8zblXNTWuizuxWbhlfGVLfuUmo/15DfI7pjq7gcCONa9F/165UKcPF
         GF8hKrMQfw95cBo0HF4ab20g/mIO+tEozL6Bo1WvyWuHa8rhRt4eYudUFdwQ2DRS3cJb
         oxxoA4N9EsWzo2K/7W6LKi/FpOlQ4bmrNjN9Cd9L/H+zGasZ/2eQXaKWwfbD+UsWKseY
         fDF+GMTFaFE7EekNkIlN718OJGbR3h4uEKxUqKLh+0ESY/sltIH/fEUUh8sv+ILKsKw5
         nEKA==
X-Gm-Message-State: ACrzQf3P8Zc5P3jTGLJ82gVftDGMMoURY/NSPDfex5j0GsMLhUpYKjcD
        o2svw/AoBclD7ANtXFaoV2vATw==
X-Google-Smtp-Source: AMsMyM6NbTNp8MaAus1vBK+OFjgHxpHFG2knciEAMe7P9foNclhBI3qX1UhqyFsMxPdnsEx5jxDO/Q==
X-Received: by 2002:a17:90b:4f4d:b0:20d:a08e:3876 with SMTP id pj13-20020a17090b4f4d00b0020da08e3876mr12322592pjb.0.1666905754317;
        Thu, 27 Oct 2022 14:22:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id t9-20020a62d149000000b0052d4cb47339sm1584362pfl.151.2022.10.27.14.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:22:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooAKd-0079nT-5c; Fri, 28 Oct 2022 08:22:31 +1100
Date:   Fri, 28 Oct 2022 08:22:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: fix agblocks check in the cow leftover
 recovery function
Message-ID: <20221027212231.GX3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689089944.3788582.6885104145014798058.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689089944.3788582.6885104145014798058.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As we've seen, refcount records use the upper bit of the rc_startblock
> field to ensure that all the refcount records are at the right side of
> the refcount btree.  This works because an AG is never allowed to have
> more than (1U << 31) blocks in it.  If we ever encounter a filesystem
> claiming to have that many blocks, we absolutely do not want reflink
> touching it at all.
> 
> However, this test at the start of xfs_refcount_recover_cow_leftovers is
> slightly incorrect -- it /should/ be checking that agblocks isn't larger
> than the XFS_MAX_CRC_AG_BLOCKS constant, and it should check that the
> constant is never large enough to conflict with that CoW flag.
> 
> Note that the V5 superblock verifier has not historically rejected
> filesystems where agblocks <= XFS_MAX_CRC_AG_BLOCKS, which is why this
ITYM                         >=

> ended up in the COW recovery routine.

I think we should probably fix that - I didn't realise we had this
superblock geometry check buried deep in the reflink recovery code.

That said, for the moment adding an extra check to the reflink
recovery code is fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
