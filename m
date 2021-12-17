Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB8EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 21:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhLQVFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 16:05:40 -0500
Received: from sandeen.net ([63.231.237.45]:35992 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhLQVFk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Dec 2021 16:05:40 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 55A014905;
        Fri, 17 Dec 2021 15:05:15 -0600 (CST)
Message-ID: <86a01a07-630a-6bc3-749d-678037221b1d@sandeen.net>
Date:   Fri, 17 Dec 2021 15:05:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20211217203900.GQ27664@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: mkfs: document sample configuration file location
In-Reply-To: <20211217203900.GQ27664@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/17/21 2:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the documentation to note where one can find sample configuration
> files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   man/man8/mkfs.xfs.8 |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4d292dbe..7984f818 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -159,6 +159,7 @@ The configuration options will be sourced from the file specified by the
>   option string.
>   This option can be use either an absolute or relative path to the configuration
>   file to be read.
> +Sample configuration files can be found in /usr/share/xfsprogs/mkfs/.

That path is actually configure-time configurable, right, so ... sorry
for being a PITA but I'm not sure we should cite a definitive location
like that in the manpage ..?

>   .RE
>   .PP
>   .PD 0
> 
