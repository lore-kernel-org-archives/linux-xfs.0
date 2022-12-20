Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B56C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiLTXXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiLTXXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8332710A4
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:16 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id fy4so14027161pjb.0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bQmS641ZcG9XGlSDCRNew6UvM+LbS2/OilZ9ZSSFq2M=;
        b=yUXnWLDjJGfXdALm2b8clzwaAcadWfRHGKCFGVQ4CB9QMLTbLZSD9Tk7BypzAjWUrK
         HallT6E8Y84tWyvV6ZMkwrxT3F+k6QgAU+t9M02dNiiHsDGAi2W28A+H7YYqbwQ9AScQ
         pBAjpwapVZ0lvhW/QzSdt2vO7WyM4K2wWussooUhlS765ho+bnLmDsCS7tXdLfKVFb8y
         XPkxmKZ2YDLH6QFdASJmhQNCbSWNeBihXIu7fr4OMsqUv2Si/I9jots5mRjFEf6KSnBm
         JGQV7sFDiJLiBbOTP7l2OLcO02ZhgPLjr8WvKW2AFrQ7lDjpTKtszf68hFn5sjYH+QM+
         /pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bQmS641ZcG9XGlSDCRNew6UvM+LbS2/OilZ9ZSSFq2M=;
        b=DZGS4+a395V/4Ku68i7KfTBHwyM461JIflu6FYVi9TPWcqXJlrMf5Hb9MfAaJDk2xx
         m70V9p7NsYXeHkz+Hx8cu4fF6hDt5Xsaa4IXU6g4zyyhac+J1pyP0VtwRndY8oayxQ5u
         DpXY32G61sR+TBJwIEMg0etfaDG+AJ+b6PabwWVkFAoJvkP8FsEtnfZuv4FgkR73LlC8
         bE43CPOuZt6Yw3WGoOT9bgWzMXR2wlfUsEx2riE2yAVgvqXQRaoI2+Ida0+B/yaOfMJ7
         YzZ3taRR8z1AXSptlo+2f3m4ltp0FpM6D2ttJaXBTZGd9xC6C9+gaB+/KlREJe/SJZLh
         /zow==
X-Gm-Message-State: ANoB5pldvtDan8rUYnqzVSOOoSnrc6lNkZI0S3RlAxVpX4xIh97X3xKX
        DmkYWRRVTlvVLM6SikRlI/4FrAq719r1sEI8
X-Google-Smtp-Source: AA0mqf5hKHtNJCZYlNXY44fUYAJQKJao1bpmqIprXnY4ioKJLu7YpZ+3yiShNzOL1RLTKHgas/hs8A==
X-Received: by 2002:a05:6a21:8cc2:b0:9d:efbe:52bf with SMTP id ta2-20020a056a218cc200b0009defbe52bfmr57417347pzb.47.1671578595950;
        Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id u31-20020a63235f000000b00488b8ad57bfsm6249051pgm.54.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00AsnR-3N
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec5n-09
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/9 v3] xfs: byte-based grant head reservation tracking
Date:   Wed, 21 Dec 2022 10:22:59 +1100
Message-Id: <20221220232308.3482960-1-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

One of the significant limitations of the log reservation code is
that it uses physical tracking of the reservation space to account
for both the space used in the journal as well as the reservations
held in memory by the CIL and activei running transactions. Because
this in-memory reservation tracking requires byte-level granularity,
this means that the "LSN" that the grant head stores it's location
in is split into 32 bits for the log cycle and 32 bits for the grant
head offset into the log.

Storing a byte count as the grant head offset into the log means
that we can only index 4GB of space with the grant head. This is one
of the primary limiting factors preventing us from increasing the
physical log size beyond 2GB. Hence to increase the physical log
size, we have to increase the space available for storing the grant
head.

Needing more physical space to store the grant head is an issue
because we use lockless atomic accounting for the grant head to
minimise the overhead of new incoming transaction reservations.
These have unbound concurrency, and hence any lock in the
reservation path will cause serious scalability issues. The lockless
accounting fast path was the solution to these scalability problems
that we had over a decade ago, and hence we know we cannot go back
to a lock based solution.

Therefore we are still largely limited to the storage space we can
perform atomic operations on. We already use 64 bit compare/exchange
operations, and there is not widespread hardware support for 128 bit
atomic compare/exchange operations so increasing the grant head LSN
to a structure > 64 bits in size is not really an option.

Hence we have to look for a different solution - one that doesn't
require us to increase the amount of storage space for the grant
head. This is where we need to recognise that the grant head is
actually tracking three things:

1. physical log space that is tracked by the AIL;
2. physical log space that the CIL will soon consume; and
3. potential log space that active transactions *may* consume.

