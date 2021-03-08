Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CAEC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 20:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16999651D3
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 20:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCHU4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:56:19 -0500
Received: from sandeen.net ([63.231.237.45]:50810 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhCHU4P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 15:56:15 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 20A0714A23;
        Mon,  8 Mar 2021 14:55:47 -0600 (CST)
To:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
References: <20210302134554.112408-1-preichl@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: document attr2, ikeep option deprecation in
 xfs.5
Message-ID: <d4beee23-a9c0-a23f-c257-dd46758dfb97@sandeen.net>
Date:   Mon, 8 Mar 2021 14:56:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302134554.112408-1-preichl@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/2/21 7:45 AM, Pavel Reichl wrote:
> Since kernel v5.10, the (no)attr2 and (no)ikeep mount options are deprecated:
> 
> c23c393eaab5d xfs: remove deprecated mount options
> 
> Document this fact in the xfs(5) manpage.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man5/xfs.5 | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 7642662f..b657f0e4 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -118,6 +118,12 @@ to the file. Specifying a fixed allocsize value turns off
>  the dynamic behavior.
>  .TP
>  .BR attr2 | noattr2
> +Note: These options have been
> +.B deprecated
> +as of kernel v5.10; The noattr2 option will be removed no
> +earlier than in September 2025 and attr2 option will be immutable
> +default.
> +.sp
>  The options enable/disable an "opportunistic" improvement to
>  be made in the way inline extended attributes are stored
>  on-disk.  When the new form is used for the first time when
> @@ -159,6 +165,13 @@ across the entire filesystem rather than just on directories
>  configured to use it.
>  .TP
>  .BR ikeep | noikeep
> +Note: These options have been
> +.B deprecated
> +as of kernel v5.10; The noikeep option will be removed no
> +earlier than in September 2025 and ikeep option will be
> +immutable default.
> +
> +.sp
>  When ikeep is specified, XFS does not delete empty inode
>  clusters and keeps them around on disk.  When noikeep is
>  specified, empty inode clusters are returned to the free
> 
