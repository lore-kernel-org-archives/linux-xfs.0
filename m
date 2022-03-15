Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26311C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 12:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348490AbiCOMvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 08:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348495AbiCOMvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 08:51:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A93A4DF6C
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 05:49:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 825C721921;
        Tue, 15 Mar 2022 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647348587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=mVXd8Fl/YD1cQ5muwcPN0mMFAkc0NlwtdTUDlIFLw9A=;
        b=WBSGfq2vd/ogSpWqhUYxI9B6AsCBXaNqwPs4/ow478kHFBFy5qjPgkU+GBNm7oP1tH4Z9V
        bcT3DG5qf1dpb2/wruyNUSYNK0/5E3iDcDHOw5DWDug62ogXrowCK9jtMyMitl3GQOscFm
        lTl6LNF/mRvjr6vD6KTNqZwx9y22hTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647348587;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=mVXd8Fl/YD1cQ5muwcPN0mMFAkc0NlwtdTUDlIFLw9A=;
        b=aMZt/VWd3+j9RpcfU6cfeHBaGx4PscRaauSE+A/hjS7UttAupmpoa4vwI0Kb4dNedTvSFn
        dKoimtDYKsENYfAA==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 76BC2A3B89;
        Tue, 15 Mar 2022 12:49:47 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E5460A0615; Tue, 15 Mar 2022 13:49:43 +0100 (CET)
Date:   Tue, 15 Mar 2022 13:49:43 +0100
From:   Jan Kara <jack@suse.cz>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Regression in XFS for fsync heavy workload
Message-ID: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I was tracking down a regression in dbench workload on XFS we have
identified during our performance testing. These are results from one of
our test machine (server with 64GB of RAM, 48 CPUs, SATA SSD for the test
disk):

			       good		       bad
Amean     1        64.29 (   0.00%)       73.11 * -13.70%*
Amean     2        84.71 (   0.00%)       98.05 * -15.75%*
Amean     4       146.97 (   0.00%)      148.29 *  -0.90%*
Amean     8       252.94 (   0.00%)      254.91 *  -0.78%*
Amean     16      454.79 (   0.00%)      456.70 *  -0.42%*
Amean     32      858.84 (   0.00%)      857.74 (   0.13%)
Amean     64     1828.72 (   0.00%)     1865.99 *  -2.04%*

Note that the numbers are actually times to complete workload, not
traditional dbench throughput numbers so lower is better. Eventually I have
tracked down the problem to commit bad77c375e8d ("xfs: CIL checkpoint
flushes caches unconditionally"). Before this commit we submit ~63k cache
flush requests during the dbench run, after this commit we submit ~150k
cache flush requests. And the additional cache flushes are coming from
xlog_cil_push_work(). The reason as far as I understand it is that
xlog_cil_push_work() never actually ends up writing the iclog (I can see
this in the traces) because it is writing just very small amounts (my
debugging shows xlog_cil_push_work() tends to add 300-1000 bytes to iclog,
4000 bytes is the largest number I've seen) and very frequent fsync(2)
calls from dbench always end up forcing iclog before it gets filled. So the
cache flushes issued by xlog_cil_push_work() are just pointless overhead
for this workload AFAIU.

Is there a way we could help this? I had some idea like call
xfs_flush_bdev_async() only once we find enough items while walking the
cil->xc_cil list that we think iclog write is likely. This should still
submit it rather early to provide the latency advantage. Otherwise postpone
the flush to the moment we know we are going to flush the iclog to save
pointless flushes. But we would have to record whether the flush happened
or not in the iclog and it would all get a bit hairy... I'm definitely not
an expert in XFS logging code so that's why I'm just writing here my
current findings if people have some ideas.

								Honza


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