One of the tricks that the grant heads play is that the don't need
to explicitly track the space consumed by the AIL (#1), because the
consumed log space is simply "grant head - log tail", and so it
doesn't not matter how the space that is consumed moves between the
three separate accounting groups. Reservation space is automatically
returned to the "available pool" by the AIL moving the log tail
forwards. Hence the grant head only needs to account for the
journal space that transactions consume as they complete, and never
have to be updated to account for metadata writeback emptying the
journal.

This all works because xlog_space_left() is a calculation of the
difference between two LSNs - the log tail and the grant head. When
the grant head wraps the log tail, we've run out of log space and
the journal reservations get throttled until the log tail is moved
forward to "unwrap" the grant head and make space available again.

But there's no reason why we have to track log space in this way
to determine that we've run out of reservation space - all we need
is for xlog_space_left() to be able to accurately calculate when
we've run out of space. So let's break this down.

Firstly, the AIL tracks all the items in the journal, and so at
any given time it should know exactly where the on-disk head and
tail of the journal are located. At the moment, we only know where
the tail is (xfs_ail_min_lsn()), and we update the log tail
(log->l_tail_lsn) whenever the AIL minimum LSN changes.

The AIL will see the maximum committed LSN, but it does not track
this. Instead, the log tracks this as log->l_last_sync_lsn and
updates this directly in iclog IO completion when a iclog has
callbacks attached. That is, log->l_last_sync_lsn is updated
whenever journal IO completion is going to insert the latest
committed log items into the AIL. If the AIL is empty, the log tail
is assigned the value stored in l_last_sync_lsn as the log tail
now points to the last written checkpoint in the journal.

The simplest way I can describe how we track the log space is
as follows:

   l_tail_lsn		l_last_sync_lsn		grant head lsn
	|-----------------------|+++++++++++++++++++++|
	|    physical space	|   in memory space   |
	| - - - - - - xlog_space_left() - - - - - - - |

It is simple for the AIL to track the maximum LSN that has been
inserted into the AIL. If we do this, we no longer need to track
log->l_last_sync_lsn in the journal itself and we can always get the
physical space tracked by the journal directly from the AIL. The AIL
functions can calculate the "log tail space" dynamically when either
the log tail or the max LSN seen changes, thereby removing all need
for the log itself to track this state. Hence we now have:

   l_tail_lsn		ail_max_lsn_seen	grant head lsn
	|-----------------------|+++++++++++++++++++++|
	|    log->l_tail_space	|   in memory space   |
	| - - - - - - xlog_space_left() - - - - - - - |

And we've solved the problem of efficiently calculating the amount
of physical space the log is consuming. All this leaves is now
calculating how much space we are consuming in memory.

Luckily for us, we've just added all the update hooks needed to do
this. From the above diagram, two things are obvious:

1. when the tail moves, only log->l_tail_space reduces
2. when the ail_max_lsn_seen increases, log->l_tail_space increases
   and "in memory space" reduces by the same amount.

IOWs, we now have a mechanism that can transfer the in-memory
reservation space directly to the on-disk tail space accounting. At
this point, we can change the grant head from tracking physical
location to tracking a simple byte count:

   l_tail_lsn		ail_max_lsn_seen	grant head bytes
	|-----------------------|+++++++++++++++++++++|
	|    log->l_tail_space	|     grant space     |
	| - - - - - - xlog_space_left() - - - - - - - |

and xlog_space_left() simply changes to:

space left = log->l_logsize - grant space - log->l_tail_space;

All of the complex grant head cracking, combining and
compare/exchange code gets replaced by simple atomic add/sub
operations, and the grant heads can now track a full 64 bit bytes
space. The fastpath reservation accounting is also much faster
because it is much simpler.

There's one little problem, though. The transaction reservation code
has to set the LSN target for the AIL to push to ensure that the log
tail keeps moving forward (xlog_grant_push_ail()), and the deferred
intent logging code also tries to keep abreast of the amount of
space available in the log via xlog_grant_push_threshold().

The AIL pushing problem is actually easy to solve - we don't need to
push the AIL from the transaction reservation code as the AIL
already tracks all the space used by the journal. All the
transaction reservation code does is try to keep 25% of the journal
physically free, and there's no reason why the AIL can't do that
itself.

Hence before we start changing any of the grant head accounting, we
remove all the AIL pushing hooks from the reservation code and let
the AIL determine the target it needs to push to itself. We also
allow the deferred intent logging code to determine if the AIL
should be tail pushing similar to how it currently checks if we are
running out of log space, so the intent relogging still works as it
should.

WIth these changes in place, there is no external code that is
dependent on the grant heads tracking physical space, and hence we
can then implement the change to pure in-memory reservation space
tracking in the grant heads.....

This all passes fstests for default and rmapbt enable configs.
Performance tests also show good improvements where the transaction
accounting is the bottleneck.

-Dave.

Version 3
- forward port onto current for-next dev branch.
- cleaned up static warnings from build bot.
- fixed comment about minimum AIL push target.
- fixed whitespace problems in multiple patches.

Version 2
- https://lore.kernel.org/linux-xfs/20220809230353.3353059-1-david@fromorbit.com/
- reorder moving xfs_trans_bulk_commit() patch to start of series
- fix failure to consider NULLCOMMITLSN push target in AIL
- grant space release based on ctx->start_lsn fails to release the space used in
  the checkpoint that was just committed. Release needs to be based on the the
  ctx->commit_lsn which is the end of the region that the checkpoint consumes in
  the log.


