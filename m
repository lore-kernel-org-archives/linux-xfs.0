Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5219EC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 23:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 210F2613DE
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 23:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhDWXxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhDWXxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 19:53:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81A8C061574;
        Fri, 23 Apr 2021 16:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0RWHCLM3/c6H7Z+k5OkW53M3PGgAByaiGpKPD3i08lU=; b=hp8p+Z8DNn1ZurqXmgj2wcS+eL
        rJTz5xXktIyXySN7NXjYlkC3CaxpMHTDnvl0WySOWRASZ/2hQwb3FSRFd+IC7CdooqCKKIQanortM
        M03aHr+F8Y2h/0tKuCSOOisyBXTJ8RJbnT2LTw3CO2+q8wng0SGU1SbYtPMN6dfVL90vHtFcYOTnN
        r39G7yPrxoFM82lg9bY1SzQXwf26JkjX78Y6tOCl739/tP7daK4bgbvDKnWwWwGSJ7VaVSSKajec/
        wSQyinWy5Nir/Utxh+PzZtksMDvn5wT3zIYm3ihveI6NJ9RK1v6Nm5o0Ash0JG/rUQlI5NoZQi+bJ
        F18mbw0A==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1la5aP-002WUO-SQ; Fri, 23 Apr 2021 23:51:55 +0000
Date:   Sat, 24 Apr 2021 00:51:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>, Ted Tso <tytso@mit.edu>,
        ceph-devel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH 0/12 v4] fs: Hole punch vs page cache filling races
Message-ID: <20210423235149.GE235567@casper.infradead.org>
References: <20210423171010.12-1-jack@suse.cz>
 <20210423220751.GB63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423220751.GB63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 24, 2021 at 08:07:51AM +1000, Dave Chinner wrote:
> I've got to spend time now reconstructing the patchset into a single
> series because the delivery has been spread across three different
> mailing lists and so hit 3 different procmail filters.  I'll comment
> on the patches once I've reconstructed the series and read through
> it as a whole...

$ b4 mbox 20210423171010.12-1-jack@suse.cz
Looking up https://lore.kernel.org/r/20210423171010.12-1-jack%40suse.cz
Grabbing thread from lore.kernel.org/ceph-devel
6 messages in the thread
Saved ./20210423171010.12-1-jack@suse.cz.mbx

