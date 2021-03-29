Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD145C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8383961964
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhC2FpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:45:20 -0400
Received: from verein.lst.de ([213.95.11.211]:52043 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhC2FpQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 01:45:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 86D7168BEB; Mon, 29 Mar 2021 07:45:13 +0200 (CEST)
Date:   Mon, 29 Mar 2021 07:45:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <20210329054513.GA26736@lst.de>
References: <YF4AOto30pC/0FYW@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YF4AOto30pC/0FYW@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 11:39:38AM -0400, Brian Foster wrote:
> 1. Optimize current append transaction processing with an inode field as
> noted above.
> 
> 2. Replace the submission side append transaction entirely with a flag
> or some such on the ioend that allocates the transaction at completion
> time, but otherwise preserves batching behavior instituted in patch 1.

I'm pretty sure I had a patch to kill off the transaction reservation
a while ago and Dave objected, mostly in performance grounds in that
we might have tons of reservations coming from the I/O completion
workqueue that would all be blocked on the transaction reservations.

This would probably be much better with the ioend merging, which should
significantly reduce the amount of transactions reservations - to probably
not more than common workloads using unwritten extents.

I'm all for killing the transaction pre-reservations as they have created
a lot of pain for us.
