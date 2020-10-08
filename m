Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683E1C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 20:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C3D22227
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 20:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgJHUQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:16:57 -0400
Received: from sandeen.net ([63.231.237.45]:47862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgJHUQ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Oct 2020 16:16:57 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 49B6F504DE0;
        Thu,  8 Oct 2020 15:15:55 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20201008035732.GA6535@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] libfrog: fix a potential null pointer dereference
Message-ID: <05af96e6-aab8-3a93-93f5-6cb9195f50cb@sandeen.net>
Date:   Thu, 8 Oct 2020 15:16:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201008035732.GA6535@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/7/20 10:57 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Apparently, gcc 10.2 thinks that it's possible for either of the calloc
> arguments to be zero here, in which case it will return NULL with a zero
> errno.  I suppose it's possible to do that via integer overflow in the
> macro, though I find it unlikely unless someone passes in a yuuuge value.
> 
> Nevertheless, just shut up the warning by hardcoding the error number
> so I can move on to nastier bugs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libfrog/bulkstat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index c3e5c5f804e4..195f6ea053bd 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -428,7 +428,7 @@ xfrog_bulkstat_alloc_req(
>  
>  	breq = calloc(1, XFS_BULKSTAT_REQ_SIZE(nr));
>  	if (!breq)
> -		return -errno;
> +		return -ENOMEM;

Sure, why not!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
 
>  	breq->hdr.icount = nr;
>  	breq->hdr.ino = startino;
> 
