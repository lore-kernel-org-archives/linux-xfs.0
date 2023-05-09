Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E1EC77B75
	for <linux-xfs@archiver.kernel.org>; Tue,  9 May 2023 13:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbjEIN2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 May 2023 09:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbjEIN2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2023 09:28:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93942D7E;
        Tue,  9 May 2023 06:28:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5D2EA6732A; Tue,  9 May 2023 15:28:34 +0200 (CEST)
Date:   Tue, 9 May 2023 15:28:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: wire up sops->shutdown
Message-ID: <20230509132833.GA841@lst.de>
References: <20230505175132.2236632-1-hch@lst.de> <20230505175132.2236632-9-hch@lst.de> <20230505182305.GE15394@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505182305.GE15394@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 05, 2023 at 11:23:05AM -0700, Darrick J. Wong wrote:
> Could you add SHUTDOWN_DEVICE_REMOVED to XFS_SHUTDOWN_STRINGS so the
> tracepoint data will decode that flag?

Sure.
