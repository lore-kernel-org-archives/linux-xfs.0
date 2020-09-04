Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E882C43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B7220791
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgIDP7z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:59:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44660 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbgIDP7z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:59:55 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-_86vB2haM8GtWkcBDg4f5Q-1; Fri, 04 Sep 2020 11:59:52 -0400
X-MC-Unique: _86vB2haM8GtWkcBDg4f5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EFAC1007473;
        Fri,  4 Sep 2020 15:59:51 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D99C660C0F;
        Fri,  4 Sep 2020 15:59:50 +0000 (UTC)
Date:   Fri, 4 Sep 2020 11:59:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: quotaoff, transaction quiesce, and dquot logging
Message-ID: <20200904155949.GF529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

I'm finally getting back to the quotaoff thing we discussed a ways
back[1] and doing some auditing to make sure that I understand the
approach and that it seems correct. To refresh, your original prototype
and the slightly different one I'm looking into implement the same
general scheme:

1.) quiesce the transaction subsystem
2.) disable quota(s) (update state flags)
3.) log quotaoff start/end items (synchronous)
4.) open the transaction subsystem
5.) release all inode dquot references and purge dquots

The idea is that the critical invariant requred for quotaoff is that no
dquots are logged after the quotaoff end item is committed to the log.
Otherwise there is no guarantee that the tail pushes past the quotaoff
item and a subsequent crash/recovery incorrectly replays dquot changes
for an inactive quota mode.

As it is, I think there's at least one assumption we've made that isn't
entirely accurate. It looks to me that steps 1-4 don't guarantee that
dquots aren't logged after the transaction subsystem is released. The
current code (and my prototype) only clear the *QUOTA_ACTIVE flags at
that point, and various transactions might have already acquired or
attached dquots to inodes before the transaction allocation even occurs.
Once the transaction is allocated, various paths basically only care if
we have a dquot or not.

For example, xfs_create() gets the dquots up front, allocs the
transaction and xfs_trans_reserve_quota_bydquots() attaches any of the
associated dquots to the transaction. xfs_trans_reserve_quota_bydquots()
checks for (!QUOTA_ON() || !QUOTA_RUNNING()), but those only help us if
all quotas have been disabled. Consider if one of multiple active quotas
are being turned off, and that this path already has dquots for both,
for example.

I do notice that your prototype[1] clears all of the quota flags (not
just the ACTIVE flags) after the transaction barrier is released. This
prevents further modifications in some cases, but it doesn't seem like
that is enough to avoid violating the invariant described above. E.g.,
xfs_trans_apply_dquot_deltas() logs the dquot regardless of whether
changes are made (and actually looks like it can make some changes on
the dquot even if the transaction doesn't) after the dquot is attached
to the transaction.

This does make me wonder a bit whether we should rework the transaction
commit path to avoid modifying/logging the dquot completely if the quota
is inactive or accounting is disabled. When starting to look around with
that in mind, I see the following in xfs_quota_defs.h:

/*
 * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
 * quota will be not be switched off as long as that inode lock is held.
 */
#define XFS_IS_QUOTA_ON(mp)     ((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
                                                   XFS_GQUOTA_ACTIVE | \
                                                   XFS_PQUOTA_ACTIVE))
...

So I'm wondering how safe that actually would be, or even how safe it is
to clear the ACCT|ENFD flags before we release/purge dquots. It seems
like that conflicts with the above documentation, at least, but I'm not
totally clear on the reason for that rule. In any event, I'm still
poking around a bit, but unless I'm missing something in the analysis
above it doesn't seem like this is a matter of simply altering the
quotaoff path as originally expected. Thoughts or ideas appreciated.

Brian

[1] https://lore.kernel.org/linux-xfs/20200702115144.GH2005@dread.disaster.area/

