Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31504C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 14:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01ED2613CA
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 14:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhD0ObJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 10:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236358AbhD0ObG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 10:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619533821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DszvQZBs5DfSo0ikgI6RDun8GSDkAEq7doRucCIMTRQ=;
        b=Pvu7NvvhayjJ0vBnAzz98rgKMFwJK9ZW2L2JCk3GWHnxurDAa+c2Nhv7hqwBSUBzx7j6na
        65QlYa8o9MjpUxztsYYPnUqmoiSooUyK24N0Rr00OtR711EIU1CKkULcb5exSlzdg5YAtJ
        CDoU//dZC/jmwDckGdOhBIY6YGVijVY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-x8WG2mj3MbWy3k3mhiE2FQ-1; Tue, 27 Apr 2021 10:30:19 -0400
X-MC-Unique: x8WG2mj3MbWy3k3mhiE2FQ-1
Received: by mail-pg1-f199.google.com with SMTP id q64-20020a632a430000b0290209af2eea25so13745550pgq.18
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 07:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DszvQZBs5DfSo0ikgI6RDun8GSDkAEq7doRucCIMTRQ=;
        b=pBgT8ouy0NMMg2Na1vlqFn41hZ4nCrt4KyhNAGCqwGG8zDV/Mw5UfrAHk7aE8tLwxw
         L3fst6xSqTVJoE9Fb8DLUm9+mEBmG0uiRKtWGy4Q2FlmGsQfug+R328g+u4AxO5mPxsL
         N2t+zfKy8x7HRp2ov/Wcj8rZkBsGXvx7jYRAqcGXh3ymy2Z0L2nTPJYs4IT3wXLVNaOi
         vMSBOz5WQNNLHf1fWjfZDbr1ldsW/InIa3YQaJiXkk6cRT0LvgFTeu5F1emT3zUPTOMY
         WOrL1ovIVyyZx+6OhzgitV67ZSGClTsNdQvtl0Adl0cHZJNB70LFLyukkjs8qe8EuJBn
         iGLw==
X-Gm-Message-State: AOAM531Z4RGCEp55LIeGWc1mnd24ArUsah/NkTxSjY0UiABcn5fz3tYY
        RJr/nhTWuARe6CzoWBexpDYAi3Y3wXTKRP1gSfEzKrcaDTaG5uOge58bspa4k8kXXXmSOVK8W1g
        JyijCseAjYbG1IHHkozpD
X-Received: by 2002:a17:902:ba8a:b029:ec:b04c:451d with SMTP id k10-20020a170902ba8ab02900ecb04c451dmr24662896pls.67.1619533818153;
        Tue, 27 Apr 2021 07:30:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySXmVl42qUuxN/y2GV2O3n6nqlFFEVJtrXSO55zJXgLO6OgJXSfqX1Tj6BGsc/V8neXJRrhw==
X-Received: by 2002:a17:902:ba8a:b029:ec:b04c:451d with SMTP id k10-20020a170902ba8ab02900ecb04c451dmr24662868pls.67.1619533817904;
        Tue, 27 Apr 2021 07:30:17 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3sm2737313pff.132.2021.04.27.07.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 07:30:17 -0700 (PDT)
Date:   Tue, 27 Apr 2021 22:30:07 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: update superblock counters correctly for
 !lazysbcount
Message-ID: <20210427143007.GC103178@xiangao.remote.csb>
References: <20210427011201.4175506-1-hsiangkao@redhat.com>
 <YIgHoSvI4oj9bPER@bfoster>
 <20210427131318.GA103178@xiangao.remote.csb>
 <YIge2/FRLy4Xjvcp@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YIge2/FRLy4Xjvcp@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 10:25:31AM -0400, Brian Foster wrote:
> On Tue, Apr 27, 2021 at 09:13:18PM +0800, Gao Xiang wrote:
> > On Tue, Apr 27, 2021 at 08:46:25AM -0400, Brian Foster wrote:
> > > On Tue, Apr 27, 2021 at 09:12:01AM +0800, Gao Xiang wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Keep the mount superblock counters up to date for !lazysbcount
> > > > filesystems so that when we log the superblock they do not need
> > > > updating in any way because they are already correct.
> > > > 
> > > > It's found by what Zorro reported:
> > > > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > > > 2. mount $dev $mnt
> > > > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > > > 4. umount $mnt
> > > > 5. xfs_repair -n $dev
> > > > and I've seen no problem with this patch.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > > Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > 
> > > Could you provide a bit more detail on the problem in the commit log?
> > > From the description and code change, it seems like there is some
> > > problem with doing the percpu aggregation in xfs_log_sb() on
> > > !lazysbcount filesystems. Therefore this patch reserves that behavior
> > > for lazysbcount, and instead enables per-transaction updates in the
> > > !lazysbcount specific cleanup path. Am I following that correctly?
> > 
> > This patch inherited from Dave's patch [1] (and I added reproduable
> > steps),
> > https://lore.kernel.org/r/20210422014446.GZ63242@dread.disaster.area
> > 
> > More details see my original patch v2:
> > https://lore.kernel.org/r/20210420110855.2961626-1-hsiangkao@redhat.com
> > 
> 
> Ok, thanks. So the bit about xfs_log_sb() is to avoid an incorrect
> overwrite of the in-core sb counters from the percpu counters on
> !lazysbcount. The xfs_trans_apply_sb_deltas() function already applies
> the transaction deltas to the on-disk superblock buffer, so the change
> to xfs_trans_unreserve_and_mod_sb() is basically to apply those same
> deltas to the in-core superblock so they are consistent in the
> !lazysbcount case... yes? If I'm following that correctly, this looks
> good to me:

Yeah, that's right :)

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

Thanks,
Gao Xiang

> 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Brian

