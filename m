Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3729EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 21:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93C722242
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 21:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgJHVxN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 17:53:13 -0400
Received: from sandeen.net ([63.231.237.45]:52116 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJHVxN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Oct 2020 17:53:13 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 03FD214427;
        Thu,  8 Oct 2020 16:52:10 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20201008035834.GB6535@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] libhandle: fix potential unterminated string problem
Message-ID: <a75ac669-164f-23fe-6293-13c183960f84@sandeen.net>
Date:   Thu, 8 Oct 2020 16:53:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201008035834.GB6535@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/7/20 10:58 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> gcc 10.2 complains about the strncpy call here, since it's possible that
> the source string is so long that the fspath inside the fdhash structure
> will end up without a null terminator.  Work around strncpy braindamage
> yet again by forcing the string to be terminated properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> Unless this is supposed to be a memcpy?  But it doesn't look like it.

so FWIW, coverity has complained about this one forever, CID 1297520

I think the thing that kept me from addressing it before was uncertainty
around lopping one byte off of PATH_MAX / MAXPATHLEN, essentially.

In reality, I think (?) PATH_MAX is a bit of a fiction anyway, and
there's probably nothing special about that one byte, and I think (?)
this is always a path to a mountpoint (?) which is unlikely to be 4096
or 4095 chars long anyway (?) so ... um ... sure.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libhandle/handle.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index eb099f43791e..5c1686b3968d 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -107,7 +107,8 @@ path_to_fshandle(
>  		}
>  
>  		fdhp->fsfd = fd;
> -		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath));
> +		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath) - 1);
> +		fdhp->fspath[sizeof(fdhp->fspath) - 1] = 0;
>  		memcpy(fdhp->fsh, *fshanp, FSIDSIZE);
>  
>  		fdhp->fnxt = fdhash_head;
> 
