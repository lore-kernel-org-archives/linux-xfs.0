Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1E7C25B0E
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Aug 2022 13:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiHLNUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Aug 2022 09:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiHLNUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Aug 2022 09:20:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDEA6554D;
        Fri, 12 Aug 2022 06:20:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5E3C220662;
        Fri, 12 Aug 2022 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660310440;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4wKruI1cYrNPkLpX2e+wKUucwtffWcjJmuZ2pefVyBQ=;
        b=HWcMOVvMBicoJy78E3+5w3zg9LRQZAJIwTsIkS0sloK0vFghUGsnQrxjQELUA7Ooeu4p2z
        Ipxpn7GOB5TZLDApqUNj5/spGhYHB4/maIdrmSBm76DamlAronQrzxkeRvfB450D4GJyl8
        jyB32PYwUhPRnkYbqPiSRzVhNrTW+HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660310440;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4wKruI1cYrNPkLpX2e+wKUucwtffWcjJmuZ2pefVyBQ=;
        b=61mHgosgw2R5w4IFHn1wf1BfLHN2vnF8bMAisF0hDgockTEKYXvFHkGGutY+H72t0bGREq
        ARVyBDDkYiVaLbAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D66C13305;
        Fri, 12 Aug 2022 13:20:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HKwHA6hT9mLqKQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 12 Aug 2022 13:20:40 +0000
Date:   Fri, 12 Aug 2022 15:20:37 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org
Subject: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <YvZTpQFinpkB06p9@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

LTP test df01.sh found different size of loop device in v5.19.
Test uses loop device formatted on various file systems, only XFS fails.
It randomly fails during verifying that loop size usage changes:

grep ${TST_DEVICE} output | grep -q "${total}.*${used}" [1]

How to reproduce:
# PATH="/opt/ltp/testcases/bin:$PATH" df01.sh -f xfs # it needs several tries to hit

df saved output:
Filesystem     1024-blocks    Used Available Capacity Mounted on
...
/dev/loop0          256672   16208    240464       7% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
df output:
Filesystem     1024-blocks    Used Available Capacity Mounted on
...
tmpfs               201780       0    201780       0% /run/user/0
/dev/loop0          256672   15160    241512       6% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
=> different size
df01 4 TFAIL: 'df -k -P' failed, not expected.

Also 'df -T -P' fails.

It might be a false positive / bug in the test, but it's at least a changed behavior.
I was able to reproduce it on v5.19 distro kernels (openSUSE, Debian).
I haven't bisected (yet), nor checked Jens' git tree (maybe it has been fixed).

Kind regards,
Petr

[1] https://github.com/linux-test-project/ltp/blob/f42f6f3b4671f447b743afe8612917ba4362b8a6/testcases/commands/df/df01.sh#L103-L110
