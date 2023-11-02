Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5607FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 01:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348181AbjKBBQs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 21:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346990AbjKBBQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 21:16:47 -0400
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Nov 2023 18:16:41 PDT
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE53EFC
        for <linux-xfs@vger.kernel.org>; Wed,  1 Nov 2023 18:16:41 -0700 (PDT)
Date:   Wed, 1 Nov 2023 21:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698887368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NMFkICBeVzAfEfILGEd/mAVjEIeT8Er8QtywEIlpFzc=;
        b=hbk10m3jal5wz6cHkr843gxi21/L5oC86suIGP4xHWk6wjd9Q9BBD/4jqU+F1uKindgEg+
        uUaZteBzjHwS8eHiA6rBfGDhMIU8kxzJJQIrL+igTSo0TA4gFyllRRaaCAdPCq7DFJ3jwd
        qU8G78bpFfLR4fHyM+8+4qzx+0I7JmA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/7] bcachefs: Convert to bdev_open_by_path()
Message-ID: <20231102010924.pac3ag4mp6hebsif@moria.home.lan>
References: <20231101173542.23597-1-jack@suse.cz>
 <20231101174325.10596-1-jack@suse.cz>
 <ZUKggpzckTAKkyMl@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUKggpzckTAKkyMl@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 03:01:22PM -0400, Brian Foster wrote:
> On Wed, Nov 01, 2023 at 06:43:06PM +0100, Jan Kara wrote:
> > Convert bcachefs to use bdev_open_by_path() and pass the handle around.
> > 
> > CC: Kent Overstreet <kent.overstreet@linux.dev>
> > CC: Brian Foster <bfoster@redhat.com>
> > CC: linux-bcachefs@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/bcachefs/super-io.c    | 19 ++++++++++---------
> >  fs/bcachefs/super_types.h |  1 +
> >  2 files changed, 11 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> > index 332d41e1c0a3..01a32c41a540 100644
> > --- a/fs/bcachefs/super-io.c
> > +++ b/fs/bcachefs/super-io.c
> ...
> > @@ -685,21 +685,22 @@ int bch2_read_super(const char *path, struct bch_opts *opts,
> >  	if (!opt_get(*opts, nochanges))
> >  		sb->mode |= BLK_OPEN_WRITE;
> >  
> > -	sb->bdev = blkdev_get_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
> > -	if (IS_ERR(sb->bdev) &&
> > -	    PTR_ERR(sb->bdev) == -EACCES &&
> > +	sb->bdev_handle = bdev_open_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
> > +	if (IS_ERR(sb->bdev_handle) &&
> > +	    PTR_ERR(sb->bdev_handle) == -EACCES &&
> >  	    opt_get(*opts, read_only)) {
> >  		sb->mode &= ~BLK_OPEN_WRITE;
> >  
> > -		sb->bdev = blkdev_get_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
> > -		if (!IS_ERR(sb->bdev))
> > +		sb->bdev_handle = bdev_open_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
> > +		if (!IS_ERR(sb->bdev_handle))
> >  			opt_set(*opts, nochanges, true);
> >  	}
> >  
> > -	if (IS_ERR(sb->bdev)) {
> > -		ret = PTR_ERR(sb->bdev);
> > +	if (IS_ERR(sb->bdev_handle)) {
> > +		ret = PTR_ERR(sb->bdev_handle);
> >  		goto out;
> >  	}
> > +	sb->bdev = sb->bdev_handle->bdev;
> >  
> >  	ret = bch2_sb_realloc(sb, 0);
> >  	if (ret) {
> 
> Hi Jan,
> 
> This all seems reasonable to me, but should bcachefs use sb_open_mode()
> somewhere in here to involve use of the restrict writes flag in the
> first place? It looks like bcachefs sort of open codes bits of
> mount_bdev() so it isn't clear the flag would be used anywhere...

Yeah, but that should be a separate patch :)
