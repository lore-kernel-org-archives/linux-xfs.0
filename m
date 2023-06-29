Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D568EEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 22:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjF2WY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF2WYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 18:24:25 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7412D62
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:24:24 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3a1a47b33d8so874385b6e.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688077463; x=1690669463;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PDj3CzKRMeg3vZ1wRCxcylP6JBBOUUVPUQDqUobfeek=;
        b=3Eo+RWMgww64xOZzYF8pGozQfvNvQgkYLvLB6+EB4/nv/zeKwhFHqyeag4fbcpl8qf
         dyNdyWfkDT8WvJDRaouNMUymj+pjwrv+6DfpS0uHD7TzEpsUminyI5tqZH8JH0DSuziK
         fKixJ09M/NqjsmzH50le+u91G5r0Q42EdWAiA7wP3hazbg/Yn5HjPWSEoO5cttvxoWNn
         NZysoR4xu7HUfk21zb5K3rLlgjNNATpnWRBtUmn8ujevvNrN4++aoMIotEu5/Oqm2prW
         5ame5ZhJC+5LNbyBdn7LkE9GwHQRby6ieGYZgenFOrBL1KDUW/wNXAZjvzlRJqeeYn5A
         V+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688077463; x=1690669463;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDj3CzKRMeg3vZ1wRCxcylP6JBBOUUVPUQDqUobfeek=;
        b=Hu9NsYUydr3t2Jcm/1Z7qq38bgLo6XAyz/8SUKNT3g7HRcrro6Gnx1NlIHOJ37uVo2
         IXNIs0C0T9A7CZn2DedtdALR+noUiiW+UGtoR3mLOFfKmyDNUoZI/a2Dg2K/L/uPbp2C
         9uay9AlSdq4ySh3hTu2TFs3CedAibDiwUIGZuVuNdfkbrvwYEusG/MuVuDqAt6+o4jKU
         LHGyN92Fv2DPPbCxMvAyC0ddHMFCY/OUnnLJ/lbG6s7Tti4LdI6ZBSRxRsTSSdWSeRXX
         Zqp6CviLxJPs7VWhfLryvaSKgL5yyJPv0q8WtaLa2vUVON3YLrEixsaNtmoZjefwcg1u
         nqiQ==
X-Gm-Message-State: AC+VfDxV6B8claASgz6JIK+sdIqIOMzNO487UZd/5MKHFcVqF7pTlgUC
        3DvxyDrf8SWascKMyYYsl5awmQ==
X-Google-Smtp-Source: ACHHUZ72gjXJqumK+YcdkZ8jmmxTxcw6t8IKUzz6Qbs9S6yBGIsFe6bUB1fgvM+tVVr+/p+zdesNMg==
X-Received: by 2002:a05:6808:1413:b0:3a1:dbf5:fdbd with SMTP id w19-20020a056808141300b003a1dbf5fdbdmr891974oiv.27.1688077463349;
        Thu, 29 Jun 2023 15:24:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id c4-20020aa781c4000000b00653fe2d527esm8814566pfn.32.2023.06.29.15.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 15:24:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qF03n-000C2c-2s;
        Fri, 30 Jun 2023 08:24:19 +1000
Date:   Fri, 30 Jun 2023 08:24:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     yangerkun <yangerkun@huaweicloud.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, yangerkun@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH] xfs: fix deadlock when set label online
Message-ID: <ZJ4EkyxoxDYmf8rv@dread.disaster.area>
References: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
 <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
 <c4f2edcd-efe2-2a96-316b-40f7ac95e6ce@huaweicloud.com>
 <ZJy9/9uqtTyS2fIA@dread.disaster.area>
 <4d6ee3b3-6d4b-ddb6-eb8e-e04a7e0c1ab0@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d6ee3b3-6d4b-ddb6-eb8e-e04a7e0c1ab0@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 07:55:10PM +0800, yangerkun wrote:
