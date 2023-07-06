Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F8AC001DF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 16:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbjGFQOm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjGFQOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 12:14:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8B3129;
        Thu,  6 Jul 2023 09:14:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4E502223E8;
        Thu,  6 Jul 2023 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1688660074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U3X2c4DZ7u1WJQoXTnnFA0EIrJReIsvKkxSR5ka0KIA=;
        b=QmpkaGPRZaoHJzRo2a6TjndqPucrWh7f/FY2L3L/tkSmDEI1eMsM8wrizbEulyyCbALdKF
        NAhJw22VD9dE7RV9U1X7QxEMrx2wMp7N4RocvtwIIP7j7sOckxmGngjpgD0K7UzZlI8BMj
        7TaptoZ4hnlDaa+a0YvCourIJS7rkEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1688660074;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U3X2c4DZ7u1WJQoXTnnFA0EIrJReIsvKkxSR5ka0KIA=;
        b=BFZ9TyrydR/g+7ExWBaMGJWuaCnekgsDWt3QOA77tpx+pa0ab3V9kDQ7HgXi8ns77IxFLs
        krph+7hPTygy6eCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2ADF1138EE;
        Thu,  6 Jul 2023 16:14:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +RN/CmropmTIKwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 06 Jul 2023 16:14:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B00D6A0707; Thu,  6 Jul 2023 18:14:33 +0200 (CEST)
Date:   Thu, 6 Jul 2023 18:14:33 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        David Sterba <dsterba@suse.com>, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        Joern Engel <joern@lazybastard.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Minchan Kim <minchan@kernel.org>, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Song Liu <song@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        target-devel@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_* functions
Message-ID: <20230706161433.lj4apushiwguzvdd@quack3>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
 <ZKbgAG5OoHVyUKOG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKbgAG5OoHVyUKOG@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 06-07-23 08:38:40, Christoph Hellwig wrote:
> On Tue, Jul 04, 2023 at 02:21:28PM +0200, Jan Kara wrote:
> > Create struct bdev_handle that contains all parameters that need to be
> > passed to blkdev_put() and provide blkdev_get_handle_* functions that
> > return this structure instead of plain bdev pointer. This will
> > eventually allow us to pass one more argument to blkdev_put() without
> > too much hassle.
> 
> Can we use the opportunity to come up with better names?  blkdev_get_*
> was always a rather horrible naming convention for something that
> ends up calling into ->open.
> 
> What about:
> 
> struct bdev_handle *bdev_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
> 		const struct blk_holder_ops *hops);
> struct bdev_handle *bdev_open_by_path(dev_t dev, blk_mode_t mode,
> 		void *holder, const struct blk_holder_ops *hops);
> void bdev_release(struct bdev_handle *handle);

I'd maybe use bdev_close() instead of bdev_release() but otherwise I like
the new naming.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
