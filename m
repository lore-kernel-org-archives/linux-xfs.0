Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41144C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 19:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiKQTH1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 14:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiKQTH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 14:07:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA197A352
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 11:07:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62985CE1EF7
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 19:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C449C433C1;
        Thu, 17 Nov 2022 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668712042;
        bh=Ufv2wCfDxxUv46enI2AQb4Bk8zT04PvWcSiu+Ra2MIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N7q/LMQ/JD8fZpP+kSXhHj7dVi2LsPTnYuSXfMr/2WaDtBGg8VmIc/1nrhLHSsF21
         4YEoxJ/x7Rp+4HcCNjqjKwlCAwTZIRvqpqHAL9KpS/zVSSJbXZ+2xSV0DhhLvHPDS0
         fN4SFT6lOci2qbC2wfPAM7tznj/TPjzUfNLuDq8256H4RvyGjyzYPc1NKLd0P9Nj8L
         zfH/uffi2J73621YukjDQI7lUqHRAXaDVzFGGi7yRvuYbISwLv3gZgraNUE96Kmhgi
         4vDcGaeVDPW+qUcPuB9kozrR0spjjLlHJI3Uc7RWy11RIAI9iH8/wXRcTCGc43s1Nt
         HotOnvncu6dEw==
Date:   Thu, 17 Nov 2022 11:07:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, houtao1@huawei.com, jack.qiu@huawei.com,
        fangwei1@huawei.com, yi.zhang@huawei.com, zhengbin13@huawei.com,
        leo.lilong@huawei.com, zengheng4@huawei.com
Subject: Re: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
Message-ID: <Y3aGas1bc7IMTS/h@magnolia>
References: <20221103113709.251669-1-guoxuenan@huawei.com>
 <Y2k5NTjTRdsDAuhN@magnolia>
 <1afe73bb-481c-01b3-8c61-3d208e359f40@huawei.com>
 <6ad3b4b0-f25b-1609-e79b-82204bc5577a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ad3b4b0-f25b-1609-e79b-82204bc5577a@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 10:13:46AM -0600, Eric Sandeen wrote:
> On 11/7/22 7:50 PM, Guo Xuenan wrote:
> > On 2022/11/8 0:58, Darrick J. Wong wrote:
> >> On Thu, Nov 03, 2022 at 07:37:09PM +0800, Guo Xuenan wrote:
> >>> xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
> >>> it is a fault injection tag, better not use it in the macro ASSERT.
> >>>
> >>> Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
> >>>> /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
> >>> It's confusing and strange.
> >> Please be more specific about how this is confusing or strange.
> > I meant in current code, the ASSERT will alway happen,when we
> > `echo 1 > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
> > xfs_btree_islastblock
> >   ->ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
> >     ->xfs_btree_check_{l/s}block
> >       ->XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_{S,L}BLOCK)
> > we can use error injection to trigger this ASSERT.
> 
> Hmmm...
> 
> > I think ASERRT macro and error injection are to find some effective problems,
> > not to create some kernel panic.
> 
> You can avoid a panic by turning XFS_ASSERT_FATAL off in Kconfig, or
> at runtime by setting fs.xfs.bug_on_assert to 0, but ...
> 
> > So, putting the error injection function in
> > ASSERT is a little strange.
> 
> Ok, so I think the argument is that in the default config, setting this error
> injection tag will immediately result in a system panic, which probably isn't
> what we want.  Is my understanding correct?
> 
> But in the bigger picture, isn't this:
> 
> ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
> 
> putting a disk corruption check into an ASSERT? That in itself seems a bit
> suspect.  However, the ASSERT was all introduced in:
> 
> commit 27d9ee577dccec94fb0fc1a14728de64db342f86
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Wed Nov 6 08:47:09 2019 -0800
> 
>     xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock
>     
>     Coverity points out that xfs_btree_islastblock doesn't check the return
>     value of xfs_btree_check_block.  Since the question "Does the cursor
>     point to the last block in this level?" only makes sense if the caller
>     previously performed a lookup or seek operation, the block should
>     already have been checked.
>     
>     Therefore, check the return value in an ASSERT and turn the whole thing
>     into a static inline predicate.
>     
>     Coverity-id: 114069
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> which seems to imply that we really should not get here with a corrupt block during
> normal operation.
> 
> Perhaps the error tag can get set after the block "should already have been checked"
> but before this test in the ASSERT?

What I want to know here is *how* do we get to the point of tripping
this assertion via debugknob?  Won't the lookup or seek operation have
already checked the block and failed with EFSCORRUPTED?  And shouldn't
that be enough to stop whatever code calls xfs_btree_islastblock?  If
not, how do we get there?

Seriously, I don't want to burn more time discussing where and how to
fail on debugging knobs when there are all these other **far more
serious** corruption and deadlock problems that people are trying to get
merged.

Tell me specifically how to make the system fail.  "It's confusing and
strange" is not good enough.

--D

> -Eric
> 
