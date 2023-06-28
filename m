Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3C3EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 23:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjF1XLB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 19:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjF1XLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 19:11:00 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F98B2102
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 16:10:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-55ae51a45deso50520a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 16:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687993859; x=1690585859;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2ajgLaNtLpHNgKQ/ESM2uNKJulQnHLDKPRdfkv7OCa0=;
        b=DTVNcOiCPakB8dpj13cAfm4+M7rp9qPCJNCDqKdRVZY16/kD9rkecu6zt3UMsGUaxz
         zm9rK/RCk/nMsIR6H0soc6rV7GMtf/5+STA5po9rZv88niubdtyK27Fg3bbjNsS0YPL2
         yGvqnyQNmkVGj7KhXVBdIrp73jyGQOhvVpYZHNX5cwjSLk99bB3xzn5Os8LJonvFKGt/
         n3+CIRduLZ7goaDl/W22rsBDoBne7FQhj8bRPxw38V5pmvRHxqW0LLMuGe3Ekfc1/h/0
         aqvQn6spQkx80ynGBgCah7jaHVoTnYS3LjfMf58o5702kKO6dOgQFU3K5cG249PON09S
         kmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687993859; x=1690585859;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ajgLaNtLpHNgKQ/ESM2uNKJulQnHLDKPRdfkv7OCa0=;
        b=F3TGnu+4Gg2ogeYSEnsasgVunzF945rbzFD0X37xTffrrILO/BsyfSvBYIgGpAVXIY
         0kWzVvd/cH9UlkrxZKxgolHp0nvU3Fpo7cyzAYRoJn9LL+80G2mJLAMQwN1HG29/dizn
         uLAJgcIVUpFevtJv+uo6hzJ5NGlflbI1G6mX460A2OYgL+n99S9gM9dlcVVDlqkX6ZBi
         FxVsVilAAQJLXMirl6Vx4rWAalmYy4oqG3xZfd2oAu0f/CDeDXEtdZqETp6Jbnfn9nxk
         CVuHaWfT+fQKUJ0jlKJy6ieWUGrdrGNY/V6yBl1s3NtOTBmrasBKf9eycPdGM6SY5szW
         RfLw==
X-Gm-Message-State: AC+VfDws167bDadS+0FgL59necyX5DDLhnbHuzdyiCWhkljJUbmaaiFg
        qmOk8Z9qfEB30PXvoiNBcwN0mg==
X-Google-Smtp-Source: ACHHUZ6PpZyMhNK/PkDmxfltwE1q+9YN9il8Q/2ODdzS49obwOubcEqp1eW9rrgg4MhjMXdd2fPGBQ==
X-Received: by 2002:a17:902:e5c3:b0:1b6:b024:b072 with SMTP id u3-20020a170902e5c300b001b6b024b072mr11038237plf.38.1687993859037;
        Wed, 28 Jun 2023 16:10:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902b94800b001b02df0ddbbsm8078976pls.275.2023.06.28.16.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 16:10:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEeJL-00HPDL-1X;
        Thu, 29 Jun 2023 09:10:55 +1000
Date:   Thu, 29 Jun 2023 09:10:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     yangerkun <yangerkun@huaweicloud.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, yangerkun@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH] xfs: fix deadlock when set label online
Message-ID: <ZJy9/9uqtTyS2fIA@dread.disaster.area>
References: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
 <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
 <c4f2edcd-efe2-2a96-316b-40f7ac95e6ce@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4f2edcd-efe2-2a96-316b-40f7ac95e6ce@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2023 at 04:42:41PM +0800, yangerkun wrote:
> 
> 
> 在 2023/6/27 5:45, Dave Chinner 写道:
> > On Mon, Jun 26, 2023 at 09:15:42PM +0800, yangerkun wrote:
> > > From: yangerkun <yangerkun@huawei.com>
> > > 
> > > Combine use of xfs_trans_hold and xfs_trans_set_sync in xfs_sync_sb_buf
> > > can trigger a deadlock once shutdown happened concurrently. xlog_ioend_work
> > > will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
> > > xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to unlock
> > > sb until been wakeup by xlog_ioend_work.
> > > 
> > > xfs_sync_sb_buf
> > >    xfs_trans_getsb // lock sb buf
> > >    xfs_trans_bhold // sb buf keep lock until success commit
> > >    xfs_trans_commit
> > >    ...
> > >      xfs_log_force_seq
> > >        xlog_force_lsn
> > >          xlog_wait_on_iclog
> > >            xlog_wait(&iclog->ic_force_wait... // shutdown happened
> > >    xfs_buf_relse // unlock sb buf
> > > 
> > > xlog_ioend_work
> > >    xlog_force_shutdown
> > >      xlog_state_shutdown_callbacks
> > >        xlog_cil_process_committed
> > >          xlog_cil_committed
> > >          ...
> > >          xfs_buf_item_unpin
> > >            xfs_buf_lock // deadlock
> > >        wake_up_all(&iclog->ic_force_wait)
> > > 
> > > xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will see the
> > > change for sb immediately. We can simply call xfs_ail_push_all_sync to
> > > do this and sametime fix the deadlock.
> > 
> > Why is this deadlock specific to the superblock buffer?
> 
> Hi Dave,
> 
> Thanks a lot for your revirew! We find this problem when do some code
> reading(which can help us to fix another growfs bug). And then reproduce it
> easily when we set label online frequently with IO error inject at the
> sametime.

Right, I know how it can be triggered; that's not actually my
concern...

> > Can't any buffer that is held locked over a synchronous transaction
> > commit deadlock during a shutdown like this?
> 
> After check all place use xfs_buf_bhold, it seems xfs_sync_sb_buf is the
> only convict that combine use xfs_trans_hold and xfs_trans_set_sync(I'm not
> familiar with xfs yet, so I may have some problems with my code check)...

Yes, I can also see that. But my concern is that this change only
addresses the symptom, but leaves the underlying deadlock unsolved.

Indeed, this isn't xfs_trans_commit() I'm worried about here; it's
the call to xfs_log_force(mp, XFS_LOG_SYNC) or
xfs_log_force_seq(XFS_LOG_SYNC) with a buffer held locked that I'm
worried about.

i.e. We have a buffer in the CIL (from a previous transaction) that
we currently hold locked while we call xfs_log_force(XFS_LOG_SYNC).
If a shutdown occurs while we are waiting for journal IO completion
to occur, then xlog_ioend_work() will attempt to lock the buffer and
deadlock, right?

e.g. I'm thinking of things like busy extent flushing (hold AGF +
AGFL + AG btree blocks locked when we call xfs_log_force()) could
also be vulnerable to the same deadlock...

If that's true, how do we avoid the shutdown from causing a deadlock
in these situations?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