> 在 2023/6/29 7:10, Dave Chinner 写道:
> > On Tue, Jun 27, 2023 at 04:42:41PM +0800, yangerkun wrote:
> > > 在 2023/6/27 5:45, Dave Chinner 写道:
> > > > On Mon, Jun 26, 2023 at 09:15:42PM +0800, yangerkun wrote:
> > > > > From: yangerkun <yangerkun@huawei.com>
> > > > > 
> > > > > Combine use of xfs_trans_hold and xfs_trans_set_sync in xfs_sync_sb_buf
> > > > > can trigger a deadlock once shutdown happened concurrently. xlog_ioend_work
> > > > > will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
> > > > > xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to unlock
> > > > > sb until been wakeup by xlog_ioend_work.
> > > > > 
> > > > > xfs_sync_sb_buf
> > > > >     xfs_trans_getsb // lock sb buf
> > > > >     xfs_trans_bhold // sb buf keep lock until success commit
> > > > >     xfs_trans_commit
> > > > >     ...
> > > > >       xfs_log_force_seq
> > > > >         xlog_force_lsn
> > > > >           xlog_wait_on_iclog
> > > > >             xlog_wait(&iclog->ic_force_wait... // shutdown happened
> > > > >     xfs_buf_relse // unlock sb buf
> > > > > 
> > > > > xlog_ioend_work
> > > > >     xlog_force_shutdown
> > > > >       xlog_state_shutdown_callbacks
> > > > >         xlog_cil_process_committed
> > > > >           xlog_cil_committed
> > > > >           ...
> > > > >           xfs_buf_item_unpin
> > > > >             xfs_buf_lock // deadlock
> > > > >         wake_up_all(&iclog->ic_force_wait)
> > > > > 
> > > > > xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will see the
> > > > > change for sb immediately. We can simply call xfs_ail_push_all_sync to
> > > > > do this and sametime fix the deadlock.
> > > > 
> > > > Why is this deadlock specific to the superblock buffer?
> > > 
> > > Hi Dave,
> > > 
> > > Thanks a lot for your revirew! We find this problem when do some code
> > > reading(which can help us to fix another growfs bug). And then reproduce it
> > > easily when we set label online frequently with IO error inject at the
> > > sametime.
> > 
> > Right, I know how it can be triggered; that's not actually my
> > concern...
> > 
> > > > Can't any buffer that is held locked over a synchronous transaction
> > > > commit deadlock during a shutdown like this?
> > > 
> > > After check all place use xfs_buf_bhold, it seems xfs_sync_sb_buf is the
> > > only convict that combine use xfs_trans_hold and xfs_trans_set_sync(I'm not
> > > familiar with xfs yet, so I may have some problems with my code check)...
> > 
> > Yes, I can also see that. But my concern is that this change only
> > addresses the symptom, but leaves the underlying deadlock unsolved.
> > 
> > Indeed, this isn't xfs_trans_commit() I'm worried about here; it's
> > the call to xfs_log_force(mp, XFS_LOG_SYNC) or
> > xfs_log_force_seq(XFS_LOG_SYNC) with a buffer held locked that I'm
> > worried about.
> > 
> > i.e. We have a buffer in the CIL (from a previous transaction) that
> > we currently hold locked while we call xfs_log_force(XFS_LOG_SYNC).
> > If a shutdown occurs while we are waiting for journal IO completion
> > to occur, then xlog_ioend_work() will attempt to lock the buffer and
> > deadlock, right?
> > 
> > e.g. I'm thinking of things like busy extent flushing (hold AGF +
> > AGFL + AG btree blocks locked when we call xfs_log_force()) could
> > also be vulnerable to the same deadlock...
> 
> You mean something like xfs_allocbt_alloc_block(call xfs_log_force to
> flush busy extent which keep agf locked sametime)?
> 
> We call xfs_log_force(mp, XFS_LOG_SYNC) after lock agf and before
> xfs_trans_commit. It seems ok since xfs_buf_item_unpin will not call
> xfs_buf_lock because bli_refcount still keep active(once we hold locked
> agf, the bli_refcount will inc in _xfs_trans_bjoin, and keep it until
> xfs_trans_commit success(clean agf item) or .iop_unpin(dirty agf item,
> call from xlog_ioend_work) which can be called after xfs_trans_commit
> too)...

Again, I gave an example of the class of issue I'm worried about.
Again, you chased the one example given through, but haven't
mentioned a thing about all the other code paths that lead to
xfs_log_force(SYNC) that might hold buffers locked that I didn't
mention.

I don't want to have to ask every person who proposes a fix about
every possible code path the bug may manifest in -one at a time-.  I
use examples to point you in the right direction for further
analysis of the rest of the code base, not because that's the only
thing I want checked. Please use your initiative to look at all the
callers of xfs_log_force(SYNC) and determine if they are all safe or
whether there are landmines lurked or even more bugs of a similar
sort.

When we learn about a new issue, this is the sort of audit work that
is necessary to determine the scope of the issue. We need to perform
such audits because they direct the scope of the fix necessary. We
are not interested in slapping a band-aid fix over the symptom that
was reported - that only leads to more band-aid fixes as the same
issue appears in other places.

Now we know there is a lock ordering problem in this code, so before
we attempt to fix it we need to know how widespread it is, what the
impact is, how different code paths avoid it, etc. That requires a
code audit to determine, and that requires looking at all the paths
into xfs_log_force(XFS_LOG_SYNC) to determine if they are safe or
not and documenting that.

Yes, it's more work *right now* than slapping a quick band-aid fix
over it, but it's much less work in the long run for us and we don't
have to keep playing whack-a-mole because we fixed it the right way
the first time.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
