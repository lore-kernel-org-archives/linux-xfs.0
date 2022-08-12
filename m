Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A0CC28B2B
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Aug 2022 13:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiHLNYT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Aug 2022 09:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiHLNYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Aug 2022 09:24:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0851890C68;
        Fri, 12 Aug 2022 06:24:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B733C38E65;
        Fri, 12 Aug 2022 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660310656;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jHPbboNCLfVt9x4zLbf1gFwcvrmatt9a0rTeSyx+jQU=;
        b=wHtdDAmBqevJTn+cLbtLpmZXGNQLLeawBhM5TqDM2T/mgnNTsTm+lwOft2pVg67qxrQgwa
        w6vCXHxMTT9FZ50/u/HETcEtVbRIZnd6N50fpacnFSs2/LEDjDAbxMaboFQV3sP2IzyHAV
        ldwtxS2tXKfR/YPBpdZVTVQWDlFJ0/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660310656;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jHPbboNCLfVt9x4zLbf1gFwcvrmatt9a0rTeSyx+jQU=;
        b=KTwgQttalAbPZPhU6awKnxxIh86keR0ZDe4twozOx1OjKTmZaE5BwTzqIt6OB+75HOQyg0
        MMVhaHRTo4xcFxDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1877D13305;
        Fri, 12 Aug 2022 13:24:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1mV3A4BU9mJ5KwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 12 Aug 2022 13:24:16 +0000
Date:   Fri, 12 Aug 2022 15:24:14 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <YvZUfq+3HYwXEncw@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YvZTpQFinpkB06p9@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvZTpQFinpkB06p9@pevik>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Hi all,

> LTP test df01.sh found different size of loop device in v5.19.
> Test uses loop device formatted on various file systems, only XFS fails.
> It randomly fails during verifying that loop size usage changes:

> grep ${TST_DEVICE} output | grep -q "${total}.*${used}" [1]

> How to reproduce:
> # PATH="/opt/ltp/testcases/bin:$PATH" df01.sh -f xfs # it needs several tries to hit

> df saved output:
> Filesystem     1024-blocks    Used Available Capacity Mounted on
> ...
> /dev/loop0          256672   16208    240464       7% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
> df output:
> Filesystem     1024-blocks    Used Available Capacity Mounted on
> ...
> tmpfs               201780       0    201780       0% /run/user/0
> /dev/loop0          256672   15160    241512       6% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
> => different size
> df01 4 TFAIL: 'df -k -P' failed, not expected.

> Also 'df -T -P' fails.

> It might be a false positive / bug in the test, but it's at least a changed behavior.
> I was able to reproduce it on v5.19 distro kernels (openSUSE, Debian).
> I haven't bisected (yet), nor checked Jens' git tree (maybe it has been fixed).

Forget to note dmesg "operation not supported error" warning on *each* run (even
successful) on affected v5.19:
[ 5097.594021] loop0: detected capacity change from 0 to 524288
[ 5097.658201] operation not supported error, dev loop0, sector 262192 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[ 5097.675670] XFS (loop0): Mounting V5 Filesystem
[ 5097.681668] XFS (loop0): Ending clean mount
[ 5097.956445] XFS (loop0): Unmounting Filesystem

Kind regards,
Petr

> Kind regards,
> Petr

> [1] https://github.com/linux-test-project/ltp/blob/f42f6f3b4671f447b743afe8612917ba4362b8a6/testcases/commands/df/df01.sh#L103-L110
