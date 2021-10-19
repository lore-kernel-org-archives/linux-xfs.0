Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48ABC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 15:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C3846115A
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 15:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhJSPUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:20:46 -0400
Received: from sandeen.net ([63.231.237.45]:43850 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhJSPUq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 11:20:46 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5AD5D7B9F
        for <linux-xfs@vger.kernel.org>; Tue, 19 Oct 2021 10:17:20 -0500 (CDT)
Message-ID: <e5d00665-ff40-cd6a-3c5c-a022341c3344@sandeen.net>
Date:   Tue, 19 Oct 2021 10:18:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Small project: Make it easier to upgrade root fs (i.e. to bigtime)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick taught xfs_admin to upgrade filesystems to bigtime and inobtcount, which is
nice! But it operates via xfs_repair on an unmounted filesystem, so it's a bit tricky
to do for the root fs.

It occurs to me that with the /forcefsck and /fsckoptions files[1], we might be able
to make this a bit easier. i.e. touch /forcefsck and add "-c bigtime=1" to /fsckoptions,
and then the initrd/initramfs should run xfs_repair with -c bigtime=1 and do the upgrade.

However ... fsck.xfs doesn't accept that option, and doesn't pass it on to repair, so
that doesn't work.

It seems reasonable to me for fsck.xfs, when it gets the "-f" option via init, and
the special handling we do already to actually Do Something(tm)[2], we could then also
pass on any additional options we got via the /fsckoptions method.

Does anyone see a problem with this?
If not, would anyone like to take this on as a small project?

Thanks,
-Eric


[1] this works at least on some OSes, I don't know if it works on all.

[2]
if $FORCE; then
         xfs_repair -e $DEV
         repair2fsck_code $?
         exit $?
fi
