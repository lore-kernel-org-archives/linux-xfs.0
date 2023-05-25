Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCABC77B7A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 00:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjEYAry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 20:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjEYArx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 20:47:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F48C5
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 17:47:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d24136663so1215219b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 17:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684975671; x=1687567671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oalY5wsiD6j6xDKMDg+wIeyTwmG8p/dUTTcwfE15L7c=;
        b=rvDjOd8Nmj1XCsNVtxT1X1fn4d91zK61UtIUn4QTz0S1HUs5YjezpC8Hrgd2qXz5Qc
         Z6jyLCRRzCBB5d+QKTWOy0ozrRf7Xqs+aRyQKkJlbbQIUaSm5tjgzM20m6qLEQtC1QlM
         XYyNAd4Y0HK4DQeNGS25fu+Z+1GluTZ9CTO8jmaJYJvMv7gSZ55pqzJuyXl8qpPtWuww
         HWbu3O9IsMttGfQ+Vd9B/WwZr1T6sBc6wyBkhUDfBhyVpLvGwPttp0zg9ztjMsjV1k4d
         /okZggtclO1wRvZHFIZufDgDRa+7WAVosB2fFHVGllgM1Dpd5bRTrhqNukYZCpbhNA7d
         F/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684975671; x=1687567671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oalY5wsiD6j6xDKMDg+wIeyTwmG8p/dUTTcwfE15L7c=;
        b=lV6qu9UhPjbQkOi40LiuTQPTDRrkF58b303GwOdlHjYLMnCeyVGP1YeNU0vpIq7QGD
         4hs8LHAeFTU7/MzuCinbECCab2j6lDfI+8le34ty5tZ7vflsCDSfDulT4H2+ujsFYCRf
         aC77WkazNXiUBAbSURbqwPvlwqvPxYpt9ZyM/okXeH5kaJ3akS1wbGDSNMJRWEUpnzEj
         rlrfpLUEcL3rt19C6XM3GpDWezrZDDPEK9L0r/ezFK62FWemGn2jeLQbU1UdZaE55x7+
         wTj3WeI4XOoafbMiYtyR0FWfgT8gkE0kvGI6JaTEu8LyovpoXxNUTcokwRL5SraeCDZj
         cawg==
X-Gm-Message-State: AC+VfDyIXDJ764F1/HXbf8XihDMIC+Uai/WymDCS8MOJjt0OcEustDDs
        tFAG8Ac/Z+AYUegq3YDFpKzXEg==
X-Google-Smtp-Source: ACHHUZ6i0TxmDicmrjCcAmPebhCk0uDfS9CLw7EI04L4RC8CfOgpcYi7H14+kq5xKleCnscR2LQcOA==
X-Received: by 2002:a05:6a20:8f05:b0:10c:49e:6c67 with SMTP id b5-20020a056a208f0500b0010c049e6c67mr11603333pzk.33.1684975671386;
        Wed, 24 May 2023 17:47:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id u15-20020a62ed0f000000b00634b91326a9sm40721pfh.143.2023.05.24.17.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 17:47:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1z8t-003X6p-2F;
        Thu, 25 May 2023 10:47:47 +1000
Date:   Thu, 25 May 2023 10:47:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH] xfs: xfs_trans_cancel() path must check for log shutdown
Message-ID: <ZG6wM/VjZb7wIOPC@dread.disaster.area>
References: <20230524121121.GA4130562@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524121121.GA4130562@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 24, 2023 at 08:11:21PM +0800, Long Li wrote:
> The following error occurred when do IO fault injection test:
> 
> XFS: Assertion failed: xlog_is_shutdown(lip->li_log), file: fs/xfs/xfs_inode_item.c, line: 748

This line of code does not match to any assert in the current
upstream code base. 

I'm assuming that the assert is this one:

 735                 /*
 736                  * dgc: Not sure how this happens, but it happens very
 737                  * occassionaly via generic/388.  xfs_iflush_abort() also
 738                  * silently handles this same "under writeback but not in AIL at
 739                  * shutdown" condition via xfs_trans_ail_delete().
 740                  */
 741                 if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 742  >>>>>>>                ASSERT(xlog_is_shutdown(lip->li_log));
 743                         continue;
 744                 }

Is that correct? I am going to assume that it is from this point
onwards.

Also, please include the full stack trace with the assert - the assert by
itself does not give us any context about where the failure
occurred, and the above code path can be run from several different
contexts, especially when a shutdown is in progress.

> In commit 3c4cb76bce43 (xfs: xfs_trans_commit() path must check for log
> shutdown) fix a problem that dirty transaction was canceled before log
> shutdown, because of the log is still running, it result dirty and
> unlogged inode item that isn't in the AIL in memory that can be flushed
> to disk via writeback clustering.

Yes, but this was a race checking shutdown state before inserting the
dirty item into the CIL, moving it from filesystem level context
to log level context. i.e. it caused the object to be handled as
valid instead of being aborted.

> xfs_trans_cancel() has the same problem, if a shut down races with
> xfs_trans_cancel() and we have shut down the filesystem but not the log,
> we will still cancel the transaction before log shutdown. So
> xfs_trans_cancel() needs to check log state for shutdown, not mount.

Yet this is cancelling a transaction that has dirty objects that
will be aborted. It is not the same context as the race fixed in
3c4cb76bce43, especially as the log item is marked as aborted as
part of the transaction cancel. As this is operating at the
filesytsem level, checking for filesystem level shutdown before
issuing a filesystem level shutdown is appropriate - we're about to
release items, not hand them off to the log.

Transaction cancel this ends up in xfs_trans_free_items(abort =
true) which sets XFS_LI_ABORTED then releases the log items.  This
then calls xfs_inode_item_release() for inodes, which does nothing
special with XFS_LI_ABORTED inode items, nor does it check for log
shutdown.

I may be missing something obvious that hasn't been explained, but
from the information provided I can't see how the above assert is
related to not doing a log shutdown check in the transaction cancel
path. Nothing in the transaction cancel path removes the inode item
from the AIL, so it can't be responsible for the ASSERT firing...

However, looking at this abort path does point out that the code in
xfs_inode_item_release() is probably wrong - it probably should check
for XFS_LI_ABORTED and log shutdown and mark the inode as stale if
it is dirty and then remove it from the AIL. In comparison, the
buffer log item release method does these checks and removes the
buffer log item from the AIL on abort/log shutdown, so I suspect
that inodes log items should be doing something similar.

I also supsect that the AIL push (metadata writeback) should skip
over aborted log items, too.

But none of these things explain to me how the change is in any way
related to the assert I have assumed has fired. More information,
please.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
