Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7248AC47087
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D296142D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhEZB2g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhEZB2f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44E8761284;
        Wed, 26 May 2021 01:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621992425;
        bh=fvARVF4RELXwoXeWAEmhnhUdrBnGSI9KrBD8vHFsfGw=;
        h=Date:From:To:Cc:Subject:From;
        b=rALu7rtADBhB20rzqs+SyuWjJ1MDrSin4/OadP9qkZuTrC9i3Qooo8UvSjqF3WSxO
         dBRGKL3Dnq62GEVd24BlxnNtOfWpoyl1K7uJLfwqu2FIgCl8mEq0Xh9os9X6bpSvZh
         HYg2tj5QHInbWBsdoW0CyaLcUrFzQnVZRI27Td0L2BcxgShsJ1CbX/iCEio5IxlGzp
         7CLbX5bBu27MjAk6qWSpmYa85dLkUD2YoFF70IJ2C4fT/oMshuk92FUVsBzVlXdiGR
         UJf3VDwV3mXlSK5fEZtLBnem7APDYG1rI5SFaPaRv3ZGdD6gxzHgZ4xVz3yJGi+iDd
         JOuYIbUzTzZBw==
Date:   Tue, 25 May 2021 18:27:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: patch review scheduling...
Message-ID: <20210526012704.GH202144@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello list, frequent-submitters, and usual-reviewer-suspects:

As you've all seen, we have quite a backlog of patch review for 5.14
already.  The people cc'd on this message are the ones who either (a)
authored the patches caught in the backlog, (b) commented on previous
iterations of them, or (c) have participated in a lot of reviews before.

Normally I'd just chug through them all until I get to the end, but even
after speed-reading through the shorter series (deferred xattrs,
mmaplock, reflink+dax) I still have 73 to go, which is down from 109
this morning.

So, time to be a bit more aggressive about planning.  I would love it if
people dedicated some time this week to reviewing things, but before we
even get there, I have other questions:

Dave: Between the CIL improvements and the perag refactoring, which
would you rather get reviewed first?  The CIL improvments patches have
been circulating longer, but they're more subtle changes.

Dave and Christoph: Can I rely on you both to sort out whatever
conflicts arose around reworking memory page allocation for xfs_bufs?

Brian: Is it worth the time to iterate more on the ioend thresholds in
the "iomap: avoid soft lockup warnings" series?  Specifically, I was
kind of interested in whether or not we should/could scale the max ioend
size limit with the optimal/max io request size that devices report,
though I'm getting a feeling that block device limits are all over the
place maybe we should start with the static limit and iterate up (or
down?) from there...?

Everyone else: If you'd like to review something, please stake a claim
and start reading.

Everyone else not on cc: You're included too!  If you like! :)

--D
