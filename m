Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D879EC00A8F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 16:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbjJXQO0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbjJXQOZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 12:14:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1175083;
        Tue, 24 Oct 2023 09:14:23 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D7FD668AA6; Tue, 24 Oct 2023 18:14:18 +0200 (CEST)
Date:   Tue, 24 Oct 2023 18:14:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] filemap: add a per-mapping stable writes flag
Message-ID: <20231024161418.GA20546@lst.de>
References: <20231024064416.897956-1-hch@lst.de> <20231024064416.897956-2-hch@lst.de> <20231024150053.GY3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024150053.GY3195650@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:00:53AM -0700, Darrick J. Wong wrote:
> For a hot second I wondered if we could get rid of SB_I_STABLE_WRITES
> too, but then had an AHA moment when I saw that NFS also sets it.

It's not just NFS, but still the general way of propagating the flag.
I don't really want to add bdev-specific code to new_inode.
