Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CEAEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 06:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjGSGlt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 02:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjGSGlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 02:41:46 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DC11FCB
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 23:41:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-668709767b1so4842227b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 23:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689748905; x=1692340905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v1Ovzdrhi3KUQedEyqna8+mWXEG14dFFByEVr3jg93k=;
        b=x8bmCtiblsBKzBqD3QZnHrW88IYhlOqdWB0Y6EIXdiM1moESAWSGyIiZZ8hKCu065z
         cMrVlSCoD9NpOc9XSBiJ10HxAE9z9mmmVh1E1qVjwScfTNTrP2wghMHxHf1+4Yhm0tMy
         g9I+o+JkTNZ7i8TUTUraiOhzyvVmEFar8E/loX08DTbE/AIqJ8Lqyb/Rff2S4kEXo6Vk
         37yaAL9Pyq+xKjXDlcTmru96G5cWTzwtcjZXRgHjSarQWRF4pPBiDi9LYTSluf8FSxoK
         Wupw3NugeF+dI2n6DQ8nKp3dJQhAaVWNJWrCt2porDzSqN5ytoekQGaVCtcgHMc5uC43
         7P2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689748905; x=1692340905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1Ovzdrhi3KUQedEyqna8+mWXEG14dFFByEVr3jg93k=;
        b=L2IrCSt59XgOhc+dT1c2fSl3dxJ1ziqzfeokAF8MnLj9L0Pq2SkVG7AJHZvtgatJlb
         oAYmP1Z646POl2nbidPZsoeKDJ+hbMmIuAvlBd436B7eCwOMJuMwq8wRq6PwuFIb4vWt
         6yxvxZdcO0sU9HxH0fpQK6VJORAp9s8IRa59CacHBlylsVg1RKSLH+YcEABLFs8HV351
         9XqXADtvgOs8CDnE0PxFRYEihr+9v+J+vIEWa+TWpdTI44srOxLEchowdtbRmO/UzTjk
         H+9Gp7HvYe6/OhR7q6/A5P8bD1/ShMvSE8Pkg08sAOiTc0RlSbGELdA8OTTDxri1dO+e
         NPxA==
X-Gm-Message-State: ABy/qLaAdjOI8G6sNuoipMMmD9qK+RIgm7GHvJ414B0335gy/EAu4KDk
        fj6OukBmb/G5UVYvl/vhnjts1w==
X-Google-Smtp-Source: APBJJlEdv5MWAUSNJ36ppaXAjKJEkJ1SdeKvcbiiLiqAdAnocGcZsV94OkSO8nvrtSpcBJQA8ckbKw==
X-Received: by 2002:a05:6a00:1a87:b0:675:8f71:28f1 with SMTP id e7-20020a056a001a8700b006758f7128f1mr4470220pfv.30.1689748904889;
        Tue, 18 Jul 2023 23:41:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id 6-20020aa79106000000b0062cf75a9e6bsm2521622pfh.131.2023.07.18.23.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 23:41:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qM0sX-007rmy-2F;
        Wed, 19 Jul 2023 16:41:41 +1000
Date:   Wed, 19 Jul 2023 16:41:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: make sure done item committed before cancel
 intents
Message-ID: <ZLeFpQWSUVmYNJXJ@dread.disaster.area>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-4-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230715063647.2094989-4-leo.lilong@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 15, 2023 at 02:36:47PM +0800, Long Li wrote:
> KASAN report a uaf when recover intents fails:
....
> 
> If process intents fails, intent items left in AIL will be delete
> from AIL and freed in error handling, even intent items that have been
> recovered and created done items. After this, uaf will be triggered when
> done item commited, because at this point the released intent item will
> be accessed.
> 
> xlog_recover_finish                     xlog_cil_push_work
> ----------------------------            ---------------------------
> xlog_recover_process_intents
>   xfs_cui_item_recover//cui_refcount == 1
>     xfs_trans_get_cud
>     xfs_trans_commit
>       <add cud item to cil>
>   xfs_cui_item_recover
>     <error occurred and return>
> xlog_recover_cancel_intents
>   xfs_cui_release     //cui_refcount == 0
>     xfs_cui_item_free //free cui
>   <release other intent items>
> xlog_force_shutdown   //shutdown
>                                <...>
>                                         <push items in cil>
>                                         xlog_cil_committed
>                                           xfs_cud_item_release
>                                             xfs_cui_release // UAF

Huh. The log stores items in the AIL without holding a reference to
them, then on shutdown takes the intent done reference away because
it assumes the intent has not been processed as it is still in the
AIL.

Ok, that's broken.

> Fix it by move log force forward to make sure done items committed before
> cancel intents.

That doesn't fix the fact we have a reference counted object that is
being accessed by code that doesn't actually own a reference to the
object.  Intent log items are created with a reference count of 2 -
one for the creator, and one for the intent done object.

Look at xlog_recover_cui_commit_pass2():

        /*
         * Insert the intent into the AIL directly and drop one reference so
         * that finishing or canceling the work will drop the other.
         */
        xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
        xfs_cui_release(cuip);
        return 0;
}

Log recovery explicitly drops the creator reference after it is
inserted into the AIL, but it then processes the log item as if it
also owns the intent-done reference. The moment we call
->iop_recover(), the intent-done reference should be owned by the
log item.

The recovery of the BUI, RUI and EFI all do the same thing. I
suspect that these references should actually be held by log
recovery until it is done processing the item, at which point it
should be removed from the AIL by xlog_recover_process_intents().

The code in ->iop_recovery should assume that it passes the
reference to the done intent, but if that code fails before creating
the done-intent then it needs to release the intent reference
itself.

That way when we go to cancel the intent, the only intents we find
in the AIL are the ones we know have not been processed yet and
hence we can safely drop both the creator and the intent done
reference from xlog_recover_cancel_intents().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
