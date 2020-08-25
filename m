Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D153FC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 01:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B93EB207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 01:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgHYByt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHYBys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 21:54:48 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E618C061574;
        Mon, 24 Aug 2020 18:54:48 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAOAO-004EWH-BU; Tue, 25 Aug 2020 01:54:28 +0000
Date:   Tue, 25 Aug 2020 02:54:28 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] bio: Direct IO: convert to pin_user_pages_fast()
Message-ID: <20200825015428.GU1236603@ZenIV.linux.org.uk>
References: <20200822042059.1805541-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822042059.1805541-1-jhubbard@nvidia.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 21, 2020 at 09:20:54PM -0700, John Hubbard wrote:

> Direct IO behavior:
> 
>     ITER_IOVEC:
>         pin_user_pages_fast();
>         break;
> 
>     ITER_KVEC:    // already elevated page refcount, leave alone
>     ITER_BVEC:    // already elevated page refcount, leave alone
>     ITER_PIPE:    // just, no :)

Why?  What's wrong with splice to O_DIRECT file?
