Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D542CC77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 07:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjEQH2C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 03:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjEQH2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 03:28:01 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E21A7;
        Wed, 17 May 2023 00:28:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 83B6368C4E; Wed, 17 May 2023 09:27:57 +0200 (CEST)
Date:   Wed, 17 May 2023 09:27:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] fs: add a method to shut down the file system
Message-ID: <20230517072757.GD27026@lst.de>
References: <20230505175132.2236632-1-hch@lst.de> <20230505175132.2236632-8-hch@lst.de> <20230516-heckklappe-wirkt-bfdd7ec99a6e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516-heckklappe-wirkt-bfdd7ec99a6e@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 16, 2023 at 06:20:19PM +0200, Christian Brauner wrote:
> Do you want the fs infra and block infra merged together or separately?

Yes, splitting this up doesn't really make a lot of sense.
