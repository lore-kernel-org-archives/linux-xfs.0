Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A9CC07548
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 21:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46D7206E7
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 21:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgICVMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:12:35 -0400
Received: from sandeen.net ([63.231.237.45]:41628 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgICVMf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Sep 2020 17:12:35 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D94902ACC;
        Thu,  3 Sep 2020 16:12:09 -0500 (CDT)
To:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org
References: <20200903165632.1338996-1-agruenba@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] iomap: Fix direct I/O write consistency check
Message-ID: <695a418c-ba6d-d3e9-f521-7dfa059764db@sandeen.net>
Date:   Thu, 3 Sep 2020 16:12:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200903165632.1338996-1-agruenba@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/3/20 11:56 AM, Andreas Gruenbacher wrote:
> When a direct I/O write falls back to buffered I/O entirely, dio->size
> will be 0 in iomap_dio_complete.  Function invalidate_inode_pages2_range
> will try to invalidate the rest of the address space.

(Because if ->size == 0 and offset == 0, then invalidating up to (0+0-1) will
invalidate the entire range.)


                err = invalidate_inode_pages2_range(inode->i_mapping,
                                offset >> PAGE_SHIFT,
                                (offset + dio->size - 1) >> PAGE_SHIFT);

so I guess this behavior is unique to writing to a hole at offset 0?

FWIW, this same test yields the same results on ext3 when it falls back to
buffered.

-Eric

> If there are any
> dirty pages in that range, the write will fail and a "Page cache
> invalidation failure on direct I/O" error will be logged.
> 
> On gfs2, this can be reproduced as follows:
> 
>   xfs_io \
>     -c "open -ft foo" -c "pwrite 4k 4k" -c "close" \
>     -c "open -d foo" -c "pwrite 0 4k"
> 
> Fix this by recognizing 0-length writes.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/iomap/direct-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index c1aafb2ab990..c9d6b4eecdb7 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -108,7 +108,7 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  	 * ->end_io() when necessary, otherwise a racing buffer read would cache
>  	 * zeros from unwritten extents.
>  	 */
> -	if (!dio->error &&
> +	if (!dio->error && dio->size &&
>  	    (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
>  		int err;
>  		err = invalidate_inode_pages2_range(inode->i_mapping,
> 
