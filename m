Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E86C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 22:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiEWWgL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 18:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiEWWgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 18:36:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F168055B3;
        Mon, 23 May 2022 15:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF7661540;
        Mon, 23 May 2022 22:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAC6C385A9;
        Mon, 23 May 2022 22:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653345368;
        bh=EE0WUvON5ejJQLkBWGV/tDflACpI5x3JMK2sZqhb/4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CC5Vp4lrbHj9V1ccl5SdDoFbcHiWK5BO+R40hsCl9NoRxMav99+ONFpUyqXktj6Jk
         27fb7G61UI6BSXDJ8pu/EOT/Q1GZY2Fm+6RVKI46K9nd9gxCXHQHaKmhkZVo0f/L7E
         1aKRJWCycFJbh1gRWQBAa0L8i1QMtEbx6LmnI/wess6hn+kK7lxKwokfdEwbsVeqT8
         m1ULKspWnvGIH9jzOZDKPXaiYj16rXgB1YG0asYZu34mQnbB/+2PZ4IArwtOxbp34D
         3bzGNBTuDdNJTm4rvbMvTzkC25IKXjhmjE2XmG9zJLIJJKOL7ldOqtq4BTebO4JQgO
         NxwNCPzk8hmjA==
Date:   Mon, 23 May 2022 16:36:04 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420143110.2679002-1-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 10:31:10PM +0800, Ming Lei wrote:
> So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> from userspace sync io interface, then block layer tries to poll until
> the bio is completed. But the current implementation calls
> blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> timeout easily.

Wait a second. The task's current state is TASK_RUNNING when bio_poll() returns
zero, so calling blk_io_schedule() isn't supposed to hang.
