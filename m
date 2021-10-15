Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C8CC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 20:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28CA610E5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 20:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhJOUbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:31:32 -0400
Received: from sandeen.net ([63.231.237.45]:50012 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238545AbhJOUbb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Oct 2021 16:31:31 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2FF3A4900;
        Fri, 15 Oct 2021 15:28:19 -0500 (CDT)
Message-ID: <abf2094c-588e-8306-85ab-9cd4ca12735f@sandeen.net>
Date:   Fri, 15 Oct 2021 15:29:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20211005223252.GF24307@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] libxfs: fix crash on second attempt to initialize library
In-Reply-To: <20211005223252.GF24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/5/21 5:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_repair crashes when it tries to initialize the libxfs library but
> the initialization fails because the fs is already mounted:

Sorry for missing this; looks right to me. For some reason I did not hit
it in testing, old library version I guess.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> # xfs_repair /dev/sdd
> xfs_repair: /dev/sdd contains a mounted filesystem
> xfs_repair: urcu.c:553: urcu_memb_register_thread: Assertion `!URCU_TLS(rcu_reader).registered' failed.
> Aborted
> 
> This is because libxfs_init() registers the main thread with liburcu,
> but doesn't unregister the thread if libxfs library initialization
> fails.  When repair sets more dangerous options and tries again, the
> second initialization attempt causes liburcu to abort.  Fix this by
> unregistering the thread with liburcu if libxfs initialization fails.
> 
> Observed by running xfs/284.
> 
> Fixes: e4da1b16 ("xfsprogs: introduce liburcu support")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   libxfs/init.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index d0753ce5..14911596 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -407,8 +407,10 @@ libxfs_init(libxfs_init_t *a)
>   		unlink(rtpath);
>   	if (fd >= 0)
>   		close(fd);
> -	if (!rval)
> +	if (!rval) {
>   		libxfs_close_devices(a);
> +		rcu_unregister_thread();
> +	}
>   
>   	return rval;
>   }
> 
