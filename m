Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AFFC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 01:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348174AbjKBBQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 21:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348177AbjKBBQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 21:16:42 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Nov 2023 18:16:36 PDT
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681EE101
        for <linux-xfs@vger.kernel.org>; Wed,  1 Nov 2023 18:16:36 -0700 (PDT)
Date:   Wed, 1 Nov 2023 21:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698887393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hvc87rLyNSuk6U47xv+ZrAEvJPwfJlWofcSTDHhl/cc=;
        b=uhT0YA0oJvl2v+shgvGl5NJKYfiqpHKRvoNoTvXm45MDRu2GouriFBC3ltFiriatDH7mOZ
        NpDOUF00eA4q0YmeE7qF+dCLnxmn1GhC2/OfuxOP06K8OZ8CmTRTZR0p6D+wBYpaJEcxl3
        0ZFHVLBAWihfsdWyIb2bneqz4H/krcg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jan Kara <jack@suse.cz>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/7] bcachefs: Convert to bdev_open_by_path()
Message-ID: <20231102010950.no2byim4ttu6csmy@moria.home.lan>
References: <20231101173542.23597-1-jack@suse.cz>
 <20231101174325.10596-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101174325.10596-1-jack@suse.cz>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 06:43:06PM +0100, Jan Kara wrote:
> Convert bcachefs to use bdev_open_by_path() and pass the handle around.
> 
> CC: Kent Overstreet <kent.overstreet@linux.dev>
> CC: Brian Foster <bfoster@redhat.com>
> CC: linux-bcachefs@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
