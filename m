Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE97C001DC
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 01:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjGXBFz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Jul 2023 21:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGXBFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2023 21:05:54 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8957B186
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 18:05:53 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-583b3aa4f41so18699247b3.2
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 18:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690160753; x=1690765553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vjZ/Jsp6PMrdLM+7kXf9xZA3z9U12JKy9mZNOcYumIk=;
        b=NJRzjKKcLPZvx/msSpx7innoWnfHL9i4nNMyEwTnMGoNvrb3WmrZhgAwGWgekixjuc
         lEbYjyj/kOW9MAVoHqd6XeXTN4twuVLZwiQQbD1UcYs8Kp+vo0V/qRBr5xMFQEdnhvfG
         4gLJUt9G9vY5sgLdqpWO2NeVMwhLoI+X9PhR6RL1JynD/s47Mmxw5eyrq7cg2ilzSIpG
         TxosXyEch8Cu5tOt1l/KFM79cLItlrEAmuf+m8k9vLwKan1/ysvEHDzKMAXiP0DlJslS
         ECqHdOiLL7HhVWgWIq0mrKwVqyyt1OSL2IGnrwmpifyrmgELb+nH8R8oE4QUlVKEeJvd
         y+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690160753; x=1690765553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjZ/Jsp6PMrdLM+7kXf9xZA3z9U12JKy9mZNOcYumIk=;
        b=i/ord5pt0ypfKuc5Ry1tnNmd18Rncvldl1YjeIa76MDPgWi6dgzuSKVED9oMR0Ilb3
         Me9gES8TT2rd+jD51LAYAkgBJrI0SsVj79Sm2E43kZSGkR3N2tnJOrp10auh2wzAawWr
         S04lx41VOcBZvAyWJzkMiFEPVQLesakiS88J6PnnO9UBYyIN+7LnPAZNPSt0jAsuBmt7
         2awNAOuifGkED3gtdzomINFnZkAndsbNw9zXz0Vc2IdAEzDs+xVTfMhauCjS4O1BN0Ym
         a/tUnACeVgWHh4GHUT55DDYOYVvMeQSaZ9/Uq5iFBWMuADgxYIfJqLUwRNksvR3Mi2ir
         ZkZA==
X-Gm-Message-State: ABy/qLaKuV7xIZUDIK03DGoE6TLVN5phPq6DbvwAqtGjUMnvmhHbDPV+
        w2zq2mNsGQiWf9vlLMNIVqGTh/ahoMD13xE+nkY=
X-Google-Smtp-Source: APBJJlGhCrOiZACfPAruZSx2ySFYnOZN0yle0lM7wxCLj3eS9uk3EZQyQcWdf/+rwmD/0feecoYpzQ==
X-Received: by 2002:a81:4fd6:0:b0:583:5a34:cfd with SMTP id d205-20020a814fd6000000b005835a340cfdmr5554982ywb.2.1690160752776;
        Sun, 23 Jul 2023 18:05:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id j8-20020a62e908000000b00682669dc19bsm6402106pfh.201.2023.07.23.18.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jul 2023 18:05:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qNk1E-009lDM-1a;
        Mon, 24 Jul 2023 11:05:48 +1000
Date:   Mon, 24 Jul 2023 11:05:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huaweicloud.com>
Cc:     Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: make sure done item committed before cancel
 intents
Message-ID: <ZL3ObF23wET/rT7x@dread.disaster.area>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-4-leo.lilong@huawei.com>
 <ZLeFpQWSUVmYNJXJ@dread.disaster.area>
 <20230722011909.GA4061995@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722011909.GA4061995@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 22, 2023 at 09:19:09AM +0800, Long Li wrote:
