Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D88C7EE22
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 15:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbjEHPUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 11:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjEHPUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 11:20:22 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35798173A;
        Mon,  8 May 2023 08:20:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B131368BEB; Mon,  8 May 2023 17:20:16 +0200 (CEST)
Date:   Mon, 8 May 2023 17:20:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: introduce bdev holder ops and a file system shutdown method
Message-ID: <20230508152015.GA15395@lst.de>
References: <20230505175132.2236632-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505175132.2236632-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As I got asked last night what tree this actually applies to, and
the answer is "whatever was in Linus' tree three days ago",
I have just pushed out the branch here:

    git://git.infradead.org/users/hch/block.git blk_holder_ops

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/blk_holder_ops
