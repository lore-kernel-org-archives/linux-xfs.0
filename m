Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB05C7EE31
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 10:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbjEYKGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 06:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbjEYKGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 06:06:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF8310B;
        Thu, 25 May 2023 03:06:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 45E6C68AFE; Thu, 25 May 2023 12:05:58 +0200 (CEST)
Date:   Thu, 25 May 2023 12:05:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 09/11] fs: factor out a direct_write_fallback helper
Message-ID: <20230525100557.GA30242@lst.de>
References: <20230524063810.1595778-1-hch@lst.de> <20230524063810.1595778-10-hch@lst.de> <CAJfpeguT-LjhS-XrZwMystZqkxyB=HaON1zo-BTNOC0L1zCa1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguT-LjhS-XrZwMystZqkxyB=HaON1zo-BTNOC0L1zCa1Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 24, 2023 at 09:00:36AM +0200, Miklos Szeredi wrote:
> > +ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
> > +               ssize_t direct_written, ssize_t buffered_written)
> > +{
> > +       struct address_space *mapping = iocb->ki_filp->f_mapping;
> > +       loff_t pos = iocb->ki_pos - buffered_written;
> > +       loff_t end = iocb->ki_pos - 1;
> > +       int err;
> > +
> > +       /*
> > +        * If the buffered write fallback returned an error, we want to return
> > +        * the number of bytes which were written by direct I/O, or the error
> > +        * code if that was zero.
> > +        *
> > +        * Note that this differs from normal direct-io semantics, which will
> > +        * return -EFOO even if some bytes were written.
> > +        */
> > +       if (unlikely(buffered_written < 0))
> > +               return buffered_written;
> 
> Comment/code mismatch.   The comment says:
> 
> if (buffered_written < 0)
>         return direct_written ?: buffered_written;

Yeah.  And the old code matches the comment, so I'll update to that.
I'm really wondering how I could come up with a good test case for
this..
