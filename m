Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADA7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 16:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C602C2310E
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 16:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbgLKPwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:52:09 -0500
Received: from sandeen.net ([63.231.237.45]:37336 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393387AbgLKPwB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Dec 2020 10:52:01 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 88AB41171F;
        Fri, 11 Dec 2020 09:50:31 -0600 (CST)
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        linux-kernel@vger.kernel.org
References: <20201211084112.1931-1-zhengyongjun3@huawei.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH -next] fs/xfs: convert comma to semicolon
Message-ID: <fd372b27-983d-00ff-5218-4082fe2f08df@sandeen.net>
Date:   Fri, 11 Dec 2020 09:51:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211084112.1931-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/11/20 2:41 AM, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

hah, that's an old one.  Harmless though, AFAICT.

this fixes 91cca5df9bc8 ("[XFS] implement generic xfs_btree_delete/delrec")
if we dare add that tag ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2d25bab68764..51dbff9b0908 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4070,7 +4070,7 @@ xfs_btree_delrec(
>  	 * surviving block, and log it.
>  	 */
>  	xfs_btree_set_numrecs(left, lrecs + rrecs);
> -	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
> +	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB);
>  	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
>  	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
>  
> 
