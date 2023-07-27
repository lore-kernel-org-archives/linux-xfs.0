Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF22C001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 13:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbjG0NZ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 09:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjG0NZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 09:25:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA08B271D;
        Thu, 27 Jul 2023 06:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0KFiIDnhYDZ7taAXE/urV3AjA9+e3xnscnSv4yRez2o=; b=pzM1KK99mqAxzuzJ5/6RPDEsr4
        OHZPI0hOsDM75J7k/VaQA077zg10R0FzhmXfSRNRCkHjt+100JzZml2SpaNEfafSwNGqxavp5G4ez
        brs5w4IoP0VqJKoYFz0TUgVjRwDS4nbRb2bZfhTzhaGmUkdLEwLV6tJHtbOiINUOT2RCFpHC93dcl
        B/2Kf/YnGpTf9TaYgVdVwCAjgXsWKniZns8GFzHAq7W8t5ElWzAh38hMk4zDY1N8/EYHT+8FsT9Sc
        Ps9UoD1xaXP7CU56U2974+RYt9JLIAIQxqm7qBhXJWvxc9VvdoqzK0TGBm6Uq7+Ihmub3Wz1l5e7+
        A2l8iwtQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qP0zu-007Vc2-5n; Thu, 27 Jul 2023 13:25:42 +0000
Date:   Thu, 27 Jul 2023 14:25:42 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 4/7] add llseek_nowait() for struct file_operations
Message-ID: <ZMJwVmhWcVC0oN20@casper.infradead.org>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-5-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726102603.155522-5-hao.xu@linux.dev>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 06:26:00PM +0800, Hao Xu wrote:
> +	loff_t (*llseek_nowait)(struct file *, loff_t, int, bool);

You don't have to name the struct file, but an unnamed int and an
unnamed bool is just not acceptable.
