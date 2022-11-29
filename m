Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A90C4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiK2Vit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbiK2Vir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:38:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9430B5F866
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:38:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mv18so13949806pjb.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A79DnCxs1Un+TibUL269HZBRFGRYvo+dk2qAobdfpBs=;
        b=CHWxaSNLwt9ak6ppVlbOhtzH7/JLWno6x2Yth69bZ/Zqa6A1e6gdAbTjvClPi7iXl3
         O6srYFv640uvrj6OtIAv8V28UGo2jWXkLi9v86QYLJaqQSseDBMmlFPT1KkSc1/IV4lE
         OE/7JdgUAhnVp3ivykYGyjsPb8f7cVUZqDxQ3agB7FaAgYisnzBWn+dkcS/UUYo2EuVA
         tMOG1I7Mx0iLP86Jf2SX7A1pf91RSwB9jwT3KooZLl2fHoItilX/G4A1/lNqq6hpTUnJ
         FmKdCrUeetiWYy07jJOBvBMScOhvYCcf5gjwNups7SDFRCH2aA5b1UafBA1Kv7lw7mFX
         rK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A79DnCxs1Un+TibUL269HZBRFGRYvo+dk2qAobdfpBs=;
        b=Zo1XI8v6aBI/lihlBlAzQfjKuzs1/jJ6pU4vqlUOXWX1XNg8szKdZdZawJBWtQTV4d
         nKdGfUIn5GrO7ao/qtXklbvmNYRuLZ0wRW1feMiXVxH6hGqigXSaVFf4sRNXEo+dNvTE
         PQiZ0v5RRm3r9+InU+hZOdEo2dDPj2ibubicuYYfzBNK4M3A2pITRbk8RE6Db1+51iVe
         nV33He9w71zw/wezV20D2pTygjC1OBVmBAhCtkEgVadJm7d3VY6XYc4lT9wopAVRmvek
         XC5Dy7/3L3Fm94IyCu701K4u+QG/zl5NghHpt58+MIYbEX2QNojkyvaswbSx7c59nz8P
         SgLQ==
X-Gm-Message-State: ANoB5pkVn7DO60VWRsdli+xlGMfztJXiSyo0GKvP1pNjqcmnub8KaC/x
        Z1Wi9sunWJ5j3uGb0gai/lPamQ==
X-Google-Smtp-Source: AA0mqf6Wt8nndKP6mgNbx4kXEHPKAg8ECdWNY2AsWyWnOmMnG4oIOHlWW8u82KUu6mNiqyZKmN8MdA==
X-Received: by 2002:a17:902:e849:b0:17a:aca0:e295 with SMTP id t9-20020a170902e84900b0017aaca0e295mr52405648plg.3.1669757926084;
        Tue, 29 Nov 2022 13:38:46 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id 23-20020a630417000000b004393f60db36sm16638pge.32.2022.11.29.13.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 13:38:45 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p08JO-002a23-AY; Wed, 30 Nov 2022 08:38:42 +1100
Date:   Wed, 30 Nov 2022 08:38:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/3] xfs: attach dquots to inode before reading
 data/cow fork mappings
Message-ID: <20221129213842.GH3600936@dread.disaster.area>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <Y4OuLTwPVdiHMBGi@magnolia>
 <Y4Z0FH0RORXeV17g@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Z0FH0RORXeV17g@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 01:05:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I've been running near-continuous integration testing of online fsck,
> and I've noticed that once a day, one of the ARM VMs will fail the test
> with out of order records in the data fork.
> 
> xfs/804 races fsstress with online scrub (aka scan but do not change
> anything), so I think this might be a bug in the core xfs code.  This
> also only seems to trigger if one runs the test for more than ~6 minutes
> via TIME_FACTOR=13 or something.
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
> 
> I added a debugging patch to the kernel to check the data fork extents
> after taking the ILOCK, before dropping ILOCK, and before and after each
> bmapping operation.  So far I've narrowed it down to the delalloc code
> inserting a record in the wrong place in the iext tree:
.....
> 
> So.  Fix this by moving the dqattach_locked call up before we take the
> ILOCK, like all the other callers in that file.
> 
> Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
> v2: just do a regular dqattach, and tweak the commit message to make it
> clearer if it's dave or me talking

All looks good, thanks for doing the updates :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
