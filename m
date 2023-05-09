Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E348C77B75
	for <linux-xfs@archiver.kernel.org>; Tue,  9 May 2023 13:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjEINat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 May 2023 09:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjEINaa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2023 09:30:30 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C0D30C4;
        Tue,  9 May 2023 06:30:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 87B706732A; Tue,  9 May 2023 15:30:26 +0200 (CEST)
Date:   Tue, 9 May 2023 15:30:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] block: add a mark_dead holder operation
Message-ID: <20230509133025.GB841@lst.de>
References: <20230505175132.2236632-1-hch@lst.de> <20230505175132.2236632-7-hch@lst.de> <20230505183749.GG15394@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505183749.GG15394@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 05, 2023 at 11:37:49AM -0700, Darrick J. Wong wrote:
> Now that we have blockdev callbacks, can we add a pair for freeze_bdev
> and thaw_bdev so that LVM snapshotting an xfs log device can actually
> quiesce the filesystem?

Probably.  Assuming we're not creating any really weird locking dependency
that way.
