Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F405AC7EE2D
	for <linux-xfs@archiver.kernel.org>; Sun, 21 May 2023 23:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjEUXlH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 May 2023 19:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjEUXlG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2023 19:41:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E4CB4;
        Sun, 21 May 2023 16:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DEBE60FAC;
        Sun, 21 May 2023 23:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF259C433EF;
        Sun, 21 May 2023 23:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684712463;
        bh=tA12yQU00KKUJDHmMiS/p1BMYZTe42VhuQxJI9hnBGs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bbR+hubYRLAGzg/uGQW+S+uObtEMdvAC9Prq09XRey518FIX9V+FA9yn08nrOyJNo
         phX9SlbCCQp1tqYPJmwQQ7TYpLWkj6b+H3zMuc1Z7VQuG4Eo9Q/x02u3s+NMYDXZK7
         y6g4/CCC39Anez1oZFdvYg1ooCDtAlwpyilfm6Q6NNXW5yqA5BSTe0P3z5r+pwBHUD
         0on5F0vG1ouPX4IHgXYeHIp4iq7izeicWegN4YNYFIeZ8chatU4lAHZIfFgH6cpWn+
         WUW1P4+xbujvaU0L10MBQr77eKeg564VpiezTN64057zhcRO/0ww07EJx3udJ/fiyx
         NLclOBUpvfnRw==
Message-ID: <3efbf8c7-b3ad-fbca-f37e-a7b2fd78320d@kernel.org>
Date:   Mon, 22 May 2023 08:40:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 01/13] iomap: update ki_pos a little later in
 iomap_dio_complete
To:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>,
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
References: <20230519093521.133226-1-hch@lst.de>
 <20230519093521.133226-2-hch@lst.de>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230519093521.133226-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/19/23 18:35, Christoph Hellwig wrote:
> Move the ki_pos update down a bit to prepare for a better common
> helper that invalidates pages based of an iocb.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +		if (dio->flags & IOMAP_DIO_NEED_SYNC)
> +			ret = generic_write_sync(iocb, ret);
> +		if (ret > 0)
> +			ret += dio->done_before;
> +	}
>  	trace_iomap_dio_complete(iocb, dio->error, ret);
>  	kfree(dio);
> -

white line change. Personally, I like a blank line before returns to make them
stand out :)

>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_complete);

-- 
Damien Le Moal
Western Digital Research

