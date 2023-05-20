Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7890C77B7F
	for <linux-xfs@archiver.kernel.org>; Sat, 20 May 2023 09:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjETJli (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 May 2023 05:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjETJlg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 May 2023 05:41:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F000D1BD;
        Sat, 20 May 2023 02:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8802960B6B;
        Sat, 20 May 2023 09:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90607C433EF;
        Sat, 20 May 2023 09:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684575694;
        bh=Qi34Xt1y6x93U61QykhNqil2JS5d/WED6AUV/H0U3cU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCKu+qWLljLQMkOKKE7+IBqPv71gQvySDl07esuV8mxzFnjBimDFbJ+MeTXiImdwi
         LAo1oAYsycIi6Ngjivs8aWf09Cb9lAvSPT8V2b4vnr52AhA3wOa/eQDFYZZeo1f4LA
         1dZwCOGQ7U8tRHWFm0WzUOBEiB2QJO1tfY0b2INLx6s4X3yorcUT+1egxyQYM79jmL
         VEwcuw7Dj4wzdbpCiR3/dZ5jcuQr/CBLIo4+1Q6Z325lA4XAokTZBbKp7ZzDfVTlP3
         rPhjhxF3vQ/ENd4VZF5WlXEzG14C074CDwifY9/pZY9VpqGP7shdUgTnByBELcVTt2
         V26DafIYZg3Tg==
Date:   Sat, 20 May 2023 11:41:27 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v21 08/30] splice: Make splice from a DAX file use
 copy_splice_read()
Message-ID: <20230520-gepocht-akzeptabel-b117346c55b6@brauner>
References: <20230520000049.2226926-1-dhowells@redhat.com>
 <20230520000049.2226926-9-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230520000049.2226926-9-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 20, 2023 at 01:00:27AM +0100, David Howells wrote:
> Make a read splice from a DAX file go directly to copy_splice_read() to do
> the reading as filemap_splice_read() is unlikely to find any pagecache to
> splice.
> 
> I think this affects only erofs, Ext2, Ext4, fuse and XFS.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: linux-erofs@lists.ozlabs.org
> cc: linux-ext4@vger.kernel.org
> cc: linux-xfs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-mm@kvack.org
> ---

Fwiw, O_DIRECT and DAX could've just been folded into one patch imho.
Reviewed-by: Christian Brauner <brauner@kernel.org>
