Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2065CC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue, 16 May 2023 16:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjEPQVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 12:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjEPQU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 12:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F060A250;
        Tue, 16 May 2023 09:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B50C63C1F;
        Tue, 16 May 2023 16:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14059C4339E;
        Tue, 16 May 2023 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684254030;
        bh=3WT1WVGK0hca8jMDyWJiYpw02ppfbBMt+9oT9Pajf9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFqLH9hXL4tbzc1YSaTo9s6oBJw/vntfKYezeJGEa+rFfg60hFKe1V8lzMG0TrpaM
         35D8s5o3wXeota8rL4yGcNgVr08XupEQV2Z9sTeIlCYVBNiUb8tm/gpMf1sfaq9bKW
         ijsW6+VColRs17+KcY/sQd7OC62WlomIuReHxBm+pLsg5xJDB0f8/RrSmjpGG5tXWu
         uLsvdTZnoifFYeNGtD9PsVi+eETpyQOKjxHLR8AEH/9kq8X8lE0i3suKp6eRzAh5Y6
         mJzPXghg00ozure6mAs7gBrQl2VkOC7aFm24cIyZfQ+zmlfEQIfeu9CRS6t2LcQd59
         bsuyRxMdneC6w==
Date:   Tue, 16 May 2023 18:20:19 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] fs: add a method to shut down the file system
Message-ID: <20230516-heckklappe-wirkt-bfdd7ec99a6e@brauner>
References: <20230505175132.2236632-1-hch@lst.de>
 <20230505175132.2236632-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230505175132.2236632-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 05, 2023 at 01:51:30PM -0400, Christoph Hellwig wrote:
> Add a new ->shutdown super operation that can be used to tell the file
> system to shut down, and call it from newly created holder ops when the
> block device under a file system shuts down.
> 
> This only covers the main block device for "simple" file systems using
> get_tree_bdev / mount_bdev.  File systems their own get_tree method
> or opening additional devices will need to set up their own
> blk_holder_ops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Do you want the fs infra and block infra merged together or separately?
Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
