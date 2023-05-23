Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DC2C7EE2F
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 16:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbjEWQCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 12:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbjEWQCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 12:02:21 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12928E;
        Tue, 23 May 2023 09:02:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8A4516732D; Tue, 23 May 2023 18:02:17 +0200 (CEST)
Date:   Tue, 23 May 2023 18:02:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        "open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>,
        cluster-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/13] iomap: update ki_pos in iomap_file_buffered_write
Message-ID: <20230523160217.GB15391@lst.de>
References: <20230519093521.133226-1-hch@lst.de> <20230519093521.133226-8-hch@lst.de> <5c66fe46-13eb-d9d2-e107-cc48eb50688f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c66fe46-13eb-d9d2-e107-cc48eb50688f@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 22, 2023 at 09:01:05AM +0900, Damien Le Moal wrote:
> > -	int ret;
> > +	ssize_t ret;
> >  
> >  	if (iocb->ki_flags & IOCB_NOWAIT)
> >  		iter.flags |= IOMAP_NOWAIT;
> >  
> >  	while ((ret = iomap_iter(&iter, ops)) > 0)
> >  		iter.processed = iomap_write_iter(&iter, i);
> > -	if (iter.pos == iocb->ki_pos)
> > +
> > +	if (unlikely(ret < 0))
> 
> Nit: This could be if (unlikely(ret <= 0)), no ?

No.  iomap_iter does not return te amount of bytes written.
