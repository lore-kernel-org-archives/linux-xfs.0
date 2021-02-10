Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD2AC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 18:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7F564DEC
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 18:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhBJSfN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:35:13 -0500
Received: from sandeen.net ([63.231.237.45]:39802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234139AbhBJScn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 13:32:43 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 74CB85286E7;
        Wed, 10 Feb 2021 12:31:58 -0600 (CST)
Subject: Re: [PATCH] xfs: restore shutdown check in mapped write fault path
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210210170112.172734-1-bfoster@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7edae48c-2ac9-94aa-8daa-a9ec3ba8907c@sandeen.net>
Date:   Wed, 10 Feb 2021 12:31:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210170112.172734-1-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/10/21 11:01 AM, Brian Foster wrote:
> XFS triggers an iomap warning in the write fault path due to a
> !PageUptodate() page if a write fault happens to occur on a page
> that recently failed writeback. The iomap writeback error handling
> code can clear the Uptodate flag if no portion of the page is
> submitted for I/O. This is reproduced by fstest generic/019, which
> combines various forms of I/O with simulated disk failures that
> inevitably lead to filesystem shutdown (which then unconditionally
> fails page writeback).
> 
> This is a regression introduced by commit f150b4234397 ("xfs: split
> the iomap ops for buffered vs direct writes") due to the removal of
> a shutdown check and explicit error return in the ->iomap_begin()
> path used by the write fault path. The explicit error return
> historically translated to a SIGBUS, but now carries on with iomap
> processing where it complains about the unexpected state. Restore
> the shutdown check to xfs_buffered_write_iomap_begin() to restore
> historical behavior.
> 
> Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_iomap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 70c341658c01..6594f572096e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -860,6 +860,9 @@ xfs_buffered_write_iomap_begin(
>  	int			allocfork = XFS_DATA_FORK;
>  	int			error = 0;
>  
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
>  	/* we can't use delayed allocations when using extent size hints */
>  	if (xfs_get_extsz_hint(ip))
>  		return xfs_direct_write_iomap_begin(inode, offset, count,
> 
