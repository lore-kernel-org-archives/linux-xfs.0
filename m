Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC97C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Feb 2022 22:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiB0WQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Feb 2022 17:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiB0WQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Feb 2022 17:16:08 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD816E7A5;
        Sun, 27 Feb 2022 14:15:30 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nORoy-005Wb1-JX; Sun, 27 Feb 2022 22:15:16 +0000
Date:   Sun, 27 Feb 2022 22:15:16 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     jhubbard.send.patches@gmail.com
Cc:     Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 3/6] block, fs: assert that key paths use iovecs, and
 nothing else
Message-ID: <Yhv39J4+FwD/B2aJ@zeniv-ca.linux.org.uk>
References: <20220227093434.2889464-1-jhubbard@nvidia.com>
 <20220227093434.2889464-4-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227093434.2889464-4-jhubbard@nvidia.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 27, 2022 at 01:34:31AM -0800, jhubbard.send.patches@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Upcoming changes to Direct IO will change it from acquiring pages via
> get_user_pages_fast(), to calling pin_user_pages_fast() instead.
> 
> Place a few assertions at key points, that the pages are IOVEC (user
> pages), to enforce the assumptions that there are no kernel or pipe or
> other odd variations being passed.

Umm...  And what should happen when O_DIRECT file gets passed to splice()?
