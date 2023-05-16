Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DC1C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue, 16 May 2023 16:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjEPQZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 12:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjEPQZb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 12:25:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8134D9029;
        Tue, 16 May 2023 09:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3341863C4C;
        Tue, 16 May 2023 16:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B96C433EF;
        Tue, 16 May 2023 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684254270;
        bh=+cdE3XO2ofjWYrDpSaVHslgYMqqdXTsji8DOg+lgKvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XWziwsNbetXdwK4zSEcGZKamgzKP07aNDbfosE7PBvUNv1rUD2ABk0a75rXrG4j4R
         jgexCkIlrKc1dwX5SBnJGCShUndMbhY2euOO4qOkjRG1piCVvF5Dkje+G6z8xk2OAG
         NbapHWCDOitt8SjviAbz4vrzzlL+0a1ct+7so3WV30k2s3QwylXLgtcIGtGAd/p25a
         zHflIl7vz+AEpMJlykVkJU4JAPQdbVYL/VfFdQheRj3705Cg7xnVOKzX1moUlYx2/w
         Hf1f7wbrNK3YSL0yDJhXegwE/vy5qap9qGdGhK42vNLQYsCOBTsgpJ0tDo68XFqtR9
         ACfmIJEqOe4rg==
Date:   Tue, 16 May 2023 18:24:25 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] block: turn bdev_lock into a mutex
Message-ID: <20230516-gefasst-kredit-ee4b0a2e2359@brauner>
References: <20230505175132.2236632-1-hch@lst.de>
 <20230505175132.2236632-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230505175132.2236632-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 05, 2023 at 01:51:27PM -0400, Christoph Hellwig wrote:
> There is no reason for this lock to spin, and being able to sleep under
> it will come in handy soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Acked-by: Christian Brauner <brauner@kernel.org>