> On Wed, Jul 19, 2023 at 04:41:41PM +1000, Dave Chinner wrote:
> > On Sat, Jul 15, 2023 at 02:36:47PM +0800, Long Li wrote:
> > > KASAN report a uaf when recover intents fails:
> > ....
> > > 
> > > If process intents fails, intent items left in AIL will be delete
> > > from AIL and freed in error handling, even intent items that have been
> > > recovered and created done items. After this, uaf will be triggered when
> > > done item commited, because at this point the released intent item will
> > > be accessed.
> > > 
> > > xlog_recover_finish                     xlog_cil_push_work
> > > ----------------------------            ---------------------------
> > > xlog_recover_process_intents
> > >   xfs_cui_item_recover//cui_refcount == 1
> > >     xfs_trans_get_cud
> > >     xfs_trans_commit
> > >       <add cud item to cil>
> > >   xfs_cui_item_recover
> > >     <error occurred and return>
> > > xlog_recover_cancel_intents
> > >   xfs_cui_release     //cui_refcount == 0
> > >     xfs_cui_item_free //free cui
> > >   <release other intent items>
> > > xlog_force_shutdown   //shutdown
> > >                                <...>
> > >                                         <push items in cil>
> > >                                         xlog_cil_committed
> > >                                           xfs_cud_item_release
> > >                                             xfs_cui_release // UAF
> > 
> > Huh. The log stores items in the AIL without holding a reference to
> > them, then on shutdown takes the intent done reference away because
> > it assumes the intent has not been processed as it is still in the
> > AIL.
> > 
> > Ok, that's broken.
> > 
> > > Fix it by move log force forward to make sure done items committed before
> > > cancel intents.
> > 
> > That doesn't fix the fact we have a reference counted object that is
> > being accessed by code that doesn't actually own a reference to the
> > object.  Intent log items are created with a reference count of 2 -
> > one for the creator, and one for the intent done object.
> > 
> > Look at xlog_recover_cui_commit_pass2():
> > 
> >         /*
> >          * Insert the intent into the AIL directly and drop one reference so
> >          * that finishing or canceling the work will drop the other.
> >          */
> >         xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
> >         xfs_cui_release(cuip);
> >         return 0;
> > }
> > 
> > Log recovery explicitly drops the creator reference after it is
> > inserted into the AIL, but it then processes the log item as if it
> > also owns the intent-done reference. The moment we call
> > ->iop_recover(), the intent-done reference should be owned by the
> > log item.
> 
> Hi, Dave
> 
> Thanks for the reply. Yes, your analysis seems reasonable, it helped me a
> lot to understand the intent lifecycle.
> 
> > 
> > The recovery of the BUI, RUI and EFI all do the same thing. I
> > suspect that these references should actually be held by log
> > recovery until it is done processing the item, at which point it
> > should be removed from the AIL by xlog_recover_process_intents().
> 
> Why do we need to remove the intent from the AIL at this point,

Because we've processed the recovery of it - it is either completely
done or we have a new intent in the CIL ready to continue operation.
Either way, the next write to the journal will remove the item from
the AIL when it completes.

Intents don't need to be in the AIL, though - we can cancel them
in memory (see the intent whiteout code) and so when we process the
done item from journal IO completion the last reference goes away
and they won't be in the AIL at this point in time.

IOWs, the intent freeing code doesn't care if the intent is in the
AIL or not, it does the right thing either way.

Hence if we remove the intent from the list of intents that need to
be recovered after we have done the initial recovery, we acheive two
things:

1. the tail of the log can be moved forward with the commit of the
done intent or new intent to continue the operation, and

2. We avoid the problem of trying to determine how many reference
counts we need to drop from intent recovery cancelling because we
never come across intents we've actually attempted recovery on.

> shouldn't
> it be removed from the AIL when the done intent is committed? Or is there
> any way to ensure that the intents are removed from the AIL when they are
> processed.

THe reference counting ensures the right thing is done when the last
reference goes away. If it is in the AIL, it will get removed, if it
is not in the AIL, then AIL removal is a no-op and nothign bad
happens.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
