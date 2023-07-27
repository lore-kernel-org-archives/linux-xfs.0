Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21E5C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 01:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjG0BZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 21:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjG0BZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 21:25:25 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D343A3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 18:25:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b9c5e07c1bso3429655ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 18:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690421121; x=1691025921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=onNurV5EO8twDmAxGK4PmbUvVROvPsPpZlviYNExuY4=;
        b=kYPSVW+P9GU4AkImSUlL17piABS1qTgqFIiKuzY7miMGZnCHBxwEDqusmbMvWmSjv2
         YGnxXpBcYufzfpHduL8LahGKQCiWe64k1VSkT5rhXuQHzfFivReR1ouw79l/VQt+Tubt
         F8ADNQj9k2mxMvV841nPQt2QZxJExTARXV24bSlPrGqInTy30N5n2R5r611PDBE7FIQL
         PeAp4INuTc5EfYC7BG3i4TF6dp9aa/05gQlSopHxpXbcvE2Aa71erVQwIUY8Q+gTTf4L
         tRTuZQBbM1PdB7VDRgbzns4Oaqdx79EjG4gLWTsxiKDmUlXRABfUSLZ0t1+rDIZoGXc7
         QAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690421121; x=1691025921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onNurV5EO8twDmAxGK4PmbUvVROvPsPpZlviYNExuY4=;
        b=UB07L/Av1pIhJawiZJkJi2EBpkrjK/0hIVPBlNXS1ENGy9P1gSTfPz2rfu/vRW7M4T
         YpfUqv9DEvm8/PQ+bgcDheTNwD8JkQVPktsSbnx7EWdK1PszCCwydTm6weuzrSfNFlEG
         XO1iqdcStc+kL6yV0J+WXHw8BeErplsx88OlbpMNfUiMVVajPVL+tuSc6EZaZlmRId7f
         r+cGTdtHZGoGIAVoOuNITPDC5HqIwqhGtffkZ/UicRUsff00zvHY5u0gJ6tPRfIGqnWG
         vOsVEdNtXZrwKOifeiXJ41R1/ssjhGNAVa443I3FNyyckVNYUI4BpCBpU2k+ccbSn1NS
         ZwfQ==
X-Gm-Message-State: ABy/qLb5L+HaGfJAz8JmDwrRfBgRUdGvSZ6aGORM54quU9whRjaDStld
        cqzCJz/dYPRBUrWpabpX1qh8hJmwOEXy71ZuhGo=
X-Google-Smtp-Source: APBJJlEzjn6c8Ezd/XOlnj0/Frz5pml71no2vjq2a39x5xn9tOJEyQsY7mJkbUYfuz9+oeUiHbhdlA==
X-Received: by 2002:a17:903:2288:b0:1bb:c69b:6f6b with SMTP id b8-20020a170903228800b001bbc69b6f6bmr4522837plh.6.1690421121428;
        Wed, 26 Jul 2023 18:25:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id 29-20020a17090a01dd00b0025bcdada95asm197305pjd.38.2023.07.26.18.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 18:25:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOpkk-00Axv3-1n;
        Thu, 27 Jul 2023 11:25:18 +1000
Date:   Thu, 27 Jul 2023 11:25:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huaweicloud.com>
Cc:     Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
Subject: Re: [PATCH v2] xfs: fix a UAF when inode item push
Message-ID: <ZMHHfqSnB/CaxKwR@dread.disaster.area>
References: <20230722025721.312909-1-leo.lilong@huawei.com>
 <ZMCgmBDM6vjVuyLV@dread.disaster.area>
 <20230726073219.GA1050117@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726073219.GA1050117@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 03:32:19PM +0800, Long Li wrote:
> On Wed, Jul 26, 2023 at 02:27:04PM +1000, Dave Chinner wrote:
> > On Sat, Jul 22, 2023 at 10:57:21AM +0800, Long Li wrote:
> > > Fix the race condition by add XFS_ILOCK_SHARED lock for inode in
> > > xfs_inode_item_push(). The XFS_ILOCK_EXCL lock is held when the inode is
> > > reclaimed, so this prevents the uaf from occurring.
> > 
> > Having reclaim come in and free the inode after we've already
> > aborted and removed from the buffer isn't a problem. The inode
> > flushing code is designed to handle that safely.
> > 
> > The problem is that xfs_inode_item_push() tries to use the inode
> > item after the failure has occurred and we've already aborted the
> > inode item and finished it. i.e. the problem is this line:
> > 
> > 	spin_lock(&lip->li_ailp->ail_lock);
> > 
> > because it is using the log item that has been freed to get the
> > ailp. We can safely store the alip at the start of the function
> > whilst we still hold the ail_lock.
> > 
> 
> Hi Dave,
> 
> That's how I solved it in v1[1], but I found that it doesn't completely
> solve the problem, because it's still possible to reference the freed
> lip in xfsaild_push(). Unless we don't refer to lip in tracepoint after
> xfsaild_push_item().
> 
> xfsaild_push()
>   xfsaild_push_item()
>     lip->li_ops->iop_push()
>       xfs_inode_item_push(lip)
> 	xfs_iflush_cluster(bp)
> 				......
> 					xfs_reclaim_inode(ip)
> 					  ......
> 					  __xfs_inode_free(ip)
> 					    call_rcu(ip, xfs_inode_free_callback)
> 				......		
> 			<rcu grace period expires>
> 			<rcu free callbacks run somewhere>
> 			  xfs_inode_free_callback(ip)
> 			    kmem_cache_free(ip->i_itemp)
> 				......
>   trace_xfs_ail_xxx(lip) //uaf

Then we need to fix that UAF, too!

Seriously: just because a reclaim race exposes more than one UAF
vector, it doesn't mean that the we need to completely change the
lock order and life-cycle/existence guarantees for that object. It
means we need to look at the wider situation and determine if there
are other vectors to those same UAF conditions.

Such as: what happens if other types of log items have the same sort
of "can be freed before returning" situation?

Really, all this means is that returning XFS_ITEM_LOCKED when we've
dropped the AIL lock in .iop_push() is not safe - there is no longer
any guarantee the item is still in the AIL or even whether it exists
on return to xfsaild_push(), so it's just not safe to reference
there at all.

Indeed, I note that xfs_qm_dquot_logitem_push() has exactly the same
potential UAF problem as xfs_inode_item_push() has. i.e. it also
drops the AIL lock to do a flush, which can abort the item and
remove it from the AIL on failure while the AIL lock is dropped,
then it grabs the AIL lock from the log item and returns
XFS_ITEM_LOCKED....

So, yeah, these failure cases need to return something different to
xfsaild_push() so it knows that it is unsafe to reference the log
item, even for tracing purposes. And, further,
xfs_qm_dquot_logitem_push() needs the same "grab ailp before
dropping the ail_lock" for when it is relocking the AIL....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
