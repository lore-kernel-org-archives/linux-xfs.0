Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74628C001DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 07:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjHBH1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 03:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjHBH1F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 03:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1303198B;
        Wed,  2 Aug 2023 00:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 196946183D;
        Wed,  2 Aug 2023 07:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0369FC433C8;
        Wed,  2 Aug 2023 07:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690961223;
        bh=nhMWAX0JZCMdR76h1WXi/CMNQv6QqzNrLWOGcbCo8sA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RiEFMZYtNKuthj/PCmgiUMFsgNqURRju0WyaF8GtvwpV0KLcq4uagnEzja02itBQf
         VcZJPkaM/lFtG0Ijd6Rt6sMjrsZZVnUAEirYSTT1HURgY0u1NZvk4tQSJJoG68XQNQ
         Uy2dGSfQw73bW3MmNZa1USI3HZSVK3zqK00mEkMIXWiDE/vjoJQl57YqjtxRCSQOop
         3hXyeaMgKhqVZ5Q3MDzQ/8ZklZFJKhXzofFXS5IRQFFoi69KtsBDnDViNrnPqqssB3
         tEI5fLn50YEQnirSRlCMm4dsOKZQPE/+EVkNyz/zdISFzu6B+Ka6NFPB54gP4NSuSD
         f8Ec2wx64vTyg==
Date:   Wed, 2 Aug 2023 09:26:57 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian@brauner.io>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] block: open code __generic_file_write_iter for
 blkdev writes
Message-ID: <20230802-hotel-abneigung-6bb5ac334195@brauner>
References: <20230801172201.1923299-1-hch@lst.de>
 <20230801172201.1923299-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230801172201.1923299-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 07:21:58PM +0200, Christoph Hellwig wrote:
> Open code __generic_file_write_iter to remove the indirect call into
> ->direct_IO and to prepare using the iomap based write code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>
